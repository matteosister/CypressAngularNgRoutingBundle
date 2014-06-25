<?php

/*
 * This file is part of the FOSJsRoutingBundle package.
 *
 * (c) FriendsOfSymfony <http://friendsofsymfony.github.com/>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Cypress\AngularNgRoutingBundle\Command;

use FOS\JsRoutingBundle\Response\RoutesResponse;
use FOS\JsRoutingBundle\Command\DumpCommand as FOSDumpCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Dumps routes to the filesystem.
 *
 * @author Benjamin Dulau <benjamin.dulau@anonymation.com>
 */
class DumpCommand extends FOSDumpCommand
{
    private $targetPath;

    protected function configure()
    {
        $this
            ->setName('cypress:ng-routing:dump')
            ->setDescription('Dumps exposed routes to the filesystem')
            ->addOption(
                'callback',
                null,
                InputOption::VALUE_REQUIRED,
                'Callback function to pass the routes as an argument.',
                'cypress.NgRouter.setData'
            )
            ->addOption(
                'target',
                null,
                InputOption::VALUE_OPTIONAL,
                'Override the target directory to dump routes in.'
            )
            ->addOption(
                'locale',
                null,
                InputOption::VALUE_OPTIONAL,
                'Set locale to be used with JMSI18nRoutingBundle.',
                ''
            )
        ;
    }

    protected function initialize(InputInterface $input, OutputInterface $output)
    {
        parent::initialize($input, $output);

        $this->targetPath = $input->getOption('target') ?:
            sprintf('%s/../web/js/fos_ng_routes.js', $this->getContainer()->getParameter('kernel.root_dir'));
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $output->writeln('Dumping exposed routes.');
        $output->writeln('');

        $this->doDump($input, $output);
    }

    /**
     * Performs the routes dump.
     *
     * @param InputInterface  $input  The command input
     * @param OutputInterface $output The command output
     */
    private function doDump(InputInterface $input, OutputInterface $output)
    {
        if (!is_dir($dir = dirname($this->targetPath))) {
            $output->writeln('<info>[dir+]</info>  ' . $dir);
            if (false === @mkdir($dir, 0777, true)) {
                throw new \RuntimeException('Unable to create directory ' . $dir);
            }
        }

        $output->writeln('<info>[file+]</info> ' . $this->targetPath);

        $baseUrl = $this->getContainer()->hasParameter('fos_js_routing.request_context_base_url') ?
            $this->getContainer()->getParameter('fos_js_routing.request_context_base_url') :
            $this->getExposedRoutesExtractor()->getBaseUrl()
        ;

        $content = $this->getSerializer()->serialize(
            new RoutesResponse(
                $baseUrl,
                $this->getExposedRoutesExtractor()->getRoutes(),
                $input->getOption('locale'),
                $this->getExposedRoutesExtractor()->getHost(),
                $this->getExposedRoutesExtractor()->getScheme()
            ),
            'json'
        );

        $content = sprintf("%s(%s);", $input->getOption('callback'), $content);

        if (false === @file_put_contents($this->targetPath, $content)) {
            throw new \RuntimeException('Unable to write file ' . $this->targetPath);
        }
    }
}

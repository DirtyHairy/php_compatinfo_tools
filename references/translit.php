<?php

# Copyright (c) 2014 Christian Speckner <cnspeckn@googlemail.com>

class PHP_CompatInfo_Reference_Translit
    extends PHP_CompatInfo_Reference_PluginsAbstract
{
    /**
     * Extension/Reference name
     */
    const REF_NAME    = 'translit';

    /**
     * Latest version of Extension/Reference supported
     */
    const REF_VERSION = '0.6.1';

    /**
     * Gets informations about extensions
     *
     * @param string $extension (optional) NULL for PHP version,
     *                          TRUE if extension version
     * @param string $version   (optional) php or extension version
     * @param string $condition (optional) particular relationship with $version
     *                          Same operator values as used by version_compare
     *
     * @return array
     */
    public function getExtensions($extension = null, $version = null, $condition = null)
    {
        $phpMin = '5.1.0';
        $extensions = array(
            self::REF_NAME => array($phpMin, '', self::REF_VERSION)
        );
        return $extensions;
    }

    /**
     * Gets informations about functions
     *
     * @param string $extension (optional) NULL for PHP version,
     *                          TRUE if extension version
     * @param string $version   (optional) php or extension version
     * @param string $condition (optional) particular relationship with $version
     *                          Same operator values as used by version_compare
     *
     * @return array
     * @link   http://www.php.net/manual/en/ref.bzip2.php
     */
    public function getFunctions($extension = null, $version = null, $condition = null)
    {
        $this->setFilter(func_get_args());

        $functions = array();

        $release = '5.1.0';       // 2000-12-19 (stable)
        $items = array(
            'transliterate'           => array('5.1.0', ''),
            'transliterate_filters_get' => array('5.1.0', ''),
        );
        $this->applyFilter($release, $items, $functions);

        return $functions;
    }
}

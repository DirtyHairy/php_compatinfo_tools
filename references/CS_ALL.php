<?php

# Copyright (c) 2014 Christian Speckner <cnspeckn@googlemail.com>

class PHP_CompatInfo_Reference_CS_ALL
    extends PHP_CompatInfo_Reference_ALL
{
    /**
     * Constructor.
     *
     * @param array $extensions OPTIONAL List of extensions to look for
     *                          (default: all supported by current platform)
     */
    public function __construct($extensions = null)
    {
        if (!isset($extensions)) {
            $extensions = parent::getDatabaseExtensions();
            $extensions[] = 'translit';
        }
        parent::__construct($extensions);
    }
}

<?php
    $oddrow = true;
    $preLen = strlen(CbIOHelper::getCommonPathPrefix(array_keys($fileList)));

    // Find out which types of errors have been found
    $occuringErrorTypes = array (
        'CPD'        => false,
        'CRAP'       => false,
        'Checkstyle' => false,
        'Coverage'   => false,
        'PMD'        => false,
        'Padawan'    => false
    );

    foreach ($fileList as $file) foreach ($file->getIssues() as $issue) {
        $occuringErrorTypes[$issue->foundBy] = true;
    }

    $occuringErrorTypes = array_keys(array_filter($occuringErrorTypes));
?>

<!doctype html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link rel="stylesheet" type="text/css" href="js/jquery.sidebar/css/codebrowser/sidebar.css" />
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
        <link rel="stylesheet" type="text/css" href="css/cruisecontrol.css" />
        <link rel="stylesheet" type="text/css" href="css/global.css" />
        <link rel="stylesheet" type="text/css" href="css/review.css" />
        <link rel="stylesheet" type="text/css" href="css/tree.css" />

        <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.jstree/jquery.jstree.min.js"></script>
        <script type="text/javascript" src="js/jquery.sidebar/jquery-ui-1.7.2.custom.min.js"></script>
        <script type="text/javascript" src="js/jquery.sidebar/jquery.sidebar.js"></script>
        <script type="text/javascript" src="js/jquery.cluetip/lib/jquery.hoverIntent.js"></script>
        <script type="text/javascript" src="js/jquery.cluetip/lib/jquery.bgiframe.min.js"></script>
        <script type="text/javascript" src="js/jquery.cluetip/jquery.cluetip.min.js"></script>
        <script type="text/javascript" src="js/jquery.history.js"></script>

        <script type="text/javascript" src="js/review.js"></script>
        <script type="text/javascript" src="js/tree.js"></script>

        <title>PHP CodeBrowser</title>
    </head>
    <body class="codebrowser">
        <div class="container">
            <h1>PHP CodeBrowser</h1>

            <div id="treeContainer">
                <div id="tree">
                    <div id="treeHeader">
                        <a href="index.html" class='fileLink'>CodeBrowser</a>
                    </div>
                    <?= $treeList; ?>
                </div>
                <div id="treeToggle" style="background-image: url('img/treeToggle-extended.png');"></div>
            </div>

            <div id="contentBox" style="margin: 15px;">
                <div id="fileList">
                    <table class="table table-striped">
                        <tr class="head">
                            <th><strong>File</strong></th>
                            <th align="center"><strong>Errors</strong></th>
                            <th align="center"><strong>Warnings</strong></th>
                            <?php foreach ($occuringErrorTypes as $errorType): ?>
                                <th align="center"><strong><?= $errorType ?></strong></th>
                            <?php endforeach ?>
                        </tr>

                        <?php // Print the file table
                        foreach ($fileList as $filename => $f):
                            $shortName = substr($filename, $preLen);
                            $shortName = str_replace('\\', '/', $shortName);
                            $errors = $f->getErrorCount();
                            $warnings = $f->getWarningCount();

                            $counts = array_fill_keys($occuringErrorTypes, '');

                            foreach ($f->getIssues() as $issue) {
                                $counts[$issue->foundBy] += 1;
                            }
                            ?>

                            <tr>
                                <td><a class="fileLink" href="./$shortName.html"><?= $shortName ?></a></td>
                                <td align="center"><span class="errorCount"><?= $errors ?></span></td>
                                <td align="center">
                                    <span class="warningCount"><?= $warnings ?></span>
                                </td>
                                <?php foreach ($counts as $count): ?>
                                    <td align="center"><?= $count ?></td>
                                <?php endforeach ?>
                            </tr>
                        <? endforeach ?>
                    </table>
                </div>
            </div>

        </div>
    </body>
</html>

Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67E6C11F68
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:30:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A75461420
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A75461420
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10A4B4A4BE;
	Fri,  2 Jul 2021 12:30:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D8R1hNJj8RBv; Fri,  2 Jul 2021 12:30:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80C014B0B1;
	Fri,  2 Jul 2021 12:30:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D73AA4A195
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:30:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ch+y9ww1Se-h for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 12:30:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEDD64A198
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:30:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37C101424;
 Fri,  2 Jul 2021 09:30:42 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA9953F5A1;
 Fri,  2 Jul 2021 09:30:39 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
 lvivier@redhat.com, kvm-ppc@vger.kernel.org, david@redhat.com,
 frankja@linux.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH 4/5] scripts: Generate kvmtool standalone
 tests
Date: Fri,  2 Jul 2021 17:31:21 +0100
Message-Id: <20210702163122.96110-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210702163122.96110-1-alexandru.elisei@arm.com>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: vivek.gautam@arm.com, andre.przywara@arm.com, maz@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add support for the standalone target when running kvm-unit-tests under
kvmtool.

Example command line invocation:

$ ./configure --target=kvmtool
$ make clean && make standalone

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/mkstandalone.sh | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 16f461c06842..d84bdb7e278c 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -44,6 +44,10 @@ generate_test ()
 	config_export ARCH_NAME
 	config_export PROCESSOR
 
+	if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "arm" ]; then
+		config_export TARGET
+	fi
+
 	echo "echo BUILD_HEAD=$(cat build-head)"
 
 	if [ ! -f $kernel ]; then
@@ -59,7 +63,7 @@ generate_test ()
 		echo 'export FIRMWARE'
 	fi
 
-	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
+	if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
 		temp_file ERRATATXT "$ERRATATXT"
 		echo 'export ERRATATXT'
 	fi
@@ -95,12 +99,8 @@ function mkstandalone()
 	echo Written $standalone.
 }
 
-if [ "$TARGET" = "kvmtool" ]; then
-	echo "Standalone tests not supported with kvmtool"
-	exit 2
-fi
-
-if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
+if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && \
+		[ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
 	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
 	exit 2
 fi
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

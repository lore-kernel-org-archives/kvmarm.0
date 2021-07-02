Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720BEC11F68
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:30:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 13C4E6141D
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13C4E6141D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F9240CF8;
	Fri,  2 Jul 2021 12:30:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VU4MsVaW5ML0; Fri,  2 Jul 2021 12:30:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A49294A588;
	Fri,  2 Jul 2021 12:30:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B17764A198
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:30:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n0x3nlBy096g for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 12:30:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B7BF4B08B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:30:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDA23143B;
 Fri,  2 Jul 2021 09:30:44 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 75C643F5A1;
 Fri,  2 Jul 2021 09:30:42 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
 lvivier@redhat.com, kvm-ppc@vger.kernel.org, david@redhat.com,
 frankja@linux.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH 5/5] configure: Ignore --erratatxt when
 --target=kvmtool
Date: Fri,  2 Jul 2021 17:31:22 +0100
Message-Id: <20210702163122.96110-6-alexandru.elisei@arm.com>
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

kvmtool runs a test using the -f/--firmware argument, which doesn't load an
initrd, making specifying an errata file useless. Instead, configure forces
all erratas to be enabled via the CONFIG_ERRATA_FORCE define in
lib/config.h.

Forbid the --erratatxt option when kvm-unit-tests is configured for kvmtool
and let the user know that all erratas are enabled by default.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
I'm not sure if printing an error is too strong here and a simple warning would
suffice. Suggestions welcome!

 configure | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/configure b/configure
index 395c809c9c02..acd288239f80 100755
--- a/configure
+++ b/configure
@@ -24,7 +24,8 @@ u32_long=
 wa_divide=
 target=
 errata_force=0
-erratatxt="$srcdir/errata.txt"
+erratatxt_default="$srcdir/errata.txt"
+erratatxt="_NO_FILE_4Uhere_"
 host_key_document=
 page_size=
 earlycon=
@@ -50,7 +51,8 @@ usage() {
 	                           enable or disable the generation of a default environ when
 	                           no environ is provided by the user (enabled by default)
 	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
-	                           '--erratatxt=' to ensure no file is used.
+	                           '--erratatxt=' to ensure no file is used. This option is
+	                           invalid for arm/arm64 when target=kvmtool.
 	    --host-key-document=HOST_KEY_DOCUMENT
 	                           Specify the machine-specific host-key document for creating
 	                           a PVM image with 'genprotimg' (s390x only)
@@ -147,11 +149,6 @@ if [ -n "$host_key_document" ] && [ ! -f "$host_key_document" ]; then
     exit 1
 fi
 
-if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
-    echo "erratatxt: $erratatxt does not exist or is not a regular file"
-    exit 1
-fi
-
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
@@ -184,6 +181,21 @@ else
     fi
 fi
 
+if [ "$target" = "kvmtool" ]; then
+    if [ "$erratatxt" ] && [ "$erratatxt" != "_NO_FILE_4Uhere_" ]; then
+        echo "--erratatxt is not supported for target=kvmtool (all erratas enabled by default)"
+        usage
+    fi
+else
+    if [ "$erratatxt" = "_NO_FILE_4Uhere_" ]; then
+        erratatxt=$erratatxt_default
+    fi
+    if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
+        echo "erratatxt: $erratatxt does not exist or is not a regular file"
+        exit 1
+    fi
+fi
+
 [ -z "$processor" ] && processor="$arch"
 
 if [ "$processor" = "arm64" ]; then
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

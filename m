Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500AEC11F68
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:30:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D69E36142B
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:30:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D69E36142B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 839684A195;
	Fri,  2 Jul 2021 12:30:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gQijH-Unh26a; Fri,  2 Jul 2021 12:30:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08BED4B091;
	Fri,  2 Jul 2021 12:30:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA5F04A195
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:30:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qBtqkQhdB0nZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 12:30:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2BA940895
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:30:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75F261063;
 Fri,  2 Jul 2021 09:30:34 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C464B3F5A1;
 Fri,  2 Jul 2021 09:30:31 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
 lvivier@redhat.com, kvm-ppc@vger.kernel.org, david@redhat.com,
 frankja@linux.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status on
 exit if chr-testdev is not available
Date: Fri,  2 Jul 2021 17:31:18 +0100
Message-Id: <20210702163122.96110-2-alexandru.elisei@arm.com>
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

The arm64 tests can be run under kvmtool, which doesn't emulate a
chr-testdev device. In preparation for adding run script support for
kvmtool, print the test exit status so the scripts can pick it up and
correctly mark the test as pass or fail.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/chr-testdev.h |  1 +
 lib/arm/io.c      | 10 +++++++++-
 lib/chr-testdev.c |  5 +++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
index ffd9a851aa9b..09b4b424670e 100644
--- a/lib/chr-testdev.h
+++ b/lib/chr-testdev.h
@@ -11,4 +11,5 @@
  */
 extern void chr_testdev_init(void);
 extern void chr_testdev_exit(int code);
+extern bool chr_testdev_available(void);
 #endif
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 343e10822263..9e62b571a91b 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -125,7 +125,15 @@ extern void halt(int code);
 
 void exit(int code)
 {
-	chr_testdev_exit(code);
+	if (chr_testdev_available()) {
+		chr_testdev_exit(code);
+	} else {
+		/*
+		 * Print the test return code in the format used by chr-testdev
+		 * so the runner script can parse it.
+		 */
+		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
+	}
 	psci_system_off();
 	halt(code);
 	__builtin_unreachable();
diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
index b3c641a833fe..301e73a6c064 100644
--- a/lib/chr-testdev.c
+++ b/lib/chr-testdev.c
@@ -68,3 +68,8 @@ void chr_testdev_init(void)
 	in_vq = vqs[0];
 	out_vq = vqs[1];
 }
+
+bool chr_testdev_available(void)
+{
+	return vcon != NULL;
+}
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

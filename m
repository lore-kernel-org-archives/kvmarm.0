Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9C4C10F13
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 15:11:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 413B121473
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 15:11:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 413B121473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F7E74A3B3;
	Mon,  8 Apr 2019 11:11:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6lGjRYDVO8hA; Mon,  8 Apr 2019 11:11:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8B84A445;
	Mon,  8 Apr 2019 11:11:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 649644A426
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 11:11:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q10ZgDEqrD5F for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 11:11:40 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CE664A3B3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 11:11:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B6FA15AB;
 Mon,  8 Apr 2019 08:11:39 -0700 (PDT)
Received: from bc-c3-2-16.euhpc.arm.com (bc-c3-2-16.euhpc.arm.com [10.6.5.120])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 866843F557;
 Mon,  8 Apr 2019 08:11:38 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] lib: arm: Use correct halt() prototype from
 smp.h
Date: Mon,  8 Apr 2019 16:11:25 +0100
Message-Id: <20190408151125.32080-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.17.0
Cc: kvmarm@lists.cs.columbia.edu
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
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408151125.BLIurpbKbmUPBn8K42Mr5YJmbjl8xy0lW-SxDXePmWA@z>

The prototype for the halt() function is incorrect, because halt() doesn't
take any arguments. Fix it by using the prototype from smp.h.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index 8226b765bdc5..6d3d7afed002 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -15,11 +15,10 @@
 #include <asm/psci.h>
 #include <asm/spinlock.h>
 #include <asm/io.h>
+#include <asm/smp.h>
 
 #include "io.h"
 
-extern void halt(int code);
-
 static struct spinlock uart_lock;
 /*
  * Use this guess for the uart base in order to make an attempt at
@@ -93,6 +92,6 @@ void exit(int code)
 {
 	chr_testdev_exit(code);
 	psci_system_off();
-	halt(code);
+	halt();
 	__builtin_unreachable();
 }
-- 
2.17.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

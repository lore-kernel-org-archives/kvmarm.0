Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64852C433E3
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 15:06:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EDDC761984
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 15:06:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDDC761984
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91DCB4B39A;
	Mon, 22 Mar 2021 11:06:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q2Z+64MSFt1r; Mon, 22 Mar 2021 11:06:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49CDC4B41D;
	Mon, 22 Mar 2021 11:06:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB774B3F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 11:06:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X6+G-XvGhlEX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 11:06:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F095B4B232
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 11:06:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 753511042;
 Mon, 22 Mar 2021 08:06:24 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B34C43F719;
 Mon, 22 Mar 2021 08:06:23 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 5/6] arm64: Configure SCTLR_EL1 at boot
Date: Mon, 22 Mar 2021 15:06:40 +0000
Message-Id: <20210322150641.58878-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322150641.58878-1-alexandru.elisei@arm.com>
References: <20210322150641.58878-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: andre.przywara@arm.com
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

Some fields in SCTLR_EL1 are UNKNOWN at reset and the arm64 boot
requirements, as stated by Linux in Documentation/arm64/booting.rst, do not
specify a particular value for all the fields. Do not rely on the good will
of the hypervisor and userspace to set SCTLR_EL1 to a sane value (by their
definition of sane) and set SCTLR_EL1 explicitely before running setup().
This will ensure that all tests are performed with the hardware set up
identically, regardless of the KVM or VMM versions.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/sysreg.h | 7 +++++++
 arm/cstart64.S         | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 9d6b4fc66936..18c4ed39557a 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -8,6 +8,8 @@
 #ifndef _ASMARM64_SYSREG_H_
 #define _ASMARM64_SYSREG_H_
 
+#include <linux/const.h>
+
 #define sys_reg(op0, op1, crn, crm, op2) \
 	((((op0)&3)<<19)|((op1)<<16)|((crn)<<12)|((crm)<<8)|((op2)<<5))
 
@@ -87,4 +89,9 @@ asm(
 #define SCTLR_EL1_A	(1 << 1)
 #define SCTLR_EL1_M	(1 << 0)
 
+#define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
+			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
+#define INIT_SCTLR_EL1_MMU_OFF	\
+			SCTLR_EL1_RES1
+
 #endif /* _ASMARM64_SYSREG_H_ */
diff --git a/arm/cstart64.S b/arm/cstart64.S
index f6c5d2ebccf3..42a838ff4c38 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -52,6 +52,11 @@ start:
 	b	1b
 
 1:
+	/* set SCTLR_EL1 to a known value */
+	ldr	x4, =INIT_SCTLR_EL1_MMU_OFF
+	msr	sctlr_el1, x4
+	isb
+
 	/* set up stack */
 	mov	x4, #1
 	msr	spsel, x4
-- 
2.31.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

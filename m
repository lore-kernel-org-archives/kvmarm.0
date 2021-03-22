Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704B5C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 15:06:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 04AE26198D
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 15:06:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04AE26198D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A30334B3CE;
	Mon, 22 Mar 2021 11:06:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MDdxexy3d9E9; Mon, 22 Mar 2021 11:06:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22DAF4B40D;
	Mon, 22 Mar 2021 11:06:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B80C4B383
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 11:06:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a5U+oEjdzQwX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 11:06:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC93B4B3E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 11:06:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DC82139F;
 Mon, 22 Mar 2021 08:06:23 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE1623F719;
 Mon, 22 Mar 2021 08:06:22 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 4/6] lib: arm64: Consolidate register
 definitions to sysreg.h
Date: Mon, 22 Mar 2021 15:06:39 +0000
Message-Id: <20210322150641.58878-5-alexandru.elisei@arm.com>
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

Move system register field definitions to sysreg.h, where the opcodes for
system register access are defined, to align ourselves with the Linux
kernel. EL2 support, needed for EFI and nested virtualization testing, will
require additional register and field definions, and having them in the
same place as Linux will make maintenance easier.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/arch_gicv3.h |  6 ------
 lib/arm64/asm/processor.h  | 10 ----------
 lib/arm64/asm/sysreg.h     | 17 +++++++++++++++++
 arm/cstart64.S             |  2 +-
 4 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
index a7994ec2fbbe..fdee4de1f1f6 100644
--- a/lib/arm64/asm/arch_gicv3.h
+++ b/lib/arm64/asm/arch_gicv3.h
@@ -10,12 +10,6 @@
 
 #include <asm/sysreg.h>
 
-#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
-#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
-#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
-#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
-#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
-
 #ifndef __ASSEMBLY__
 
 #include <libcflat.h>
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index cdc2463e1981..4a3d826ab560 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -6,16 +6,6 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 
-/* System Control Register (SCTLR_EL1) bits */
-#define SCTLR_EL1_EE	(1 << 25)
-#define SCTLR_EL1_WXN	(1 << 19)
-#define SCTLR_EL1_I	(1 << 12)
-#define SCTLR_EL1_SA0	(1 << 4)
-#define SCTLR_EL1_SA	(1 << 3)
-#define SCTLR_EL1_C	(1 << 2)
-#define SCTLR_EL1_A	(1 << 1)
-#define SCTLR_EL1_M	(1 << 0)
-
 #ifndef __ASSEMBLY__
 #include <asm/ptrace.h>
 #include <asm/esr.h>
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 378bf7ebb3b5..9d6b4fc66936 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -70,4 +70,21 @@ asm(
 "	.endm\n"
 );
 #endif /* __ASSEMBLY__ */
+
+#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
+#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
+#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
+#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
+#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
+
+/* System Control Register (SCTLR_EL1) bits */
+#define SCTLR_EL1_EE	(1 << 25)
+#define SCTLR_EL1_WXN	(1 << 19)
+#define SCTLR_EL1_I	(1 << 12)
+#define SCTLR_EL1_SA0	(1 << 4)
+#define SCTLR_EL1_SA	(1 << 3)
+#define SCTLR_EL1_C	(1 << 2)
+#define SCTLR_EL1_A	(1 << 1)
+#define SCTLR_EL1_M	(1 << 0)
+
 #endif /* _ASMARM64_SYSREG_H_ */
diff --git a/arm/cstart64.S b/arm/cstart64.S
index c1deff842f03..f6c5d2ebccf3 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -10,9 +10,9 @@
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
 #include <asm/ptrace.h>
-#include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
+#include <asm/sysreg.h>
 
 .section .init
 
-- 
2.31.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

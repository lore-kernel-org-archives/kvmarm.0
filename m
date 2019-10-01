Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56357ECE589
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:24:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1AAD9222C2
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:24:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AAD9222C2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67704A6FD;
	Tue,  1 Oct 2019 06:24:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z1XMOoLOrcpO; Tue,  1 Oct 2019 06:24:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 270B74A58C;
	Tue,  1 Oct 2019 06:23:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EEB84A6ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3BgdfedU0uWb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 06:23:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 718EA4A7DE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:57 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26F761570;
 Tue,  1 Oct 2019 03:23:57 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E1BC23F739;
 Tue,  1 Oct 2019 03:23:55 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 13/19] lib: Add _UL and _ULL definitions
 to linux/const.h
Date: Tue,  1 Oct 2019 11:23:17 +0100
Message-Id: <20191001102323.27628-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com
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

There is an UL macro defined in lib/arm64/asm/pgtable-hwdef.h.  Replace
it with the _UL macro and put it in lib/linux/const.h, where it can be
used in other files. To keep things consistent with Linux's
include/uapi/linux/const.h file, also add an _ULL macro.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Changes:
* Renamed UL->_UL and ULL->_ULL.
* Replaced some uses of _AC(x, UL) with _UL(x). Same for ULL.

 lib/linux/const.h             |  7 +++--
 lib/arm64/asm/pgtable-hwdef.h | 50 +++++++++++++++++------------------
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/lib/linux/const.h b/lib/linux/const.h
index c872bfd25e13..1453a886d041 100644
--- a/lib/linux/const.h
+++ b/lib/linux/const.h
@@ -21,7 +21,10 @@
 #define _AT(T,X)	((T)(X))
 #endif
 
-#define _BITUL(x)	(_AC(1,UL) << (x))
-#define _BITULL(x)	(_AC(1,ULL) << (x))
+#define _UL(x) 		_AC(x, UL)
+#define _ULL(x)		_AC(x, ULL)
+
+#define _BITUL(x)	(_UL(1) << (x))
+#define _BITULL(x)	(_ULL(1) << (x))
 
 #endif /* !(_LINUX_CONST_H) */
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 045a3ce12645..f183b48dec5d 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -9,8 +9,6 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
-#define UL(x) _AC(x, UL)
-
 #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
 
 /*
@@ -18,21 +16,21 @@
  * (depending on the configuration, this level can be 0, 1 or 2).
  */
 #define PGDIR_SHIFT		((PAGE_SHIFT - 3) * PGTABLE_LEVELS + 3)
-#define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
+#define PGDIR_SIZE		(_UL(1) << PGDIR_SHIFT)
 #define PGDIR_MASK		(~(PGDIR_SIZE-1))
 #define PTRS_PER_PGD		(1 << (VA_BITS - PGDIR_SHIFT))
 
 /* From include/asm-generic/pgtable-nopmd.h */
 #define PMD_SHIFT		PGDIR_SHIFT
 #define PTRS_PER_PMD		1
-#define PMD_SIZE		(UL(1) << PMD_SHIFT)
+#define PMD_SIZE		(_UL(1) << PMD_SHIFT)
 #define PMD_MASK		(~(PMD_SIZE-1))
 
 /*
  * Section address mask and size definitions.
  */
 #define SECTION_SHIFT		PMD_SHIFT
-#define SECTION_SIZE		(_AC(1, UL) << SECTION_SHIFT)
+#define SECTION_SIZE		(_UL(1) << SECTION_SHIFT)
 #define SECTION_MASK		(~(SECTION_SIZE-1))
 
 /*
@@ -90,31 +88,31 @@
  * Highest possible physical address supported.
  */
 #define PHYS_MASK_SHIFT		(48)
-#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
+#define PHYS_MASK		((_UL(1) << PHYS_MASK_SHIFT) - 1)
 
 /*
  * TCR flags.
  */
-#define TCR_TxSZ(x)		(((UL(64) - (x)) << 16) | ((UL(64) - (x)) << 0))
-#define TCR_IRGN_NC		((UL(0) << 8) | (UL(0) << 24))
-#define TCR_IRGN_WBWA		((UL(1) << 8) | (UL(1) << 24))
-#define TCR_IRGN_WT		((UL(2) << 8) | (UL(2) << 24))
-#define TCR_IRGN_WBnWA		((UL(3) << 8) | (UL(3) << 24))
-#define TCR_IRGN_MASK		((UL(3) << 8) | (UL(3) << 24))
-#define TCR_ORGN_NC		((UL(0) << 10) | (UL(0) << 26))
-#define TCR_ORGN_WBWA		((UL(1) << 10) | (UL(1) << 26))
-#define TCR_ORGN_WT		((UL(2) << 10) | (UL(2) << 26))
-#define TCR_ORGN_WBnWA		((UL(3) << 10) | (UL(3) << 26))
-#define TCR_ORGN_MASK		((UL(3) << 10) | (UL(3) << 26))
-#define TCR_SHARED		((UL(3) << 12) | (UL(3) << 28))
-#define TCR_TG0_4K		(UL(0) << 14)
-#define TCR_TG0_64K		(UL(1) << 14)
-#define TCR_TG0_16K		(UL(2) << 14)
-#define TCR_TG1_16K		(UL(1) << 30)
-#define TCR_TG1_4K		(UL(2) << 30)
-#define TCR_TG1_64K		(UL(3) << 30)
-#define TCR_ASID16		(UL(1) << 36)
-#define TCR_TBI0		(UL(1) << 37)
+#define TCR_TxSZ(x)		(((_UL(64) - (x)) << 16) | ((_UL(64) - (x)) << 0))
+#define TCR_IRGN_NC		((_UL(0) << 8) | (_UL(0) << 24))
+#define TCR_IRGN_WBWA		((_UL(1) << 8) | (_UL(1) << 24))
+#define TCR_IRGN_WT		((_UL(2) << 8) | (_UL(2) << 24))
+#define TCR_IRGN_WBnWA		((_UL(3) << 8) | (_UL(3) << 24))
+#define TCR_IRGN_MASK		((_UL(3) << 8) | (_UL(3) << 24))
+#define TCR_ORGN_NC		((_UL(0) << 10) | (_UL(0) << 26))
+#define TCR_ORGN_WBWA		((_UL(1) << 10) | (_UL(1) << 26))
+#define TCR_ORGN_WT		((_UL(2) << 10) | (_UL(2) << 26))
+#define TCR_ORGN_WBnWA		((_UL(3) << 10) | (_UL(3) << 26))
+#define TCR_ORGN_MASK		((_UL(3) << 10) | (_UL(3) << 26))
+#define TCR_SHARED		((_UL(3) << 12) | (_UL(3) << 28))
+#define TCR_TG0_4K		(_UL(0) << 14)
+#define TCR_TG0_64K		(_UL(1) << 14)
+#define TCR_TG0_16K		(_UL(2) << 14)
+#define TCR_TG1_16K		(_UL(1) << 30)
+#define TCR_TG1_4K		(_UL(2) << 30)
+#define TCR_TG1_64K		(_UL(3) << 30)
+#define TCR_ASID16		(_UL(1) << 36)
+#define TCR_TBI0		(_UL(1) << 37)
 
 /*
  * Memory types available.
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

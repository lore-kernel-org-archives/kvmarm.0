Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFBBC433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 15:06:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7212661984
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 15:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7212661984
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1609E4B423;
	Mon, 22 Mar 2021 11:06:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g8Rub9zZE5xu; Mon, 22 Mar 2021 11:06:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 658534B3E7;
	Mon, 22 Mar 2021 11:06:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 283064B3F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 11:06:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HViHKeyvTl9b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 11:06:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2DB24B2A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 11:06:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88DF913A1;
 Mon, 22 Mar 2021 08:06:25 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC5F23F7B4;
 Mon, 22 Mar 2021 08:06:24 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 6/6] arm64: Disable TTBR1_EL1 translation
 table walks
Date: Mon, 22 Mar 2021 15:06:41 +0000
Message-Id: <20210322150641.58878-7-alexandru.elisei@arm.com>
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

From an architectural point of view, the PE can speculate instruction
fetches and data reads at any time when the MMU is enabled using the
translation tables from TTBR0_EL1 and TTBR1_EL1. kvm-unit-tests uses an
identity map, and as such it only programs TTBR0_EL1 with a valid table and
leaves TTBR1_EL1 unchanged. The reset value for TTBR1_EL1 is UNKNOWN, which
means it is possible for the PE to perform reads from memory locations
where accesses can cause side effects (like memory-mapped devices) as part
of the speculated translation table walk.

So far, this hasn't been a problem, because KVM resets TTBR{0,1}_EL1 to
zero, and that address is used for emulation for both qemu and kvmtool and
it doesn't point to a real device. However, kvm-unit-tests shouldn't rely
on a particular combination of hypervisor and userspace for correctness.
Another situation where we can't rely on these assumptions being true is
when kvm-unit-tests is run as an EFI app.

To prevent reads from arbitrary addresses, set the TCR_EL1.EPD1 bit to
disable speculative translation table walks using TTBR1_EL1.

This is similar to EDK2 commit fafb7e9c110e ("ArmPkg: correct TTBR1_EL1
settings in TCR_EL1"). Also mentioned in that commit is the Cortex-A57
erratum 822227 which impacts the hypervisor, but kvm-unit-tests is
protected against it because asm_mmu_enable sets both the TCR_EL1.TG0 and
TCR_EL1.TG1 bits when programming the register.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/pgtable-hwdef.h | 1 +
 arm/cstart64.S                | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 48a1d1ab1ac2..8c41fe123fb3 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -136,6 +136,7 @@
 #define TCR_ORGN_WBnWA		((UL(3) << 10) | (UL(3) << 26))
 #define TCR_ORGN_MASK		((UL(3) << 10) | (UL(3) << 26))
 #define TCR_SHARED		((UL(3) << 12) | (UL(3) << 28))
+#define TCR_EPD1		(UL(1) << 23)
 #define TCR_TG0_4K		(UL(0) << 14)
 #define TCR_TG0_64K		(UL(1) << 14)
 #define TCR_TG0_16K		(UL(2) << 14)
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 42a838ff4c38..3d359c8387c9 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -181,7 +181,8 @@ asm_mmu_enable:
 	ldr	x1, =TCR_TxSZ(VA_BITS) |		\
 		     TCR_TG_FLAGS  |			\
 		     TCR_IRGN_WBWA | TCR_ORGN_WBWA |	\
-		     TCR_SHARED
+		     TCR_SHARED |			\
+		     TCR_EPD1
 	mrs	x2, id_aa64mmfr0_el1
 	bfi	x1, x2, #32, #3
 	msr	tcr_el1, x1
-- 
2.31.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

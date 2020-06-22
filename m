Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40550C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:34:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ECEE720708
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:34:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECEE720708
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5A634B092;
	Mon, 22 Jun 2020 07:34:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aT-hsXxSpdIj; Mon, 22 Jun 2020 07:34:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 476974B0DD;
	Mon, 22 Jun 2020 07:34:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77FAB4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:34:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SVfqcvd263t8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 07:34:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 631584B0FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:34:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EE6311B3;
 Mon, 22 Jun 2020 04:34:00 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E4213F71E;
 Mon, 22 Jun 2020 04:33:59 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/5] KVM: arm64: Remove the target table
Date: Mon, 22 Jun 2020 11:33:17 +0000
Message-Id: <20200622113317.20477-6-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200622113317.20477-1-james.morse@arm.com>
References: <20200622113317.20477-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>
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

Finally, remove the target table. Merge the code that checks the
tables into kvm_reset_sys_regs() as there is now only one table.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/kvm_coproc.h  |  7 ----
 arch/arm64/kvm/Makefile              |  2 +-
 arch/arm64/kvm/sys_regs.c            | 57 ++++++----------------------
 arch/arm64/kvm/sys_regs.h            |  2 -
 arch/arm64/kvm/sys_regs_generic_v8.c | 55 ---------------------------
 5 files changed, 12 insertions(+), 111 deletions(-)
 delete mode 100644 arch/arm64/kvm/sys_regs_generic_v8.c

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index 4bf0d6d05e0f..147f3a77e6a5 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -19,13 +19,6 @@ struct kvm_sys_reg_table {
 	size_t num;
 };
 
-struct kvm_sys_reg_target_table {
-	struct kvm_sys_reg_table table64;
-	struct kvm_sys_reg_table table32;
-};
-
-void kvm_check_target_sys_reg_table(struct kvm_sys_reg_target_table *table);
-
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 8d3d9513cbfe..48cda50aa225 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o \
 	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
 	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
-	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
+	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 aarch32.o arch_timer.o \
 	 vgic/vgic.o vgic/vgic-init.o \
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 14333005b476..41a4d3d2a312 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2137,28 +2137,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 	return 0;
 }
 
-void kvm_check_target_sys_reg_table(struct kvm_sys_reg_target_table *table)
-{
-	BUG_ON(check_sysreg_table(table->table64.table, table->table64.num, false));
-	BUG_ON(check_sysreg_table(table->table32.table, table->table32.num, true));
-}
-
-/* Get specific register table for this target. */
-static const struct sys_reg_desc *get_target_table(unsigned target,
-						   bool mode_is_64,
-						   size_t *num)
-{
-	struct kvm_sys_reg_target_table *table = &genericv8_target_table;
-
-	if (mode_is_64) {
-		*num = table->table64.num;
-		return table->table64.table;
-	} else {
-		*num = table->table32.num;
-		return table->table32.table;
-	}
-}
-
 static int match_sys_reg(const void *key, const void *elt)
 {
 	const unsigned long pval = (unsigned long)key;
@@ -2393,14 +2371,20 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
-				const struct sys_reg_desc *table, size_t num)
+/**
+ * kvm_reset_sys_regs - sets system registers to reset value
+ * @vcpu: The VCPU pointer
+ *
+ * This function finds the right table above and sets the registers on the
+ * virtual CPU struct to their architecturally defined reset values.
+ */
+void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 {
 	unsigned long i;
 
-	for (i = 0; i < num; i++)
-		if (table[i].reset)
-			table[i].reset(vcpu, &table[i]);
+	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++)
+		if (sys_reg_descs[i].reset)
+			sys_reg_descs[i].reset(vcpu, &sys_reg_descs[i]);
 }
 
 /**
@@ -2869,22 +2853,3 @@ void kvm_sys_reg_table_init(void)
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
 }
-
-/**
- * kvm_reset_sys_regs - sets system registers to reset value
- * @vcpu: The VCPU pointer
- *
- * This function finds the right table above and sets the registers on the
- * virtual CPU struct to their architecturally defined reset values.
- */
-void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
-{
-	size_t num;
-	const struct sys_reg_desc *table;
-
-	/* Generic chip reset first (so target could override). */
-	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
-
-	table = get_target_table(vcpu->arch.target, true, &num);
-	reset_sys_reg_descs(vcpu, table, num);
-}
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 933609e883bf..5a6fc30f5989 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -165,6 +165,4 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
-extern struct kvm_sys_reg_target_table genericv8_target_table;
-
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
deleted file mode 100644
index a7e21e61beea..000000000000
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ /dev/null
@@ -1,55 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2012,2013 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * Based on arch/arm/kvm/coproc_a15.c:
- * Copyright (C) 2012 - Virtual Open Systems and Columbia University
- * Authors: Rusty Russell <rusty@rustcorp.au>
- *          Christoffer Dall <c.dall@virtualopensystems.com>
- */
-#include <linux/kvm_host.h>
-#include <asm/cputype.h>
-#include <asm/kvm_arm.h>
-#include <asm/kvm_asm.h>
-#include <asm/kvm_emulate.h>
-#include <asm/kvm_coproc.h>
-#include <asm/sysreg.h>
-#include <linux/init.h>
-
-#include "sys_regs.h"
-
-/*
- * Implementation specific sys-reg registers.
- * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
- */
-static const struct sys_reg_desc genericv8_sys_regs[] = {
-};
-
-static const struct sys_reg_desc genericv8_cp15_regs[] = {
-};
-
-struct kvm_sys_reg_target_table genericv8_target_table = {
-	.table64 = {
-		.table = genericv8_sys_regs,
-		.num = ARRAY_SIZE(genericv8_sys_regs),
-	},
-	.table32 = {
-		.table = genericv8_cp15_regs,
-		.num = ARRAY_SIZE(genericv8_cp15_regs),
-	},
-};
-
-static int __init sys_reg_genericv8_init(void)
-{
-	unsigned int i;
-
-	for (i = 1; i < ARRAY_SIZE(genericv8_sys_regs); i++)
-		BUG_ON(cmp_sys_reg(&genericv8_sys_regs[i-1],
-			       &genericv8_sys_regs[i]) >= 0);
-
-	kvm_check_target_sys_reg_table(&genericv8_target_table);
-
-	return 0;
-}
-late_initcall(sys_reg_genericv8_init);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

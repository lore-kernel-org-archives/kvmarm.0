Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902D8C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:33:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42FA720732
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:33:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42FA720732
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E43804B0D8;
	Mon, 22 Jun 2020 07:33:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F3IOO-RhSy7C; Mon, 22 Jun 2020 07:33:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A00D14B0D9;
	Mon, 22 Jun 2020 07:33:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EC264B0D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:33:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZJaE4J+GgYYv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 07:33:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7C194B087
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:33:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 571A9C0A;
 Mon, 22 Jun 2020 04:33:46 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8826F3F71E;
 Mon, 22 Jun 2020 04:33:45 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/5] KVM: arm64: Drop the target_table[] indirection
Date: Mon, 22 Jun 2020 11:33:13 +0000
Message-Id: <20200622113317.20477-2-james.morse@arm.com>
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

KVM for 32bit arm had a get/set target mechanism to allow for
micro-architecture differences that are visible in system registers
to be described.

KVM's user-space can query the supported targets for a CPU, and
create vCPUs for that target. The target can override the handling
of system registers to provide different reset or RES0 behaviour.
On 32bit arm this was used to provide different ACTLR reset values
for A7 and A15.

On 64bit arm, the first few CPUs out of the gate used this mechanism,
before it was deemed redundant in commit bca556ac468a ("arm64/kvm:
Add generic v8 KVM target"). All future CPUs use the
KVM_ARM_TARGET_GENERIC_V8 target.

The 64bit target_table[] stuff exists to preserve the ABI to
user-space. As all targets registers genericv8_target_table, there
is no reason to look the target up.

Until we can merge genericv8_target_table with the main sys_regs
array, kvm_register_target_sys_reg_table() becomes
kvm_check_target_sys_reg_table(), which uses BUG_ON() in keeping
with the other callers in this file.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/kvm_coproc.h  |  3 +--
 arch/arm64/kvm/sys_regs.c            | 16 ++++------------
 arch/arm64/kvm/sys_regs.h            |  2 ++
 arch/arm64/kvm/sys_regs_generic_v8.c | 15 ++-------------
 4 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index 0185ee8b8b5e..4bf0d6d05e0f 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -24,8 +24,7 @@ struct kvm_sys_reg_target_table {
 	struct kvm_sys_reg_table table32;
 };
 
-void kvm_register_target_sys_reg_table(unsigned int target,
-				       struct kvm_sys_reg_target_table *table);
+void kvm_check_target_sys_reg_table(struct kvm_sys_reg_target_table *table);
 
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index baf5ce9225ce..6333a7cd92d3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2109,17 +2109,10 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 	return 0;
 }
 
-/* Target specific emulation tables */
-static struct kvm_sys_reg_target_table *target_tables[KVM_ARM_NUM_TARGETS];
-
-void kvm_register_target_sys_reg_table(unsigned int target,
-				       struct kvm_sys_reg_target_table *table)
+void kvm_check_target_sys_reg_table(struct kvm_sys_reg_target_table *table)
 {
-	if (check_sysreg_table(table->table64.table, table->table64.num, false) ||
-	    check_sysreg_table(table->table32.table, table->table32.num, true))
-		return;
-
-	target_tables[target] = table;
+	BUG_ON(check_sysreg_table(table->table64.table, table->table64.num, false));
+	BUG_ON(check_sysreg_table(table->table32.table, table->table32.num, true));
 }
 
 /* Get specific register table for this target. */
@@ -2127,9 +2120,8 @@ static const struct sys_reg_desc *get_target_table(unsigned target,
 						   bool mode_is_64,
 						   size_t *num)
 {
-	struct kvm_sys_reg_target_table *table;
+	struct kvm_sys_reg_target_table *table = &genericv8_target_table;
 
-	table = target_tables[target];
 	if (mode_is_64) {
 		*num = table->table64.num;
 		return table->table64.table;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 5a6fc30f5989..933609e883bf 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -165,4 +165,6 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
+extern struct kvm_sys_reg_target_table genericv8_target_table;
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index aa9d356451eb..a82cc2ccfd44 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -59,7 +59,7 @@ static const struct sys_reg_desc genericv8_cp15_regs[] = {
 	  access_actlr },
 };
 
-static struct kvm_sys_reg_target_table genericv8_target_table = {
+struct kvm_sys_reg_target_table genericv8_target_table = {
 	.table64 = {
 		.table = genericv8_sys_regs,
 		.num = ARRAY_SIZE(genericv8_sys_regs),
@@ -78,18 +78,7 @@ static int __init sys_reg_genericv8_init(void)
 		BUG_ON(cmp_sys_reg(&genericv8_sys_regs[i-1],
 			       &genericv8_sys_regs[i]) >= 0);
 
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_AEM_V8,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_FOUNDATION_V8,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_CORTEX_A53,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_CORTEX_A57,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_XGENE_POTENZA,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_GENERIC_V8,
-					  &genericv8_target_table);
+	kvm_check_target_sys_reg_table(&genericv8_target_table);
 
 	return 0;
 }
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

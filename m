Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 580C1C433E1
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 17:57:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05F7522D08
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 17:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7uMxOjz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05F7522D08
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A97564B561;
	Wed,  5 Aug 2020 13:57:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CcaxD1AkRrqp; Wed,  5 Aug 2020 13:57:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A6934B61A;
	Wed,  5 Aug 2020 13:57:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8CAE4B578
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 13:57:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v-NnnrX4oBnU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 13:57:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A58C4B397
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 13:57:21 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 36E1722D04;
 Wed,  5 Aug 2020 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596650240;
 bh=7ArqvSK8VUGJgeX1OnhoTSQ+a7BydokvwxYLyhHIlMg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=G7uMxOjz8gkR3xFfhtpD82P2khC6WFYs2XifyJqv9j8pemgssW4y6+fB58SANSeRP
 JQ77MaMaQlXFEK+d4DGnHaObDprDOQn/gb6w67MsmTJ7sTtzuZcgRbP8v8yaA1xICu
 VgM7p/Ls/izszv+/8S5ybw8tmp00XBEVrDma7XzA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3NfC-0004w9-LP; Wed, 05 Aug 2020 18:57:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 08/56] KVM: arm64: Drop the target_table[] indirection
Date: Wed,  5 Aug 2020 18:56:12 +0100
Message-Id: <20200805175700.62775-9-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: James Morse <james.morse@arm.com>

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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200622113317.20477-2-james.morse@arm.com
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
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

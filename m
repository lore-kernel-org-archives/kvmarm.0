Return-Path: <SRS0=zTnl=WF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9D4C31E40
	for <kvmarm@archiver.kernel.org>; Fri,  9 Aug 2019 07:49:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54AF72171F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Aug 2019 07:49:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54AF72171F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D70E4A4F7;
	Fri,  9 Aug 2019 03:49:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8F-9fW6RliWj; Fri,  9 Aug 2019 03:49:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBEEA4A563;
	Fri,  9 Aug 2019 03:49:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEB4D4A575
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Aug 2019 03:49:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4k1w6b0GahIg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Aug 2019 03:49:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6F54A520
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Aug 2019 03:49:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A142B15BF;
 Fri,  9 Aug 2019 00:49:02 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 021853F706;
 Fri,  9 Aug 2019 00:49:00 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/4] KVM: arm64: Don't write junk to sysregs on reset
Date: Fri,  9 Aug 2019 08:48:30 +0100
Message-Id: <20190809074832.13283-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809074832.13283-1-maz@kernel.org>
References: <20190809074832.13283-1-maz@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

At the moment, the way we reset system registers is mildly insane:
We write junk to them, call the reset functions, and then check that
we have something else in them.

The "fun" thing is that this can happen while the guest is running
(PSCI, for example). If anything in KVM has to evaluate the state
of a system register while junk is in there, bad thing may happen.

Let's stop doing that. Instead, we track that we have called a
reset function for that register, and assume that the reset
function has done something. This requires fixing a couple of
sysreg refinition in the trap table.

In the end, the very need of this reset check is pretty dubious,
as it doesn't check everything (a lot of the sysregs leave outside of
the sys_regs[] array). It may well be axed in the near future.

Tested-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f26e181d881c..2071260a275b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -632,7 +632,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	 */
 	val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
@@ -981,13 +981,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
-	  trap_bvr, reset_bvr, n, 0, get_bvr, set_bvr },		\
+	  trap_bvr, reset_bvr, 0, 0, get_bvr, set_bvr },		\
 	{ SYS_DESC(SYS_DBGBCRn_EL1(n)),					\
-	  trap_bcr, reset_bcr, n, 0, get_bcr, set_bcr },		\
+	  trap_bcr, reset_bcr, 0, 0, get_bcr, set_bcr },		\
 	{ SYS_DESC(SYS_DBGWVRn_EL1(n)),					\
-	  trap_wvr, reset_wvr, n, 0,  get_wvr, set_wvr },		\
+	  trap_wvr, reset_wvr, 0, 0,  get_wvr, set_wvr },		\
 	{ SYS_DESC(SYS_DBGWCRn_EL1(n)),					\
-	  trap_wcr, reset_wcr, n, 0,  get_wcr, set_wcr }
+	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
@@ -1540,7 +1540,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 
-	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, },
+	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, PMCR_EL0 },
 	{ SYS_DESC(SYS_PMCNTENSET_EL0), access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
 	{ SYS_DESC(SYS_PMCNTENCLR_EL0), access_pmcnten, NULL, PMCNTENSET_EL0 },
 	{ SYS_DESC(SYS_PMOVSCLR_EL0), access_pmovs, NULL, PMOVSSET_EL0 },
@@ -2254,13 +2254,19 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 }
 
 static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
-			      const struct sys_reg_desc *table, size_t num)
+				const struct sys_reg_desc *table, size_t num,
+				unsigned long *bmap)
 {
 	unsigned long i;
 
 	for (i = 0; i < num; i++)
-		if (table[i].reset)
+		if (table[i].reset) {
+			int reg = table[i].reg;
+
 			table[i].reset(vcpu, &table[i]);
+			if (reg > 0 && reg < NR_SYS_REGS)
+				set_bit(reg, bmap);
+		}
 }
 
 /**
@@ -2774,18 +2780,16 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 {
 	size_t num;
 	const struct sys_reg_desc *table;
-
-	/* Catch someone adding a register without putting in reset entry. */
-	memset(&vcpu->arch.ctxt.sys_regs, 0x42, sizeof(vcpu->arch.ctxt.sys_regs));
+	DECLARE_BITMAP(bmap, NR_SYS_REGS) = { 0, };
 
 	/* Generic chip reset first (so target could override). */
-	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs), bmap);
 
 	table = get_target_table(vcpu->arch.target, true, &num);
-	reset_sys_reg_descs(vcpu, table, num);
+	reset_sys_reg_descs(vcpu, table, num, bmap);
 
 	for (num = 1; num < NR_SYS_REGS; num++) {
-		if (WARN(__vcpu_sys_reg(vcpu, num) == 0x4242424242424242,
+		if (WARN(!test_bit(num, bmap),
 			 "Didn't reset __vcpu_sys_reg(%zi)\n", num))
 			break;
 	}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

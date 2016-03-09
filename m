From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 67/95] arm64: KVM: Add access handler for PMINTENSET and
 PMINTENCLR register
Date: Wed,  9 Mar 2016 07:31:01 +0000
Message-ID: <1457508689-19672-68-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4C549B93
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AjTBRiv6sLY9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:34:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5603E49B34
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:56 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Since the reset value of PMINTENSET and PMINTENCLR is UNKNOWN, use
reset_unknown for its reset handler. Add a handler to emulate writing
PMINTENSET or PMINTENCLR register.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 32 ++++++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 121182d..da59f44 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -127,6 +127,7 @@ enum vcpu_sysreg {
 	PMEVTYPER30_EL0 = PMEVTYPER0_EL0 + 30,
 	PMCCFILTR_EL0,	/* Cycle Count Filter Register */
 	PMCNTENSET_EL0,	/* Count Enable Set Register */
+	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
 
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4faf324..bfc70b2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -626,6 +626,30 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	if (!kvm_arm_pmu_v3_ready(vcpu))
+		return trap_raz_wi(vcpu, p, r);
+
+	if (p->is_write) {
+		u64 val = p->regval & mask;
+
+		if (r->Op2 & 0x1)
+			/* accessing PMINTENSET_EL1 */
+			vcpu_sys_reg(vcpu, PMINTENSET_EL1) |= val;
+		else
+			/* accessing PMINTENCLR_EL1 */
+			vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
+	} else {
+		p->regval = vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -784,10 +808,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* PMINTENSET_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b001),
-	  trap_raz_wi },
+	  access_pminten, reset_unknown, PMINTENSET_EL1 },
 	/* PMINTENCLR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b010),
-	  trap_raz_wi },
+	  access_pminten, NULL, PMINTENSET_EL1 },
 
 	/* MAIR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0010), Op2(0b000),
@@ -1182,8 +1206,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
 
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
-- 
2.1.4

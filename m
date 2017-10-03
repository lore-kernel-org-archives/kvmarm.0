From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 23/31] KVM: arm64: Emulate AT S12E[01] instructions
Date: Mon,  2 Oct 2017 22:11:05 -0500
Message-ID: <1507000273-3735-21-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFC4D49D33
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MmW9BvNaruEw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:47 -0400 (EDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com
 [209.85.223.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2823849D31
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:45 -0400 (EDT)
Received: by mail-io0-f182.google.com with SMTP id m201so1135541iom.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:04 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Emulating AT A12E[01] instructions involves two steps. First, do the
stage-1 translation by reusing the existing AT emulation functions. Then
do the stage-2 translation by walking the guest hypervisor's stage-2
page table in software. Record the translation result to PAR_EL1.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/sys_regs.c        | 99 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3993703..e160895 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -111,6 +111,7 @@
 #define VTCR_EL2_TG0_16K	TCR_TG0_16K
 #define VTCR_EL2_TG0_64K	TCR_TG0_64K
 #define VTCR_EL2_SH0_MASK	TCR_SH0_MASK
+#define VTCR_EL2_SH0_SHIFT	TCR_SH0_SHIFT
 #define VTCR_EL2_SH0_INNER	TCR_SH0_INNER
 #define VTCR_EL2_ORGN0_MASK	TCR_ORGN0_MASK
 #define VTCR_EL2_ORGN0_WBWA	TCR_ORGN0_WBWA
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cb46db5..7950ee0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1656,6 +1656,97 @@ static bool handle_s1e2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static u64 setup_par_aborted(u32 esr)
+{
+	u64 par = 0;
+
+	/* S [9]: fault in the stage 2 translation */
+	par |= (1 << 9);
+	/* FST [6:1]: Fault status code  */
+	par |= (esr << 1);
+	/* F [0]: translation is aborted */
+	par |= 1;
+
+	return par;
+}
+
+static u64 setup_par_completed(struct kvm_vcpu *vcpu, struct kvm_s2_trans *out)
+{
+	u64 par, vtcr_sh0;
+
+	/* F [0]: Translation is completed successfully */
+	par = 0;
+	/* ATTR [63:56] */
+	par |= out->upper_attr;
+	/* PA [47:12] */
+	par |= out->output & GENMASK_ULL(11, 0);
+	/* RES1 [11] */
+	par |= (1UL << 11);
+	/* SH [8:7]: Shareability attribute */
+	vtcr_sh0 = vcpu_sys_reg(vcpu, VTCR_EL2) & VTCR_EL2_SH0_MASK;
+	par |= (vtcr_sh0 >> VTCR_EL2_SH0_SHIFT) << 7;
+
+	return par;
+}
+
+static bool handle_s12(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+		       const struct sys_reg_desc *r, bool write)
+{
+	u64 par, va;
+	u32 esr;
+	phys_addr_t ipa;
+	struct kvm_s2_trans out;
+	int ret;
+
+	/* Do the stage-1 translation */
+	handle_s1e01(vcpu, p, r);
+	par = vcpu_sys_reg(vcpu, PAR_EL1);
+	if (par & 1) {
+		/* The stage-1 translation aborted */
+		return true;
+	}
+
+	/* Do the stage-2 translation */
+	va = p->regval;
+	ipa = (par & GENMASK_ULL(47, 12)) | (va & GENMASK_ULL(11, 0));
+	out.esr = 0;
+	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
+	if (ret < 0)
+		return false;
+
+	/* Check if the stage-2 PTW is aborted */
+	if (out.esr) {
+		esr = out.esr;
+		goto s2_trans_abort;
+	}
+
+	/* Check the access permission */
+	if ((!write && !out.readable) || (write && !out.writable)) {
+		esr = ESR_ELx_FSC_PERM;
+		esr |= out.level & 0x3;
+		goto s2_trans_abort;
+	}
+
+	vcpu_sys_reg(vcpu, PAR_EL1) = setup_par_completed(vcpu, &out);
+	return true;
+
+s2_trans_abort:
+	vcpu_sys_reg(vcpu, PAR_EL1) = setup_par_aborted(esr);
+	return true;
+}
+
+static bool handle_s12r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	return handle_s12(vcpu, p, r, false);
+}
+
+static bool handle_s12w(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	return handle_s12(vcpu, p, r, true);
+}
+
 /*
  * AT instruction emulation
  *
@@ -1733,10 +1824,10 @@ static bool handle_s1e2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	SYS_INSN_TO_DESC(AT_S1E1WP, handle_s1e01, NULL),
 	SYS_INSN_TO_DESC(AT_S1E2R, handle_s1e2, NULL),
 	SYS_INSN_TO_DESC(AT_S1E2W, handle_s1e2, NULL),
-	SYS_INSN_TO_DESC(AT_S12E1R, NULL, NULL),
-	SYS_INSN_TO_DESC(AT_S12E1W, NULL, NULL),
-	SYS_INSN_TO_DESC(AT_S12E0R, NULL, NULL),
-	SYS_INSN_TO_DESC(AT_S12E0W, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S12E1R, handle_s12r, NULL),
+	SYS_INSN_TO_DESC(AT_S12E1W, handle_s12w, NULL),
+	SYS_INSN_TO_DESC(AT_S12E0R, handle_s12r, NULL),
+	SYS_INSN_TO_DESC(AT_S12E0W, handle_s12w, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2E1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2LE1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE2IS, NULL, NULL),
-- 
1.9.1

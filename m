From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 21/31] KVM: arm64: Emulate AT S1E[01] instructions
Date: Mon,  2 Oct 2017 22:11:03 -0500
Message-ID: <1507000273-3735-19-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B194B49D3B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6O6LHNOHZmaR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:45 -0400 (EDT)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com
 [209.85.214.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB44B49D28
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:42 -0400 (EDT)
Received: by mail-it0-f45.google.com with SMTP id 85so9982949ith.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:02 -0700 (PDT)
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

Emulate AT S1E[01] instructions by issuing the same instructions in EL2. We
set the physical EL1 registers, NV and NV1 bits as described in the AT
instruction emulation overview.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 11 +++++++++++
 arch/arm64/kvm/sys_regs.c            | 32 ++++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4c47bc7..a494db2 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -185,6 +185,17 @@ static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)
 	return (vcpu_sys_reg(vcpu, HCR_EL2) & HCR_TGE);
 }
 
+
+/*
+ * When the NV and NV1 bits are set, the EL2 page table format is used for the
+ * EL1 translation regime.
+ */
+static inline bool vcpu_el2_format_used(const struct kvm_vcpu *vcpu)
+{
+	return ((vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) &&
+		(vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV1));
+}
+
 static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 {
 	/*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d8728cc..a82274f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1621,6 +1621,26 @@ static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
 	{ SYS_DESC(SYS_SP_EL2), NULL, reset_special, SP_EL2, 0},
 };
 
+static bool handle_s1e01(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	bool el2_format;
+	int sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	/* See '2. EL0/EL1 AT instructions: S1E[01]x, S12E1x' table. */
+	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
+		ctxt->hw_sys_regs = ctxt->shadow_sys_regs;
+	else
+		ctxt->hw_sys_regs = ctxt->sys_regs;
+
+	el2_format = vcpu_el2_format_used(vcpu);
+
+	kvm_call_hyp(__kvm_at_insn, vcpu, p->regval, el2_format, sys_encoding);
+
+	return true;
+}
+
 /*
  * AT instruction emulation
  *
@@ -1690,12 +1710,12 @@ static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
 #define SYS_INSN_TO_DESC(insn, access_fn, forward_fn)	\
 	{ SYS_DESC((insn)), (access_fn), NULL, 0, 0, NULL, NULL, (forward_fn) }
 static struct sys_reg_desc sys_insn_descs[] = {
-	SYS_INSN_TO_DESC(AT_S1E1R, NULL, NULL),
-	SYS_INSN_TO_DESC(AT_S1E1W, NULL, NULL),
-	SYS_INSN_TO_DESC(AT_S1E0R, NULL, NULL),
-	SYS_INSN_TO_DESC(AT_S1E0W, NULL, NULL),
-	SYS_INSN_TO_DESC(AT_S1E1RP, NULL, NULL),
-	SYS_INSN_TO_DESC(AT_S1E1WP, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S1E1R, handle_s1e01, NULL),
+	SYS_INSN_TO_DESC(AT_S1E1W, handle_s1e01, NULL),
+	SYS_INSN_TO_DESC(AT_S1E0R, handle_s1e01, NULL),
+	SYS_INSN_TO_DESC(AT_S1E0W, handle_s1e01, NULL),
+	SYS_INSN_TO_DESC(AT_S1E1RP, handle_s1e01, NULL),
+	SYS_INSN_TO_DESC(AT_S1E1WP, handle_s1e01, NULL),
 	SYS_INSN_TO_DESC(AT_S1E2R, NULL, NULL),
 	SYS_INSN_TO_DESC(AT_S1E2W, NULL, NULL),
 	SYS_INSN_TO_DESC(AT_S12E1R, NULL, NULL),
-- 
1.9.1

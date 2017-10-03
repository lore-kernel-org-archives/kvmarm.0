From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 22/31] KVM: arm64: Emulate AT S1E2 instructions
Date: Mon,  2 Oct 2017 22:11:04 -0500
Message-ID: <1507000273-3735-20-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F1EE49D1F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hRolbMqZSVpM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:46 -0400 (EDT)
Received: from mail-it0-f47.google.com (mail-it0-f47.google.com
 [209.85.214.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EAB7149D26
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:43 -0400 (EDT)
Received: by mail-it0-f47.google.com with SMTP id 85so9735878ith.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:03 -0700 (PDT)
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

Emulate AT S1E2 instructions by issuing the corresponding S1E1
instructions in EL2. We set the physical EL1 registers and the HCR_EL2
register as described in the AT instruction emulation overview.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a82274f..cb46db5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1641,6 +1641,21 @@ static bool handle_s1e01(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool handle_s1e2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	bool el2_format;
+	int sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	/* See the '1. EL2 AT instructions: S1E2x' table */
+	ctxt->hw_sys_regs = ctxt->shadow_sys_regs;
+	el2_format = !vcpu_el2_e2h_is_set(vcpu);
+
+	kvm_call_hyp(__kvm_at_insn, vcpu, p->regval, el2_format, sys_encoding);
+	return true;
+}
+
 /*
  * AT instruction emulation
  *
@@ -1716,8 +1731,8 @@ static bool handle_s1e01(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	SYS_INSN_TO_DESC(AT_S1E0W, handle_s1e01, NULL),
 	SYS_INSN_TO_DESC(AT_S1E1RP, handle_s1e01, NULL),
 	SYS_INSN_TO_DESC(AT_S1E1WP, handle_s1e01, NULL),
-	SYS_INSN_TO_DESC(AT_S1E2R, NULL, NULL),
-	SYS_INSN_TO_DESC(AT_S1E2W, NULL, NULL),
+	SYS_INSN_TO_DESC(AT_S1E2R, handle_s1e2, NULL),
+	SYS_INSN_TO_DESC(AT_S1E2W, handle_s1e2, NULL),
 	SYS_INSN_TO_DESC(AT_S12E1R, NULL, NULL),
 	SYS_INSN_TO_DESC(AT_S12E1W, NULL, NULL),
 	SYS_INSN_TO_DESC(AT_S12E0R, NULL, NULL),
-- 
1.9.1

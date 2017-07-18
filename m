From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 37/38] KVM: arm64: Respect the virtual HCR_EL2.NV1 bit
 setting
Date: Tue, 18 Jul 2017 11:59:03 -0500
Message-ID: <1500397144-16232-38-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EFBA49C01
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ocDe7g33L41S for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:55 -0400 (EDT)
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com
 [209.85.223.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8397649C5B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:55 -0400 (EDT)
Received: by mail-io0-f177.google.com with SMTP id l7so10063022iof.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:44 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Forward ELR_EL1, SPSR_EL1 and VBAR_EL1 traps to the virtual EL2 if the
virtual HCR_EL2.NV bit is set.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/sys_regs.c        | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index aeaac4e..a1274b7 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,7 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_NV1		(UL(1) << 43)
 #define HCR_NV		(UL(1) << 42)
 #define HCR_E2H		(UL(1) << 34)
 #define HCR_ID		(UL(1) << 33)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3e4ec5e..6f67666 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1031,6 +1031,15 @@ static bool trap_el2_regs(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* This function is to support the recursive nested virtualization */
+static bool forward_nv1_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
+{
+	if (!vcpu_mode_el2(vcpu) && (vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV1))
+		return true;
+
+	return false;
+}
+
 static bool access_elr(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
@@ -1038,6 +1047,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
 
+	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	access_rw(p, &vcpu->arch.ctxt.gp_regs.elr_el1);
 	return true;
 }
@@ -1049,6 +1061,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
 
+	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	access_rw(p, &vcpu->arch.ctxt.gp_regs.spsr[KVM_SPSR_EL1]);
 	return true;
 }
@@ -1060,6 +1075,9 @@ static bool access_vbar(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
 
+	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
 	return true;
 }
-- 
1.9.1

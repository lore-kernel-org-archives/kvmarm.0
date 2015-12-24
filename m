From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/31] arm64: KVM: Implement 32bit system register save/restore
Date: Thu, 24 Dec 2015 11:12:18 +0000
Message-ID: <1450955559-15639-11-git-send-email-marc.zyngier@arm.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69A4E49692
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Dec 2015 06:11:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G7Bnxv131m8g for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Dec 2015 06:11:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61143495BD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Dec 2015 06:11:24 -0500 (EST)
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Jisheng Zhang <jszhang@marvell.com>, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Implement the 32bit system register save/restore as a direct
translation of the assembly code version.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/hyp.h       |  2 ++
 arch/arm64/kvm/hyp/sysreg-sr.c | 47 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index 778d56d..bffd308 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -40,6 +40,8 @@ void __timer_restore_state(struct kvm_vcpu *vcpu);
 
 void __sysreg_save_state(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
+void __sysreg32_save_state(struct kvm_vcpu *vcpu);
+void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_HYP_H__ */
 
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index add8fcb..eb05afb 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -88,3 +88,50 @@ void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->gp_regs.elr_el1,	elr_el1);
 	write_sysreg(ctxt->gp_regs.spsr[KVM_SPSR_EL1], spsr_el1);
 }
+
+void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
+{
+	u64 *spsr, *sysreg;
+
+	if (read_sysreg(hcr_el2) & HCR_RW)
+		return;
+
+	spsr = vcpu->arch.ctxt.gp_regs.spsr;
+	sysreg = vcpu->arch.ctxt.sys_regs;
+
+	spsr[KVM_SPSR_ABT] = read_sysreg(spsr_abt);
+	spsr[KVM_SPSR_UND] = read_sysreg(spsr_und);
+	spsr[KVM_SPSR_IRQ] = read_sysreg(spsr_irq);
+	spsr[KVM_SPSR_FIQ] = read_sysreg(spsr_fiq);
+
+	sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
+	sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
+
+	if (!(read_sysreg(cptr_el2) & CPTR_EL2_TFP))
+		sysreg[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
+
+	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
+		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
+}
+
+void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
+{
+	u64 *spsr, *sysreg;
+
+	if (read_sysreg(hcr_el2) & HCR_RW)
+		return;
+
+	spsr = vcpu->arch.ctxt.gp_regs.spsr;
+	sysreg = vcpu->arch.ctxt.sys_regs;
+
+	write_sysreg(spsr[KVM_SPSR_ABT], spsr_abt);
+	write_sysreg(spsr[KVM_SPSR_UND], spsr_und);
+	write_sysreg(spsr[KVM_SPSR_IRQ], spsr_irq);
+	write_sysreg(spsr[KVM_SPSR_FIQ], spsr_fiq);
+
+	write_sysreg(sysreg[DACR32_EL2], dacr32_el2);
+	write_sysreg(sysreg[IFSR32_EL2], ifsr32_el2);
+
+	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
+		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
+}
-- 
2.1.4

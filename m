From: Alex Shi <alex.shi@linaro.org>
Subject: [PATCH 36/52] arm64: KVM: Make PSCI_VERSION a fast path
Date: Mon, 26 Feb 2018 16:20:10 +0800
Message-ID: <1519633227-29832-37-git-send-email-alex.shi@linaro.org>
References: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, "open list:KERNEL VIRTUAL MACHINE KVM" <kvm@vger.kernel.org>, "moderated list:KERNEL VIRTUAL
        MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 KVM/arm64" <kvmarm@lists.cs.columbia.edu>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

commit 90348689d500 upstream.

For those CPUs that require PSCI to perform a BP invalidation,
going all the way to the PSCI code for not much is a waste of
precious cycles. Let's terminate that call as early as possible.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index cf6d962..3eab6ac 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -17,6 +17,7 @@
 
 #include <linux/types.h>
 #include <linux/jump_label.h>
+#include <uapi/linux/psci.h>
 
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -308,6 +309,18 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
 		goto again;
 
+	if (exit_code == ARM_EXCEPTION_TRAP &&
+	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_HVC64 ||
+	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_HVC32) &&
+	    vcpu_get_reg(vcpu, 0) == PSCI_0_2_FN_PSCI_VERSION) {
+		u64 val = PSCI_RET_NOT_SUPPORTED;
+		if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features))
+			val = 2;
+
+		vcpu_set_reg(vcpu, 0, val);
+		goto again;
+	}
+
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
 	    exit_code == ARM_EXCEPTION_TRAP) {
 		bool valid;
-- 
2.7.4

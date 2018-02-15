From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 15/40] KVM: arm64: Don't deactivate VM on VHE systems
Date: Thu, 15 Feb 2018 22:03:07 +0100
Message-ID: <20180215210332.8648-16-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

There is no need to reset the VTTBR to zero when exiting the guest on
VHE systems.  VHE systems don't use stage 2 translations for the EL2&0
translation regime used by the host.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v1:
     - Changed __activate_vm to take a kvm pointer
     - No longer adding inline attributes to functions

 arch/arm64/kvm/hyp/switch.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 85dae7b94a0f..734dac7f808f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -156,9 +156,8 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(0, pmuserenr_el0);
 }
 
-static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
+static void __hyp_text __activate_vm(struct kvm *kvm)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
 }
 
@@ -377,7 +376,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__sysreg_save_host_state(host_ctxt);
 
 	__activate_traps(vcpu);
-	__activate_vm(vcpu);
+	__activate_vm(vcpu->kvm);
 
 	__vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
@@ -405,7 +404,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
-	__deactivate_vm(vcpu);
 
 	__sysreg_restore_host_state(host_ctxt);
 
@@ -440,7 +438,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__sysreg_save_host_state(host_ctxt);
 
 	__activate_traps(vcpu);
-	__activate_vm(vcpu);
+	__activate_vm(kern_hyp_va(vcpu->kvm));
 
 	__vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
-- 
2.14.2

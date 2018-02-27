From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 15/40] KVM: arm64: Don't deactivate VM on VHE systems
Date: Tue, 27 Feb 2018 12:34:04 +0100
Message-ID: <20180227113429.637-16-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FFF049FCA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:28:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nes2MuISxW2Q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 06:28:25 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5473F49E07
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:28:01 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id s206so21263357wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 03:34:54 -0800 (PST)
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

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
index 1e26a81c0a16..9ffd802e775d 100644
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

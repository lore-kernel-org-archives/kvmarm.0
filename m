From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 22/26] KVM: arm/arm64: GICv4: Enable virtual cpuif if VLPIs can be delivered
Date: Fri,  6 Oct 2017 16:33:57 +0100
Message-ID: <20171006153401.5481-23-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order for VLPIs to be delivered to the guest, we must make
sure that the cpuif is always enabled, irrespective of the
presence of virtual interrupt in the LRs.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 91728faa13fd..f5c3d6d7019e 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -258,7 +258,8 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
 		}
 	} else {
-		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+		if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
+		    cpu_if->its_vpe.its_vm)
 			write_gicreg(0, ICH_HCR_EL2);
 
 		cpu_if->vgic_elrsr = 0xffff;
@@ -337,9 +338,11 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 		/*
 		 * If we need to trap system registers, we must write
 		 * ICH_HCR_EL2 anyway, even if no interrupts are being
-		 * injected,
+		 * injected. Same thing if GICv4 is used, as VLPI
+		 * delivery is gated by ICH_HCR_EL2.En.
 		 */
-		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+		if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
+		    cpu_if->its_vpe.its_vm)
 			write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 	}
 
-- 
2.14.1

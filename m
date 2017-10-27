From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 22/26] KVM: arm/arm64: GICv4: Enable virtual cpuif if VLPIs
 can be delivered
Date: Fri, 27 Oct 2017 15:28:51 +0100
Message-ID: <20171027142855.21584-23-marc.zyngier@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE85C40795
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dpkoJ8Nqwg-u for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 10:28:49 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F61049D6A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:48 -0400 (EDT)
In-Reply-To: <20171027142855.21584-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
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
2.11.0

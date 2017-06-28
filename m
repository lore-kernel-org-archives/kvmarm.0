From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 50/52] KVM: arm/arm64: GICv4: Enable virtual cpuif if VLPIs
 can be delivered
Date: Wed, 28 Jun 2017 16:04:09 +0100
Message-ID: <20170628150411.15846-51-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C77649C5B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UgDXWvTATY33 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F48F40D19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:53 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

In order for VLPIs to be delivered to the guest, we must make
sure that the cpuif is always enabled, irrespective of the
presence of virtual interrupt in the LRs.

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

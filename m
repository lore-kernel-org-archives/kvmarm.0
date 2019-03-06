From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] KVM: arm: VGIC: properly initialise private IRQ affinity
Date: Wed,  6 Mar 2019 10:40:08 +0000
Message-ID: <20190306104008.69414-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 117464A497
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Mar 2019 05:40:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 72k1MUmyA1tq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Mar 2019 05:40:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D08CD4A496
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Mar 2019 05:40:15 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Dave Martin <dave.martin@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

At the moment we initialise the target *mask* of a virtual IRQ to the
VCPU it belongs to, even though this mask is only defined for GICv2 and
quickly runs out of bits for many GICv3 guests.
This behaviour triggers an UBSAN complaint for more than 32 VCPUs:
------
[ 5659.462377] UBSAN: Undefined behaviour in virt/kvm/arm/vgic/vgic-init.c:223:21
[ 5659.471689] shift exponent 32 is too large for 32-bit type 'unsigned int'
------
Also for GICv3 guests the reporting of TARGET in the "vgic-state" debugfs
dump is wrong, due to this very same problem.

Fix both issues by only initialising vgic_irq->targets for a vGICv2 guest,
and by initialising vgic_irq->mpdir for vGICv3 guests instead. We can't
use the actual MPIDR for that, as the VCPU's system register is not
initialised at this point yet. This is not really an issue, as ->mpidr
is just used for the debugfs output and the IROUTER MMIO register, which
does not exist in redistributors (dealing with SGIs and PPIs).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reported-by: Dave Martin <dave.martin@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 3bdb31eaed64..3172b2c916f1 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -220,7 +220,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		irq->intid = i;
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu;
-		irq->targets = 1U << vcpu->vcpu_id;
 		kref_init(&irq->refcount);
 		if (vgic_irq_is_sgi(i)) {
 			/* SGIs */
@@ -231,10 +230,14 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 			irq->config = VGIC_CONFIG_LEVEL;
 		}
 
-		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
 			irq->group = 1;
-		else
+			/* The actual MPIDR is not initialised at this point. */
+			irq->mpidr = 0;
+		} else {
 			irq->group = 0;
+			irq->targets = 1U << vcpu->vcpu_id;
+		}
 	}
 
 	if (!irqchip_in_kernel(vcpu->kvm))
-- 
2.17.1

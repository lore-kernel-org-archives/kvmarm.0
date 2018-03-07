From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/2] KVM: arm/arm64: vgic: Don't populate multiple LRs with
 the same vintid
Date: Wed,  7 Mar 2018 12:40:54 +0000
Message-ID: <20180307124055.13800-2-marc.zyngier@arm.com>
References: <20180307124055.13800-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B6F9402B8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 07:34:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CWGWD8N9HxZW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Mar 2018 07:33:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BBD740259
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 07:33:58 -0500 (EST)
In-Reply-To: <20180307124055.13800-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The vgic code is trying to be clever when injecting GICv2 SGIs,
and will happily populate LRs with the same interrupt number if
they come from multiple vcpus (after all, they are distinct
interrupt sources).

Unfortunately, this is against the letter of the architecture,
and the GICv2 architecture spec says "Each valid interrupt stored
in the List registers must have a unique VirtualID for that
virtual CPU interface.". GICv3 has similar (although slightly
ambiguous) restrictions.

This results in guests locking up when using GICv2-on-GICv3, for
example. The obvious fix is to stop trying so hard, and inject
a single vcpu per SGI per guest entry. After all, pending SGIs
with multiple source vcpus are pretty rare, and are mostly seen
in scenario where the physical CPUs are severely overcomitted.

Cc: stable@vger.kernel.org
Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index c7c5ef190afa..1f7ff175f47b 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -720,18 +720,9 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		spin_lock(&irq->irq_lock);
 
-		if (unlikely(vgic_target_oracle(irq) != vcpu))
-			goto next;
-
-		/*
-		 * If we get an SGI with multiple sources, try to get
-		 * them in all at once.
-		 */
-		do {
+		if (likely(vgic_target_oracle(irq) == vcpu))
 			vgic_populate_lr(vcpu, irq, count++);
-		} while (irq->source && count < kvm_vgic_global_state.nr_lr);
 
-next:
 		spin_unlock(&irq->irq_lock);
 
 		if (count == kvm_vgic_global_state.nr_lr) {
-- 
2.14.2

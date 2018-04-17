From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] KVM: arm/arm64: VGIC: Kick new VCPU on interrupt migration
Date: Tue, 17 Apr 2018 11:23:49 +0100
Message-ID: <20180417102349.3039-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Stefano Stabellini <sstabellini@kernel.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When vgic_prune_ap_list() finds an interrupt that needs to be migrated
to a new VCPU, we should notify this VCPU of the pending interrupt,
since it requires immediate action.
Kick this VCPU once we have added the new IRQ to the list, but only
after dropping the locks.

Reported-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index e74baec76361..4b6d72939c42 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -594,6 +594,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
+		bool target_vcpu_needs_kick = false;
 
 		spin_lock(&irq->irq_lock);
 
@@ -664,11 +665,18 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			list_del(&irq->ap_list);
 			irq->vcpu = target_vcpu;
 			list_add_tail(&irq->ap_list, &new_cpu->ap_list_head);
+			target_vcpu_needs_kick = true;
 		}
 
 		spin_unlock(&irq->irq_lock);
 		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
 		spin_unlock_irqrestore(&vcpuA->arch.vgic_cpu.ap_list_lock, flags);
+
+		if (target_vcpu_needs_kick) {
+			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
+			kvm_vcpu_kick(target_vcpu);
+		}
+
 		goto retry;
 	}
 
-- 
2.14.1

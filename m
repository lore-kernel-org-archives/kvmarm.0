From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/5] KVM: arm/arm64: vgic: Kick new VCPU on interrupt migration
Date: Fri, 20 Apr 2018 17:07:12 +0100
Message-ID: <20180420160713.17884-5-marc.zyngier@arm.com>
References: <20180420160713.17884-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180420160713.17884-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Stefano Stabellini <sstabellini@kernel.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

When vgic_prune_ap_list() finds an interrupt that needs to be migrated
to a new VCPU, we should notify this VCPU of the pending interrupt,
since it requires immediate action.
Kick this VCPU once we have added the new IRQ to the list, but only
after dropping the locks.

Reported-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
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
2.14.2

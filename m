From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm: vgic: Drop build compatibility hack for older kernel versions
Date: Tue, 30 Aug 2016 18:54:19 +0100
Message-ID: <1472579659-20772-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As kvm_set_routing_entry() was changing prototype between 4.7 and 4.8,
an ugly hack was put in place in order to survive both building in
-next and the merge window.

Now that everything has been merged, let's dump the compatibility
hack for good.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-irqfd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index b31a51a..d918dcf 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -46,15 +46,9 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
  * @ue: user api routing entry handle
  * return 0 on success, -EINVAL on errors.
  */
-#ifdef KVM_CAP_X2APIC_API
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
-#else
-/* Remove this version and the ifdefery once merged into 4.8 */
-int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
-			  const struct kvm_irq_routing_entry *ue)
-#endif
 {
 	int r = -EINVAL;
 
-- 
2.1.4


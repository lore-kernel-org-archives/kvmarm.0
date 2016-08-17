From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 03/12] KVM: arm64: vgic-its: Plug race in vgic_put_irq
Date: Wed, 17 Aug 2016 21:38:50 +0200
Message-ID: <20160817193859.15726-4-christoffer.dall@linaro.org>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Right now the following sequence of events can happen:

  1. Thread X calls vgic_put_irq
  2. Thread Y calls vgic_add_lpi
  3. Thread Y gets lpi_list_lock
  4. Thread X drops the ref count to 0 and blocks on lpi_list_lock
  5. Thread Y finds the irq via the lpi_list_lock, raises the ref
     count to 1, and release the lpi_list_lock.
  6. Thread X proceeds and frees the irq.

Avoid this by holding the spinlock around the kref_put.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index e7aeac7..e83b7fe 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -117,17 +117,17 @@ static void vgic_irq_release(struct kref *ref)
 
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
-	struct vgic_dist *dist;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 
 	if (irq->intid < VGIC_MIN_LPI)
 		return;
 
-	if (!kref_put(&irq->refcount, vgic_irq_release))
+	spin_lock(&dist->lpi_list_lock);
+	if (!kref_put(&irq->refcount, vgic_irq_release)) {
+		spin_unlock(&dist->lpi_list_lock);
 		return;
+	};
 
-	dist = &kvm->arch.vgic;
-
-	spin_lock(&dist->lpi_list_lock);
 	list_del(&irq->lpi_list);
 	dist->lpi_list_count--;
 	spin_unlock(&dist->lpi_list_lock);
-- 
2.9.0


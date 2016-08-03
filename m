From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 2/3] KVM: arm64: vgic-its: Plug race in vgic_put_irq
Date: Wed,  3 Aug 2016 18:13:24 +0200
Message-ID: <20160803161325.14933-3-christoffer.dall@linaro.org>
References: <20160803161325.14933-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B30D49B34
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 12:05:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SBUKWCb78ixw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2016 12:05:00 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B28E149B1D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 12:05:00 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id q128so454559094wma.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Aug 2016 09:11:51 -0700 (PDT)
In-Reply-To: <20160803161325.14933-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index e7aeac7..fb8c0ab 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -117,22 +117,22 @@ static void vgic_irq_release(struct kref *ref)
 
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
-	struct vgic_dist *dist;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 
 	if (irq->intid < VGIC_MIN_LPI)
 		return;
 
-	if (!kref_put(&irq->refcount, vgic_irq_release))
-		return;
-
-	dist = &kvm->arch.vgic;
-
 	spin_lock(&dist->lpi_list_lock);
-	list_del(&irq->lpi_list);
-	dist->lpi_list_count--;
-	spin_unlock(&dist->lpi_list_lock);
+	if (!kref_put(&irq->refcount, vgic_irq_release)) {
+		spin_unlock(&dist->lpi_list_lock);
+		return;
+	} else {
+		list_del(&irq->lpi_list);
+		dist->lpi_list_count--;
+		spin_unlock(&dist->lpi_list_lock);
 
-	kfree(irq);
+		kfree(irq);
+	}
 }
 
 /**
-- 
2.9.0

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 1/3] KVM: arm64: vgic-its: Handle errors from vgic_add_lpi
Date: Wed,  3 Aug 2016 18:13:23 +0200
Message-ID: <20160803161325.14933-2-christoffer.dall@linaro.org>
References: <20160803161325.14933-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2209949B3D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 12:05:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vtEh6m35zRsF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2016 12:05:00 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3695749B34
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2016 12:04:59 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id o80so343676636wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Aug 2016 09:11:50 -0700 (PDT)
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

During low memory conditions, we could be dereferencing a NULL pointer
when vgic_add_lpi fails to allocate memory.

Consider for example this call sequence:

  vgic_its_cmd_handle_mapi
      itte->irq = vgic_add_lpi(kvm, lpi_nr);
          update_lpi_config(kvm, itte->irq, NULL);
              ret = kvm_read_guest(kvm, propbase + irq->intid
	                                             ^^^^
						     kaboom?

Instead, return an error pointer from vgic_add_lpi and check the return
value from its single caller.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changes since v1:
 - Don't errornously get an extra kref refernce for the struct vgic_irq
 - Don't rework the entire error handling of the function, but follow
   what Marc suggested he prefers based on his fixup patch.
 virt/kvm/arm/vgic/vgic-its.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 07411cf..424f7a5 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -51,7 +51,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
 
 	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL);
 	if (!irq)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&irq->lpi_list);
 	INIT_LIST_HEAD(&irq->ap_list);
@@ -693,10 +693,11 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	u32 event_id = its_cmd_get_id(its_cmd);
 	u32 coll_id = its_cmd_get_collection(its_cmd);
-	struct its_itte *itte;
+	struct its_itte *itte, *new_itte = NULL;
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
 	int lpi_nr;
+	struct vgic_irq *irq;
 
 	device = find_its_device(its, device_id);
 	if (!device)
@@ -720,7 +721,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 	itte = find_itte(its, device_id, event_id);
 	if (!itte) {
-		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
+		new_itte = itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
 		if (!itte) {
 			if (new_coll)
 				vgic_its_free_collection(its, coll_id);
@@ -733,7 +734,16 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 	itte->collection = collection;
 	itte->lpi = lpi_nr;
-	itte->irq = vgic_add_lpi(kvm, lpi_nr);
+
+	irq = vgic_add_lpi(kvm, lpi_nr);
+	if (IS_ERR(irq)) {
+		if (new_coll)
+			vgic_its_free_collection(its, coll_id);
+		kfree(new_itte);
+		return PTR_ERR(irq);
+	}
+	itte->irq = irq;
+
 	update_affinity_itte(kvm, itte);
 
 	/*
-- 
2.9.0

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] KVM: arm64: vgic-its: Handle errors from vgic_add_lpi
Date: Mon,  1 Aug 2016 20:29:52 +0200
Message-ID: <20160801182952.3005-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EEC749B35
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Aug 2016 14:21:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lqj5LTlV6FxL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Aug 2016 14:21:37 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FB0449B34
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Aug 2016 14:21:37 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id o80so256773578wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Aug 2016 11:28:22 -0700 (PDT)
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
 virt/kvm/arm/vgic/vgic-its.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 07411cf..3515bdb 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -51,7 +51,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
 
 	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL);
 	if (!irq)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&irq->lpi_list);
 	INIT_LIST_HEAD(&irq->ap_list);
@@ -697,24 +697,33 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
 	int lpi_nr;
-
-	device = find_its_device(its, device_id);
-	if (!device)
-		return E_ITS_MAPTI_UNMAPPED_DEVICE;
+	struct vgic_irq *irq = NULL;
+	int err = 0;
 
 	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
 		lpi_nr = its_cmd_get_physical_id(its_cmd);
 	else
 		lpi_nr = event_id;
+
 	if (lpi_nr < GIC_LPI_OFFSET ||
 	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser))
 		return E_ITS_MAPTI_PHYSICALID_OOR;
 
+	irq = vgic_add_lpi(kvm, lpi_nr);
+	if (IS_ERR(irq))
+		return PTR_ERR(irq);
+
+	device = find_its_device(its, device_id);
+	if (!device) {
+		err = E_ITS_MAPTI_UNMAPPED_DEVICE;
+		goto out;
+	}
+
 	collection = find_collection(its, coll_id);
 	if (!collection) {
-		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
-		if (ret)
-			return ret;
+		err = vgic_its_alloc_collection(its, &collection, coll_id);
+		if (err)
+			goto out;
 		new_coll = collection;
 	}
 
@@ -722,9 +731,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (!itte) {
 		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
 		if (!itte) {
-			if (new_coll)
-				vgic_its_free_collection(its, coll_id);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto out;
 		}
 
 		itte->event_id	= event_id;
@@ -733,7 +741,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 	itte->collection = collection;
 	itte->lpi = lpi_nr;
-	itte->irq = vgic_add_lpi(kvm, lpi_nr);
+	vgic_get_irq_kref(irq);
+	itte->irq = irq;
 	update_affinity_itte(kvm, itte);
 
 	/*
@@ -742,8 +751,15 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	 * the respective config data from memory here upon mapping the LPI.
 	 */
 	update_lpi_config(kvm, itte->irq, NULL);
+	new_coll = NULL;
+	irq = NULL;
 
-	return 0;
+out:
+	if (new_coll)
+		vgic_its_free_collection(its, coll_id);
+	if (irq)
+		vgic_put_irq(kvm, irq);
+	return err;
 }
 
 /* Requires the its_lock to be held. */
-- 
2.9.0

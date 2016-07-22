From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 51/55] KVM: arm64: vgic-its: Add collection
 allocator/destructor
Date: Fri, 22 Jul 2016 18:29:08 +0100
Message-ID: <1469208552-4155-52-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04C1E49BBB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1JEAZ8YHgllM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:25:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBD0A49C02
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:11 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

Instead of spreading random allocations all over the place,
consolidate allocation/init/freeing of collections in a pair
of constructor/destructor.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 92 ++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 38 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 2faf1f4..d6f68e9 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -581,14 +581,45 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
-static void vgic_its_init_collection(struct vgic_its *its,
-				     struct its_collection *collection,
+static int vgic_its_alloc_collection(struct vgic_its *its,
+				     struct its_collection **colp,
 				     u32 coll_id)
 {
+	struct its_collection *collection;
+
+	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
+
 	collection->collection_id = coll_id;
 	collection->target_addr = COLLECTION_NOT_MAPPED;
 
 	list_add_tail(&collection->coll_list, &its->collection_list);
+	*colp = collection;
+
+	return 0;
+}
+
+static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
+{
+	struct its_collection *collection;
+	struct its_device *device;
+	struct its_itte *itte;
+
+	/*
+	 * Clearing the mapping for that collection ID removes the
+	 * entry from the list. If there wasn't any before, we can
+	 * go home early.
+	 */
+	collection = find_collection(its, coll_id);
+	if (!collection)
+		return;
+
+	for_each_lpi_its(device, itte, its)
+		if (itte->collection &&
+		    itte->collection->collection_id == coll_id)
+			itte->collection = NULL;
+
+	list_del(&collection->coll_list);
+	kfree(collection);
 }
 
 /*
@@ -605,6 +636,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
 	int lpi_nr;
+	int ret;
 
 	device = find_its_device(its, device_id);
 	if (!device)
@@ -612,9 +644,10 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 	collection = find_collection(its, coll_id);
 	if (!collection) {
-		new_coll = kzalloc(sizeof(struct its_collection), GFP_KERNEL);
-		if (!new_coll)
-			return -ENOMEM;
+		ret = vgic_its_alloc_collection(its, &collection, coll_id);
+		if (ret)
+			return ret;
+		new_coll = collection;
 	}
 
 	if (subcmd == GITS_CMD_MAPTI)
@@ -623,27 +656,22 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		lpi_nr = event_id;
 	if (lpi_nr < GIC_LPI_OFFSET ||
 	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser)) {
-		kfree(new_coll);
-		return E_ITS_MAPTI_PHYSICALID_OOR;
+		ret = E_ITS_MAPTI_PHYSICALID_OOR;
+		goto err;
 	}
 
 	itte = find_itte(its, device_id, event_id);
 	if (!itte) {
 		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
 		if (!itte) {
-			kfree(new_coll);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err;
 		}
 
 		itte->event_id	= event_id;
 		list_add_tail(&itte->itte_list, &device->itt_head);
 	}
 
-	if (!collection) {
-		collection = new_coll;
-		vgic_its_init_collection(its, collection, coll_id);
-	}
-
 	itte->collection = collection;
 	itte->lpi = lpi_nr;
 	itte->irq = vgic_add_lpi(kvm, lpi_nr);
@@ -657,6 +685,10 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	update_lpi_config(kvm, itte->irq, NULL);
 
 	return 0;
+err:
+	if (new_coll)
+		vgic_its_free_collection(its, coll_id);
+	return ret;
 }
 
 /* Requires the its_lock to be held. */
@@ -809,34 +841,18 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 	if (coll_id >= vgic_its_nr_collection_ids(its))
 		return E_ITS_MAPC_COLLECTION_OOR;
 
-	collection = find_collection(its, coll_id);
-
 	if (!valid) {
-		struct its_device *device;
-		struct its_itte *itte;
-		/*
-		 * Clearing the mapping for that collection ID removes the
-		 * entry from the list. If there wasn't any before, we can
-		 * go home early.
-		 */
-		if (!collection)
-			return 0;
-
-		for_each_lpi_its(device, itte, its)
-			if (itte->collection &&
-			    itte->collection->collection_id == coll_id)
-				itte->collection = NULL;
-
-		list_del(&collection->coll_list);
-		kfree(collection);
+		vgic_its_free_collection(its, coll_id);
 	} else {
+		collection = find_collection(its, coll_id);
+
 		if (!collection) {
-			collection = kzalloc(sizeof(struct its_collection),
-					     GFP_KERNEL);
-			if (!collection)
-				return -ENOMEM;
+			int ret;
 
-			vgic_its_init_collection(its, collection, coll_id);
+			ret = vgic_its_alloc_collection(its, &collection,
+							coll_id);
+			if (ret)
+				return ret;
 			collection->target_addr = target_addr;
 		} else {
 			collection->target_addr = target_addr;
-- 
2.8.1

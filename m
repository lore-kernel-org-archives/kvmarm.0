From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 07/12] KVM: arm64: ITS: avoid re-mapping LPIs
Date: Wed, 17 Aug 2016 21:38:54 +0200
Message-ID: <20160817193859.15726-8-christoffer.dall@linaro.org>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

When a guest wants to map a device-ID/event-ID combination that is
already mapped, we may end up in a situation where an LPI is never
"put", thus never being freed.
Since the GICv3 spec says that mapping an already mapped LPI is
UNPREDICTABLE, lets just bail out early in this situation to avoid
any potential leaks.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 9533080..4660a7d 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -731,7 +731,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	u32 event_id = its_cmd_get_id(its_cmd);
 	u32 coll_id = its_cmd_get_collection(its_cmd);
-	struct its_itte *itte, *new_itte = NULL;
+	struct its_itte *itte;
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
 	int lpi_nr;
@@ -749,6 +749,10 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser))
 		return E_ITS_MAPTI_PHYSICALID_OOR;
 
+	/* If there is an existing mapping, behavior is UNPREDICTABLE. */
+	if (find_itte(its, device_id, event_id))
+		return 0;
+
 	collection = find_collection(its, coll_id);
 	if (!collection) {
 		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
@@ -757,20 +761,16 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		new_coll = collection;
 	}
 
-	itte = find_itte(its, device_id, event_id);
+	itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
 	if (!itte) {
-		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
-		if (!itte) {
-			if (new_coll)
-				vgic_its_free_collection(its, coll_id);
-			return -ENOMEM;
-		}
-
-		new_itte = itte;
-		itte->event_id	= event_id;
-		list_add_tail(&itte->itte_list, &device->itt_head);
+		if (new_coll)
+			vgic_its_free_collection(its, coll_id);
+		return -ENOMEM;
 	}
 
+	itte->event_id	= event_id;
+	list_add_tail(&itte->itte_list, &device->itt_head);
+
 	itte->collection = collection;
 	itte->lpi = lpi_nr;
 
@@ -778,8 +778,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (IS_ERR(irq)) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
-		if (new_itte)
-			its_free_itte(kvm, new_itte);
+		its_free_itte(kvm, itte);
 		return PTR_ERR(irq);
 	}
 	itte->irq = irq;
-- 
2.9.0


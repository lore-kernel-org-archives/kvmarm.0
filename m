From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 15/22] KVM: arm64: vgic-its: vgic_its_alloc_ite/device
Date: Fri, 14 Apr 2017 12:15:27 +0200
Message-ID: <1492164934-988-16-git-send-email-eric.auger@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Add two new helpers to allocate an its ite and an its device.
This will avoid duplication on restore path.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

---

v4 -> v5:
- add Marc's A-b

v3 -> v4:
- fix allocation
- add comment about its_lock mutex hold

v1 -> v2:
- report itt_size fix and remove ITE_SIZE
- s/itte/ite/g
---
 virt/kvm/arm/vgic/vgic-its.c | 73 ++++++++++++++++++++++++++++++--------------
 1 file changed, 50 insertions(+), 23 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 55267ab..56c5123 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -742,6 +742,27 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
 	kfree(collection);
 }
 
+/* Must be called with its_lock mutex held */
+static int vgic_its_alloc_ite(struct its_device *device,
+			       struct its_ite **itep,
+			       struct its_collection *collection,
+			       u32 lpi_id, u32 event_id)
+{
+	struct its_ite *ite;
+
+	ite = kzalloc(sizeof(*ite), GFP_KERNEL);
+	if (!ite)
+		return -ENOMEM;
+
+	ite->event_id	= event_id;
+	ite->collection = collection;
+	ite->lpi = lpi_id;
+
+	list_add_tail(&ite->ite_list, &device->itt_head);
+	*itep = ite;
+	return 0;
+}
+
 /*
  * The MAPTI and MAPI commands map LPIs to ITTEs.
  * Must be called with its_lock mutex held.
@@ -755,7 +776,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	struct its_ite *ite;
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
-	int lpi_nr;
+	int lpi_nr, ret;
 	struct vgic_irq *irq;
 
 	device = find_its_device(its, device_id);
@@ -785,19 +806,13 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		new_coll = collection;
 	}
 
-	ite = kzalloc(sizeof(struct its_ite), GFP_KERNEL);
-	if (!ite) {
+	ret = vgic_its_alloc_ite(device, &ite, collection, lpi_nr, event_id);
+	if (ret) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
-		return -ENOMEM;
+		return ret;
 	}
 
-	ite->event_id	= event_id;
-	list_add_tail(&ite->ite_list, &device->itt_head);
-
-	ite->collection = collection;
-	ite->lpi = lpi_nr;
-
 	irq = vgic_add_lpi(kvm, lpi_nr);
 	if (IS_ERR(irq)) {
 		if (new_coll)
@@ -836,6 +851,29 @@ static void vgic_its_unmap_device(struct kvm *kvm, struct its_device *device)
 	kfree(device);
 }
 
+/* Must be called with its_lock mutex held */
+static int vgic_its_alloc_device(struct vgic_its *its,
+				 struct its_device **devp,
+				 u32 device_id, gpa_t itt_addr,
+				 u8 nb_eventid_bits)
+{
+	struct its_device *device;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device)
+		return -ENOMEM;
+
+	device->device_id = device_id;
+	device->itt_addr = itt_addr;
+	device->nb_eventid_bits = nb_eventid_bits;
+	INIT_LIST_HEAD(&device->itt_head);
+
+	list_add_tail(&device->dev_list, &its->device_list);
+	*devp = device;
+
+	return 0;
+}
+
 /*
  * MAPD maps or unmaps a device ID to Interrupt Translation Tables (ITTs).
  * Must be called with the its_lock mutex held.
@@ -872,19 +910,8 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	if (!valid)
 		return 0;
 
-	device = kzalloc(sizeof(struct its_device), GFP_KERNEL);
-	if (!device)
-		return -ENOMEM;
-
-	device->device_id = device_id;
-	device->nb_eventid_bits = nb_eventid_bits;
-	device->itt_addr = itt_addr;
-
-	INIT_LIST_HEAD(&device->itt_head);
-
-	list_add_tail(&device->dev_list, &its->device_list);
-
-	return 0;
+	return vgic_its_alloc_device(its, &device, device_id,
+				     itt_addr, nb_eventid_bits);
 }
 
 /*
-- 
2.5.5

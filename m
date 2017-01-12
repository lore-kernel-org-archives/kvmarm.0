From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 10/13] KVM: arm64: ITS: vgic_its_alloc_itte/device
Date: Thu, 12 Jan 2017 16:56:50 +0100
Message-ID: <1484236613-24633-11-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9BCA40419
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9LJjzsULLqLJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 10:55:51 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B214B40354
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:51 -0500 (EST)
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

Add two new helpers to allocate an its itte and an its device.
This will avoid duplication on restore path.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 71 ++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index aeb9d08..07bf180 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -732,6 +732,26 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
 	kfree(collection);
 }
 
+static int vgic_its_alloc_itte(struct its_device *device,
+			       struct its_itte **ittep,
+			       struct its_collection *collection,
+			       u32 lpi_id, u32 event_id)
+{
+	struct its_itte *itte;
+
+	itte = kzalloc(sizeof(itte), GFP_KERNEL);
+	if (!itte)
+		return -ENOMEM;
+
+	itte->event_id	= event_id;
+	itte->collection = collection;
+	itte->lpi = lpi_id;
+
+	list_add_tail(&itte->itte_list, &device->itt_head);
+	*ittep = itte;
+	return 0;
+}
+
 /*
  * The MAPTI and MAPI commands map LPIs to ITTEs.
  * Must be called with its_lock mutex held.
@@ -745,7 +765,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	struct its_itte *itte;
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
-	int lpi_nr;
+	int lpi_nr, ret;
 	struct vgic_irq *irq;
 
 	device = find_its_device(its, device_id);
@@ -772,19 +792,13 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		new_coll = collection;
 	}
 
-	itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
-	if (!itte) {
+	ret = vgic_its_alloc_itte(device, &itte, collection, lpi_nr, event_id);
+	if (ret) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
-		return -ENOMEM;
+		return ret;
 	}
 
-	itte->event_id	= event_id;
-	list_add_tail(&itte->itte_list, &device->itt_head);
-
-	itte->collection = collection;
-	itte->lpi = lpi_nr;
-
 	irq = vgic_add_lpi(kvm, lpi_nr);
 	if (IS_ERR(irq)) {
 		if (new_coll)
@@ -823,6 +837,29 @@ static void vgic_its_unmap_device(struct kvm *kvm, struct its_device *device)
 	kfree(device);
 }
 
+static int vgic_its_alloc_device(struct vgic_its *its,
+				 struct its_device **devp,
+				 u32 device_id, gpa_t itt_addr_field,
+				 size_t size_field)
+{
+	struct its_device *device;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device)
+		return -ENOMEM;
+
+	device->device_id = device_id;
+	device->itt_addr = itt_addr_field << 8;
+	device->nb_eventid_bits = size_field + 1;
+	device->itt_size = ((2 << (size_field + 1)) - 1) * 16;
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
@@ -856,19 +893,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	if (!valid)
 		return 0;
 
-	device = kzalloc(sizeof(struct its_device), GFP_KERNEL);
-	if (!device)
-		return -ENOMEM;
-
-	device->device_id = device_id;
-	device->itt_addr = itt_addr << 8;
-	device->nb_eventid_bits = size + 1;
-	device->itt_size = ((2 << (size + 1)) - 1) * 16;
-	INIT_LIST_HEAD(&device->itt_head);
-
-	list_add_tail(&device->dev_list, &its->device_list);
-
-	return 0;
+	return vgic_its_alloc_device(its, &device, device_id, itt_addr, size);
 }
 
 /*
-- 
2.5.5

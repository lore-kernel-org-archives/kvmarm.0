From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 19/37] KVM: arm64: vgic-its: vgic_its_alloc_ite/device
Date: Tue,  9 May 2017 12:44:48 +0200
Message-ID: <20170509104506.30929-20-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C21E40C2F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X9tUAa161yZY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:19 -0400 (EDT)
Received: from mail-qk0-f170.google.com (mail-qk0-f170.google.com
 [209.85.220.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5879C40C32
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:16 -0400 (EDT)
Received: by mail-qk0-f170.google.com with SMTP id a72so58964840qkj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:31 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

Add two new helpers to allocate an its ite and an its device.
This will avoid duplication on restore path.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 68 ++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index cb7ae4c..737ba3c 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -802,6 +802,25 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
 	kfree(collection);
 }
 
+/* Must be called with its_lock mutex held */
+static struct its_ite *vgic_its_alloc_ite(struct its_device *device,
+					  struct its_collection *collection,
+					  u32 lpi_id, u32 event_id)
+{
+	struct its_ite *ite;
+
+	ite = kzalloc(sizeof(*ite), GFP_KERNEL);
+	if (!ite)
+		return ERR_PTR(-ENOMEM);
+
+	ite->event_id	= event_id;
+	ite->collection = collection;
+	ite->lpi = lpi_id;
+
+	list_add_tail(&ite->ite_list, &device->itt_head);
+	return ite;
+}
+
 /*
  * The MAPTI and MAPI commands map LPIs to ITTEs.
  * Must be called with its_lock mutex held.
@@ -816,8 +835,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	struct kvm_vcpu *vcpu = NULL;
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
-	int lpi_nr;
 	struct vgic_irq *irq;
+	int lpi_nr;
 
 	device = find_its_device(its, device_id);
 	if (!device)
@@ -846,19 +865,13 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		new_coll = collection;
 	}
 
-	ite = kzalloc(sizeof(struct its_ite), GFP_KERNEL);
-	if (!ite) {
+	ite = vgic_its_alloc_ite(device, collection, lpi_nr, event_id);
+	if (IS_ERR(ite)) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
-		return -ENOMEM;
+		return PTR_ERR(ite);
 	}
 
-	ite->event_id	= event_id;
-	list_add_tail(&ite->ite_list, &device->itt_head);
-
-	ite->collection = collection;
-	ite->lpi = lpi_nr;
-
 	if (its_is_collection_mapped(collection))
 		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
@@ -891,6 +904,26 @@ static void vgic_its_unmap_device(struct kvm *kvm, struct its_device *device)
 	kfree(device);
 }
 
+/* Must be called with its_lock mutex held */
+static struct its_device *vgic_its_alloc_device(struct vgic_its *its,
+						u32 device_id, gpa_t itt_addr,
+						u8 num_eventid_bits)
+{
+	struct its_device *device;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device)
+		return ERR_PTR(-ENOMEM);
+
+	device->device_id = device_id;
+	device->itt_addr = itt_addr;
+	device->num_eventid_bits = num_eventid_bits;
+	INIT_LIST_HEAD(&device->itt_head);
+
+	list_add_tail(&device->dev_list, &its->device_list);
+	return device;
+}
+
 /*
  * MAPD maps or unmaps a device ID to Interrupt Translation Tables (ITTs).
  * Must be called with the its_lock mutex held.
@@ -927,17 +960,10 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	if (!valid)
 		return 0;
 
-	device = kzalloc(sizeof(struct its_device), GFP_KERNEL);
-	if (!device)
-		return -ENOMEM;
-
-	device->device_id = device_id;
-	device->num_eventid_bits = num_eventid_bits;
-	device->itt_addr = itt_addr;
-
-	INIT_LIST_HEAD(&device->itt_head);
-
-	list_add_tail(&device->dev_list, &its->device_list);
+	device = vgic_its_alloc_device(its, device_id, itt_addr,
+				       num_eventid_bits);
+	if (IS_ERR(device))
+		return PTR_ERR(device);
 
 	return 0;
 }
-- 
2.9.0

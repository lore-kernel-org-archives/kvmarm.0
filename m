From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 21/26] KVM: arm/arm64: vgic-its: New helper functions to free the caches
Date: Tue,  7 Nov 2017 11:47:54 +0100
Message-ID: <20171107104800.30021-22-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wanghaibin <wanghaibin.wang@huawei.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: wanghaibin <wanghaibin.wang@huawei.com>

We create two new functions that free the device and
collection lists. They are currently called by vgic_its_destroy()
and other callers will be added in subsequent patches.

We also remove the check on its->device_list.next.
Lists are initialized in vgic_create_its() and the device
is added to the device list only if this latter succeeds.

vgic_its_destroy is the device destroy ops. This latter is called
by kvm_destroy_devices() which loops on all created devices. So
at this point the list is initialized.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 75c18183eee3..d46256c07ba5 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -913,6 +913,24 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
 	kfree(device);
 }
 
+/* its lock must be held */
+static void vgic_its_free_device_list(struct kvm *kvm, struct vgic_its *its)
+{
+	struct its_device *cur, *temp;
+
+	list_for_each_entry_safe(cur, temp, &its->device_list, dev_list)
+		vgic_its_free_device(kvm, cur);
+}
+
+/* its lock must be held */
+static void vgic_its_free_collection_list(struct kvm *kvm, struct vgic_its *its)
+{
+	struct its_collection *cur, *temp;
+
+	list_for_each_entry_safe(cur, temp, &its->collection_list, coll_list)
+		vgic_its_free_collection(its, cur->collection_id);
+}
+
 /* Must be called with its_lock mutex held */
 static struct its_device *vgic_its_alloc_device(struct vgic_its *its,
 						u32 device_id, gpa_t itt_addr,
@@ -1619,32 +1637,13 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 {
 	struct kvm *kvm = kvm_dev->kvm;
 	struct vgic_its *its = kvm_dev->private;
-	struct list_head *cur, *temp;
-
-	/*
-	 * We may end up here without the lists ever having been initialized.
-	 * Check this and bail out early to avoid dereferencing a NULL pointer.
-	 */
-	if (!its->device_list.next)
-		return;
 
 	mutex_lock(&its->its_lock);
-	list_for_each_safe(cur, temp, &its->device_list) {
-		struct its_device *dev;
 
-		dev = list_entry(cur, struct its_device, dev_list);
-		vgic_its_free_device(kvm, dev);
-	}
-
-	list_for_each_safe(cur, temp, &its->collection_list) {
-		struct its_collection *coll;
+	vgic_its_free_device_list(kvm, its);
+	vgic_its_free_collection_list(kvm, its);
 
-		coll = list_entry(cur, struct its_collection, coll_list);
-		list_del(cur);
-		kfree(coll);
-	}
 	mutex_unlock(&its->its_lock);
-
 	kfree(its);
 }
 
-- 
2.14.2

From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 08/11] KVM: arm/arm64: vgic-its: new helper functions to
 free the caches
Date: Tue, 17 Oct 2017 09:10:06 +0200
Message-ID: <1508224209-15366-9-git-send-email-eric.auger@redhat.com>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C41AF49D2B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 03:10:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5u-HbU+eQeMH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 03:10:05 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC13649D28
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 03:10:05 -0400 (EDT)
In-Reply-To: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: wanghaibin <wanghaibin.wang@huawei.com>

We create 2 new functions that frees the device and
collection lists. this is currently called by vgic_its_destroy()
and we will add other callers in subsequent patches.

We also remove the check on its->device_list.next as it looks
unnecessary. Indeed, the device list always is initialized
when vgic_its_destroy gets called: the kvm device is removed
by kvm_destroy_devices() which loops on all the devices
added to kvm->devices. kvm_ioctl_create_device() only adds
the device to kvm_devices once the lists have been initialized
(in vgic_create_its).

We also move vgic_its_free_device to prepare for new callers.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
[Eric] removed its->device_list.next which is not needed as
pointed out by Wanghaibin. Reword the commit message
---
 virt/kvm/arm/vgic/vgic-its.c | 76 ++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 35 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1c3e83f..f3f0026f 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -611,6 +611,45 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 	kfree(ite);
 }
 
+static void vgic_its_free_device(struct kvm *kvm, struct its_device *dev)
+{
+	struct its_ite *ite, *tmp;
+
+	list_for_each_entry_safe(ite, tmp, &dev->itt_head, ite_list)
+		its_free_ite(kvm, ite);
+	list_del(&dev->dev_list);
+	kfree(dev);
+}
+
+static void vgic_its_free_device_list(struct kvm *kvm, struct vgic_its *its)
+{
+	struct list_head *cur, *temp;
+
+	mutex_lock(&its->its_lock);
+	list_for_each_safe(cur, temp, &its->device_list) {
+		struct its_device *dev;
+
+		dev = list_entry(cur, struct its_device, dev_list);
+		vgic_its_free_device(kvm, dev);
+	}
+	mutex_unlock(&its->its_lock);
+}
+
+static void vgic_its_free_collection_list(struct kvm *kvm, struct vgic_its *its)
+{
+	struct list_head *cur, *temp;
+
+	list_for_each_safe(cur, temp, &its->collection_list) {
+		struct its_collection *coll;
+
+		coll = list_entry(cur, struct its_collection, coll_list);
+		list_del(cur);
+		kfree(coll);
+	}
+	mutex_unlock(&its->its_lock);
+}
+
+
 static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
 {
 	return (le64_to_cpu(its_cmd[word]) >> shift) & (BIT_ULL(size) - 1);
@@ -1644,46 +1683,13 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	return vgic_its_set_abi(its, NR_ITS_ABIS - 1);
 }
 
-static void vgic_its_free_device(struct kvm *kvm, struct its_device *dev)
-{
-	struct its_ite *ite, *tmp;
-
-	list_for_each_entry_safe(ite, tmp, &dev->itt_head, ite_list)
-		its_free_ite(kvm, ite);
-	list_del(&dev->dev_list);
-	kfree(dev);
-}
-
 static void vgic_its_destroy(struct kvm_device *kvm_dev)
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
-
-	mutex_lock(&its->its_lock);
-	list_for_each_safe(cur, temp, &its->device_list) {
-		struct its_device *dev;
-
-		dev = list_entry(cur, struct its_device, dev_list);
-		vgic_its_free_device(kvm, dev);
-	}
-
-	list_for_each_safe(cur, temp, &its->collection_list) {
-		struct its_collection *coll;
-
-		coll = list_entry(cur, struct its_collection, coll_list);
-		list_del(cur);
-		kfree(coll);
-	}
-	mutex_unlock(&its->its_lock);
 
+	vgic_its_free_device_list(kvm, its);
+	vgic_its_free_collection_list(kvm, its);
 	kfree(its);
 }
 
-- 
2.5.5

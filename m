From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 07/10] KVM: arm/arm64: vgic-its: New helper functions to
 free the caches
Date: Mon, 23 Oct 2017 16:08:26 +0200
Message-ID: <1508767709-15256-8-git-send-email-eric.auger@redhat.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 454DE49D69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:08:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NJOl0vvGDA3e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Oct 2017 10:07:59 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAEAC49D42
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:07:57 -0400 (EDT)
In-Reply-To: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
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

We create two new functions that free the device and
collection lists. They are currently called by vgic_its_destroy()
and other callers will be added in subsequent patches.

We also remove the check on its->device_list.next.
Lists are initialized in vgic_create_its() and the device
is added to the device list only if this latter succeeds.

vgic_its_destroy is the device destroy ops. This latter is called
by kvm_destroy_devices() which loops on all created devices. So
at this point the list is initialized.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v4 -> v5:
- add mutex_lock in vgic_its_free_collection_list
- use list_for_each_entry_safe
- reword commit message
---
 virt/kvm/arm/vgic/vgic-its.c | 51 ++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 2f3c3a1..8098f91 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -910,6 +910,30 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
 	kfree(device);
 }
 
+static void vgic_its_free_device_list(struct kvm *kvm, struct vgic_its *its)
+{
+	struct its_device *cur, *temp;
+
+	mutex_lock(&its->its_lock);
+
+	list_for_each_entry_safe(cur, temp, &its->device_list, dev_list)
+		vgic_its_free_device(kvm, cur);
+
+	mutex_unlock(&its->its_lock);
+}
+
+static void vgic_its_free_collection_list(struct kvm *kvm, struct vgic_its *its)
+{
+	struct its_collection *cur, *temp;
+
+	mutex_lock(&its->its_lock);
+
+	list_for_each_entry_safe(cur, temp, &its->collection_list, coll_list)
+		vgic_its_free_collection(its, cur->collection_id);
+
+	mutex_unlock(&its->its_lock);
+}
+
 /* Must be called with its_lock mutex held */
 static struct its_device *vgic_its_alloc_device(struct vgic_its *its,
 						u32 device_id, gpa_t itt_addr,
@@ -1627,32 +1651,9 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
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

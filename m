From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 37/37] KVM: arm/arm64: vgic-its: Cleanup after failed ITT
 restore
Date: Tue,  9 May 2017 12:45:06 +0200
Message-ID: <20170509104506.30929-38-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E897740BAC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yzB06Ut5crCq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:40 -0400 (EDT)
Received: from mail-qk0-f174.google.com (mail-qk0-f174.google.com
 [209.85.220.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 368B240DAF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:33 -0400 (EDT)
Received: by mail-qk0-f174.google.com with SMTP id k74so75288762qke.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:48 -0700 (PDT)
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When failing to restore the ITT for a DTE, we should remove the failed
device entry from the list and free the object.

We slightly refactor vgic_its_destroy to be able to reuse the now
separate vgic_its_free_dte() function.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 9aeaff0..2dff288 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1613,13 +1613,20 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	return vgic_its_set_abi(its, NR_ITS_ABIS - 1);
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
 static void vgic_its_destroy(struct kvm_device *kvm_dev)
 {
 	struct kvm *kvm = kvm_dev->kvm;
 	struct vgic_its *its = kvm_dev->private;
-	struct its_device *dev;
-	struct its_ite *ite;
-	struct list_head *dev_cur, *dev_temp;
 	struct list_head *cur, *temp;
 
 	/*
@@ -1630,19 +1637,19 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 		return;
 
 	mutex_lock(&its->its_lock);
-	list_for_each_safe(dev_cur, dev_temp, &its->device_list) {
-		dev = container_of(dev_cur, struct its_device, dev_list);
-		list_for_each_safe(cur, temp, &dev->itt_head) {
-			ite = (container_of(cur, struct its_ite, ite_list));
-			its_free_ite(kvm, ite);
-		}
-		list_del(dev_cur);
-		kfree(dev);
+	list_for_each_safe(cur, temp, &its->device_list) {
+		struct its_device *dev;
+
+		dev = list_entry(cur, struct its_device, dev_list);
+		vgic_its_free_device(kvm, dev);
 	}
 
 	list_for_each_safe(cur, temp, &its->collection_list) {
+		struct its_collection *coll;
+
+		coll = list_entry(cur, struct its_collection, coll_list);
 		list_del(cur);
-		kfree(container_of(cur, struct its_collection, coll_list));
+		kfree(coll);
 	}
 	mutex_unlock(&its->its_lock);
 
@@ -2012,8 +2019,10 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 		return PTR_ERR(dev);
 
 	ret = vgic_its_restore_itt(its, dev);
-	if (ret)
+	if (ret) {
+		vgic_its_free_device(its->dev->kvm, dev);
 		return ret;
+	}
 
 	return offset;
 }
-- 
2.9.0

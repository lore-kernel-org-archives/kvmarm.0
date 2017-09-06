From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [RFC PATCH 1/3] kvm: arm/arm64: vgic-vits: separate
 vgic_its_free_list() function
Date: Wed, 6 Sep 2017 21:05:08 +0800
Message-ID: <1504703110-10744-2-git-send-email-wanghaibin.wang@huawei.com>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AECCD49C42
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 09:04:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mHGysc34YPcU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Sep 2017 09:04:26 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17BEB49C46
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 09:04:23 -0400 (EDT)
In-Reply-To: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

We slightly refactor vgic_its_destroy, separate vgic_its_free_list()
function for later patch invoke.

The patch also take a functional change. If the its->device_list.next
is NULL, we still should free the its.
Honestly, I can't understand How does the its->device_list.next is NULL
happened at this moment.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index aa6b68d..25d614f 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1624,10 +1624,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *dev)
 	kfree(dev);
 }
 
-static void vgic_its_destroy(struct kvm_device *kvm_dev)
+static void vgic_its_free_list(struct kvm *kvm, struct vgic_its *its)
 {
-	struct kvm *kvm = kvm_dev->kvm;
-	struct vgic_its *its = kvm_dev->private;
 	struct list_head *cur, *temp;
 
 	/*
@@ -1653,7 +1651,14 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 		kfree(coll);
 	}
 	mutex_unlock(&its->its_lock);
+}
+
+static void vgic_its_destroy(struct kvm_device *kvm_dev)
+{
+	struct kvm *kvm = kvm_dev->kvm;
+	struct vgic_its *its = kvm_dev->private;
 
+	vgic_its_free_list(kvm, its);
 	kfree(its);
 }
 
-- 
1.8.3.1

From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 5/9] KVM: arm/arm64: vgic-its: Remove kvm_its_unmap_device
Date: Thu, 26 Oct 2017 17:23:07 +0200
Message-ID: <1509031391-4407-6-git-send-email-eric.auger@redhat.com>
References: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A485349D39
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 11:22:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l-T8E0i9XtAx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Oct 2017 11:22:37 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C866749D27
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 11:22:37 -0400 (EDT)
In-Reply-To: <1509031391-4407-1-git-send-email-eric.auger@redhat.com>
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

Let's remove kvm_its_unmap_device and use kvm_its_free_device
as both functions are identical.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

---
v5 -> v6:
- Added Christoffer's A-b

v5: creation
---
 virt/kvm/arm/vgic/vgic-its.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 9ba6f23..d21c960 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -894,7 +894,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 }
 
 /* Requires the its_lock to be held. */
-static void vgic_its_unmap_device(struct kvm *kvm, struct its_device *device)
+static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
 {
 	struct its_ite *ite, *temp;
 
@@ -957,7 +957,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * by removing the mapping and re-establishing it.
 	 */
 	if (device)
-		vgic_its_unmap_device(kvm, device);
+		vgic_its_free_device(kvm, device);
 
 	/*
 	 * The spec does not say whether unmapping a not-mapped device
@@ -1623,16 +1623,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
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
-- 
2.5.5

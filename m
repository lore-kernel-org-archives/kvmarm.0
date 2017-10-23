From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 06/10] KVM: arm/arm64: vgic-its: Remove kvm_its_unmap_device
Date: Mon, 23 Oct 2017 16:08:25 +0200
Message-ID: <1508767709-15256-7-git-send-email-eric.auger@redhat.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Let's remove kvm_its_unmap_device and use kvm_its_free_device
as both functions are identical.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v5: creation
---
 virt/kvm/arm/vgic/vgic-its.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8472417..2f3c3a1 100644
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

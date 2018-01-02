From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH] KVM: arm/arm64: vgic-its: Fix vgic_v4 init
Date: Tue,  2 Jan 2018 14:50:20 +0100
Message-ID: <1514901020-5072-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

When GICv4 is enabled and vgic_v4_init() is called from the its device
creation path, it does nothing. The reason is that the has_its field is
initialized after the vgic_v4_init() call and vgic_supports_direct_msis
returns false.

This patch moves the has_its setting before the vgic_v4_init call.

Fixes: 74fe55dc ("KVM: arm/arm64: GICv4: Add init/teardown of the per-VM
vPE irq domain")

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8e633bd..1651e49 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1687,10 +1687,13 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	if (!its)
 		return -ENOMEM;
 
+	dev->kvm->arch.vgic.has_its = true;
+
 	if (vgic_initialized(dev->kvm)) {
 		int ret = vgic_v4_init(dev->kvm);
 		if (ret < 0) {
 			kfree(its);
+			dev->kvm->arch.vgic.has_its = false;
 			return ret;
 		}
 	}
@@ -1704,7 +1707,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	INIT_LIST_HEAD(&its->collection_list);
 
 	dev->kvm->arch.vgic.msis_require_devid = true;
-	dev->kvm->arch.vgic.has_its = true;
 	its->enabled = false;
 	its->dev = dev;
 
-- 
2.5.5

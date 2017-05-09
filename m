From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 08/11] KVM: arm/arm64: Get rid of its->initialized field
Date: Tue,  9 May 2017 10:56:15 +0200
Message-ID: <20170509085618.28311-9-cdall@linaro.org>
References: <20170509085618.28311-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170509085618.28311-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The its->initialized doesn't bring much to the table, and creates
unnecessary ordering between setting the address and initializing it
(which amounts to exactly nothing).

Let's kill it altogether, making KVM_DEV_ARM_VGIC_CTRL_INIT the no-op
it deserves to be.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_vgic.h       | 1 -
 virt/kvm/arm/vgic/vgic-its.c | 7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4ff65ef..bfde6fb 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -148,7 +148,6 @@ struct vgic_its {
 	gpa_t			vgic_its_base;
 
 	bool			enabled;
-	bool			initialized;
 	struct vgic_io_device	iodev;
 	struct kvm_device	*dev;
 
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 9f7105c..18318c6 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1545,9 +1545,6 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
 	struct vgic_io_device *iodev = &its->iodev;
 	int ret;
 
-	if (!its->initialized)
-		return -EBUSY;
-
 	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
 		return -ENXIO;
 
@@ -1597,7 +1594,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	INIT_LIST_HEAD(&its->collection_list);
 
 	dev->kvm->arch.vgic.has_its = true;
-	its->initialized = false;
 	its->enabled = false;
 	its->dev = dev;
 
@@ -2397,8 +2393,7 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			its->initialized = true;
-
+			/* Nothing to do */
 			return 0;
 		case KVM_DEV_ARM_ITS_SAVE_TABLES:
 			return abi->save_tables(its);
-- 
2.9.0

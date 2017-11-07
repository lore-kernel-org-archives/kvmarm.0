From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 24/26] KVM: arm/arm64: vgic-its: Implement KVM_DEV_ARM_ITS_CTRL_RESET
Date: Tue,  7 Nov 2017 11:47:57 +0100
Message-ID: <20171107104800.30021-25-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

On reset we clear the valid bits of GITS_CBASER and GITS_BASER<n>.
We also clear command queue registers and free the cache (device,
collection, and lpi lists).

As we need to take the same locks as save/restore functions, we
create a vgic_its_ctrl() wrapper that handles KVM_DEV_ARM_VGIC_GRP_CTRL
group functions.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/uapi/asm/kvm.h   |   1 +
 arch/arm64/include/uapi/asm/kvm.h |   1 +
 virt/kvm/arm/vgic/vgic-its.c      | 105 ++++++++++++++++++++------------------
 3 files changed, 58 insertions(+), 49 deletions(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 665c454e50d0..b56895593c84 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -221,6 +221,7 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
+#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 0004feef7cc2..37ca7394549c 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -233,6 +233,7 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
+#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1732e08a4375..40791c121710 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2273,29 +2273,13 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
  */
 static int vgic_its_save_tables_v0(struct vgic_its *its)
 {
-	struct kvm *kvm = its->dev->kvm;
 	int ret;
 
-	mutex_lock(&kvm->lock);
-	mutex_lock(&its->its_lock);
-
-	if (!lock_all_vcpus(kvm)) {
-		mutex_unlock(&its->its_lock);
-		mutex_unlock(&kvm->lock);
-		return -EBUSY;
-	}
-
 	ret = vgic_its_save_device_tables(its);
 	if (ret)
-		goto out;
-
-	ret = vgic_its_save_collection_table(its);
+		return ret;
 
-out:
-	unlock_all_vcpus(kvm);
-	mutex_unlock(&its->its_lock);
-	mutex_unlock(&kvm->lock);
-	return ret;
+	return vgic_its_save_collection_table(its);
 }
 
 /**
@@ -2305,29 +2289,13 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
  */
 static int vgic_its_restore_tables_v0(struct vgic_its *its)
 {
-	struct kvm *kvm = its->dev->kvm;
 	int ret;
 
-	mutex_lock(&kvm->lock);
-	mutex_lock(&its->its_lock);
-
-	if (!lock_all_vcpus(kvm)) {
-		mutex_unlock(&its->its_lock);
-		mutex_unlock(&kvm->lock);
-		return -EBUSY;
-	}
-
 	ret = vgic_its_restore_collection_table(its);
 	if (ret)
-		goto out;
-
-	ret = vgic_its_restore_device_tables(its);
-out:
-	unlock_all_vcpus(kvm);
-	mutex_unlock(&its->its_lock);
-	mutex_unlock(&kvm->lock);
+		return ret;
 
-	return ret;
+	return vgic_its_restore_device_tables(its);
 }
 
 static int vgic_its_commit_v0(struct vgic_its *its)
@@ -2346,6 +2314,19 @@ static int vgic_its_commit_v0(struct vgic_its *its)
 	return 0;
 }
 
+static void vgic_its_reset(struct kvm *kvm, struct vgic_its *its)
+{
+	/* We need to keep the ABI specific field values */
+	its->baser_coll_table &= ~GITS_BASER_VALID;
+	its->baser_device_table &= ~GITS_BASER_VALID;
+	its->cbaser = 0;
+	its->creadr = 0;
+	its->cwriter = 0;
+	its->enabled = 0;
+	vgic_its_free_device_list(kvm, its);
+	vgic_its_free_collection_list(kvm, its);
+}
+
 static int vgic_its_has_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
@@ -2360,6 +2341,8 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_ITS_CTRL_RESET:
+			return 0;
 		case KVM_DEV_ARM_ITS_SAVE_TABLES:
 			return 0;
 		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
@@ -2372,6 +2355,41 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 	return -ENXIO;
 }
 
+static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
+{
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	int ret = 0;
+
+	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT) /* Nothing to do */
+		return 0;
+
+	mutex_lock(&kvm->lock);
+	mutex_lock(&its->its_lock);
+
+	if (!lock_all_vcpus(kvm)) {
+		mutex_unlock(&its->its_lock);
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	switch (attr) {
+	case KVM_DEV_ARM_ITS_CTRL_RESET:
+		vgic_its_reset(kvm, its);
+		break;
+	case KVM_DEV_ARM_ITS_SAVE_TABLES:
+		ret = abi->save_tables(its);
+		break;
+	case KVM_DEV_ARM_ITS_RESTORE_TABLES:
+		ret = abi->restore_tables(its);
+		break;
+	}
+
+	unlock_all_vcpus(kvm);
+	mutex_unlock(&its->its_lock);
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 static int vgic_its_set_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
@@ -2397,19 +2415,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 
 		return vgic_register_its_iodev(dev->kvm, its, addr);
 	}
-	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
-		const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-
-		switch (attr->attr) {
-		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			/* Nothing to do */
-			return 0;
-		case KVM_DEV_ARM_ITS_SAVE_TABLES:
-			return abi->save_tables(its);
-		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
-			return abi->restore_tables(its);
-		}
-	}
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		return vgic_its_ctrl(dev->kvm, its, attr->attr);
 	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
 		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 		u64 reg;
-- 
2.14.2

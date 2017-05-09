From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 18/37] KVM: arm64: vgic-its: KVM_DEV_ARM_ITS_SAVE/RESTORE_TABLES
Date: Tue,  9 May 2017 12:44:47 +0200
Message-ID: <20170509104506.30929-19-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B272C40C4E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lrg3gekg3R-o for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:19 -0400 (EDT)
Received: from mail-qk0-f180.google.com (mail-qk0-f180.google.com
 [209.85.220.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E5DD40CE0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:15 -0400 (EDT)
Received: by mail-qk0-f180.google.com with SMTP id a72so58964422qkj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:30 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

Introduce new attributes in KVM_DEV_ARM_VGIC_GRP_CTRL group:
- KVM_DEV_ARM_ITS_SAVE_TABLES: saves the ITS tables into guest RAM
- KVM_DEV_ARM_ITS_RESTORE_TABLES: restores them into VGIC internal
  structures.

We hold the vcpus lock during the save and restore to make
sure no vcpu is running.

At this stage the functionality is not yet implemented. Only
the skeleton is put in place.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
[Given we will move the iodev register until setting the base addr]
Reviewed-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/uapi/asm/kvm.h   |   4 +-
 arch/arm64/include/uapi/asm/kvm.h |   4 +-
 virt/kvm/arm/vgic/vgic-its.c      | 107 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 109 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index ee183fc..0f7ee15 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -201,7 +201,9 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK 0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
-#define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
+#define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
+#define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ee4a0ad..5dd7be0 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -221,7 +221,9 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
-#define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
+#define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
+#define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index ffd0a80..cb7ae4c 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1703,12 +1703,71 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
 }
 
 /**
+ * vgic_its_save_device_tables - Save the device table and all ITT
+ * into guest RAM
+ */
+static int vgic_its_save_device_tables(struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_restore_device_tables - Restore the device table and all ITT
+ * from guest RAM to internal data structs
+ */
+static int vgic_its_restore_device_tables(struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_save_collection_table - Save the collection table into
+ * guest RAM
+ */
+static int vgic_its_save_collection_table(struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_restore_collection_table - reads the collection table
+ * in guest memory and restores the ITS internal state. Requires the
+ * BASER registers to be restored before.
+ */
+static int vgic_its_restore_collection_table(struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
  * vgic_its_save_tables_v0 - Save the ITS tables into guest ARM
  * according to v0 ABI
  */
 static int vgic_its_save_tables_v0(struct vgic_its *its)
 {
-	return -ENXIO;
+	struct kvm *kvm = its->dev->kvm;
+	int ret;
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
+	ret = vgic_its_save_device_tables(its);
+	if (ret)
+		goto out;
+
+	ret = vgic_its_save_collection_table(its);
+
+out:
+	unlock_all_vcpus(kvm);
+	mutex_unlock(&its->its_lock);
+	mutex_unlock(&kvm->lock);
+	return ret;
 }
 
 /**
@@ -1718,7 +1777,37 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
  */
 static int vgic_its_restore_tables_v0(struct vgic_its *its)
 {
-	return -ENXIO;
+	struct kvm *kvm = its->dev->kvm;
+	int ret;
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
+	ret = vgic_its_restore_collection_table(its);
+	if (ret)
+		goto out;
+
+	ret = vgic_its_restore_device_tables(its);
+
+out:
+	unlock_all_vcpus(kvm);
+	mutex_unlock(&its->its_lock);
+	mutex_unlock(&kvm->lock);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * On restore path, MSI injections can happen before the
+	 * first VCPU run so let's complete the GIC init here.
+	 */
+	return kvm_vgic_map_resources(its->dev->kvm);
 }
 
 static int vgic_its_commit_v0(struct vgic_its *its)
@@ -1751,6 +1840,10 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_ITS_SAVE_TABLES:
+			return 0;
+		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
+			return 0;
 		}
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS:
@@ -1786,14 +1879,20 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 
 		return 0;
 	}
-	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
+		const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			its->initialized = true;
 
 			return 0;
+		case KVM_DEV_ARM_ITS_SAVE_TABLES:
+			return abi->save_tables(its);
+		case KVM_DEV_ARM_ITS_RESTORE_TABLES:
+			return abi->restore_tables(its);
 		}
-		break;
+	}
 	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
 		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 		u64 reg;
-- 
2.9.0

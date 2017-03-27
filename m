From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 13/22] KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
 group
Date: Mon, 27 Mar 2017 11:31:03 +0200
Message-ID: <1490607072-21610-14-git-send-email-eric.auger@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5D8A40BD2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:30:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GnkVcveYSh2e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 05:30:27 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E55940A80
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:30:27 -0400 (EDT)
In-Reply-To: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Introduce a new group aiming at saving/restoring the ITS
tables to/from the guest memory.

We hold the vcpus lock during the save and restore to make
sure no vcpu is running.

At this stage the functionality is not yet implemented. Only
the skeleton is put in place.

The ABI revision supposed to have been set through IIDR user
write is checked before the table restoration. This guarantees
this vITS knows how to restore the saved tables.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- pass kvm struct handle to vgic_its_flush/restore_pending_tables
- take the kvm lock and vcpu locks
- ABI revision check
- check attr->attr is null

v1 -> v2:
- remove useless kvm parameter
---
 arch/arm/include/uapi/asm/kvm.h   |   1 +
 arch/arm64/include/uapi/asm/kvm.h |   1 +
 virt/kvm/arm/vgic/vgic-its.c      | 142 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 4beb83b..7b165e9 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -193,6 +193,7 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS	8
+#define KVM_DEV_ARM_VGIC_GRP_ITS_TABLES	9
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 7e8dd69..166df68 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -213,6 +213,7 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
+#define KVM_DEV_ARM_VGIC_GRP_ITS_TABLES 9
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index b275aea..76dd562 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1627,6 +1627,135 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
 	return ret;
 }
 
+/**
+ * vgic_its_flush_pending_tables - Flush the pending tables into guest RAM
+ */
+static int vgic_its_flush_pending_tables(struct kvm *kvm)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_restore_pending_tables - Restore the pending tables from guest
+ * RAM to internal data structs
+ */
+static int vgic_its_restore_pending_tables(struct kvm *kvm)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_flush_device_tables - flush the device table and all ITT
+ * into guest RAM
+ */
+static int vgic_its_flush_device_tables(struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_restore_device_tables - restore the device table and all ITT
+ * from guest RAM to internal data structs
+ */
+static int vgic_its_restore_device_tables(struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_flush_collection_table - flush the collection table into
+ * guest RAM
+ */
+static int vgic_its_flush_collection_table(struct vgic_its *its)
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
+ * vgic_its_table_flush - Flush all the tables into guest RAM
+ */
+static int vgic_its_table_flush(struct vgic_its *its)
+{
+	struct kvm *kvm = its->dev->kvm;
+	int ret;
+
+	mutex_lock(&kvm->lock);
+
+	if (!lock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	ret = vgic_its_flush_pending_tables(kvm);
+	if (ret)
+		goto out;
+	ret = vgic_its_flush_device_tables(its);
+	if (ret)
+		goto out;
+
+	ret = vgic_its_flush_collection_table(its);
+
+out:
+	unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
+/**
+ * vgic_its_table_restore - Restore all tables from guest RAM to internal
+ * data structs
+ */
+static int vgic_its_table_restore(struct vgic_its *its)
+{
+	struct kvm *kvm = its->dev->kvm;
+	int ret;
+
+	mutex_lock(&kvm->lock);
+
+	if (its->user_revision < REV) {
+		mutex_unlock(&kvm->lock);
+		return -EINVAL;
+	}
+
+	if (!lock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	ret = vgic_its_restore_collection_table(its);
+	if (ret)
+		goto out;
+
+	ret = vgic_its_restore_device_tables(its);
+	if (ret)
+		goto out;
+
+	ret = vgic_its_restore_pending_tables(kvm);
+
+out:
+	unlock_all_vcpus(kvm);
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
+}
+
 static int vgic_its_has_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
@@ -1645,6 +1774,8 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS:
 		return vgic_its_has_attr_regs(dev, attr);
+	case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
+		return 0;
 	}
 	return -ENXIO;
 }
@@ -1693,6 +1824,10 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 
 		return vgic_its_attr_regs_access(dev, attr, &reg, true);
 	}
+	case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
+		if (attr->attr)
+			return -EINVAL;
+		return vgic_its_table_restore(its);
 	}
 	return -ENXIO;
 }
@@ -1700,9 +1835,10 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 static int vgic_its_get_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
+	struct vgic_its *its = dev->private;
+
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
-		struct vgic_its *its = dev->private;
 		u64 addr = its->vgic_its_base;
 		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 		unsigned long type = (unsigned long)attr->attr;
@@ -1723,6 +1859,10 @@ static int vgic_its_get_attr(struct kvm_device *dev,
 		if (ret)
 			return ret;
 		return put_user(reg, uaddr);
+	case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
+		if (attr->attr)
+			return -EINVAL;
+		return vgic_its_table_flush(its);
 	}
 	default:
 		return -ENXIO;
-- 
2.5.5

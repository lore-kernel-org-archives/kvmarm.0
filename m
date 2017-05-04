From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 16/24] KVM: arm64: vgic-its: KVM_DEV_ARM_ITS_SAVE/RESTORE_TABLES
Date: Thu,  4 May 2017 13:44:36 +0200
Message-ID: <1493898284-29504-17-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Introduce new attributes in KVM_DEV_ARM_VGIC_GRP_CTRL group:
- KVM_DEV_ARM_ITS_SAVE_TABLES: saves the ITS tables into guest RAM
- KVM_DEV_ARM_ITS_RESTORE_TABLES: restores them into VGIC internal
  structures.

We hold the vcpus lock during the save and restore to make
sure no vcpu is running.

At this stage the functionality is not yet implemented. Only
the skeleton is put in place.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v5 -> v6:
- remove the pending table sync from the ITS table restore

v4 -> v5:
- use KVM_DEV_ARM_ITS_SAVE_TABLES and KVM_DEV_ARM_ITS_RESTORE_TABLES
- rename *flush* into *save*
- call its_sync_lpi_pending_table at the end of restore
- use abi framework

v3 -> v4:
- pass kvm struct handle to vgic_its_flush/restore_pending_tables
- take the kvm lock and vcpu locks
- ABI revision check
- check attr->attr is null

v1 -> v2:
- remove useless kvm parameter
---
 arch/arm/include/uapi/asm/kvm.h   |   4 +-
 arch/arm64/include/uapi/asm/kvm.h |   4 +-
 virt/kvm/arm/vgic/vgic-its.c      | 101 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 103 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 4beb83b..8e6563c 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -199,7 +199,9 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK 0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
-#define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
+#define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
+#define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 7e8dd69..1e35115 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -219,7 +219,9 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
-#define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
+#define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
+#define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 3ad615a..5b251dc 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1669,12 +1669,68 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
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
+
+	if (!lock_all_vcpus(kvm)) {
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
+	mutex_unlock(&kvm->lock);
+	return ret;
 }
 
 /**
@@ -1684,7 +1740,34 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
  */
 static int vgic_its_restore_tables_v0(struct vgic_its *its)
 {
-	return -ENXIO;
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
+	ret = vgic_its_restore_collection_table(its);
+	if (ret)
+		goto out;
+
+	ret = vgic_its_restore_device_tables(its);
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
 }
 
 static int vgic_its_commit_v0(struct vgic_its *its)
@@ -1739,6 +1822,10 @@ static int vgic_its_has_attr(struct kvm_device *dev,
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
@@ -1774,14 +1861,20 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 
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
2.5.5

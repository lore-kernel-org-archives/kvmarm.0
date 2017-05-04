From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 21/24] KVM: arm64: vgic-its: Device table save/restore
Date: Thu,  4 May 2017 13:44:41 +0200
Message-ID: <1493898284-29504-22-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9820640992
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 07:44:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id knYwUX+wAT34 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 07:43:59 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4151140C32
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 07:43:59 -0400 (EDT)
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
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
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch saves the device table entries into guest RAM.
Both flat table and 2 stage tables are supported. DeviceId
indexing is used.

For each device listed in the device table, we also save
the translation table using the vgic_its_save/restore_itt
routines. Those functions will be implemented in a subsequent
patch.

On restore, devices are re-allocated and their itt are
re-built.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v5 -> v6:
- accomodate vgic_its_alloc_device change of proto
- define bit fields for L1 entries
- s/handle_l1_entry/handle_l1_dte
- s/ite_esz/dte_esz in handle_l1_dte
- check BASER valid bit
- s/nb_eventid_bits/num_eventid_bits
- new convention for returned values
- itt functions implemented in subsequent patch

v4 -> v5:
- sort the device list by deviceid on device table save
- use defines for shifts and masks
- use abi->dte_esz
- clatify entry sizes for L1 and L2 tables

v3 -> v4:
- use the new proto for its_alloc_device
- compute_next_devid_offset, vgic_its_flush/restore_itt
  become static in this patch
- change in the DTE entry format with the introduction of the
  valid bit and next field width decrease; ittaddr encoded
  on its full range
- fix handle_l1_entry entry handling
- correct vgic_its_table_restore error handling

v2 -> v3:
- fix itt_addr bitmask in vgic_its_restore_dte
- addition of return 0 in vgic_its_restore_ite moved to
  the ITE related patch

v1 -> v2:
- use 8 byte format for DTE and ITE
- support 2 stage format
- remove kvm parameter
- ITT flush/restore moved in a separate patch
- use deviceid indexing
---
 virt/kvm/arm/vgic/vgic-its.c | 194 +++++++++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic.h     |  10 +++
 2 files changed, 199 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index a3ed52a..c5b388d 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/uaccess.h>
+#include <linux/list_sort.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 
@@ -1701,7 +1702,8 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
 	return ret;
 }
 
-u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
+static u32 compute_next_devid_offset(struct list_head *h,
+				     struct its_device *dev)
 {
 	struct its_device *next;
 	u32 next_offset;
@@ -1755,8 +1757,8 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
  * Return: < 0 on error, 0 if last element was identified, 1 otherwise
  * (the last element may not be found on second level tables)
  */
-int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
-		   int start_id, entry_fn_t fn, void *opaque)
+static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
+			  int start_id, entry_fn_t fn, void *opaque)
 {
 	void *entry = kzalloc(esz, GFP_KERNEL);
 	struct kvm *kvm = its->dev->kvm;
@@ -1791,13 +1793,171 @@ int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 	return ret;
 }
 
+static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
+{
+	return -ENXIO;
+}
+
+static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_save_dte - Save a device table entry at a given GPA
+ *
+ * @its: ITS handle
+ * @dev: ITS device
+ * @ptr: GPA
+ */
+static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
+			     gpa_t ptr, int dte_esz)
+{
+	struct kvm *kvm = its->dev->kvm;
+	u64 val, itt_addr_field;
+	u32 next_offset;
+
+	itt_addr_field = dev->itt_addr >> 8;
+	next_offset = compute_next_devid_offset(&its->device_list, dev);
+	val = (1ULL << KVM_ITS_DTE_VALID_SHIFT |
+	       ((u64)next_offset << KVM_ITS_DTE_NEXT_SHIFT) |
+	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
+		(dev->num_eventid_bits - 1));
+	val = cpu_to_le64(val);
+	return kvm_write_guest(kvm, ptr, &val, dte_esz);
+}
+
+/**
+ * vgic_its_restore_dte - restore a device table entry
+ *
+ * @its: its handle
+ * @id: device id the DTE corresponds to
+ * @ptr: kernel VA where the 8 byte DTE is located
+ * @opaque: unused
+ *
+ * Return: < 0 on error, 0 if the dte is the last one, id offset to the
+ * next dte otherwise
+ */
+static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
+				void *ptr, void *opaque)
+{
+	struct its_device *dev;
+	gpa_t itt_addr;
+	u8 num_eventid_bits;
+	u64 entry = *(u64 *)ptr;
+	bool valid;
+	u32 offset;
+	int ret;
+
+	entry = le64_to_cpu(entry);
+
+	valid = entry >> KVM_ITS_DTE_VALID_SHIFT;
+	num_eventid_bits = (entry & KVM_ITS_DTE_SIZE_MASK) + 1;
+	itt_addr = ((entry & KVM_ITS_DTE_ITTADDR_MASK)
+			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
+
+	if (!valid)
+		return 1;
+
+	/* dte entry is valid */
+	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
+
+	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	ret = vgic_its_restore_itt(its, dev);
+	if (ret)
+		return ret;
+
+	return offset;
+}
+
+static int vgic_its_device_cmp(void *priv, struct list_head *a,
+			       struct list_head *b)
+{
+	struct its_device *deva = container_of(a, struct its_device, dev_list);
+	struct its_device *devb = container_of(b, struct its_device, dev_list);
+
+	if (deva->device_id < devb->device_id)
+		return -1;
+	else
+		return 1;
+}
+
 /**
  * vgic_its_save_device_tables - Save the device table and all ITT
  * into guest RAM
+ *
+ * L1/L2 handling is hidden by vgic_its_check_id() helper which directly
+ * returns the GPA of the device entry
  */
 static int vgic_its_save_device_tables(struct vgic_its *its)
 {
-	return -ENXIO;
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	struct its_device *dev;
+	int dte_esz = abi->dte_esz;
+	u64 baser;
+
+	baser = its->baser_device_table;
+
+	list_sort(NULL, &its->device_list, vgic_its_device_cmp);
+
+	list_for_each_entry(dev, &its->device_list, dev_list) {
+		int ret;
+		gpa_t eaddr;
+
+		if (!vgic_its_check_id(its, baser,
+				       dev->device_id, &eaddr))
+			return -EINVAL;
+
+		ret = vgic_its_save_itt(its, dev);
+		if (ret)
+			return ret;
+
+		ret = vgic_its_save_dte(its, dev, eaddr, dte_esz);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/**
+ * handle_l1_dte - callback used for L1 device table entries (2 stage case)
+ *
+ * @its: its handle
+ * @id: index of the entry in the L1 table
+ * @addr: kernel VA
+ * @opaque: unused
+ *
+ * L1 table entries are scanned by steps of 1 entry
+ * Return < 0 if error, 0 if last dte was found when scanning the L2
+ * table, +1 otherwise (meaning next L1 entry must be scanned)
+ */
+static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
+			 void *opaque)
+{
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	int l2_start_id = id * (SZ_64K / abi->dte_esz);
+	u64 entry = *(u64 *)addr;
+	int dte_esz = abi->dte_esz;
+	gpa_t gpa;
+	int ret;
+
+	entry = le64_to_cpu(entry);
+
+	if (!(entry & KVM_ITS_L1E_VALID_MASK))
+		return 1;
+
+	gpa = entry & KVM_ITS_L1E_ADDR_MASK;
+
+	ret = scan_its_table(its, gpa, SZ_64K, dte_esz,
+			     l2_start_id, vgic_its_restore_dte, NULL);
+
+	if (ret <= 0)
+		return ret;
+
+	return 1;
 }
 
 /**
@@ -1806,7 +1966,31 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
  */
 static int vgic_its_restore_device_tables(struct vgic_its *its)
 {
-	return -ENXIO;
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	u64 baser = its->baser_device_table;
+	int l1_esz, ret;
+	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
+	gpa_t l1_gpa;
+
+	if (!(baser & GITS_BASER_VALID))
+		return 0;
+
+	l1_gpa = BASER_ADDRESS(baser);
+
+	if (baser & GITS_BASER_INDIRECT) {
+		l1_esz = GITS_LVL1_ENTRY_SIZE;
+		ret = scan_its_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
+				     handle_l1_dte, NULL);
+	} else {
+		l1_esz = abi->dte_esz;
+		ret = scan_its_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
+				     vgic_its_restore_dte, NULL);
+	}
+
+	if (ret > 0)
+		ret = -EINVAL;
+
+	return ret;
 }
 
 static int vgic_its_save_cte(struct vgic_its *its,
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 58adcae..e896114 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -81,6 +81,16 @@
 #define KVM_ITS_CTE_VALID_MASK		BIT_ULL(63)
 #define KVM_ITS_CTE_RDBASE_SHIFT	16
 #define KVM_ITS_CTE_ICID_MASK		GENMASK_ULL(15, 0)
+#define KVM_ITS_DTE_VALID_SHIFT		63
+#define KVM_ITS_DTE_VALID_MASK		BIT_ULL(63)
+#define KVM_ITS_DTE_NEXT_SHIFT		49
+#define KVM_ITS_DTE_NEXT_MASK		GENMASK_ULL(62, 49)
+#define KVM_ITS_DTE_ITTADDR_SHIFT	5
+#define KVM_ITS_DTE_ITTADDR_MASK	GENMASK_ULL(48, 5)
+#define KVM_ITS_DTE_SIZE_MASK		GENMASK_ULL(4, 0)
+#define KVM_ITS_L1E_VALID_MASK		BIT_ULL(63)
+/* we only support 64 kB translation table page size */
+#define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
 
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
-- 
2.5.5

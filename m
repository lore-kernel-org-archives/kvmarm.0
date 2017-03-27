From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 21/22] KVM: arm64: ITS: Device table save/restore
Date: Mon, 27 Mar 2017 11:31:11 +0200
Message-ID: <1490607072-21610-22-git-send-email-eric.auger@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch flushes the device table entries into guest RAM.
Both flat table and 2 stage tables are supported.  DeviceId
indexing is used.

For each device listed in the device table, we also flush
the translation table using the vgic_its_flush/restore_itt
routines.

On restore, devices are re-allocated and their itte are
re-built.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
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
 virt/kvm/arm/vgic/vgic-its.c | 161 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 156 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 02c0694..a516bbb 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1693,7 +1693,8 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
 	return ret;
 }
 
-u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
+static u32 compute_next_devid_offset(struct list_head *h,
+				     struct its_device *dev)
 {
 	struct list_head *e = &dev->dev_list;
 	struct its_device *next;
@@ -1884,7 +1885,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	return 0;
 }
 
-int vgic_its_flush_itt(struct vgic_its *its, struct its_device *device)
+static int vgic_its_flush_itt(struct vgic_its *its, struct its_device *device)
 {
 	gpa_t base = device->itt_addr;
 	struct its_ite *ite;
@@ -1900,7 +1901,7 @@ int vgic_its_flush_itt(struct vgic_its *its, struct its_device *device)
 	return 0;
 }
 
-int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
+static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 {
 	size_t max_size = BIT_ULL(dev->nb_eventid_bits) * VITS_ESZ;
 	gpa_t base = dev->itt_addr;
@@ -1917,12 +1918,141 @@ int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 }
 
 /**
+ * vgic_its_flush_dte - Flush a device table entry at a given GPA
+ *
+ * @its: ITS handle
+ * @dev: ITS device
+ * @ptr: GPA
+ */
+static int vgic_its_flush_dte(struct vgic_its *its,
+			      struct its_device *dev, gpa_t ptr)
+{
+	struct kvm *kvm = its->dev->kvm;
+	u64 val, itt_addr_field;
+	int ret;
+	u32 next_offset;
+
+	itt_addr_field = dev->itt_addr >> 8;
+	next_offset = compute_next_devid_offset(&its->device_list, dev);
+	val = (1ULL << 63 | ((u64)next_offset << 49) | (itt_addr_field << 5) |
+		(dev->nb_eventid_bits - 1));
+	val = cpu_to_le64(val);
+	ret = kvm_write_guest(kvm, ptr, &val, 8);
+	return ret;
+}
+
+/**
+ * vgic_its_restore_dte - restore a device table entry
+ *
+ * @its: its handle
+ * @id: device id the DTE corresponds to
+ * @ptr: kernel VA where the 8 byte DTE is located
+ * @opaque: unused
+ * @next: offset to the next valid device id
+ *
+ * Return: < 0 on error, 0 otherwise
+ */
+static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
+				void *ptr, void *opaque, u32 *next)
+{
+	struct its_device *dev;
+	gpa_t itt_addr;
+	u8 nb_eventid_bits;
+	u64 entry = *(u64 *)ptr;
+	bool valid;
+	int ret;
+
+	entry = le64_to_cpu(entry);
+
+	valid = entry >> 63;
+	nb_eventid_bits = (entry & GENMASK_ULL(4, 0)) + 1;
+	itt_addr = ((entry & GENMASK_ULL(48, 5)) >> 5) << 8;
+	*next = 1;
+
+	if (!valid)
+		return 0;
+
+	/* dte entry is valid */
+	*next = (entry & GENMASK_ULL(62, 49)) >> 49;
+
+	ret = vgic_its_alloc_device(its, &dev, id,
+				    itt_addr, nb_eventid_bits);
+	if (ret)
+		return ret;
+	ret = vgic_its_restore_itt(its, dev);
+
+	return ret;
+}
+
+/**
  * vgic_its_flush_device_tables - flush the device table and all ITT
  * into guest RAM
+ *
+ * L1/L2 handling is hidden by vgic_its_check_id() helper which directly
+ * returns the GPA of the device entry
  */
 static int vgic_its_flush_device_tables(struct vgic_its *its)
 {
-	return -ENXIO;
+	struct its_device *dev;
+	u64 baser;
+
+	baser = its->baser_device_table;
+
+	list_for_each_entry(dev, &its->device_list, dev_list) {
+		int ret;
+		gpa_t eaddr;
+
+		if (!vgic_its_check_id(its, baser,
+				       dev->device_id, &eaddr))
+			return -EINVAL;
+
+		ret = vgic_its_flush_itt(its, dev);
+		if (ret)
+			return ret;
+
+		ret = vgic_its_flush_dte(its, dev, eaddr);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/**
+ * handle_l1_entry - callback used for L1 entries (2 stage case)
+ *
+ * @its: its handle
+ * @id: id
+ * @addr: kernel VA
+ * @opaque: unused
+ * @next_offset: offset to the next L1 entry: 0 if the last element
+ * was found, 1 otherwise
+ */
+static int handle_l1_entry(struct vgic_its *its, u32 id, void *addr,
+			   void *opaque, u32 *next_offset)
+{
+	int l2_start_id = id * (SZ_64K / GITS_LVL1_ENTRY_SIZE);
+	u64 entry = *(u64 *)addr;
+	gpa_t gpa;
+	int ret;
+
+	entry = le64_to_cpu(entry);
+	*next_offset = 1;
+
+	if (!(entry & BIT_ULL(63)))
+		return 0;
+
+	gpa = entry & GENMASK_ULL(51, 16);
+
+	ret = lookup_table(its, gpa, SZ_64K, 8,
+			    l2_start_id, vgic_its_restore_dte, NULL);
+
+	if (ret == 1) {
+		/* last entry was found in this L2 table */
+		*next_offset = 0;
+		ret = 0;
+	}
+
+	return ret;
 }
 
 /**
@@ -1931,7 +2061,28 @@ static int vgic_its_flush_device_tables(struct vgic_its *its)
  */
 static int vgic_its_restore_device_tables(struct vgic_its *its)
 {
-	return -ENXIO;
+	u64 baser = its->baser_device_table;
+	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
+	int l1_esz = GITS_BASER_ENTRY_SIZE(baser);
+	gpa_t l1_gpa;
+	int ret;
+
+	l1_gpa = BASER_ADDRESS(baser);
+	if (!l1_gpa)
+		return 0;
+
+	if (baser & GITS_BASER_INDIRECT)
+		ret = lookup_table(its, l1_gpa, l1_tbl_size, 8, 0,
+			    	   handle_l1_entry, NULL);
+	else
+		ret = lookup_table(its, l1_gpa, l1_tbl_size, l1_esz,
+				    0, vgic_its_restore_dte, NULL);
+
+	if (ret < 0)
+		return ret;
+
+	/* if last element was not found we have an issue here */
+	return ret ? 0 : -EINVAL;
 }
 
 static int vgic_its_flush_cte(struct vgic_its *its,
-- 
2.5.5

From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 18/19] KVM: arm64: ITS: Device table save/restore
Date: Wed,  8 Feb 2017 12:43:31 +0100
Message-ID: <1486554212-2774-19-git-send-email-eric.auger@redhat.com>
References: <1486554212-2774-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9A74408E9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 06:44:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YWfdKynDkl3k for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Feb 2017 06:44:20 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCC9940962
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 06:44:19 -0500 (EST)
In-Reply-To: <1486554212-2774-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, Prasun.Kapoor@cavium.com
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

v1 -> v2:
- use 8 byte format for DTE and ITE
- support 2 stage format
- remove kvm parameter
- ITT flush/restore moved in a separate patch
- use deviceid indexing
---
 virt/kvm/arm/vgic/vgic-its.c | 145 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index be9e8ed..c1ae85b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1814,6 +1814,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		return ret;
 
 	update_affinity_ite(kvm, ite);
+	return 0;
 }
 
 static int vgic_its_flush_itt(struct vgic_its *its, struct its_device *device)
@@ -1848,12 +1849,137 @@ static int vgic_its_restore_itt(struct vgic_its *its,
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
+	val = (((u64)next_offset << 45) | (itt_addr_field << 5) |
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
+	size_t size;
+	u64 val, *p = (u64 *)ptr;
+	int ret;
+
+	val = *p;
+	val = le64_to_cpu(val);
+
+	size = val & GENMASK_ULL(4, 0);
+	itt_addr = (val & GENMASK_ULL(48, 5)) >> 5;
+	*next = 1;
+
+	if (!itt_addr)
+		return 0;
+
+	/* dte entry is valid */
+	*next = (val & GENMASK_ULL(63, 45)) >> 45;
+
+	ret = vgic_its_alloc_device(its, &dev, id,
+				    itt_addr, size);
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
+		}
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
+	u64 *pe = addr;
+	gpa_t gpa;
+	int l2_start_id = id * (SZ_64K / 8);
+	int ret;
+
+	*pe = le64_to_cpu(*pe);
+	*next_offset = 1;
+
+	if (!(*pe & BIT_ULL(63)))
+		return 0;
+
+	gpa = *pe & GENMASK_ULL(51, 16);
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
@@ -1862,7 +1988,22 @@ static int vgic_its_flush_device_tables(struct vgic_its *its)
  */
 static int vgic_its_restore_device_tables(struct vgic_its *its)
 {
-	return -ENXIO;
+	u64 baser = its->baser_device_table;
+	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
+	int l1_esz = GITS_BASER_ENTRY_SIZE(baser);
+	gpa_t l1_gpa;
+
+	l1_gpa = BASER_ADDRESS(baser);
+	if (!l1_gpa)
+		return 0;
+
+	if (!(baser & GITS_BASER_INDIRECT))
+		return lookup_table(its, l1_gpa, l1_tbl_size, l1_esz,
+				    0, vgic_its_restore_dte, NULL);
+
+	/* two stage table */
+	return lookup_table(its, l1_gpa, l1_tbl_size, 8, 0,
+			    handle_l1_entry, NULL);
 }
 
 static int vgic_its_flush_cte(struct vgic_its *its,
-- 
2.5.5

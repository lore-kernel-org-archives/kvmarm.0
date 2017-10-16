From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 01/11] KVM: arm/arm64: vgic-its: fix return value for
 device table restore
Date: Mon, 16 Oct 2017 17:03:22 +0200
Message-ID: <1508166212-9599-2-git-send-email-eric.auger@redhat.com>
References: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EC9649D25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:02:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hoMez1B4josn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 11:02:54 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C15149D34
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:02:54 -0400 (EDT)
In-Reply-To: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

AT the moment if ITT only contains invalid entries,
vgic_its_restore_itt returns 1 and this is considered as
an an error in vgic_its_restore_dte.

Also in case the device table only contains invalid entries,
the table restore fails and this is not correct.

This patch fully revisits the errror handling while fixing those
2 bugs.

- entry_fn_t now takes a valid output paraleter
- scan_its_table() now returns <= 0 values and output 2 booleans,
  valid and last.
- vgic_its_restore_itt() now returns <= 0 values.
- vgic_its_restore_device_tables() also returns <= 0 values.

With that patch we are able to properly handle the case where
all data are invalid but we still are able to detect the case
where a next entry was referenced by some valid entry and
never found.

Fixes: 57a9a117154c93 (KVM: arm64: vgic-its: Device table save/restore)
Fixes: eff484e0298da5 (KVM: arm64: vgic-its: ITT save and restore)
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: wanghaibin <wanghaibin.wang@huawei.com>

---

need to CC stable

v2 -> v3:
- add comments
- added valid parameter
- vgic_its_restore_itt don't return +1 anymore
- reword the commit message

v1 -> v2:
- if (ret > 0) ret = 0
---
 virt/kvm/arm/vgic/vgic-its.c | 91 ++++++++++++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f51c1e1..fbc3218 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1772,16 +1772,20 @@ static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
 
 /**
  * entry_fn_t - Callback called on a table entry restore path
+ *
  * @its: its handle
  * @id: id of the entry
  * @entry: pointer to the entry
  * @opaque: pointer to an opaque data
+ * @valid: indicates whether valid data is associated to this entry
+ * (the entry itself in case of linear table or entries in the next level,
+ * in case of hierachical tables)
  *
  * Return: < 0 on error, 0 if last element was identified, id offset to next
  * element otherwise
  */
 typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
-			  void *opaque);
+			  void *opaque, bool *valid);
 
 /**
  * scan_its_table - Scan a contiguous table in guest RAM and applies a function
@@ -1794,29 +1798,34 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
  * @start_id: the ID of the first entry in the table
  * (non zero for 2d level tables)
  * @fn: function to apply on each entry
+ * @opaque: opaque data passed to @fn
+ * @valid: indicates whether the table contains any valid data
+ * @last: returns whether the last valid entry was decoded
  *
- * Return: < 0 on error, 0 if last element was identified, 1 otherwise
- * (the last element may not be found on second level tables)
+ * Return: < 0 on error, 0 on success
  */
 static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
-			  int start_id, entry_fn_t fn, void *opaque)
+			  int start_id, entry_fn_t fn, void *opaque,
+			  bool *valid, bool *last)
 {
 	void *entry = kzalloc(esz, GFP_KERNEL);
 	struct kvm *kvm = its->dev->kvm;
 	unsigned long len = size;
 	int id = start_id;
 	gpa_t gpa = base;
+	int next_offset = 0;
 	int ret;
 
 	while (len > 0) {
-		int next_offset;
 		size_t byte_offset;
+		bool entry_valid;
 
 		ret = kvm_read_guest(kvm, gpa, entry, esz);
 		if (ret)
 			goto out;
 
-		next_offset = fn(its, id, entry, opaque);
+		next_offset = fn(its, id, entry, opaque, &entry_valid);
+		*valid |= entry_valid;
 		if (next_offset <= 0) {
 			ret = next_offset;
 			goto out;
@@ -1827,9 +1836,15 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 		gpa += byte_offset;
 		len -= byte_offset;
 	}
-	ret =  1;
-
+	/*
+	 * the table lookup was completed without identifying the
+	 * last valid entry (ie. next_offset > 0).
+	 */
+	ret = 0;
 out:
+	if (!next_offset)
+		*last = true;
+
 	kfree(entry);
 	return ret;
 }
@@ -1854,12 +1869,14 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 
 /**
  * vgic_its_restore_ite - restore an interrupt translation entry
+ *
  * @event_id: id used for indexing
  * @ptr: pointer to the ITE entry
  * @opaque: pointer to the its_device
+ * @valid: indicates whether the ite is valid
  */
 static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
-				void *ptr, void *opaque)
+				void *ptr, void *opaque, bool *valid)
 {
 	struct its_device *dev = (struct its_device *)opaque;
 	struct its_collection *collection;
@@ -1879,7 +1896,9 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	coll_id = val & KVM_ITS_ITE_ICID_MASK;
 	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
 
-	if (!lpi_id)
+	*valid = !!lpi_id;
+
+	if (!*valid)
 		return 1; /* invalid entry, no choice but to scan next entry */
 
 	if (lpi_id < VGIC_MIN_LPI)
@@ -1940,6 +1959,14 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 	return 0;
 }
 
+/**
+ * vgic_its_restore_itt - restore the ITT of a device
+ *
+ * @its: its handle
+ * @dev: device handle
+ *
+ * Return 0 on success, < 0 on error
+ */
 static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
@@ -1947,9 +1974,15 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 	int ret;
 	int ite_esz = abi->ite_esz;
 	size_t max_size = BIT_ULL(dev->num_eventid_bits) * ite_esz;
+	bool valid = false, last = false;
 
 	ret = scan_its_table(its, base, max_size, ite_esz, 0,
-			     vgic_its_restore_ite, dev);
+			     vgic_its_restore_ite, dev, &valid, &last);
+
+	if (!ret && valid && !last) {
+		/* a next element was referenced but not found */
+		return -EINVAL;
+	}
 
 	return ret;
 }
@@ -1985,29 +2018,29 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
  * @id: device id the DTE corresponds to
  * @ptr: kernel VA where the 8 byte DTE is located
  * @opaque: unused
+ * @valid: indicates whether the dte is valid
  *
  * Return: < 0 on error, 0 if the dte is the last one, id offset to the
  * next dte otherwise
  */
 static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
-				void *ptr, void *opaque)
+				void *ptr, void *opaque, bool *valid)
 {
 	struct its_device *dev;
 	gpa_t itt_addr;
 	u8 num_eventid_bits;
 	u64 entry = *(u64 *)ptr;
-	bool valid;
 	u32 offset;
 	int ret;
 
 	entry = le64_to_cpu(entry);
 
-	valid = entry >> KVM_ITS_DTE_VALID_SHIFT;
+	*valid = entry >> KVM_ITS_DTE_VALID_SHIFT;
 	num_eventid_bits = (entry & KVM_ITS_DTE_SIZE_MASK) + 1;
 	itt_addr = ((entry & KVM_ITS_DTE_ITTADDR_MASK)
 			>> KVM_ITS_DTE_ITTADDR_SHIFT) << 8;
 
-	if (!valid)
+	if (!*valid)
 		return 1;
 
 	/* dte entry is valid */
@@ -2082,13 +2115,14 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
  * @id: index of the entry in the L1 table
  * @addr: kernel VA
  * @opaque: unused
+ * @valid: indicates whether any dte entry was found
  *
  * L1 table entries are scanned by steps of 1 entry
  * Return < 0 if error, 0 if last dte was found when scanning the L2
  * table, +1 otherwise (meaning next L1 entry must be scanned)
  */
 static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
-			 void *opaque)
+			 void *opaque, bool *valid)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	int l2_start_id = id * (SZ_64K / abi->dte_esz);
@@ -2096,6 +2130,7 @@ static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
 	int dte_esz = abi->dte_esz;
 	gpa_t gpa;
 	int ret;
+	bool last;
 
 	entry = le64_to_cpu(entry);
 
@@ -2105,12 +2140,17 @@ static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
 	gpa = entry & KVM_ITS_L1E_ADDR_MASK;
 
 	ret = scan_its_table(its, gpa, SZ_64K, dte_esz,
-			     l2_start_id, vgic_its_restore_dte, NULL);
+			     l2_start_id, vgic_its_restore_dte, NULL,
+			     valid, &last);
 
-	if (ret <= 0)
-		return ret;
+	/*
+	 * if the last dte has not been found in this L2 table, we
+	 * need to scan the next L1 entry
+	 */
+	if (!ret && !last)
+		return 1;
 
-	return 1;
+	return ret;
 }
 
 /**
@@ -2124,6 +2164,7 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	int l1_esz, ret;
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 	gpa_t l1_gpa;
+	bool valid = false, last = false;
 
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
@@ -2133,15 +2174,17 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (baser & GITS_BASER_INDIRECT) {
 		l1_esz = GITS_LVL1_ENTRY_SIZE;
 		ret = scan_its_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
-				     handle_l1_dte, NULL);
+				     handle_l1_dte, NULL, &valid, &last);
 	} else {
 		l1_esz = abi->dte_esz;
 		ret = scan_its_table(its, l1_gpa, l1_tbl_size, l1_esz, 0,
-				     vgic_its_restore_dte, NULL);
+				     vgic_its_restore_dte, NULL, &valid, &last);
 	}
 
-	if (ret > 0)
-		ret = -EINVAL;
+	if (!ret && valid && !last) {
+		/* a next element was referenced but not found */
+		return -EINVAL;
+	}
 
 	return ret;
 }
-- 
2.5.5

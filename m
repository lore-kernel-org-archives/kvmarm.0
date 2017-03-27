From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 17/22] KVM: arm64: ITS: Add infrastructure for table lookup
Date: Mon, 27 Mar 2017 11:31:07 +0200
Message-ID: <1490607072-21610-18-git-send-email-eric.auger@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C135F40BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:30:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SSZ+W6eFlaR2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 05:30:49 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B865140A86
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:30:49 -0400 (EDT)
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

Add a generic lookup_table() helper whose role consists in
scanning a contiguous table located in guest RAM and applying
a callback on each entry. Entries can be handled as linked lists
since the callback may return an offset to the next entry and
also tell that an entry is the last one.

Helper functions also are added to compute the device/event ID
offset to the next DTE/ITE.

compute_next_devid_offset, compute_next_eventid_offset and
lookup_table will become static in subsequent patches

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- remove static to avoid compilation warning
- correct size computation in looup_table()
- defines now encode the number of bits used for devid and eventid offsets
- use BIT() - 1 to encode the max offets
---
 virt/kvm/arm/vgic/vgic-its.c | 107 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 7364b7d..8eaeba4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -184,6 +184,8 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
 #define VITS_ESZ 8
 #define VITS_TYPER_IDBITS 16
 #define VITS_TYPER_DEVBITS 16
+#define VITS_DTE_MAX_DEVID_OFFSET	(BIT(14) - 1)
+#define VITS_ITE_MAX_EVENTID_OFFSET	(BIT(16) - 1)
 
 /*
  * Finds and returns a collection in the ITS collection table.
@@ -1686,6 +1688,111 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
 	return ret;
 }
 
+u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
+{
+	struct list_head *e = &dev->dev_list;
+	struct its_device *next;
+	u32 next_offset;
+
+	if (e->next == h)
+		return 0;
+	next = list_entry(e->next, struct its_device, dev_list);
+	next_offset = next->device_id - dev->device_id;
+
+	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
+}
+
+u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
+{
+	struct list_head *e = &ite->ite_list;
+	struct its_ite *next;
+	u32 next_offset;
+
+	if (e->next == h)
+		return 0;
+	next = list_entry(e->next, struct its_ite, ite_list);
+	next_offset = next->event_id - ite->event_id;
+
+	return min_t(u32, next_offset, VITS_ITE_MAX_EVENTID_OFFSET);
+}
+
+/**
+ * entry_fn_t - Callback called on a table entry restore path
+ * @its: its handle
+ * @id: id of the entry
+ * @addr: kernel VA of the entry
+ * @opaque: pointer to an opaque data
+ * @next_offset: minimal ID offset to the next entry. 0 if this
+ * entry is the last one, 1 if the entry is invalid, >= 1 if an
+ * entry's next_offset field was truly decoded
+ *
+ * Return: < 0 on error, 0 otherwise
+ */
+typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *addr,
+			  void *opaque, u32 *next_offset);
+
+/**
+ * lookup_table - scans a contiguous table in guest RAM and applies a function
+ * to each entry
+ *
+ * @its: its handle
+ * @base: base gpa of the table
+ * @size: size of the table in bytes
+ * @esz: entry size in bytes
+ * @start_id: first entry's ID
+ * @fn: function to apply on each entry
+ *
+ * Return: < 0 on error, 1 if last element identified, 0 otherwise
+ */
+int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
+		 int start_id, entry_fn_t fn, void *opaque)
+{
+	gpa_t gpa = base, top = base + size - 1;
+	unsigned long len = size;
+	int ret, seg, offset = offset_in_page(gpa);
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	u32 id = start_id + (gpa - base)/esz;
+	struct kvm *kvm = its->dev->kvm;
+	kvm_pfn_t pfn;
+
+	while ((seg = next_segment(len, offset)) != 0) {
+		u32 next_offset;
+		bool writeable;
+		void *addr;
+
+		pfn = gfn_to_pfn_prot(kvm, gfn, true, &writeable);
+		if (is_error_noslot_pfn(pfn))
+			return -EINVAL;
+		addr = phys_to_virt((u64)pfn << PAGE_SHIFT);
+		addr += offset;
+
+		while (seg > 0) {
+			size_t byte_offset;
+
+			ret = fn(its, id, addr, opaque, &next_offset);
+			if (ret < 0 || (!ret && !next_offset))
+				goto out;
+
+			byte_offset = next_offset * esz;
+
+			id += next_offset;
+			gpa += byte_offset;
+			addr += byte_offset;
+			seg -= byte_offset;
+		}
+		kvm_release_pfn_clean(pfn);
+
+		len = top - gpa + 1;
+		offset = offset_in_page(gpa);
+		gfn = gpa >> PAGE_SHIFT;
+		id = start_id + (gpa - base)/esz;
+	}
+	return 0;
+out:
+	kvm_release_pfn_clean(pfn);
+	return (ret < 0 ? ret : 1);
+}
+
 /**
  * vgic_its_flush_pending_tables - Flush the pending tables into guest RAM
  */
-- 
2.5.5

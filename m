From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 18/24] KVM: arm64: vgic-its: Add infrastructure for table lookup
Date: Thu,  4 May 2017 13:44:38 +0200
Message-ID: <1493898284-29504-19-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Add a generic scan_its_table() helper whose role consists in
scanning a contiguous table located in guest RAM and applying
a callback on each entry. Entries can be handled as linked lists
since the callback may return an id offset to the next entry and
also indicate whether the entry is the last one.

Helper functions also are added to compute the device/event ID
offset to the next DTE/ITE.

compute_next_devid_offset, compute_next_eventid_offset and
scan_table will become static in subsequent patches

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v5 -> v6:
- add comments about 2d level table scan as suggested by Christoffer
- s/lookup_table/scan_its_table
- scan_table now return 0 if last elt found and +1 if not found
- use int for id
- simplify compute_next_devid/eventid_offset

v4 -> v5:
- use kvm_read_guest

v3 -> v4:
- remove static to avoid compilation warning
- correct size computation in looup_table()
- defines now encode the number of bits used for devid and eventid offsets
- use BIT() - 1 to encode the max offets
---
 virt/kvm/arm/vgic/vgic-its.c | 92 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index ea8eb6a..1db7e38 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -221,6 +221,8 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
 
 #define VITS_TYPER_IDBITS 16
 #define VITS_TYPER_DEVBITS 16
+#define VITS_DTE_MAX_DEVID_OFFSET	(BIT(14) - 1)
+#define VITS_ITE_MAX_EVENTID_OFFSET	(BIT(16) - 1)
 
 /*
  * Finds and returns a collection in the ITS collection table.
@@ -1694,6 +1696,96 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
 	return ret;
 }
 
+u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
+{
+	struct its_device *next;
+	u32 next_offset;
+
+	if (list_is_last(&dev->dev_list, h))
+		return 0;
+	next = list_next_entry(dev, dev_list);
+	next_offset = next->device_id - dev->device_id;
+
+	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
+}
+
+u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
+{
+	struct its_ite *next;
+	u32 next_offset;
+
+	if (list_is_last(&ite->ite_list, h))
+		return 0;
+	next = list_next_entry(ite, ite_list);
+	next_offset = next->event_id - ite->event_id;
+
+	return min_t(u32, next_offset, VITS_ITE_MAX_EVENTID_OFFSET);
+}
+
+/**
+ * entry_fn_t - Callback called on a table entry restore path
+ * @its: its handle
+ * @id: id of the entry
+ * @entry: pointer to the entry
+ * @opaque: pointer to an opaque data
+ *
+ * Return: < 0 on error, 0 if last element was identified, id offset to next
+ * element otherwise
+ */
+typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
+			  void *opaque);
+
+/**
+ * scan_its_table - Scan a contiguous table in guest RAM and applies a function
+ * to each entry
+ *
+ * @its: its handle
+ * @base: base gpa of the table
+ * @size: size of the table in bytes
+ * @esz: entry size in bytes
+ * @start_id: the ID of the first entry in the table
+ * (non zero for 2d level tables)
+ * @fn: function to apply on each entry
+ *
+ * Return: < 0 on error, 0 if last element was identified, 1 otherwise
+ * (the last element may not be found on second level tables)
+ */
+int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
+		   int start_id, entry_fn_t fn, void *opaque)
+{
+	void *entry = kzalloc(esz, GFP_KERNEL);
+	struct kvm *kvm = its->dev->kvm;
+	unsigned long len = size;
+	int id = start_id;
+	gpa_t gpa = base;
+	int ret;
+
+	while (len > 0) {
+		int next_offset;
+		size_t byte_offset;
+
+		ret = kvm_read_guest(kvm, gpa, entry, esz);
+		if (ret)
+			goto out;
+
+		next_offset = fn(its, id, entry, opaque);
+		if (next_offset <= 0) {
+			ret = next_offset;
+			goto out;
+		}
+
+		byte_offset = next_offset * esz;
+		id += next_offset;
+		gpa += byte_offset;
+		len -= byte_offset;
+	}
+	ret =  1;
+
+out:
+	kfree(entry);
+	return ret;
+}
+
 /**
  * vgic_its_save_device_tables - Save the device table and all ITT
  * into guest RAM
-- 
2.5.5

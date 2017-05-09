From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 20/37] KVM: arm64: vgic-its: Add infrastructure for table lookup
Date: Tue,  9 May 2017 12:44:49 +0200
Message-ID: <20170509104506.30929-21-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3C940C8B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id llFZ2QnyeuGC for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:22 -0400 (EDT)
Received: from mail-qk0-f171.google.com (mail-qk0-f171.google.com
 [209.85.220.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F11A340C49
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:16 -0400 (EDT)
Received: by mail-qk0-f171.google.com with SMTP id k74so75282203qke.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:32 -0700 (PDT)
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
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 92 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 737ba3c..d5c0057 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -244,6 +244,8 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
 
 #define VITS_TYPER_IDBITS 16
 #define VITS_TYPER_DEVBITS 16
+#define VITS_DTE_MAX_DEVID_OFFSET	(BIT(14) - 1)
+#define VITS_ITE_MAX_EVENTID_OFFSET	(BIT(16) - 1)
 
 /*
  * Finds and returns a collection in the ITS collection table.
@@ -1728,6 +1730,96 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
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
2.9.0

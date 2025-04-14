Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8735725D8E0
	for <kvmarm@lists.linux.dev>; Mon, 14 Apr 2025 11:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744629356; cv=none; b=OzrqwzxlqKfENX3Nw2Vc+FypwXyu+gl8nAo3qCEzBAKby7xMJHE0gcmt+GXO/nH98LjU96w1/aCfBNg6cBOW10u7C/MucWQXTHcJtGrYYwQoyl2w0ohOgc9MKkKogiG8zEIP+Jzty6EKxBDkwvxxTo4Z6QVhCRniG/D/UI+W3LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744629356; c=relaxed/simple;
	bh=VE85U9XhRyJ3HDJBsRenBpLiRI9p6WK5oqp4jTT8pII=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iscu53y6x+Tcc2Jx9KFPB39E70/s2Si/kdjVB1+tL2BHT5TaWCTGG8UaZLtIMm4mVMV2ZAty2ovTt6CG+kkGuOlNeSwqFQGZKRKgj1/RLcTVQYEna+inbkal3yrf4pqCgRPZjw5AbiDui3sVfFD6H0E6WTCEvOv22Yss1D9DR0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=iPt2xKzA; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="iPt2xKzA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1744629354; x=1776165354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uE1Wytg16lMT8ifH4+9KDLY0YnjOJXle533c9rO8+PM=;
  b=iPt2xKzAqWFszYFzzJYWXmJnBHB8T0TRQGTY8gQKMnNh109ES/zY1iy5
   uMta6nOgCe53SYMlmvpSn3W3S2HtlgkQ0ibszgPYRpT2RzHPaTP2Ebu6l
   TL5TkvroSqcEjKAT0KD7nNjr4ctzQ2s9yGtsfj1mVpnQMHsqea766IBQ+
   g=;
X-IronPort-AV: E=Sophos;i="6.15,212,1739836800"; 
   d="scan'208";a="83450314"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 11:15:51 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:51553]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.0.201:2525] with esmtp (Farcaster)
 id e0e345b7-4395-46d2-a344-14a1cfd2ffd8; Mon, 14 Apr 2025 11:15:51 +0000 (UTC)
X-Farcaster-Flow-ID: e0e345b7-4395-46d2-a344-14a1cfd2ffd8
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 14 Apr 2025 11:15:50 +0000
Received: from u94b036d6357a55.ant.amazon.com.com (10.106.82.24) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 14 Apr 2025 11:15:44 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<maz@kernel.org>, <oliver.upton@linux.dev>
CC: <joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<eric.auger@redhat.com>, <andre.przywara@arm.com>, <will@kernel.org>,
	<dwmw@amazon.co.uk>, <ilstam@amazon.com>, <jgrall@amazon.co.uk>,
	<ugurus@amazon.co.uk>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 1/1] KVM: arm64: vgic-its: Add flag for saving ITTs in userspace buffer
Date: Mon, 14 Apr 2025 12:12:44 +0100
Message-ID: <20250414111244.153528-2-ilstam@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250414111244.153528-1-ilstam@amazon.com>
References: <20250414111244.153528-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)

When running a protected VM on top of pKVM or another lowvisor the EL1
host kernel cannot access guest memory in order to save/restore the ITT
tables for the KVM_DEV_ARM_ITS_SAVE_TABLES and
KVM_DEV_ARM_ITS_RESTORE_TABLES operations.

Introduce a new KVM_DEV_ARM_ITS_ITT_UBUF flag that when set instructs
the vITS to serialize the ITTs into a buffer provided by userspace or
restore them from it. The struct kvm_device_attr passed to
KVM_DEV_ARM_ITS_{SAVE,RESTORE}_TABLES has a currently unused 'addr'
field. Use that field to pass the buffer address. Also use the upper
32-bits of 'attr' from the same struct for the buffer size.

The format of the blob stored in the buffer is the following. There is a
64-bit ITT start marker which embeds the device ID owning the ITT. The
start marker is followed by 64-bit ITEs stored using the existing ITS
Table ABI REV0 with the 'next' field being replaced by an 'event_id'
field which stores the event ID rather than an offset. An end marker
indicates the end of the ITT and is followed by the start marker for the
ITT of the next device.

This is an RFC patch, the ABI is not documented yet.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/arm64/include/uapi/asm/kvm.h |   5 +
 arch/arm64/kvm/vgic/vgic-its.c    | 213 +++++++++++++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.h        |   4 +
 include/kvm/arm_vgic.h            |  11 ++
 4 files changed, 227 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b57f28c9d60f..45edb34ec595 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -367,6 +367,11 @@ struct kvm_arm_counter_offset {
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
+/*
+ * Flags for KVM_DEV_ARM_ITS_{SAVE,RESTORE}_TABLES
+ */
+#define   KVM_DEV_ARM_ITS_ITT_UBUF           (1ULL << 0)
+
 #define KVM_DEV_ARM_VGIC_NR_IRQS_SHIFT 12
 #define KVM_DEV_ARM_VGIC_NR_IRQS_MASK                                          \
 	((1 << KVM_DEV_ARM_VGIC_NR_IRQS_SHIFT) - 1)
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index b8a78a678aa1..142e663eb75d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2225,6 +2225,62 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 	return 1;
 }
 
+static int vgic_its_ubuf_append_entry(struct vgic_its *its, u64 entry)
+{
+	entry = cpu_to_le64(entry);
+
+	if (its->itt_ubuf.slot_next > its->itt_ubuf.slot_max)
+		return -ENOMEM;
+
+	if (copy_to_user(&its->itt_ubuf.ubuf[its->itt_ubuf.slot_next], &entry, sizeof(entry)))
+		return -EFAULT;
+
+	its->itt_ubuf.slot_next++;
+	return 0;
+}
+
+static int vgic_its_save_itt_ubuf(struct vgic_its *its, struct its_device *device) {
+	int ret = 0;
+	u64 val;
+	struct its_ite *ite;
+
+	/*
+	 * Write the start marker. Here we abuse the ITS Table ABI REV0. A
+	 * valid physical LPI has an ID of 8192. We can use numbers lower than
+	 * that for different types of entries such as ITT start/end markers.
+	 * The high 16-bits of the entry contain the device ID.
+	 */
+	val = ((u64)device->device_id << KVM_ITS_ITE_NEXT_SHIFT) |
+	      ((u64)KVM_ITS_ITT_START_MARKER << KVM_ITS_ITE_PINTID_SHIFT);
+	if ((ret = vgic_its_ubuf_append_entry(its, val)))
+		return ret;
+
+	list_for_each_entry(ite, &device->itt_head, ite_list) {
+		/*
+		 * If an LPI carries the HW bit, this means that this
+		 * interrupt is controlled by GICv4, and we do not
+		 * have direct access to that state without GICv4.1.
+		 * Let's simply fail the save operation...
+		 */
+		if (ite->irq->hw && !kvm_vgic_global_state.has_gicv4_1)
+			return -EACCES;
+
+		val = ((u64)ite->event_id << KVM_ITS_ITE_NEXT_SHIFT) |
+		       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
+			ite->collection->collection_id;
+		if ((ret = vgic_its_ubuf_append_entry(its, val)))
+			return ret;
+	}
+
+	/* Write the end marker */
+	val = ((u64)device->device_id << KVM_ITS_ITE_NEXT_SHIFT) |
+	      ((u64)KVM_ITS_ITT_END_MARKER << KVM_ITS_ITE_PINTID_SHIFT);
+	if ((ret = vgic_its_ubuf_append_entry(its, val)))
+		return ret;
+
+	return ret;
+}
+
 /**
  * vgic_its_save_ite - Save an interrupt translation entry at @gpa
  */
@@ -2327,6 +2383,9 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 
 	list_sort(NULL, &device->itt_head, vgic_its_ite_cmp);
 
+	if (its->itt_ubuf.must_be_used)
+		return vgic_its_save_itt_ubuf(its, device);
+
 	list_for_each_entry(ite, &device->itt_head, ite_list) {
 		gpa_t gpa = base + ite->event_id * ite_esz;
 
@@ -2494,10 +2553,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
-	ret = vgic_its_restore_itt(its, dev);
-	if (ret) {
-		vgic_its_free_device(its->dev->kvm, its, dev, false);
-		return ret;
+	if (!its->itt_ubuf.must_be_used) {
+		ret = vgic_its_restore_itt(its, dev);
+		if (ret) {
+			vgic_its_free_device(its->dev->kvm, its, dev, false);
+			return ret;
+		}
 	}
 
 	return offset;
@@ -2776,6 +2837,112 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
 	return vgic_its_save_collection_table(its);
 }
 
+static int vgic_its_ubuf_pop_entry(struct vgic_its *its, u64 *entry)
+{
+	if (!entry)
+		return -EINVAL;
+
+	if (its->itt_ubuf.slot_next > its->itt_ubuf.slot_max)
+		return -ENOMEM;
+
+	if (copy_from_user(entry, &its->itt_ubuf.ubuf[its->itt_ubuf.slot_next], sizeof(*entry)))
+		return -EFAULT;
+
+	its->itt_ubuf.slot_next++;
+
+	*entry = le64_to_cpu(*entry);
+
+	return 0;
+}
+
+static int vgic_its_restore_itt_ubuf(struct vgic_its *its, struct its_device *device)
+{
+	u64 entry, device_id, type, event_id;
+	bool found_end = false;
+	int ret;
+
+	/* Confirm there is a start marker matching the device ID */
+	ret = vgic_its_ubuf_pop_entry(its, &entry);
+	if (ret)
+		return ret;
+
+	/*
+	 * See the comment in vgic_its_save_itt_ubuf() explaining how the ITS
+	 * Table ABI REV0 is abused.
+	 */
+	device_id = entry >> KVM_ITS_ITE_NEXT_SHIFT;
+	type = (entry & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
+
+	if (type != KVM_ITS_ITT_START_MARKER) {
+		printk(KERN_WARNING "Failed to restore vGIC interrupt translation entry: did not find start marker (device_id=%u)",
+		       device->device_id);
+		return -EBADF;
+	}
+	if (device_id != device->device_id) {
+		printk(KERN_WARNING "Failed to restore vGIC interrupt translation entry: found start marker for device_id=%llu instead of device_id=%u",
+		       device_id, device->device_id);
+		return -ENODEV;
+	}
+
+	while (its->itt_ubuf.slot_next <= its->itt_ubuf.slot_max) {
+		ret = vgic_its_ubuf_pop_entry(its, &entry);
+		if (ret)
+			return ret;
+
+		/*
+		 * Is this an ITE or is it an end marker?
+		 */
+		type = (entry & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
+		if (type == KVM_ITS_ITT_END_MARKER) {
+			found_end = true;
+			device_id = entry >> KVM_ITS_ITE_NEXT_SHIFT;
+			if (device_id != device->device_id)
+				return -ENODEV;
+			break;
+		}
+
+		event_id = entry >> KVM_ITS_ITE_NEXT_SHIFT;
+		/*
+		 * Set the 'next' field of the entry to 0 which is a valid
+		 * value for vgic_its_restore_ite().
+		 */
+		entry &= ~KVM_ITS_ITE_NEXT_MASK;
+		ret = vgic_its_restore_ite(its, event_id, &entry, device);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (!found_end)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int vgic_its_restore_itt_all_ubuf(struct vgic_its *its)
+{
+	int ret;
+	struct its_device *dev;
+
+	/*
+	 * The list is sorted in vgic_its_save_device_tables() before
+	 * serialization, therefore we expect the ITTs to be sorted in the blob.
+	 */
+	list_sort(NULL, &its->device_list, vgic_its_device_cmp);
+
+	list_for_each_entry(dev, &its->device_list, dev_list) {
+		ret = vgic_its_restore_itt_ubuf(its, dev);
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		vgic_its_free_device(its->dev->kvm, its, dev, false);
+		return ret;
+	}
+
+	return 0;
+}
+
 /**
  * vgic_its_restore_tables_v0 - Restore the ITS tables from guest RAM
  * to internal data structs according to V0 ABI
@@ -2789,7 +2956,14 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
 	if (ret)
 		return ret;
 
-	return vgic_its_restore_device_tables(its);
+	ret = vgic_its_restore_device_tables(its);
+	if (ret)
+		return ret;
+
+	if (its->itt_ubuf.must_be_used)
+		return vgic_its_restore_itt_all_ubuf(its);
+
+	return 0;
 }
 
 static int vgic_its_commit_v0(struct vgic_its *its)
@@ -2860,7 +3034,11 @@ static int vgic_its_ctlr(struct kvm_device *dev,
 	struct kvm *kvm = dev->kvm;
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	int ret = 0;
-	u64 attrval = attr->attr;
+	/*
+	 * The low 32 bits are used for the attribute, whereas the high 32 bits
+	 * have a special meaning for KVM_DEV_ARM_ITS_{SAVE,RESTORE}_TABLES
+	 */
+	u64 attrval = attr->attr & 0xffffffff;
 	bool need_itslock = true;
 
 	switch (attrval) {
@@ -2886,6 +3064,29 @@ static int vgic_its_ctlr(struct kvm_device *dev,
 		return -EBUSY;
 	}
 
+	if (attrval == KVM_DEV_ARM_ITS_SAVE_TABLES || attrval == KVM_DEV_ARM_ITS_RESTORE_TABLES) {
+		if (attr->flags & KVM_DEV_ARM_ITS_ITT_UBUF) {
+			u32 buf_size = attr->attr >> 32;
+			u32 num_slots = buf_size / sizeof(u64);
+			if (num_slots == 0)
+				return -ENOSPC;
+
+			its->itt_ubuf.must_be_used = true;
+			its->itt_ubuf.ubuf = (u64 *)attr->addr;
+			its->itt_ubuf.slot_next = 0;
+			its->itt_ubuf.slot_max = num_slots - 1;
+
+			if (attrval == KVM_DEV_ARM_ITS_SAVE_TABLES) {
+				/* Zero out the first entry */
+				u64 invalid = 0;
+				if (copy_to_user(&its->itt_ubuf.ubuf[0], &invalid, sizeof(invalid)))
+					return -EFAULT;
+			}
+		} else {
+			its->itt_ubuf.must_be_used = false;
+		}
+	}
+
 	switch (attrval) {
 	case KVM_DEV_ARM_ITS_CTRL_RESET:
 		vgic_its_reset(kvm, its);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 1d0e8bfdc676..f5dac01a9a27 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -76,6 +76,7 @@ static inline bool vgic_irq_is_lpi(u32 const intid)
 #define KVM_ITS_CTE_RDBASE_SHIFT	16
 #define KVM_ITS_CTE_ICID_MASK		GENMASK_ULL(15, 0)
 #define KVM_ITS_ITE_NEXT_SHIFT		48
+#define KVM_ITS_ITE_NEXT_MASK		GENMASK_ULL(63, 48)
 #define KVM_ITS_ITE_PINTID_SHIFT	16
 #define KVM_ITS_ITE_PINTID_MASK		GENMASK_ULL(47, 16)
 #define KVM_ITS_ITE_ICID_MASK		GENMASK_ULL(15, 0)
@@ -90,6 +91,9 @@ static inline bool vgic_irq_is_lpi(u32 const intid)
 /* we only support 64 kB translation table page size */
 #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
 
+#define KVM_ITS_ITT_START_MARKER        1
+#define KVM_ITS_ITT_END_MARKER          2
+
 #define KVM_VGIC_V3_RDIST_INDEX_MASK	GENMASK_ULL(11, 0)
 #define KVM_VGIC_V3_RDIST_FLAGS_MASK	GENMASK_ULL(15, 12)
 #define KVM_VGIC_V3_RDIST_FLAGS_SHIFT	12
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8cef0b7767e8..43e1f47a4c7a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -190,6 +190,17 @@ struct vgic_its {
 	struct list_head	device_list;
 	struct list_head	collection_list;
 	struct list_head	inval_dte_list;
+
+	/*
+	 * Userspace buffer to be used by KVM_DEV_ARM_ITS_{SAVE,RESTORE}_TABLES
+	 * optionally for saving/restoring the ITTs of all device tables.
+	 */
+	struct {
+		bool must_be_used;
+		u64 __user *ubuf;
+		size_t slot_max;
+		size_t slot_next;
+	} itt_ubuf;
 };
 
 struct vgic_state_iter;
-- 
2.47.1


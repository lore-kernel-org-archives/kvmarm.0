Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282494EB86E
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166353; cv=none; b=iRe9HJAj388xeNhBEGddz7fIdVTgtAnQNtjJjvnbEbScsO+Q59u0cCdEViBiWrk4UTTvuLzL5BmR0Ow9XkIX5hIpOl7IYLCsRNRknY+UNSA+fTe4F/ghD3ZT7fZM//5io4UCV5DeM85jk7uvHC0Qm2xNyGJu/ynt0KqNaTi5iUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166353; c=relaxed/simple;
	bh=yDSHUBzCaBeONkdYZiDJOzGDam4JaDg4CXm4Hggjv70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NloLtfWHYSMeFMXFYtMA9IiY8akT3Ii6YLTl8egEtsLDspU/sNM6tUp5XO/qrGk7BwjHlO/4VUpYPOpsgPsZLDizGrrGiDFydYvDVhrsYO/7wdiW8rvCfR1DtOzeitqcSm5f48/HnyDTLRXmUmuLxE6HXemVYme0Upvwji35Foc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HAJ7OYEZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HAJ7OYEZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 686891516;
	Fri, 16 Oct 2026 08:59:08 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0D753F673;
	Fri, 16 Oct 2026 08:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166351; bh=yDSHUBzCaBeONkdYZiDJOzGDam4JaDg4CXm4Hggjv70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAJ7OYEZH9MvI9YGO4nwjMZKV6TbqYDCXBdzGece4ni+Vcn+Lmgx6dy8JRhY3vmBF
	 gyVg1+sjNiBK8qfpfEtE/TPYJGmMBRkuNuTtrogCK2R8w2AEkz8zeB3EWbyoJG6qRi
	 zZ5r5TkqfzKEl4ZlvEUMwO9yLKvcKYxhWLSWM5EI=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH 08/16] KVM: arm64: gic-v5: Add ITS translation cache maintenance
Date: Fri, 16 Oct 2026 16:57:33 +0100
Message-Id: <20261016155741.979985-9-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016155741.979985-1-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Walking the guest DT and ITTs on every MSI or ITS event is unnecessary
once a DeviceID/EventID pair has been resolved. Add a small hash table
to cache resolved translations as a disposable acceleration structure
which avoids iterating over guest memory whenever possible.

Cache entries hold references to the resolved struct vgic_irq objects
stored in the VM-wide LPI xarray. Lookups take an IRQ reference before
returning an entry to the caller, and cache eviction drops the
reference held by the cache. This keeps the cache tied to the normal
LPI object lifetime instead of storing raw LPI numbers.

Invalidate cached translations when the table configuration or guest
invalidation commands make them stale. Changes to DT_BASER or DT_CFGR
drop the entire cache, while writes of unchanged values leave it intact.
INV_EVENTR removes either one event or the events covered by an L1 ITT
entry, and INV_DEVICER removes the translations covered by either an L2
DT entry or an L1 DT entry.

The cache is not part of any userspace ABI and is never authoritative:
entries can always be rebuilt from guest memory on the next lookup.

The vgic_irq objects for LPIs track valid translations rather than
mirror interrupt state. Mirroring that state would require querying
the GIC on every guest exit. Once direct injection is added, the
objects also record whether an LPI is mapped into the host ITT.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-its-v5.c | 343 ++++++++++++++++++++++++++++--
 include/kvm/arm_vgic.h            |   7 +
 2 files changed, 335 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
index f6d2acca4ae4c..e4c0415137605 100644
--- a/arch/arm64/kvm/vgic/vgic-its-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
@@ -19,6 +19,272 @@
 #define VITS_V5_DEVICE_ID_BITS		16
 #define VITS_V5_EVENT_ID_BITS		16
 
+struct its_cache_translation_entry {
+	struct hlist_node node;
+	u64 key;
+	struct vgic_irq *irq;
+};
+
+static void its_cache_drop_translation(struct kvm *kvm,
+				       struct its_cache_translation_entry *entry)
+{
+	struct vgic_irq *irq = entry->irq;
+
+	vgic_put_irq(kvm, irq);
+	kfree(entry);
+}
+
+static void its_cache_drop_removed_translations(struct kvm *kvm,
+						struct hlist_head *removed)
+{
+	struct its_cache_translation_entry *entry;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(entry, tmp, removed, node) {
+		hlist_del(&entry->node);
+		its_cache_drop_translation(kvm, entry);
+	}
+}
+
+static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its *its,
+				     u32 device_id, u16 event_id,
+				     struct vgic_irq *irq)
+{
+	u64 key = ((u64)device_id << 16) | (u64)event_id;
+	struct its_cache_translation_entry *entry;
+	struct its_cache_translation_entry *old;
+	struct hlist_node *tmp;
+	HLIST_HEAD(removed);
+
+	entry = kzalloc_obj(*entry, GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->key = key;
+	entry->irq = irq;
+
+	scoped_guard(raw_spinlock, &its->translation_cache_lock) {
+		hash_for_each_possible_safe(its->translation_cache, old, tmp,
+					    node, key) {
+			if (old->key == key) {
+				hash_del(&old->node);
+				hlist_add_head(&old->node, &removed);
+			}
+		}
+
+		hash_add(its->translation_cache, &entry->node, entry->key);
+	}
+
+	its_cache_drop_removed_translations(kvm, &removed);
+
+	return 0;
+}
+
+static int its_cache_remove_translation(struct vgic_v5_its *its, u32 device_id,
+					u16 event_id)
+{
+	u64 key = ((u64)device_id << 16) | (u64)event_id;
+	struct its_cache_translation_entry *entry;
+	struct hlist_node *tmp;
+	HLIST_HEAD(removed);
+	bool found = false;
+
+	scoped_guard(raw_spinlock, &its->translation_cache_lock) {
+		hash_for_each_possible_safe(its->translation_cache, entry, tmp,
+					    node, key) {
+			if (entry->key == key) {
+				hash_del(&entry->node);
+				hlist_add_head(&entry->node, &removed);
+				found = true;
+			}
+		}
+	}
+
+	its_cache_drop_removed_translations(its->dev->kvm, &removed);
+
+	return found ? 0 : -EINVAL;
+}
+
+static void its_cache_clear_translations(struct vgic_v5_its *its)
+{
+	struct its_cache_translation_entry *entry;
+	struct hlist_node *tmp;
+	HLIST_HEAD(removed);
+	int bkt;
+
+	scoped_guard(raw_spinlock, &its->translation_cache_lock) {
+		hash_for_each_safe(its->translation_cache, bkt, tmp, entry,
+				   node) {
+			hash_del(&entry->node);
+			hlist_add_head(&entry->node, &removed);
+		}
+
+		WARN_ON(!hash_empty(its->translation_cache));
+	}
+
+	its_cache_drop_removed_translations(its->dev->kvm, &removed);
+}
+
+static int its_cache_look_up_translation(struct vgic_v5_its *its,
+					 u32 device_id, u16 event_id,
+					 struct vgic_irq **irq)
+{
+	u64 key = ((u64)device_id << 16) | (u64)event_id;
+	struct its_cache_translation_entry *entry;
+
+	guard(raw_spinlock)(&its->translation_cache_lock);
+
+	hash_for_each_possible(its->translation_cache, entry, node, key) {
+		if (entry->key == key) {
+			if (!vgic_try_get_irq_ref(entry->irq))
+				return -ENXIO;
+
+			*irq = entry->irq;
+			return 0;
+		}
+	}
+
+	return -ENXIO;
+}
+
+static void its_cache_handle_inv_devicer_l2(struct vgic_v5_its *its,
+					    u32 device_id, u8 event_id_bits)
+{
+	struct its_cache_translation_entry *entry;
+	struct hlist_node *tmp;
+	HLIST_HEAD(removed);
+	u64 event_id_limit;
+	int bkt;
+
+	if (event_id_bits > 16)
+		event_id_bits = 16;
+	event_id_limit = 1ULL << event_id_bits;
+
+	scoped_guard(raw_spinlock, &its->translation_cache_lock) {
+		hash_for_each_safe(its->translation_cache, bkt, tmp, entry,
+				   node) {
+			if ((entry->key >> 16 == device_id) &&
+			    ((entry->key & 0xffffULL) < event_id_limit)) {
+				hash_del(&entry->node);
+				hlist_add_head(&entry->node, &removed);
+			}
+		}
+	}
+
+	its_cache_drop_removed_translations(its->dev->kvm, &removed);
+}
+
+static void its_cache_handle_inv_devicer_l1(struct vgic_v5_its *its,
+					    u32 device_id, u8 l2sz)
+{
+	struct its_cache_translation_entry *entry;
+	struct hlist_node *tmp;
+	HLIST_HEAD(removed);
+	u8 device_id_split_bits;
+	u32 device_id_mask;
+	int bkt;
+
+	switch (l2sz) {
+	case 0:
+		device_id_split_bits = 9;
+		break;
+	case 1:
+		device_id_split_bits = 11;
+		break;
+	case 2:
+		device_id_split_bits = 13;
+		break;
+	default:
+		return;
+	}
+
+	device_id_mask = ~((1U << device_id_split_bits) - 1);
+	device_id &= device_id_mask;
+
+	scoped_guard(raw_spinlock, &its->translation_cache_lock) {
+		hash_for_each_safe(its->translation_cache, bkt, tmp, entry,
+				   node) {
+			if (((entry->key >> 16) & device_id_mask) ==
+			    device_id) {
+				hash_del(&entry->node);
+				hlist_add_head(&entry->node, &removed);
+			}
+		}
+	}
+
+	its_cache_drop_removed_translations(its->dev->kvm, &removed);
+}
+
+static void its_cache_handle_inv_devicer(struct vgic_v5_its *its)
+{
+	const u8 event_id_bits = its->inv_devicer.event_id_bits;
+	const bool structure = its->dt_cfgr.structure;
+	const bool l1 = its->inv_devicer.l1 && structure;
+	const u32 device_id = its->didr.device_id;
+	const u8 l2sz = its->dt_cfgr.l2sz;
+
+	if (!l1)
+		its_cache_handle_inv_devicer_l2(its, device_id, event_id_bits);
+	else
+		its_cache_handle_inv_devicer_l1(its, device_id, l2sz);
+}
+
+static void its_cache_handle_inv_eventr_l1(struct vgic_v5_its *its,
+					   u32 device_id, u16 event_id,
+					   u8 itt_l2sz)
+{
+	struct its_cache_translation_entry *entry;
+	struct hlist_node *tmp;
+	HLIST_HEAD(removed);
+	u8 lower_event_id_bit;
+	u16 event_id_mask;
+	int bkt;
+
+	switch (itt_l2sz) {
+	case 0:
+		lower_event_id_bit = 9;
+		break;
+	case 1:
+		lower_event_id_bit = 11;
+		break;
+	case 2:
+		lower_event_id_bit = 13;
+		break;
+	default:
+		return;
+	}
+
+	event_id_mask = (u16)((0xffffU << lower_event_id_bit) & 0xffffU);
+	event_id &= event_id_mask;
+
+	scoped_guard(raw_spinlock, &its->translation_cache_lock) {
+		hash_for_each_safe(its->translation_cache, bkt, tmp, entry,
+				   node) {
+			if ((entry->key >> 16 == device_id) &&
+			    ((entry->key & event_id_mask) == event_id)) {
+				hash_del(&entry->node);
+				hlist_add_head(&entry->node, &removed);
+			}
+		}
+	}
+
+	its_cache_drop_removed_translations(its->dev->kvm, &removed);
+}
+
+static void its_cache_handle_inv_eventr(struct vgic_v5_its *its)
+{
+	const bool l1 = its->inv_eventr.l1;
+	const u8 itt_l2sz = its->inv_eventr.itt_l2sz;
+	const u16 event_id = its->eidr.event_id;
+	const u32 device_id = its->didr.device_id;
+
+	if (!l1)
+		its_cache_remove_translation(its, device_id, event_id);
+	else
+		its_cache_handle_inv_eventr_l1(its, device_id, event_id,
+					       itt_l2sz);
+}
+
 static int parse_linear_dt(struct kvm *kvm, gpa_t dt_base, u32 device_id,
 			   gpa_t *itt_base, bool *two_level_itt,
 			   unsigned int *event_id_bits, unsigned int *itt_l2sz)
@@ -228,6 +494,10 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 		return -ENXIO;
 	}
 
+	ret = its_cache_look_up_translation(its, device_id, event_id, irq);
+	if (!ret)
+		return 0;
+
 	if (WARN_ON_ONCE(kvm->mm != get_current()->mm))
 		return -EWOULDBLOCK;
 
@@ -260,7 +530,15 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 	if (IS_ERR(*irq))
 		return PTR_ERR(*irq);
 
-	return 0;
+	vgic_get_irq_ref(*irq);
+	ret = its_cache_add_translation(kvm, its, device_id, event_id, *irq);
+	if (ret) {
+		vgic_put_irq(kvm, *irq);
+		vgic_put_irq(kvm, *irq);
+		*irq = NULL;
+	}
+
+	return ret;
 }
 
 static void vgic_v5_its_inject_lpi(struct kvm *kvm, struct vgic_irq *irq)
@@ -385,9 +663,17 @@ static void vgic_v5_mmio_write_its_misc(struct kvm *kvm, void *dev, gpa_t addr,
 	size_t offset = addr & (SZ_64K - 1);
 
 	switch (offset) {
-	case GICV5_ITS_CR0:
-		its->enabled = FIELD_GET(GICV5_ITS_CR0_ITSEN, val);
+	case GICV5_ITS_CR0: {
+		guard(mutex)(&its->its_lock);
+
+		if (FIELD_GET(GICV5_ITS_CR0_ITSEN, val)) {
+			its->enabled = true;
+		} else {
+			its->enabled = false;
+			its_cache_clear_translations(its);
+		}
 		return;
+	}
 	case GICV5_ITS_CR1:
 		its->cr1.sh = FIELD_GET(GICV5_ITS_CR1_SH, val);
 		its->cr1.oc = FIELD_GET(GICV5_ITS_CR1_OC, val);
@@ -403,21 +689,39 @@ static void vgic_v5_mmio_write_its_misc(struct kvm *kvm, void *dev, gpa_t addr,
 static void vgic_v5_write_its_dt_reg(struct vgic_v5_its *its, size_t offset,
 				     unsigned long val)
 {
+	lockdep_assert_held(&its->its_lock);
+
 	switch (offset) {
-	case GICV5_ITS_DT_CFGR:
-		its->dt_cfgr.device_id_bits =
-			FIELD_GET(GICV5_ITS_DT_CFGR_DEVICEID_BITS, val);
-		its->dt_cfgr.l2sz =
-			FIELD_GET(GICV5_ITS_DT_CFGR_L2SZ, val);
-		its->dt_cfgr.structure =
-			FIELD_GET(GICV5_ITS_DT_CFGR_STRUCTURE, val);
-		return;
-	case GICV5_ITS_DT_BASER:
-		its->dt_baser.addr =
-			FIELD_GET(GICV5_ITS_DT_BASER_ADDR_MASK, val)
-			<< GICV5_ITS_DT_BASER_ADDR_SHIFT;
+	case GICV5_ITS_DT_CFGR: {
+		u8 device_id_bits = FIELD_GET(GICV5_ITS_DT_CFGR_DEVICEID_BITS, val);
+		u8 l2sz = FIELD_GET(GICV5_ITS_DT_CFGR_L2SZ, val);
+		bool structure = FIELD_GET(GICV5_ITS_DT_CFGR_STRUCTURE, val);
+
+		if (its->dt_cfgr.device_id_bits == device_id_bits &&
+		    its->dt_cfgr.l2sz == l2sz &&
+		    its->dt_cfgr.structure == structure)
+			return;
+
+		its->dt_cfgr.device_id_bits = device_id_bits;
+		its->dt_cfgr.l2sz = l2sz;
+		its->dt_cfgr.structure = structure;
+		break;
+	}
+	case GICV5_ITS_DT_BASER: {
+		u64 base = FIELD_GET(GICV5_ITS_DT_BASER_ADDR_MASK, val)
+			   << GICV5_ITS_DT_BASER_ADDR_SHIFT;
+
+		if (its->dt_baser.addr == base)
+			return;
+
+		its->dt_baser.addr = base;
+		break;
+	}
+	default:
 		return;
 	}
+
+	its_cache_clear_translations(its);
 }
 
 static u64 vgic_v5_read_its_dt_baser(struct vgic_v5_its *its)
@@ -522,6 +826,8 @@ static void vgic_v5_mmio_write_its_dt_itt(struct kvm *kvm, void *dev,
 			FIELD_GET(GICV5_ITS_INV_DEVICER_EVENTID_BITS, val);
 		its->inv_devicer.i =
 			FIELD_GET(GICV5_ITS_INV_DEVICER_I, val);
+		if (its->inv_devicer.i)
+			its_cache_handle_inv_devicer(its);
 		return;
 	case GICV5_ITS_DIDR:
 	case GICV5_ITS_DIDR + 4:
@@ -538,6 +844,8 @@ static void vgic_v5_mmio_write_its_dt_itt(struct kvm *kvm, void *dev,
 		its->inv_eventr.itt_l2sz =
 			FIELD_GET(GICV5_ITS_INV_EVENTR_ITT_L2SZ, val);
 		its->inv_eventr.i = FIELD_GET(GICV5_ITS_INV_EVENTR_I, val);
+		if (its->inv_eventr.i)
+			its_cache_handle_inv_eventr(its);
 		return;
 	case GICV5_ITS_SYNCR:
 		return;
@@ -730,6 +1038,7 @@ static void vgic_v5_its_reset(struct vgic_v5_its *its)
 	its->gen_event_eidr.event_id = 0;
 	its->gen_event_didr.device_id = 0;
 
+	its_cache_clear_translations(its);
 }
 
 static int vgic_v5_its_create(struct kvm_device *dev, u32 type)
@@ -753,6 +1062,9 @@ static int vgic_v5_its_create(struct kvm_device *dev, u32 type)
 		return -ENODEV;
 	}
 
+	hash_init(its->translation_cache);
+	raw_spin_lock_init(&its->translation_cache_lock);
+
 	its->vgic_v5_its_base = VGIC_ADDR_UNDEF;
 	its->dev = dev;
 
@@ -770,6 +1082,7 @@ static void vgic_v5_its_destroy(struct kvm_device *kvm_dev)
 {
 	struct vgic_v5_its *its = kvm_dev->private;
 
+	its_cache_clear_translations(its);
 	kfree(its);
 	kfree(kvm_dev);
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c9eaa7897b57e..bf970275868c9 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -17,6 +17,7 @@
 #include <kvm/iodev.h>
 #include <linux/list.h>
 #include <linux/jump_label.h>
+#include <linux/hashtable.h>
 
 #include <linux/irqchip/arm-gic-v4.h>
 #include <linux/irqchip/arm-gic-v5.h>
@@ -590,6 +591,12 @@ struct vgic_v5_its {
 		u32 device_id;
 	} gen_event_didr;
 
+	/* A hash table with 2^3 buckets */
+	DECLARE_HASHTABLE(translation_cache, 3);
+
+	/* Protects the translation_cache */
+	raw_spinlock_t translation_cache_lock;
+
 	/* Protects the device in general */
 	struct mutex		its_lock;
 };
-- 
2.34.1


From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 12/13] KVM: arm64: ITS: Device and translation table flush
Date: Thu, 12 Jan 2017 16:56:52 +0100
Message-ID: <1484236613-24633-13-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, Prasun.Kapoor@cavium.com, pbonzini@redhat.com, dgilbert@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch flushes the device table into guest RAM, at
the address specified by the BASER register. The last
written element is a dummy element with valid bit set to
zero.

For each device listed in the device table, we also flush
the translation table into the address specific in the
corresponding device table entry.

On restore, devices are re-allocated and their itte are
re-built. LPI is re-created and its config gets updated.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 virt/kvm/arm/vgic/vgic-its.c | 158 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 156 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index a1861b8..16a9aac 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1592,13 +1592,129 @@ static int vgic_its_restore_pending_tables(struct kvm *kvm,
 	return -ENXIO;
 }
 
+static int vgic_its_flush_itt(struct kvm *kvm, struct its_device *device)
+{
+	struct its_itte *itte;
+	size_t max_size, filled = 0;
+	u64 val, *ptr;
+	int ret;
+
+	ptr = (u64 *)device->itt_addr;
+	max_size = device->itt_size;
+
+	list_for_each_entry(itte, &device->itt_head, itte_list) {
+		if (filled == max_size)
+			return -ENOSPC;
+		val = ((u64)device->device_id << 32) | (1ULL << 16) |
+			itte->collection->collection_id;
+		ret = kvm_write_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		val = (u64)itte->lpi << 32 | itte->event_id;
+		ret = kvm_write_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		filled += ITTE_SIZE;
+	}
+	return 0;
+}
+
+static int vgic_its_restore_itt(struct kvm *kvm, struct vgic_its *its,
+				struct its_device *dev)
+{
+	u64 val, *ptr = (u64 *)dev->itt_addr;
+	size_t max_size, read = 0;
+	bool valid;
+
+	max_size = dev->itt_size;
+
+	while (read < max_size) {
+		u32 coll_id, device_id, lpi_id, event_id;
+		struct its_collection *collection;
+		struct its_itte *itte;
+		struct vgic_irq *irq;
+		int ret;
+
+		ret = kvm_read_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		valid = val & 0x10000;
+		if (!valid)
+			break;
+		coll_id = val & 0xFFFF;
+		device_id = val >> 32;
+		ret = kvm_read_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		lpi_id = val >> 32;
+		event_id = val & 0xFFFFFFFFFFFFFFFF;
+		collection = find_collection(its, coll_id);
+		if (!collection)
+			return -EINVAL;
+		ret = vgic_its_alloc_itte(dev, &itte, collection,
+					  lpi_id, event_id);
+		if (ret)
+			return ret;
+
+		irq = vgic_add_lpi(kvm, lpi_id);
+		if (IS_ERR(irq))
+			return PTR_ERR(irq);
+		itte->irq = irq;
+
+		/* restores the configuration of the LPI */
+		ret = update_lpi_config(kvm, irq, NULL);
+		if (ret)
+			return ret;
+
+		update_affinity_itte(kvm, itte);
+		read += ITTE_SIZE;
+	}
+	return 0;
+}
+
 /**
  * vgic_its_flush_device_tables - flush the device table and all ITT
  * into guest RAM
  */
 static int vgic_its_flush_device_tables(struct kvm *kvm, struct vgic_its *its)
 {
-	return -ENXIO;
+	struct its_device *dev;
+	size_t max_size, filled = 0;
+	u64 val, *ptr;
+	int ret;
+
+	ptr = (u64 *)(its->baser_device_table & 0x0000FFFFFFFFF000);
+
+	/* max size of the device table (64kB page size) */
+	max_size = its->device_table_size;
+
+	list_for_each_entry(dev, &its->device_list, dev_list) {
+		if (filled == max_size)
+			return -ENOSPC;
+		ret = vgic_its_flush_itt(kvm, dev);
+		if (ret)
+			return ret;
+		val = ((u64)dev->device_id << 32) | (1 << 5) |
+				(dev->nb_eventid_bits - 1);
+		ret = kvm_write_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		val = dev->itt_addr >> 8;
+		ret = kvm_write_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		filled += DEV_ENTRY_SIZE;
+	}
+	if (filled == max_size)
+		return 0;
+
+	/**
+	 * table is not fully filled, add a last dummy element
+	 * element with valid but unset
+	 */
+	val = 0;
+	ret = kvm_write_guest(kvm, (gpa_t)ptr, &val, 8);
+	return ret;
 }
 
 /**
@@ -1608,7 +1724,45 @@ static int vgic_its_flush_device_tables(struct kvm *kvm, struct vgic_its *its)
 static int vgic_its_restore_device_tables(struct kvm *kvm,
 					  struct vgic_its *its)
 {
-	return -ENXIO;
+	size_t max_size, read = 0;
+	struct its_device *dev;
+	u64 val, *ptr;
+	bool valid;
+	int ret;
+
+	ptr = (u64 *)(its->baser_device_table & 0x0000FFFFFFFFF000);
+	if (!ptr)
+		return 0;
+
+	max_size = its->device_table_size;
+
+	while (read < max_size) {
+		u32 device_id;
+		gpa_t itt_addr;
+		size_t size;
+
+		ret = kvm_read_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		valid = val & 0x20;
+		if (!valid)
+			break;
+		device_id =  val >> 32;
+		size = val & 0x1F;
+		ret = kvm_read_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		itt_addr = val & 0x000FFFFFFFFFFFFF;
+		ret = vgic_its_alloc_device(its, &dev, device_id,
+					    itt_addr, size);
+		if (ret)
+			return ret;
+		ret = vgic_its_restore_itt(kvm, its, dev);
+		if (ret)
+			return ret;
+		read += DEV_ENTRY_SIZE;
+	}
+	return 0;
 }
 
 /**
-- 
2.5.5


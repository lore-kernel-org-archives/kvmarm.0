From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 11/13] KVM: arm64: ITS: Collection table save/restore
Date: Thu, 12 Jan 2017 16:56:51 +0100
Message-ID: <1484236613-24633-12-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, Prasun.Kapoor@cavium.com, pbonzini@redhat.com, dgilbert@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

The flush path copies the collection entries into guest RAM
at the GPA specified in the BASER register. This obviously
requires the BASER to be set. The last written element
is a dummy collection table entry with valid bit set to 0.

On restore path we re-allocate the collection objects.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 virt/kvm/arm/vgic/vgic-its.c | 66 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 07bf180..a1861b8 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1618,7 +1618,39 @@ static int vgic_its_restore_device_tables(struct kvm *kvm,
 static int vgic_its_flush_collection_table(struct kvm *kvm,
 					   struct vgic_its *its)
 {
-	return -ENXIO;
+	struct its_collection *collection;
+	u64 val, *ptr;
+	size_t max_size, filled = 0;
+	int ret;
+
+	ptr = (u64 *)(its->baser_coll_table & 0x0000FFFFFFFFF000);
+	if (!ptr)
+		return 0;
+
+	max_size = its->collection_table_size;
+
+	list_for_each_entry(collection, &its->collection_list, coll_list) {
+		if (filled == max_size)
+			return -ENOSPC;
+		val = ((u64)1 << 63 |
+		       ((u64)collection->target_addr << 16) |
+		       collection->collection_id);
+		ret = kvm_write_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		filled += COLL_ENTRY_SIZE;
+	}
+
+	if (filled == max_size)
+		return 0;
+
+	/*
+	 * table is not fully filled, add a last dummy element
+	 * with valid bit unset
+	 */
+	val = 0;
+	ret = kvm_write_guest(kvm, (gpa_t)ptr, &val, 8);
+	return ret;
 }
 
 /**
@@ -1629,7 +1661,37 @@ static int vgic_its_flush_collection_table(struct kvm *kvm,
 static int vgic_its_restore_collection_table(struct kvm *kvm,
 					     struct vgic_its *its)
 {
-	return -ENXIO;
+	struct its_collection *collection;
+	size_t max_size, read = 0;
+	u64 val, *ptr;
+	bool valid = true;
+	int ret;
+
+	ptr = (u64 *)(its->baser_coll_table & 0x0000FFFFFFFFF000);
+	if (!ptr)
+		return 0;
+
+	max_size = its->collection_table_size;
+
+	while (read < max_size) {
+		u32 target_addr;
+		u32 coll_id;
+
+		ret = kvm_read_guest(kvm, (gpa_t)ptr++, &val, 8);
+		if (ret)
+			return ret;
+		valid = val >> 63;
+		if (!valid)
+			break;
+		target_addr = (u32)(val >> 16);
+		coll_id = val & 0xFFFF;
+		ret = vgic_its_alloc_collection(its, &collection, coll_id);
+		if (ret)
+			return ret;
+		collection->target_addr = target_addr;
+		read += COLL_ENTRY_SIZE;
+	}
+	return 0;
 }
 
 /**
-- 
2.5.5


From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 17/19] KVM: arm64: ITS: ITT flush and restore
Date: Mon,  6 Mar 2017 12:34:32 +0100
Message-ID: <1488800074-21991-18-git-send-email-eric.auger@redhat.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C420E40B5B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 06:34:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 319lBGVCK83X for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 06:34:31 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE12A40A86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 06:34:30 -0500 (EST)
In-Reply-To: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
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

Introduce routines to flush and restore device ITT and their
interrupt table entries (ITE).

The routines will be called on device table flush and
restore.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v2 -> v3:
- add return 0 in vgic_its_restore_ite (was in subsequent patch)

v2: creation
---
 virt/kvm/arm/vgic/vgic-its.c | 100 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1060125..a216849 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1748,6 +1748,106 @@ static int vgic_its_restore_pending_tables(struct vgic_its *its)
 	return -ENXIO;
 }
 
+static int vgic_its_flush_ite(struct vgic_its *its, struct its_device *dev,
+			      struct its_ite *ite, gpa_t gpa)
+{
+	struct kvm *kvm = its->dev->kvm;
+	u32 next_offset;
+	u64 val;
+
+	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
+	val = ((u64)next_offset << 48) | ((u64)ite->lpi << 16) |
+		ite->collection->collection_id;
+	val = cpu_to_le64(val);
+	return kvm_write_guest(kvm, gpa, &val, VITS_ESZ);
+}
+
+/**
+ * vgic_its_restore_ite - restore an interrupt translation entry
+ * @event_id: id used for indexing
+ * @ptr: kernel VA where the 8 byte ITE is located
+ * @opaque: pointer to the its_device
+ * @next: id offset to the next entry
+ */
+static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
+				void *ptr, void *opaque, u32 *next)
+{
+	struct its_device *dev = (struct its_device *)opaque;
+	struct its_collection *collection;
+	struct kvm *kvm = its->dev->kvm;
+	u64 val, *p = (u64 *)ptr;
+	struct vgic_irq *irq;
+	u32 coll_id, lpi_id;
+	struct its_ite *ite;
+	int ret;
+
+	val = *p;
+	*next = 1;
+
+	val = le64_to_cpu(val);
+
+	coll_id = val & GENMASK_ULL(15, 0);
+	lpi_id = (val & GENMASK_ULL(47, 16)) >> 16;
+
+	if (!lpi_id)
+		return 0;
+
+	*next = (val & GENMASK_ULL(63, 48)) >> 48;
+
+	collection = find_collection(its, coll_id);
+	if (!collection)
+		return -EINVAL;
+
+	ret = vgic_its_alloc_ite(dev, &ite, collection,
+				  lpi_id, event_id);
+	if (ret)
+		return ret;
+
+	irq = vgic_add_lpi(kvm, lpi_id);
+	if (IS_ERR(irq))
+		return PTR_ERR(irq);
+	ite->irq = irq;
+
+	/* restore the configuration of the LPI */
+	ret = update_lpi_config(kvm, irq, NULL);
+	if (ret)
+		return ret;
+
+	update_affinity_ite(kvm, ite);
+	return 0;
+}
+
+static int vgic_its_flush_itt(struct vgic_its *its, struct its_device *device)
+{
+	gpa_t base = device->itt_addr;
+	struct its_ite *ite;
+	int ret;
+
+	list_for_each_entry(ite, &device->itt_head, ite_list) {
+		gpa_t gpa = base + ite->event_id * VITS_ESZ;
+
+		ret = vgic_its_flush_ite(its, device, ite, gpa);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int vgic_its_restore_itt(struct vgic_its *its,
+				struct its_device *dev)
+{
+	size_t max_size = (2 << dev->nb_eventid_bits) * VITS_ESZ;
+	gpa_t base = dev->itt_addr;
+	int ret;
+
+	ret =  lookup_table(its, base, max_size, VITS_ESZ, 0,
+			    vgic_its_restore_ite, dev);
+
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
 /**
  * vgic_its_flush_device_tables - flush the device table and all ITT
  * into guest RAM
-- 
2.5.5

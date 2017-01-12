From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 13/13] KVM: arm64: ITS: Pending table save/restore
Date: Thu, 12 Jan 2017 16:56:53 +0100
Message-ID: <1484236613-24633-14-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FA2540670
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:56:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7utz7YDAXVS7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 10:56:02 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB22740354
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:56:02 -0500 (EST)
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
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
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

Save and restore the pending tables.

Pending table restore obviously requires the pendbaser to be
already set.

We also make sure the first kB of the pending table is zeroed.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

Not sure what to do with this 1st kB. Should we really care?

Maybe we should read it instead from guest RAM and return
an error if it is non zero, as the spec says on init it should be
zero. Then we do not touch it.
---
 virt/kvm/arm/vgic/vgic-its.c | 94 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 16a9aac..4a2b4de 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -316,6 +316,29 @@ static u32 max_lpis_propbaser(u64 propbaser)
 	return 1U << min(nr_idbits, INTERRUPT_ID_BITS_ITS);
 }
 
+/**
+ * its_zero_pending_table_first1kB - Sets the first kB of the
+ * pending table to 0
+ * @vcpu: vcpu handle the pending table is attached to
+ *
+ * The content of the 1st kB is implementation defined. We force
+ * it to 0. Note the spec says it should already contain zeros on
+ * initial allocation and it must be visible to redist, else the
+ * behavior is unpredicatable
+ */
+static int its_zero_pending_table_first1kB(struct kvm_vcpu *vcpu)
+{
+	gpa_t pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+	u8 *tmp;
+	int ret;
+
+	tmp = kzalloc(1024, GFP_KERNEL);
+	ret = kvm_write_guest(vcpu->kvm, (gpa_t)pendbase, tmp, 1024);
+	kfree(tmp);
+
+	return ret;
+}
+
 /*
  * Scan the whole LPI pending table and sync the pending bit in there
  * with our own data structures. This relies on the LPI being
@@ -1399,6 +1422,8 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu)
 {
 	if (!(vcpu->arch.vgic_cpu.pendbaser & GICR_PENDBASER_PTZ))
 		its_sync_lpi_pending_table(vcpu);
+
+	its_zero_pending_table_first1kB(vcpu);
 }
 
 static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
@@ -1579,7 +1604,47 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
 static int vgic_its_flush_pending_tables(struct kvm *kvm,
 					 struct vgic_its *its)
 {
-	return -ENXIO;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	int ret;
+
+	/**
+	 * we do not take the dist->lpi_list_lock this we have a garantee
+	 * the LPI list is not touched while the cmd and its lock are held
+	 */
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+		struct kvm_vcpu *vcpu;
+		gpa_t pendbase, ptr;
+		bool stored;
+		u8 val;
+
+		vcpu = irq->target_vcpu;
+		if (!vcpu)
+			return -EINVAL;
+
+		pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+
+		ptr = pendbase + (irq->intid / BITS_PER_BYTE);
+
+		ret = kvm_read_guest(kvm, (gpa_t)ptr, &val, 1);
+		if (ret)
+			return ret;
+
+		stored = val & (irq->intid % BITS_PER_BYTE);
+		if (stored == irq->pending)
+			continue;
+
+		if (irq->pending)
+			val |= 1 << (irq->intid % BITS_PER_BYTE);
+		else
+			val &= ~(1 << (irq->intid % BITS_PER_BYTE));
+
+		ret = kvm_write_guest(kvm, (gpa_t)ptr, &val, 1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 /**
@@ -1589,7 +1654,32 @@ static int vgic_its_flush_pending_tables(struct kvm *kvm,
 static int vgic_its_restore_pending_tables(struct kvm *kvm,
 					   struct vgic_its *its)
 {
-	return -ENXIO;
+	struct vgic_irq *irq;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int ret;
+
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+		struct kvm_vcpu *vcpu;
+		gpa_t pendbase, ptr;
+		u8 val;
+
+		vcpu = irq->target_vcpu;
+		if (!vcpu)
+			return -EINVAL;
+
+		if (!(vcpu->arch.vgic_cpu.pendbaser & GICR_PENDBASER_PTZ))
+			return 0;
+
+		pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+
+		ptr = pendbase + (irq->intid / BITS_PER_BYTE);
+
+		ret = kvm_read_guest(kvm, (gpa_t)ptr, &val, 1);
+		if (ret)
+			return ret;
+		irq->pending = val & (1 << (irq->intid % BITS_PER_BYTE));
+	}
+	return 0;
 }
 
 static int vgic_its_flush_itt(struct kvm *kvm, struct its_device *device)
-- 
2.5.5

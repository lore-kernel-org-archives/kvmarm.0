From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 22/22] KVM: arm64: ITS: Pending table save/restore
Date: Mon, 27 Mar 2017 11:31:12 +0200
Message-ID: <1490607072-21610-23-git-send-email-eric.auger@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6245C40A6A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:31:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R84lL016t9tF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 05:31:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 793FF40A80
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:31:13 -0400 (EDT)
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

Save and restore the pending tables.

Pending table restore obviously requires the pendbaser to be
already set.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- remove the wrong comment about locking
- pass kvm struct instead of its handle
- add comment about restore method
- remove GITR_PENDABASER.PTZ check
- continue if target_vcpu == NULL
- new locking strategy

v1 -> v2:
- do not care about the 1st KB which should be zeroed according to
  the spec.
---
 virt/kvm/arm/vgic/vgic-its.c | 66 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index a516bbb..e10aa81 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1804,16 +1804,78 @@ static int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
  */
 static int vgic_its_flush_pending_tables(struct kvm *kvm)
 {
-	return -ENXIO;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	int ret;
+
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+		struct kvm_vcpu *vcpu;
+		gpa_t pendbase, ptr;
+		bool stored;
+		u8 val;
+
+		vcpu = irq->target_vcpu;
+		if (!vcpu)
+			continue;
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
+		if (stored == irq->pending_latch)
+			continue;
+
+		if (irq->pending_latch)
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
  * vgic_its_restore_pending_tables - Restore the pending tables from guest
  * RAM to internal data structs
+ *
+ * Does not scan the whole pending tables but just loop on all registered
+ * LPIS and scan their associated pending bit. This obviously requires
+ * the ITEs to be restored before.
  */
 static int vgic_its_restore_pending_tables(struct kvm *kvm)
 {
-	return -ENXIO;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	int ret;
+
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+		struct kvm_vcpu *vcpu;
+		gpa_t pendbase, ptr;
+		u8 val;
+
+		vcpu = irq->target_vcpu;
+		if (!vcpu)
+			continue;
+
+		pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+
+		ptr = pendbase + (irq->intid / BITS_PER_BYTE);
+
+		ret = kvm_read_guest(kvm, (gpa_t)ptr, &val, 1);
+		if (ret)
+			return ret;
+		irq->pending_latch = val & (1 << (irq->intid % BITS_PER_BYTE));
+	}
+	return 0;
 }
 
 static int vgic_its_flush_ite(struct vgic_its *its, struct its_device *dev,
-- 
2.5.5

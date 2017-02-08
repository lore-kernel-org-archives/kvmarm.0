From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 19/19] KVM: arm64: ITS: Pending table save/restore
Date: Wed,  8 Feb 2017 12:43:32 +0100
Message-ID: <1486554212-2774-20-git-send-email-eric.auger@redhat.com>
References: <1486554212-2774-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A7040948
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 06:44:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ar8dlo9oTDmD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Feb 2017 06:44:24 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECF6D408EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 06:44:23 -0500 (EST)
In-Reply-To: <1486554212-2774-1-git-send-email-eric.auger@redhat.com>
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

Save and restore the pending tables.

Pending table restore obviously requires the pendbaser to be
already set.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- do not care about the 1st KB which should be zeroed according to
  the spec.
---
 virt/kvm/arm/vgic/vgic-its.c | 71 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index c1ae85b..67db680 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1736,7 +1736,48 @@ static int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
  */
 static int vgic_its_flush_pending_tables(struct vgic_its *its)
 {
-	return -ENXIO;
+	struct kvm *kvm = its->dev->kvm;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	int ret;
+
+	/**
+	 * we do not take the dist->lpi_list_lock since we have a garantee
+	 * the LPI list is not touched while the its lock is held
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
@@ -1745,7 +1786,33 @@ static int vgic_its_flush_pending_tables(struct vgic_its *its)
  */
 static int vgic_its_restore_pending_tables(struct vgic_its *its)
 {
-	return -ENXIO;
+	struct vgic_irq *irq;
+	struct kvm *kvm = its->dev->kvm;
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
+		irq->pending_latch = val & (1 << (irq->intid % BITS_PER_BYTE));
+	}
+	return 0;
 }
 
 static int vgic_its_flush_ite(struct vgic_its *its, struct its_device *dev,
-- 
2.5.5

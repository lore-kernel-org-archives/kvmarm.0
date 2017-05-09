From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 16/37] KVM: arm64: vgic-v3: vgic_v3_lpi_sync_pending_status
Date: Tue,  9 May 2017 12:44:45 +0200
Message-ID: <20170509104506.30929-17-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

this new helper synchronizes the irq pending_latch
with the LPI pending bit status found in rdist pending table.
As the status is consumed, we reset the bit in pending table.

As we need the PENDBASER_ADDRESS() in vgic-v3, let's move its
definition in the irqchip header. We restore the full length
of the field, ie [51:16]. Same for PROPBASER_ADDRESS with full
field length of [51:12].

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
---
 include/linux/irqchip/arm-gic-v3.h |  2 ++
 virt/kvm/arm/vgic/vgic-its.c       |  6 ++----
 virt/kvm/arm/vgic/vgic-v3.c        | 44 ++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h           |  1 +
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index be8bad0..fffb912 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -159,6 +159,8 @@
 #define GICR_PROPBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWb)
 
 #define GICR_PROPBASER_IDBITS_MASK			(0x1f)
+#define GICR_PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
+#define GICR_PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
 
 #define GICR_PENDBASER_SHAREABILITY_SHIFT		(10)
 #define GICR_PENDBASER_INNER_CACHEABILITY_SHIFT		(7)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index bd1362e..3601790 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -221,8 +221,6 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
  */
 #define BASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
 #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
-#define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
-#define PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
 
 #define GIC_LPI_OFFSET 8192
 
@@ -257,7 +255,7 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
 static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 			     struct kvm_vcpu *filter_vcpu)
 {
-	u64 propbase = PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
+	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
 	u8 prop;
 	int ret;
 
@@ -369,7 +367,7 @@ static u32 max_lpis_propbaser(u64 propbaser)
  */
 static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 {
-	gpa_t pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+	gpa_t pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
 	struct vgic_irq *irq;
 	int last_byte_offset = -1;
 	int ret = 0;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index df15036..9ae8add 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -234,6 +234,50 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 	vgic_v3->vgic_hcr = ICH_HCR_EN;
 }
 
+int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
+{
+	struct kvm_vcpu *vcpu;
+	int byte_offset, bit_nr;
+	gpa_t pendbase, ptr;
+	bool status;
+	u8 val;
+	int ret;
+
+retry:
+	vcpu = irq->target_vcpu;
+	if (!vcpu)
+		return 0;
+
+	pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+
+	byte_offset = irq->intid / BITS_PER_BYTE;
+	bit_nr = irq->intid % BITS_PER_BYTE;
+	ptr = pendbase + byte_offset;
+
+	ret = kvm_read_guest(kvm, ptr, &val, 1);
+	if (ret)
+		return ret;
+
+	status = val & (1 << bit_nr);
+
+	spin_lock(&irq->irq_lock);
+	if (irq->target_vcpu != vcpu) {
+		spin_unlock(&irq->irq_lock);
+		goto retry;
+	}
+	irq->pending_latch = status;
+	vgic_queue_irq_unlock(vcpu->kvm, irq);
+
+	if (status) {
+		/* clear consumed data */
+		val &= ~(1 << bit_nr);
+		ret = kvm_write_guest(kvm, ptr, &val, 1);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 /* check for overlapping regions and for regions crossing the end of memory */
 static bool vgic_v3_check_base(struct kvm *kvm)
 {
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index a48f33b..79768c8 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -149,6 +149,7 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
+int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);
-- 
2.9.0

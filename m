From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 24/27] KVM: arm/arm64: merge GICv3 RD_base and SGI_base register frames
Date: Thu,  2 Apr 2015 11:05:28 +0100
Message-ID: <1427969131-8445-25-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Currently we handle the redistributor registers in two separate MMIO
regions, one for the overall behaviour and SPIs and one for the
SGIs/PPIs. That latter forces the creation of _two_ KVM I/O bus
devices for each redistributor.
Since the spec mandates those two pages to be contigious, we could as
well merge them and save the churn with the second KVM I/O bus device.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic-v3-emul.c | 174 +++++++++++++++++++++-----------------------
 1 file changed, 83 insertions(+), 91 deletions(-)

diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 14943e3..2f03a36 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -502,6 +502,43 @@ static const struct vgic_io_range vgic_v3_dist_ranges[] = {
 	{},
 };
 
+static bool handle_mmio_ctlr_redist(struct kvm_vcpu *vcpu,
+				    struct kvm_exit_mmio *mmio,
+				    phys_addr_t offset)
+{
+	/* since we don't support LPIs, this register is zero for now */
+	vgic_reg_access(mmio, NULL, offset,
+			ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
+	return false;
+}
+
+static bool handle_mmio_typer_redist(struct kvm_vcpu *vcpu,
+				     struct kvm_exit_mmio *mmio,
+				     phys_addr_t offset)
+{
+	u32 reg;
+	u64 mpidr;
+	struct kvm_vcpu *redist_vcpu = mmio->private;
+	int target_vcpu_id = redist_vcpu->vcpu_id;
+
+	/* the upper 32 bits contain the affinity value */
+	if ((offset & ~3) == 4) {
+		mpidr = kvm_vcpu_get_mpidr_aff(redist_vcpu);
+		reg = compress_mpidr(mpidr);
+
+		vgic_reg_access(mmio, &reg, offset,
+				ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
+		return false;
+	}
+
+	reg = redist_vcpu->vcpu_id << 8;
+	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
+		reg |= GICR_TYPER_LAST;
+	vgic_reg_access(mmio, &reg, offset,
+			ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
+	return false;
+}
+
 static bool handle_mmio_set_enable_reg_redist(struct kvm_vcpu *vcpu,
 					      struct kvm_exit_mmio *mmio,
 					      phys_addr_t offset)
@@ -570,146 +607,107 @@ static bool handle_mmio_cfg_reg_redist(struct kvm_vcpu *vcpu,
 	return vgic_handle_cfg_reg(reg, mmio, offset);
 }
 
-static const struct vgic_io_range vgic_redist_sgi_ranges[] = {
+#define SGI_base(x) ((x) + SZ_64K)
+
+static const struct vgic_io_range vgic_redist_ranges[] = {
+	{
+		.base           = GICR_CTLR,
+		.len            = 0x04,
+		.bits_per_irq   = 0,
+		.handle_mmio    = handle_mmio_ctlr_redist,
+	},
 	{
-		.base		= GICR_IGROUPR0,
+		.base           = GICR_TYPER,
+		.len            = 0x08,
+		.bits_per_irq   = 0,
+		.handle_mmio    = handle_mmio_typer_redist,
+	},
+	{
+		.base           = GICR_IIDR,
+		.len            = 0x04,
+		.bits_per_irq   = 0,
+		.handle_mmio    = handle_mmio_iidr,
+	},
+	{
+		.base           = GICR_WAKER,
+		.len            = 0x04,
+		.bits_per_irq   = 0,
+		.handle_mmio    = handle_mmio_raz_wi,
+	},
+	{
+		.base           = GICR_IDREGS,
+		.len            = 0x30,
+		.bits_per_irq   = 0,
+		.handle_mmio    = handle_mmio_idregs,
+	},
+	{
+		.base		= SGI_base(GICR_IGROUPR0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
 		.handle_mmio	= handle_mmio_rao_wi,
 	},
 	{
-		.base		= GICR_ISENABLER0,
+		.base		= SGI_base(GICR_ISENABLER0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
 		.handle_mmio	= handle_mmio_set_enable_reg_redist,
 	},
 	{
-		.base		= GICR_ICENABLER0,
+		.base		= SGI_base(GICR_ICENABLER0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
 		.handle_mmio	= handle_mmio_clear_enable_reg_redist,
 	},
 	{
-		.base		= GICR_ISPENDR0,
+		.base		= SGI_base(GICR_ISPENDR0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
 		.handle_mmio	= handle_mmio_set_pending_reg_redist,
 	},
 	{
-		.base		= GICR_ICPENDR0,
+		.base		= SGI_base(GICR_ICPENDR0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
 		.handle_mmio	= handle_mmio_clear_pending_reg_redist,
 	},
 	{
-		.base		= GICR_ISACTIVER0,
+		.base		= SGI_base(GICR_ISACTIVER0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
 		.handle_mmio	= handle_mmio_raz_wi,
 	},
 	{
-		.base		= GICR_ICACTIVER0,
+		.base		= SGI_base(GICR_ICACTIVER0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
 		.handle_mmio	= handle_mmio_raz_wi,
 	},
 	{
-		.base		= GICR_IPRIORITYR0,
+		.base		= SGI_base(GICR_IPRIORITYR0),
 		.len		= 0x20,
 		.bits_per_irq	= 8,
 		.handle_mmio	= handle_mmio_priority_reg_redist,
 	},
 	{
-		.base		= GICR_ICFGR0,
+		.base		= SGI_base(GICR_ICFGR0),
 		.len		= 0x08,
 		.bits_per_irq	= 2,
 		.handle_mmio	= handle_mmio_cfg_reg_redist,
 	},
 	{
-		.base		= GICR_IGRPMODR0,
+		.base		= SGI_base(GICR_IGRPMODR0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
 		.handle_mmio	= handle_mmio_raz_wi,
 	},
 	{
-		.base		= GICR_NSACR,
+		.base		= SGI_base(GICR_NSACR),
 		.len		= 0x04,
 		.handle_mmio	= handle_mmio_raz_wi,
 	},
 	{},
 };
 
-static bool handle_mmio_ctlr_redist(struct kvm_vcpu *vcpu,
-				    struct kvm_exit_mmio *mmio,
-				    phys_addr_t offset)
-{
-	/* since we don't support LPIs, this register is zero for now */
-	vgic_reg_access(mmio, NULL, offset,
-			ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
-	return false;
-}
-
-static bool handle_mmio_typer_redist(struct kvm_vcpu *vcpu,
-				     struct kvm_exit_mmio *mmio,
-				     phys_addr_t offset)
-{
-	u32 reg;
-	u64 mpidr;
-	struct kvm_vcpu *redist_vcpu = mmio->private;
-	int target_vcpu_id = redist_vcpu->vcpu_id;
-
-	/* the upper 32 bits contain the affinity value */
-	if ((offset & ~3) == 4) {
-		mpidr = kvm_vcpu_get_mpidr_aff(redist_vcpu);
-		reg = compress_mpidr(mpidr);
-
-		vgic_reg_access(mmio, &reg, offset,
-				ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
-		return false;
-	}
-
-	reg = redist_vcpu->vcpu_id << 8;
-	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
-		reg |= GICR_TYPER_LAST;
-	vgic_reg_access(mmio, &reg, offset,
-			ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
-	return false;
-}
-
-static const struct vgic_io_range vgic_redist_ranges[] = {
-	{
-		.base           = GICR_CTLR,
-		.len            = 0x04,
-		.bits_per_irq   = 0,
-		.handle_mmio    = handle_mmio_ctlr_redist,
-	},
-	{
-		.base           = GICR_TYPER,
-		.len            = 0x08,
-		.bits_per_irq   = 0,
-		.handle_mmio    = handle_mmio_typer_redist,
-	},
-	{
-		.base           = GICR_IIDR,
-		.len            = 0x04,
-		.bits_per_irq   = 0,
-		.handle_mmio    = handle_mmio_iidr,
-	},
-	{
-		.base           = GICR_WAKER,
-		.len            = 0x04,
-		.bits_per_irq   = 0,
-		.handle_mmio    = handle_mmio_raz_wi,
-	},
-	{
-		.base           = GICR_IDREGS,
-		.len            = 0x30,
-		.bits_per_irq   = 0,
-		.handle_mmio    = handle_mmio_idregs,
-	},
-	{},
-};
-
 /*
  * This function splits accesses between the distributor and the two
  * redistributor parts (private/SPI). As each redistributor is accessible
@@ -726,7 +724,6 @@ static bool vgic_v3_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	unsigned long rdbase = dist->vgic_redist_base;
 	int nrcpus = atomic_read(&vcpu->kvm->online_vcpus);
 	int vcpu_id;
-	const struct vgic_io_range *mmio_range;
 
 	if (is_in_range(mmio->phys_addr, mmio->len, dbase, GIC_V3_DIST_SIZE)) {
 		return vgic_handle_mmio_range(vcpu, run, mmio,
@@ -741,13 +738,8 @@ static bool vgic_v3_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	rdbase += (vcpu_id * GIC_V3_REDIST_SIZE);
 	mmio->private = kvm_get_vcpu(vcpu->kvm, vcpu_id);
 
-	if (mmio->phys_addr >= rdbase + SGI_BASE_OFFSET) {
-		rdbase += SGI_BASE_OFFSET;
-		mmio_range = vgic_redist_sgi_ranges;
-	} else {
-		mmio_range = vgic_redist_ranges;
-	}
-	return vgic_handle_mmio_range(vcpu, run, mmio, mmio_range, rdbase);
+	return vgic_handle_mmio_range(vcpu, run, mmio, vgic_redist_ranges,
+				      rdbase);
 }
 
 static bool vgic_v3_queue_sgi(struct kvm_vcpu *vcpu, int irq)
-- 
2.1.4


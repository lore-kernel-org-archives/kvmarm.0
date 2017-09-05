From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 8/8] KVM: arm/arm64: Support uaccess of GICC_APRn
Date: Tue,  5 Sep 2017 16:52:07 +0200
Message-ID: <20170905145207.18447-9-cdall@linaro.org>
References: <20170905145207.18447-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170905145207.18447-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When migrating guests around we need to know the active priorities to
ensure functional virtual interrupt prioritization by the GIC.

This commit clarifies the API and how active priorities of interrupts in
different groups are represented, and implements the accessor functions
for the uaccess register range.

We live with a slight layering violation in accessing GICv3 data
structures from vgic-mmio-v2.c, because anything else just adds too much
complexity for us to deal with (it's not like there's a benefit
elsewhere in the code of an intermediate representation as is the case
with the VMCR).  We accept this, because while doing v3 processing from
a file named something-v2.c can look strange at first, this really is
specific to dealing with the user space interface for something that
looks like a GICv2.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt |  5 +++
 virt/kvm/arm/vgic/vgic-mmio-v2.c               | 47 +++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index b2f60ca..b3ce126 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -83,6 +83,11 @@ Groups:
 
     Bits for undefined preemption levels are RAZ/WI.
 
+    Note that this differs from a CPU's view of the APRs on hardware in which
+    a GIC without the security extensions expose group 0 and group 1 active
+    priorities in separate register groups, whereas we show a combined view
+    similar to GICv2's GICH_APR.
+
     For historical reasons and to provide ABI compatibility with userspace we
     export the GICC_PMR register in the format of the GICH_VMCR.VMPriMask
     field in the lower 5 bits of a word, meaning that userspace must always
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 37522e6..b3d4a10 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -303,6 +303,51 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 	vgic_set_vmcr(vcpu, &vmcr);
 }
 
+static unsigned long vgic_mmio_read_apr(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len)
+{
+	int n; /* which APRn is this */
+
+	n = (addr >> 2) & 0x3;
+
+	if (kvm_vgic_global_state.type == VGIC_V2) {
+		/* GICv2 hardware systems support max. 32 groups */
+		if (n != 0)
+			return 0;
+		return vcpu->arch.vgic_cpu.vgic_v2.vgic_apr;
+	} else {
+		struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+		if (n > vgic_v3_max_apr_idx(vcpu))
+			return 0;
+		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
+		return vgicv3->vgic_ap1r[n];
+	}
+}
+
+static void vgic_mmio_write_apr(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val)
+{
+	int n; /* which APRn is this */
+
+	n = (addr >> 2) & 0x3;
+
+	if (kvm_vgic_global_state.type == VGIC_V2) {
+		/* GICv2 hardware systems support max. 32 groups */
+		if (n != 0)
+			return;
+		vcpu->arch.vgic_cpu.vgic_v2.vgic_apr = val;
+	} else {
+		struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+		if (n > vgic_v3_max_apr_idx(vcpu))
+			return;
+		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
+		vgicv3->vgic_ap1r[n] = val;
+	}
+}
+
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
@@ -364,7 +409,7 @@ static const struct vgic_register_region vgic_v2_cpu_registers[] = {
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+		vgic_mmio_read_apr, vgic_mmio_write_apr, 16,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
-- 
2.9.0

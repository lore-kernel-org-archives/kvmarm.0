From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: new-vgic: add proper GICv2 CPU interface
 userland access
Date: Tue, 3 May 2016 18:59:15 +0100
Message-ID: <5728E6F3.6000801@arm.com>
References: <57287A89.9010809@arm.com>
 <1462291649-9906-1-git-send-email-andre.przywara@arm.com>
 <5728D92A.9010503@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5728D92A.9010503@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/05/16 18:00, Marc Zyngier wrote:
> On 03/05/16 17:07, Andre Przywara wrote:
>> Although the actual register access was wired, the availability check
>> for the GICv2 CPU interface register interface was not - leading to
>> any attempt of saving or restoring GICv2 CPU i/f registers to fail.
>>
>> This patch fixes this by modelling the CPU i/f registers similarily to
>> the distributor registers, thereby piggy backing on the existing
>> distributor save/restore code to do the heavy lifting.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Hi,
>>
>> this is a fix for the missing CPU i/f migration that Marc spotted.
>> In a repost I will merge this somehow into the existing patches, but
>> for now this goes on top of the series.
>> Can any of you have a look whether this is the right way to go?
> 
> The whole VMCR story feels very convoluted. It caters for GICv3 (which
> has no way to use it), has global symbols where it should be static,
> and indirections that serve no apparent purpose. And the vgic_vmcr
> structure should really per implementation. </rant> ;-)
> 
> So here's my take on this particular patch:

[... lots of stupid code deleted ...]

Which is completely wrong. I missed the case where we emulate GICv2 on GICv3. So, here's a much smaller patch that goes on top of yours (making the vmcr accessors static and reworking the MMIO handlers):

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index dddd8e1..1967a52 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -206,6 +206,22 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	}
 }
 
+static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+{
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_set_vmcr(vcpu, vmcr);
+	else
+		vgic_v3_set_vmcr(vcpu, vmcr);
+}
+
+static void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+{
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_get_vmcr(vcpu, vmcr);
+	else
+		vgic_v3_get_vmcr(vcpu, vmcr);
+}
+
 #define GICC_ARCH_VERSION_V2	0x2
 
 /* These are for userland accesses only, there is no guest-facing emulation. */
@@ -213,33 +229,33 @@ static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
 					   gpa_t addr, unsigned int len)
 {
 	struct vgic_vmcr vmcr;
-	u32 *field;
+	u32 val;
+
+	vgic_get_vmcr(vcpu, &vmcr);
 
 	switch (addr & 0xff) {
 	case GIC_CPU_CTRL:
-		field = &vmcr.ctlr;
+		val = vmcr.ctlr;
 		break;
 	case GIC_CPU_PRIMASK:
-		field = &vmcr.pmr;
+		val = vmcr.pmr;
 		break;
 	case GIC_CPU_BINPOINT:
-		field = &vmcr.bpr;
+		val = vmcr.bpr;
 		break;
 	case GIC_CPU_ALIAS_BINPOINT:
-		field = &vmcr.abpr;
+		val = vmcr.abpr;
 		break;
 	case GIC_CPU_IDENT:
-		return extract_bytes((PRODUCT_ID_KVM << 20) |
-				     (GICC_ARCH_VERSION_V2 << 16) |
-				     (IMPLEMENTER_ARM << 0),
-				     addr & 3, len);
+		val = ((PRODUCT_ID_KVM << 20) |
+		       (GICC_ARCH_VERSION_V2 << 16) |
+		       IMPLEMENTER_ARM);
+		break;
 	default:
 		return 0;
 	}
 
-	vgic_get_vmcr(vcpu, &vmcr);
-
-	return extract_bytes(*field, addr & 3, len);
+	return extract_bytes(val, addr & 3, len);
 }
 
 static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
@@ -247,30 +263,24 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 				   unsigned long val)
 {
 	struct vgic_vmcr vmcr;
-	u32 *field;
+
+	vgic_get_vmcr(vcpu, &vmcr);
 
 	switch (addr & 0xff) {
 	case GIC_CPU_CTRL:
-		field = &vmcr.ctlr;
+		vmcr.ctlr = val;
 		break;
 	case GIC_CPU_PRIMASK:
-		field = &vmcr.pmr;
+		vmcr.pmr = val;
 		break;
 	case GIC_CPU_BINPOINT:
-		field = &vmcr.bpr;
+		vmcr.bpr = val;
 		break;
 	case GIC_CPU_ALIAS_BINPOINT:
-		field = &vmcr.abpr;
+		vmcr.abpr = val;
 		break;
-	default:
-		return;
 	}
 
-	vgic_get_vmcr(vcpu, &vmcr);
-	if (*field == val)
-		return;
-
-	*field = val;
 	vgic_set_vmcr(vcpu, &vmcr);
 }
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 5f21742..b22e2ac 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -482,22 +482,6 @@ static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
 		vgic_v3_set_underflow(vcpu);
 }
 
-void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
-{
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_set_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_set_vmcr(vcpu, vmcr);
-}
-
-void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
-{
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_get_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_get_vmcr(vcpu, vmcr);
-}
-
 static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c1f3751..800be90 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -116,9 +116,6 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 }
 #endif
 
-void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
-void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
-
 int vgic_lazy_init(struct kvm *kvm);
 int vgic_init(struct kvm *kvm);
 void kvm_register_vgic_device(unsigned long type);


Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

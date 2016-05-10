From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic-new: fix overlap check for device addresses
Date: Tue, 10 May 2016 11:58:42 +0100
Message-ID: <1462877922-8743-1-git-send-email-andre.przywara@arm.com>
References: <5730C65D.5000609@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5730C65D.5000609@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When userland sets the base addresses for the GIC register frames,
the kernel tries to make sure that the regions for the distributor and
the one for the CPU interface or the redistributors do not overlap.
Only that this check currently takes care of a GICv2 model only.
Rework the overlap check to take a GICv3 in account also.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi Marc,

this one goes on top of the new-vgic-v3 series.
Does this address your concerns about the overlap check?
I'd be grateful if you could apply some of your C wizardry on the first
function ;-)

Cheers,
Andre.

 virt/kvm/arm/vgic/vgic-kvm-device.c | 59 ++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 2122ff2..fcf38ef 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -21,41 +21,63 @@
 
 /* common helpers */
 
-static int vgic_ioaddr_overlap(struct kvm *kvm)
+static phys_addr_t vgic_get_existing_region(struct kvm *kvm, phys_addr_t *addr)
 {
-	phys_addr_t dist = kvm->arch.vgic.vgic_dist_base;
-	phys_addr_t cpu = kvm->arch.vgic.vgic_cpu_base;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	phys_addr_t cpu_addr;
+	bool is_vgicv2 = (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2);
 
-	if (IS_VGIC_ADDR_UNDEF(dist) || IS_VGIC_ADDR_UNDEF(cpu))
-		return 0;
-	if ((dist <= cpu && dist + KVM_VGIC_V2_DIST_SIZE > cpu) ||
-	    (cpu <= dist && cpu + KVM_VGIC_V2_CPU_SIZE > dist))
-		return -EBUSY;
-	return 0;
+	cpu_addr = is_vgicv2 ? dist->vgic_cpu_base : dist->vgic_redist_base;
+
+	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base)) {
+		if (IS_VGIC_ADDR_UNDEF(cpu_addr))
+			return 0;
+
+		*addr = cpu_addr;
+		if (is_vgicv2)
+			return KVM_VGIC_V2_CPU_SIZE;
+		return atomic_read(&kvm->online_vcpus) * KVM_VGIC_V3_REDIST_SIZE;
+	}
+
+	*addr = dist->vgic_dist_base;
+	return is_vgicv2 ? KVM_VGIC_V2_DIST_SIZE : KVM_VGIC_V3_DIST_SIZE;
+}
+
+static bool vgic_ioaddr_overlap(struct kvm *kvm, phys_addr_t addr,
+				phys_addr_t size)
+{
+	phys_addr_t used_addr, used_size;
+
+	used_size = vgic_get_existing_region(kvm, &used_addr);
+	if (!used_size)
+		return false;
+
+	if (addr + size <= used_addr)
+		return false;
+
+	if (used_addr + used_size <= addr)
+		return false;
+
+	return true;
 }
 
 static int vgic_ioaddr_assign(struct kvm *kvm, phys_addr_t *ioaddr,
 			      phys_addr_t addr, phys_addr_t size)
 {
-	int ret;
-
 	if (addr & ~KVM_PHYS_MASK)
 		return -E2BIG;
 
-	if (addr & (SZ_4K - 1))
-		return -EINVAL;
-
 	if (!IS_VGIC_ADDR_UNDEF(*ioaddr))
 		return -EEXIST;
 	if (addr + size < addr)
 		return -EINVAL;
 
+	if (vgic_ioaddr_overlap(kvm, addr, size))
+		return -EBUSY;
+
 	*ioaddr = addr;
-	ret = vgic_ioaddr_overlap(kvm);
-	if (ret)
-		*ioaddr = VGIC_ADDR_UNDEF;
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -104,6 +126,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
 		addr_ptr = &vgic->vgic_redist_base;
 		block_size = KVM_VGIC_V3_REDIST_SIZE;
+		block_size *= atomic_read(&kvm->online_vcpus);
 		alignment = SZ_64K;
 		break;
 #endif
-- 
2.7.3


From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic: Prevent access to invalid SPIs
Date: Fri, 28 Oct 2016 11:28:18 +0100
Message-ID: <1477650498-19200-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

In our VGIC implementation we limit the number of SPIs to a number
that the userland application told us. Accordingly we limit the
allocation of memory for virtual IRQs to that number.
However in our MMIO dispatcher we didn't check if we ever access an
IRQ beyond that limit, leading to out-of-bound accesses.
Add a test against the number of allocated SPIs in check_region().

[maz: cleaned-up original patch]

Cc: stable@vger.kernel.org
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index e18b30d..ebe1b9f 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -453,17 +453,33 @@ struct vgic_io_device *kvm_to_vgic_iodev(const struct kvm_io_device *dev)
 	return container_of(dev, struct vgic_io_device, dev);
 }
 
-static bool check_region(const struct vgic_register_region *region,
+static bool check_region(const struct kvm *kvm,
+			 const struct vgic_register_region *region,
 			 gpa_t addr, int len)
 {
-	if ((region->access_flags & VGIC_ACCESS_8bit) && len == 1)
-		return true;
-	if ((region->access_flags & VGIC_ACCESS_32bit) &&
-	    len == sizeof(u32) && !(addr & 3))
-		return true;
-	if ((region->access_flags & VGIC_ACCESS_64bit) &&
-	    len == sizeof(u64) && !(addr & 7))
-		return true;
+	int flags, nr_irqs = kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+
+	switch (len) {
+	case sizeof(u8):
+		flags = VGIC_ACCESS_8bit;
+		break;
+	case sizeof(u32):
+		flags = VGIC_ACCESS_32bit;
+		break;
+	case sizeof(u64):
+		flags = VGIC_ACCESS_64bit;
+		break;
+	default:
+		return false;
+	}
+
+	if ((region->access_flags & flags) && IS_ALIGNED(addr, len)) {
+		if (!region->bits_per_irq)
+			return true;
+
+		/* Do we access a non-allocated IRQ? */
+		return VGIC_ADDR_TO_INTID(addr, region->bits_per_irq) < nr_irqs;
+	}
 
 	return false;
 }
@@ -477,7 +493,7 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 
 	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
 				       addr - iodev->base_addr);
-	if (!region || !check_region(region, addr, len)) {
+	if (!region || !check_region(vcpu->kvm, region, addr, len)) {
 		memset(val, 0, len);
 		return 0;
 	}
@@ -510,10 +526,7 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 
 	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
 				       addr - iodev->base_addr);
-	if (!region)
-		return 0;
-
-	if (!check_region(region, addr, len))
+	if (!region || !check_region(vcpu->kvm, region, addr, len))
 		return 0;
 
 	switch (iodev->iodev_type) {
-- 
2.1.4


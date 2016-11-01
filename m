From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3] KVM: arm/arm64: vgic: Prevent access to invalid SPIs
Date: Tue,  1 Nov 2016 18:00:08 +0000
Message-ID: <20161101180008.6956-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0355E402EC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 13:59:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OPAutvRknrET for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2016 13:59:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F3DD4028D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 13:59:37 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

In our VGIC implementation we limit the number of SPIs to a number
that the userland application told us. Accordingly we limit the
allocation of memory for virtual IRQs to that number.
However in our MMIO dispatcher we didn't check if we ever access an
IRQ beyond that limit, leading to out-of-bound accesses.
Add a test against the number of allocated SPIs in check_region().
Adjust the VGIC_ADDR_TO_INT macro to avoid an actual division, which
is not implemented on ARM(32).

[maz: cleaned-up original patch]

Cc: stable@vger.kernel.org
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
Hi,

I checked that the old and new VGIC_ADDR_TO_INTID() algorithm give
identical results by moving it into a small userland unit-test, using
all <bits> values we use in the VGIC and calling it with quite some test
addresses. No differences were found.

Cheers,
Andre.

Changelog v2 .. v3:
- further simplify VGIC_ADDR_TO_INTID
- adjust VGIC_ADDR_TO_INTID comment

Changelog v1 .. v2:
- fix compilation for 32-bit ARM

 virt/kvm/arm/vgic/vgic-mmio.c | 41 +++++++++++++++++++++++++++--------------
 virt/kvm/arm/vgic/vgic-mmio.h | 14 +++++++-------
 2 files changed, 34 insertions(+), 21 deletions(-)

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
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 4c34d39..84961b4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -50,15 +50,15 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
 #define VGIC_ADDR_IRQ_MASK(bits) (((bits) * 1024 / 8) - 1)
 
 /*
- * (addr & mask) gives us the byte offset for the INT ID, so we want to
- * divide this with 'bytes per irq' to get the INT ID, which is given
- * by '(bits) / 8'.  But we do this with fixed-point-arithmetic and
- * take advantage of the fact that division by a fraction equals
- * multiplication with the inverted fraction, and scale up both the
- * numerator and denominator with 8 to support at most 64 bits per IRQ:
+ * (addr & mask) gives us the _byte_ offset for the INT ID.
+ * We multiply this by 8 the get the _bit_ offset, then divide this by
+ * the number of bits to learn the actual INT ID.
+ * But instead of a division (which requires a "long long div" implementation),
+ * we shift by the binary logarithm of <bits>.
+ * This assumes that <bits> is a power of two.
  */
 #define VGIC_ADDR_TO_INTID(addr, bits)  (((addr) & VGIC_ADDR_IRQ_MASK(bits)) * \
-					64 / (bits) / 8)
+					8 >> ilog2(bits))
 
 /*
  * Some VGIC registers store per-IRQ information, with a different number
-- 
2.9.0

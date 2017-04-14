From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 04/22] arm/arm64: vgic: turn vgic_find_mmio_region into public
Date: Fri, 14 Apr 2017 12:15:16 +0200
Message-ID: <1492164934-988-5-git-send-email-eric.auger@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

We plan to use vgic_find_mmio_region in vgic-its.c so let's
turn it into a public function.

Also let's take the opportunity to rename the region parameter
into regions to emphasize this latter is an array of regions.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

---
v4 -> v5:
- add Marc's A-b

v3 -> v4:
- rename region parameter into regions
- add Andre's R-b
---
 virt/kvm/arm/vgic/vgic-mmio.c | 11 +++++------
 virt/kvm/arm/vgic/vgic-mmio.h |  5 +++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 2a5db13..1c17b2a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -446,13 +446,12 @@ static int match_region(const void *key, const void *elt)
 	return 0;
 }
 
-/* Find the proper register handler entry given a certain address offset. */
-static const struct vgic_register_region *
-vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
-		      unsigned int offset)
+const struct vgic_register_region *
+vgic_find_mmio_region(const struct vgic_register_region *regions,
+		      int nr_regions, unsigned int offset)
 {
-	return bsearch((void *)(uintptr_t)offset, region, nr_regions,
-		       sizeof(region[0]), match_region);
+	return bsearch((void *)(uintptr_t)offset, regions, nr_regions,
+		       sizeof(regions[0]), match_region);
 }
 
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 98bb566..6eec91b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -192,4 +192,9 @@ u64 vgic_sanitise_shareability(u64 reg);
 u64 vgic_sanitise_field(u64 reg, u64 field_mask, int field_shift,
 			u64 (*sanitise_fn)(u64));
 
+/* Find the proper register handler entry given a certain address offset */
+const struct vgic_register_region *
+vgic_find_mmio_region(const struct vgic_register_region *regions,
+		      int nr_regions, unsigned int offset);
+
 #endif
-- 
2.5.5

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3] KVM: arm64: vgic-its: Make updates to propbaser/pendbaser atomic
Date: Mon, 15 Aug 2016 23:15:31 +0200
Message-ID: <20160815211531.30350-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

There are two problems with the current implementation of the MMIO
handlers for the propbaser and pendbaser:

First, the write to the value itself is not guaranteed to be an atomic
64-bit write so two concurrent writes to the structure field could be
intermixed.

Second, because we do a read-modify-update operation without any
synchronization, if we have two 32-bit accesses to separate parts of the
register, we can loose one of them.

By using the atomic cmpxchg64 we should cover both issues above.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changes since v2:
 - I misread the implementation and example uses of cmpxchg64 and
   checked the return value for non-zero instead of comparing with the
   old value.
 - Dropped Andre's R-B

Changes since v1:
 - Use atomic cmpxchg64 instead of taking a lock
 
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index ff668e0..90d8181 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -306,16 +306,19 @@ static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	u64 propbaser = dist->propbaser;
+	u64 old_propbaser, propbaser;
 
 	/* Storing a value with LPIs already enabled is undefined */
 	if (vgic_cpu->lpis_enabled)
 		return;
 
-	propbaser = update_64bit_reg(propbaser, addr & 4, len, val);
-	propbaser = vgic_sanitise_propbaser(propbaser);
-
-	dist->propbaser = propbaser;
+	do {
+		old_propbaser = dist->propbaser;
+		propbaser = old_propbaser;
+		propbaser = update_64bit_reg(propbaser, addr & 4, len, val);
+		propbaser = vgic_sanitise_propbaser(propbaser);
+	} while (cmpxchg64(&dist->propbaser, old_propbaser,
+			   propbaser) != old_propbaser);
 }
 
 static unsigned long vgic_mmio_read_pendbase(struct kvm_vcpu *vcpu,
@@ -331,16 +334,19 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 				     unsigned long val)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	u64 pendbaser = vgic_cpu->pendbaser;
+	u64 old_pendbaser, pendbaser;
 
 	/* Storing a value with LPIs already enabled is undefined */
 	if (vgic_cpu->lpis_enabled)
 		return;
 
-	pendbaser = update_64bit_reg(pendbaser, addr & 4, len, val);
-	pendbaser = vgic_sanitise_pendbaser(pendbaser);
-
-	vgic_cpu->pendbaser = pendbaser;
+	do {
+		old_pendbaser = vgic_cpu->pendbaser;
+		pendbaser = old_pendbaser;
+		pendbaser = update_64bit_reg(pendbaser, addr & 4, len, val);
+		pendbaser = vgic_sanitise_pendbaser(pendbaser);
+	} while (cmpxchg64(&vgic_cpu->pendbaser, old_pendbaser,
+			   pendbaser) != old_pendbaser);
 }
 
 /*
-- 
2.9.0


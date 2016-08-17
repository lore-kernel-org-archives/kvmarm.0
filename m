From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 04/12] KVM: arm64: vgic-its: Make updates to
 propbaser/pendbaser atomic
Date: Wed, 17 Aug 2016 21:38:51 +0200
Message-ID: <20160817193859.15726-5-christoffer.dall@linaro.org>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 680CE412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 15:29:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5bg14MUcv64v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 15:29:35 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6943412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 15:29:34 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id d196so39513871wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 12:37:04 -0700 (PDT)
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
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

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
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

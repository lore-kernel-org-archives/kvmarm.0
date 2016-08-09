From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 3/3] KVM: arm64: vgic-its: Make updates to
 propbaser/pendbaser atomic
Date: Tue,  9 Aug 2016 13:16:06 +0200
Message-ID: <20160809111606.28744-4-christoffer.dall@linaro.org>
References: <20160809111606.28744-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7480849B4E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 07:07:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e-LMNxfR4TGV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 07:07:18 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F3FF49B59
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 07:07:17 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id i5so27419854wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2016 04:14:24 -0700 (PDT)
In-Reply-To: <20160809111606.28744-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

Notes:
    Changes since v1:
     - Use atomic cmpxchg64 instead of taking a lock

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index ff668e0..a50d5ba 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -306,16 +306,18 @@ static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
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
+	} while (cmpxchg64(&dist->propbaser, old_propbaser, propbaser));
 }
 
 static unsigned long vgic_mmio_read_pendbase(struct kvm_vcpu *vcpu,
@@ -331,16 +333,18 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
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
+	} while (cmpxchg64(&vgic_cpu->pendbaser, old_pendbaser, pendbaser));
 }
 
 /*
-- 
2.9.0

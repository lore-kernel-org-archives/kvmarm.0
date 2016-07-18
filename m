From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 3/7] KVM: arm: vgic-new: improve compatibility with 32-bit
Date: Mon, 18 Jul 2016 11:48:15 +0100
Message-ID: <1468838899-34909-4-git-send-email-vladimir.murzin@arm.com>
References: <1468838899-34909-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E8F49B32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:42:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X+ceZS2KpiW5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 06:42:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D9449B3C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:42:39 -0400 (EDT)
In-Reply-To: <1468838899-34909-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

We have couple of 64-bit register defined in GICv3 architecture, so
"unsigned long" kind of accessors wouldn't work for 32-bit. However,
these registers can't be access as 64-bit in a one go if we run 32-bit
host simply beacuse KVM doesn't support multiple load/store on MMIO
space.

It means that 32-bit guest accesses these registers in 32-bit chunks, so
the only thing we need to do is to ensure that extract_bytes() always
takes 64-bit data.

Since we are here fix couple of other width releated issues by using
ULL varians over UL.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index a0c515a..a266304 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -23,7 +23,7 @@
 #include "vgic-mmio.h"
 
 /* extract @num bytes at @offset bytes offset in data */
-static unsigned long extract_bytes(unsigned long data, unsigned int offset,
+static unsigned long extract_bytes(u64 data, unsigned int offset,
 				   unsigned int num)
 {
 	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
@@ -121,7 +121,7 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 	int target_vcpu_id = vcpu->vcpu_id;
 	u64 value;
 
-	value = (mpidr & GENMASK(23, 0)) << 32;
+	value = (mpidr & GENMASK_ULL(23, 0)) << 32;
 	value |= ((target_vcpu_id & 0xffff) << 8);
 	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
 		value |= GICR_TYPER_LAST;
@@ -411,7 +411,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 	bool broadcast;
 
 	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
-	broadcast = reg & BIT(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
+	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
 	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
 	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
 	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
-- 
1.7.9.5

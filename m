From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] kvmtool/arm: Fix timer trigger
Date: Mon, 13 Jun 2016 15:09:45 +0100
Message-ID: <1465826985-14737-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

KVM exposes a level triggered timer to the guest, and yet kvmtool
presents it as being edge-triggered in the DT. Let's fix it and
match what the kernel exposes.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arm/timer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 29991da..71bfe8d 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -15,19 +15,19 @@ void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
 	u32 irq_prop[] = {
 		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
 		cpu_to_fdt32(irqs[0]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_EDGE_RISING),
+		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
 
 		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
 		cpu_to_fdt32(irqs[1]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_EDGE_RISING),
+		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
 
 		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
 		cpu_to_fdt32(irqs[2]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_EDGE_RISING),
+		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
 
 		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
 		cpu_to_fdt32(irqs[3]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_EDGE_RISING),
+		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
 	};
 
 	_FDT(fdt_begin_node(fdt, "timer"));
-- 
2.1.4


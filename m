From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/2] KVM: arm/arm64: check IRQ number on userland injection
Date: Wed, 22 Apr 2015 16:08:38 +0100
Message-ID: <1429715318-31725-3-git-send-email-marc.zyngier@arm.com>
References: <1429715318-31725-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1429715318-31725-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Andre Przywara <andre.przywara@arm.com>, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

When userland injects a SPI via the KVM_IRQ_LINE ioctl we currently
only check it against a fixed limit, which historically is set
to 127. With the new dynamic IRQ allocation the effective limit may
actually be smaller (64).
So when now a malicious or buggy userland injects a SPI in that
range, we spill over on our VGIC bitmaps and bytemaps memory.
I could trigger a host kernel NULL pointer dereference with current
mainline by injecting some bogus IRQ number from a hacked kvmtool:
-----------------
....
DEBUG: kvm_vgic_inject_irq(kvm, cpu=0, irq=114, level=1)
DEBUG: vgic_update_irq_pending(kvm, cpu=0, irq=114, level=1)
DEBUG: IRQ #114 still in the game, writing to bytemap now...
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = ffffffc07652e000
[00000000] *pgd=00000000f658b003, *pud=00000000f658b003, *pmd=0000000000000000
Internal error: Oops: 96000006 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 1053 Comm: lkvm-msi-irqinj Not tainted 4.0.0-rc7+ #3027
Hardware name: FVP Base (DT)
task: ffffffc0774e9680 ti: ffffffc0765a8000 task.ti: ffffffc0765a8000
PC is at kvm_vgic_inject_irq+0x234/0x310
LR is at kvm_vgic_inject_irq+0x30c/0x310
pc : [<ffffffc0000ae0a8>] lr : [<ffffffc0000ae180>] pstate: 80000145
.....

So this patch fixes this by checking the SPI number against the
actual limit. Also we remove the former legacy hard limit of
127 in the ioctl code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
CC: <stable@vger.kernel.org> # 4.0, 3.19, 3.18
[maz: wrap KVM_ARM_IRQ_GIC_MAX with #ifndef __KERNEL__,
as suggested by Christopher Covington]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/uapi/asm/kvm.h   | 8 +++++++-
 arch/arm/kvm/arm.c                | 3 +--
 arch/arm64/include/uapi/asm/kvm.h | 8 +++++++-
 virt/kvm/arm/vgic.c               | 3 +++
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 2499867..df3f60c 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -195,8 +195,14 @@ struct kvm_arch_memory_slot {
 #define KVM_ARM_IRQ_CPU_IRQ		0
 #define KVM_ARM_IRQ_CPU_FIQ		1
 
-/* Highest supported SPI, from VGIC_NR_IRQS */
+/*
+ * This used to hold the highest supported SPI, but it is now obsolete
+ * and only here to provide source code level compatibility with older
+ * userland. The highest SPI number can be set via KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
+ */
+#ifndef __KERNEL__
 #define KVM_ARM_IRQ_GIC_MAX		127
+#endif
 
 /* One single KVM irqchip, ie. the VGIC */
 #define KVM_NR_IRQCHIPS          1
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 6f53645..d9631ec 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -671,8 +671,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
 
-		if (irq_num < VGIC_NR_PRIVATE_IRQS ||
-		    irq_num > KVM_ARM_IRQ_GIC_MAX)
+		if (irq_num < VGIC_NR_PRIVATE_IRQS)
 			return -EINVAL;
 
 		return kvm_vgic_inject_irq(kvm, 0, irq_num, level);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index c154c0b..d268320 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -188,8 +188,14 @@ struct kvm_arch_memory_slot {
 #define KVM_ARM_IRQ_CPU_IRQ		0
 #define KVM_ARM_IRQ_CPU_FIQ		1
 
-/* Highest supported SPI, from VGIC_NR_IRQS */
+/*
+ * This used to hold the highest supported SPI, but it is now obsolete
+ * and only here to provide source code level compatibility with older
+ * userland. The highest SPI number can be set via KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
+ */
+#ifndef __KERNEL__
 #define KVM_ARM_IRQ_GIC_MAX		127
+#endif
 
 /* One single KVM irqchip, ie. the VGIC */
 #define KVM_NR_IRQCHIPS          1
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 7ed7873..78fb820 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1561,6 +1561,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			goto out;
 	}
 
+	if (irq_num >= kvm->arch.vgic.nr_irqs)
+		return -EINVAL;
+
 	vcpu_id = vgic_update_irq_pending(kvm, cpuid, irq_num, level);
 	if (vcpu_id >= 0) {
 		/* kick the specified vcpu */
-- 
2.1.4


From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] KVM: arm/arm64: check IRQ number on userland injection
Date: Fri, 10 Apr 2015 16:17:59 +0100
Message-ID: <1428679079-16499-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFC454C15D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 11:10:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tjBSKlKWnvoB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 11:10:22 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65EA44C15E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 11:10:21 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

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
CC: <stable@vger.kernel.org> # 4.0, 3.19, 3.18
---
 arch/arm/include/uapi/asm/kvm.h   |    6 +++++-
 arch/arm/kvm/arm.c                |    3 +--
 arch/arm64/include/uapi/asm/kvm.h |    6 +++++-
 virt/kvm/arm/vgic.c               |    3 +++
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 0db25bc..9d5ed83 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -195,7 +195,11 @@ struct kvm_arch_memory_slot {
 #define KVM_ARM_IRQ_CPU_IRQ		0
 #define KVM_ARM_IRQ_CPU_FIQ		1
 
-/* Highest supported SPI, from VGIC_NR_IRQS */
+/*
+ * This used to hold the highest supported SPI, but it is now obsolete
+ * and only here to provide source code level compatibility with older
+ * userland. The highest SPI number can be set via KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
+ */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
 /* PSCI interface */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 4f0afeb..0bbc0aa 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -653,8 +653,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
 
-		if (irq_num < VGIC_NR_PRIVATE_IRQS ||
-		    irq_num > KVM_ARM_IRQ_GIC_MAX)
+		if (irq_num < VGIC_NR_PRIVATE_IRQS)
 			return -EINVAL;
 
 		return kvm_vgic_inject_irq(kvm, 0, irq_num, level);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 3ef77a4..cc4affe 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -188,7 +188,11 @@ struct kvm_arch_memory_slot {
 #define KVM_ARM_IRQ_CPU_IRQ		0
 #define KVM_ARM_IRQ_CPU_FIQ		1
 
-/* Highest supported SPI, from VGIC_NR_IRQS */
+/*
+ * This used to hold the highest supported SPI, but it is now obsolete
+ * and only here to provide source code level compatibility with older
+ * userland. The highest SPI number can be set via KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
+ */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
 /* PSCI interface */
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 1b4c344..b0dd2d9 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1372,6 +1372,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			goto out;
 	}
 
+	if (irq_num >= kvm->arch.vgic.nr_irqs)
+		return -EINVAL;
+
 	vcpu_id = vgic_update_irq_pending(kvm, cpuid, irq_num, level);
 	if (vcpu_id >= 0) {
 		/* kick the specified vcpu */
-- 
1.7.9.5

From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 55/95] ARM: KVM: Use common version of vgic-v2-sr.c
Date: Wed,  9 Mar 2016 07:30:49 +0000
Message-ID: <1457508689-19672-56-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0230A49B2C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mbKKyTMKM3bm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:34:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C12E49B5C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:20 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

No need to keep our own private version, the common one is
strictly identical.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/Makefile     |  5 ++-
 arch/arm/kvm/hyp/vgic-v2-sr.c | 82 -------------------------------------------
 2 files changed, 4 insertions(+), 83 deletions(-)
 delete mode 100644 arch/arm/kvm/hyp/vgic-v2-sr.c

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 7152369..8f735d9 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -2,10 +2,13 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #
 
+KVM=../../../../virt/kvm
+
+obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
+
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += cp15-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
 obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
diff --git a/arch/arm/kvm/hyp/vgic-v2-sr.c b/arch/arm/kvm/hyp/vgic-v2-sr.c
deleted file mode 100644
index 9514a7d..0000000
--- a/arch/arm/kvm/hyp/vgic-v2-sr.c
+++ /dev/null
@@ -1,82 +0,0 @@
-/*
- * Copyright (C) 2012-2015 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/compiler.h>
-#include <linux/irqchip/arm-gic.h>
-#include <linux/kvm_host.h>
-
-#include <asm/kvm_hyp.h>
-
-/* vcpu is already in the HYP VA space */
-void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &kvm->arch.vgic;
-	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	u32 eisr0, eisr1, elrsr0, elrsr1;
-	int i, nr_lr;
-
-	if (!base)
-		return;
-
-	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
-	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
-	cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
-	eisr0  = readl_relaxed(base + GICH_EISR0);
-	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
-	if (unlikely(nr_lr > 32)) {
-		eisr1  = readl_relaxed(base + GICH_EISR1);
-		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
-	} else {
-		eisr1 = elrsr1 = 0;
-	}
-#ifdef CONFIG_CPU_BIG_ENDIAN
-	cpu_if->vgic_eisr  = ((u64)eisr0 << 32) | eisr1;
-	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
-#else
-	cpu_if->vgic_eisr  = ((u64)eisr1 << 32) | eisr0;
-	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
-#endif
-	cpu_if->vgic_apr    = readl_relaxed(base + GICH_APR);
-
-	writel_relaxed(0, base + GICH_HCR);
-
-	for (i = 0; i < nr_lr; i++)
-		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
-}
-
-/* vcpu is already in the HYP VA space */
-void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &kvm->arch.vgic;
-	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	int i, nr_lr;
-
-	if (!base)
-		return;
-
-	writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
-	writel_relaxed(cpu_if->vgic_vmcr, base + GICH_VMCR);
-	writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
-
-	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
-	for (i = 0; i < nr_lr; i++)
-		writel_relaxed(cpu_if->vgic_lr[i], base + GICH_LR0 + (i * 4));
-}
-- 
2.1.4

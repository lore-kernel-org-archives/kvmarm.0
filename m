From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 4/5] ARM: KVM: Use common version of vgic-v2-sr.c
Date: Thu, 28 Jan 2016 15:56:04 +0000
Message-ID: <1453996565-19666-5-git-send-email-marc.zyngier@arm.com>
References: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

No need to keep our own private version, the common one is
strictly identical.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/Makefile     |  5 ++-
 arch/arm/kvm/hyp/vgic-v2-sr.c | 82 -------------------------------------------
 2 files changed, 4 insertions(+), 83 deletions(-)
 delete mode 100644 arch/arm/kvm/hyp/vgic-v2-sr.c

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index a7d3a7e..34645a4 100644
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


From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 5/5] ARM: KVM: Use common version of timer-sr.c
Date: Thu, 28 Jan 2016 15:56:05 +0000
Message-ID: <1453996565-19666-6-git-send-email-marc.zyngier@arm.com>
References: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Using the common HYP timer code is a bit more tricky, since we
use system register names. Nothing a set of macros cannot
work around...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_hyp.h |  9 ++++++
 arch/arm/kvm/hyp/Makefile      |  2 +-
 arch/arm/kvm/hyp/timer-sr.c    | 69 ------------------------------------------
 3 files changed, 10 insertions(+), 70 deletions(-)
 delete mode 100644 arch/arm/kvm/hyp/timer-sr.c

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 8bbd2a7..dff2f95 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -102,6 +102,15 @@
 
 #define VFP_FPEXC	__ACCESS_VFP(FPEXC)
 
+/* AArch64 compatibility macros, only for the timer so far */
+#define read_sysreg_el0(r)		read_sysreg(r##_el0)
+#define write_sysreg_el0(v, r)		write_sysreg(v, r##_el0)
+
+#define cntv_ctl_el0			CNTV_CTL
+#define cntv_cval_el0			CNTV_CVAL
+#define cntvoff_el2			CNTVOFF
+#define cnthctl_el2			CNTHCTL
+
 void __timer_save_state(struct kvm_vcpu *vcpu);
 void __timer_restore_state(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 34645a4..2d6c33e 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -5,10 +5,10 @@
 KVM=../../../../virt/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
 
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += cp15-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
 obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
diff --git a/arch/arm/kvm/hyp/timer-sr.c b/arch/arm/kvm/hyp/timer-sr.c
deleted file mode 100644
index 2bb0c92..0000000
--- a/arch/arm/kvm/hyp/timer-sr.c
+++ /dev/null
@@ -1,69 +0,0 @@
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
-#include <clocksource/arm_arch_timer.h>
-#include <linux/compiler.h>
-#include <linux/kvm_host.h>
-
-#include <asm/kvm_hyp.h>
-
-/* vcpu is already in the HYP VA space */
-void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	u64 val;
-
-	if (kvm->arch.timer.enabled) {
-		timer->cntv_ctl = read_sysreg(CNTV_CTL);
-		timer->cntv_cval = read_sysreg(CNTV_CVAL);
-	}
-
-	/* Disable the virtual timer */
-	write_sysreg(0, CNTV_CTL);
-
-	/* Allow physical timer/counter access for the host */
-	val = read_sysreg(CNTHCTL);
-	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
-	write_sysreg(val, CNTHCTL);
-
-	/* Clear cntvoff for the host */
-	write_sysreg(0, CNTVOFF);
-}
-
-void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	u64 val;
-
-	/*
-	 * Disallow physical timer access for the guest
-	 * Physical counter access is allowed
-	 */
-	val = read_sysreg(CNTHCTL);
-	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
-	write_sysreg(val, CNTHCTL);
-
-	if (kvm->arch.timer.enabled) {
-		write_sysreg(kvm->arch.timer.cntvoff, CNTVOFF);
-		write_sysreg(timer->cntv_cval, CNTV_CVAL);
-		isb();
-		write_sysreg(timer->cntv_ctl, CNTV_CTL);
-	}
-}
-- 
2.1.4


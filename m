From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 58/59] KVM: arm/arm64: vgic-new: enable build
Date: Tue, 24 May 2016 11:09:52 +0200
Message-ID: <1464080993-10884-59-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Now that the new VGIC implementation has reached feature parity with
the old one, add the new files to the build system and add a Kconfig
option to switch between the two versions.
We set the default to the new version to get maximum test coverage,
in case people experience problems they can switch back to the old
behaviour if needed.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/Kconfig          |  7 +++++++
 arch/arm/kvm/Makefile         | 11 +++++++++++
 arch/arm64/kvm/Kconfig        |  7 +++++++
 arch/arm64/kvm/Makefile       | 12 ++++++++++++
 virt/kvm/arm/hyp/vgic-v2-sr.c |  5 +++++
 5 files changed, 42 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 95a0005..02abfff 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -46,6 +46,13 @@ config KVM_ARM_HOST
 	---help---
 	  Provides host support for ARM processors.
 
+config KVM_NEW_VGIC
+	bool "New VGIC implementation"
+	depends on KVM
+	default y
+	---help---
+	  uses the new VGIC implementation
+
 source drivers/vhost/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index eb1bf43..a596b58 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -21,7 +21,18 @@ obj-$(CONFIG_KVM_ARM_HOST) += hyp/
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
 obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
+
+ifeq ($(CONFIG_KVM_NEW_VGIC),y)
+obj-y += $(KVM)/arm/vgic/vgic.o
+obj-y += $(KVM)/arm/vgic/vgic-init.o
+obj-y += $(KVM)/arm/vgic/vgic-irqfd.o
+obj-y += $(KVM)/arm/vgic/vgic-v2.o
+obj-y += $(KVM)/arm/vgic/vgic-mmio.o
+obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
+obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
+else
 obj-y += $(KVM)/arm/vgic.o
 obj-y += $(KVM)/arm/vgic-v2.o
 obj-y += $(KVM)/arm/vgic-v2-emul.o
+endif
 obj-y += $(KVM)/arm/arch_timer.o
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index aa2e34e..c4f26ef 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -54,6 +54,13 @@ config KVM_ARM_PMU
 	  Adds support for a virtual Performance Monitoring Unit (PMU) in
 	  virtual machines.
 
+config KVM_NEW_VGIC
+	bool "New VGIC implementation"
+	depends on KVM
+	default y
+        ---help---
+          uses the new VGIC implementation
+
 source drivers/vhost/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 122cff4..a7a958c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -20,10 +20,22 @@ kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
 
+ifeq ($(CONFIG_KVM_NEW_VGIC),y)
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-init.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-irqfd.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v2.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
+else
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2-emul.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
+endif
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index caac41f..a3f12b3 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -21,7 +21,12 @@
 
 #include <asm/kvm_hyp.h>
 
+#ifdef CONFIG_KVM_NEW_VGIC
+extern struct vgic_global kvm_vgic_global_state;
+#define vgic_v2_params kvm_vgic_global_state
+#else
 extern struct vgic_params vgic_v2_params;
+#endif
 
 static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
 					    void __iomem *base)
-- 
2.1.2.330.g565301e.dirty


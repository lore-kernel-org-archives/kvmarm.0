From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 45/45] KVM: arm/arm64: vgic-new: enable build
Date: Fri, 25 Mar 2016 02:05:08 +0000
Message-ID: <1458871508-17279-46-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A6A240C9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BWpe-n4mE3ni for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7268649B66
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:32 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that the new VGIC implementation has reached feature parity with
the old one, add the new files to the build system and add a Kconfig
option to switch between the two versions.
We set the default to the new version to get maximum test coverage,
in case people experience problems they can switch back to the old
behaviour if needed.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/kvm/Kconfig    |  7 +++++++
 arch/arm/kvm/Makefile   | 10 ++++++++++
 arch/arm64/kvm/Kconfig  |  7 +++++++
 arch/arm64/kvm/Makefile | 10 ++++++++++
 4 files changed, 34 insertions(+)

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
index eb1bf43..aa7d724 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -21,7 +21,17 @@ obj-$(CONFIG_KVM_ARM_HOST) += hyp/
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
 obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
+
+ifeq ($(CONFIG_KVM_NEW_VGIC),y)
+obj-y += $(KVM)/arm/vgic/vgic.o
+obj-y += $(KVM)/arm/vgic/vgic_init.o
+obj-y += $(KVM)/arm/vgic/vgic_irqfd.o
+obj-y += $(KVM)/arm/vgic/vgic-v2.o
+obj-y += $(KVM)/arm/vgic/vgic_mmio.o
+obj-y += $(KVM)/arm/vgic/vgic_kvm_device.o
+else
 obj-y += $(KVM)/arm/vgic.o
 obj-y += $(KVM)/arm/vgic-v2.o
 obj-y += $(KVM)/arm/vgic-v2-emul.o
+endif
 obj-y += $(KVM)/arm/arch_timer.o
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index de7450d..3f0e1ce 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -55,6 +55,13 @@ config KVM_ARM_PMU
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
index 122cff4..2f5d431 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -20,10 +20,20 @@ kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
 
+ifeq ($(CONFIG_KVM_NEW_VGIC),y)
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_init.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_irqfd.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v2.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_mmio.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_kvm_device.o
+else
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2-emul.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
+endif
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
-- 
2.7.3

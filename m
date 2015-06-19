From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/12] KVM: arm/arm64: Enable the KVM-VFIO device
Date: Fri, 19 Jun 2015 13:53:10 +0100
Message-ID: <1434718396-13110-7-git-send-email-marc.zyngier@arm.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Kim Phillips <kim.phillips@linaro.org>, Eric Auger <eric.auger@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Firo Yang <firogm@gmail.com>, Tiejun Chen <tiejun.chen@intel.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Kim Phillips <kim.phillips@linaro.org>

The KVM-VFIO device is used by the QEMU VFIO device. It is used to
record the list of in-use VFIO groups so that KVM can manipulate
them.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/Kconfig    | 1 +
 arch/arm/kvm/Makefile   | 2 +-
 arch/arm64/kvm/Kconfig  | 1 +
 arch/arm64/kvm/Makefile | 2 +-
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index f1f79d1..bfb915d 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -28,6 +28,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select SRCU
 	select MMU_NOTIFIER
+	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 139e46c..c5eef02c 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
 AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
 
 KVM := ../../../virt/kvm
-kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
+kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 5105e29..bfffe8f 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -28,6 +28,7 @@ config KVM
 	select KVM_ARM_HOST
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select SRCU
+	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	---help---
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index d5904f8..f90f4aa 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe kvm" in

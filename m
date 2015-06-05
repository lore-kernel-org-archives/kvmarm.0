From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH] KVM: arm/arm64: Enable the KVM-VFIO device
Date: Fri,  5 Jun 2015 17:21:49 +0200
Message-ID: <1433517709-6872-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, Kim Phillips <kim.phillips@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Kim Phillips <kim.phillips@linaro.org>

The KVM-VFIO device is used by the QEMU VFIO device. It is used to
record the list of in-use VFIO groups so that KVM can manipulate
them.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

- previously included in KVM-VFIO IRQ forward control v6 series.
  Rationale to put it aside is the unavailability of the kvm-vfio device
  causes produces a warning when launching the QEMU VFIO platform device
  that can puzzle some users (although not blocking):
  "Failed to create KVM VFIO device: No such device"
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
1.9.1


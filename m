From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 01/16] KVM: arm/arm64: Enable the KVM-VFIO device
Date: Mon, 13 Apr 2015 14:29:16 +0200
Message-ID: <1428928171-18884-2-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6760B4C3D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V-7wB0iA5Psz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:24:47 -0400 (EDT)
Received: from mail-wg0-f52.google.com (mail-wg0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AA344C3D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:46 -0400 (EDT)
Received: by wgso17 with SMTP id o17so79111114wgs.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:33 -0700 (PDT)
In-Reply-To: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com
Cc: feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Kim Phillips <kim.phillips@linaro.org>

The KVM-VFIO device is used by the QEMU VFIO device. It is used to
record the list of in-use VFIO groups so that KVM can manipulate
them. With this series, it will also be used to record the forwarded
IRQs.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v4 -> v5:
- reword the commit message to explain both usages of the KVM-VFIO
  device in QEMU
- squash both arm and arm64 enables
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
index a093bf1..a4dbb97 100644
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
index b22c636..7104ca1 100644
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

From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v5 2/5] KVM: arm/arm64: select IRQ_BYPASS_MANAGER
Date: Mon, 10 Aug 2015 15:31:04 +0200
Message-ID: <1439213467-13668-3-git-send-email-eric.auger@linaro.org>
References: <1439213467-13668-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 819D05A7D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:18:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0BUoFwDRpm-T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:18:56 -0400 (EDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
 [209.85.212.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94FDD5A79A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:18:56 -0400 (EDT)
Received: by wijp15 with SMTP id p15so135811150wij.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:31:57 -0700 (PDT)
In-Reply-To: <1439213467-13668-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, feng.wu@intel.com
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Select IRQ_BYPASS_MANAGER when CONFIG_KVM is set
Also add compilation of virt/lib.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Feng Wu <feng.wu@intel.com>

---

v3 -> v4:
- add compilation of virt/lib in arm/arm64 KVM

v2 -> v3:
- [Feng Wu] Correct a typo in 'arch/arm64/kvm/Kconfig'

v1 -> v2:
- also set IRQ_BYPASS_MANAGER for arm64
---
 arch/arm/kvm/Kconfig    | 2 ++
 arch/arm/kvm/Makefile   | 1 +
 arch/arm64/kvm/Kconfig  | 2 ++
 arch/arm64/kvm/Makefile | 1 +
 4 files changed, 6 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index bfb915d..3c565b9 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -3,6 +3,7 @@
 #
 
 source "virt/kvm/Kconfig"
+source "virt/lib/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -31,6 +32,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select IRQ_BYPASS_MANAGER
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index c5eef02c..a6a41dd 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -24,3 +24,4 @@ obj-y += $(KVM)/arm/vgic.o
 obj-y += $(KVM)/arm/vgic-v2.o
 obj-y += $(KVM)/arm/vgic-v2-emul.o
 obj-y += $(KVM)/arm/arch_timer.o
+obj-y += ../../../virt/lib/
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index bfffe8f..2509539 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -3,6 +3,7 @@
 #
 
 source "virt/kvm/Kconfig"
+source "virt/lib/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -31,6 +32,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select IRQ_BYPASS_MANAGER
 	---help---
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index f90f4aa..55eec69 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -27,3 +27,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
 kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v3-switch.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
+kvm-$(CONFIG_KVM_ARM_HOST) += ../../../virt/lib/
-- 
1.9.1

From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v3 8/9] arm: KVM: Enable support for host pmu
Date: Tue, 10 Jan 2017 11:38:55 +0000
Message-ID: <20170110113856.7183-9-punit.agrawal@arm.com>
References: <20170110113856.7183-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6923C405B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N7ujtr1ZIoOG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 06:38:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7676E40665
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:33 -0500 (EST)
In-Reply-To: <20170110113856.7183-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

Add the Kconfig option and Makefile updates to enable the recently added
support for host pmu.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
---
 arch/arm/kvm/Kconfig  | 4 ++++
 arch/arm/kvm/Makefile | 1 +
 2 files changed, 5 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 90d0176fb30d..198d16c36220 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -16,6 +16,9 @@ menuconfig VIRTUALIZATION
 
 if VIRTUALIZATION
 
+config KVM_HOST_PMU
+	bool
+
 config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on MMU && OF
@@ -30,6 +33,7 @@ config KVM
 	select SRCU
 	select MMU_NOTIFIER
 	select KVM_VFIO
+	select KVM_HOST_PMU if PERF_EVENTS
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_IRQCHIP
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index d571243ab4d1..09d358499ce1 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -35,3 +35,4 @@ obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
 obj-y += $(KVM)/arm/vgic/vgic-its.o
 obj-y += $(KVM)/irqchip.o
 obj-y += $(KVM)/arm/arch_timer.o
+obj-$(CONFIG_KVM_HOST_PMU) += $(KVM)/arm/host_pmu.o
-- 
2.11.0

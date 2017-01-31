From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v4 8/9] arm: KVM: Enable support for host pmu
Date: Tue, 31 Jan 2017 17:16:29 +0000
Message-ID: <20170131171630.26898-9-punit.agrawal@arm.com>
References: <20170131171630.26898-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8A3640187
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:17:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HWvpcRUjg8fF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 12:17:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0CD40A3C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:17:31 -0500 (EST)
In-Reply-To: <20170131171630.26898-1-punit.agrawal@arm.com>
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
 arch/arm/include/asm/kvm_host.h | 8 ++++++++
 arch/arm/kvm/Kconfig            | 1 +
 arch/arm/kvm/Makefile           | 1 +
 3 files changed, 10 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 26f0c8a0b790..b530c85db894 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -289,6 +289,14 @@ static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
+#if !defined(CONFIG_KVM_HOST_PMU)
+static inline int arm_host_pmu_init(void) { return 0; }
+static inline void arm_host_pmu_teardown(void) { }
+#else
+int arm_host_pmu_init(void);
+void arm_host_pmu_teardown(void);
+#endif
+
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 90d0176fb30d..fbc09bd161fd 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -30,6 +30,7 @@ config KVM
 	select SRCU
 	select MMU_NOTIFIER
 	select KVM_VFIO
+	select KVM_HOST_PMU if PERF_EVENTS
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_IRQCHIP
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index d571243ab4d1..639aaef165f3 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -35,3 +35,4 @@ obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
 obj-y += $(KVM)/arm/vgic/vgic-its.o
 obj-y += $(KVM)/irqchip.o
 obj-y += $(KVM)/arm/arch_timer.o
+obj-$(CONFIG_KVM_HOST_PMU) += $(KVM)/host_pmu.o $(KVM)/arm/host_pmu_events.o
-- 
2.11.0

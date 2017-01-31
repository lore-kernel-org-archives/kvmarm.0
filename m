From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v4 7/9] arm64: KVM: Enable support for the host pmu
Date: Tue, 31 Jan 2017 17:16:28 +0000
Message-ID: <20170131171630.26898-8-punit.agrawal@arm.com>
References: <20170131171630.26898-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02A3E4093E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:17:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aWni1Hc3mgyL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 12:17:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 169E140430
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:17:26 -0500 (EST)
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Add the Kconfig option and Makefile update the enable the recently added
host pmu.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 8 ++++++++
 arch/arm64/kvm/Kconfig            | 1 +
 arch/arm64/kvm/Makefile           | 1 +
 3 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1e83b707f14c..78c4e9af64b1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -349,6 +349,14 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
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
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 52cb7ad9b2fd..608adb532118 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -31,6 +31,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select KVM_HOST_PMU if PERF_EVENTS
 	select KVM_ARM_PMU if HW_PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index d50a82a16ff6..b12c78c9e9dd 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -34,3 +34,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
+kvm-$(CONFIG_KVM_HOST_PMU) += $(KVM)/host_pmu.o $(KVM)/arm/host_pmu_events.o
-- 
2.11.0

From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v4 01/11] KVM: improve arch vcpu request defining
Date: Tue, 16 May 2017 04:20:25 +0200
Message-ID: <20170516022035.7674-2-drjones@redhat.com>
References: <20170516022035.7674-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170516022035.7674-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: cdall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Marc Zyngier suggested that we define the arch specific VCPU request
base, rather than requiring each arch to remember to start from 8.
That suggestion, along with Radim Krcmar's recent VCPU request flag
addition, snowballed into defining something of an arch VCPU request
defining API.

No functional change.

(Looks like x86 is running out of arch VCPU request bits.  Maybe
 someday we'll need to extend to 64.)

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/kvm_host.h     |  3 ++-
 arch/arm64/include/asm/kvm_host.h   |  3 ++-
 arch/powerpc/include/asm/kvm_host.h |  4 ++--
 arch/s390/include/asm/kvm_host.h    |  6 ++---
 arch/x86/include/asm/kvm_host.h     | 47 ++++++++++++++++++++-----------------
 include/linux/kvm_host.h            |  7 ++++++
 6 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 12274d46df70..c556babe467c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -44,7 +44,8 @@
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
 #endif
 
-#define KVM_REQ_VCPU_EXIT	(8 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VCPU_EXIT \
+	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
 int __attribute_const__ kvm_target_cpu(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 32cbe8a3bb0d..0ff991c9c66e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -41,7 +41,8 @@
 
 #define KVM_VCPU_MAX_FEATURES 4
 
-#define KVM_REQ_VCPU_EXIT	(8 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VCPU_EXIT \
+	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 9c51ac4b8f36..50e0bc9723cc 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -52,8 +52,8 @@
 #define KVM_IRQCHIP_NUM_PINS     256
 
 /* PPC-specific vcpu->requests bit members */
-#define KVM_REQ_WATCHDOG           8
-#define KVM_REQ_EPR_EXIT           9
+#define KVM_REQ_WATCHDOG	KVM_ARCH_REQ(0)
+#define KVM_REQ_EPR_EXIT	KVM_ARCH_REQ(1)
 
 #include <linux/mmu_notifier.h>
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 426614a882a9..9c3bd94204ac 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -42,9 +42,9 @@
 #define KVM_HALT_POLL_NS_DEFAULT 80000
 
 /* s390-specific vcpu->requests bit members */
-#define KVM_REQ_ENABLE_IBS         8
-#define KVM_REQ_DISABLE_IBS        9
-#define KVM_REQ_ICPT_OPEREXC       10
+#define KVM_REQ_ENABLE_IBS	KVM_ARCH_REQ(0)
+#define KVM_REQ_DISABLE_IBS	KVM_ARCH_REQ(1)
+#define KVM_REQ_ICPT_OPEREXC	KVM_ARCH_REQ(2)
 
 #define SIGP_CTRL_C		0x80
 #define SIGP_CTRL_SCN_MASK	0x3f
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9c761fea0c98..563979976fab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -48,28 +48,31 @@
 #define KVM_IRQCHIP_NUM_PINS  KVM_IOAPIC_NUM_PINS
 
 /* x86-specific vcpu->requests bit members */
-#define KVM_REQ_MIGRATE_TIMER      8
-#define KVM_REQ_REPORT_TPR_ACCESS  9
-#define KVM_REQ_TRIPLE_FAULT      10
-#define KVM_REQ_MMU_SYNC          11
-#define KVM_REQ_CLOCK_UPDATE      12
-#define KVM_REQ_EVENT             14
-#define KVM_REQ_APF_HALT          15
-#define KVM_REQ_STEAL_UPDATE      16
-#define KVM_REQ_NMI               17
-#define KVM_REQ_PMU               18
-#define KVM_REQ_PMI               19
-#define KVM_REQ_SMI               20
-#define KVM_REQ_MASTERCLOCK_UPDATE 21
-#define KVM_REQ_MCLOCK_INPROGRESS (22 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_SCAN_IOAPIC       (23 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_GLOBAL_CLOCK_UPDATE 24
-#define KVM_REQ_APIC_PAGE_RELOAD  (25 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_HV_CRASH          26
-#define KVM_REQ_IOAPIC_EOI_EXIT   27
-#define KVM_REQ_HV_RESET          28
-#define KVM_REQ_HV_EXIT           29
-#define KVM_REQ_HV_STIMER         30
+#define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
+#define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
+#define KVM_REQ_TRIPLE_FAULT		KVM_ARCH_REQ(2)
+#define KVM_REQ_MMU_SYNC		KVM_ARCH_REQ(3)
+#define KVM_REQ_CLOCK_UPDATE		KVM_ARCH_REQ(4)
+#define KVM_REQ_EVENT			KVM_ARCH_REQ(6)
+#define KVM_REQ_APF_HALT		KVM_ARCH_REQ(7)
+#define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(8)
+#define KVM_REQ_NMI			KVM_ARCH_REQ(9)
+#define KVM_REQ_PMU			KVM_ARCH_REQ(10)
+#define KVM_REQ_PMI			KVM_ARCH_REQ(11)
+#define KVM_REQ_SMI			KVM_ARCH_REQ(12)
+#define KVM_REQ_MASTERCLOCK_UPDATE	KVM_ARCH_REQ(13)
+#define KVM_REQ_MCLOCK_INPROGRESS \
+	KVM_ARCH_REQ_FLAGS(14, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_SCAN_IOAPIC \
+	KVM_ARCH_REQ_FLAGS(15, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_GLOBAL_CLOCK_UPDATE	KVM_ARCH_REQ(16)
+#define KVM_REQ_APIC_PAGE_RELOAD \
+	KVM_ARCH_REQ_FLAGS(17, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_HV_CRASH		KVM_ARCH_REQ(18)
+#define KVM_REQ_IOAPIC_EOI_EXIT		KVM_ARCH_REQ(19)
+#define KVM_REQ_HV_RESET		KVM_ARCH_REQ(20)
+#define KVM_REQ_HV_EXIT			KVM_ARCH_REQ(21)
+#define KVM_REQ_HV_STIMER		KVM_ARCH_REQ(22)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8c0664309815..3724b51aab64 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -126,6 +126,13 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_PENDING_TIMER     2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQUEST_ARCH_BASE     8
+
+#define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
+	BUILD_BUG_ON((unsigned)(nr) >= 32 - KVM_REQUEST_ARCH_BASE); \
+	(unsigned)(((nr) + KVM_REQUEST_ARCH_BASE) | (flags)); \
+})
+#define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
-- 
2.9.3

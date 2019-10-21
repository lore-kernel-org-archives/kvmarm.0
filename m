Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA503CA9EAF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 15:29:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DDF12089C
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 15:29:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DDF12089C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2842D4AA46;
	Mon, 21 Oct 2019 11:29:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZuzsgKN+t71l; Mon, 21 Oct 2019 11:29:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A08C24AC0F;
	Mon, 21 Oct 2019 11:29:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 822EC4A987
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 11:29:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vDj6JJK9ILL6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 11:29:14 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EEB24A9B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 11:29:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D400A11D4;
 Mon, 21 Oct 2019 08:28:44 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com
 [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D0F113F71F;
 Mon, 21 Oct 2019 08:28:42 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 05/10] KVM: arm64: Support stolen time reporting via shared
 structure
Date: Mon, 21 Oct 2019 16:28:18 +0100
Message-Id: <20191021152823.14882-6-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191021152823.14882-1-steven.price@arm.com>
References: <20191021152823.14882-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Steven Price <steven.price@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Implement the service call for configuring a shared structure between a
VCPU and the hypervisor in which the hypervisor can write the time
stolen from the VCPU's execution time by other tasks on the host.

User space allocates memory which is placed at an IPA also chosen by user
space. The hypervisor then updates the shared structure using
kvm_put_guest() to ensure single copy atomicity of the 64-bit value
reporting the stolen time in nanoseconds.

Whenever stolen time is enabled by the guest, the stolen time counter is
reset.

The stolen time itself is retrieved from the sched_info structure
maintained by the Linux scheduler code. We enable SCHEDSTATS when
selecting KVM Kconfig to ensure this value is meaningful.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 19 ++++++++++++
 arch/arm64/include/asm/kvm_host.h | 20 ++++++++++++
 arch/arm64/kvm/Kconfig            |  1 +
 include/linux/kvm_types.h         |  2 ++
 virt/kvm/arm/arm.c                | 11 +++++++
 virt/kvm/arm/hypercalls.c         |  6 ++++
 virt/kvm/arm/pvtime.c             | 51 +++++++++++++++++++++++++++++++
 7 files changed, 110 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 5a0c3569ebde..5a077f85813f 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -39,6 +39,7 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
@@ -329,6 +330,24 @@ static inline long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	return SMCCC_RET_NOT_SUPPORTED;
 }
 
+static inline gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
+{
+	return GPA_INVALID;
+}
+
+static inline void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
+{
+}
+
+static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
+{
+	return false;
+}
+
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 93b46d9526d0..75ef37f79633 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
@@ -338,6 +339,13 @@ struct kvm_vcpu_arch {
 	/* True when deferrable sysregs are loaded on the physical CPU,
 	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
 	bool sysregs_loaded_on_cpu;
+
+	/* Guest PV state */
+	struct {
+		u64 steal;
+		u64 last_steal;
+		gpa_t base;
+	} steal;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -479,6 +487,18 @@ int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
+gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
+void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
+
+static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
+{
+	vcpu_arch->steal.base = GPA_INVALID;
+}
+
+static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
+{
+	return (vcpu_arch->steal.base != GPA_INVALID);
+}
 
 void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a67121d419a2..d8b88e40d223 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ config KVM
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
+	select SCHEDSTATS
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index bde5374ae021..1c88e69db3d9 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -35,6 +35,8 @@ typedef unsigned long  gva_t;
 typedef u64            gpa_t;
 typedef u64            gfn_t;
 
+#define GPA_INVALID	(~(gpa_t)0)
+
 typedef unsigned long  hva_t;
 typedef u64            hpa_t;
 typedef u64            hfn_t;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86c6aa1cb58e..2aba375dfd13 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -40,6 +40,10 @@
 #include <asm/kvm_coproc.h>
 #include <asm/sections.h>
 
+#include <kvm/arm_hypercalls.h>
+#include <kvm/arm_pmu.h>
+#include <kvm/arm_psci.h>
+
 #ifdef REQUIRES_VIRT
 __asm__(".arch_extension	virt");
 #endif
@@ -351,6 +355,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_arm_reset_debug_ptr(vcpu);
 
+	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
+
 	return kvm_vgic_vcpu_init(vcpu);
 }
 
@@ -380,6 +386,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_vcpu_load_sysregs(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
+	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
+		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
 	if (single_task_running())
 		vcpu_clear_wfe_traps(vcpu);
@@ -645,6 +653,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		 * that a VCPU sees new virtual interrupts.
 		 */
 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
+
+		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
+			kvm_update_stolen_time(vcpu);
 	}
 }
 
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
index 97ea8b133e77..550dfa3e53cd 100644
--- a/virt/kvm/arm/hypercalls.c
+++ b/virt/kvm/arm/hypercalls.c
@@ -14,6 +14,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	u32 func_id = smccc_get_function(vcpu);
 	long val = SMCCC_RET_NOT_SUPPORTED;
 	u32 feature;
+	gpa_t gpa;
 
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
@@ -56,6 +57,11 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
 		val = kvm_hypercall_pv_features(vcpu);
 		break;
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		gpa = kvm_init_stolen_time(vcpu);
+		if (gpa != GPA_INVALID)
+			val = gpa;
+		break;
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
index 8d0fad671dcf..b90b3a7bea85 100644
--- a/virt/kvm/arm/pvtime.c
+++ b/virt/kvm/arm/pvtime.c
@@ -3,8 +3,35 @@
 
 #include <linux/arm-smccc.h>
 
+#include <asm/pvclock-abi.h>
+
 #include <kvm/arm_hypercalls.h>
 
+void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 steal;
+	__le64 steal_le;
+	u64 offset;
+	int idx;
+	u64 base = vcpu->arch.steal.base;
+
+	if (base == GPA_INVALID)
+		return;
+
+	/* Let's do the local bookkeeping */
+	steal = vcpu->arch.steal.steal;
+	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	vcpu->arch.steal.steal = steal;
+
+	steal_le = cpu_to_le64(steal);
+	idx = srcu_read_lock(&kvm->srcu);
+	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
+	kvm_put_guest(kvm, base + offset, steal_le, u64);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 {
 	u32 feature = smccc_get_arg1(vcpu);
@@ -12,6 +39,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
 		val = SMCCC_RET_SUCCESS;
 		break;
 	}
@@ -19,3 +47,26 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	return val;
 }
 
+gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
+{
+	struct pvclock_vcpu_stolen_time init_values = {};
+	struct kvm *kvm = vcpu->kvm;
+	u64 base = vcpu->arch.steal.base;
+	int idx;
+
+	if (base == GPA_INVALID)
+		return base;
+
+	/*
+	 * Start counting stolen time from the time the guest requests
+	 * the feature enabled.
+	 */
+	vcpu->arch.steal.steal = 0;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	kvm_write_guest(kvm, base, &init_values, sizeof(init_values));
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return base;
+}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=eGRX=V6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BAAC32753
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 14:50:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3CE221783
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 14:50:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3CE221783
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ECC04A57F;
	Fri,  2 Aug 2019 10:50:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hvIwBIote96v; Fri,  2 Aug 2019 10:50:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E5B24A547;
	Fri,  2 Aug 2019 10:50:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52FD64A500
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 10:50:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eLDCoOaC-cEw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Aug 2019 10:50:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D469C4A54F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 10:50:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D0C21596;
 Fri,  2 Aug 2019 07:50:38 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com
 [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 962063F575;
 Fri,  2 Aug 2019 07:50:36 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: 
Subject: [PATCH 4/9] KVM: arm64: Support stolen time reporting via shared
 structure
Date: Fri,  2 Aug 2019 15:50:12 +0100
Message-Id: <20190802145017.42543-5-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802145017.42543-1-steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Implement the service call for configuring a shared structre between a
VCPU and the hypervisor in which the hypervisor can write the time
stolen from the VCPU's execution time by other tasks on the host.

The hypervisor allocates memory which is placed at an IPA chosen by user
space. The hypervisor then uses WRITE_ONCE() to update the shared
structre ensuring single copy atomicity of the 64-bit unsigned value
that reports stolen time in nanoseconds.

Whenever stolen time is enabled by the guest, the stolen time counter is
reset.

The stolen time itself is retrieved from the sched_info structure
maintained by the Linux scheduler code. We enable SCHEDSTATS when
selecting KVM Kconfig to ensure this value is meaningful.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 13 +++++-
 arch/arm64/kvm/Kconfig            |  1 +
 include/kvm/arm_hypercalls.h      |  1 +
 include/linux/kvm_types.h         |  2 +
 virt/kvm/arm/arm.c                | 18 ++++++++
 virt/kvm/arm/hypercalls.c         | 70 +++++++++++++++++++++++++++++++
 6 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f656169db8c3..78f270190d43 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
@@ -83,6 +84,11 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	struct kvm_arch_pvtime {
+		void *st;
+		gpa_t st_base;
+	} pvtime;
 };
 
 #define KVM_NR_MEM_OBJS     40
@@ -338,8 +344,13 @@ struct kvm_vcpu_arch {
 	/* True when deferrable sysregs are loaded on the physical CPU,
 	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
 	bool sysregs_loaded_on_cpu;
-};
 
+	/* Guest PV state */
+	struct {
+		u64 steal;
+		u64 last_steal;
+	} steal;
+};
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
 				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
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
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 35a5abcc4ca3..9f0710ab4292 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -7,6 +7,7 @@
 #include <asm/kvm_emulate.h>
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
+int kvm_update_stolen_time(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
 {
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
index f645c0fbf7ec..ebd963d2580b 100644
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
@@ -135,6 +139,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = vgic_present ?
 				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 
+	kvm->arch.pvtime.st_base = GPA_INVALID;
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(kvm);
@@ -371,6 +376,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_vcpu_load_sysregs(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
+	kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
 	if (single_task_running())
 		vcpu_clear_wfe_traps(vcpu);
@@ -617,6 +623,15 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	smp_rmb();
 }
 
+static void vcpu_req_record_steal(struct kvm_vcpu *vcpu)
+{
+	int idx;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_update_stolen_time(vcpu);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+}
+
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.target >= 0;
@@ -636,6 +651,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		 * that a VCPU sees new virtual interrupts.
 		 */
 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
+
+		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
+			vcpu_req_record_steal(vcpu);
 	}
 }
 
diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
index 2906b2df99df..196c71c8dd87 100644
--- a/virt/kvm/arm/hypercalls.c
+++ b/virt/kvm/arm/hypercalls.c
@@ -10,6 +10,70 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
 
+
+static struct pvclock_vcpu_stolen_time_info *pvtime_get_st(
+		struct kvm_vcpu *vcpu)
+{
+	struct pvclock_vcpu_stolen_time_info *st = vcpu->kvm->arch.pvtime.st;
+
+	if (!st)
+		return NULL;
+
+	return &st[kvm_vcpu_get_idx(vcpu)];
+}
+
+int kvm_update_stolen_time(struct kvm_vcpu *vcpu)
+{
+	u64 steal;
+	struct pvclock_vcpu_stolen_time_info *kaddr;
+
+	if (vcpu->kvm->arch.pvtime.st_base == GPA_INVALID)
+		return -ENOTSUPP;
+
+	kaddr = pvtime_get_st(vcpu);
+
+	if (!kaddr)
+		return -ENOTSUPP;
+
+	kaddr->revision = 0;
+	kaddr->attributes = 0;
+
+	/* Let's do the local bookkeeping */
+	steal = vcpu->arch.steal.steal;
+	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+	vcpu->arch.steal.steal = steal;
+
+	/* Now write out the value to the shared page */
+	WRITE_ONCE(kaddr->stolen_time, cpu_to_le64(steal));
+
+	return 0;
+}
+
+static int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
+{
+	u64 ret;
+	int err;
+
+	/*
+	 * Start counting stolen time from the time the guest requests
+	 * the feature enabled.
+	 */
+	vcpu->arch.steal.steal = 0;
+	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
+
+	err = kvm_update_stolen_time(vcpu);
+
+	if (err)
+		ret = SMCCC_RET_NOT_SUPPORTED;
+	else
+		ret = vcpu->kvm->arch.pvtime.st_base +
+			(sizeof(struct pvclock_vcpu_stolen_time_info) *
+			 kvm_vcpu_get_idx(vcpu));
+
+	smccc_set_retval(vcpu, ret, 0, 0, 0);
+	return 1;
+}
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -57,8 +121,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_HV_PV_FEATURES:
 		feature = smccc_get_arg1(vcpu);
 		switch (feature) {
+		case ARM_SMCCC_HV_PV_FEATURES:
+		case ARM_SMCCC_HV_PV_TIME_ST:
+			val = SMCCC_RET_SUCCESS;
+			break;
 		}
 		break;
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_hypercall_stolen_time(vcpu);
 	default:
 		return kvm_psci_call(vcpu);
 	}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

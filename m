Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0442FC55179
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72E0A2075E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="TxsjGKaO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72E0A2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1603D4B7F5;
	Wed,  4 Nov 2020 13:37:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QD4FiUYpd5EL; Wed,  4 Nov 2020 13:37:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C23384B804;
	Wed,  4 Nov 2020 13:37:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAA084B712
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ojXPbPxqOISx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:26 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 998804B78E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:26 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id e2so3294412wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=psZfm56b4NnuZJ+WZzr2WmBKhp4myVTyKEGCmvNKJks=;
 b=TxsjGKaOrDUcyBdWwkVl6gVpEsI0EyVoMSnxLfzex2v4DhMMNQ7qag73+RtH3qli9m
 9yQ++ZOWDsggJ77v/O9QRR0JOGzotQwiGgq5vkaOHRqeOlvpkASr5A7KUIAW9HwhxmuS
 BVnoC85IyuzhS/a4STCqYT1dZ1Y7Wg9T7rcygwQJOsBVZNs0kH8FUssM0Chk5q3yMAde
 MaqOnTx5bomYLOASp9DUrdOJABRdWc8bYOQt6H2J/IjVa5FIrJmQ9muxkBEl96AIelSN
 lYn0gfhjT8XS6RXfifKhx8z7JBPE3g7SfKipoAOkEdyZhXP7Or6UVO1TeJ3x7HG1SXGb
 /Wqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=psZfm56b4NnuZJ+WZzr2WmBKhp4myVTyKEGCmvNKJks=;
 b=EnqiXETMkmjGMyfTsKccuRiOdTFnybUohuo+FTo8oRAOaixji6fEuXTNmz8LQFr745
 QKTzDWkmcVsT+zbsRQl14YKfHrwCC9n8Lw/B0P8Qe8JEvXxQHkb3K4Y9/DAE9W2X+adB
 ZVMZfJMeYP/hWifkmAtVJYQuPKX3dhlXasW6+M5GkynE2sXoYKJQjdn64sLbq4vAUKuJ
 zh/GTrkJmjOiRjNGqBSgPLf7HJ742jnSWB58qfGgMpdUDBpA7FJkQdeI3s6qiw6aRTgN
 3YequzVUGpl2gm5wY1umrSPNpF7bsXmQ0DxyQkN7lJqbbBzOGKvDp8+7MSXoHp/tYtMn
 zy4w==
X-Gm-Message-State: AOAM532d3QRgg2LfWNnfcR4FltzJ6Woe4htmHY4tUBWThTjCSs2Lj6/0
 3/twXiRjHU/S7LxyTvnZkDVB2U0JzkpLNTCs
X-Google-Smtp-Source: ABdhPJwKl9g4CE++tDKZXsF8rk/tYeIOyDzjpQI7vYRHtBkW57iNk1cV2dnVQZY8ATbWn1yB9MRW3w==
X-Received: by 2002:a7b:c453:: with SMTP id l19mr5898950wmi.2.1604515045200;
 Wed, 04 Nov 2020 10:37:25 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id u202sm3665680wmu.23.2020.11.04.10.37.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:24 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 22/26] kvm: arm64: Intercept PSCI_CPU_ON host SMC calls
Date: Wed,  4 Nov 2020 18:36:26 +0000
Message-Id: <20201104183630.27513-23-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Add a handler of the CPU_ON PSCI call from host. When invoked, it
looks up the logical CPU ID corresponding to the provided MPIDR and
populates the state struct of the target CPU with the provided x0, pc.
It then calls CPU_ON itself, with an entry point in hyp that initializes
EL2 state before returning ERET to the provided PC in EL1.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h |   1 +
 arch/arm64/kvm/arm.c             |   3 +
 arch/arm64/kvm/hyp/nvhe/psci.c   | 113 +++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index cf4c1d16c3e0..2d88a2dad4de 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,6 +97,7 @@ void deactivate_traps_vhe_put(void);
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
+asmlinkage void __noreturn kvm_host_psci_cpu_entry(void);
 void kvm_host_psci_cpu_init(void);
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5b073806463e..166975999ead 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1334,6 +1334,7 @@ static int kvm_map_vectors(void)
 
 static void cpu_init_hyp_mode(void)
 {
+	DECLARE_KVM_NVHE_SYM(kvm_host_psci_cpu_entry);
 	struct kvm_nvhe_init_params *params = this_cpu_ptr_nvhe_sym(kvm_init_params);
 	struct arm_smccc_res res;
 
@@ -1351,6 +1352,8 @@ static void cpu_init_hyp_mode(void)
 	params->pgd_ptr = kvm_mmu_get_httbr();
 	params->vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
 	params->hyp_stack_ptr = kern_hyp_va(__this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE);
+	params->psci_cpu_entry_fn = (unsigned long)kern_hyp_va(
+		kvm_ksym_ref(CHOOSE_NVHE_SYM(kvm_host_psci_cpu_entry)));
 
 	/*
 	 * Flush the init params from the data cache because the struct will
diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
index 00dc0cab860c..42ee5effa827 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -9,12 +9,15 @@
 #include <asm/kvm_mmu.h>
 #include <kvm/arm_hypercalls.h>
 #include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
 #include <linux/psci.h>
 #include <kvm/arm_psci.h>
 #include <uapi/linux/psci.h>
 
 #include <nvhe/spinlock.h>
 
+#define INVALID_CPU_ID UINT_MAX
+
 /* Config options set by the host. */
 u32 kvm_host_psci_version = PSCI_VERSION(0, 0);
 u32 kvm_host_psci_function_id[PSCI_FN_MAX];
@@ -24,6 +27,7 @@ s64 hyp_physvirt_offset;
 
 static DEFINE_PER_CPU(hyp_spinlock_t, psci_cpu_lock);
 DEFINE_PER_CPU(enum kvm_nvhe_psci_state, psci_cpu_state);
+static DEFINE_PER_CPU(struct vcpu_reset_state, psci_cpu_reset);
 
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
@@ -79,6 +83,29 @@ static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *ho
 	hyp_panic(); /* unreachable */
 }
 
+static unsigned int find_cpu_id(u64 mpidr)
+{
+	int i;
+
+	if (mpidr != INVALID_HWID) {
+		for (i = 0; i < NR_CPUS; i++) {
+			if (cpu_logical_map(i) == mpidr)
+				return i;
+		}
+	}
+
+	return INVALID_CPU_ID;
+}
+
+static phys_addr_t cpu_entry_pa(void)
+{
+	extern char __kvm_hyp_cpu_entry[];
+	unsigned long kern_va;
+
+	asm volatile("ldr %0, =%1" : "=r" (kern_va) : "S" (__kvm_hyp_cpu_entry));
+	return kern_va - kimage_voffset;
+}
+
 static int psci_cpu_off(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	hyp_spinlock_t *cpu_lock = this_cpu_ptr(&psci_cpu_lock);
@@ -100,10 +127,76 @@ static int psci_cpu_off(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	return ret;
 }
 
+static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	u64 mpidr = host_ctxt->regs.regs[1] & MPIDR_HWID_BITMASK;
+	unsigned long pc = host_ctxt->regs.regs[2];
+	unsigned long r0 = host_ctxt->regs.regs[3];
+	unsigned int cpu_id;
+	hyp_spinlock_t *cpu_lock;
+	enum kvm_nvhe_psci_state *cpu_power;
+	struct vcpu_reset_state	*cpu_reset;
+	struct kvm_nvhe_init_params *cpu_params;
+	int ret;
+
+	/*
+	 * Find the logical CPU ID for the given MPIDR. The search set is
+	 * the set of CPUs that were online at the point of KVM initialization.
+	 * Booting other CPUs is rejected because their cpufeatures were not
+	 * checked against the finalized capabilities. This could be relaxed
+	 * by doing the feature checks in hyp.
+	 */
+	cpu_id = find_cpu_id(mpidr);
+	if (cpu_id == INVALID_CPU_ID)
+		return PSCI_RET_INVALID_PARAMS;
+
+	cpu_lock = per_cpu_ptr(&psci_cpu_lock, cpu_id);
+	cpu_power = per_cpu_ptr(&psci_cpu_state, cpu_id);
+	cpu_reset = per_cpu_ptr(&psci_cpu_reset, cpu_id);
+	cpu_params = per_cpu_ptr(&kvm_init_params, cpu_id);
+
+	do {
+		hyp_spin_lock(cpu_lock);
+
+		if (*cpu_power != KVM_NVHE_PSCI_CPU_OFF) {
+			if (kvm_host_psci_version == PSCI_VERSION(0, 1))
+				ret = PSCI_RET_INVALID_PARAMS;
+			else if (*cpu_power == KVM_NVHE_PSCI_CPU_ON)
+				ret = PSCI_RET_ALREADY_ON;
+			else
+				ret = PSCI_RET_ON_PENDING;
+			hyp_spin_unlock(cpu_lock);
+			return ret;
+		}
+
+		*cpu_reset = (struct vcpu_reset_state){
+			.pc = pc,
+			.r0 = r0,
+		};
+
+		ret = psci_call(func_id, mpidr, cpu_entry_pa(), __hyp_pa(cpu_params));
+
+		if (ret == PSCI_RET_SUCCESS)
+			*cpu_power = KVM_NVHE_PSCI_CPU_PENDING_ON;
+
+		hyp_spin_unlock(cpu_lock);
+
+		/*
+		 * If recorded CPU state is OFF but EL3 reports that it's ON,
+		 * we must have hit a race with CPU_OFF on the target core.
+		 * Loop to try again.
+		 */
+	} while (ret == PSCI_RET_ALREADY_ON);
+
+	return ret;
+}
+
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
 		return psci_cpu_off(func_id, host_ctxt);
+	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_ON])
+		return psci_cpu_on(func_id, host_ctxt);
 	else if (func_id == kvm_host_psci_function_id[PSCI_FN_MIGRATE])
 		return psci_forward(host_ctxt);
 	else
@@ -125,6 +218,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 		unreachable();
 	case PSCI_0_2_FN_CPU_OFF:
 		return psci_cpu_off(func_id, host_ctxt);
+	case PSCI_0_2_FN64_CPU_ON:
+		return psci_cpu_on(func_id, host_ctxt);
 	default:
 		return PSCI_RET_NOT_SUPPORTED;
 	}
@@ -148,6 +243,24 @@ static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_
 	}
 }
 
+void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
+
+asmlinkage void __noreturn kvm_host_psci_cpu_entry(void)
+{
+	hyp_spinlock_t *cpu_lock = this_cpu_ptr(&psci_cpu_lock);
+	enum kvm_nvhe_psci_state *cpu_power = this_cpu_ptr(&psci_cpu_state);
+	struct vcpu_reset_state	*cpu_reset = this_cpu_ptr(&psci_cpu_reset);
+	struct kvm_cpu_context *host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+
+	hyp_spin_lock(cpu_lock);
+	*cpu_power = KVM_NVHE_PSCI_CPU_ON;
+	host_ctxt->regs.regs[0] = cpu_reset->r0;
+	write_sysreg_el2(cpu_reset->pc, SYS_ELR);
+	hyp_spin_unlock(cpu_lock);
+
+	__host_enter(host_ctxt);
+}
+
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt)
 {
 	u64 func_id = get_psci_func_id(host_ctxt);
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

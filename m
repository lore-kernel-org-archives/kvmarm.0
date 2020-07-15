Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFD7C433E3
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DDDB20771
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="FfJ8yrfM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DDDB20771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4A94B238;
	Wed, 15 Jul 2020 14:45:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yX2eWI0gvK+U; Wed, 15 Jul 2020 14:45:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77F994B3C1;
	Wed, 15 Jul 2020 14:45:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18CD34B213
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QFf2rvdytCsu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:11 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E5334B1CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:11 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id d202so3967174ybh.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Pe+OeVkFdVfdLCR9l3Rkbn829uq1fiFz6g2wLHYGq3k=;
 b=FfJ8yrfM2AzmdQnBJY2PX/wVHJyHyQaGnSzd7zACLhQloJ5FUk0nzlR4Adju1URDBN
 Hs5JgwE+eNLzG3B7BoGWzCxqeiOtt5jAadkGZSXdI1AzdgZ8DJ8YBwMenArjAKxBPQNH
 7p0e5FJOZXXJwp9v3u8FDjiJcPcv8JhaEdeqVoAVPPmQEtzNwMg+6LefU6vuQp7FJ7VY
 /DDBlgYN3eACPWVog5donf+EP33ogjDzYxHDjJBbeGcEuzzA9f+fKk1J33bKsRXUQgXT
 ThuNDORp72QkCDCDMzoj9qKKuRfOt6irnk6NV36hs2AEAmdqfKLfysfk4GLw4Y91mfHC
 moPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Pe+OeVkFdVfdLCR9l3Rkbn829uq1fiFz6g2wLHYGq3k=;
 b=oRAHuaXItrXquZK+pOaqm+eRWXJMGA4OUA5M4uKkJPTvVRHhp2b2RwgWkXSHh1W7Sx
 wQBFkR88o/UKB93qXgcKqs/YWyQztry0N1rFoIZE2o4cI1FPLjnp1vCOE0ee4TaUGsJX
 YG6E0775Y9TP/aIypsgs3CViJy3JAkoidk7Y0J621k/EDAK4U3jOgVHLgk8KbaNspljr
 YvNS2Yzav84NG92ytqX67OY2oRKuTXYc/L97KvA/SPZtbtXBg6A5QZQsP+guVYQZ+yZP
 1LI5xgz6OISfcRUPWGgjh3VKTk8RZLGLh3N6mBMkIqhzJZavAivjUE5/5Jdl8My0ADz9
 xXzg==
X-Gm-Message-State: AOAM531o3Q4796CwNiCLTdTLo8cXw60Dh5L54jIrjHUZsUXQhIrlaoYJ
 zSjC+MeTBkBnTqgGBbq50YSoQS4rQmknkxLTwpNyf/zFh8WXu1XkHDD5N3QMpRIvP6p4AUglyIX
 jU/dSr/LneDSRrNgDRbENB3hMJ50DXs7nlaWRxJ09k4Gf1vGvk155UCB2siqLlUkuQi2Z9g==
X-Google-Smtp-Source: ABdhPJywioEiXWVrSK1+7gkaaiKWFzNLdUSFQv9Z6v46oVWxWDk1eRf+Nw0gKU/MltCP9AxcWNbivtkdtHM=
X-Received: by 2002:a5b:4ca:: with SMTP id u10mr597339ybp.128.1594838710592;
 Wed, 15 Jul 2020 11:45:10 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:11 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-11-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 10/37] KVM: arm64: nVHE: Migrate hyp interface to SMCCC
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

Rather than passing arbitrary function pointers to run at hyp, define
and equivalent set of SMCCC functions.

Since the SMCCC functions are strongly tied to the original function
prototypes, it is not expected for the host to ever call an invalid ID
but a warning is raised if this does ever occur.

Signed-off-by: Andrew Scull <ascull@google.com>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  24 +++++++
 arch/arm64/include/asm/kvm_host.h  |  26 +++++---
 arch/arm64/kvm/arm.c               |   4 +-
 arch/arm64/kvm/hyp.S               |  25 ++-----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 104 +++++++++++++++++++++++++----
 5 files changed, 139 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ebe9d582f360..ff27c18b9fd6 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -38,6 +38,30 @@
 
 #define __SMCCC_WORKAROUND_1_SMC_SZ 36
 
+#define KVM_HOST_SMCCC_ID(id)						\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,		\
+			   (id))
+
+#define KVM_HOST_SMCCC_FUNC(name) KVM_HOST_SMCCC_ID(__KVM_HOST_SMCCC_FUNC_##name)
+
+#define __KVM_HOST_SMCCC_FUNC___kvm_hyp_init			0
+#define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		1
+#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		2
+#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		3
+#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_local_vmid	4
+#define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		5
+#define __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run			6
+#define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_ich_vtr_el2		8
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr		9
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr		10
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs		11
+#define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
+#define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
+
 #ifndef __ASSEMBLY__
 
 #include <linux/mm.h>
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 183312340d2c..5603d2f465eb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -11,6 +11,7 @@
 #ifndef __ARM64_KVM_HOST_H__
 #define __ARM64_KVM_HOST_H__
 
+#include <linux/arm-smccc.h>
 #include <linux/bitmap.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
@@ -492,18 +493,21 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
-u64 __kvm_call_hyp(void *hypfn, ...);
+u64 __kvm_call_hyp_init(phys_addr_t pgd_ptr,
+			unsigned long hyp_stack_ptr,
+			unsigned long vector_ptr,
+			unsigned long start_hyp,
+			unsigned long tpidr_el2);
 
-#define kvm_call_hyp_nvhe(f, ...)					\
-	do {								\
-		DECLARE_KVM_NVHE_SYM(f);				\
-		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
-	} while(0)
-
-#define kvm_call_hyp_nvhe_ret(f, ...)					\
+#define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
-		DECLARE_KVM_NVHE_SYM(f);				\
-		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
+		struct arm_smccc_res res;				\
+									\
+		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),		\
+				  ##__VA_ARGS__, &res);			\
+		WARN_ON(res.a0 != SMCCC_RET_SUCCESS);			\
+									\
+		res.a1;							\
 	})
 
 /*
@@ -529,7 +533,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 			ret = f(__VA_ARGS__);				\
 			isb();						\
 		} else {						\
-			ret = kvm_call_hyp_nvhe_ret(f, ##__VA_ARGS__);	\
+			ret = kvm_call_hyp_nvhe(f, ##__VA_ARGS__);	\
 		}							\
 									\
 		ret;							\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8bd4630666ca..c42c00c8141a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1290,8 +1290,8 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
-	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, start_hyp,
-		       tpidr_el2);
+	__kvm_call_hyp_init(pgd_ptr, hyp_stack_ptr, vector_ptr, start_hyp,
+			    tpidr_el2);
 
 	/*
 	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 3c79a1124af2..0891625c8648 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -11,24 +11,13 @@
 #include <asm/cpufeature.h>
 
 /*
- * u64 __kvm_call_hyp(void *hypfn, ...);
- *
- * This is not really a variadic function in the classic C-way and care must
- * be taken when calling this to ensure parameters are passed in registers
- * only, since the stack will change between the caller and the callee.
- *
- * Call the function with the first argument containing a pointer to the
- * function you wish to call in Hyp mode, and subsequent arguments will be
- * passed as x0, x1, and x2 (a maximum of 3 arguments in addition to the
- * function pointer can be passed).  The function being called must be mapped
- * in Hyp mode (see init_hyp_mode in arch/arm/kvm/arm.c).  Return values are
- * passed in x0.
- *
- * A function pointer with a value less than 0xfff has a special meaning,
- * and is used to implement hyp stubs in the same way as in
- * arch/arm64/kernel/hyp_stub.S.
+ * u64 __kvm_call_hyp_init(phys_addr_t pgd_ptr,
+ * 			   unsigned long hyp_stack_ptr,
+ * 			   unsigned long vector_ptr,
+ * 			   unsigned long start_hyp,
+ * 			   unsigned long tpidr_el2);
  */
-SYM_FUNC_START(__kvm_call_hyp)
+SYM_FUNC_START(__kvm_call_hyp_init)
 	hvc	#0
 	ret
-SYM_FUNC_END(__kvm_call_hyp)
+SYM_FUNC_END(__kvm_call_hyp_init)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9b58d58d6cfa..7e7c074f8093 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -11,23 +11,101 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-typedef unsigned long (*hypcall_fn_t)
-	(unsigned long, unsigned long, unsigned long);
+#include <kvm/arm_hypercalls.h>
+
+static void handle_host_hcall(unsigned long func_id, struct kvm_vcpu *host_vcpu)
+{
+	unsigned long ret = 0;
+
+	switch (func_id) {
+	case KVM_HOST_SMCCC_FUNC(__kvm_flush_vm_context):
+		__kvm_flush_vm_context();
+		break;
+	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid_ipa): {
+			struct kvm_s2_mmu *mmu =
+				(struct kvm_s2_mmu *)smccc_get_arg1(host_vcpu);
+			phys_addr_t ipa = smccc_get_arg2(host_vcpu);
+			int level = smccc_get_arg3(host_vcpu);
+
+			__kvm_tlb_flush_vmid_ipa(mmu, ipa, level);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid): {
+			struct kvm_s2_mmu *mmu =
+				(struct kvm_s2_mmu *)smccc_get_arg1(host_vcpu);
+
+			__kvm_tlb_flush_vmid(mmu);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): {
+			struct kvm_s2_mmu *mmu =
+				(struct kvm_s2_mmu *)smccc_get_arg1(host_vcpu);
+
+			__kvm_tlb_flush_local_vmid(mmu);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__kvm_timer_set_cntvoff): {
+			u64 cntvoff = smccc_get_arg1(host_vcpu);
+
+			__kvm_timer_set_cntvoff(cntvoff);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__kvm_vcpu_run): {
+			struct kvm_vcpu *vcpu =
+				(struct kvm_vcpu *)smccc_get_arg1(host_vcpu);
+
+			ret = __kvm_vcpu_run(vcpu);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__kvm_enable_ssbs):
+		__kvm_enable_ssbs();
+		break;
+	case KVM_HOST_SMCCC_FUNC(__vgic_v3_get_ich_vtr_el2):
+		ret = __vgic_v3_get_ich_vtr_el2();
+		break;
+	case KVM_HOST_SMCCC_FUNC(__vgic_v3_read_vmcr):
+		ret = __vgic_v3_read_vmcr();
+		break;
+	case KVM_HOST_SMCCC_FUNC(__vgic_v3_write_vmcr): {
+			u32 vmcr = smccc_get_arg1(host_vcpu);
+
+			__vgic_v3_write_vmcr(vmcr);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__vgic_v3_init_lrs):
+		__vgic_v3_init_lrs();
+		break;
+	case KVM_HOST_SMCCC_FUNC(__kvm_get_mdcr_el2):
+		ret = __kvm_get_mdcr_el2();
+		break;
+	case KVM_HOST_SMCCC_FUNC(__vgic_v3_save_aprs): {
+			struct vgic_v3_cpu_if *cpu_if =
+				(struct vgic_v3_cpu_if *)smccc_get_arg1(host_vcpu);
+
+			__vgic_v3_save_aprs(cpu_if);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__vgic_v3_restore_aprs): {
+			struct vgic_v3_cpu_if *cpu_if =
+				(struct vgic_v3_cpu_if *)smccc_get_arg1(host_vcpu);
+
+			__vgic_v3_restore_aprs(cpu_if);
+			break;
+		}
+	default:
+		/* Invalid host HVC. */
+		smccc_set_retval(host_vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
+		return;
+	}
+
+	smccc_set_retval(host_vcpu, SMCCC_RET_SUCCESS, ret, 0, 0);
+}
 
 static void handle_trap(struct kvm_vcpu *host_vcpu) {
 	if (kvm_vcpu_trap_get_class(host_vcpu) == ESR_ELx_EC_HVC64) {
-		hypcall_fn_t func;
-		unsigned long ret;
+		unsigned long func_id = smccc_get_function(host_vcpu);
 
-		/*
-		 * __kvm_call_hyp takes a pointer in the host address space and
-		 * up to three arguments.
-		 */
-		func = (hypcall_fn_t)kern_hyp_va(vcpu_get_reg(host_vcpu, 0));
-		ret = func(vcpu_get_reg(host_vcpu, 1),
-			   vcpu_get_reg(host_vcpu, 2),
-			   vcpu_get_reg(host_vcpu, 3));
-		vcpu_set_reg(host_vcpu, 0, ret);
+		handle_host_hcall(func_id, host_vcpu);
 	}
 
 	/* Other traps are ignored. */
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

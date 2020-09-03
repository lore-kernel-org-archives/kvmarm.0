Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF910C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 788B9208B3
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="I0/I1enp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 788B9208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 250474B267;
	Thu,  3 Sep 2020 09:53:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1gwOYuBRPkDI; Thu,  3 Sep 2020 09:53:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F3C4B2FD;
	Thu,  3 Sep 2020 09:53:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77C5E4B276
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YG85U4mxve8a for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:48 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35BF24B22C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:48 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id f5so2168423qtk.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=eUIPSBoSSw3xv/HffwjODbqF2fUyJlJOGEKU8Ol03Gs=;
 b=I0/I1enp1VBrC0F79lcaXSVQyD945D4EiydPPENzq8u1rjfSCB/A53DWY9cusfmqvh
 /WRPTY8Jga8UP7tpDh753ugE75ucKmNRNraqmSxv6YfWGxvCnr3PhJiRKnkZ1K231+au
 Sz68jaIN1bWiXzgn4WFj+MV3jzIeXFPbKMdEvHPqJvLGb9dG3d6ORb5JN6E6RmJ3CTk9
 /kfSdjFhlV4WKKWIkIavpPJp+avhuF2wURR4/jdJjw4oZIpkKEeOiv7rm91l1cNAmEB2
 beq//BlETslX4er54FPbGp/+/FUiuY+KPLwPBVxGt6UbVFHrrM6hhhHqlk92ttigoUL7
 heBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=eUIPSBoSSw3xv/HffwjODbqF2fUyJlJOGEKU8Ol03Gs=;
 b=cbX6G29e70yuR8VDLgVEwa2joJJBR26/FTNL093pE8T87gtE+j/0fYulsM1ULGauDV
 ey/mdLHMR1pzsw1rwRq96Sgb6pk3oXgSXkxy6LmkdZH3H5Xw60HEnVu9P6PC3jezV8u0
 mtPHqgbV508zoiBTvjXTBYh6TLkpcaeROE8mEynaaY9UMtQ3sGFfzATOR3yBQm7013lB
 who0NAETe94hpCTwT1/Oihu+xXmsitOiQ2wqRn6WAbMszcHwF9jrvndsDNF6XCg9rYjv
 gQ8BHQ2Z3i4J+s74IxJiq5Pax3R/BZ6bJqSYg1TE4LwbQF21y5wCzn0LQHoYWZjzEPCj
 EY2A==
X-Gm-Message-State: AOAM53125WCtLhqafz4IAoe94XRi6AlG1pVtMhATOuQvVI3q/GKB6oPX
 gUQ2g1OubF3CguLc5qkityaM286oxQykfrTx8pJjJQWG+vMvf1BHNxOntBhVDGQ54UnbcL0t3io
 pDIrHthmuCCrYVk5jkwRkPxjblLpJz85AxbSPp8w05IcYboIonhwPdkdSU8T+Llab9FOvBg==
X-Google-Smtp-Source: ABdhPJzrc7FGMJwXGHvsH1xcY+ysNIAylc0+XEIaEOB2wpHp89Ug6L/BC0cvqFhSK+myvvg8OG5QymGZ3xY=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:e188:: with SMTP id
 p8mr1932414qvl.9.1599141227585; 
 Thu, 03 Sep 2020 06:53:47 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:53:05 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-17-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 16/18] KVM: arm64: nVHE: Migrate hyp interface to SMCCC
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

As __kvm_vcpu_run is used for every switch between the host and a guest,
it is explicitly singled out to be identified before the other function
IDs to improve the performance of the hot path.

Signed-off-by: Andrew Scull <ascull@google.com>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  24 ++++++
 arch/arm64/include/asm/kvm_host.h  |  25 ++++---
 arch/arm64/kvm/arm.c               |   2 +-
 arch/arm64/kvm/hyp.S               |  24 ++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 113 +++++++++++++++++++++++++----
 5 files changed, 145 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 4bbde3d3989c..4a73f1349151 100644
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
index 16adbefde1cc..82c941cf8890 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -11,6 +11,7 @@
 #ifndef __ARM64_KVM_HOST_H__
 #define __ARM64_KVM_HOST_H__
 
+#include <linux/arm-smccc.h>
 #include <linux/bitmap.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
@@ -479,18 +480,20 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
-u64 __kvm_call_hyp(void *hypfn, ...);
+u64 __kvm_call_hyp_init(phys_addr_t pgd_ptr,
+			unsigned long hyp_stack_ptr,
+			unsigned long vector_ptr,
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
@@ -516,7 +519,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 			ret = f(__VA_ARGS__);				\
 			isb();						\
 		} else {						\
-			ret = kvm_call_hyp_nvhe_ret(f, ##__VA_ARGS__);	\
+			ret = kvm_call_hyp_nvhe(f, ##__VA_ARGS__);	\
 		}							\
 									\
 		ret;							\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6b7180072c8d..49aa08bd26de 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1288,7 +1288,7 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
-	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
+	__kvm_call_hyp_init(pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
 
 	/*
 	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 3c79a1124af2..12aa426f7559 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -11,24 +11,12 @@
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
+ * 			   unsigned long tpidr_el2);
  */
-SYM_FUNC_START(__kvm_call_hyp)
+SYM_FUNC_START(__kvm_call_hyp_init)
 	hvc	#0
 	ret
-SYM_FUNC_END(__kvm_call_hyp)
+SYM_FUNC_END(__kvm_call_hyp_init)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c8938e09f585..13093df70c87 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -12,24 +12,111 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-typedef unsigned long (*hypcall_fn_t)
-	(unsigned long, unsigned long, unsigned long);
+#include <kvm/arm_hypercalls.h>
+
+static void handle_host_hcall(unsigned long func_id,
+			      struct kvm_cpu_context *host_ctxt)
+{
+	unsigned long ret = 0;
+
+	/*
+	 * __kvm_vcpu_run is a hot path of the context switch so identify it
+	 * quickly before searching through the other functions IDs.
+	 */
+	if (func_id == KVM_HOST_SMCCC_FUNC(__kvm_vcpu_run)) {
+		struct kvm_vcpu *vcpu =
+			(struct kvm_vcpu *)host_ctxt->regs.regs[1];
+
+		ret = __kvm_vcpu_run(vcpu);
+		goto out;
+	}
+
+	switch (func_id) {
+	case KVM_HOST_SMCCC_FUNC(__kvm_flush_vm_context):
+		__kvm_flush_vm_context();
+		break;
+	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid_ipa): {
+			struct kvm_s2_mmu *mmu =
+				(struct kvm_s2_mmu *)host_ctxt->regs.regs[1];
+			phys_addr_t ipa = host_ctxt->regs.regs[2];
+			int level = host_ctxt->regs.regs[3];
+
+			__kvm_tlb_flush_vmid_ipa(mmu, ipa, level);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid): {
+			struct kvm_s2_mmu *mmu =
+				(struct kvm_s2_mmu *)host_ctxt->regs.regs[1];
+
+			__kvm_tlb_flush_vmid(mmu);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): {
+			struct kvm_s2_mmu *mmu =
+				(struct kvm_s2_mmu *)host_ctxt->regs.regs[1];
+
+			__kvm_tlb_flush_local_vmid(mmu);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__kvm_timer_set_cntvoff): {
+			u64 cntvoff = host_ctxt->regs.regs[1];
+
+			__kvm_timer_set_cntvoff(cntvoff);
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
+			u32 vmcr = host_ctxt->regs.regs[1];
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
+				(struct vgic_v3_cpu_if *)host_ctxt->regs.regs[1];
+
+			__vgic_v3_save_aprs(cpu_if);
+			break;
+		}
+	case KVM_HOST_SMCCC_FUNC(__vgic_v3_restore_aprs): {
+			struct vgic_v3_cpu_if *cpu_if =
+				(struct vgic_v3_cpu_if *)host_ctxt->regs.regs[1];
+
+			__vgic_v3_restore_aprs(cpu_if);
+			break;
+		}
+	default:
+		/* Invalid host HVC. */
+		host_ctxt->regs.regs[0] = SMCCC_RET_NOT_SUPPORTED;
+		return;
+	}
+
+out:
+	host_ctxt->regs.regs[0] = SMCCC_RET_SUCCESS;
+	host_ctxt->regs.regs[1] = ret;
+}
 
 void handle_trap(struct kvm_cpu_context *host_ctxt) {
 	u64 esr = read_sysreg_el2(SYS_ESR);
-	hypcall_fn_t func;
-	unsigned long ret;
+	unsigned long func_id;
 
 	if (ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64)
 		hyp_panic();
 
-	/*
-	 * __kvm_call_hyp takes a pointer in the host address space and
-	 * up to three arguments.
-	 */
-	func = (hypcall_fn_t)kern_hyp_va(host_ctxt->regs.regs[0]);
-	ret = func(host_ctxt->regs.regs[1],
-		   host_ctxt->regs.regs[2],
-		   host_ctxt->regs.regs[3]);
-	host_ctxt->regs.regs[0] = ret;
+	func_id = host_ctxt->regs.regs[0];
+	handle_host_hcall(func_id, host_ctxt);
 }
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

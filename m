Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838ACC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 376D361242
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 376D361242
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB20E4B1DB;
	Fri, 24 Sep 2021 08:54:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9U7uLkYeYO-z; Fri, 24 Sep 2021 08:54:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 781E54B1E9;
	Fri, 24 Sep 2021 08:54:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD49B4B1CF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CN8o0hGpvB6A for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:47 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E01FD4B1E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:46 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 v15-20020adff68f000000b0015df51efa18so7963541wrp.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Q+8n29A2U0S8NhAXycyXeyNJmHo/u/5CJ1rE8AvB4D8=;
 b=cxpNbynNFzYUxpl57MPUhLzZUKq20M6Q1Tq3Uvg3l5O/+YFgKxm+t3GqpLYgANuefD
 FPUjOhEFGEJy43xXVn6ZFNY0LFs4Uy6mjCyxHhS8Zo/wb78rOmhuQQJ9vwDTZv8/11dw
 DXLgiQ4WjLw2W/KPOPTTtiK/9s1sIFiRPMuNAefBb6r1alfL0vFOz1pUq+Crz1+Tc1Wf
 FYB+yadmLGksdNEeGyE+zllj0q2xhraWVXxhQ1ab7nRJfm8KrZox2fEDFaKyRLw+x4w4
 r49qzs8672CUxLgy2rljpqGDb7uuyXtfH+mlUs38aHU7pwRKXgh3dZ02yKB2BTwkyoQ8
 Ln1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Q+8n29A2U0S8NhAXycyXeyNJmHo/u/5CJ1rE8AvB4D8=;
 b=N8MA8bqr0Ev/QDTU5tSt6fDtDdQdvuNkbWAYmWIx6hPBIgDtZkuk6VCD4nhVjDZWa7
 6McrykSpBdalSAp+vPVasDyVOIg49S95+jnCxQPIiJQGu83BW5aSzs9LWnpYoyjnipNa
 HrzaxIe55Pl2ksCfYykkpupn/n7aOMATDcwr8dScQ3p3E7Kc2PX7YhWRIyV1LGPxCFEp
 8RLDNnbwcgH+BN9Y9LFM4EU9KvUu7Ol7XDoqg0Bb1NU7F1BFfqWFccR9bvRBiPKs0CMW
 e2KHu8+Xs9WknNOpun9539Rnbr9Jxys4gytstpBBJLS184hPDPhrJjr60LB4IVy9qMPG
 HMew==
X-Gm-Message-State: AOAM532lLAmrREA6i1reEGNAvxHl5vRHb6Is0HeRsbTxnIurCJDLPcQf
 gqv8nXnHDV3jHjeGNkCOIXFmDwknHIHq1qPtk9xMqonzBsBxwAnVryFNmZ5IAjg9Za8XwbzqH+p
 1YYXtvdNuWDva5RunHF2lpA2TNir0NTd/49wcnc9lFzkZ20Uar9sU3hCjKEy8HFAfMlI=
X-Google-Smtp-Source: ABdhPJwSaHPVCm7TSNiTJZE78dylDVwwxbZ3U77YPIEY25dKbKZj9TIDo4HPPu5CDTfj+SDFth6yZB/QeA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:ecd2:: with SMTP id
 s18mr11112114wro.99.1632488085955; 
 Fri, 24 Sep 2021 05:54:45 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:50 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-22-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 21/30] KVM: arm64: transition code to
 __hyp_running_ctxt and __hyp_running_hyps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Transition code for to use the new hyp_running pointers.
Everything is consistent, because all fields are in-sync.

Remove __hyp_running_vcpu now that no one is using it.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  | 24 ++++--------------------
 arch/arm64/include/asm/kvm_host.h |  5 +----
 arch/arm64/kernel/asm-offsets.c   |  1 -
 arch/arm64/kvm/handle_exit.c      |  6 +++---
 arch/arm64/kvm/hyp/nvhe/host.S    |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c  |  4 +---
 arch/arm64/kvm/hyp/vhe/switch.c   |  8 ++++----
 7 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 52079e937fcd..e24ebcf9e0d3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -246,31 +246,18 @@ extern u32 __kvm_get_mdcr_el2(void);
 	add	\reg, \reg, #HOST_DATA_CONTEXT
 .endm
 
-.macro get_vcpu_ptr vcpu, ctxt
-	get_host_ctxt \ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-.endm
-
 .macro get_vcpu_ctxt_ptr vcpu, ctxt
 	get_host_ctxt \ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-	add	\vcpu, \vcpu, #VCPU_CONTEXT
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_CTXT]
 .endm
 
 .macro get_vcpu_hyps_ptr vcpu, ctxt
 	get_host_ctxt \ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-	add	\vcpu, \vcpu, #VCPU_HYPS
-.endm
-
-.macro get_loaded_vcpu vcpu, ctxt
-	adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_HYPS]
 .endm
 
 .macro set_loaded_vcpu vcpu, ctxt, tmp
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \tmp
-	str	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
 
 	add	\tmp, \vcpu, #VCPU_CONTEXT
 	str	\tmp, [\ctxt, #HOST_CONTEXT_CTXT]
@@ -281,21 +268,18 @@ extern u32 __kvm_get_mdcr_el2(void);
 
 .macro clear_loaded_vcpu ctxt, tmp
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \tmp
-	str	xzr, [\ctxt, #HOST_CONTEXT_VCPU]
 	str	xzr, [\ctxt, #HOST_CONTEXT_CTXT]
 	str	xzr, [\ctxt, #HOST_CONTEXT_HYPS]
 .endm
 
 .macro get_loaded_vcpu_ctxt vcpu, ctxt
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-	add	\vcpu, \vcpu, #VCPU_CONTEXT
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_CTXT]
 .endm
 
 .macro get_loaded_vcpu_hyps vcpu, ctxt
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-	add	\vcpu, \vcpu, #VCPU_HYPS
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_HYPS]
 .endm
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b42d0c6c8004..035ca5a49166 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -227,15 +227,12 @@ struct kvm_cpu_context {
 
 	u64 sys_regs[NR_SYS_REGS];
 
-	struct kvm_vcpu *__hyp_running_vcpu;
 	struct kvm_cpu_context *__hyp_running_ctxt;
 	struct vcpu_hyp_state *__hyp_running_hyps;
 };
 
-#define get_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
 #define set_hyp_running_vcpu(host_ctxt, vcpu) do { \
 	struct kvm_vcpu *v = (vcpu); \
-	(host_ctxt)->__hyp_running_vcpu = v; \
 	if (vcpu) { \
 		(host_ctxt)->__hyp_running_ctxt = &v->arch.ctxt; \
 		(host_ctxt)->__hyp_running_hyps = &v->arch.hyp_state; \
@@ -245,7 +242,7 @@ struct kvm_cpu_context {
 	}\
 } while(0)
 
-#define is_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
+#define is_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_ctxt
 
 #define get_hyp_running_ctxt(host_ctxt) (host_ctxt)->__hyp_running_ctxt
 #define get_hyp_running_hyps(host_ctxt) (host_ctxt)->__hyp_running_hyps
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 9c25078da294..f42aea730cf4 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -116,7 +116,6 @@ int main(void)
   DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
   DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
-  DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
   DEFINE(HOST_CONTEXT_CTXT,	offsetof(struct kvm_cpu_context, __hyp_running_ctxt));
   DEFINE(HOST_CONTEXT_HYPS,	offsetof(struct kvm_cpu_context, __hyp_running_hyps));
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 22e9f03fe901..cb6a25b79e38 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -293,7 +293,7 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 }
 
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
-					      u64 par, uintptr_t vcpu,
+					      u64 par, uintptr_t vcpu_ctxt,
 					      u64 far, u64 hpfar) {
 	u64 elr_in_kimg = __phys_to_kimg(__hyp_pa(elr));
 	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr;
@@ -333,6 +333,6 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
 	 */
 	kvm_err("Hyp Offset: 0x%llx\n", hyp_offset);
 
-	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
-	      spsr, elr, esr, far, hpfar, par, vcpu);
+	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU_CTXT:%016lx\n",
+	      spsr, elr, esr, far, hpfar, par, vcpu_ctxt);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 7de2e8716f69..975cf125d54c 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -87,7 +87,7 @@ SYM_FUNC_START(__hyp_do_panic)
 
 	/* Load the panic arguments into x0-7 */
 	mrs	x0, esr_el2
-	get_vcpu_ptr x4, x5
+	get_vcpu_ctxt_ptr x4, x5
 	mrs	x5, far_el2
 	mrs	x6, hpfar_el2
 	mov	x7, xzr			// Unused argument
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 12c673301210..483df8fe052e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -272,14 +272,12 @@ void __noreturn hyp_panic(void)
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
 	struct kvm_cpu_context *host_ctxt;
-	struct kvm_vcpu *vcpu;
 	struct vcpu_hyp_state *vcpu_hyps;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	vcpu = get_hyp_running_vcpu(host_ctxt);
 	vcpu_hyps = get_hyp_running_hyps(host_ctxt);
 
-	if (vcpu) {
+	if (vcpu_hyps) {
 		__timer_disable_traps();
 		__deactivate_traps(vcpu_hyps);
 		__load_host_stage2();
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 14c434e00914..64de9f0d7636 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -203,20 +203,20 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
-	struct kvm_vcpu *vcpu;
+	struct kvm_cpu_context *vcpu_ctxt;
 	struct vcpu_hyp_state *vcpu_hyps;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	vcpu = get_hyp_running_vcpu(host_ctxt);
+	vcpu_ctxt = get_hyp_running_ctxt(host_ctxt);
 	vcpu_hyps = get_hyp_running_hyps(host_ctxt);
 
 	__deactivate_traps(vcpu_hyps);
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n",
+	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU_CTXT:%p\n",
 	      spsr, elr,
 	      read_sysreg_el2(SYS_ESR), read_sysreg_el2(SYS_FAR),
-	      read_sysreg(hpfar_el2), par, vcpu);
+	      read_sysreg(hpfar_el2), par, vcpu_ctxt);
 }
 NOKPROBE_SYMBOL(__hyp_call_panic);
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

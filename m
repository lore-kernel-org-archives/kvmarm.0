Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B339CC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 657366147F
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 657366147F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 190BD4B1AA;
	Fri, 24 Sep 2021 08:54:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eUk4xQpJVgCp; Fri, 24 Sep 2021 08:54:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56E3B4B0DF;
	Fri, 24 Sep 2021 08:54:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8FFF4B165
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OCFcGUQ1hpnv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:30 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD9794B17B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:29 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 e6-20020a0cb446000000b0037eeb9851dfso30074923qvf.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tcAwNt45Vh1nx0SA/+pHzECez1ST6+QmIJi+nsrNrnY=;
 b=rRJqgmjLCucwh+wufx8j237AwU9kX/U6m3gu4FcHEgCl+7TjZpNNRxFyoVmz2wJBhi
 SyVaJHfYhbMRpDDAZD4yRAxl3UbZs8T1bKZ4mlI1LrPCKDeS9f+Qj6WH4IP2NuyoO4tT
 VupZMeTBPVWdBvyzICj7uTz7Rkrth+DuXDdeD4CFu4yB1rKnLlkaOJhA/3ZcWF5DX78d
 xCXOMpDIn9HAdiF1sHJUrZa1jdz0AKjfBdkfhTKIZVMCcz5n+Gw+nKohd8+YBRfoUFep
 YuBpZr6s8s/Dsj1iCua9XlGC2xMHtcNAyDby42cvr1ruvD75NDgPLpDA/yxRoaWHy83P
 GBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tcAwNt45Vh1nx0SA/+pHzECez1ST6+QmIJi+nsrNrnY=;
 b=lJrUZ93BKcynPvK5Y9rAcQzbWfLZSMf29AZHnehtSjW1E3dIi4HyiahqMzGeUj1WPD
 q7+V0cuIgE7aj8jtWv/P3pektr6GyQKculhJVSmlJjx+BHFYDToPB3mfPAC05r6ZqwB7
 iTKV6bAKABv2VWtkQow0rC644tBvL9my7A5YdPIP8xkSFs47QbPtQcuxLEGj7rmRhcAr
 WxqKVkYN7X8bcQONo8IhJD5jnNOClruzCymVW2HbeJ/CYTRUjH3LOH9Ej59Snj21hsJP
 efmDUa5Ssd8dxG8W7F5+5j0DYtBGwtwR+e/3laJarSlvrohI37DcUCJWU8CUM2rlkQzn
 SJGQ==
X-Gm-Message-State: AOAM531W3gPcVx6VqsGCbjdAicQfahVTxiO2ZBWVvMEF8Pb3LvmcLhoO
 zPPz8IFZTeLpOGdjA7Izf0cjrJ/sDwzRDfyB0nldiZKw9SNkTY3qdVTVQAzLUD9YrqPayl0aohs
 GKM0uaewfMf2wC65br/dux0JROYWqZMuO9vLtrb3cbdXrQfpwtnJqS7fUC+SwoKUO+G0=
X-Google-Smtp-Source: ABdhPJwH2gVvKjdWYkyW8o/mToo0z94tmPdYf5a/AXeifZH/51OHiESFtVRdGTkNYrDA6ygLN0UnaBeGBg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:4a8f:: with SMTP id
 h15mr9910607qvx.2.1632488069370; 
 Fri, 24 Sep 2021 05:54:29 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:42 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-14-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 13/30] KVM: arm64: change function parameters to use
 kvm_cpu_ctxt and hyp_state
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

__kvm_skip_instr, kvm_condition_valid, and __kvm_adjust_pc are
passed the vcpu when all they need is the context as well as the
hypervisor state. Refactor them to use these instead.

These functions are called directly or indirectly in future
patches from contexts that don't have access to the whole vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h       | 15 ++++++++++-----
 arch/arm64/kvm/hyp/aarch32.c               | 14 +++++---------
 arch/arm64/kvm/hyp/exception.c             | 19 ++++++++++---------
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 14 ++++++--------
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           |  2 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   |  6 +++---
 arch/arm64/kvm/hyp/vgic-v3-sr.c            |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c            |  2 +-
 9 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index e095afeecd10..28fc4781249e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -33,8 +33,8 @@ enum exception_type {
 	except_type_serror	= 0x180,
 };
 
-bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
-void kvm_skip_instr32(struct kvm_vcpu *vcpu);
+bool kvm_condition_valid32(const struct kvm_cpu_context *vcpu_ctxt, const struct vcpu_hyp_state *vcpu_hyps);
+void kvm_skip_instr32(struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
@@ -162,14 +162,19 @@ static __always_inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 	return ctxt_mode_is_32bit(&vcpu_ctxt(vcpu));
 }
 
-static __always_inline bool kvm_condition_valid(const struct kvm_vcpu *vcpu)
+static __always_inline bool __kvm_condition_valid(const struct kvm_cpu_context *vcpu_ctxt, const struct vcpu_hyp_state *vcpu_hyps)
 {
-	if (vcpu_mode_is_32bit(vcpu))
-		return kvm_condition_valid32(vcpu);
+	if (ctxt_mode_is_32bit(vcpu_ctxt))
+		return kvm_condition_valid32(vcpu_ctxt, vcpu_hyps);
 
 	return true;
 }
 
+static __always_inline bool kvm_condition_valid(const struct kvm_vcpu *vcpu)
+{
+	return __kvm_condition_valid(&vcpu->arch.ctxt, &hyp_state(vcpu));
+}
+
 static inline void ctxt_set_thumb(struct kvm_cpu_context *ctxt)
 {
 	*ctxt_cpsr(ctxt) |= PSR_AA32_T_BIT;
diff --git a/arch/arm64/kvm/hyp/aarch32.c b/arch/arm64/kvm/hyp/aarch32.c
index 2d45e13d1b12..2feb2f8d9907 100644
--- a/arch/arm64/kvm/hyp/aarch32.c
+++ b/arch/arm64/kvm/hyp/aarch32.c
@@ -44,20 +44,18 @@ static const unsigned short cc_map[16] = {
 /*
  * Check if a trapped instruction should have been executed or not.
  */
-bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
+bool kvm_condition_valid32(const struct kvm_cpu_context *vcpu_ctxt, const struct vcpu_hyp_state *vcpu_hyps)
 {
-	const struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	const struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	unsigned long cpsr;
 	u32 cpsr_cond;
 	int cond;
 
 	/* Top two bits non-zero?  Unconditional. */
-	if (kvm_vcpu_get_esr(vcpu) >> 30)
+	if (kvm_hyp_state_get_esr(vcpu_hyps) >> 30)
 		return true;
 
 	/* Is condition field valid? */
-	cond = kvm_vcpu_get_condition(vcpu);
+	cond = kvm_hyp_state_get_condition(vcpu_hyps);
 	if (cond == 0xE)
 		return true;
 
@@ -125,15 +123,13 @@ static void kvm_adjust_itstate(struct kvm_cpu_context *vcpu_ctxt)
  * kvm_skip_instr - skip a trapped instruction and proceed to the next
  * @vcpu: The vcpu pointer
  */
-void kvm_skip_instr32(struct kvm_vcpu *vcpu)
+void kvm_skip_instr32(struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 pc = *ctxt_pc(vcpu_ctxt);
 	bool is_thumb;
 
 	is_thumb = !!(*ctxt_cpsr(vcpu_ctxt) & PSR_AA32_T_BIT);
-	if (is_thumb && !kvm_vcpu_trap_il_is32bit(vcpu))
+	if (is_thumb && !kvm_hyp_state_trap_il_is32bit(vcpu_hyps))
 		pc += 2;
 	else
 		pc += 4;
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index d4c2905b595d..a08806efe031 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -329,11 +329,9 @@ static void enter_exception32(struct kvm_cpu_context *vcpu_ctxt, u32 mode,
 	*ctxt_pc(vcpu_ctxt) = vect_offset;
 }
 
-static void kvm_inject_exception(struct kvm_vcpu *vcpu)
+static void kvm_inject_exception(struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	if (vcpu_el1_is_32bit(vcpu)) {
+	if (hyp_state_el1_is_32bit(vcpu_hyps)) {
 		switch (hyp_state_flags(vcpu_hyps) & KVM_ARM64_EXCEPT_MASK) {
 		case KVM_ARM64_EXCEPT_AA32_UND:
 			enter_exception32(vcpu_ctxt, PSR_AA32_MODE_UND, 4);
@@ -370,16 +368,19 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
  * Adjust the guest PC (and potentially exception state) depending on
  * flags provided by the emulation code.
  */
-void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
+void kvm_adjust_pc(struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_PENDING_EXCEPTION) {
-		kvm_inject_exception(vcpu);
+		kvm_inject_exception(vcpu_ctxt, vcpu_hyps);
 		hyp_state_flags(vcpu_hyps) &= ~(KVM_ARM64_PENDING_EXCEPTION |
 				      KVM_ARM64_EXCEPT_MASK);
 	} else 	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_INCREMENT_PC) {
-		kvm_skip_instr(vcpu);
+		kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 		hyp_state_flags(vcpu_hyps) &= ~KVM_ARM64_INCREMENT_PC;
 	}
 }
+
+void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
+{
+	kvm_adjust_pc(&vcpu_ctxt(vcpu), &hyp_state(vcpu));
+}
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index 9bbe452a461a..4e0cfbe635e5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -13,12 +13,10 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 
-static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
+static inline void kvm_skip_instr(struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (ctxt_mode_is_32bit(vcpu_ctxt)) {
-		kvm_skip_instr32(vcpu);
+		kvm_skip_instr32(vcpu_ctxt, vcpu_hyps);
 	} else {
 		*ctxt_pc(vcpu_ctxt) += 4;
 		*ctxt_cpsr(vcpu_ctxt) &= ~PSR_BTYPE_MASK;
@@ -32,14 +30,12 @@ static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
  * Skip an instruction which has been emulated at hyp while most guest sysregs
  * are live.
  */
-static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
+static inline void __kvm_skip_instr(struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	*ctxt_pc(vcpu_ctxt) = read_sysreg_el2(SYS_ELR);
 	ctxt_gp_regs(vcpu_ctxt)->pstate = read_sysreg_el2(SYS_SPSR);
 
-	kvm_skip_instr(vcpu);
+	kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 
 	write_sysreg_el2(ctxt_gp_regs(vcpu_ctxt)->pstate, SYS_SPSR);
 	write_sysreg_el2(*ctxt_pc(vcpu_ctxt), SYS_ELR);
@@ -54,4 +50,6 @@ static inline void kvm_skip_host_instr(void)
 	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
 }
 
+void kvm_adjust_pc(struct kvm_cpu_context *vcpu_ctxt, struct vcpu_hyp_state *vcpu_hyps);
+
 #endif
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5ee8aac86fdc..075719c07009 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -350,7 +350,7 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 		return false;
 	}
 
-	__kvm_skip_instr(vcpu);
+	__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 	return true;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index d9326085387b..eadbf2ccaf68 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -204,7 +204,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	__debug_save_host_buffers_nvhe(vcpu);
 
-	__kvm_adjust_pc(vcpu);
+	kvm_adjust_pc(vcpu_ctxt, vcpu_hyps);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 84304d6d455a..acd0d21394e3 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -55,13 +55,13 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 
 	/* Reject anything but a 32bit access */
 	if (kvm_vcpu_dabt_get_as(vcpu) != sizeof(u32)) {
-		__kvm_skip_instr(vcpu);
+		__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 		return -1;
 	}
 
 	/* Not aligned? Don't bother */
 	if (fault_ipa & 3) {
-		__kvm_skip_instr(vcpu);
+		__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 		return -1;
 	}
 
@@ -85,7 +85,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		ctxt_set_reg(vcpu_ctxt, rd, data);
 	}
 
-	__kvm_skip_instr(vcpu);
+	__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 
 	return 1;
 }
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 725b2976e7c2..d025a5830dcc 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -1086,7 +1086,7 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	esr = kvm_vcpu_get_esr(vcpu);
 	if (ctxt_mode_is_32bit(vcpu_ctxt)) {
 		if (!kvm_condition_valid(vcpu)) {
-			__kvm_skip_instr(vcpu);
+			__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 			return 1;
 		}
 
@@ -1198,7 +1198,7 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	rt = kvm_vcpu_sys_get_rt(vcpu);
 	fn(vcpu, vmcr, rt);
 
-	__kvm_skip_instr(vcpu);
+	__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 
 	return 1;
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c9da0d1c7e72..395274532c20 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -135,7 +135,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__load_guest_stage2(vcpu->arch.hw_mmu);
 	__activate_traps(vcpu);
 
-	__kvm_adjust_pc(vcpu);
+	kvm_adjust_pc(vcpu_ctxt, vcpu_hyps);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB2BC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5415D207E8
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Okgzc/Jn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5415D207E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1023D4B568;
	Thu, 25 Jun 2020 09:14:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id azH2uYQYF9RI; Thu, 25 Jun 2020 09:14:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4563A4B570;
	Thu, 25 Jun 2020 09:14:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F60F4B543
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bbnKvKQJS+Xv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:48 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E71B4B17A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:48 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id 17so5893872wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ETvcnIdoYOd6fKRkr8kW0WKFku8qOtdzIFy0DsfdfKU=;
 b=Okgzc/Jnhq/ZtNvgRmU0RPWD7yyRO9AEZ4X+49Cd25zX0I/s5yIM5M1jVXZ/WpTNvv
 eqnhcbK/B66VKiGhBbTzcrgbJof4EpMrrUJwOzbOpWFcFCjtJ9vdlFIc3ziBouKPpy+a
 3eqgJC3bsDLdbR8rcdCxt0aPC5qKGaxTCkgRCdP8e5/Ge/TNsuGYLpBRvpDXqV1+TdVi
 hqBj0HtV2lpswo/suhTmeirJSGwj09i/aND3huyDwYPdhbLDeTQZI3YkytO1NhJwVD3X
 xcMoqCoRGb7+TywX0UmciB86ZKOuTtMz/KJffnTVB+k+ZbsnfiMH82tggSL63uQGjCQK
 80sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ETvcnIdoYOd6fKRkr8kW0WKFku8qOtdzIFy0DsfdfKU=;
 b=sMbbDEtp4FHZ5qJy+R4tluEqDOTEYCH5y9HumGFVtTXL1sB+JEbgXFnqZet9SY/+bG
 lBcXG3xjJ70JPlIzcoZXmNC4yxZ/xhIH98KR9tTca2RU5/3HbNm2k7ar1HClqkcguJgS
 +GNy13GpkEa6Nuy69tVFtiFL6vFvPh9xq6O1M8hRFFwiM/jJdJkpYZbJv+KCO4OFxQmK
 tSjN/hucibJze/7kC67WNwsAWXzLBKjQNyIDEkEz23nece8qVD7/ShJzRTCfivkOEBsS
 D5iGaREa7n5MDJJyBMcgsnJPHNvnS4A/lUXJ0GsZZUIg7KZh3qBDVgXWrw+uFAybNbFQ
 /QbA==
X-Gm-Message-State: AOAM530fpvuF5wT+vQ3bs/IF54W7QYd6tZflAaeT06ATfCdg7Xzzw9EM
 jUnw0bhUYqHz4U0SoqWKbk3eIiufwEaz90Oi
X-Google-Smtp-Source: ABdhPJzsxT2/tFsbVgmThb5b99ShdDMJHyyME9TgWW5rpzINN9MdAqckQFWofUF84Be2eT03dISZFQ==
X-Received: by 2002:a1c:f60d:: with SMTP id w13mr3489927wmc.51.1593090887222; 
 Thu, 25 Jun 2020 06:14:47 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id d2sm31803367wrs.95.2020.06.25.06.14.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:46 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 11/15] arm64: kvm: Split hyp/sysreg-sr.c to VHE/nVHE
Date: Thu, 25 Jun 2020 14:14:16 +0100
Message-Id: <20200625131420.71444-12-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

sysreg-sr.c contains KVM's code for saving/restoring system registers, with
some code shared between VHE/nVHE. These common routines are moved to
a header file, VHE-specific code is moved to vhe/sysreg-sr.c and nVHE-specific
code to nvhe/sysreg-sr.c.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_host.h             |   6 +-
 arch/arm64/include/asm/kvm_hyp.h              |   5 +-
 arch/arm64/kernel/image-vars.h                |   7 -
 arch/arm64/kvm/arm.c                          |   8 +-
 arch/arm64/kvm/hyp/Makefile                   |   4 +-
 .../{sysreg-sr.c => include/hyp/sysreg-sr.h}  | 158 ++----------------
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   1 +
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |  46 +++++
 arch/arm64/kvm/hyp/vhe/Makefile               |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            | 114 +++++++++++++
 12 files changed, 191 insertions(+), 164 deletions(-)
 rename arch/arm64/kvm/hyp/{sysreg-sr.c => include/hyp/sysreg-sr.h} (56%)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/sysreg-sr.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 49d1a5cd8f8f..e0920df1d0c1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -338,7 +338,7 @@ struct kvm_vcpu_arch {
 	struct vcpu_reset_state	reset_state;
 
 	/* True when deferrable sysregs are loaded on the physical CPU,
-	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
+	 * see kvm_vcpu_load_sysregs_vhe and kvm_vcpu_put_sysregs_vhe. */
 	bool sysregs_loaded_on_cpu;
 
 	/* Guest PV state */
@@ -639,8 +639,8 @@ static inline int kvm_arm_have_ssbd(void)
 	}
 }
 
-void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
-void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
+void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu);
 
 int kvm_set_ipa_limit(void);
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 82fa05d15b8b..997c5bda1ac7 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -66,14 +66,15 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
 
+#ifdef __KVM_NVHE_HYPERVISOR__
 void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt);
+#else
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
-void __sysreg32_save_state(struct kvm_vcpu *vcpu);
-void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
+#endif
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 663d5b70fa49..05c642621d61 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -76,13 +76,6 @@ KVM_NVHE_ALIAS(abort_guest_exit_start);
 KVM_NVHE_ALIAS(__fpsimd_restore_state);
 KVM_NVHE_ALIAS(__fpsimd_save_state);
 
-/* Symbols defined in sysreg-sr.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__kvm_enable_ssbs);
-KVM_NVHE_ALIAS(__sysreg32_restore_state);
-KVM_NVHE_ALIAS(__sysreg32_save_state);
-KVM_NVHE_ALIAS(__sysreg_restore_state_nvhe);
-KVM_NVHE_ALIAS(__sysreg_save_state_nvhe);
-
 /* Symbols defined in timer-sr.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__kvm_timer_set_cntvoff);
 KVM_NVHE_ALIAS(__timer_disable_traps);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8d3d66ebf295..8ca2c111cec2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -351,7 +351,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
-	kvm_vcpu_load_sysregs(vcpu);
+	if (has_vhe())
+		kvm_vcpu_load_sysregs_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
@@ -369,7 +370,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	kvm_arch_vcpu_put_fp(vcpu);
-	kvm_vcpu_put_sysregs(vcpu);
+	if (has_vhe())
+		kvm_vcpu_put_sysregs_vhe(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
@@ -1302,7 +1304,7 @@ static void cpu_init_hyp_mode(void)
 	 */
 	if (this_cpu_has_cap(ARM64_SSBS) &&
 	    arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE) {
-		kvm_call_hyp(__kvm_enable_ssbs);
+		kvm_call_hyp_nvhe(__kvm_enable_ssbs);
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index fc09025d2e97..f49797237818 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -13,8 +13,8 @@ subdir-ccflags-y := -I$(incdir)				\
 obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
-hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
-	 entry.o fpsimd.o
+hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o entry.o \
+	 fpsimd.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
similarity index 56%
rename from arch/arm64/kvm/hyp/sysreg-sr.c
rename to arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 2493439a5c54..3e0585fbd403 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -4,6 +4,9 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#ifndef __ARM64_KVM_HYP_SYSREG_SR_H__
+#define __ARM64_KVM_HYP_SYSREG_SR_H__
+
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 
@@ -12,30 +15,18 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
-/*
- * Non-VHE: Both host and guest must save everything.
- *
- * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
- * pstate, which are handled as part of the el2 return state) on every
- * switch (sp_el0 is being dealt with in the assembly code).
- * tpidr_el0 and tpidrro_el0 only need to be switched when going
- * to host userspace or a different VCPU.  EL1 registers only need to be
- * switched when potentially going to run a different VCPU.  The latter two
- * classes are handled as part of kvm_arch_vcpu_load and kvm_arch_vcpu_put.
- */
-
-static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
 }
 
-static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
 	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
 }
 
-static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
 	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
@@ -60,7 +51,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(SYS_SPSR);
 }
 
-static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->gp_regs.regs.pc		= read_sysreg_el2(SYS_ELR);
 	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(SYS_SPSR);
@@ -69,39 +60,18 @@ static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ct
 		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
 }
 
-void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_save_el1_state(ctxt);
-	__sysreg_save_common_state(ctxt);
-	__sysreg_save_user_state(ctxt);
-	__sysreg_save_el2_return_state(ctxt);
-}
-
-void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_save_common_state(ctxt);
-}
-NOKPROBE_SYMBOL(sysreg_save_host_state_vhe);
-
-void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_save_common_state(ctxt);
-	__sysreg_save_el2_return_state(ctxt);
-}
-NOKPROBE_SYMBOL(sysreg_save_guest_state_vhe);
-
-static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
 }
 
-static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[TPIDR_EL0],		tpidr_el0);
 	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0],	tpidrro_el0);
 }
 
-static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
@@ -160,8 +130,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
 }
 
-static void __hyp_text
-__sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
+static inline void __hyp_text __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
 	u64 pstate = ctxt->gp_regs.regs.pstate;
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
@@ -187,28 +156,7 @@ __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
 }
 
-void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_restore_el1_state(ctxt);
-	__sysreg_restore_common_state(ctxt);
-	__sysreg_restore_user_state(ctxt);
-	__sysreg_restore_el2_return_state(ctxt);
-}
-
-void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_restore_common_state(ctxt);
-}
-NOKPROBE_SYMBOL(sysreg_restore_host_state_vhe);
-
-void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_restore_common_state(ctxt);
-	__sysreg_restore_el2_return_state(ctxt);
-}
-NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
-
-void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
+static inline void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
@@ -230,7 +178,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
 }
 
-void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
+static inline void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
@@ -252,82 +200,4 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
 }
 
-/**
- * kvm_vcpu_load_sysregs - Load guest system registers to the physical CPU
- *
- * @vcpu: The VCPU pointer
- *
- * Load system registers that do not affect the host's execution, for
- * example EL1 system registers on a VHE system where the host kernel
- * runs at EL2.  This function is called from KVM's vcpu_load() function
- * and loading system register state early avoids having to load them on
- * every entry to the VM.
- */
-void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
-	struct kvm_cpu_context *host_ctxt;
-
-	if (!has_vhe())
-		return;
-
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	__sysreg_save_user_state(host_ctxt);
-
-	/*
-	 * Load guest EL1 and user state
-	 *
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 */
-	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_user_state(guest_ctxt);
-	__sysreg_restore_el1_state(guest_ctxt);
-
-	vcpu->arch.sysregs_loaded_on_cpu = true;
-
-	activate_traps_vhe_load(vcpu);
-}
-
-/**
- * kvm_vcpu_put_sysregs - Restore host system registers to the physical CPU
- *
- * @vcpu: The VCPU pointer
- *
- * Save guest system registers that do not affect the host's execution, for
- * example EL1 system registers on a VHE system where the host kernel
- * runs at EL2.  This function is called from KVM's vcpu_put() function
- * and deferring saving system register state until we're no longer running the
- * VCPU avoids having to save them on every exit from the VM.
- */
-void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
-	struct kvm_cpu_context *host_ctxt;
-
-	if (!has_vhe())
-		return;
-
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	deactivate_traps_vhe_put();
-
-	__sysreg_save_el1_state(guest_ctxt);
-	__sysreg_save_user_state(guest_ctxt);
-	__sysreg32_save_state(vcpu);
-
-	/* Restore host user state */
-	__sysreg_restore_user_state(host_ctxt);
-
-	vcpu->arch.sysregs_loaded_on_cpu = false;
-}
-
-void __hyp_text __kvm_enable_ssbs(void)
-{
-	u64 tmp;
-
-	asm volatile(
-	"mrs	%0, sctlr_el2\n"
-	"orr	%0, %0, %1\n"
-	"msr	sctlr_el2, %0"
-	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
-}
+#endif /* __ARM64_KVM_HYP_SYSREG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b3cb67b63d67..61a8160f0dd9 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := debug-sr.o switch.o tlb.o hyp-init.o ../hyp-entry.o
+obj-y := sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7f6b8d3dc637..f08bfb951df6 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -5,6 +5,7 @@
  */
 
 #include <hyp/switch.h>
+#include <hyp/sysreg-sr.h>
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
new file mode 100644
index 000000000000..710cf28ab1ec
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2012-2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <hyp/sysreg-sr.h>
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kprobes.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+
+/*
+ * Non-VHE: Both host and guest must save everything.
+ */
+
+void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_el1_state(ctxt);
+	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
+}
+
+void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_el1_state(ctxt);
+	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
+}
+
+void __hyp_text __kvm_enable_ssbs(void)
+{
+	u64 tmp;
+
+	asm volatile(
+	"mrs	%0, sctlr_el2\n"
+	"orr	%0, %0, %1\n"
+	"msr	sctlr_el2, %0"
+	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
+}
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 62bdaf272b03..2801582a739a 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := debug-sr.o switch.o tlb.o ../hyp-entry.o
+obj-y := sysreg-sr.o debug-sr.o switch.o tlb.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index e8d76cab44e4..c0d33deba77e 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -120,7 +120,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	 * HCR_EL2.TGE.
 	 *
 	 * We have already configured the guest's stage 1 translation in
-	 * kvm_vcpu_load_sysregs above.  We must now call __activate_vm
+	 * kvm_vcpu_load_sysregs_vhe above.  We must now call __activate_vm
 	 * before __activate_traps, because __activate_vm configures
 	 * stage 2 translation, and __activate_traps clear HCR_EL2.TGE
 	 * (among other things).
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
new file mode 100644
index 000000000000..996471e4c138
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2012-2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <hyp/sysreg-sr.h>
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kprobes.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+
+/*
+ * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
+ * pstate, which are handled as part of the el2 return state) on every
+ * switch (sp_el0 is being dealt with in the assembly code).
+ * tpidr_el0 and tpidrro_el0 only need to be switched when going
+ * to host userspace or a different VCPU.  EL1 registers only need to be
+ * switched when potentially going to run a different VCPU.  The latter two
+ * classes are handled as part of kvm_arch_vcpu_load and kvm_arch_vcpu_put.
+ */
+
+void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_common_state(ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_save_host_state_vhe);
+
+void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_common_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_save_guest_state_vhe);
+
+void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_common_state(ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_restore_host_state_vhe);
+
+void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
+
+/**
+ * kvm_vcpu_load_sysregs_vhe - Load guest system registers to the physical CPU
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * Load system registers that do not affect the host's execution, for
+ * example EL1 system registers on a VHE system where the host kernel
+ * runs at EL2.  This function is called from KVM's vcpu_load() function
+ * and loading system register state early avoids having to load them on
+ * every entry to the VM.
+ */
+void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	__sysreg_save_user_state(host_ctxt);
+
+	/*
+	 * Load guest EL1 and user state
+	 *
+	 * We must restore the 32-bit state before the sysregs, thanks
+	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 */
+	__sysreg32_restore_state(vcpu);
+	__sysreg_restore_user_state(guest_ctxt);
+	__sysreg_restore_el1_state(guest_ctxt);
+
+	vcpu->arch.sysregs_loaded_on_cpu = true;
+
+	activate_traps_vhe_load(vcpu);
+}
+
+/**
+ * kvm_vcpu_put_sysregs_vhe - Restore host system registers to the physical CPU
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * Save guest system registers that do not affect the host's execution, for
+ * example EL1 system registers on a VHE system where the host kernel
+ * runs at EL2.  This function is called from KVM's vcpu_put() function
+ * and deferring saving system register state until we're no longer running the
+ * VCPU avoids having to save them on every exit from the VM.
+ */
+void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	deactivate_traps_vhe_put();
+
+	__sysreg_save_el1_state(guest_ctxt);
+	__sysreg_save_user_state(guest_ctxt);
+	__sysreg32_save_state(vcpu);
+
+	/* Restore host user state */
+	__sysreg_restore_user_state(host_ctxt);
+
+	vcpu->arch.sysregs_loaded_on_cpu = false;
+}
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

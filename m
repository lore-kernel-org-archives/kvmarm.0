Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AF8C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62746207BB
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="W7GGgA4F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62746207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CD5C4B3D0;
	Wed, 15 Jul 2020 14:45:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Q2LbSHW-CxR; Wed, 15 Jul 2020 14:45:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6AB44B3E0;
	Wed, 15 Jul 2020 14:45:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23CED4B381
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kOCxmB3XzJjC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:34 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6FB74B3C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:33 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id j16so1967297wrw.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BxWbH3WA+MXeEvzz1k2asVpc0QOo6M2u0gw/SGscnNg=;
 b=W7GGgA4FzO4YhQsyBP+/viS6z63Qsf6Z0CZV69qxwWgBQ0b8BapY+HzeNNWRuJOMQo
 IY3bipWGGgTLjfcomo/h7Q2SvD9+dGmmG9zgOG1P5HfjsL9YUhJOtt+fnKzS8qFb7cde
 JMf42mdFLkztxmxzPDtL20aIvJ3O54SYYx5MOMPsi1FQqLemjXJKwKYOGKZJ0W/6nmu6
 BvsYQwxCu62CGOyp6jB8tn+CaqXbPa15Fnt9ykFP3mG8tI+l034tmwWur2MQSN0JwsUq
 AlJN14mbtyZyo7x0hF4i9xH2ZI+vUdfcRuYR+h7m++JJWR4g7wf7NR9bAOTfIQl+tmJf
 r4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BxWbH3WA+MXeEvzz1k2asVpc0QOo6M2u0gw/SGscnNg=;
 b=fiwMkvMpDFIdC8F9Vu8579kq/BUmZvq8JGzIhHxN+lieTmAPzXhYdOQtvKCKPk8c5Y
 MM2x9FlUu4bxxphwDssxqXITofN6HXELMJ/ukXtytJQwFRvuMfiPbvq4zzXknU8ECoGG
 RRSdcIsdXH7AV522wok0h3ZEIxJbcPJwtnKcbT+U71f/HprP2UyPjw4gD4PjMzmceaTn
 kfCgpHY198JVBDrqqh0+y7F8cUpVwiEwe5DfPcAJfgT7AwRli7Hp54YWc7FWF41LcUc8
 AezNkSyZHstG+OXVdlUfkZcQ0g/gO0jXv3c4UEATh6CwU+Nw57mYfcxKxQUxRVUyQX6J
 SzMw==
X-Gm-Message-State: AOAM532l63UVsDNtDJoJ5HEyMjv9eGlWs3BGY5fNEY5YZxSUYEFCMzYQ
 2poaJPQL0QXFDH0ffenrEWBws0z9mzKxMC6fWrelqqJntKqj4gLh+u0NwLu5HLZDjXUsRea72KD
 63z6hBPdsLAA6zFzhoauJcV36GREhoFT02YbIcvhOrOWe18+fceVTI0zPlck3lUDDdD0fvg==
X-Google-Smtp-Source: ABdhPJzmrQ8XNornTmXFBBiMMB0Te9/wAKLu+CS2iyguLlYo7ZutvRx57o84VlJpncuamCQSnwkYR6Q+Nug=
X-Received: by 2002:a5d:4591:: with SMTP id p17mr697968wrq.343.1594838732949; 
 Wed, 15 Jul 2020 11:45:32 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:21 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-21-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 20/37] KVM: arm64: nVHE: Use host vcpu context for host debug
 state
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

Migrate the host's debug state from kvm_host_data's context and into the
host's vcpu context.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h          |  5 +++++
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 16 ++++++----------
 arch/arm64/kvm/hyp/nvhe/debug-sr.c        | 20 ++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c        |  1 +
 arch/arm64/kvm/hyp/nvhe/switch.c          |  4 ++--
 arch/arm64/kvm/hyp/vhe/debug-sr.c         | 16 ++++++++++++++--
 6 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index d6915ab60e1f..aec61c9f6017 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -81,8 +81,13 @@ void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 #endif
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+void __debug_switch_to_guest(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu);
+void __debug_switch_to_host(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu);
+#else
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
+#endif
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 50ca5d048017..0d342418d706 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -125,38 +125,34 @@ static void __debug_restore_state(struct kvm_guest_debug_arch *dbg,
 	write_sysreg(ctxt_sys_reg(ctxt, MDCCINT_EL1), mdccint_el1);
 }
 
-static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
+static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu,
+						  struct kvm_guest_debug_arch *host_dbg,
+						  struct kvm_cpu_context *host_ctxt)
 {
-	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
-	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	guest_ctxt = &vcpu->arch.ctxt;
-	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
 	__debug_save_state(host_dbg, host_ctxt);
 	__debug_restore_state(guest_dbg, guest_ctxt);
 }
 
-static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
+static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu,
+						 struct kvm_guest_debug_arch *host_dbg,
+						 struct kvm_cpu_context *host_ctxt)
 {
-	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
-	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	guest_ctxt = &vcpu->arch.ctxt;
-	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
 	__debug_save_state(guest_dbg, guest_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 91a711aa8382..a5fa40c060a8 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -58,17 +58,29 @@ static void __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
 }
 
-void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+void __debug_switch_to_guest(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_guest_debug_arch *host_dbg;
+
+	host_ctxt = &host_vcpu->arch.ctxt;
+	host_dbg = host_vcpu->arch.debug_ptr;
+
 	/* Disable and flush SPE data generation */
 	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
-	__debug_switch_to_guest_common(vcpu);
+	__debug_switch_to_guest_common(vcpu, host_dbg, host_ctxt);
 }
 
-void __debug_switch_to_host(struct kvm_vcpu *vcpu)
+void __debug_switch_to_host(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_guest_debug_arch *host_dbg;
+
+	host_ctxt = &host_vcpu->arch.ctxt;
+	host_dbg = host_vcpu->arch.debug_ptr;
+
 	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
-	__debug_switch_to_host_common(vcpu);
+	__debug_switch_to_host_common(vcpu, host_dbg, host_ctxt);
 }
 
 u32 __kvm_get_mdcr_el2(void)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d013586e3a03..e7601de3b901 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -170,6 +170,7 @@ void __noreturn kvm_hyp_main(void)
 
 	host_vcpu->arch.flags = KVM_ARM64_HOST_VCPU_FLAGS;
 	host_vcpu->arch.workaround_flags = VCPU_WORKAROUND_2_FLAG;
+	host_vcpu->arch.debug_ptr = &host_vcpu->arch.vcpu_debug_state;
 
 	/*
 	 * The first time entering the host is seen by the host as the return
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index ae830a9ef9d9..629fea722de1 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -181,7 +181,7 @@ static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
 
-	__debug_switch_to_guest(vcpu);
+	__debug_switch_to_guest(host_vcpu, vcpu);
 }
 
 static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
@@ -206,7 +206,7 @@ static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_switch_to_host(vcpu);
+	__debug_switch_to_host(host_vcpu, vcpu);
 
 	__pmu_switch_to_host();
 
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
index f1e2e5a00933..6225c6cdfbca 100644
--- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -12,12 +12,24 @@
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 {
-	__debug_switch_to_guest_common(vcpu);
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_guest_debug_arch *host_dbg;
+
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_dbg = &vcpu->arch.host_debug_state.regs;
+
+	__debug_switch_to_guest_common(vcpu, host_dbg, host_ctxt);
 }
 
 void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
-	__debug_switch_to_host_common(vcpu);
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_guest_debug_arch *host_dbg;
+
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	host_dbg = &vcpu->arch.host_debug_state.regs;
+
+	__debug_switch_to_host_common(vcpu, host_dbg, host_ctxt);
 }
 
 u32 __kvm_get_mdcr_el2(void)
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

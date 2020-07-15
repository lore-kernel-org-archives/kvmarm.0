Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B420FC433E1
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87352207BB
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="bTk4gPTb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87352207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35BC54B3E3;
	Wed, 15 Jul 2020 14:45:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8EHXYbL0E6wS; Wed, 15 Jul 2020 14:45:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F2C74B3EB;
	Wed, 15 Jul 2020 14:45:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 253DB4B381
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BI3iAKQNzwcz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:37 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3826E4B3DC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:36 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id b8so1963605wro.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YNdJqbfh8erFG54gnNIJh6S2VsRUWtG9kWEyGgubWQA=;
 b=bTk4gPTb+oQI8QbkCR6sBzD1YBuiMn0Pi0xJuXSSeXwV/kUAG4khyac7giOfqaeDiA
 2Jr0oRVuMMQRaaUC4GFcBoYIekC8aTXcracXSS4luFxJqOW8+ivQhoBmprv5mNdWlrTT
 E7PE1fiOuzmRYS4+WoEmfQSR4DbCJ5lXfkNDgzxGAk2fHqQS+t8UEAfHnGGlh4GUPdmR
 PIseo6JzhdcterG3eWCE6KlbHtVbKJ6AGQcML0XsgNCJozN5BFQVNN5QSXeYFCzbt7AH
 2vLAhCX6/H5ttXJiBEOPvC2wqQv74eMvpGgQ/VueQ4k9BNo/QmXcRVptdNXCTwXUfn1F
 uP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YNdJqbfh8erFG54gnNIJh6S2VsRUWtG9kWEyGgubWQA=;
 b=YW/q+XK7fuPcTEQCVFvdP/owOa2PuNerKtb8fiaoEcYJPTKkP8rR7xQyp5zn5007jX
 bFqlZ3ZAtgHuzCTO/xD6crlluaSg51POv+n+ER2fnzfzSBl80ckt6K6dGM4AIUa8/5/L
 C8QxfYFbzGaIVoVD4906KehLgmcrWSbWPNQSPbq8vY24rEowV/pNki3TFXBByFu42pUH
 VBIJsnNKfKgKTX+UKIvZrH/4bU8DTyIZELIm1y31ClEvGpmgX0JSqoN6owpRDtDX9UGW
 2tuCIOTz1FgobbqdDY87Wq0ms9EBHrl9t6yRNSUS7JVY7R8hoE5pMYgvDoc92plzNByP
 +FfA==
X-Gm-Message-State: AOAM532CMbppAN+UuXgwQBdi5As4y9qQcMKMlTdU3oolI/U2PuT1MH3E
 yh8osRl7uO9FCKneeGVthaN7j/6iQwe8IIECoHJJwXDu6XPl/8cvOLfGX/JMvwO3OI/rKyS6rj3
 xD6o0SPzZXxoq2L4fVMtk3ktQACUmlGW1R/7F13TGCcj4weQt3jr7dJEekoZYmrfubkha5Q==
X-Google-Smtp-Source: ABdhPJwf8xC5y62GMWbv2mdqcBtIB1VHA7ijcoUXVUkMO1yz+V4ZFT2Q0SS5wZ02ql4e2+cg+F8gS/GzLZ0=
X-Received: by 2002:a1c:6384:: with SMTP id x126mr794427wmb.144.1594838735292; 
 Wed, 15 Jul 2020 11:45:35 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:22 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-22-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 21/37] KVM: arm64: Move host debug state from vcpu to percpu
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

As there's only one host on each CPU, there's no need to pollute
struct kvm_vcpu with this field. Especially when there different state
is needed between VHE and nVHE.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h  | 15 +++------------
 arch/arm64/include/asm/kvm_hyp.h   |  3 +++
 arch/arm64/kernel/image-vars.h     |  1 +
 arch/arm64/kvm/arm.c               | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  4 ++--
 arch/arm64/kvm/hyp/vhe/debug-sr.c  |  4 ++--
 6 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 152c050e74a9..37e94a49b668 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -308,11 +308,9 @@ struct kvm_vcpu_arch {
 	 * We maintain more than a single set of debug registers to support
 	 * debugging the guest from the host and to maintain separate host and
 	 * guest state during world switches. vcpu_debug_state are the debug
-	 * registers of the vcpu as the guest sees them.  host_debug_state are
-	 * the host registers which are saved and restored during
-	 * world switches. external_debug_state contains the debug
-	 * values we want to debug the guest. This is set via the
-	 * KVM_SET_GUEST_DEBUG ioctl.
+	 * registers of the vcpu as the guest sees them. external_debug_state
+	 * contains the debug values we want to debug the guest. This is set
+	 * via the KVM_SET_GUEST_DEBUG ioctl.
 	 *
 	 * debug_ptr points to the set of debug registers that should be loaded
 	 * onto the hardware when running the guest.
@@ -324,13 +322,6 @@ struct kvm_vcpu_arch {
 	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 
-	struct {
-		/* {Break,watch}point registers */
-		struct kvm_guest_debug_arch regs;
-		/* Statistical profiling extension */
-		u64 pmscr_el1;
-	} host_debug_state;
-
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index aec61c9f6017..75016c92d70b 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -15,6 +15,9 @@
 DECLARE_PER_CPU(struct kvm_vcpu *, kvm_hyp_running_vcpu);
 #ifdef __KVM_NVHE_HYPERVISOR__
 DECLARE_PER_CPU(struct kvm_vcpu, kvm_host_vcpu);
+DECLARE_PER_CPU(u64, kvm_host_pmscr_el1);
+#else
+DECLARE_PER_CPU(struct kvm_guest_debug_arch, kvm_host_debug_state);
 #endif
 
 #define read_sysreg_elx(r,nvh,vh)					\
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 5b93da2359d4..c75d74adfc8b 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -71,6 +71,7 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
 KVM_NVHE_ALIAS(kvm_host_data);
+KVM_NVHE_ALIAS(kvm_host_pmscr_el1);
 KVM_NVHE_ALIAS(kvm_host_vcpu);
 KVM_NVHE_ALIAS(kvm_hyp_running_vcpu);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe49203948d3..cb8ac29195be 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -49,6 +49,8 @@ __asm__(".arch_extension	virt");
 DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_vcpu, kvm_host_vcpu);
 DEFINE_PER_CPU(struct kvm_vcpu *, kvm_hyp_running_vcpu);
+DEFINE_PER_CPU(struct kvm_guest_debug_arch, kvm_host_debug_state);
+DEFINE_PER_CPU(u64, kvm_host_pmscr_el1);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
 /* The VMID used in the VTTBR */
@@ -1549,6 +1551,7 @@ static int init_hyp_mode(void)
 	for_each_possible_cpu(cpu) {
 		kvm_host_data_t *cpu_data;
 		struct kvm_vcpu *host_vcpu;
+		u64 *host_pmscr;
 		struct kvm_vcpu **running_vcpu;
 
 		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
@@ -1567,6 +1570,14 @@ static int init_hyp_mode(void)
 			goto out_err;
 		}
 
+		host_pmscr = per_cpu_ptr(&kvm_host_pmscr_el1, cpu);
+		err = create_hyp_mappings(host_pmscr, host_pmscr + 1, PAGE_HYP);
+
+		if (err) {
+			kvm_err("Cannot map host pmscr_el1: %d\n", err);
+			goto out_err;
+		}
+
 		running_vcpu = per_cpu_ptr(&kvm_hyp_running_vcpu, cpu);
 		err = create_hyp_mappings(running_vcpu, running_vcpu + 1, PAGE_HYP);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index a5fa40c060a8..4bf0eeb41a44 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -67,7 +67,7 @@ void __debug_switch_to_guest(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu)
 	host_dbg = host_vcpu->arch.debug_ptr;
 
 	/* Disable and flush SPE data generation */
-	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
+	__debug_save_spe(__hyp_this_cpu_ptr(kvm_host_pmscr_el1));
 	__debug_switch_to_guest_common(vcpu, host_dbg, host_ctxt);
 }
 
@@ -79,7 +79,7 @@ void __debug_switch_to_host(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu)
 	host_ctxt = &host_vcpu->arch.ctxt;
 	host_dbg = host_vcpu->arch.debug_ptr;
 
-	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+	__debug_restore_spe(__hyp_this_cpu_read(kvm_host_pmscr_el1));
 	__debug_switch_to_host_common(vcpu, host_dbg, host_ctxt);
 }
 
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
index 6225c6cdfbca..a564831726e7 100644
--- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -16,7 +16,7 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 
 	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	host_dbg = &vcpu->arch.host_debug_state.regs;
+	host_dbg = __hyp_this_cpu_ptr(kvm_host_debug_state);
 
 	__debug_switch_to_guest_common(vcpu, host_dbg, host_ctxt);
 }
@@ -27,7 +27,7 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 
 	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	host_dbg = &vcpu->arch.host_debug_state.regs;
+	host_dbg = __hyp_this_cpu_ptr(kvm_host_debug_state);
 
 	__debug_switch_to_host_common(vcpu, host_dbg, host_ctxt);
 }
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

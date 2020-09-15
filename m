Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA5FC433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B57B6206DB
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="SavMPg1l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B57B6206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 630854B36F;
	Tue, 15 Sep 2020 06:47:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sYHOp8mnvd9u; Tue, 15 Sep 2020 06:47:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EC5E4B315;
	Tue, 15 Sep 2020 06:47:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 187FE4B339
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ffYk7vHNA07F for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:06 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3CB84B374
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:06 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id 205so2547918qkd.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=BTPadyEaRoWtQqN63RjmUZB4GzF6ytAN73T0t7cjwAY=;
 b=SavMPg1lEwJb7lZRc4ds/VZ7QhBmfhPdzMcWmEeCekcuoCldENY/1vk2lhmZGBvoEs
 CsXgxpRfZWSG+enZNhpKQcQodluJT8rcl1qjwGom63sqdZYSwyxXg/cTUZg0CoXHrx2W
 QrQEqTlznimBWefQ3ClZNTNhIcCs1ZT+62eDd4GSbco0+GcGF8YFeXwbz8kpuOyFMxil
 rm4rtJuLVV7axypjSH7me/g6/0O6pybP0Q6kB4j1hOtg0a997ajknSJsOShAEAZASeAm
 Vuya6STBi/6MAGQmiwzxN8VxTO8QCYzv9QOYDIrXtQ0Y3NUOtyinfUbh89jp+QUTzbTJ
 Fx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BTPadyEaRoWtQqN63RjmUZB4GzF6ytAN73T0t7cjwAY=;
 b=pQFSidv8pJWlWI/Ua51Bp4VwVmzpvrR0drNYL5s5LKBpQYBN6SNbn6N0AaLrZBPWea
 b9mJERMgXXl45oMliTo7trqPLo2nDu+8jK8wAC++Ih3TG8ybMPp0G7vKR4qYiJ+MPxou
 V42/AR5kUmTf6FvDVD7HCulmxk1dlvnboCsr6ifv2w4//VM1XEogMi3Un0PwwcmFKlvm
 cTMMl84iislq842gUZha4mIopXfFokzN7pkPQ+X5+E3qgAn6cYari0+45DaIqI+aWlJ7
 naQooSdd5cSlrBN99OykHkJoTWsiYjrQS3Onz4TVFsPws3jESOSnXqXM0tneysko5uXj
 Emcg==
X-Gm-Message-State: AOAM531NoxuXM49/Rqmi5HOoJdzdbJAMNXTPNSMr9b0h8FoBHKUcRc4v
 HsW1cXGslMKEoahbmhe2hAkSE+pNs2pztNxeKip243oO38YhCoOkTaPWXMf8/ovtWUpEefGBRj+
 ErdOl5D6LngjfkwV0o2P9qMbI22v6xAYnJA/Xhm8lGUfqkew348eR7zwGhVShpcd8azK22A==
X-Google-Smtp-Source: ABdhPJybu0S8OHbpr/BzZDfzzFiPx/Qq3S5GEiXKb7K+1+x1gW4GDpEtzMXcxT7Xwzw6U8RGfpN6hkm1jP0=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:ad4:500c:: with SMTP id
 s12mr18154503qvo.7.1600166826082; 
 Tue, 15 Sep 2020 03:47:06 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:32 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-9-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 08/19] KVM: arm64: Introduce hyp context
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

During __guest_enter, save and restore from a new hyp context rather
than the host context. This is preparation for separation of the hyp and
host context in nVHE.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h        |  3 ++-
 arch/arm64/kernel/image-vars.h          |  1 +
 arch/arm64/kvm/arm.c                    | 10 ++++++++++
 arch/arm64/kvm/hyp/entry.S              | 10 +++++-----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 7 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 1e2491da324e..0b525e05e5bf 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -12,6 +12,7 @@
 #include <asm/alternative.h>
 #include <asm/sysreg.h>
 
+DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 #define read_sysreg_elx(r,nvh,vh)					\
@@ -89,7 +90,7 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
 void deactivate_traps_vhe_put(void);
 #endif
 
-u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
+u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 54bb0eb34b0f..9f419e4fc66b 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -71,6 +71,7 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
 KVM_NVHE_ALIAS(kvm_host_data);
+KVM_NVHE_ALIAS(kvm_hyp_ctxt);
 KVM_NVHE_ALIAS(kvm_hyp_vector);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b6442c6be5ad..ae4b34f91e94 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
+DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
@@ -1542,6 +1543,7 @@ static int init_hyp_mode(void)
 
 	for_each_possible_cpu(cpu) {
 		struct kvm_host_data *cpu_data;
+		struct kvm_cpu_context *hyp_ctxt;
 		unsigned long *vector;
 
 		cpu_data = per_cpu_ptr(&kvm_host_data, cpu);
@@ -1552,6 +1554,14 @@ static int init_hyp_mode(void)
 			goto out_err;
 		}
 
+		hyp_ctxt = per_cpu_ptr(&kvm_hyp_ctxt, cpu);
+		err = create_hyp_mappings(hyp_ctxt, hyp_ctxt + 1, PAGE_HYP);
+
+		if (err) {
+			kvm_err("Cannot map hyp context: %d\n", err);
+			goto out_err;
+		}
+
 		vector = per_cpu_ptr(&kvm_hyp_vector, cpu);
 		err = create_hyp_mappings(vector, vector + 1, PAGE_HYP);
 
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 76e7eaf4675e..9551d7f186da 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -57,15 +57,15 @@
 .endm
 
 /*
- * u64 __guest_enter(struct kvm_vcpu *vcpu,
- *		     struct kvm_cpu_context *host_ctxt);
+ * u64 __guest_enter(struct kvm_vcpu *vcpu);
  */
 SYM_FUNC_START(__guest_enter)
 	// x0: vcpu
-	// x1: host context
-	// x2-x17: clobbered by macros
+	// x1-x17: clobbered by macros
 	// x29: guest context
 
+	hyp_adr_this_cpu x1, kvm_hyp_ctxt, x2
+
 	// Store the host regs
 	save_callee_saved_regs x1
 
@@ -148,7 +148,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Store the guest's sp_el0
 	save_sp_el0	x1, x2
 
-	get_host_ctxt	x2, x3
+	hyp_adr_this_cpu x2, kvm_hyp_ctxt, x3
 
 	// Macro ptrauth_switch_to_guest format:
 	// 	ptrauth_switch_to_host(guest cxt, host cxt, tmp1, tmp2, tmp3)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 96ea3fdd0c20..afe714056b97 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -381,7 +381,7 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	    !esr_is_ptrauth_trap(kvm_vcpu_get_esr(vcpu)))
 		return false;
 
-	ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	ctxt = __hyp_this_cpu_ptr(kvm_hyp_ctxt);
 	__ptrauth_save_key(ctxt, APIA);
 	__ptrauth_save_key(ctxt, APIB);
 	__ptrauth_save_key(ctxt, APDA);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 075384084e08..c99945cda779 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -209,7 +209,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	do {
 		/* Jump in the fire! */
-		exit_code = __guest_enter(vcpu, host_ctxt);
+		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b49cf53c11f0..cf477f856e51 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -135,7 +135,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	do {
 		/* Jump in the fire! */
-		exit_code = __guest_enter(vcpu, host_ctxt);
+		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

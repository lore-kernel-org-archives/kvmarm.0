Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B62C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:24:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 573CD64ED6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 573CD64ED6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9A034B2B6;
	Fri, 19 Feb 2021 07:24:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M+jCBegnVPpS; Fri, 19 Feb 2021 07:24:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1134B2BD;
	Fri, 19 Feb 2021 07:24:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78C9E4B2B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:24:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xYBBrN7x1h+0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 07:24:16 -0500 (EST)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 837EF4B2B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:24:16 -0500 (EST)
Received: by mail-qv1-f73.google.com with SMTP id k14so3062111qvw.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 04:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=TjICHKCTzDMja+79MrvqOUORH0l2JlSOQGujchxQyOg=;
 b=BDIZEIY6PBgqVg46OiBrMTS4HJQKBIx1Ls1cJd0lementEI/2iSyngz/6BgwRMFqV9
 gM5ltwB3G8wzahl7UPdYwR8I8Sf/HlZGEuTh5BhtddSpdizMdXxjDIPS2yQhYJtdSs6k
 6kJg9t65jx3gp7XVlyMesIKRzmlGra8Swp86GhlTlYnF1vIs5DFgRYqbCcRPkRge6hCI
 MVSFanzJvGgmwz1XHaDFnEcqM2oulCwjdBCsAP2CynR2gY+qnsZiMT1s2FnZxATt98BU
 4mEfn+WA/MGb6C0gpAnwcKhbYEAyXQMKRLOD2lrxN6uFKSCmVAfZtHm67ZzhrhxhtYd3
 rG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=TjICHKCTzDMja+79MrvqOUORH0l2JlSOQGujchxQyOg=;
 b=iPhNvHAeTXaI2+e7hkZxJUPoj+FqDsZP/0bgjD5+KS2Not/ECe1FoDIvB24Xwkl4Zk
 vpBVwzOqWL4I9GLPyvOr+uPQ6U+fASwE3SxGWaJXnj13NRaffjSDr7Y3QYSBg2mjCJjA
 intpS3aVIP0ErSP5nD8lc5YW//MkwPe6rZNqUIg6iv1MEML9xXfNCO5MZZzTu2nbQLT3
 UDxOSwt+TA6yXbVEF9ob3e5PIt8svjGDYL+USBRFU9rSPFxPww5b+ftqQwfY2lw5RoUW
 wPAi5FOYI8qyzPEwCKFALiXZJvn02GGmBxX1rYDAbcmihA3xjtUE/BYJ33GRk1iRYBNR
 dfZQ==
X-Gm-Message-State: AOAM531HM6ImAnQog9/kc+Qr6rxacaAABgzelLk73RP4qGZwnc3gU50y
 4uXflN/fgSGWX+dkucTeNq2YBAyevXQeIyMFe3wU7LJGDW2D07W9LrI4ZF5Paiwfu9LXZDADFWy
 BsEZn0xHdI3BvMWypwV+J7F2/ROBJRuQGriXGKfF/7j6l+DhrIwEV0gXAhDJs8grjiGpexA==
X-Google-Smtp-Source: ABdhPJxy1ZItxvSvCDUTzSn+plxXi0SBKkh61Bwhunhl/oNzffkynYCfwV7O4oJx6skkxdrB6XrERXBOTHY=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a05:6214:186b:: with SMTP id
 eh11mr8627663qvb.1.1613737455903; Fri, 19 Feb 2021 04:24:15 -0800 (PST)
Date: Fri, 19 Feb 2021 12:24:06 +0000
Message-Id: <20210219122406.1337626-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH] KVM: arm64: Fix nVHE hyp panic host context restore
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
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

When panicking from the nVHE hyp and restoring the host context, x29 is
expected to hold a pointer to the host context. This wasn't being done
so fix it to make sure there's a valid pointer the host context being
used.

Rather than passing a boolean indicating whether or not the host context
should be restored, instead pass the pointer to the host context. NULL
is passed to indicate that no context should be restored.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/host.S   | 20 ++++++++++----------
 arch/arm64/kvm/hyp/nvhe/switch.c |  3 +--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index c0450828378b..fb8404fefd1f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,7 +97,8 @@ bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+			       u64 elr, u64 par);
 #endif
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index a820dfdc9c25..3dc5a9f3e575 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -71,10 +71,15 @@ SYM_FUNC_START(__host_enter)
 SYM_FUNC_END(__host_enter)
 
 /*
- * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+ * void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+ * 				  u64 elr, u64 par);
  */
 SYM_FUNC_START(__hyp_do_panic)
-	/* Load the format arguments into x1-7 */
+	mov	x29, x0
+
+	/* Load the format string into x0 and arguments into x1-7 */
+	ldr	x0, =__hyp_panic_string
+
 	mov	x6, x3
 	get_vcpu_ptr x7, x3
 
@@ -89,13 +94,8 @@ SYM_FUNC_START(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 
-	/*
-	 * Set the panic format string and enter the host, conditionally
-	 * restoring the host context.
-	 */
-	cmp	x0, xzr
-	ldr	x0, =__hyp_panic_string
-	b.eq	__host_enter_without_restoring
+	/* Enter the host, restoring the host context if it was provided. */
+	cbz	x29, __host_enter_without_restoring
 	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
 
@@ -150,7 +150,7 @@ SYM_FUNC_END(__hyp_do_panic)
 
 .macro invalid_host_el1_vect
 	.align 7
-	mov	x0, xzr		/* restore_host = false */
+	mov	x0, xzr		/* host_ctxt = NULL */
 	mrs	x1, spsr_el2
 	mrs	x2, elr_el2
 	mrs	x3, par_el1
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f3d0e9eca56c..038147b7674b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -257,7 +257,6 @@ void __noreturn hyp_panic(void)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
-	bool restore_host = true;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
@@ -271,7 +270,7 @@ void __noreturn hyp_panic(void)
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
-	__hyp_do_panic(restore_host, spsr, elr, par);
+	__hyp_do_panic(host_ctxt, spsr, elr, par);
 	unreachable();
 }
 
-- 
2.30.0.617.g56c4b15f3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

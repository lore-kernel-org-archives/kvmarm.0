Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB93C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 12:22:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11FCC64DCE
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 12:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11FCC64DCE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 880D64B57B;
	Mon, 15 Mar 2021 08:22:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dyZwERuoz57O; Mon, 15 Mar 2021 08:22:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6645C4B50D;
	Mon, 15 Mar 2021 08:22:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61A624B4FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 08:22:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Xh1sJ9fULwu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 08:22:15 -0400 (EDT)
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com
 [209.85.218.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24C3F4B501
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 08:22:15 -0400 (EDT)
Received: by mail-ej1-f74.google.com with SMTP id e13so11844962ejd.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=fRWjTowij/e3Q0sjNrdb6qA8tgM0QEsCeCOJzERGm7s=;
 b=VM6pgmCO6drvOMnmfsHHbMAwCCkLjWP5+72WdB76pNyrvLaA0vAktr0NQSsBKBY5AY
 S3E1gCjXvhjlUaz8CXR5CcITIKoUGItPD8arPEkn5ltUKOO8MnlXY2BH7tY8fp/HmjfH
 A+hWIpErM9/UdCcGZQpELEfMzniO5aDWLK9PFocZK/0SqD7A3TkiDRWYqDx0akT+TxTM
 fLT+0mFTO++tJU1WPvrUor0aDHbSDNZmSklpZDlcIpIgGZ9eN19DxK+ShurqofRZa3xE
 eKR4xy5x6YduyWdtg+L84yF7yQlqZvuIod4qU6TgEJl5JT43OfTWGN8c6eaQ3S1KxlOT
 SMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=fRWjTowij/e3Q0sjNrdb6qA8tgM0QEsCeCOJzERGm7s=;
 b=DpWVtGyOMxB8ni5qAVIW2kqWi1vopzsvE+fydCLpHV0xheXpTbaLDUuJDQcrmeBQwU
 JfEDv+lDl4PZC9UerwGh4PwWvx5WSOxHOk0OekrDvXFrrD14O1VQzzpn0ELPW15adgMj
 qkR1b64PCs2ygvH4agGmsmnTthBamvkty0FEEnfpIL3fjE5NevteleUrR7NjyR3y0Bm4
 VW70LAkB4cifMcfNPF9A5hU5VttItc0aezBzPgimxv/aHcfLPLnRq7zLRqNDicqWn9QL
 QcV1n74WXv6rZVj+IGey4UuOGK3aXRq6tNRMdvRicyiQmNgjUDh5yUKmjzpMXyGBg/Ws
 +7yw==
X-Gm-Message-State: AOAM530qWQqQQqQMEty6bxHVvw506ZeEu69PjOhlYc2CXUanGd9gSFNR
 onzCsvKYju8+wAONs0YCtk5Ogyh8sJXpD41pGH7RPIE8Zz77z9+XdqzJWRcOc0W45x3Q11FCziy
 QWk5XD4h9/HuQPbdNQieVAmboSWy7uvU2OiwAUTmSRZdtsjz3NyN9HapMUwG/kBi3N+IL/w==
X-Google-Smtp-Source: ABdhPJxO3avSctya0WAUjWrKQfStJ9JQYgruNzNVj9/RpYhwrDc4yuZequMkEqrAAiUxd2RjjO/9LOyODH0=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a17:907:7637:: with SMTP id
 jy23mr22426198ejc.12.1615810933760; Mon, 15 Mar 2021 05:22:13 -0700 (PDT)
Date: Mon, 15 Mar 2021 12:22:10 +0000
Message-Id: <20210315122210.1688894-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] KVM: arm64: Fix nVHE hyp panic host context restore
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com, stable@vger.kernel.org
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

Commit c4b000c3928d4f20acef79dccf3a65ae3795e0b0 upstream.

When panicking from the nVHE hyp and restoring the host context, x29 is
expected to hold a pointer to the host context. This wasn't being done
so fix it to make sure there's a valid pointer the host context being
used.

Rather than passing a boolean indicating whether or not the host context
should be restored, instead pass the pointer to the host context. NULL
is passed to indicate that no context should be restored.

Fixes: a2e102e20fd6 ("KVM: arm64: nVHE: Handle hyp panics")
Cc: stable@vger.kernel.org # 5.10.y only
Signed-off-by: Andrew Scull <ascull@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210219122406.1337626-1-ascull@google.com
---
 arch/arm64/include/asm/kvm_hyp.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/host.S   | 20 ++++++++++----------
 arch/arm64/kvm/hyp/nvhe/switch.c |  3 +--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 6b664de5ec1f..183bc9c7e1cb 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -94,7 +94,8 @@ u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+			       u64 elr, u64 par);
 #endif
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index ed27f06a31ba..4ce934fc1f72 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -64,10 +64,15 @@ __host_enter_without_restoring:
 SYM_FUNC_END(__host_exit)
 
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
 
@@ -82,13 +87,8 @@ SYM_FUNC_START(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 
-	/*
-	 * Set the panic format string and enter the host, conditionally
-	 * restoring the host context.
-	 */
-	cmp	x0, xzr
-	ldr	x0, =__hyp_panic_string
-	b.eq	__host_enter_without_restoring
+	/* Enter the host, conditionally restoring the host context. */
+	cbz	x29, __host_enter_without_restoring
 	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
 
@@ -144,7 +144,7 @@ SYM_FUNC_END(__hyp_do_panic)
 
 .macro invalid_host_el1_vect
 	.align 7
-	mov	x0, xzr		/* restore_host = false */
+	mov	x0, xzr		/* host_ctxt = NULL */
 	mrs	x1, spsr_el2
 	mrs	x2, elr_el2
 	mrs	x3, par_el1
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 8ae8160bc93a..1b16a3457e2b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -251,7 +251,6 @@ void __noreturn hyp_panic(void)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
-	bool restore_host = true;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
@@ -265,7 +264,7 @@ void __noreturn hyp_panic(void)
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
-	__hyp_do_panic(restore_host, spsr, elr, par);
+	__hyp_do_panic(host_ctxt, spsr, elr, par);
 	unreachable();
 }
 
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

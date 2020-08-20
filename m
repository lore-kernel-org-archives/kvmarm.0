Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E14AC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1443220738
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="bU6jB95W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1443220738
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C32534B846;
	Thu, 20 Aug 2020 06:35:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aRlEWdzAo559; Thu, 20 Aug 2020 06:35:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 915F74B845;
	Thu, 20 Aug 2020 06:35:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE88E4B845
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id skDZpX7i3Rbx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:43 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0726D4B83E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:43 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id u14so1722570wml.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=jml8hsX+WAS4ZVzEE/taO1Ose+FoMtNwJ1ulVnbmoEs=;
 b=bU6jB95WVd9ufaJhtdKEl0R/DZLfwMsnejZbXy4BBXaR4iizJvH7+uY5jcNH7I1/U1
 6xBLFU4+quc31skSnlUP5y5pzz8yUwdZm4LaRgnS4E9XSfPw/A7O0ceKzOE1A5HW1yJx
 Z6I2uNlWSzP0auzClq/IC6KA8cJYi9CvRq4bU4q8KcVC9WH+A10Vw+icMwo4JqcpWA7F
 PP92QfHGNzg3Jn51F1XQrIyimz7Aci43z/MnzarzXMstSUieBd6xkd4ZyVmdc6lSm2YN
 rdkQ//YDSl0NFUeZ1vp8CMNPtKhII+I50Eer8pIqVNVNPzT7jgDCft3BQWQeKN/8fbfl
 AgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jml8hsX+WAS4ZVzEE/taO1Ose+FoMtNwJ1ulVnbmoEs=;
 b=Q5Aj2rf2E2mqs9mSH2jGPtF2mz9k0UpfvK6W+hc8eCXXRTH7Mmhgnp9f3yNH47nXoc
 Xad+zRXanUxQAliSk3rdv9GYavdE+ZtK6z06gU8rwe8o49t7VJAnFPcpPbLpqbsth0Pa
 dHdjPnbWnn4FMdGscDBAe66WimBntNEsrEfeNIMpLBMdwjrRGQ/zi0p5XM/K98lGAUAF
 iCkknH8TU0TZB+h9JUXDE34r6HMT+mO3HkYtdtAbvMoB8eUJO9EiVt4pb58gWGFvnq7O
 CqvHHodtDupjtXRVb1pry03ctYKcNyIMdJUmeTlyoJ4vqw6KdC8+djefbK3HNMtfYKdR
 vxjQ==
X-Gm-Message-State: AOAM531K4l5xWkpKpYn5UhyvkPtaDZ8gbV2otkuIGZ4ESHLB56RaSIDZ
 a7cQd+JQRmxWuAv9BsWyGbaMwMboSpZDj99hSd1lrSTTqZQosgLhSnMh8qs3uLSAqZj/n15xeyE
 M+mDoP5oibz2Gv+Eswy9DsODA4h+CvGuSFooUHpN3Ewk7pTy0rCI5jTEWPMB2ERkMDwwHKQ==
X-Google-Smtp-Source: ABdhPJywriXDQqNyDlGtOFrbdcFJQNr3aF/n9CjNI9lPE/hc3BBx21/d0hoQdW7YmLc8dcvs+En9d6dypC8=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a5d:414e:: with SMTP id
 c14mr2755336wrq.57.1597919742155; 
 Thu, 20 Aug 2020 03:35:42 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:36 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-11-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 10/20] KVM: arm64: Update context references from host to
 hyp
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

Hyp now has its own nominal context for saving and restoring its state
when switching to and from a guest. Update the related comments and
utilities to match the new name.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_ptrauth.h |  6 +++---
 arch/arm64/kvm/hyp/entry.S           | 22 +++++++++++-----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index 0ddf98c3ba9f..0cd0965255d2 100644
--- a/arch/arm64/include/asm/kvm_ptrauth.h
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -60,7 +60,7 @@
 .endm
 
 /*
- * Both ptrauth_switch_to_guest and ptrauth_switch_to_host macros will
+ * Both ptrauth_switch_to_guest and ptrauth_switch_to_hyp macros will
  * check for the presence ARM64_HAS_ADDRESS_AUTH, which is defined as
  * (ARM64_HAS_ADDRESS_AUTH_ARCH || ARM64_HAS_ADDRESS_AUTH_IMP_DEF) and
  * then proceed ahead with the save/restore of Pointer Authentication
@@ -78,7 +78,7 @@ alternative_else_nop_endif
 .L__skip_switch\@:
 .endm
 
-.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
+.macro ptrauth_switch_to_hyp g_ctxt, h_ctxt, reg1, reg2, reg3
 alternative_if_not ARM64_HAS_ADDRESS_AUTH
 	b	.L__skip_switch\@
 alternative_else_nop_endif
@@ -96,7 +96,7 @@ alternative_else_nop_endif
 #else /* !CONFIG_ARM64_PTR_AUTH */
 .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
 .endm
-.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
+.macro ptrauth_switch_to_hyp g_ctxt, h_ctxt, reg1, reg2, reg3
 .endm
 #endif /* CONFIG_ARM64_PTR_AUTH */
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index dbf746478f7e..e95cd7f2ff86 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -66,16 +66,16 @@ SYM_FUNC_START(__guest_enter)
 
 	hyp_adr_this_cpu x1, kvm_hyp_ctxt, x2
 
-	// Store the host regs
+	// Store the hyp regs
 	save_callee_saved_regs x1
 
-	// Save the host's sp_el0
+	// Save hyp's sp_el0
 	save_sp_el0	x1, x2
 
-	// Now the host state is stored if we have a pending RAS SError it must
-	// affect the host. If any asynchronous exception is pending we defer
-	// the guest entry. The DSB isn't necessary before v8.2 as any SError
-	// would be fatal.
+	// Now the hyp state is stored if we have a pending RAS SError it must
+	// affect the host or hyp. If any asynchronous exception is pending we
+	// defer the guest entry. The DSB isn't necessary before v8.2 as any
+	// SError would be fatal.
 alternative_if ARM64_HAS_RAS_EXTN
 	dsb	nshst
 	isb
@@ -150,17 +150,17 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 
 	hyp_adr_this_cpu x2, kvm_hyp_ctxt, x3
 
-	// Macro ptrauth_switch_to_guest format:
-	// 	ptrauth_switch_to_host(guest cxt, host cxt, tmp1, tmp2, tmp3)
+	// Macro ptrauth_switch_to_hyp format:
+	// 	ptrauth_switch_to_hyp(guest cxt, host cxt, tmp1, tmp2, tmp3)
 	// The below macro to save/restore keys is not implemented in C code
 	// as it may cause Pointer Authentication key signing mismatch errors
 	// when this feature is enabled for kernel code.
-	ptrauth_switch_to_host x1, x2, x3, x4, x5
+	ptrauth_switch_to_hyp x1, x2, x3, x4, x5
 
-	// Restore the hosts's sp_el0
+	// Restore hyp's sp_el0
 	restore_sp_el0 x2, x3
 
-	// Now restore the host regs
+	// Now restore the hyp regs
 	restore_callee_saved_regs x2
 
 alternative_if ARM64_HAS_RAS_EXTN
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

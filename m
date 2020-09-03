Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB07AC433E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D436208C7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="FNiIX8ep"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D436208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 150C94B14C;
	Thu,  3 Sep 2020 09:53:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 07gHerVORl2a; Thu,  3 Sep 2020 09:53:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3D54B2AF;
	Thu,  3 Sep 2020 09:53:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 278D64B249
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zV2Puz2MTMdY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:32 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3882A4B29C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:32 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id c191so1614217qkb.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=qZBRVfU6iX7fkoXY+sodztWCZRih+Eyz+gMad5gZKiA=;
 b=FNiIX8epcUohcCBrqijsET3cxa44U5bioQfgIelN16/1PoTUqLdege8Qi2o2Ak4PUO
 OrHvUhjR+MbN9e64HlyAqaEf5V2DU7Y2bmydemv3/Wifbqjvqh489UJ0V4qscJOmlMnC
 ik9/mur4LcKQKgOb+uUUv0d0VQOWveSSAyVS3d5cXOwi99Gnbi3Qc9nSzH25vW2vkeep
 ctPfl4TMG/QUlYk3/HJ0aQ6z+v7vMckTkirs/p71DRfD3/Fawm9iKARA2UXHz1qtUVNW
 eY9cobCczHbpnpCB99oomcubCHfiCTdk5TyoIBEizmBy9+V5e4umMzWer53CYf66r+0I
 0oIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qZBRVfU6iX7fkoXY+sodztWCZRih+Eyz+gMad5gZKiA=;
 b=EHK8yMdUrTK0JLBFx1mTsps/s6r/AZkuc2WM/+P1C7mhuT7dqvJwcO58fV5o4H3t/H
 HWfsJTdBx8eAxT0mNxzKV6ElSVwYlkFvQzrcfz9d2zqO8IPdOTUoWvHVb6um63KVtUJq
 e7or7BJscc3dbB/OHjjaFiNrJT3n4t0fc4TzteBmOyGnAbkYVSc8/wzpLJ+a4iJZYTT8
 itwZrPPVqojTgcp6SF3Xh/uHZKky9bnOisPVLyqXrWfxp5lrRsTy+CqqhNie86Qz8qEK
 Wgi+M4O8AqS0wc5HCXXzV7QCiPW4qQSOcb+Iqq3h1ph4XLdJ6AX0r+NQaLQscaykaIsf
 bKPg==
X-Gm-Message-State: AOAM530XPtVy7KkOtezRrWQK6k0dScXy7/jowVzA0yqmfDxjTsldfGTe
 2QIANaEdo/72c2kJUwdolZ2C5f9aUOhFqbiaAiY5gf0i+pTwzvUEtJie2sTCXn49pPMOFTnPeaW
 +6QzYytoAxNvhVcFelV4MfQ85jCMPAmrbKTRIuJ6RY/Q8FL8tCuHi9+w2cPLOHb8Cs1jU2w==
X-Google-Smtp-Source: ABdhPJxsv/JPhi9l1/1IiNuzUtde3ZxiySOnh+0KXyQcE6FQcTnSVifQAN5eY7O7SHwIene2aEdfZF2LtCg=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a05:6214:178c:: with SMTP id
 ct12mr2049268qvb.12.1599141211721; Thu, 03 Sep 2020 06:53:31 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:52:58 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-10-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 09/18] KVM: arm64: Update context references from host to
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
index 9551d7f186da..38cca690a6ff 100644
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
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

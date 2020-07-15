Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B30C433E7
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73017207BB
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="p+yXxuws"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73017207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D77D4B3C0;
	Wed, 15 Jul 2020 14:45:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rqk5fg-jOehJ; Wed, 15 Jul 2020 14:45:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CD214B1B2;
	Wed, 15 Jul 2020 14:45:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D113C4B1B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vrTz3tI+sJb9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:04 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE79F4B238
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:04 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id y18so1972478wrq.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Hh2RRb42S2dUmaJw/vbwjp8tmEOHETBZIsbvLkCng+U=;
 b=p+yXxuws66lRva6RlAM2yVfXS4tjOANWilnVuaVKIV7F/Lx/ztmKgVSyUqYe41bFot
 vSQGkYIX4OOUDYPzlLdm4x7gXpAVn9lUL0bM8nDfKLn4ZjiWO3H2NbW/61n1biB4Z0ul
 ku4kRXsuJhTVIh0NbXZaQR0wAgLgFsW8u2KslaIOQcX91Mcb6BgEwsjiLOWHoeIqbz9t
 L3rSsY03Bi5ISVefpKqGYDFaaonTEekCKrFE8LM928dKbvVldcBhl3FvuKZ8WDiqQzW/
 P5VVrDkgNTM/tO03uuyWFhz0SWSMDe2Ctsi+JuOWhS+4mZIVl58dCapWLGERCatBhWUg
 2u/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Hh2RRb42S2dUmaJw/vbwjp8tmEOHETBZIsbvLkCng+U=;
 b=pifebWibm1yQ3n+RPlZeObBkHhtGjgVSh/PYVzxGJAm2qFxKunUeIcPTqRD8Xu0FFm
 ogNRu5ZVI8G4RtZf1VWTaV8qeqADX9qpF5/EEezWsPwIY/2oG7tlwv0Mtk9HGESTO5+s
 LdXNt4/jo4MovNp9m9jSnPxMX7Fjmd8QW1kMsOCJVLctdxith5OOaVMmAD8BX4OOdmZ8
 6hUxtLNM9yFggRO2dxgpS77lO44vr7/Pu8mrqXcZKjy+/7NWETWcn0tc2XjGmatcUvIm
 SdZ8rsveP/V+C24s/D3i+N0kKYdYr9G89yu3ODrhZf2mlG9XUSuFLx9hnC4uteFzDSC3
 d1Jg==
X-Gm-Message-State: AOAM530d0y78PRqWXWoqs55NHuIz+VReaaio71A/FLIF2S2Oq+Af+quk
 mddML9ozIs7t4lAaHiwZKtsOaR2vyV67IaRDcRSADN58VN3cW7cNkw53Wq4D39iRp8b9pxxb6Sd
 1m9V6RPmM8NDbZd2tcab6OJLBJEmmahOqXGBLFdR77AuvjTSv9nol+S3JoGnttc0/nKRhUw==
X-Google-Smtp-Source: ABdhPJw2OK05UUNzk8pgceTLVoeBj8zYlRMAw5cnZbRoQzOaqXr3xr/j00Xk/tHm44oy85YBZfEx8+Fo0rY=
X-Received: by 2002:a1c:964d:: with SMTP id y74mr798630wmd.80.1594838703902;
 Wed, 15 Jul 2020 11:45:03 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:08 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-8-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 07/37] KVM: arm64: Separate SError detection from VAXorcism
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

When exiting a guest, just check whether there is an SError pending and
set the bit in the exit code. The fixup then initiates the ceremony
should it be required.

The separation allows for easier choices to be made as to whether the
demonic consultation should proceed.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h        |  2 ++
 arch/arm64/kvm/hyp/entry.S              | 27 +++++++++++++++++--------
 arch/arm64/kvm/hyp/hyp-entry.S          |  1 -
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++++
 4 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 07745d9c49fc..50a774812761 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -91,6 +91,8 @@ void deactivate_traps_vhe_put(void);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 
+void __vaxorcize_serror(void);
+
 void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(unsigned long, ...);
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 6a641fcff4f7..dc4e3e7e7407 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -174,18 +174,31 @@ alternative_if ARM64_HAS_RAS_EXTN
 	mrs_s	x2, SYS_DISR_EL1
 	str	x2, [x1, #(VCPU_FAULT_DISR - VCPU_CONTEXT)]
 	cbz	x2, 1f
-	msr_s	SYS_DISR_EL1, xzr
 	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
-1:	ret
+	nop
+1:
 alternative_else
 	dsb	sy		// Synchronize against in-flight ld/st
 	isb			// Prevent an early read of side-effect free ISR
 	mrs	x2, isr_el1
-	tbnz	x2, #8, 2f	// ISR_EL1.A
-	ret
-	nop
+	tbz	x2, #8, 2f	// ISR_EL1.A
+	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
 2:
 alternative_endif
+
+	ret
+SYM_FUNC_END(__guest_enter)
+
+/*
+ * void __vaxorcize_serror(void);
+ */
+SYM_FUNC_START(__vaxorcize_serror)
+
+alternative_if ARM64_HAS_RAS_EXTN
+	msr_s	SYS_DISR_EL1, xzr
+	ret
+alternative_else_nop_endif
+
 	// We know we have a pending asynchronous abort, now is the
 	// time to flush it out. From your VAXorcist book, page 666:
 	// "Threaten me not, oh Evil one!  For I speak with
@@ -193,7 +206,6 @@ alternative_endif
 	mrs	x2, elr_el2
 	mrs	x3, esr_el2
 	mrs	x4, spsr_el2
-	mov	x5, x0
 
 	msr	daifclr, #4	// Unmask aborts
 
@@ -217,6 +229,5 @@ abort_guest_exit_end:
 	msr	elr_el2, x2
 	msr	esr_el2, x3
 	msr	spsr_el2, x4
-	orr	x0, x0, x5
 1:	ret
-SYM_FUNC_END(__guest_enter)
+SYM_FUNC_END(__vaxorcize_serror)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index e727bee8e110..c441aabb8ab0 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -177,7 +177,6 @@ el2_error:
 	adr	x1, abort_guest_exit_end
 	ccmp	x0, x1, #4, ne
 	b.ne	__hyp_panic
-	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
 	sb
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0511af14dc81..14a774d1a35a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -405,6 +405,10 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	/* Flush guest SErrors. */
+	if (ARM_SERROR_PENDING(*exit_code))
+		__vaxorcize_serror();
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

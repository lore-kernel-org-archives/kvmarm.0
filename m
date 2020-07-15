Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F08DC433E7
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FF4420787
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="boYRFIUL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FF4420787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD4A54B1B2;
	Wed, 15 Jul 2020 14:45:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LqyZIplYs0ZJ; Wed, 15 Jul 2020 14:45:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5823A4B3DC;
	Wed, 15 Jul 2020 14:45:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25C2A4B3D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nbPUo8EcFYjg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:41 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 156374B3C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:41 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id s134so1560472wme.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Y54p5wOLVjkqV9LQOmEOwl9Orb3HRxUOEFIdX/9yWSs=;
 b=boYRFIULe/j64FkXQMikU8XA2e/fVAyLe+OGGX9CMYmX9lf0esahK57YzTmehmIcUj
 ypRD1GATfFWTYtNFnbHjoy7NixHCZQwA0DyQWg5bZQAmSXbGouTubt+wOJloHqt8D6wy
 ejEHG6yAZtlSXlp632YL99Noah3elCejozLkDSt8a1bKeIrtf+hNlJmkcCOz2Tonyxdi
 eG0ZRiwPzuphWt9v0Z7ZXyD5eyZZHn2jjLHPGWGR34VCE63KBERlbasQNjy73KmnCg/0
 Sf2cV9L1aLaoLQkl7h6SMRuIOTPbaxYxV+ReLQT7jPiYrbLY/VhvhX600GyuGYxzo7XX
 ZdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Y54p5wOLVjkqV9LQOmEOwl9Orb3HRxUOEFIdX/9yWSs=;
 b=YPqNcNM/bNK7uvefgtqrdZLtW3t0ZdOjilqzhvnKkCgAXe+ZObxszo/o7kPtQuFqNG
 04Lh6mQm6Iqd6O1uP+Qrb6vIHmwXicnYGXN5YOE2NGemDtYNYQ8mBp/J9iHg6nTnFWXD
 Sl3rj+jpQRDWxtfH7CI9XnggbQ30/gzoSkvmrqeenYVzIRJjz63+MPeNAcKyZsmyJUp0
 PAubDHFZ4ThBLzOewIWOlyzzJq9hv/fqOXOT6bh0XmQ/X8G0E+2naSzi2krBhmTr+v2R
 Eu7lKsz81pSAjSd4UwixikY/a9eXidc/B2nii58jIsUX5YpOZpdJoT8P2QQSFc0ZPEOp
 XK3Q==
X-Gm-Message-State: AOAM530rWrHh0llBT8eaCkXeAJ+8lLlAPedwr4aLN/5pszOHAPB6+9Qe
 X5lwwY2yIeavHi+oy7dDB/imPz4yUvfJiA+3PBPWhRSjt4hN3oPdEVIFOE2RngRMLNb5UxHnESA
 6yMBiWaBjIvOF0qr3eQ+yVO9UYoUCaTauEQPMd4a9dVhAAoQo5jAAdB2ndC5Qrrfobx4Kjw==
X-Google-Smtp-Source: ABdhPJx8RzdHZ3EA/N51JCfHTpWo5jRWx98sv6Z8CnauzddIv7L9ziQixtiQN/BBb/qoDJBdrvkhdIo1vVA=
X-Received: by 2002:a1c:cc09:: with SMTP id h9mr1314897wmb.1.1594838739712;
 Wed, 15 Jul 2020 11:45:39 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:24 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-24-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 23/37] KVM: arm64: Skip __hyp_panic and go direct to hyp_panic
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

The VHE and nVHE variants of hyp_panic no longer share the same
arguments so __hyp_panic no longer serves a useful purpose. hyp_panic
can get all the context it needs from percpu variables.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  2 +-
 arch/arm64/kvm/hyp/hyp-entry.S   | 11 +++--------
 arch/arm64/kvm/hyp/nvhe/switch.c |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c  |  3 ++-
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 75016c92d70b..32b438c1da4e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -104,7 +104,7 @@ u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 
 void __vaxorcize_serror(void);
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt);
+void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(unsigned long, ...);
 #endif
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 3113665ce912..2748e3d3ef85 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -95,7 +95,7 @@ el2_sync:
 
 	/* if this was something else, then panic! */
 	tst	x0, #PSR_IL_BIT
-	b.eq	__hyp_panic
+	b.eq	hyp_panic
 
 	/* Let's attempt a recovery from the illegal exception return */
 	hyp_ldr_this_cpu x1, kvm_hyp_running_vcpu, x0
@@ -123,7 +123,7 @@ el2_error:
 	cmp	x0, x1
 	adr	x1, abort_guest_exit_end
 	ccmp	x0, x1, #4, ne
-	b.ne	__hyp_panic
+	b.ne	hyp_panic
 	eret
 	sb
 
@@ -139,12 +139,7 @@ SYM_FUNC_START(__hyp_do_panic)
 SYM_FUNC_END(__hyp_do_panic)
 #endif
 
-SYM_CODE_START(__hyp_panic)
-	get_host_ctxt x0, x1
-	b	hyp_panic
-SYM_CODE_END(__hyp_panic)
-
-.macro invalid_vector	label, target = __hyp_panic
+.macro invalid_vector	label, target = hyp_panic
 	.align	2
 SYM_CODE_START(\label)
 	b \target
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 88e7946a35d5..e49967c915de 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -265,7 +265,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
+void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d871e79fceaf..5c2eaf889cf5 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -207,8 +207,9 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par,
 }
 NOKPROBE_SYMBOL(__hyp_call_panic);
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
+void __noreturn hyp_panic(void)
 {
+	struct kvm_cpu_context *host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

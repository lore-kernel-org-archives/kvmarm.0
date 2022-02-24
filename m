Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850EFC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 10:36:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B06C4C011;
	Thu, 24 Feb 2022 05:36:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nqxcdrz9FLRD; Thu, 24 Feb 2022 05:36:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6B24C05D;
	Thu, 24 Feb 2022 05:36:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 242DF4BC5A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:21:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7I63tPPcxbxy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 00:21:20 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E50874BC4F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:21:20 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2d7eaa730d9so11601397b3.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 21:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=v7H+YHEXea4IIqGySI7aLREzIvLtpBuCKjmvH1cIeXQ=;
 b=NulZA7w/XH6Ovox3Z8EPA5m/C/4Cu5qNglcuNmoAQGiwk4ZsQUEDaqrrza3kj0/rO1
 4AIBYeKLpSv0/Y0kyPuD0iIaYP+rfQjHEEPqR6hATVEXSiEGw1puhIgCf0xl4KrRv9Ze
 bf3X6bGXRtPd3AVhIvpnfTipQKZ7kaRoy2V22FK420mGJNxu4NBXNZkGrPE31FXO18uL
 p5giufi9NXloDjTBFhB+FZiUOIrIvZ5VdVoH+krscvWKPlnWpw3VycB1f6vXmcZ/3Bcy
 kQgU10gE8FIBPttAIaRsih5zbrOFWZVcM3EhGsNnh5UyKz3q6san4735fgWDpsuyGnfD
 vTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=v7H+YHEXea4IIqGySI7aLREzIvLtpBuCKjmvH1cIeXQ=;
 b=kNLfgZFbFDCrS0et+MllzhOIo2XVwbwOtoGurnAIAVFnUFeCGiGR7oUrtOzOHGC3IU
 xu0rEaEK7BnDRdXBTArHKTHNaCS9leNRGvi4eYJI8xCwk/lJ2qi/dfFX22OM/qPGM8pv
 hK1ijNJIEUNZT9cRnrOFs2BOzhNSbmgzuHQt6Pn0omojL636Nf8ir1RZg8rgjCvbRh1c
 /voQON3Wj3CgsTGWFS6Ou26UlMJifeAKI2bQ7eN3wDuE+XptVD5/uOxrqFLXBxJ3McO3
 /vfCi+wYSr2RJ1bt7ASb9fpCURkEJwM5uyhkYvqBFU1d0EdgekkLZwA3R/0ND3Ll1bMm
 wh4A==
X-Gm-Message-State: AOAM531dJJfwsBe15vSgT3+FyIFSkcI3q+fXorYDoqt797zQMaPSPgP5
 V1gNCiQwER651GmmpxiRFKWTaqTem17b1g3Zlg==
X-Google-Smtp-Source: ABdhPJyGTlGm+C/X/WYwJEpFuocVcINp/xR0sgVssDAtD0IXfiwn+elCX3UtU0cHn8Y6Lskq6uXxQyXVu8faJREUXQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:415c:9be0:c461:440a])
 (user=kaleshsingh job=sendgmr) by 2002:a25:9108:0:b0:61e:329:700 with SMTP id
 v8-20020a259108000000b0061e03290700mr976530ybl.369.1645680080321; Wed, 23 Feb
 2022 21:21:20 -0800 (PST)
Date: Wed, 23 Feb 2022 21:13:41 -0800
In-Reply-To: <20220224051439.640768-1-kaleshsingh@google.com>
Message-Id: <20220224051439.640768-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 6/8] KVM: arm64: Add hypervisor overflow stack
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Thu, 24 Feb 2022 05:36:21 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 Andrew Walbran <qwandor@google.com>, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

Allocate and switch to 16-byte aligned secondary stack on overflow. This
provides us stack space to better handle overflows; and is used in
a subsequent patch to dump the hypervisor stacktrace. The overflow stack
is only allocated if CONFIG_NVHE_EL2_DEBUG is enabled, as hypervisor
stacktraces is a debug feature dependent on CONFIG_NVHE_EL2_DEBUG.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S   | 5 +++++
 arch/arm64/kvm/hyp/nvhe/switch.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 749961bfa5ba..367a01e8abed 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -179,6 +179,10 @@ SYM_FUNC_END(__host_hvc)
 	b	hyp_panic
 
 .L__hyp_sp_overflow\@:
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	/* Switch to the overflow stack */
+	adr_this_cpu sp, hyp_overflow_stack + PAGE_SIZE, x0
+#else
 	/*
 	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
 	 * This corrupts the stack but is ok, since we won't be attempting
@@ -186,6 +190,7 @@ SYM_FUNC_END(__host_hvc)
 	 */
 	ldr_this_cpu	x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
 	mov	sp, x0
+#endif
 
 	bl	hyp_panic_bad_stack
 	ASM_BUG()
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 703a5d3f611b..efc20273a352 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -34,6 +34,11 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], hyp_overflow_stack)
+	__aligned(16);
+#endif
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

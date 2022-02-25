Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB9EC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 15:00:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 353D14B9E0;
	Fri, 25 Feb 2022 10:00:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B0HnT09sRhTS; Fri, 25 Feb 2022 10:00:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85B034BA2C;
	Fri, 25 Feb 2022 09:59:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EE1C4BBDB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:45:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4oZeCEFG+fG9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 22:45:01 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A7024BBD0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:45:01 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d07ae11460so19802997b3.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 19:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=53jTUHXN8pXhAmdBLdFZ3XwM5fVPq5Z9CpfRPZqZFCI=;
 b=Vuz84OwZMocSA83nvo8NZ4zxH6ccvGrHdYvieAWCrHxxrge7jQQG/OH1a8uFFGG4t0
 GAfASHstE4xtShS2AA7B5kso/iNl7ro+9oirqf1U0bSq+Uzf5hhssvO0GkISWMyybAeX
 7BvdyvbW02JKYDtiLwjM1HUgVDPHahEXe8LP8aQT3bDAE30D49aHNFHS+Gf9kmKHlfkT
 cdfOYW9WnT4/rtSTYaWkBZCFYQwYShrnDme/ddg8d8qh2GtFqPx74zGTMQnR1xpBFtEF
 Ladj1Ae/voJEATBIZ4vuWd/MgNnf6zMvOfwtSkER77HyC18caRCbFRIBen0IE3m2Ez3z
 pDTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=53jTUHXN8pXhAmdBLdFZ3XwM5fVPq5Z9CpfRPZqZFCI=;
 b=4FXFUk5eCDJUfcPY8qASkVRJ/KgxBm5gku50XCj6/xpOjn4usepKPGDW2mI7GUGIRZ
 cgmv9d+rS1E4mHBWeM2SrwubNsEkfdBxQBT8PIKFqHR7cgXvV8HXwQi4CjfAI/gFIT2L
 nlo74b8yOOAn3FYP8be3YyvC5CT5A3IndfANEGHFa4dF9RuQ31zG6VvW8zzyL33682do
 x+CGuoCxKi+fc5mtLqphXIGW93tzh5rgpm6scw7HiCFz3gv7X2N59zjFPNdYd8oSIoLO
 ahkwttNQzfWd3SFfeYpZlXdi8bZwp+7d/hMVzWTcgOfVDX/f/XGO8UBYgk109KoCsZLV
 3eLQ==
X-Gm-Message-State: AOAM531FCNDBXMW/fBRhrG2kvf+bkK5s5+HR1DMwp+BSzJaeDiNCRkTb
 9yKkxcrHdegFM3OLGQucA/eZf5IAEX1zgdj1Kw==
X-Google-Smtp-Source: ABdhPJx4OPw80y5Vq18KcxUsCYgPq2jDdE5mSLmC2vx51PsGs+75ealL5rRfaLmZWL1VA67CEKvpatgngkV2u3nJHg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:3a50:90b2:e6a2:9060])
 (user=kaleshsingh job=sendgmr) by 2002:a0d:ee45:0:b0:2d6:ec15:4f89 with SMTP
 id x66-20020a0dee45000000b002d6ec154f89mr5460513ywe.372.1645760700677; Thu,
 24 Feb 2022 19:45:00 -0800 (PST)
Date: Thu, 24 Feb 2022 19:34:51 -0800
In-Reply-To: <20220225033548.1912117-1-kaleshsingh@google.com>
Message-Id: <20220225033548.1912117-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220225033548.1912117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 6/8] KVM: arm64: Add hypervisor overflow stack
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Kalesh Singh <kaleshsingh@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 surenb@google.com, kvmarm@lists.cs.columbia.edu
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

Changes in v4:
  - Update comment to clarify resetting the SP to the top of the stack
    only happens if CONFIG_NVHE_EL2_DEBUG is disabled, per Fuad

 arch/arm64/kvm/hyp/nvhe/host.S   | 11 ++++++++---
 arch/arm64/kvm/hyp/nvhe/switch.c |  5 +++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 749961bfa5ba..2c04f3e6b3f0 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -179,13 +179,18 @@ SYM_FUNC_END(__host_hvc)
 	b	hyp_panic
 
 .L__hyp_sp_overflow\@:
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	/* Switch to the overflow stack */
+	adr_this_cpu sp, hyp_overflow_stack + PAGE_SIZE, x0
+#else
 	/*
-	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
-	 * This corrupts the stack but is ok, since we won't be attempting
-	 * any unwinding here.
+	 * If !CONFIG_NVHE_EL2_DEBUG, reset SP to the top of the stack, to
+	 * allow handling the hyp_panic. This corrupts the stack but is ok,
+	 * since we won't be attempting any unwinding here.
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
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

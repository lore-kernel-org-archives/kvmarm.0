Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB65C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2518964F34
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2518964F34
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F084B2EC;
	Thu,  4 Mar 2021 06:55:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BXv96JekINN0; Thu,  4 Mar 2021 06:55:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B011E4B63D;
	Thu,  4 Mar 2021 06:55:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 950944B354
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SWjTSneUDBRK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:24 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 840B64B63A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:23 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id g5so14235011wrd.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=fiUsra0qfWwzHWD/P+9oKhTxHeDGjv2nXIVpia0RzhA=;
 b=CxyXlGcHsbzwLNRmXxaXbkA29fbxrm1hBXSDkfOrQY3uhgmA+vlOgV1h2PKpTRYQvx
 +xbb2Ir1FzpKRK5t77zP2+4goNT3T7ZzgIxby2kaQZPWlK8V8EtFG4QKXX8dMjfZ+Bxd
 L1pWxtS2+NhkgTk8UIf17c8z+gzGwzq2iBrP+6YYhr7G6ia1KCwXUqnl9mTrXJWQY+IN
 OqHMvCH5O7o1ROf+YHy6qGPWDIGAxYKJGTNhGn+L9nEps3yMHgSy9w+OZDK3y3VeBoxs
 b1Zx56MINiF/LwXejnRVpk6zO8D5omrxWKQQZCucUoSmrQn0OTx0vcL+N9f+qQrs9tAx
 Oy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fiUsra0qfWwzHWD/P+9oKhTxHeDGjv2nXIVpia0RzhA=;
 b=YrjwHPwATLKfzfems8TzYApv9ybr/5ttY8jeiSSlE+EoQMranBJ5fgLo/Vs40vVwEi
 e2lDOlKuDtAytNeyIH0Tm0bM10s+pOJGmNnG+5CuWo4ryRQx3j646DFjJ3tGr6hjSmsN
 hJJh5YsdtSUKtCZxatMSP68qQ9RRV1j3BA7XwU2PCozWmes6FiiIcO4G5U+y8tmkYi9S
 hLHbUJ+haKO404TNrpyrUf86zlyI3osLt8lfbgHNzmTqbqLEsmYTwA5SYrMKdB/oLFvY
 jcBVPC06mcfwBwIxF5LNwhPMoZjpLLFlDVUygb6FzcwDDnukppYNBKMFwOgZcp1oIjc6
 6/2A==
X-Gm-Message-State: AOAM532qoLpAkpxrTuhX/BvvSofq0x166szKBeHlEf+1pIc5vcS+QRF3
 +9Gt13u4YAUuKN2HP4IdZ/KIaa3bGFZUJORf5gpVnWPyHtj98+oo2lH/XOftkl7yvdfEbqC0bhP
 M6Pviewk0MZAsK9YVasV+X6TaMAZPb+nI9iTEeHefqr/3wmk0b9oejP+TwVAQy9QaxiYL5A==
X-Google-Smtp-Source: ABdhPJyLEFU2BTIVFxtjfM2JLSTKRQs6vbrwdIW/QjRVjmKG5SR04m51Bj1Qahwr/GjOuRb9w/6IGWK4JCI=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a1c:b6d7:: with SMTP id
 g206mr3581442wmf.123.1614858922702; 
 Thu, 04 Mar 2021 03:55:22 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:48 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-6-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 05/10] KVM: arm64: Track where vcpu FP state was last loaded
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Dave.Martin@arm.com
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

Keep track of the cpu that a vcpu's FP state was last loaded onto. This
information is needed in order to tell whether a vcpu's latest FP state
is already loaded on a cpu to avoid unnecessary reloading.

The method follows the pattern used by thread_struct whereby an
fpsimd_cpu field is added and updated when the state is loaded.

Signed-off-by: Andrew Scull <ascull@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/kvm_host.h       | 1 +
 arch/arm64/kvm/arm.c                    | 2 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8a559fa2f237..a01194371ae5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -306,6 +306,7 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
+	int fpsimd_cpu;
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 
 	struct {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e3edea8379f3..87141c8d63e6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -313,6 +313,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
+	vcpu->arch.fpsimd_cpu = NR_CPUS;
+
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 8eb1f87f9119..1afee8557ddf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -259,6 +259,8 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
 
+	vcpu->arch.fpsimd_cpu = smp_processor_id();
+
 	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
 
 	return true;
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

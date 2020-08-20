Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B82AC433E3
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CCDC822BF5
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ttsVAj7n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCDC822BF5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8343D4B888;
	Thu, 20 Aug 2020 06:35:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pTEHNGCP3TLV; Thu, 20 Aug 2020 06:35:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 729094B865;
	Thu, 20 Aug 2020 06:35:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE0794B86B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ZsApysKIfww for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:26 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5B2F4B852
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:25 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id e14so504830wrr.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=FpXGW2sGNgfy+CtJ7CXoWW+rn8TCwxkGXj7yU9QSp6Y=;
 b=ttsVAj7nmCb3QMAaIIDzT7OmMhd6HcWp0XMv8mtRiDFmTkfFNVsqg2wriz3PPmK3A9
 30CU3WzvRy1kqa1skZ3VzgODbEEMYFD0VHflfyQXd6lH1ciejSmnsbBDWaUr8jO/MPTa
 hpsr4ty3rugoOv8bPC0J3Vcup0+dpi77exLll9lSeuSMqJujONetR+bPvSNTZCxftOmB
 /kKRe9gunwz6n44vTPC9a1C3c+EMRgMvGt6B4BFFf9ZOcXywUvJce6QTZZbwTIO0JJlG
 l9QieQ70/jtxMBx/kTYYeONHTZFA02DEu37Cj8oKMpqdwfkP+9Zyfqz0JZn54c8g5Yk4
 AJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FpXGW2sGNgfy+CtJ7CXoWW+rn8TCwxkGXj7yU9QSp6Y=;
 b=I55dIzzRVRVgK4V3zxPk1/XlfmhO//dnOo/KTZI9cQtmDgCUna+pa/TwUbybF6mr5Y
 zSFOft2bieJnns+Fnzje0z7t0JTHIuvCjrBoe8YxuW0vqBiCxb/RXLIw2UE8/k+X1GJb
 bF+qYNoqeBhrB1QfsK7YJstTIUUhm9CC+tYLVCq1ncZcoJUWCV2ROFsnEb63GAhlZgNJ
 QHrSs9qegktU5WeRGyHpIsPKloSpC8HoGdwxy1rqTEuT375n721Kcq0vdfgGcT0jC6vZ
 Jq1K3mxHVMHoHLLJS7xt8W3e8BaOMqZ3N5WsUIQVzabPVVmb4TKLTNiLWq3lZHLSQDX5
 DKiQ==
X-Gm-Message-State: AOAM531FdEr8dX+6qrFbduaw4T6AHCM2vdEF/jm1DJP6rwPh6+G+/47P
 K77Mt4qlgAg3fNdx6TvxSTOXGGj7EGGbeSqMrG5nxGqZQ6Y+l3OVEXQguy6zt8BbLceWZrxFGti
 iP3xt03XqUnq5QvjdaPYbRcLIfY6263g85+KuEr0WHMkSTENF+fQ8xVopWCnBH5y5+uPpZg==
X-Google-Smtp-Source: ABdhPJzUJO0vAS12FqRwiVrrpYI/5KMeVxMpn8uu2ncYyxlpc3uZjKgzLGSHeTcMw6oIQgCymDQCbAN9kC8=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a1c:96d7:: with SMTP id
 y206mr2834837wmd.9.1597919724606; 
 Thu, 20 Aug 2020 03:35:24 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:28 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-3-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 02/20] KVM: arm64: Remove hyp_panic arguments
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

hyp_panic is able to find all the context it needs from within itself so
remove the argument. The __hyp_panic wrapper becomes redundant so is
also removed.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  2 +-
 arch/arm64/kvm/hyp/hyp-entry.S   | 11 +++--------
 arch/arm64/kvm/hyp/nvhe/switch.c |  4 +++-
 arch/arm64/kvm/hyp/vhe/switch.c  |  4 +++-
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 46689e7db46c..3de99b323061 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -89,7 +89,7 @@ void deactivate_traps_vhe_put(void);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt);
+void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(unsigned long, ...);
 #endif
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 689fccbc9de7..b0923e9f9291 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -148,7 +148,7 @@ el2_sync:
 
 	/* if this was something else, then panic! */
 	tst	x0, #PSR_IL_BIT
-	b.eq	__hyp_panic
+	b.eq	hyp_panic
 
 	/* Let's attempt a recovery from the illegal exception return */
 	get_vcpu_ptr	x1, x0
@@ -176,7 +176,7 @@ el2_error:
 	cmp	x0, x1
 	adr	x1, abort_guest_exit_end
 	ccmp	x0, x1, #4, ne
-	b.ne	__hyp_panic
+	b.ne	hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
 	sb
@@ -193,12 +193,7 @@ SYM_FUNC_START(__hyp_do_panic)
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
index 2940d220096d..f969a6dc4741 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -242,11 +242,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
+void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
+	struct kvm_cpu_context *host_ctxt =
+		&__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	struct kvm_vcpu *vcpu = host_ctxt->__hyp_running_vcpu;
 	unsigned long str_va;
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 30bb76066cc0..099bfa78011c 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -208,8 +208,10 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par,
 }
 NOKPROBE_SYMBOL(__hyp_call_panic);
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
+void __noreturn hyp_panic(void)
 {
+	struct kvm_cpu_context *host_ctxt =
+		&__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

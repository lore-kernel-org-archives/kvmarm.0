Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4A6C48BE8
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D40966147E
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D40966147E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7854B0DF;
	Tue, 15 Jun 2021 09:40:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KMOO6HRMmwHG; Tue, 15 Jun 2021 09:40:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CFD04B0E2;
	Tue, 15 Jun 2021 09:40:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08D374B0F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AIOZOQLfoPVr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:11 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F6474B0FF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:10 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 h19-20020ac846d30000b029024baebaa003so8436166qto.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/ZNj//y7/SjoAxBEcefkL8ebDQE/+CV8RIiKr82iulc=;
 b=c8jRQUYuhTzwZVthFQCOV+MDGIBkdEnFNJ4lhEsf2PofCyfKBFI18FQmhYJgOYOeHX
 dFwtBz1+MhteiRUdOLVy0Nr/WE4hGhdHENFeFijmHo6T5RNO6lNzZDwqlTv6GVBpmuJt
 r/KfWXNR7QKgkmy1mnorlbDV16p5ViychL2SmieQggSi6PVzVERnItzKKzNewDKe1xgK
 2gnCu5LIlFYc4FNARtvkmDVOVFdPYsNE6C1yEdW7Mvl4HNKpHgmyb4TfTyM3jfpiTL3N
 TMy0TIUoQ+G8Xxd4cpEj5gpalk3HXOI88vG6n5KphoXtaN1yqdbDGR2OA8QDMq0C1BLF
 T0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/ZNj//y7/SjoAxBEcefkL8ebDQE/+CV8RIiKr82iulc=;
 b=GEbJHAi1KzTFCR3fvT8QRRjKRqLCitWapLl1eSq52GpXWxR5gT8WZk/TyYsD/dSV9R
 ObNYIcnoXSbr+L5SSUUygGawTpYIuxxtPKx2rmP6k0dEhn4tQXICCpH0Gt/ZOq5lHZAD
 uZ40ieJISj7f/I3LDBDkbDuoqMn92q4IFp1IbBXekiMR3hviLvANlq56P3yV+Gxen9mF
 MYQ17Yz48T1e89IdZIwc5Mk13seLEFZRodw3g+cFh0Kv7hE6Zm6gYGQ+nBCm65ba4aif
 wFoGUxm/MVOTdKBfz0W1wqY5uKDkYbkwo0f4GJEwWfea+sIgy3sirhNdJeLjcWcikkqF
 o7Og==
X-Gm-Message-State: AOAM533FJx3gvmJIChTDrPPNxK7krJZ/+cjmvNlttOy2p4W6R1MpsjXF
 TOo/58NEs3ppy9Z3nByx9++3+IK+6PGNjQY0YzzZlLNHhibYJ4W1CS5jC7U9moDbm0zrxC92lwR
 dHlEHFXnNcGk+6XcbAFusBCBcdFD3amtdP0BDvv/jTbyx8F9/S7bUZ8ugZnXrFW/6QYQ=
X-Google-Smtp-Source: ABdhPJyTH68YPgkTSm2Hcof67XgYUf622myCRuThdrPr64jnQPXjhSM3f8Eps/2UjP0pI0ln/LGlMYSQ4A==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:20e3:: with SMTP id
 3mr5303675qvk.53.1623764409740; Tue, 15 Jun 2021 06:40:09 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:45 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-9-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 08/13] KVM: arm64: Guest exit handlers for nVHE hyp
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Add an array of pointers to handlers for various trap reasons in
nVHE code.

The current code selects how to fixup a guest on exit based on a
series of if/else statements. Future patches will also require
different handling for guest exists. Create an array of handlers
to consolidate them.

No functional change intended as the array isn't populated yet.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 35 +++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..f5d3d1da0aec 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -405,6 +405,18 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
+
+static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
+{
+	if (is_nvhe_hyp_code())
+		return kvm_get_nvhe_exit_handler(vcpu);
+	else
+		return NULL;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -412,6 +424,8 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	exit_handle_fn exit_handler;
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
@@ -492,6 +506,11 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			goto guest;
 	}
 
+	/* Check if there's an exit handler and allow it to handle the exit. */
+	exit_handler = kvm_get_hyp_exit_handler(vcpu);
+	if (exit_handler && exit_handler(vcpu))
+		goto guest;
+
 exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 430b5bae8761..967a3ad74fbd 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -165,6 +165,41 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+static exit_handle_fn hyp_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_WFx]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= NULL,
+	[ESR_ELx_EC_CP15_64]		= NULL,
+	[ESR_ELx_EC_CP14_MR]		= NULL,
+	[ESR_ELx_EC_CP14_LS]		= NULL,
+	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_HVC32]		= NULL,
+	[ESR_ELx_EC_SMC32]		= NULL,
+	[ESR_ELx_EC_HVC64]		= NULL,
+	[ESR_ELx_EC_SMC64]		= NULL,
+	[ESR_ELx_EC_SYS64]		= NULL,
+	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_IABT_LOW]		= NULL,
+	[ESR_ELx_EC_DABT_LOW]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
+	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
+	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
+	[ESR_ELx_EC_BKPT32]		= NULL,
+	[ESR_ELx_EC_BRK64]		= NULL,
+	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_PAC]		= NULL,
+};
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
+{
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 esr_ec = ESR_ELx_EC(esr);
+
+	return hyp_exit_handlers[esr_ec];
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

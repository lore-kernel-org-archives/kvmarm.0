Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2775C433E4
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A5B720672
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="uLdQQEbw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A5B720672
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 448E14B170;
	Wed, 15 Jul 2020 14:46:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hkv3MRAp-1uP; Wed, 15 Jul 2020 14:46:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 314BD4B407;
	Wed, 15 Jul 2020 14:46:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BC154B3F6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:46:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IOOrIuXaC05Q for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:46:08 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02EA44B418
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:46:07 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id y18so1978012wrq.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qGcT80hhxd3Hdp5jqNYGEnshhCPJeQj/7s91F8b18Bg=;
 b=uLdQQEbwONTY0OfVV7YQyFlHIzcT/ptyHWFpakQTuO62ycxtrxoOtQA+wvr4iy7FRh
 cCLbq5I+jDIFBtX3AiiHla6FOAijUoe+FyC46IIKSciDTOCyv0V86PfLbz5aqCaDm+d2
 XrnmQYSDu4lE4PnzlemiaCbL+cxskvUl99Lhoi+ys+Knpcz+Jo3FvMWZOFoC7UGVMxbD
 uOP26DTaMSO5QGNgxhzmuUxrIe+LMjZgKBziTKqNhRWDJhPaRQOpljeKFIpLC9jLkivY
 Ytkuo7IhIj0RS8v835/A9601UTmQ8h1pvAM0J8oePFNw05galmS8diZbhJ/BZkGMNG5n
 TIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qGcT80hhxd3Hdp5jqNYGEnshhCPJeQj/7s91F8b18Bg=;
 b=SZ47F3F5FdTbUnhWXEoToeIOBJOqn+zHstiocF61F5MrO5hKSAohz9elmklbTY8piO
 XJTaLNZdwek2346/wLkJZUqzeGciZqGYCMuyuDs5cWtXaaEcLPGr8pdZyCkwZmIcNvYI
 +LBxT1+YDCXNQ/bW1tCn/SsDXnutYqbsBqs8CVQvjpCmQtFad5DjRHBqSEHVzVDzO/9W
 8NzyYesFyRc1uoPETd1OdjEUWQuSPO4uz8PoELpo57DpZSXs0MJCZiXFmedmpgm+O00Y
 dN7zwbk9ooGuQkG9L6ZPhCXiLhghDNsBBnq4CFWDnm65LrKKOLSP3vcDW3aCFyOMe4AW
 JhPA==
X-Gm-Message-State: AOAM532fyltcHs/iANSGRRaM21vFEdRYcjkQNRQFq8G9wBEek7B3DQY5
 hh4qoNGfbZF++LodkCze21ws5z+VoCgOQ7qbTRlBjTilegkiCoxSVboXNbyIz1IKQQtlEmITxEO
 RXN4fV9SWK2+arCH0cdJ9Iop3axiavCR5bRKjHhoBk9kggyIGZbv8dzzhVNjiFi7FltP2AA==
X-Google-Smtp-Source: ABdhPJyKfMedbZRvHvUY4IWVvSsh1WODIZpQGZP6REbCa6fZ7PUB5Pyr9dkQ5XVp2+6lYBdjq5UpkWarcm4=
X-Received: by 2002:a5d:4202:: with SMTP id n2mr698689wrq.171.1594838765946;
 Wed, 15 Jul 2020 11:46:05 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:36 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-36-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 35/37] KVM: arm64: nVHE: Unify PMU event restoration paths
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

Depending on whether the vcpu is the host or not, the appropriate bits
are cleared and set.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 42 ++++++++++++--------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 05f1cf7ee9e7..d37386b8ded8 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -88,32 +88,22 @@ static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-/**
- * Disable host events, enable guest events
- */
-static void __pmu_switch_to_guest(void)
+static void __pmu_restore(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_events *pmu = __hyp_this_cpu_ptr(kvm_pmu_events);
+	u32 clr;
+	u32 set;
+
+	if (vcpu->arch.ctxt.is_host) {
+		clr = pmu->events_guest;
+		set = pmu->events_host;
+	} else {
+		clr = pmu->events_host;
+		set = pmu->events_guest;
+	}
 
-	if (pmu->events_host)
-		write_sysreg(pmu->events_host, pmcntenclr_el0);
-
-	if (pmu->events_guest)
-		write_sysreg(pmu->events_guest, pmcntenset_el0);
-}
-
-/**
- * Disable guest events, enable host events
- */
-static void __pmu_switch_to_host(void)
-{
-	struct kvm_pmu_events *pmu = __hyp_this_cpu_ptr(kvm_pmu_events);
-
-	if (pmu->events_guest)
-		write_sysreg(pmu->events_guest, pmcntenclr_el0);
-
-	if (pmu->events_host)
-		write_sysreg(pmu->events_host, pmcntenset_el0);
+	write_sysreg(clr, pmcntenclr_el0);
+	write_sysreg(set, pmcntenset_el0);
 }
 
 static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
@@ -129,15 +119,11 @@ static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
 		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
 		pmr_sync();
 	}
-
-	__pmu_switch_to_guest();
 }
 
 static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 				      struct kvm_vcpu *vcpu)
 {
-	__pmu_switch_to_host();
-
 	/* Returning to host will clear PSR.I, remask PMR if needed */
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(GIC_PRIO_IRQOFF);
@@ -219,6 +205,8 @@ static void __vcpu_restore_state(struct kvm_vcpu *vcpu, bool restore_debug)
 		__debug_restore_state(kern_hyp_va(vcpu->arch.debug_ptr),
 				      &vcpu->arch.ctxt);
 
+	__pmu_restore(vcpu);
+
 	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 }
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

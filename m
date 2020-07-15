Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024D7C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC80920787
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="A1n8WACM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC80920787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 669C14B410;
	Wed, 15 Jul 2020 14:46:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Q3okd2fQeBg; Wed, 15 Jul 2020 14:46:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 524B74B419;
	Wed, 15 Jul 2020 14:46:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB09D4B40B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:46:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jbXXyERoOniA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:46:09 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC9914B32C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:46:09 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id e15so1745651wme.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=f1rxnMCctAcF/Sb7gTNBkNap+c21g4RCSpaXg2fG2tY=;
 b=A1n8WACMGzCWgAyl0jGB/sbZhd5RNnbWTRQ/SXmUY4pYo9ZdFECf5LdcSTI5jOrp1k
 wYKZf4M7IgPixV3rXRVWk3lMrV5o7+orsyMhvV2JHqMdJ+hJWG3OtWKUrVlRLp++R3QI
 tilEYI3AFESqtDQGDoamj5SZ9P+qXjxHGxlpydXsvYqDIk8BKLvtjYjT8GtU5rgJZLrR
 FHgMnTc2lTcKugeA7AdHfGUXK7toJjnCOFUQsnRINXwkbp56stMVgCoP1qimOTNWIp3y
 aozMWzJQh8Ho960xQZBoUCXl5s7hAqNfBzTtQOlK2vbxgqjcJwyp86Y/HW17s65VnALh
 qmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=f1rxnMCctAcF/Sb7gTNBkNap+c21g4RCSpaXg2fG2tY=;
 b=LyVAdnRX1VRZ1nMSj0jmk13gnMQOleX9KM4fGidt+RamRr74hXLAxX+1ehU7F3gqZg
 GCD/pykB55v1bQ0qysNx2h1rP3iEcSzQsoYIA9CQZTH9lFJZ2bxamlzd1cCye/88hUmQ
 gDS8LcFDyvPc1emfP63qVBicSrb14ew/s5mzYwkgDHabnj5pJhbT7YQenzCH4HiPTeIW
 cBrquF1W9DuuSfmRBFFQcCGwJfZNfNIqEOKfFRRpR95NNok1o+Y9x7V0VyA7WQhzPm6/
 ASC+Z+bzJmIy3oB0rIT86Dp+b4sZR+0SiD2ZG6rqtD1yrY3hdOLBtAJvQLNa2/HmYDWi
 et7Q==
X-Gm-Message-State: AOAM533bmlsrDaZmrK169KeyZjmEEn4s4EQbxmLnJNyCif8+x6apInN/
 6JvtrytNLvzOtbUZGvyremiJK3hCi3PTsAoLFokbLLwzDsQfBSmxJJEHw8uAzqYRSsDvOOcwFEs
 3cCD9M9g4QTqyM+PNFgB9wlPcGKGDQUk5vlRDX3484SdU+vFLQ0gvICS2hQMgXMY7mi09pA==
X-Google-Smtp-Source: ABdhPJwtiEE89PaFZot5Yai71sS1zdAH79PengTjXu+YhK9BCZeyd806E0XtjwqKu3gT8u3KT83ye0piNC0=
X-Received: by 2002:a7b:c1d8:: with SMTP id a24mr1315540wmj.0.1594838768218;
 Wed, 15 Jul 2020 11:46:08 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:37 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-37-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 36/37] KVM: arm64: nVHE: Unify GIC PMR restoration paths
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

Different actions are taken depending on whether the vcpu is the host or
not.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 50 ++++++++++++++------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index d37386b8ded8..260c5cbb6717 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -88,6 +88,26 @@ static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 	}
 }
 
+void __hyp_gic_pmr_restore(struct kvm_vcpu *vcpu)
+{
+	if (!system_uses_irq_prio_masking())
+		return;
+
+	if (vcpu->arch.ctxt.is_host) {
+		/* Returning to host will clear PSR.I, remask PMR if needed */
+		gic_write_pmr(GIC_PRIO_IRQOFF);
+	} else {
+		/*
+		 * Having IRQs masked via PMR when entering the guest means the
+		 * GIC will not signal the CPU of interrupts of lower priority,
+		 * and the only way to get out will be via guest exceptions.
+		 * Naturally, we want to avoid this.
+		 */
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
+		pmr_sync();
+	}
+}
+
 static void __pmu_restore(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_events *pmu = __hyp_this_cpu_ptr(kvm_pmu_events);
@@ -106,29 +126,6 @@ static void __pmu_restore(struct kvm_vcpu *vcpu)
 	write_sysreg(set, pmcntenset_el0);
 }
 
-static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
-				       struct kvm_vcpu *vcpu)
-{
-	/*
-	 * Having IRQs masked via PMR when entering the guest means the GIC
-	 * will not signal the CPU of interrupts of lower priority, and the
-	 * only way to get out will be via guest exceptions.
-	 * Naturally, we want to avoid this.
-	 */
-	if (system_uses_irq_prio_masking()) {
-		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
-		pmr_sync();
-	}
-}
-
-static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
-				      struct kvm_vcpu *vcpu)
-{
-	/* Returning to host will clear PSR.I, remask PMR if needed */
-	if (system_uses_irq_prio_masking())
-		gic_write_pmr(GIC_PRIO_IRQOFF);
-}
-
 static void __vcpu_save_state(struct kvm_vcpu *vcpu, bool save_debug)
 {
 	__sysreg_save_state_nvhe(&vcpu->arch.ctxt);
@@ -154,11 +151,6 @@ static void __vcpu_restore_state(struct kvm_vcpu *vcpu, bool restore_debug)
 	 */
 	running_vcpu = __hyp_this_cpu_read(kvm_hyp_running_vcpu);
 
-	if (vcpu->arch.ctxt.is_host)
-		__kvm_vcpu_switch_to_host(vcpu, running_vcpu);
-	else
-		__kvm_vcpu_switch_to_guest(running_vcpu, vcpu);
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
@@ -207,6 +199,8 @@ static void __vcpu_restore_state(struct kvm_vcpu *vcpu, bool restore_debug)
 
 	__pmu_restore(vcpu);
 
+	__hyp_gic_pmr_restore(vcpu);
+
 	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 }
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

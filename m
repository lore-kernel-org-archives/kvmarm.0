Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301CFC43381
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CAA0664D73
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAA0664D73
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E99F4B39D;
	Wed, 10 Mar 2021 12:58:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8yPW3793ykVo; Wed, 10 Mar 2021 12:58:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECCDF4B531;
	Wed, 10 Mar 2021 12:58:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B184B4B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7lrzBTCDqgAz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:43 -0500 (EST)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BF2B4B531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:42 -0500 (EST)
Received: by mail-qk1-f201.google.com with SMTP id x11so10178785qki.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4oxp+YpplIoIB69u+tbsX2FMX4bca6h5fwiDtQ6/a1E=;
 b=vfNvL6VYP4cIvis4RUMqKQm+EjWb6Qdd5uxQRDjzD2jvaui8luwSb3kbZaVs7Cun3c
 I70CqF0WoKxquNq8GHLfoqZouqHwob9jrTw3fol8OJSK/TwkWGztOcvr42WqszU0moEe
 H1A8F/B1Tfh3dsLtou0ZuncYrXXuZK625m0AzBYrpPpIlL1jDNEpm3fusVFyhxTSEQLr
 9SrqgMAJKv566vQ7PZQQcfFufCHMyYUsTWwpbZFUcqzB38QgZf896YlSPDkat+pg+eei
 OL16OP7Oedq8fTKRKJjFfbS+wpyjBA5hZtamumQ0v6fBmoQZrRQdY6ofweJTdrk80kOH
 KjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4oxp+YpplIoIB69u+tbsX2FMX4bca6h5fwiDtQ6/a1E=;
 b=fioTa7KzIlo0L3qXB/UcVdAh+inCEIaDvVa3Z1eEHi/mo+XLriT0iUchwbIsY9iHt6
 rLMqqMBQQulu9LzAXAkjJMGWGNtwky5qbr4ipMevg9jBgHij6Lv/+0KRuXwqqOkNEJjq
 ou2yxcRSjtCRqQVlsapC0l3vPS8Dt89Fshqrh41c2mWlqohNSXPlLbh6qO+3g41vJL8t
 pT5VRet0NhwwI8xnlbNYd6Gtjptf9SOCuct04yV/Qs/KjRGbUshNTpKyX4kfGbF8wqh2
 bbrUyUSwvToP7UxaYKjF0CpB1zwCjTKlMiQlpDGHDr+f+6K/+XznaEjSVZcvEt4XLJ8n
 +fgg==
X-Gm-Message-State: AOAM532iEljVSUS/xY5k29jD1refW8zU9B9whxfEPtlkLosEdgiqV/nw
 KaGBvER9baga1nnHAImzoZFmXksEJrC7
X-Google-Smtp-Source: ABdhPJysjBX02XgOxXRd70RHGblWwl/bjhm+VVsnnUsNEc3jBBZ20r71lSy0Vi2+2+6+nm09mj60syhCGiEY
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:f9cc:: with SMTP id
 j12mr3939245qvo.15.1615399122003; Wed, 10 Mar 2021 09:58:42 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:39 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-23-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 22/34] KVM: arm64: Refactor __load_guest_stage2()
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

Refactor __load_guest_stage2() to introduce __load_stage2() which will
be re-used when loading the host stage 2.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6f743e20cb06..9d64fa73ee67 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -270,9 +270,9 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
  * Must be called from hyp code running at EL2 with an updated VTTBR
  * and interrupts disabled.
  */
-static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
+static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu, unsigned long vtcr)
 {
-	write_sysreg(kern_hyp_va(mmu->arch)->vtcr, vtcr_el2);
+	write_sysreg(vtcr, vtcr_el2);
 	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
 
 	/*
@@ -283,6 +283,11 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
+static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
+{
+	__load_stage2(mmu, kern_hyp_va(mmu->arch)->vtcr);
+}
+
 static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
 {
 	return container_of(mmu->arch, struct kvm, arch);
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

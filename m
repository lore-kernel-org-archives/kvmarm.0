Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1454C433E9
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7CD2B64FB1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CD2B64FB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 233CE4B1F9;
	Wed, 10 Mar 2021 12:58:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BkV8byAkHMjf; Wed, 10 Mar 2021 12:58:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D554F4B65C;
	Wed, 10 Mar 2021 12:58:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 225D84B523
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CdraFbH+Mcrm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:25 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 103A24B61A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:25 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id c7so2975603wml.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=84bkslXA7Qi7zlX0xHNbjR4XGFTrfSQqHB0l+SkjRTk=;
 b=gWR4E2H56ggbHXScQX04OGikwUKGFnpT1gmE6DUsaiqo17dy/goaVT6bwUgnhoi2Ju
 l6LWaN0AfBgHJvRU3Ntr0R6mbn6chazZBSXWjI/zmceN+GqIiziZZG6WvehBBHjFFiCv
 ff9Sb8VsJ6LT0Kj7avPebY6x8I2r8IJSx0TSinGSZuQBatEs2GvxWIim6kNPaBAilhzc
 6wISeQvXokT2A2HYnczpuZZ3DMpgom1eOj/dEnrcQ2uXdttitkZONhv0pPSGLyhCFNNJ
 2IpQR0s3Uwh8m+aS8s26mFq9vTzaNVZO59IeMkJaiD7fJ0Ial468WcZluMzWA4tW56/3
 EcUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=84bkslXA7Qi7zlX0xHNbjR4XGFTrfSQqHB0l+SkjRTk=;
 b=EohxU/+LupnqSxQev8tjr4Zm6JtgYCdfOFrWFeheD7KMwMOYn+74i66tfynNJeWt7a
 S/ksI+OdfLeF0zWF4lJ+DVSrF8f6Zzt5QqqtFuKVB+d6K9q6ydae4LebdACYIojk74E+
 5fH/rkXFuxP9GFfrmpxkUnW0v4k6xhQrK8wMwG5vkCTUseiuRPO/amOvzkPO6KnfmHBs
 YtntM/Tfy3M+7eq0uGaGAzyPy/UAeFoDi4VmfHrRHFLTqESdwTqF4CrJWhHdOKqdLrpD
 trElsVqSfROEyzCypMv5m8/FK3qx69JyXuSKZm5uWeH7cP/f2qmf/wQgDxxbrmlZdN5B
 LgaA==
X-Gm-Message-State: AOAM530f0y0qNSogBKtxHNMsOjxUMGnOBi1PuXtQflNw6knm73ccaRRX
 xGsVPE8HStQ+X2vHT+ZNRj1B8+n3VmuY
X-Google-Smtp-Source: ABdhPJya6ohuYr2xnAIymmnPbC5dgEguUfV3trhqlVeC84z+zmtstjGngwQdmVgPcn0lHtJOrOlTur1n8Dx9
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a5d:4ec5:: with SMTP id
 s5mr4826061wrv.168.1615399104184; Wed, 10 Mar 2021 09:58:24 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:31 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-15-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 14/34] KVM: arm64: Factor out vector address calculation
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

In order to re-map the guest vectors at EL2 when pKVM is enabled,
refactor __kvm_vector_slot2idx() and kvm_init_vector_slot() to move all
the address calculation logic in a static inline function.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 8 ++++++++
 arch/arm64/kvm/arm.c             | 9 +--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 90873851f677..5c42ec023cc7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -168,6 +168,14 @@ phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
 
+static inline void *__kvm_vector_slot2addr(void *base,
+					   enum arm64_hyp_spectre_vector slot)
+{
+	int idx = slot - (slot != HYP_VECTOR_DIRECT);
+
+	return base + (idx * SZ_2K);
+}
+
 struct kvm;
 
 #define kvm_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3f8bcf8db036..26e573cdede3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1345,16 +1345,9 @@ static unsigned long nvhe_percpu_order(void)
 /* A lookup table holding the hypervisor VA for each vector slot */
 static void *hyp_spectre_vector_selector[BP_HARDEN_EL2_SLOTS];
 
-static int __kvm_vector_slot2idx(enum arm64_hyp_spectre_vector slot)
-{
-	return slot - (slot != HYP_VECTOR_DIRECT);
-}
-
 static void kvm_init_vector_slot(void *base, enum arm64_hyp_spectre_vector slot)
 {
-	int idx = __kvm_vector_slot2idx(slot);
-
-	hyp_spectre_vector_selector[slot] = base + (idx * SZ_2K);
+	hyp_spectre_vector_selector[slot] = __kvm_vector_slot2addr(base, slot);
 }
 
 static int kvm_init_vector_slots(void)
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

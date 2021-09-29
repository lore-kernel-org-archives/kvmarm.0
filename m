Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43AAC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71F286137E
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 71F286137E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20DD04B137;
	Wed, 29 Sep 2021 03:12:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8BOqX5SFDv1o; Wed, 29 Sep 2021 03:12:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A64B14B129;
	Wed, 29 Sep 2021 03:12:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1DC24B09C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 00:29:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9W0qnVjLf9DJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 00:29:46 -0400 (EDT)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C6F24048B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 00:29:46 -0400 (EDT)
Received: by mail-pl1-f172.google.com with SMTP id x8so636573plv.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 21:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=OcDKPT+o8pM718i3RLMaqx3xW7Im6h5PXbupy2CRXlk=;
 b=AlxJKNLVCtbK//MPu0SwfjNSQbHwwFNaK/3A0HUgxYAYkHcIT+rlmMLLt2qZrpyAyp
 C5t1oA+CT6G5meEEeMzD5kZ8i4MvQTTRPGyO+QzHMZUkoUC3ZJlQo5YNYhLT1Gzx9doh
 asWRl+ES1erLKQgBHQzTmUb6DExqco2ElcumI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=OcDKPT+o8pM718i3RLMaqx3xW7Im6h5PXbupy2CRXlk=;
 b=Kzbcs8jYqq8o6dYEMTPfQs+zPVEjPsZQNM1yhe2dtJLSXFcmFUEvY1eidH2Lc6VldF
 BfThg8k4pqsFraWRVzPookOwbZXOD0bHZYS/2DYaO39pykhBKR2Qjo2kNgu+qFzlR3s+
 HvU1/JFaxQA2ObrS83MZ2ygnak+H1DXnadnUAagkw0Uf6u8tsHpvp0k5ckghmSKnQn7X
 dl4PGXfOUXKhjKS8t1AWe6I3mQ0r02VGOjshtRB1+hIBaRd+vvB1XKPpT27eJ/MY29t1
 VdP74zGWKPQj7wPnr6Q2/EaY0E06a7y92HirMVDV/07T0ftrIiuJxrWi854oqHvHJhSU
 ngFw==
X-Gm-Message-State: AOAM533fybkCzIwFZZlpnsGFoqz71l1cp/qIT91TFcYjuw1lX79P9/AL
 k521sQ6RbV9JDCAF6iT/8Nu+Qw==
X-Google-Smtp-Source: ABdhPJzx/fGyiGUmfwWIVEkifAtKjOaGFTb3lns1h2o/LCiNDuEd1upLa4vG7ByFxiynE/6fn+dXhQ==
X-Received: by 2002:a17:90a:f196:: with SMTP id
 bv22mr4057172pjb.212.1632889785769; 
 Tue, 28 Sep 2021 21:29:45 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:f818:368:93ef:fa36])
 by smtp.gmail.com with UTF8SMTPSA id p17sm268006pjg.54.2021.09.28.21.29.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 28 Sep 2021 21:29:45 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v4 3/4] KVM: arm64/mmu: use gfn_to_pfn_page
Date: Wed, 29 Sep 2021 13:29:07 +0900
Message-Id: <20210929042908.1313874-4-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929042908.1313874-1-stevensd@google.com>
References: <20210929042908.1313874-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 29 Sep 2021 03:12:40 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

From: David Stevens <stevensd@chromium.org>

Covert usages of the deprecated gfn_to_pfn functions to the new
gfn_to_pfn_page functions.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/arm64/kvm/mmu.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1a94a7ca48f2..dc03cc66858e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -829,7 +829,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 static unsigned long
 transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
-			    phys_addr_t *ipap)
+			    struct page **page, phys_addr_t *ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
 
@@ -838,7 +838,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
+	if (*page &&
+	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
 	    get_user_mapping_size(kvm, hva) >= PMD_SIZE) {
 		/*
 		 * The address we faulted on is backed by a transparent huge
@@ -859,10 +860,11 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		 * page accordingly.
 		 */
 		*ipap &= PMD_MASK;
-		kvm_release_pfn_clean(pfn);
+		put_page(*page);
 		pfn &= ~(PTRS_PER_PMD - 1);
-		get_page(pfn_to_page(pfn));
 		*pfnp = pfn;
+		*page = pfn_to_page(pfn);
+		get_page(*page);
 
 		return PMD_SIZE;
 	}
@@ -955,6 +957,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	short vma_shift;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
+	struct page *page;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
@@ -1056,8 +1059,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __gfn_to_pfn_page_memslot(memslot, gfn, false, NULL,
+					write_fault, &writable, NULL, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
@@ -1102,7 +1105,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			vma_pagesize = fault_granule;
 		else
 			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
-								   hva, &pfn,
+								   hva,
+								   &pfn, &page,
 								   &fault_ipa);
 	}
 
@@ -1142,14 +1146,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
-		kvm_set_pfn_dirty(pfn);
+		if (page)
+			kvm_set_pfn_dirty(pfn);
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 	}
 
 out_unlock:
 	spin_unlock(&kvm->mmu_lock);
-	kvm_set_pfn_accessed(pfn);
-	kvm_release_pfn_clean(pfn);
+	if (page) {
+		kvm_set_pfn_accessed(pfn);
+		put_page(page);
+	}
 	return ret != -EAGAIN ? ret : 0;
 }
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

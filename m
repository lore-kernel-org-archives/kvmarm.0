Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC81C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 08:41:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 898304B1FD;
	Mon, 29 Nov 2021 03:41:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VQuwh24RyWat; Mon, 29 Nov 2021 03:41:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4524B24B;
	Mon, 29 Nov 2021 03:41:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D6B4B208
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 22:43:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jzsce8G-7m-R for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Nov 2021 22:43:54 -0500 (EST)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39B7A4B1FD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 22:43:54 -0500 (EST)
Received: by mail-pj1-f50.google.com with SMTP id
 n15-20020a17090a160f00b001a75089daa3so14421931pja.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 19:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=1E5J112/KKe5nzfIjRapghLBkhpzMa3/YxcaryPQAAY=;
 b=CPZyN1kOZxK9jC2nDgnbHL1qPOcAxvPYZ4/Ldp15ZFP8LQUMl5fThYRqCxYekmI+Ti
 jaGDXmQRNigPBEiMxuYtVffQzOSXSTMZfCgxkkTeXS6mHjhsZzo3h+r10/68GkCXPnC9
 CxPtfq+6DPfEA6ybJRpLeLHrmjDI7ysst1V7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=1E5J112/KKe5nzfIjRapghLBkhpzMa3/YxcaryPQAAY=;
 b=lDp6zNw9XzbqeH2pVj3qqwbwOOJaMA4LZrehsbIBRwhu78GVO18WrG2xGQN7fOAKPq
 4/zmgjgxZg9xFMhGjr1+AJwxJzF9MjO+Z6veltbSKqaw9UT7vUazxw1lABLMO+AVi2gq
 qilfonPpgoIUt7yzObEq0a46kMF4f68YSpl8DsO6S9pWMI3EU0fKkEju14Q8pRtbzHsS
 PM4tsKFSxkSIk+a3Iemy7jKZjgk9QA7GXHuYEZGE8Joemnjdu2r6srl1BESx5SI73KTA
 +UE4PgI07NOVCwWmX6O4/MImLPYkrsOsjmVtvz0cOz12QppdyfRg7EUa0aOwNjDH6MxR
 dPRg==
X-Gm-Message-State: AOAM530PLsAa5b9nDvZrb3rVxhaWgxI5JKMJbS+79KOexzI73AU3h/sl
 atpMvUvnEgk2PXaR8zfv2z+4PA==
X-Google-Smtp-Source: ABdhPJzR1mYlqKwgxgr65ZpLjYIw4Q3tENBbFuvuJ6S4uxpSlpvxqFbVGGaQXv+7du9DJSv52f6+mQ==
X-Received: by 2002:a17:90a:e506:: with SMTP id
 t6mr34337394pjy.9.1638157433470; 
 Sun, 28 Nov 2021 19:43:53 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:72d1:80f6:e1c9:ed0a])
 by smtp.gmail.com with UTF8SMTPSA id h13sm14337804pfv.84.2021.11.28.19.43.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 28 Nov 2021 19:43:53 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v5 3/4] KVM: arm64/mmu: use gfn_to_pfn_page
Date: Mon, 29 Nov 2021 12:43:16 +0900
Message-Id: <20211129034317.2964790-4-stevensd@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129034317.2964790-1-stevensd@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Mon, 29 Nov 2021 03:41:49 -0500
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
index 326cdfec74a1..197fb8afbb94 100644
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
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3737CC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 08:41:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3C9C4B1D5;
	Mon, 29 Nov 2021 03:41:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id reRgDoUSfNqZ; Mon, 29 Nov 2021 03:41:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD6E4B245;
	Mon, 29 Nov 2021 03:41:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43DED4B1FE
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 22:43:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8wdDmhwlP+B3 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Nov 2021 22:43:49 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 976694B1FD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 22:43:49 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id v23so11554471pjr.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 19:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=WMYRrbcse/N7Z6kty0CX8mwv84TiaTtEgSRBD9icxeo=;
 b=l5BRuDFG8QUnDUfK0C4OQZ7pI/xscGyHXmrsmUVpB0homEFKpzaHd7GPALVmtCCjla
 x/NrMEM9Ls/X+/4lShvIyG4x5vdA5kGh93aou3U/cBCOR8dxuHHuR2gZsPtfbd6ouW+9
 jLl2SQxzemkKFhr8XTfasLphpSKL4EgcWJ3Ic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=WMYRrbcse/N7Z6kty0CX8mwv84TiaTtEgSRBD9icxeo=;
 b=fjsC7I4HeLldxg97hvlzrNpLMllJWqDRdhPqSfOSIvhDKgqGLRu0ua2DSqP3qCkLrZ
 Fry5eMzaJATi/fQnKj/M58GimqrImq/uzca+bub4bL8cTXD8odoJnNVrCKK3goR06KIE
 ckXtQJxG8FaZ0pjtjuDrOicb0cC1aVIgqxMMDtBBi7kuZZn5kgZ1tcsWT18la9QKd4kt
 w9b2E8+znHLN3zaQ1ujcCrCogtIOE3KssK2cyDOcs//jgynC1YFeehgxbXHzQ8PBm4Qd
 H6FHvYQgxYb2jfmP7V+Vm/gyVVudFNkoy/86Lj0LIVP2ve2xgvtJw4FGaisaByh8sczR
 W5eA==
X-Gm-Message-State: AOAM5339gC4ypm7imWdUc4/zE1sMmB+lQeLzwnezXJb/riPZHCS37xnC
 kzmwUtqYnEvVLKdeLhlQkhXhDQ==
X-Google-Smtp-Source: ABdhPJyDEsZsotgmp6fBOwk9oYujXo2fN06uKmxeZ+XjnZYzPGTRUcyJvb12Rt+m6tqKzhAuh+1n+Q==
X-Received: by 2002:a17:90b:4d0c:: with SMTP id
 mw12mr35136514pjb.209.1638157428872; 
 Sun, 28 Nov 2021 19:43:48 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:72d1:80f6:e1c9:ed0a])
 by smtp.gmail.com with UTF8SMTPSA id c21sm15497042pfl.138.2021.11.28.19.43.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 28 Nov 2021 19:43:48 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v5 2/4] KVM: x86/mmu: use gfn_to_pfn_page
Date: Mon, 29 Nov 2021 12:43:15 +0900
Message-Id: <20211129034317.2964790-3-stevensd@google.com>
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
 arch/x86/kvm/mmu.h             |  1 +
 arch/x86/kvm/mmu/mmu.c         | 18 +++++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h |  9 ++++++---
 arch/x86/kvm/x86.c             |  6 ++++--
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9ae6168d381e..97d94a9612b6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -164,6 +164,7 @@ struct kvm_page_fault {
 	/* Outputs of kvm_faultin_pfn.  */
 	kvm_pfn_t pfn;
 	hva_t hva;
+	struct page *page;
 	bool map_writable;
 };
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 04c00c34517e..0626395ff1d9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2891,6 +2891,9 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (unlikely(fault->max_level == PG_LEVEL_4K))
 		return;
 
+	if (!fault->page)
+		return;
+
 	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
 		return;
 
@@ -3950,9 +3953,9 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+	fault->pfn = __gfn_to_pfn_page_memslot(slot, fault->gfn, false, &async,
+					       fault->write, &fault->map_writable,
+					       &fault->hva, &fault->page);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
@@ -3966,9 +3969,9 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			goto out_retry;
 	}
 
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+	fault->pfn = __gfn_to_pfn_page_memslot(slot, fault->gfn, false, NULL,
+					       fault->write, &fault->map_writable,
+					       &fault->hva, &fault->page);
 	return false;
 
 out_retry:
@@ -4029,7 +4032,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	if (fault->page)
+		put_page(fault->page);
 	return r;
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f87d36898c44..370d52f252a8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -565,6 +565,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	unsigned pte_access;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
+	struct page *page;
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
@@ -580,12 +581,13 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (!slot)
 		return false;
 
-	pfn = gfn_to_pfn_memslot_atomic(slot, gfn);
+	pfn = gfn_to_pfn_page_memslot_atomic(slot, gfn, &page);
 	if (is_error_pfn(pfn))
 		return false;
 
 	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, pfn, NULL);
-	kvm_release_pfn_clean(pfn);
+	if (page)
+		put_page(page);
 	return true;
 }
 
@@ -923,7 +925,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	if (fault->page)
+		put_page(fault->page);
 	return r;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5c479ae57693..95f56ec43e0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7820,6 +7820,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 {
 	gpa_t gpa = cr2_or_gpa;
 	kvm_pfn_t pfn;
+	struct page *page;
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -7849,7 +7850,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * retry instruction -> write #PF -> emulation fail -> retry
 	 * instruction -> ...
 	 */
-	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
+	pfn = gfn_to_pfn_page(vcpu->kvm, gpa_to_gfn(gpa), &page);
 
 	/*
 	 * If the instruction failed on the error pfn, it can not be fixed,
@@ -7858,7 +7859,8 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (is_error_noslot_pfn(pfn))
 		return false;
 
-	kvm_release_pfn_clean(pfn);
+	if (page)
+		put_page(page);
 
 	/* The instructions are well-emulated on direct mmu. */
 	if (vcpu->arch.mmu->direct_map) {
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

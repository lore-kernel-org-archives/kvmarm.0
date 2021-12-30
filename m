Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A25AC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Dec 2021 19:46:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 688C040C58;
	Thu, 30 Dec 2021 14:46:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MojzTy2YDnSV; Thu, 30 Dec 2021 14:46:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30FEF49E16;
	Thu, 30 Dec 2021 14:46:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E30F240C58
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 14:46:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FbbHqtq7IJVe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Dec 2021 14:46:01 -0500 (EST)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9865240B85
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 14:46:01 -0500 (EST)
Received: by mail-pf1-f181.google.com with SMTP id u20so22100322pfi.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 11:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SSv7+eW+5rb6ctufcvm45xC/oNc4xjIbljO0x/RtzOU=;
 b=gN3IhbGgjqJ1Z7FKEniA+ftsJK2fXR/ZfOh1xON8D8zybp6rVWmXnz4KpuggFQIG9y
 5Kmhl0UEGLQxEbS6yMCud6PJZR0VV9zsF/Exo+eo1Qjlk5tKIVn8eiw/wEcQ97pgCp/7
 uf1eSNUh4K2hQfNsa4CU5tS1RcaaG6U8j9K2cuD6QFyEa8IdtYRL7dtZ34C05+Q3PVfr
 DMLw7q4o6sVNmZbSCHE2TdyjTJC5QoF7KOfwYaOB5W7+iSbXVH5ANYfA8vDNTNSfKQkk
 Dozb7nN1VPjHFTsJV8LbT0PPrvUXHqrrMB7G1BK7KIFQaoZhDiWZvGDYbaOkcMrtg8+0
 5wQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SSv7+eW+5rb6ctufcvm45xC/oNc4xjIbljO0x/RtzOU=;
 b=7Sgo8pp2Yyr0jxHrmHq8f7qzju1oVuq6IPGfS95TQt+Xm+d9wPecoS0ncOJfHwHg4Q
 2jrtQwG4Uv8GRxnED/qae1+AUJjy5ra3kl2eKAq1qx+0P2wtq5SL93j0/wxQHGQfhMuG
 ONwHLwuObFFcoyG2KaofYSDNafQYPIex4bgiuqXbIzlxRA6rNo2pGGUM2oJkCSjLp2mq
 oHTf/OpCl/OHMSQL2v0eFAaOwa3Rdnh+41vJb6Rn9Gk5QqW7GIvUpX8EkOTCtvC4V7tS
 hAyfD8vf8S3baNjDYN8+gWduTdmk5HBun7qjRhE14kRloHuM1AZRW6w/PDrvwv7tefrf
 xOqw==
X-Gm-Message-State: AOAM530kgiqrC+WvaJcLSfYacnL30JArHDsiJuTcG5QvCjF3ugL6C2Ux
 FRgha3M/oWesdwARWIfall64IA==
X-Google-Smtp-Source: ABdhPJzzclyRHQDfHvRvsZwsyUuzImkT7Z6KSZUcIcPdvMc0Stk+mbpQag6OFzQJCD9h2IBLQyVEEQ==
X-Received: by 2002:a63:8342:: with SMTP id h63mr29243410pge.443.1640893560420; 
 Thu, 30 Dec 2021 11:46:00 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id x25sm25440480pfu.113.2021.12.30.11.45.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Dec 2021 11:45:59 -0800 (PST)
Date: Thu, 30 Dec 2021 19:45:56 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v5 3/4] KVM: arm64/mmu: use gfn_to_pfn_page
Message-ID: <Yc4MdFREYW98mzMs@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-4-stevensd@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129034317.2964790-4-stevensd@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Mon, Nov 29, 2021, David Stevens wrote:
> @@ -1142,14 +1146,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	/* Mark the page dirty only if the fault is handled successfully */
>  	if (writable && !ret) {
> -		kvm_set_pfn_dirty(pfn);
> +		if (page)
> +			kvm_set_pfn_dirty(pfn);

If kvm_set_page_dirty() is changed to be less dumb:

		if (page)
			kvm_set_page_dirty(page);

>  		mark_page_dirty_in_slot(kvm, memslot, gfn);
>  	}
>  
>  out_unlock:
>  	spin_unlock(&kvm->mmu_lock);
> -	kvm_set_pfn_accessed(pfn);
> -	kvm_release_pfn_clean(pfn);
> +	if (page) {
> +		kvm_set_pfn_accessed(pfn);
> +		put_page(page);

Oof, KVM's helpers are stupid.  Take a page, convert it to a pfn, then convert it
back to a page, just to mark it dirty or put a ref.  Can you fold the below 
(completely untested) patch in before the x86/arm64 patches?  That way this code
can be:

	if (page)
		kvm_release_page_accessed(page);

and x86 can do:

	if (fault->page)
		kvm_release_page_clean(page);

instead of open-coding put_page().


From a8af0c60d7f6e77bbc7310d898211c43ae075cf8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Dec 2021 11:40:58 -0800
Subject: [PATCH] KVM: Clean up and enhance helpers for releasing pages/pfns

Tweak kvm_release_page_clean() and kvm_release_page_dirty() to avoid
pointlessly converting to a pfn and back to a page, and add an "accessed"
variant that will be used in a future arm64 patch.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8eb0f762a82c..f75129f641e9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2876,29 +2876,37 @@ void kvm_release_page_clean(struct page *page)
 {
 	WARN_ON(is_error_page(page));

-	kvm_release_pfn_clean(page_to_pfn(page));
+	put_page(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_clean);

 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
-		put_page(pfn_to_page(pfn));
+		kvm_release_page_clean(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);

+void kvm_release_page_accessed(struct page *page)
+{
+	mark_page_accessed(page);
+
+	kvm_release_page_clean(page);
+}
+EXPORT_SYMBOL_GPL(kvm_release_page_accessed);
+
 void kvm_release_page_dirty(struct page *page)
 {
-	WARN_ON(is_error_page(page));
+	SetPageDirty(page);

-	kvm_release_pfn_dirty(page_to_pfn(page));
+	kvm_release_page_clean(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_dirty);

 void kvm_release_pfn_dirty(kvm_pfn_t pfn)
 {
-	kvm_set_pfn_dirty(pfn);
-	kvm_release_pfn_clean(pfn);
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+		kvm_release_page_dirty(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);

--
2.34.1.448.ga2b2bfdf31-goog
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

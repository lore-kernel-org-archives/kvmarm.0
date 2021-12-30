Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA42C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Dec 2021 19:22:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BAA849E43;
	Thu, 30 Dec 2021 14:22:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eoERlxuZfCtn; Thu, 30 Dec 2021 14:22:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61B2449E5F;
	Thu, 30 Dec 2021 14:22:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFEE049E48
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 14:22:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id esJ2vZtZf++h for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Dec 2021 14:22:08 -0500 (EST)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBF2749E43
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 14:22:08 -0500 (EST)
Received: by mail-pg1-f182.google.com with SMTP id 2so22125502pgb.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 11:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+mUtf+fyGiADPbbqXLfJ2sL02qx3ygRddOMW9sXf8kM=;
 b=qYXQziX8Y4uSkN040i7HBoI+oOa5SoCNkcWtGdUmcaVUSstLVl7gjpPgN9I/OoARfE
 KjkW+I046/rYUv1v3APDx/Orq2Nt9ZeKIp3PRzYwJRd64RpLurzxMkknbVxu0xNDwQDn
 50LTDe0upNYikY2C6vPWerGQDhysdRq+djOm54cB5o4CjtRcotc142F91z0wCYx8bqGk
 XgdYkMz6tAw+U94B+KK7gnXjHlybHc8TRakh8F+8cAd/GXVkXUPLgNxDZ9ZWiwmnlgox
 Hm0QcKqPaNCBggoIZbMN/bpj/y57MIO0Fgkz/Oza03FYClq7Ebcx4RjEeQ0izeTDrPMk
 10Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+mUtf+fyGiADPbbqXLfJ2sL02qx3ygRddOMW9sXf8kM=;
 b=Z6jF4rI+Zbz5mOe2U1bGNPRfXOAI/FMsdck+4SRGymIG96DAhQtsSSprU27fD156pN
 7qxpJgq8I4iMG2JATPvDcEmwJQp/rgpCWYHPDZFQ9tGlPfrHk+UdwONQz/hF3bAeHeWt
 qw+EvgKH4vtBBuPMWwYAu9phXAyfqNL0tYxJfFW777KKjmqattG1qLxgA9rVfPq1A7XY
 fJa4jigaUhulD3DPsisNAyo64skq7SpqhtqDJZaM+lKEHeg8h7N0/fqQh3xYHwr5zrCS
 5clGsmmcfOhlgN3WitWWwTdSTztwaqqFWYyC9sFZx2TLYZTIcQx4/uHD7hSD2l8W4gG5
 MtwQ==
X-Gm-Message-State: AOAM5322LG0Tfm7u8XNZzj0e7MqRBQlhrMNcLmePE6Xlz9jL3Vy/BzQn
 zTXF+xtMLhkDGdgaJ7OcOskYuw==
X-Google-Smtp-Source: ABdhPJzo2qQot4YYh2sqOX2qDnTi34IfdYiH4bQr7iMKVzwbD0LQ1vHOEabmj42ZSrRvPHU7s6Gubw==
X-Received: by 2002:a62:1dca:0:b0:4ba:cfc4:1af7 with SMTP id
 d193-20020a621dca000000b004bacfc41af7mr32929296pfd.58.1640892127817; 
 Thu, 30 Dec 2021 11:22:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id i68sm18735930pfc.151.2021.12.30.11.22.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Dec 2021 11:22:07 -0800 (PST)
Date: Thu, 30 Dec 2021 19:22:03 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
Message-ID: <Yc4G23rrSxS59br5@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129034317.2964790-5-stevensd@google.com>
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
> From: David Stevens <stevensd@chromium.org>
> 
> Remove two warnings that require ref counts for pages to be non-zero, as
> mapped pfns from follow_pfn may not have an initialized ref count.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 7 -------
>  virt/kvm/kvm_main.c    | 2 +-
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0626395ff1d9..7c4c7fededf0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -621,13 +621,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>  
>  	pfn = spte_to_pfn(old_spte);
>  
> -	/*
> -	 * KVM does not hold the refcount of the page used by
> -	 * kvm mmu, before reclaiming the page, we should
> -	 * unmap it from mmu first.
> -	 */
> -	WARN_ON(!kvm_is_reserved_pfn(pfn) && !page_count(pfn_to_page(pfn)));
> -
>  	if (is_accessed_spte(old_spte))
>  		kvm_set_pfn_accessed(pfn);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 16a8a71f20bf..d81edcb3e107 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -170,7 +170,7 @@ bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
>  	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
>  	 * page_count() is zero to help detect bad usage of this helper.

Stale comment.

>  	 */
> -	if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
> +	if (!pfn_valid(pfn) || !page_count(pfn_to_page(pfn)))

Hrm, I know the whole point of this series is to support pages without an elevated
refcount, but this WARN was extremely helpful in catching several use-after-free
bugs in the TDP MMU.  We talked about burying a slow check behind MMU_WARN_ON, but
that isn't very helpful because no one runs with MMU_WARN_ON, and this is also a
type of check that's most useful if it runs in production.

IIUC, this series explicitly disallows using pfns that have a struct page without
refcounting, and the issue with the WARN here is that kvm_is_zone_device_pfn() is
called by kvm_is_reserved_pfn() before ensure_pfn_ref() rejects problematic pages,
i.e. triggers false positive.

So, can't we preserve the use-after-free benefits of the check by moving it to
where KVM releases the PFN?  I.e.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fbca2e232e94..675b835525fa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2904,15 +2904,19 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);

 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
+               WARN_ON_ONCE(!page_count(pfn_to_page(pfn)));
                SetPageDirty(pfn_to_page(pfn));
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);

 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
+               WARN_ON_ONCE(!page_count(pfn_to_page(pfn)));
                mark_page_accessed(pfn_to_page(pfn));
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);

In a way, that's even better than the current check as it makes it more obvious
that the WARN is due to a use-after-free.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

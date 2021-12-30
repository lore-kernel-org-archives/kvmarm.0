Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49123C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Dec 2021 19:31:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5E7A49EBD;
	Thu, 30 Dec 2021 14:31:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pBuYTJZmHfMZ; Thu, 30 Dec 2021 14:31:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7FD149EB3;
	Thu, 30 Dec 2021 14:31:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F07FA49E43
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 14:31:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mKnxxNZm8CUc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Dec 2021 14:31:01 -0500 (EST)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08A4C49E16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 14:31:00 -0500 (EST)
Received: by mail-pl1-f171.google.com with SMTP id l16so6773593plg.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 11:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=FYXvglbGqKa6MDTBbtApQcpspIcGTQNntrmktbwch7M=;
 b=q+u3LGjWTXF+/UkU1WEUFXFDVgUnuMGd98HfbtIuFtaohdCzdt1lUbN5XmbY/5A0Pc
 WkRa2/FXd9RP0uvpVenO/q7UTfL3MvHmp68TxNYmX5Atjg7huB0qoxS5800TvmF9hSVW
 MwnYHcWP5TdHI/YuNnMDpFJre/nJor6vhNEolXtYcWFd6zItCBwlOkZ4IOk4eydXyIJr
 jZ6R4cWla/pN3Fy8kjX/bxMwmotBloLDhJnjpNoys5aLPq/kXc5XYv3AeY6QH2IEUzGt
 k7oDX0VR+ABhKp3CynFnyI8H1hVvLh9uM+P/IujXOn6FqcxljG7ZnnXju7UJKLUUcrUk
 NyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FYXvglbGqKa6MDTBbtApQcpspIcGTQNntrmktbwch7M=;
 b=BtSdy8xreMmJ34OXf2IIp+a5tz6msjAjSuc7xcuu2J4rIQvWqVI37KaYRGOHbKoF5p
 jrDjkcMYgPwmkoOTBw4z2wvmYoD27t0sA4FDGm6/rEQVCgkNECSlTQQwHIz1fGLuddfA
 A7GqfozQ4q79UnVfpaMu0arq67kGiO+BKHcrWdhHKZvviZ2gyC/eJaoy5ynD7f95HvNb
 uD/X2AhzQ8E1tN8ebqQ5YEz5Hega3bEhuyL9YdAxsAb22lAw7JoczNf4cYBtPKdq6gvn
 W5WWLnynwQnNnk2uRuji77TzmfXx4K3BrLUVEQbZ3Y3ipCsPGjnGnS9arEGonlIj+X/v
 egVw==
X-Gm-Message-State: AOAM533kcADZWbQ/1I9SjhtRNM0VCV9D7988j2QE4k1U4t9CGeMlvUUy
 t55QUbSVlOzWOUV+HMvhxuUqBA==
X-Google-Smtp-Source: ABdhPJyYaGGC1njX1Al9c7/uvjjSt874CgyQ2TX9yQVKQldZnTwzxV1a5jQ+vjYlCk1TOSPZQNh8HA==
X-Received: by 2002:a17:90b:20b:: with SMTP id
 fy11mr39658469pjb.238.1640892659992; 
 Thu, 30 Dec 2021 11:30:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id e9sm23554274pgp.39.2021.12.30.11.30.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Dec 2021 11:30:59 -0800 (PST)
Date: Thu, 30 Dec 2021 19:30:56 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v5 2/4] KVM: x86/mmu: use gfn_to_pfn_page
Message-ID: <Yc4I8DNgQjomsfrc@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-3-stevensd@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129034317.2964790-3-stevensd@google.com>
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
> Covert usages of the deprecated gfn_to_pfn functions to the new
> gfn_to_pfn_page functions.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu.h             |  1 +
>  arch/x86/kvm/mmu/mmu.c         | 18 +++++++++++-------
>  arch/x86/kvm/mmu/paging_tmpl.h |  9 ++++++---
>  arch/x86/kvm/x86.c             |  6 ++++--
>  4 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 9ae6168d381e..97d94a9612b6 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -164,6 +164,7 @@ struct kvm_page_fault {
>  	/* Outputs of kvm_faultin_pfn.  */
>  	kvm_pfn_t pfn;
>  	hva_t hva;
> +	struct page *page;
>  	bool map_writable;
>  };
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 04c00c34517e..0626395ff1d9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2891,6 +2891,9 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (unlikely(fault->max_level == PG_LEVEL_4K))
>  		return;
>  
> +	if (!fault->page)
> +		return;
> +
>  	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))

These two checks can go away as they're made obsolete by the new !fault->page check.

>  		return;
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

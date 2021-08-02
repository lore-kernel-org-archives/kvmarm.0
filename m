Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E98C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 14:53:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38E8E60F9E
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 14:53:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 38E8E60F9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A84534A4FC;
	Mon,  2 Aug 2021 10:53:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J8Wl+yvdUOpN; Mon,  2 Aug 2021 10:53:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0FB94A49C;
	Mon,  2 Aug 2021 10:53:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0DB149F82
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 10:53:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FHxVY0ofxxi2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 10:53:08 -0400 (EDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com
 [209.85.218.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8EBC405D8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 10:53:08 -0400 (EDT)
Received: by mail-ej1-f53.google.com with SMTP id oz16so31292219ejc.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 07:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=h2IiuJBcGGHlU+MZOjJcOdM9TvLs3ZLSnxY+XqABa0c=;
 b=USbbLnzqSe8hzqWM6MzvtVB4fSWYo4OClr3p9ww33ZPRsdM8MzcX/U7glKcc5rddND
 HlSvxeOH4qaLa+CbTy62XQzUpI6/GDhqUl3Raf1NKZgSSj4fDDUpHr9+1sEAiWsAenaZ
 IBPwEAMHf+4PBDzd/06RF7q5oYEOW7F5tjLioL8BXQqxLT2JB3YZO5VAOO+7xMcUSnwj
 9cTNw/c9HMe1miCLXfK2CBsy/RZu7J95iOEwE1oEVe6xo6m+akJWMQaqeX5IMLAh+6n5
 rv8uMfOYFTwjNgdDV016+hPQsaISP6NMFbMPdKBd4w6jZLjvmQ/Q4s1zdushGvo6wIYT
 rRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=h2IiuJBcGGHlU+MZOjJcOdM9TvLs3ZLSnxY+XqABa0c=;
 b=sZDyF2aWF0oeK1HN4AsDIDo/4bVbbT6XjbByig0VDPfJbyFe/keDGsF1EQvgmxAHVh
 wrikJtHY41HRnmKxUSFAjHYpBixfY3XqCOx/7oBkvJGbtSlasfnKv6McV9fFkbnVyDEE
 45i2Ch6WQ0qdJZm9zXj6EMJC6sRzYH+56MFiEM7NDYCA4CwoKI2LUvDHOCCr6AmRkaJe
 tYW+MUnROipKpO0jNnD4R1jw9CcY0gf9jhM5KapTL+b3fbaNE5ypGGpdee4Msm6+Dss0
 A86SNhFXaXC1HH0hBtLt7nj3bIjbKslMn06mbmIcuxL9IcgEjQKDsJm6wgIVGz+5CdYl
 gdMA==
X-Gm-Message-State: AOAM532gsjnUtSQcegICj1piPiYNkOl34nbS0a6q9kcH3qY5cLYtCoud
 yzh5z7ePK7am4RfQ3zdOP8vLdRUIyi8De1v4rXg0/g==
X-Google-Smtp-Source: ABdhPJyBbigDvWGHVWOmQazVw8pxVXKqhiol21T3Dx4QXWONixp+CbjlyQf4i6I2RwpRHQdtWK86vFVNoEXF75wGOZc=
X-Received: by 2002:a17:907:7895:: with SMTP id
 ku21mr15674328ejc.265.1627915987486; 
 Mon, 02 Aug 2021 07:53:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-16-qperret@google.com>
In-Reply-To: <20210729132818.4091769-16-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 16:52:31 +0200
Message-ID: <CA+EHjTxrdA3wVsBe7zwvvGUGgoWuaGwuWCBL0k2+FcAdTGB=Qw@mail.gmail.com>
Subject: Re: [PATCH v3 15/21] KVM: arm64: Introduce addr_is_memory()
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Quentin.

On Thu, Jul 29, 2021 at 3:28 PM Quentin Perret <qperret@google.com> wrote:
>
> Introduce a helper usable in nVHE protected mode to check whether a
> physical address is in a RAM region or not.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index cc86598654b9..5968fbbb3514 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -51,6 +51,7 @@ extern const u8 pkvm_hyp_id;
>  int __pkvm_prot_finalize(void);
>  int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
>
> +bool addr_is_memory(phys_addr_t phys);

I'm just wondering about the naming of the function. I understand what
you're trying to achieve with it, but an address without a unit that
conveys size or type seems to be missing something. Would
memregion_addr_is_memory or something like that be a better
description, since it is what find_mem_range finds?

Thanks,
/fuad


>  int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot);
>  int host_stage2_set_owner_locked(u64 start, u64 end, u8 owner_id);
>  int kvm_host_prepare_stage2(void *pgt_pool_base);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index bb18940c3d12..4532f3d55a1a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -196,6 +196,13 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
>         return false;
>  }
>
> +bool addr_is_memory(phys_addr_t phys)
> +{
> +       struct kvm_mem_range range;
> +
> +       return find_mem_range(phys, &range);
> +}
> +
>  static bool range_is_memory(u64 start, u64 end)
>  {
>         struct kvm_mem_range r1, r2;
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

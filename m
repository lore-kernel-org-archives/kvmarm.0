Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582A4BE58
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 03:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707795876; cv=none; b=FBw45Mz56iaDHXL+8BQCHG7Biou7nX8D14vcgSO9tXUCJqi46hzgVbTo2LQpI0XJ3JIHfmf3xUKlCWrEHgJBPHb+FEKVgcvN4pEdMNxYtvF3JSsH2LJ3V00kTxzw4R7eMFXA4zHE1N0+d+pa2RxFZe1SNPxrWqQn2QO+dm2EbgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707795876; c=relaxed/simple;
	bh=NFft8955xc//JP+9tYos6q1H02OG2foIYqmN54xxgZs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fQphrJalRnGOmYo4TRAs8xcT/Jh1Z9rid0v9FB1dlSw979U3qGgsUCimSC96swWHbl6Vu/SfN8irj9AEnmhwnafRcZ5xHNG1GIxGO14iucYV5MjB6HjeLrKs4iaHnnAhMN3HQygCvTjh4CyVByTx7EUcEcu50hOxTA/73bln5Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U/hmcsFg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U/hmcsFg"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26eef6cso755171276.3
        for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 19:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707795873; x=1708400673; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N11MwErRtXmGthDZPoYyY2IrTS7HYLtHkfcLyWP+24I=;
        b=U/hmcsFgQ2bE3Upv5lfTfTR44LyPvNzA+yYlK3zS+7BvG6AJi95uptvkzd9nIst7dm
         zuewtF/kvrquyqQuPRjB7eOPFZ3mHnJ4guJXlWt2Lo1x+TqfIqRQm72lwb+fPaSCPDWn
         KZQqpEV3R12dyZxV/DsfCv5ny8dYaXoXsdT03g8GTvhZC1i0UBWLSaaVuFkr5Mt/zQfZ
         zC0y8RuQtdV/im4/n2c5h/R8hlW0rltWobL8ZG4YggT8EG0PjLF5sooLKnnoV6V5ONg0
         8DJ8wsRO/BhFZPBw1BLnv6+7UAXL6sG2brnw8krUh0Yu07sPMLHmI2iDfenq6YXxfb+Y
         fxjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707795873; x=1708400673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N11MwErRtXmGthDZPoYyY2IrTS7HYLtHkfcLyWP+24I=;
        b=F1RQw8VCz5JDbtKPM0+ERbrWFyE6qVcTl4Ll5aZd4Sh5oYnmWgdsN/XKEufUGVlHx6
         H7ILkKjeKQRTMyMJI5VqfklpvSNJIGN4WnPkN/8avMSpz4DqLHPO3KFmn/YKhHbw8Nuz
         Hfw4ZDxVS3Lncz81AfMn1RxIIgMfafl1vsGaqqwJWvIoYlV7E2T2ovY6rftADk2cec4H
         cE+T/vkBxafjCr3Fk2j/7A9FNd1kDtH01cdzgya4XJ429F53sm96tdmf7rNmt0RBaXWO
         zQxymsI6NRcBJ8F6AcvR0e/d9MxCyIgBpVPOkqkvtMiNGXs7jC304Z0Do3zJ7JrMAHtK
         GRXg==
X-Gm-Message-State: AOJu0YxD9Fa3hzCyf1iB1MLrPJQeXQHpI9VJhgtHLYQGrBG9dHsjwVKx
	Kk7VmrHfmzPRhgNv9ZyfBEROjoV0Eur4zAu6EQfyQ1879TD/WJQIuDZAZVZ0hAZXdj20FFId7vM
	4UA==
X-Google-Smtp-Source: AGHT+IEATzkUDO8bqX//dpXzQGggLSlUu4TYjcCX/zo6GFWt5HMja8XHztRX4j6U/QY9m+38GBoTvYSjlMY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ae15:0:b0:dc1:f6f0:1708 with SMTP id
 a21-20020a25ae15000000b00dc1f6f01708mr312479ybj.7.1707795873299; Mon, 12 Feb
 2024 19:44:33 -0800 (PST)
Date: Mon, 12 Feb 2024 19:44:31 -0800
In-Reply-To: <20230911021637.1941096-4-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-4-stevensd@google.com>
Message-ID: <Zcrln-uslzS6x-wS@google.com>
Subject: Re: [PATCH v9 3/6] KVM: mmu: Improve handling of non-refcounted pfns
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 11, 2023, David Stevens wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c2e0ddf14dba..2ed08ae1a9be 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1185,10 +1185,31 @@ struct kvm_follow_pfn {
>  	bool atomic;
>  	/* Try to create a writable mapping even for a read fault */
>  	bool try_map_writable;
> +	/* Usage of the returned pfn will be guared by a mmu notifier. */
> +	bool guarded_by_mmu_notifier;
> +	/*
> +	 * When false, do not return pfns for non-refcounted struct pages.
> +	 *
> +	 * TODO: This allows callers to use kvm_release_pfn on the pfns
> +	 * returned by gfn_to_pfn without worrying about corrupting the
> +	 * refcounted of non-refcounted pages. Once all callers respect
> +	 * is_refcounted_page, this flag should be removed.
> +	 */
> +	bool allow_non_refcounted_struct_page;
>  
>  	/* Outputs of __kvm_follow_pfn */
>  	hva_t hva;
>  	bool writable;
> +	/*
> +	 * True if the returned pfn is for a page with a valid refcount. False
> +	 * if the returned pfn has no struct page or if the struct page is not
> +	 * being refcounted (e.g. tail pages of non-compound higher order
> +	 * allocations from IO/PFNMAP mappings).
> +	 *
> +	 * When this output flag is false, callers should not try to convert
> +	 * the pfn to a struct page.
> +	 */
> +	bool is_refcounted_page;

Idea.  Hopefully a good one.  Rather than tracking a bool, what if we track:

	struct page *refcounted_page;

and then make kvm_xxx_page_clean() wrappers around inner helpers that play nice
with NULL pages, e.g.

  static inline void kvm_release_page_clean(struct page *page)
  {
  	if (!page)
		return

  	__kvm_release_page_clean(page);
  }

Then callers of __kvm_follow_pfn() can do:

	kvm_release_page_clean(fault->refcounted_page);

instead of

 	if (fault->is_refcounted_page)
		kvm_release_page_clean(pfn_to_page(fault->pfn));

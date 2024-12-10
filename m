Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A021A0B0E
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 13:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733835624; cv=none; b=JH6VMxAWf4tdrBrGZtkr1cm+Or0+BLlUQke4BMMZfKMJWKgkX5VNqDI//w9ATD1HidkMotxLU1Hh+DGUCjDog038len8qM589FBDUmhyTA3yJOA4FyuDnpJ9aQgqFWtrpmuJaRhOiGcwHUToZ1VbZfwmVSdIqccUzfW0HOmEq04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733835624; c=relaxed/simple;
	bh=c8cbwyGc6qrvJi5SHhLFBunv5BEzFDk3njGVg7z2Hvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aR5JPqmI7nFtlSSJeaB5BHv1DJnENI4IwbOHFontuT3clb/EOzKX/e77hWDkM7iPi77PN8axxS62tJd2njLTsipiNdeW/7JFBYYCJiIkM85+nW7Tesk4gW5dci1mMs4yeqXRmAySSa3XUkeNYKnBYBd0cSqnQHGG0bEnqi7XV6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qYacjjLS; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qYacjjLS"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-434fa6bf6e4so33865e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733835621; x=1734440421; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hXgN7N+sfvyWYJUrx20Eam6+/moqssT/bJkQiBA9Rqc=;
        b=qYacjjLS+CcGKJZi2DXKYAC7BOzgbdy/tziFMCOEkiKBFQjk8Pxq2fAVEVnqybraVu
         +NsD7b3SY3X5Ee0WYHqXjVVbQ4HrnhR525+TjLukkO+zlhlkVxOcybtQmmYGWzHfV9tS
         /Ny4+No1lOf9EskWbQZzQ/ZHnK1KdZoBS9A9EXlFRkddXgGMAVnQX48vuZHui8jMMmQv
         TbdITL3NWyt7z9lAPtePprxZy5sZag+UtS8OjbrFsppmOornFl/4wzmMD4sdquPYMS7d
         ZuYjj22MxxfHzu9jHn+EDYyLdvtLduDa1IASSuKE4rwyz5fCbYV0IZIbsTJ5D6Mv9gOm
         rvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733835621; x=1734440421;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hXgN7N+sfvyWYJUrx20Eam6+/moqssT/bJkQiBA9Rqc=;
        b=XWvLUD/H/Npzcq0OlYjt09e5MqNRemTt++8ngifAQUs22r4iTV+s/Ug4x2SGNftj1r
         voxCF23RAna4Dd4TdMkhGJC9KXtpOyTC3jIz5Q22mOlJLntPSX9sp5HL4u3Mldj0hABF
         sbWDfTmIFeI58kgJiZS0RK5DSH7WaqRPXMIFWGjHSQpUDb/WyfYSFWMwvZLYlGRSMnpe
         YyQnihtnosJ8fdDlxsaBLyJtt6wa1P93HUJRo8ac8KjUxp22TaZDTgFS2iljGkk67TSX
         VZH2rvKH9fgHUhVkgY83kTKOGnHTpxJpYWewVk691SS1fL5wCa1jJfzyb3AdEB2FdH9u
         ci+g==
X-Forwarded-Encrypted: i=1; AJvYcCXOMybZ5WvyXeZ8vBBdWD0xnMOc0yFglZA0eInXF6T8eOfB9uT6gz+B/DwJidVQ7S0TEToduMc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSbTPMU8fS3xKTRpHtClG63DD4zpxQEJbiX8DHxFgW4JrzFve6
	nD3PbNmm9m9zvrZ96F/vi/oq0kPtFe/CTsOTmWy0PX2ZIXzTJA1o2kk50ejw9WVsHECvp1TvrWR
	4R7OXwyXeN9NgDM6DUBUlBgf7jPHgTiInUfTT
X-Gm-Gg: ASbGncsJB7dIYb+QpjQIR72ZthYOarIrnuVENt2NZmtaUEByvIbkFr1bKKwJ/qozZZe
	w426HWNmARQ7arUNtqweKvezsCfyQ6gJsHnDO3zmv+gn7AzwvSBKs1s1kD72SGkEn
X-Google-Smtp-Source: AGHT+IGaGhDWDnawra1F1/dbQTTbNMD9zXwWoIQ2OEhqZyNYqK9fVKTHmmaCrYxgr29shZgJAAHaKKezDZL8LZSStsI=
X-Received: by 2002:a05:600c:6b06:b0:434:9e1d:44ef with SMTP id
 5b1f17b1804b1-43539dd9773mr1029035e9.7.1733835621326; Tue, 10 Dec 2024
 05:00:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-2-qperret@google.com>
In-Reply-To: <20241203103735.2267589-2-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Dec 2024 12:59:44 +0000
Message-ID: <CA+EHjTxfchr+ggO_z_zrrFTrFpS3oTJXt13t-854xWxYY=oSQQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/18] KVM: arm64: Change the layout of enum pkvm_page_state
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Tue, 3 Dec 2024 at 10:37, Quentin Perret <qperret@google.com> wrote:
>
> The 'concrete' (a.k.a non-meta) page states are currently encoded using
> software bits in PTEs. For performance reasons, the abstract
> pkvm_page_state enum uses the same bits to encode these states as that
> makes conversions from and to PTEs easy.
>
> In order to prepare the ground for moving the 'concrete' state storage
> to the hyp vmemmap, re-arrange the enum to use bits 0 and 1 for this
> purpose.
>
> No functional changes intended.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 0972faccc2af..ca3177481b78 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -24,25 +24,28 @@
>   */
>  enum pkvm_page_state {
>         PKVM_PAGE_OWNED                 = 0ULL,
> -       PKVM_PAGE_SHARED_OWNED          = KVM_PGTABLE_PROT_SW0,
> -       PKVM_PAGE_SHARED_BORROWED       = KVM_PGTABLE_PROT_SW1,
> -       __PKVM_PAGE_RESERVED            = KVM_PGTABLE_PROT_SW0 |
> -                                         KVM_PGTABLE_PROT_SW1,
> +       PKVM_PAGE_SHARED_OWNED          = BIT(0),
> +       PKVM_PAGE_SHARED_BORROWED       = BIT(1),
> +       __PKVM_PAGE_RESERVED            = BIT(0) | BIT(1),
>
>         /* Meta-states which aren't encoded directly in the PTE's SW bits */
> -       PKVM_NOPAGE,
> +       PKVM_NOPAGE                     = BIT(2),
>  };
> +#define PKVM_PAGE_META_STATES_MASK     (~(BIT(0) | BIT(1)))
>
>  #define PKVM_PAGE_STATE_PROT_MASK      (KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
>  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
>                                                  enum pkvm_page_state state)
>  {
> -       return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
> +       BUG_ON(state & PKVM_PAGE_META_STATES_MASK);

This is a slight change in functionality, having a BUG_ON instead of
just masking out illegal states. Is it necessary?

Cheers,
/fuad


> +       prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> +       prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> +       return prot;
>  }
>
>  static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
>  {
> -       return prot & PKVM_PAGE_STATE_PROT_MASK;
> +       return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
>  }
>
>  struct host_mmu {
> --
> 2.47.0.338.g60cca15819-goog
>

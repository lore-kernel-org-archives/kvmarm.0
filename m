Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B7642AA1
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425025; cv=none; b=OvzyZzvMsQFyhu/DlvGBqajivSNEeZ3QRTi8Jczl2UeZBZ4Eql9uhHjmBBfLCblIRktHanQCOCcSKiZ5GzveLSgh+GbzAuFCCSoBIN7MMDsAQl3XONHzQOct2ygeM89W0yQYgc+CqWXX4bTfRnVvh3ROKoIzIOYIWC1+h0Tz57s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425025; c=relaxed/simple;
	bh=Dh0Ctz2vowSmtTs36YbhCWvch6CdaR0SnXYuH2Kk708=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UHPQZblalQd/agKjC8LO66esFg/RwBzvTO86EDWW3ZbffFB0hlR2zINaI0cq2yTFXBcHzNTyhE42qRTlrXnZNm+FiU/Qoqm13GcGAq80ZET5ZJTWTDYYS6yw8v1TOzeEi3hZTqPP27+dNwB5PmINCZCvztwuimZPduKSnDyE4Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qLAyW/nH; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qLAyW/nH"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43622893c3cso26335e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425022; x=1735029822; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d00JPz9uD5IVTXLbqjCoJE43ltdbYjCzx2p8kqI3aJM=;
        b=qLAyW/nHn2cDIt1lG1qSU3aoo1igBjnjMM4diEwREqqMwX4zxLdoUI5oEF5jal0K7O
         8GJf4/cN0aNhfZzaPmBR2lzEzoKeX9ugS2PTxyuD1/eyo997OePnpx6hsPODGh4XY5uE
         0HJkEUUhSsiudo925shQJe2Mft8euPbVo1QDJCG0ed+/IYHRUAJwXGgYorNKqr+rqSah
         9wFoLcBBYPUPW9FiYWvC2frK5SpFKIGxpIyGKO5bfaX7PV9IoxY6X6Qw9Sp2qaSfWuK+
         qOg80cW4onx/AC+gLKsog/WSZHEv09yWmneIBWgcFVNbvbGkvsqJLj3098khquxGMfnK
         7T5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425022; x=1735029822;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d00JPz9uD5IVTXLbqjCoJE43ltdbYjCzx2p8kqI3aJM=;
        b=jsOFK76xnrmBgVnB5jBo5eUn+SO48rV1w56ewqY4nrMB/9iPJgFZlfJ3Hsuhh0ikRE
         uqdrLqmW1FrCgvKIa1pm4l+Iax85Tudc3lqHQxu9vgltZq0J38NyIa84mhnaRAiPrwl/
         H+4pZtC6/yjgA/KTa11j/HInVsEHlEKYj6/dw+FEwqaRrx/B9h1AhMaVMK9LT9PW/zk8
         VTvXYJA1xszoWlxtNrj2phRnE2dgw/8mcdX/pozICJ9rLu5fhSdbgjRSbx9Wqjpp1KY5
         iFscuZqBoCSOuWVOjTNSYAMNYkmcS+DLz+5avcjtzjE3DywuzWkbDQoQtmgb+/qMCHl0
         fS4Q==
X-Forwarded-Encrypted: i=1; AJvYcCW01KUZ9VhRIe9b9Qd2IOw9PPbcKuv0n8/ln1F8lz+7IXJeOHxBryXV8M+k/suwAiVJCiNjx5I=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywm442Uj/oTBiCBeCAmgh1koSB6iyN8XKGRofzYV1Z5GDHa2mo9
	kTs+i+YHPE+u2jNgFWreKIBzG6ussCr9E8Onw1+0T3i74EHkE3cjzwTe58Ms93eJq4CpvSzAq/l
	oJRivp1dLZVrsdAGLezq+w1uxNBYkSyqEiB1U
X-Gm-Gg: ASbGncsqReJ9zpw8tKG3llaH7bkI2WKfaspY+9v8vjIVFVNYb06vq5PHf4kBbmfOgm1
	T9LXr/DSMiyo3xFYz6Yu5lbLqwjHwLeHQ6xBrpF4rGC5hRmyCoUIQvo/Yb9Oipyu4LFc=
X-Google-Smtp-Source: AGHT+IEsm2ztvlxRIl5e4zdw11F91muRBnmV6gL9hKtcRS9F1Dhy25XfzClb2ijrhja7+oQZG9pObyx3mcUaDBXuJjA=
X-Received: by 2002:a05:600c:5690:b0:434:9e1d:44ef with SMTP id
 5b1f17b1804b1-4364ad4d797mr740325e9.7.1734425022162; Tue, 17 Dec 2024
 00:43:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-2-qperret@google.com>
In-Reply-To: <20241216175803.2716565-2-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:43:05 +0000
Message-ID: <CA+EHjTzYA5tFSR8YUfuEGzPjDYnp1a+T=K6AfwjGUVmxcQudjA@mail.gmail.com>
Subject: Re: [PATCH v3 01/18] KVM: arm64: Change the layout of enum pkvm_page_state
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
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

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 0972faccc2af..8c30362af2b9 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -24,25 +24,27 @@
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
> 2.47.1.613.gc27f4b7a9f-goog
>

Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AC11DDC33
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425346; cv=none; b=T8l1UC/ypfnYKM1CjIQz0m6EkRowqR6FjuQSKoKw+m09puOmYcd77pYJH/6hy1l9wFko7G6pCNZJMP5oh7Np53GTDkZRbWRhAxx0qRrI0agRMYx1+h+d+EH0LzSTmLYgGEkq3xx62H65XQIRHkDYM56WCNoCnKsccgPXgZZRb00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425346; c=relaxed/simple;
	bh=0VUvLaeI1jcSJGzPxHY0N25cfAWXw/BqQdLY1b0053U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I3mmNNX4gIh8TPXJ0YdcfLZAaG59oLPBr+0byINOnUHe+ssu6JDIg5NYyiodegO/8FI/1chxSSKodgGHb/JwC24fsrTMyLZGE8y/9jfSt+Qy/Gz7naeIwMAdX4ssSsPPjDyv+1vp751HQToaBwjaGsWJfg2Jrkq7Igo6pHDqQLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bIBUSNtI; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bIBUSNtI"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43622893c3cso26745e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425343; x=1735030143; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4gjynL615gvuMEubyjzZgIcz73t6loj7FWYasvQLRBg=;
        b=bIBUSNtIEdbVcp2YJVNMPQ5isbse/GxGu4oqA9EviX2ZL/c42L5iILUYCH6tTIwPZM
         nXPoCCcjOMmxdfxobGPQQeFCHuAI6XUeE7XNGgrDTf3kduhNiMfugOsSlmgT2wav43GE
         L6ai80Eysx4L6nDt34pcUPhJfpPYCVamCKxCIOhpXanDlvxzebR47KnJREA37boHRxft
         B/z8/gGNLZ8M4SIoP86kIt7CLuwnFdBKe0PnJWmnsc9ZgioIVgNQlxrYA7Tapz47mjdp
         kOTZeFp5WgWG+xdfdXblkMlpFsvR0TlBNVHZpWfON2YLEnxxFWk+jyzQ80a6YcYXAoHX
         049g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425343; x=1735030143;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4gjynL615gvuMEubyjzZgIcz73t6loj7FWYasvQLRBg=;
        b=AUCn8rz2BQDjFUBG++5+bEWVXfrq4ATSF5pQW/B7tMQwIOs2WWXAJ5T/aEYEOJDSfQ
         NOBTFNsneU7XbnnZ16UAV76fUOqgMzFRFnG/j2PJ5iDCRzde0PEQOZgNmGIrd6wuDibf
         mOVT4FHNtIUoD/O4DIhxYE5D83/9z0+9ORy7gxF4D3AKbdBK0q6Y+rr42VqicfpEWCg6
         gs7ICwQrzqpMYgUBd04J+rlCD+038U4/pfNlK69/antjzAnCR+/aPEFF5FSjOYpvgeNk
         ekj3Et8tSbjRNFOAhXvb1IAHipD0QCvFHT6Ia4iNruPw0a8rbGsz2aNrs9I1AFji7PKh
         xBgA==
X-Forwarded-Encrypted: i=1; AJvYcCXifS2UlbRu89xDGT7zC5vs7b1J2VVyg36E5IKBKLiZHegydQF7ts11zRHICKuXtViLhw1BJes=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6E0p3xo4Xy91Z8OAO4bAKADTmsNR0ikQGVBNjKV/vOiTo2ueU
	q5wQMgg22QT5vUKmUmKkUtWTdx2D8FiyAouGnuZKN4fhxVC2YEeOysXzftZRSznod95bo8HCKKr
	upxrpqUkn1+KZgPbIiWCfCZkQPPTcvngXiGvH
X-Gm-Gg: ASbGncvth65071kjARkqIM8f6dDaUn7yhqSFqgx9q9YG1iiWhY+IwoD5Yx0bA0c9ZxC
	9tI+woRhDckUCIOGSpacZOKJ1MtDz4rC+nZiMPK+hzKd3jH6sqP8zR80bp1XB1FCVxh8=
X-Google-Smtp-Source: AGHT+IGAI2rWVb4Uka3Gw6cExIudf/OJEn5z1n6O5hn8Pif2f/f8zmfBayaqT+8yKyhtBHAyACTgJA5pJBzp//b6lyU=
X-Received: by 2002:a05:600c:5741:b0:436:1811:a79c with SMTP id
 5b1f17b1804b1-4364ad4db33mr735715e9.5.1734425342932; Tue, 17 Dec 2024
 00:49:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-8-qperret@google.com>
In-Reply-To: <20241216175803.2716565-8-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:48:26 +0000
Message-ID: <CA+EHjTyYy6JxL0EH2=_VQe8+Qz7iCndPaU0C8gH69UnSkKhgtQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/18] KVM: arm64: Make kvm_pgtable_stage2_init() a
 static inline function
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
> Turn kvm_pgtable_stage2_init() into a static inline function instead of
> a macro. This will allow the usage of typeof() on it later on.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c2f4149283ef..04418b5e3004 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -526,8 +526,11 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>                               enum kvm_pgtable_stage2_flags flags,
>                               kvm_pgtable_force_pte_cb_t force_pte_cb);
>
> -#define kvm_pgtable_stage2_init(pgt, mmu, mm_ops) \
> -       __kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL)
> +static inline int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> +                                         struct kvm_pgtable_mm_ops *mm_ops)
> +{
> +       return __kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL);
> +}
>
>  /**
>   * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
> --
> 2.47.1.613.gc27f4b7a9f-goog
>

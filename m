Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BB63B6370
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224805; cv=pass; b=b5StwiZIG0MvZ3yLE7GUFMB8WJGtsJ4ZOvQxc7X4uov3k5IlOzr8IWbhraZ6Rfoetf2lKrmKTHh0MqCXT6Shh88PdMyxGcNiK4omqewP8fd+z9wyckQqxqH25qgbWAv79z+jspONcqgoZ43otVUTB/WdAF8/9gEIURRapl+nlyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224805; c=relaxed/simple;
	bh=0Y3vz069oVkYOci1zdmdl71zlGS/8x6s/8fW87Mj0hQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MrdSYnqnDtQ/6SuGlCgD3b99+Oqy18WRRgMBI+rNESnNfwzP8Ogd4hG4ulNlZwo/2iFh2oapTCeLIgNalV/upjqq+IipFuNRrNQeB45g+XN9pJLLpack5i8AZY3K6lrlsHDmmc59SCZN/U5IECrUeqS0U5zlWwlrWEMBldsoSFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1043QGLC; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1043QGLC"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5091ed02c54so405091cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:26:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224803; cv=none;
        d=google.com; s=arc-20240605;
        b=CJ/DNeX+eLhTXaacxE/j1ae5zncP1lIdPBiRF+bZ34dWzl5MlRp3FwtScsjY+xrbwE
         ciuJupzfYM0/zT2mNJqBxEeZ9oIl3RK3D+KwyWAvFLu5qvGXlfXiLZLm1Irf1z3EFSOq
         UR/VX1mmDQ8mVpF+0lMEEY/IlCuN3HlCm7CZ5oLIKiofyJhZmHcg7w+OSC5Z43ZgOMMr
         3ZzLodHHVxoaUlzT67sKI+Es5zD5zuI8A4itIj7Nep92Wh6IqbLnlngBNNAzVAQKmFd9
         LWrlF3TzZMD8DZ11XAzyZYBam08ZNi+DFIEX32tj1QjX95kwBflOOFJCBt6gGKj8i5kf
         gzOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fmEJEiWdI/ndYS6mHJYLRy1VeeMXyLew6WklNqnDoTI=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=AOfyyXc8WkOlzuKgUMkL/ZblelER3/ctU1rdW3bQftRS8L0dpWbVMwVcJTkqmM+mpl
         z5pZ++a0qG7inYXyKcDH63zqejDjx61SCNic2AtaV2XCAlj0NMqcngt27civGcTMoOqD
         mg/Fkrxy3UOvq1pzPSTRPRL6Uo3qMsH9HBGjGIwxM9bi1CdyQpM7nThtBq9Ti+93nrL0
         ID1TZ/y3Z/FjYxVRsF0MgZnvwdEu+whEXA5HZX4YJPDu7I+A4IQo5+hJpEZZV1pMfLHD
         2qhfCtnnRylmG611aEe/lmLHBTXIx4v0juw6bDqhwTBb3+uMTgaVSEz8xBQNQQMM38l4
         cKXw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224803; x=1773829603; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fmEJEiWdI/ndYS6mHJYLRy1VeeMXyLew6WklNqnDoTI=;
        b=1043QGLC3Z/LglRzspFYzddLJGC+QqNhxYclh0WK5a5xKSh3nlxvSxaZGM2Gp4d0mP
         hbchHlxsHnNq04IFWkhmnC72PJnzg68/91rQPf/54JylfMJB/MBMqiqQhZ1pqR6cjTM8
         WwQjYqa2O8KpBIuV3aOC42Uy1PW48enhQCaR7CK60wALxVHZqS8SJrX5MiJbcsBeURAi
         6k071JhafmZE6HtYo+f9Arj69B9m6rkF8pyOeEnuGqGEDCoWJtd5CJ+2bY+2yA7nOpgT
         o91x924QuqEO7JyPI0yIgU7AwUCkhyvYr1q4xoL2O+14kSWoeW53GKG1dJEXcmCYcvg1
         y9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224803; x=1773829603;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fmEJEiWdI/ndYS6mHJYLRy1VeeMXyLew6WklNqnDoTI=;
        b=AX4h1vGBiOHBgDHnZRcBfJy9varg1J6OqvIN/MXrMgsSqSa+33z/GaNFXJTQk7dDsa
         3dTJXYPCkaF1CeNgR5VoxPjanfOO3Vati8yGxOGTX20MIkhWg3nlETy1wTnB9IFQggpw
         q2EsDkLmi70vFUVw4l2AIkYckOQZGZhyXeuw442RV0YBuC5YBOSTqLUqZvHDmEheb2zk
         ahbsj5O2MlZL3fecuv6tWKzuyTnLyDT10EW4o50z2eOOuMRSmIAFxDfuy+4D8fbkEY+F
         8VM/pRm06jwQqM2cA4hbeQNa8Xhx7VrdI721YxayPU4OED2U0do22Cq9YTEbL/n/ZkYg
         qnVg==
X-Gm-Message-State: AOJu0Yxn78+aNffbvmURF8EDc0RS70ikrfctCnGUL4DqZjcW7BXBU8S9
	ys0n5eG5ETSYeAPFWBE24gNkixWy9SeluvHTXpkEr59f6fDDpyuwdq3DAEqXOUoZjKxeM1Z+CX7
	IOSNKzaoM9nS0K1kJHddr483C4FZIgFXrYXazBlnI
X-Gm-Gg: ATEYQzwPwynVsodZAxJfejVsRHczNZey8SVIOWF2/XohzLFrHVH5uL8CZE23LLPPg8C
	Mpb4V3dpDuqjR8wtMiljGq2wBbLlsK/lwcQgLXsIKo+az+2kLyJlePr17tCUfa+9cCQqA8bBc8U
	EUgKIwg2Rb7UiGvgNErUxg0y2pNcaUXPZBPO5xU2sdoLt6FkRdwGF5AA44Eknd86XzbUIxmOLKA
	tsA8T0uLT9oS5+t8B9Fsc0ZULQq1og+T+JHi3MoVgXPBdkM8RiB3HO4YbqAk+3GKFZRe/jF+FJD
	OibZg5wevSw5/hL4I2I8j8Z0qu9q4Uou+jXDkTIp6kIEEwZM
X-Received: by 2002:ac8:7dcc:0:b0:506:a3c8:d44d with SMTP id
 d75a77b69052e-50939a11387mr9323501cf.9.1773224802760; Wed, 11 Mar 2026
 03:26:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-37-will@kernel.org>
In-Reply-To: <20260305144351.17071-37-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:26:06 +0000
X-Gm-Features: AaiRm51zEMoCeXfjJ-x-zNdci4ij7U1702jzJU-AnR7k6Sx6ZBflApT7dTXZez8
Message-ID: <CA+EHjTxAZEtw=3wjxONDDpVHei1-E9dR3L-kOweUzctdPBLaAA@mail.gmail.com>
Subject: Re: [PATCH v3 36/36] KVM: arm64: Rename PKVM_PAGE_STATE_MASK
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:46, Will Deacon <will@kernel.org> wrote:
>
> Rename PKVM_PAGE_STATE_MASK to PKVM_PAGE_STATE_VMEMMAP_MASK to make it
> clear that the mask applies to the page state recorded in the entries
> of the 'hyp_vmemmap', rather than page states stored elsewhere (e.g. in
> the ptes).
>
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/nvhe/memory.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index 4cedb720c75d..b50712d47f6d 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -37,7 +37,7 @@ enum pkvm_page_state {
>          */
>         PKVM_POISON                     = BIT(2),
>  };
> -#define PKVM_PAGE_STATE_MASK           (BIT(0) | BIT(1))
> +#define PKVM_PAGE_STATE_VMEMMAP_MASK   (BIT(0) | BIT(1))
>
>  #define PKVM_PAGE_STATE_PROT_MASK      (KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
>  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> @@ -114,12 +114,12 @@ static inline void set_host_state(struct hyp_page *p, enum pkvm_page_state state
>
>  static inline enum pkvm_page_state get_hyp_state(struct hyp_page *p)
>  {
> -       return p->__hyp_state_comp ^ PKVM_PAGE_STATE_MASK;
> +       return p->__hyp_state_comp ^ PKVM_PAGE_STATE_VMEMMAP_MASK;
>  }
>
>  static inline void set_hyp_state(struct hyp_page *p, enum pkvm_page_state state)
>  {
> -       p->__hyp_state_comp = state ^ PKVM_PAGE_STATE_MASK;
> +       p->__hyp_state_comp = state ^ PKVM_PAGE_STATE_VMEMMAP_MASK;
>  }
>
>  /*
> --
> 2.53.0.473.g4a7958ca14-goog
>

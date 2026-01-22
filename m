Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6993B30596F
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094582; cv=pass; b=BOf76jfj1Z9z6MPv+VzHg8JSGd6854ZYeqNlZKyWe4S8MM51op7PT5tikZsdEmxxFxZBEhHFnyZ/Sx5RWihYqc4SoA6vZ43nAcdKOgoslsQ78RCgJHBSmcNxbFTGYcSy5vVLShWLevJ4d1LVBkbFXqLckZEX70jfEyEDVo/Ur9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094582; c=relaxed/simple;
	bh=fP7iKiiV8t7tYMrYthrxOFGuWanouRQ5SgaB16hbrHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HpKPdCeFDr3Dw9Wo9ukGfw0HF2aVwGzlmM3xbn5huwnaHWrSpkzLwJc2YuDmjaB/RTRq0fd7917mBHBfQfMCF8q2HO3N6//5huq4a6chUOYI9ovI9AdoXN92If4rLvIyYd5O81NS/5ipuznFxpG/P0gg6Cx9HWdiL3njC4bbuiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oopOpr9z; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oopOpr9z"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50299648ae9so360351cf.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 07:09:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769094579; cv=none;
        d=google.com; s=arc-20240605;
        b=KNN9bIQXUw+oYBy5GH07q3sHUCZ1dJ7J5IZ1ZygncEK7TSj5Xf31rxxQxJJ1AIE4dP
         TifxLF7WhB6JaGCCjnzFuhzdJbWq1jjz9+nLouZ7W4Crv85+2E+53A6mj4yGR5Sfk1Hu
         2SDrsW2ne7+SzBAXYDssvGD5vjE5aEetpBsMgoGs+mZXAIKRTo5Kl+XXzCA/RHjqk6/V
         3VI0VA5mKn10QLErpMrsznzWJQvm7bMFGbnoVDb/OJ4V1Hz/Yi1TXOF/CDnfl7rZQE4B
         HAg3weWx5Yv0KGXphMNjYrSFcyb3RC+2z/fnWjwV6MX0B+7p7kQ7DTACZrazOpYX8fwB
         PW4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0SOD/6X3mG1xpZ/GXzcTSM0w0ZvUC8Ff0nJjpMA7FEg=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=TU7zi7NoQy8Slzr234i1IcTtqQW0vedBHrlDd24W9NGTS1VX5dlFlWxdUr6tOLaxGN
         6hsOTYoTRAhwsLZ7Uc7WprgDTZ2ZQzNPo//oJBdpLZ6abtO/hGcTiBqrZRRFDoOKLuu+
         KuHfzqnK6sFJF5FeNn96Yki2erFvhxlnqTtpM9AEa5K3kgamOMDn/CHHT9XDOo/ZBeNQ
         LoFUC/6y4fPHQ9EInT8hgL9i6bIhqxK9U1vXrL7iz9qRqyrjFx5WTKej2XVUq2GaT5Zu
         ZVDjU7tGHj21s9Af/Iiy3AdcUMAae65KSGA+6fmzI6ecczKpj9PUto8eN9V56/iP73+x
         Ij1g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769094579; x=1769699379; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0SOD/6X3mG1xpZ/GXzcTSM0w0ZvUC8Ff0nJjpMA7FEg=;
        b=oopOpr9zwEZl+1enwb1g8W0LgTWeZ+5pXaq8e+APmEiOppfahtjPUqhYwq2zpt/Gu3
         7qA4I1oEzF1EQa5yfpDP7ihqOIRJjvx55aQOguv6gZ+/HB3+DrOEGLmrg6fxZo7zH+Tw
         Px210TfSLo+EZiOSwEl9tSfjpHp+Nzghml5SQf85y4BkImwm0A2WOg91YVJ4y3ZsOGEB
         pLl0y7vle8wWWVa6kfZkUwag+UjXdS7IJB405ECocK65uwAYwNuwN7yHZKng5QrTBhmv
         J3npb+QtUiXtHN2dU1gy/9iX52LLOaTNsOsQDUEEf+LRZNofaA6WIlJxYyp7fCnFc+AX
         UXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769094579; x=1769699379;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0SOD/6X3mG1xpZ/GXzcTSM0w0ZvUC8Ff0nJjpMA7FEg=;
        b=Ak9HzMaCD/qjfOa/hk1gjh8Wq/Bc5r4bzynk6Le+7yMELGerOc7tWpyc46/WJG3H66
         samDEABDe421+88t8kqHXOvGWdj1N9rA8+4HVGysMgtsjA9Yi3i1F/irkXt4Iw581JMZ
         /klBl8eCBuq8bbiU7eM5g1/OLQZY/jU84llWkHPJxVWfb6WvGv1qXd2MCfz1nIH91XZw
         NXAfZtioUfZxaSsbupqwyH1OffBlslIst5Y5KKU2Z9hhc1FrluAPckKGBMXgr28zCjNT
         GKFkvjT3le+wbrdW0aloxiRfMRm/aEIpNdFxCo5yNsJNmaC+INbwzoXn2jmpZkqQmlJr
         RScQ==
X-Gm-Message-State: AOJu0YxV4WtC1XnWWFriGv/pWtRNAFULmdbWJeQF4hcJXs+no1Ku1drJ
	3wlva0lH9W5B9VVcqmDEdsuIds5kX3tbuQCL2iuXcWgsUPAAKaV1b56GNwst9Uony+Bbe/tFhqY
	nM8hEPMjdaJRcJPpqqLAX3w+Bbg/JiCqk2/4lXf7G
X-Gm-Gg: AZuq6aKoLxlBj4ANPbr/apOVPkzZN2qeyPrPQADDCAbtDO8hYI9MblD7IMXelUxmPAJ
	Cbq1nkeF5KmIgl++lAK/mDeEhe314mYWE06AZrnwdukprajVf77/8RZjy+lLTcm3ebWHwAPGRnf
	+SXGrMWUW+4aUnAEGOdRBGjUe9F0lCPKShiNwPSaPzmUvym8lkIHjcLEsVAAxNqrs7lXEgE+7PL
	NUqKyWGHEcWm8uL+kMjKJZt6AcJC1IfPIYvJWWHDkbbkypyePSD8eoFJFcHrPsTx66TfjesL9Ic
	E8NLkNUmgOZ7HWrhc/eaYCVZcw==
X-Received: by 2002:ac8:5d14:0:b0:4f3:7b37:81b with SMTP id
 d75a77b69052e-502ebd86d8bmr12814351cf.18.1769094578876; Thu, 22 Jan 2026
 07:09:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119105651.255693-1-maz@kernel.org> <20260119105651.255693-6-maz@kernel.org>
In-Reply-To: <20260119105651.255693-6-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 22 Jan 2026 15:09:02 +0000
X-Gm-Features: AZwV_Qglbu-3ILOIPveU_u2g6xgRdY1YcuVAE1z9RXMZISdkRuf-Fa9wT3aB0x0
Message-ID: <CA+EHjTyUdCAB+-sPsK3r+jwJK_tHc52_6q=iZ9UvBWE_7=8Yjw@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: arm64: Kill KVM_PGTABLE_S2_NOFWB
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Jan 2026 at 10:56, Marc Zyngier <maz@kernel.org> wrote:
>
> Nobody is using this flag anymore, so remove it. This allows
> some cleanup for stage2_has_fwb(), whic doesn't need to take the

nit: s/whic/which

> pgt as a parameter anymore.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad




> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  7 ++-----
>  arch/arm64/kvm/hyp/pgtable.c         | 17 +++++++----------
>  2 files changed, 9 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 9ce51a637da0a..2198b62428832 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -229,15 +229,12 @@ struct kvm_pgtable_mm_ops {
>
>  /**
>   * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
> - * @KVM_PGTABLE_S2_NOFWB:      Don't enforce Normal-WB even if the CPUs have
> - *                             ARM64_HAS_STAGE2_FWB.
>   * @KVM_PGTABLE_S2_IDMAP:      Only use identity mappings.
>   * @KVM_PGTABLE_S2_AS_S1:      Final memory attributes are that of Stage-1.
>   */
>  enum kvm_pgtable_stage2_flags {
> -       KVM_PGTABLE_S2_NOFWB                    = BIT(0),
> -       KVM_PGTABLE_S2_IDMAP                    = BIT(1),
> -       KVM_PGTABLE_S2_AS_S1                    = BIT(2),
> +       KVM_PGTABLE_S2_IDMAP                    = BIT(0),
> +       KVM_PGTABLE_S2_AS_S1                    = BIT(1),
>  };
>
>  /**
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 07561a227f75e..3c2f7967fdc03 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -631,12 +631,9 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>         return vtcr;
>  }
>
> -static bool stage2_has_fwb(struct kvm_pgtable *pgt)
> +static bool stage2_has_fwb(void)
>  {
> -       if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> -               return false;
> -
> -       return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
> +       return cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
>  }
>
>  void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> @@ -664,10 +661,10 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>                 kvm_pte_t __attr;                                       \
>                 if((pgt)->flags & KVM_PGTABLE_S2_AS_S1)                 \
>                         __attr = PAGE_S2_MEMATTR(AS_S1,                 \
> -                                                stage2_has_fwb(pgt));  \
> +                                                stage2_has_fwb());     \
>                 else                                                    \
>                         __attr = PAGE_S2_MEMATTR(attr,                  \
> -                                                stage2_has_fwb(pgt));  \
> +                                                stage2_has_fwb());     \
>                                                                         \
>                 __attr;                                                 \
>         })
> @@ -879,7 +876,7 @@ static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
>          * system supporting FWB as the optimization is entirely
>          * pointless when the unmap walker needs to perform CMOs.
>          */
> -       return system_supports_tlb_range() && stage2_has_fwb(pgt);
> +       return system_supports_tlb_range() && stage2_has_fwb();
>  }
>
>  static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
> @@ -1167,7 +1164,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                 if (mm_ops->page_count(childp) != 1)
>                         return 0;
>         } else if (stage2_pte_cacheable(pgt, ctx->old)) {
> -               need_flush = !stage2_has_fwb(pgt);
> +               need_flush = !stage2_has_fwb();
>         }
>
>         /*
> @@ -1397,7 +1394,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>                 .arg    = pgt,
>         };
>
> -       if (stage2_has_fwb(pgt))
> +       if (stage2_has_fwb())
>                 return 0;
>
>         return kvm_pgtable_walk(pgt, addr, size, &walker);
> --
> 2.47.3
>

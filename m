Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF1AFCCA47C
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 13:06:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CFCA4B2C0;
	Fri, 10 Jun 2022 09:06:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TCMujOZjmi+B; Fri, 10 Jun 2022 09:06:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 131484B2C6;
	Fri, 10 Jun 2022 09:06:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD6854B2B7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 09:06:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fN++9fXuGvYe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 09:06:23 -0400 (EDT)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com
 [209.85.210.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 765BD4B2AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 09:06:23 -0400 (EDT)
Received: by mail-ot1-f52.google.com with SMTP id
 q1-20020a056830018100b0060c2bfb668eso2568044ota.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 06:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3ebXiX+kepLI2Qw0XY13GE4xS0GXBZo65rTV2JEU/MI=;
 b=r0iXm+ECrwbIGGwW7KlGtF0yJdsBcMHlE4hMJ4SXOUPArR/ih29baGIkqdoRmEseEO
 kR4ufVtDPBFugWHxlY7YlXTKmBAIoksSW5tPnHjVFjdSh9i2FF9CKThov13NopQrgpWB
 19vdsedFXIhd34+lTvRp9X9LsN7xm1M0e039aKwuPwBiRbEh1P2CtC+p94HOxhrJVGkR
 mfCQ4+IY/l0D5RERjRqFNKVHbwCSHy0SzH95s/OytvEmAQcKC8j3JBnAXSEm70rcX+RU
 m/meheKnwOW3RgIihgkqS9JFFSHKVIlyDa4QtXlE6LPrzWLG1WOIddzEuKROHlt4qZ8f
 rDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3ebXiX+kepLI2Qw0XY13GE4xS0GXBZo65rTV2JEU/MI=;
 b=3fFtI78rqWDf2aBFM5Io3wU9ZxJj9IlAv88OsjPpw0p4ePemwEEN8eFDS+wSFa1u0X
 XPFtjnUa35K1WHjWNa6OvpmehW5EEGXb+zHO5vZTAgjhjLhTk2Go4+QPpnENvr1iVbT/
 x//7rkeSlf7GzGjq2ODPVR3urjobpRQJKJ8G8JGNCA5dTV6rui3a1OOyd4CQvuZkEXve
 fUe46J+4xfsSuRDqbRPl38EwYRMuqZ1YF4tyWducqJrLamARZNjj5QXV/OWjr2MA1hSZ
 05UxjSaUBFAdwE9gwj3Djj/pUUSiSKwUIGApCfPbctm+csphUCYLMw1r9SiY8Rog6cZ1
 mwgw==
X-Gm-Message-State: AOAM533N4pFfx2EfxSiE2Q+EGYdg0nUFtmrncCzRJgJbWrV9byFHFrYd
 xMc44NpB6P+yxb9kGTTZ2blvQQQ8y2pSUNdawug/Uw==
X-Google-Smtp-Source: ABdhPJws07QUSYA+aDl5QUraZzBJCoFdEH8iiTu7BE5zOytCnaRv8bQE/ltNd6eD1MjkNjL1RwSMLW116iSLjnB0qJc=
X-Received: by 2002:a9d:7057:0:b0:60c:406e:1a7 with SMTP id
 x23-20020a9d7057000000b0060c406e01a7mr206631otj.299.1654866382571; Fri, 10
 Jun 2022 06:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220610092838.1205755-1-maz@kernel.org>
 <20220610092838.1205755-6-maz@kernel.org>
In-Reply-To: <20220610092838.1205755-6-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 10 Jun 2022 14:05:46 +0100
Message-ID: <CA+EHjTw_ZJREm+E2PEqB8etjaDNN7psT9p09WQU=Tp3YvB_bkw@mail.gmail.com>
Subject: Re: [PATCH v2 05/19] KVM: arm64: Add helpers to manipulate vcpu flags
 among a set
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Fri, Jun 10, 2022 at 10:28 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Careful analysis of the vcpu flags show that this is a mix of
> configuration, communication between the host and the hypervisor,
> as well as anciliary state that has no consistency. It'd be a lot
> better if we could split these flags into consistent categories.
>
> However, even if we split these flags apart, we want to make sure
> that each flag can only be applied to its own set, and not across
> sets.
>
> To achieve this, use a preprocessor hack so that each flag is always
> associated with:
>
> - the set that contains it,
>
> - a mask that describe all the bits that contain it (for a simple
>   flag, this is the same thing as the flag itself, but we will
>   eventually have values that cover multiple bits at once).
>
> Each flag is thus a triplet that is not directly usable as a value,
> but used by three helpers that allow the flag to be set, cleared,
> and fetched. By mandating the use of such helper, we can easily
> enforce that a flag can only be used with the set it belongs to.
>
> Finally, one last helper "unpacks" the raw value from the triplet
> that represents a flag, which is useful for multi-bit values that
> need to be enumerated (in a switch statement, for example).
>
> Further patches will start making use of this infrastructure.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 44 +++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 372c5642cfab..6d30ac7e3164 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -415,6 +415,50 @@ struct kvm_vcpu_arch {
>         } steal;
>  };
>
> +/*
> + * Each 'flag' is composed of a comma-separated triplet:
> + *
> + * - the flag-set it belongs to in the vcpu->arch structure
> + * - the value for that flag
> + * - the mask for that flag
> + *
> + *  __vcpu_single_flag() builds such a triplet for a single-bit flag.
> + * unpack_vcpu_flag() extract the flag value from the triplet for
> + * direct use outside of the flag accessors.
> + */
> +#define __vcpu_single_flag(_set, _f)   _set, (_f), (_f)
> +
> +#define __unpack_flag(_set, _f, _m)    _f
> +#define unpack_vcpu_flag(...)          __unpack_flag(__VA_ARGS__)
> +
> +#define __vcpu_get_flag(v, flagset, f, m)                      \
> +       ({                                                      \
> +               v->arch.flagset & (m);                          \
> +       })
> +
> +#define __vcpu_set_flag(v, flagset, f, m)                      \
> +       do {                                                    \
> +               typeof(v->arch.flagset) *fset;                  \
> +                                                               \
> +               fset = &v->arch.flagset;                        \
> +               if (HWEIGHT(m) > 1)                             \
> +                       *fset &= ~(m);                          \
> +               *fset |= (f);                                   \
> +       } while (0)
> +
> +#define __vcpu_clear_flag(v, flagset, f, m)                    \
> +       do {                                                    \
> +               typeof(v->arch.flagset) *fset;                  \
> +                                                               \
> +               fset = &v->arch.flagset;                        \
> +               *fset &= ~(m);                                  \
> +       } while (0)
> +
> +#define vcpu_get_flag(v, ...)  __vcpu_get_flag((v), __VA_ARGS__)
> +#define vcpu_set_flag(v, ...)  __vcpu_set_flag((v), __VA_ARGS__)
> +#define vcpu_clear_flag(v, ...)        __vcpu_clear_flag((v), __VA_ARGS__)
> +
> +
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
>                              sve_ffr_offset((vcpu)->arch.sve_max_vl))

A bit of macro magic going on here, but with some help I think I've
wrapped my head around it. With that

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> --
> 2.34.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

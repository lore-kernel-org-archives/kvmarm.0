Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519E7C43334
	for <kvmarm@archiver.kernel.org>; Sat, 11 Jun 2022 18:38:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BFB54B356;
	Sat, 11 Jun 2022 14:38:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3sIXO5L59ejv; Sat, 11 Jun 2022 14:38:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 531C54B3D6;
	Sat, 11 Jun 2022 14:38:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C7194B356
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jun 2022 14:38:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K8CC+GvnTCR3 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 11 Jun 2022 14:38:07 -0400 (EDT)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com
 [209.85.167.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 503864B335
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jun 2022 14:38:07 -0400 (EDT)
Received: by mail-oi1-f181.google.com with SMTP id k11so3186096oia.12
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jun 2022 11:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Xs8uTlhkm0yxZvl9ZPv6y+oBdIiDVMBnaFckx2/YwFs=;
 b=qrlIf23QC+/+YYfd/iBrITJEsFMxAPmrYnqxIPxctSu9Mne3uXPHRxFUKjfmAVijrw
 VW9X34uewzK5wSBrQROA4iDpRVtITeafCoe78LMSDERdm7xYf3HRkwgOpXtHF6m9ts+v
 YSJO2bBDqsJ7WFvP7/qOJ7bGd8+9bolMun6rpUsE/tmosL6tmHsSADf9HNrJ7+WYnfWZ
 Xa+zDJkDfP/0eX2D3ubwAylb0IKjXEOTCFmRdv2vAU+T+vguB92CQlISjY2Ei2logeOu
 HWzAL5B68l8S7kEmFkWNMu+CxRXYbjVMXHs61/W3NHn4PI2m2rPr4ms+8B8j76/bQkje
 sFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Xs8uTlhkm0yxZvl9ZPv6y+oBdIiDVMBnaFckx2/YwFs=;
 b=N4xbAhzsNxjGwo9w3vfnLKGU8TW9cf9FcTiLt5saEGJPA4DsaCb4d7jYV7heEqfSF5
 qiiD5sQyNGa7VPqbv8UkfVYEsqUCkTW8gFaVusU0z6AmLjNkS2PwAYnI81JznK0naYl3
 uCoJKtR7L1mVGv++5SwQ3NQgN4hwq+9eytCzuNwcCOio5npv7gKav2QhBarWspreoeZO
 R+5VDPLYKxfZX4RcK4s8IIkXcFMFBS0tovCuPdP/m5UtU/FFYVcePPmoLa0XcXR96TDi
 9mzgcqulVU9dg7yxXPQ/DribEIEmWgGy6hiip7zzmk/Vyo7im04TjdBVHM4kubQfkHqw
 KsJA==
X-Gm-Message-State: AOAM533deGDEKuvO9/lfZZA5sEwD+m6Kp5GKRem/kObt951TCCEcxfiS
 9oP1Ep/PP65mVSfxwryuy9/pEfDDnDReH4F55tjF9Q==
X-Google-Smtp-Source: ABdhPJw7tXu1b8dVOKxTSnAh5gbv8di1OCAQ1O999DYbmxN1zbqRW6SfDG7qKBmoytsNW4pLT2zLJrDJcRtYbxdRcJo=
X-Received: by 2002:aca:1901:0:b0:32f:7cf:db5e with SMTP id
 l1-20020aca1901000000b0032f07cfdb5emr2983324oii.16.1654972686314; Sat, 11 Jun
 2022 11:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220610092838.1205755-1-maz@kernel.org>
 <20220610092838.1205755-6-maz@kernel.org>
In-Reply-To: <20220610092838.1205755-6-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sat, 11 Jun 2022 11:37:50 -0700
Message-ID: <CAAeT=Fxu+s7JNYP-U-ov2yqhLVp7Nvf_yox0JaVZh06a=rHwzg@mail.gmail.com>
Subject: Re: [PATCH v2 05/19] KVM: arm64: Add helpers to manipulate vcpu flags
 among a set
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Fri, Jun 10, 2022 at 2:28 AM Marc Zyngier <maz@kernel.org> wrote:
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

Reviewed-by: Reiji Watanabe <reijiw@google.com>

IMHO I would prefer to have 'v' enclosed in parentheses in the
implementation of __vcpu_{get,set,clear}_flag rather than in
the implementation of vcpu_{get,set,clear}_flag though.
(That was what I meant in my comment for v1)

Thanks,
Reiji

> +#define vcpu_get_flag(v, ...)  __vcpu_get_flag((v), __VA_ARGS__)
> +#define vcpu_set_flag(v, ...)  __vcpu_set_flag((v), __VA_ARGS__)
> +#define vcpu_clear_flag(v, ...)        __vcpu_clear_flag((v), __VA_ARGS__)
> +
> +
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
>                              sve_ffr_offset((vcpu)->arch.sve_max_vl))
> --
> 2.34.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

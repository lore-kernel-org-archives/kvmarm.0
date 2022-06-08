Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65445C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jun 2022 05:27:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D63424B330;
	Wed,  8 Jun 2022 01:27:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zZv+mt5oUutX; Wed,  8 Jun 2022 01:27:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 819504B326;
	Wed,  8 Jun 2022 01:27:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E62354B31D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 01:27:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mJl8c1pnFekU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 01:27:01 -0400 (EDT)
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com
 [209.85.160.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 732164B24E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 01:27:01 -0400 (EDT)
Received: by mail-oa1-f47.google.com with SMTP id
 586e51a60fabf-e93bbb54f9so25870227fac.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jun 2022 22:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gQbcZrMkiRKMjcf000Vd/gxeTXgq7dDJP9T2Rzdx8bA=;
 b=KGm67M6fDCiCqTOD+LgzJn4tRzL5H7Jda/FE6ARw7gzoEKIY5J0oqwXOwdNJDMJsu3
 39CDY34/gPUYqHQAHfx585CQyQOsngHesG7LmRpNWtzAEOe8pSPllepAlk3qj8rkOOJx
 jtsBLs22d0ca7iQlvbiycgd5kand0QO1Z+QwTErbDG8VuIfNKH9c/+tRbb/QHqNp4nsR
 IbNX+zROkrIETwJNFzc6dNF2zipkaJ11ekObK3JJmeSlMoDX1zZqKBcUvYygjX/07E36
 0MjYcPwKSEExVWONnqlKQNirtPD0YzLo/OWDGvoXegrfNRR+fGjRY3RQ13qOdOh3Dh/m
 G9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gQbcZrMkiRKMjcf000Vd/gxeTXgq7dDJP9T2Rzdx8bA=;
 b=VEqbt9Thre2JDveBT6dQi4yEMVDsm2jejcmOOOBmwSZoebDAasc6TYGvMnRT0sbJos
 1wizMqKY/YWiV48hYwB/TLnzIcy31dpY3DULrAgT7d/68VgVZHf8csyHXRqQzKkxchVP
 B9Y4gjeY+i/yVxUNaYOmwrZ17YJ7vJmX8UnhvgG5N5NhmQIU5/P64EykjZnSa5keXPyI
 zG2ogzZiel0KsUJzhgr/jGsq5elhnqc5MzsChmLe1DymrymFmxyQFLLkbD2UMaHPSrsf
 Wfj1zzQutkbfLyyJOCRHPvSej0yZOvJLeCuNo3y1YYIKJntHnivf7MgeCJsOicQTjfin
 uLWA==
X-Gm-Message-State: AOAM531g/nwxgAfwonLK//7s0keVHsfGLS2EBns2FRMqsPSZKnutGSun
 SE9V3LF++01uD/4d+850xmIdlQ8k+RSVZlYG6YxkZA==
X-Google-Smtp-Source: ABdhPJyD1Nj5fusNP7VUimclAcbSfNFTD3GX5Z7nqpmH/vYRX4nSJ941ftf6wvyOic24AJEisuI5sK+oKKb0Zx57B0k=
X-Received: by 2002:a05:6870:5a8:b0:f4:2cf8:77eb with SMTP id
 m40-20020a05687005a800b000f42cf877ebmr1417214oap.16.1654666020584; Tue, 07
 Jun 2022 22:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-6-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-6-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 7 Jun 2022 22:26:44 -0700
Message-ID: <CAAeT=FyruEc5pDhdg0wOtFcV0EFUnhOVyt+o5BMfn5GsooM9Jw@mail.gmail.com>
Subject: Re: [PATCH 05/18] KVM: arm64: Add helpers to manipulate vcpu flags
 among a set
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
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
>  arch/arm64/include/asm/kvm_host.h | 33 +++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a46f952b97f6..5eb6791df608 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -418,6 +418,39 @@ struct kvm_vcpu_arch {
>         } steal;
>  };
>
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

I think 'v' should be enclosed in parentheses in those three macros.


> +
> +#define vcpu_get_flag(v, ...)  __vcpu_get_flag(v, __VA_ARGS__)
> +#define vcpu_set_flag(v, ...)  __vcpu_set_flag(v, __VA_ARGS__)
> +#define vcpu_clear_flag(v, ...)        __vcpu_clear_flag(v, __VA_ARGS__)
> +
> +#define __vcpu_single_flag(_set, _f)   _set, (_f), (_f)
> +
> +#define __flag_unpack(_set, _f, _m)    _f

Nit: Probably it might be worth adding a comment that explains the
above two macros ? (e.g. what is each element of the triplets ?)

> +#define vcpu_flag_unpack(...)          __flag_unpack(__VA_ARGS__)

Minor nit: KVM Functions and macros whose names begin with "vcpu_"
make me think that they are the operations for a vCPU specified in
the argument, but this macro is not (this might just my own
assumption?). So, IMHO I would prefer a name whose prefix is not
"vcpu_". Having said that, I don't have any good suggestions though...
Perhaps I might prefer "unpack_vcpu_flag" a bit instead?

Thanks,
Reiji

> +
> +
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
>                              sve_ffr_offset((vcpu)->arch.sve_max_vl))
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

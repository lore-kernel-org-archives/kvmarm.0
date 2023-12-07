Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9003744395
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zmBptz9c"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-77f35b70944so40048585a.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Dec 2023 07:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701961641; x=1702566441; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKoDQjce4p/9MLyntIxjMZ4xfjAecm8r7SrpaYpeLpo=;
        b=zmBptz9cu7GrtTzM+USWA1kI4/MhxQ2czvE+GTnIukYLOBFOcv4x5lWt295RazjUZk
         QnRKg09sOdeZz4GSeKUexoF8ppAbQv+6TpQtRYnrGJhCyau35GZfCINzYBjDUFtkQzJq
         T1Ep+TX9zVJcgp4t6xmXQmQBvfA/Spz0YJXP64eS8iOc4PyUXm31gc3wAohHQbolMwdv
         9fjaP1W9x5XhUxmwxhIel83c4G96DMVL39CHcfSLXKgg40PgqAUgat4qBv9sIulYCjMR
         qggWkM9E7nZs5M2REgRY+I+lyLAzIEUvL9c1xZSxduwjCrPNLc6hD578TjkbejD80WjA
         GtLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701961641; x=1702566441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JKoDQjce4p/9MLyntIxjMZ4xfjAecm8r7SrpaYpeLpo=;
        b=NxmJQFUVhhapEWlDQdhidC+m4RhSBeyDO6tG3hjhYD8EZhNw1m2RLlKcKEJYO4f69b
         qRdpfXzWBw7YV2MonmxoSQpDEOZFtZV9CcywIC+FDij76F6Aj3+YPtUHfPQlLbEasXHl
         OwP9m7st4pcVeL4OFuRi1VFGnP4LNEbszk8taI6CL3WhGH5PxWyWFVV8CFv1j9p6wZ7M
         pF74tFAIhn2Bmw2PbqRMKO4Z4qXjUd1cxAxanDmhyEXqgoeqj5ZiXoR1t3aGTGaHtAwQ
         H+BpCdR8cXrNYwDuxmdoQmUa+WlyT6y8Smn6G/AEvfU/ItyuOBPfWSbPcYazBHcH8oa0
         8+Vw==
X-Gm-Message-State: AOJu0YyiUa4wpAGtWnnykg5aYZ7+oWACSxtfa4xelo3akk5xQ6slujGq
	xPuw8K7waPJuY9jzMVT0PE/DN120ovp/OjKZVMG7ow==
X-Google-Smtp-Source: AGHT+IFCtMneSM6XAKmO7ovkGJAUykRnvBbTNPt5vgNos1bD0LjCArV9kpVJHJASCOQf/F7jT+4vDfEiXfbOnf/k8N0=
X-Received: by 2002:a05:6214:2529:b0:67a:c46c:64e1 with SMTP id
 gg9-20020a056214252900b0067ac46c64e1mr3299594qvb.8.1701961641289; Thu, 07 Dec
 2023 07:07:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com> <20231206100503.564090-7-tabba@google.com>
 <20231207150001.GA29745@e124191.cambridge.arm.com>
In-Reply-To: <20231207150001.GA29745@e124191.cambridge.arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 7 Dec 2023 15:06:44 +0000
Message-ID: <CA+EHjTwC+66GyPma00XQ6VRzktYzxB7XXr+7zSKFrG6U-+EeEQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] KVM: arm64: Update and fix FGT register masks
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joey,

On Thu, Dec 7, 2023 at 3:00=E2=80=AFPM Joey Gouly <joey.gouly@arm.com> wrot=
e:
>
> Hello Fuad,
>
> On Wed, Dec 06, 2023 at 10:04:56AM +0000, Fuad Tabba wrote:
> > New trap bits have been defined in the 2023-09 Arm Architecture
> > System Registers xml specification [*]. Moreover, the existing
> > definitions of some of the mask and the RES0 bits overlap, which
> > could be wrong, confusing, or both.
> >
> > Update the bits to represent the latest spec (as of this patch,
> > 2023-09), and ensure that the existing bits are consistent.
> >
> > Subsequent patches will use the generated RES0 fields instead of
> > specifying them manually. This patch keeps the manual encoding of
> > the bits to make it easier to review the series.
> >
> > [*] https://developer.arm.com/downloads/-/exploration-tools
> >
> > Fixes: 0fd76865006d ("KVM: arm64: Add nPIR{E0}_EL1 to HFG traps")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h | 39 ++++++++++++++++++++------------
> >  1 file changed, 24 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/=
kvm_arm.h
> > index 7de0a7062625..b0dc3249d5cd 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -344,30 +344,39 @@
> >   * Once we get to a point where the two describe the same thing, we'll
> >   * merge the definitions. One day.
> >   */
> > -#define __HFGRTR_EL2_RES0    (GENMASK(63, 56) | GENMASK(53, 51))
> > +#define __HFGRTR_EL2_RES0    BIT(51)
> >  #define __HFGRTR_EL2_MASK    GENMASK(49, 0)
> > -#define __HFGRTR_EL2_nMASK   (GENMASK(58, 57) | GENMASK(55, 54) | BIT(=
50))
> > +#define __HFGRTR_EL2_nMASK   (GENMASK(63, 52) | BIT(50))
> >
> > -#define __HFGWTR_EL2_RES0    (GENMASK(63, 56) | GENMASK(53, 51) |    \
> > -                              BIT(46) | BIT(42) | BIT(40) | BIT(28) | =
\
> > -                              GENMASK(26, 25) | BIT(21) | BIT(18) |  \
> > +#define __HFGWTR_EL2_RES0    (BIT(51) | BIT(46) | BIT(42) | BIT(40) | =
\
> > +                              BIT(28) | GENMASK(26, 25) | BIT(21) | BI=
T(18) | \
> >                                GENMASK(15, 14) | GENMASK(10, 9) | BIT(2=
))
> > -#define __HFGWTR_EL2_MASK    GENMASK(49, 0)
> > -#define __HFGWTR_EL2_nMASK   (GENMASK(58, 57) | GENMASK(55, 54) | BIT(=
50))
> > +#define __HFGWTR_EL2_MASK    (GENMASK(49, 47) | GENMASK(45, 43) | \
> > +                              BIT(41) | GENMASK(39, 29) | BIT(27) | \
> > +                              GENMASK(24, 22) | GENMASK(20, 19) | \
> > +                              GENMASK(17, 16) | GENMASK(13, 11) | \
> > +                              GENMASK(8, 3) | GENMASK(1, 0))
> > +#define __HFGWTR_EL2_nMASK   (GENMASK(63, 52) | BIT(50))
>
> By adding all these bits to *_nMASK, we're allowing a guest to access reg=
isters
> which KVM doesn't (currently) deal with.  For example if I apply this pat=
ch
> series, a guest can access S2POR_EL1, previously it would print something=
 like:
>
>         kvm [80]: Unsupported guest sys_reg access at: ffffc42969c1f270 [=
600000c5]
>          { Op0( 3), Op1( 0), CRn(10), CRm( 2), Op2( 5), func_read },
>
> After applying this patch series, the guest can read S2POR_EL1.
>
> We don't expose S2POE to the guest through ID_AA64MMFR3_EL1, so a well be=
haved
> guest shouldn't access it, but there's nothing stopping it.
>
> My question is, is this intended? Or do we need to update the following c=
ode
> (and comment!) to trap all the stuff we don't currently handle (along wit=
h
> ACCDATA_EL1):

Thanks for pointing this out, and no, it's not intended. For
consistency, I think it might be good to update the code, as you
suggest, to prevent these accesses. If you and the other reviewers are
happy with that solution I can respin with your suggested fix. I have
a couple of other minor fixes as well for the series.

What do you think?

Cheers,
/fuad


>
>         static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>         {
>
>                 ..
>
>                 /* The default is not to trap anything but ACCDATA_EL1 */
>                 r_val =3D __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
>                 r_val |=3D r_set;
>                 r_val &=3D ~r_clr;
>
>
> Thanks,
> Joey
>
> >
> > -#define __HFGITR_EL2_RES0    GENMASK(63, 57)
> > -#define __HFGITR_EL2_MASK    GENMASK(54, 0)
> > -#define __HFGITR_EL2_nMASK   GENMASK(56, 55)
> > +#define __HFGITR_EL2_RES0    (BIT(63) | BIT(61))
> > +#define __HFGITR_EL2_MASK    (BIT(62) | BIT(60) | GENMASK(54, 0))
> > +#define __HFGITR_EL2_nMASK   GENMASK(59, 55)
> >
> >  #define __HDFGRTR_EL2_RES0   (BIT(49) | BIT(42) | GENMASK(39, 38) |  \
> >                                GENMASK(21, 20) | BIT(8))
> > -#define __HDFGRTR_EL2_MASK   ~__HDFGRTR_EL2_nMASK
> > +#define __HDFGRTR_EL2_MASK   (BIT(63) | GENMASK(58, 50) | GENMASK(48, =
43) | \
> > +                              GENMASK(41, 40) | GENMASK(37, 22) | \
> > +                              GENMASK(19, 9) | GENMASK(7, 0))
> >  #define __HDFGRTR_EL2_nMASK  GENMASK(62, 59)
> >
> >  #define __HDFGWTR_EL2_RES0   (BIT(63) | GENMASK(59, 58) | BIT(51) | BI=
T(47) | \
> >                                BIT(43) | GENMASK(40, 38) | BIT(34) | BI=
T(30) | \
> >                                BIT(22) | BIT(9) | BIT(6))
> > -#define __HDFGWTR_EL2_MASK   ~__HDFGWTR_EL2_nMASK
> > +#define __HDFGWTR_EL2_MASK   (GENMASK(57, 52) | GENMASK(50, 48) | \
> > +                              GENMASK(46, 44) | GENMASK(42, 41) | \
> > +                              GENMASK(37, 35) | GENMASK(33, 31) | \
> > +                              GENMASK(29, 23) | GENMASK(21, 10) | \
> > +                              GENMASK(8, 7) | GENMASK(5, 0))
> >  #define __HDFGWTR_EL2_nMASK  GENMASK(62, 60)
> >
> >  #define __HAFGRTR_EL2_RES0   (GENMASK(63, 50) | GENMASK(16, 5))
> > @@ -375,9 +384,9 @@
> >  #define __HAFGRTR_EL2_nMASK  0UL
> >
> >  /* Similar definitions for HCRX_EL2 */
> > -#define __HCRX_EL2_RES0              (GENMASK(63, 16) | GENMASK(13, 12=
))
> > -#define __HCRX_EL2_MASK              (0)
> > -#define __HCRX_EL2_nMASK     (GENMASK(15, 14) | GENMASK(4, 0))
> > +#define __HCRX_EL2_RES0         (GENMASK(63, 25) | GENMASK(13, 12))
> > +#define __HCRX_EL2_MASK              (BIT(6))
> > +#define __HCRX_EL2_nMASK     (GENMASK(24, 14) | GENMASK(11, 7) | GENMA=
SK(5, 0))
> >
> >  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
> >  #define HPFAR_MASK   (~UL(0xf))
> > --
> > 2.43.0.rc2.451.g8631bc7472-goog
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

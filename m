Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0A8C941
	for <kvmarm@lists.linux.dev>; Thu,  9 Mar 2023 22:15:10 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-17711f56136so3864036fac.12
        for <kvmarm@lists.linux.dev>; Thu, 09 Mar 2023 14:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678400109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3PQRMfxQpWw1EQQGErwxaTj11IIxbXvdV9zBZ1y4E8=;
        b=Y9RgqY/R49EUCbBlDxx4d3nanzjLIn3mMjcmuVW56VS1awQnqsRW+zJP5wohesNJch
         zg1I7QVEFGP6FlohW41/rXg+b2cqCqxW6BLcDDqbions+nu/IonS5GIGWuNYbKlP6sDn
         oVGM/BN6Ky7XOdJqN7qcl4WRWFaF2rNx+y8u4LFkVEZgP6KG5MuemD7Fq3jcVwU4/x4o
         L362NHXei92hxGxrvgWRqVPrz/7Z6PdwujtF/h61LOOfYglO5eZ/jds+x4zP6cSm65Ad
         j0P5ccYOf4x/JJvz+FgB/NknLjbaQ9B4plsCKGR1KiZQQ/JKJaXsWE2h40V4WldgmCEy
         4sBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678400109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3PQRMfxQpWw1EQQGErwxaTj11IIxbXvdV9zBZ1y4E8=;
        b=hAmISpMK3DCwZzaOzWyzPY4YEr7jPAKNOsC+W7kRHwcbKKsNS6B5gF+w3MpAlYfhBP
         svm863EpNundDzWfUkO2d4r7+ZM+VWn4JBKzQyNzdoKooheF9vcLdDIfySGD8U2ueuex
         XCtDyf4SujO4Hiuyhr4MXHEp45qxH/+YF/CYFjxP+cJejDzh+o5iz9abC/D9fYwqch0A
         3EDnZkQEoPcSFJSjtSl5ii3sOEJEwtvt8v5dRmb/ATb+oBfWIYuRyJuxQp5Ql9WEWfYx
         0O8NOFQNRUSernrh0XD8aoLkD+zpsjS/6qYnjMfcFnOB4UURn//1JkUPUrMjMDS1GYUQ
         4gjA==
X-Gm-Message-State: AO0yUKX0H9sRmyWnshcW+0ANE/mLgH0dFme2IjZ4vBUqqgEh+Ai9fGua
	7iwEjyVrexYj3rX3h9+ueLvjWR1jUplYgcqfv5Zp9g==
X-Google-Smtp-Source: AK7set/32BBIrvEDt0fltBRnip4rqPQdBgJQQDjXpdLAI3JvJVq6nj0esM2VH3efuTnhloEU4dl5EHGiLl6+aSSX9Ec=
X-Received: by 2002:a05:6870:a2c2:b0:176:4a71:6fdc with SMTP id
 w2-20020a056870a2c200b001764a716fdcmr8314733oak.9.1678400109081; Thu, 09 Mar
 2023 14:15:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-7-rananta@google.com>
 <CAAeT=FyrgUjQWhL75n7z43msubHHghhy3Tj2JjsYop14f3kFhg@mail.gmail.com>
In-Reply-To: <CAAeT=FyrgUjQWhL75n7z43msubHHghhy3Tj2JjsYop14f3kFhg@mail.gmail.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Mar 2023 14:14:58 -0800
Message-ID: <CAJHc60z87hz7tVfHyiO6wcYXDKLMNZzRE2V8jWB-5rekR1xkAg@mail.gmail.com>
Subject: Re: [REPOST PATCH 06/16] tools: arm64: perf_event: Define Cycle
 counter enable/overflow bits
To: Reiji Watanabe <reijiw@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Reiji,

On Thu, Mar 2, 2023 at 4:47=E2=80=AFPM Reiji Watanabe <reijiw@google.com> w=
rote:
>
> Hi Raghu,
>
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Add the definitions of ARMV8_PMU_CNTOVS_C (Cycle counter overflow
> > bit) for overflow status registers and ARMV8_PMU_CNTENSET_C (Cycle
> > counter enable bit) for PMCNTENSET_EL0 register.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/arch/arm64/include/asm/perf_event.h | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/tools/arch/arm64/include/asm/perf_event.h b/tools/arch/arm=
64/include/asm/perf_event.h
> > index 97e49a4d4969f..8ce23aabf6fe6 100644
> > --- a/tools/arch/arm64/include/asm/perf_event.h
> > +++ b/tools/arch/arm64/include/asm/perf_event.h
> > @@ -222,9 +222,11 @@
> >  /*
> >   * PMOVSR: counters overflow flag status reg
> >   */
> > +#define ARMV8_PMU_CNTOVS_C      (1 << 31) /* Cycle counter overflow bi=
t */
>
> Nit: This macro doesn't seem to be used in any of the patches.
> Do we need this ?
>
Ah, I think originally I intended to use this instead of defining my
own ARMV8_PMU_CYCLE_COUNTER_IDX to align with other pmc idx-es. But I
think the latter is better. I'll remove ARMV8_PMU_CNTOVS_C.

Thank you.
Raghavendra

> Thank you,
> Reiji
>
>
> >  #define        ARMV8_PMU_OVSR_MASK             0xffffffff      /* Mask=
 for writable bits */
> >  #define        ARMV8_PMU_OVERFLOWED_MASK       ARMV8_PMU_OVSR_MASK
> >
> > +
> >  /*
> >   * PMXEVTYPER: Event selection reg
> >   */
> > @@ -247,6 +249,11 @@
> >  #define ARMV8_PMU_USERENR_CR   (1 << 2) /* Cycle counter can be read a=
t EL0 */
> >  #define ARMV8_PMU_USERENR_ER   (1 << 3) /* Event counter can be read a=
t EL0 */
> >
> > +/*
> > + * PMCNTENSET: Count Enable set reg
> > + */
> > +#define ARMV8_PMU_CNTENSET_C    (1 << 31) /* Cycle counter enable bit =
*/
> > +
> >  /* PMMIR_EL1.SLOTS mask */
> >  #define ARMV8_PMU_SLOTS_MASK   0xff
> >
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >

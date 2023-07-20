Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892EE171D2
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 08:04:00 +0000 (UTC)
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-635decc135eso8225376d6.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 01:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689840239; x=1690445039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76EnT+PK2jYn3HgsEght+n9bWFa9k+9apTFLh1zJF6U=;
        b=NPGhC5RG/0TQiqyN0SELXiw3pXk3y9m5o5Y9yUL/PGQdDXJvU5jhLsywSOP0po2UP0
         WVLw7xSPK5vM6hFOx637cOOOuFmXkfZapYtQmXzMu6P+UAa6nct1CLA7L7Q5OM9a0/Hf
         uI3ocXf+Gj+uADLClnyRxAswbZ/Ds1m5fjvPWclAiGlbbLQjOxE+VwYs6gyHrJzOA7cM
         6sDeWmeO4cfi+srxmuwWZlk8vA87p5gMCsbqpHxmNCM4zMA0iS26XXrEviMvVo19wBXJ
         WJVh5afDqWWYXFE+sADcJ48fjH9xzGPYfNvt2CzEj9RBJuZsFcYzf/wncGFQQQyqe18a
         KVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689840239; x=1690445039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=76EnT+PK2jYn3HgsEght+n9bWFa9k+9apTFLh1zJF6U=;
        b=bCqaw6B7bAxveX2A7d2ElPs55COBDLSvke0V2uKlnm8a2OreC4I5hR5ing5Bdv1VR6
         80njkKRpAKlbuCJn9zwnx3OqRrHrL9ofiKxfSbHdVJZYHWTksLBE/uA/nkYV+vJyrqEZ
         ri5aTHaq5ysoL8GmYyHvgGj9yjAnqZuLYN3RELftfWRiqvLNLQN7tGEcGkir1AnSlcOI
         f41tzQFoDDYOj1gylu3YELLsSpzntKsxGnoR08fF4b2bBqf5VHeXe0cjeXKuWY4VRiuD
         uZAXZs957Mp2C01AwyUf1MIHxCp9AEftPQ6PUB0TR2AwpoqjenGaFA7T1s19ANow3d3s
         ToNw==
X-Gm-Message-State: ABy/qLaoXAo3LmPzbPLazG/BG9CgEAn4KCxYH9Vi8zCh3SWEgoxeLt6Q
	IWTWeUwVzLhBUoBxsRHoByS/D8kcRchEZA+RnQbhxw==
X-Google-Smtp-Source: APBJJlHV9S4PqttW4WtskULzUQiGa/aEu0pJ8JzrS1l6fcrPypIYLRl5gjYR70ki8oqDV3LsytUT8+Hdf815iL5qWXY=
X-Received: by 2002:a05:6214:485:b0:63c:b668:9016 with SMTP id
 pt5-20020a056214048500b0063cb6689016mr5279727qvb.27.1689840239292; Thu, 20
 Jul 2023 01:03:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230719150639.1968034-1-tabba@google.com> <20230719150639.1968034-3-tabba@google.com>
 <ZLgelCk3+W3YOpVx@linux.dev>
In-Reply-To: <ZLgelCk3+W3YOpVx@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 20 Jul 2023 09:03:22 +0100
Message-ID: <CA+EHjTx0O8H-59QJrTcuROtjwE1O0YgunsmHob32bEP2iSvEUw@mail.gmail.com>
Subject: Re: [PATCH v1 2/5] KVM: arm64: Disable SME Traps for (h)VHE at setup
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,


On Wed, Jul 19, 2023 at 6:34=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Jul 19, 2023 at 04:06:36PM +0100, Fuad Tabba wrote:
> > Ensure that SME traps are disabled for (h)VHE when setting up
> > EL2, as they are for nVHE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/el2_setup.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/as=
m/el2_setup.h
> > index c106b31d776c..7001b6db3ccc 100644
> > --- a/arch/arm64/include/asm/el2_setup.h
> > +++ b/arch/arm64/include/asm/el2_setup.h
> > @@ -292,9 +292,21 @@
> >       check_override id_aa64pfr1, ID_AA64PFR1_EL1_SME_SHIFT, .Linit_sme=
_\@, .Lskip_sme_\@, x1, x2
> >
> >  .Linit_sme_\@:       /* SME register access and priority mapping */
> > +     mrs     x1, hcr_el2
> > +     and     x1, x1, #HCR_E2H
> > +     cbz     x1, .Lcptr_nvhe_sme_\@
>
> Hmm.. Our test for hVHE is repeated enough times, it might make sense
> for readability to wrap it up in a macro:
>
> .macro check_hvhe pass, fail, tmp
>         mrs     \tmp, hcr_el2
>         and     \tmp, \tmp, #HCR_E2H
>         cbnz    \tmp, \pass
>         b       \fail
> .endm
>
> So long as we tolerate the additional word of bloat for the extra branch
> :)

I did consider that, but went for less bloat. I'll wrap it in a macro
for the respin though, and leave it up to the maintainers to decide
which one to pick :D

Cheers,
/fuad

>
> > +     // (h)VHE case
> > +     mrs     x0, cpacr_el1                   // Disable SME traps
> > +     orr     x0, x0, #(CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN)
> > +     msr     cpacr_el1, x0
> > +     b       .Lskip_set_cptr_sme_\@
> > +
> > +.Lcptr_nvhe_sme_\@: // nVHE case
> >       mrs     x0, cptr_el2                    // Disable SME traps
> >       bic     x0, x0, #CPTR_EL2_TSM
> >       msr     cptr_el2, x0
> > +.Lskip_set_cptr_sme_\@:
> >       isb
> >
> >       mrs     x1, sctlr_el2
> > --
> > 2.41.0.255.g8b1d071c50-goog
> >
>
> --
> Thanks,
> Oliver

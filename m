Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E24D125A3
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 09:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u4n4BoKG"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-67f2fc389e6so9404296d6.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 01:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702893429; x=1703498229; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AWjfe7RH/mU7J9DoxKHehvCyBL+cySbjOgl2d3a9iCM=;
        b=u4n4BoKGyQRFBwtaE9ZnVmvssr2PVpC8qKugbZaW9HDxn2Dbs9ppg+Vyt+ayv9dCxS
         OmxLb+nF0iSSnT9QgfuVxbku5JDV/kXPR1UoJk2H9pRq+z501yFtL/QZOEb2Jawd9hHl
         d0JJQ2kj55sLxPVOLWwmggWVTEkB4TDphBUotP1iYQ9rzbqHfShx8HAyID5eyPV5dRpH
         d+OmoXFZiUKUMWHAt2lqAXO9979k1JwvdOmkpJmCrP7xQGEjM4Ui5Zg3ciPxqWb1iUko
         4u8+BEM2MTZ2U1NavKbPCfMmSu01EavQGZJNVyzeM9WhDHaQDaZyhtAY7nGvSoV90lfu
         aiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702893429; x=1703498229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AWjfe7RH/mU7J9DoxKHehvCyBL+cySbjOgl2d3a9iCM=;
        b=AFTyIsy5KMtHkpsAUl0RJskv6zV0HR7A1fzY3JubK4J7pWJY9DvGljzwk/OfkXi+A7
         i/HFeYnC3qzA/e5xLYAIeS53Zh5r7w5FsDDnL80OOmQchpQkIVrhKpuoc3Bjh9aIr7ad
         QMpko4Z//xgLURfR74nq+1JGL7lKUZ9euTMttxB10KEY1jP/GwHNIdj7YK/QvUM0/UPn
         ytYi7p87gqyNlJlqTGB+/xe6dtgNvgQhjQlBu7jGDU/9kiAsoGZXpCFBjCNtKGNwsg2h
         FyDtZZnzXgmaKOvH+xAMkstBc7sVSuoVGDqOKjJH3M205+bUp4wW6wph7W7ApCGLzKVA
         eYUg==
X-Gm-Message-State: AOJu0YxfIx2Ao5LzaWm/olRH9PCcIMzATe8dIUL+kl2gSQsvQPhgXlga
	eCQeOgBsxNsOAxOdZtTlIAgYXz4a42vNgmoOn01b6g==
X-Google-Smtp-Source: AGHT+IGYbR6gUlllV6xfxcDnv7UT2h4I8qSrO6cOt0PscRTby6ssA1uQNs2QiJ45mLqo4adWkVKueNeQyMx/PORwcPM=
X-Received: by 2002:a0c:c58d:0:b0:67a:8f89:a631 with SMTP id
 a13-20020a0cc58d000000b0067a8f89a631mr13157179qvj.23.1702893429206; Mon, 18
 Dec 2023 01:57:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com> <20231214100158.2305400-15-tabba@google.com>
 <86wmtbalx9.wl-maz@kernel.org>
In-Reply-To: <86wmtbalx9.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Dec 2023 09:56:32 +0000
Message-ID: <CA+EHjTxZmc2bAaDbFLjWxx-LzCX7Jwy+EH60JgFBvWYh68U=xg@mail.gmail.com>
Subject: Re: [PATCH v3 14/17] KVM: arm64: Macros for setting/clearing FGT bits
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Dec 18, 2023 at 9:40=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 14 Dec 2023 10:01:54 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > There's a lot of boilerplate code for setting and clearing FGT
> > bits when activating guest traps. Refactor it into macros. These
> > macros will also be used in future patch series.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 60 +++++++++----------------
> >  1 file changed, 21 insertions(+), 39 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/h=
yp/include/hyp/switch.h
> > index 17ce40f5b006..e223fc0d5193 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -79,6 +79,23 @@ static inline void __activate_traps_fpsimd32(struct =
kvm_vcpu *vcpu)
> >               clr |=3D ~hfg & __ ## reg ## _nMASK;                     =
 \
> >       } while(0)
> >
> > +#define update_fgt_traps_cs(reg, clr, set)                           \
> > +     do {                                                            \
> > +             struct kvm_cpu_context *hctxt =3D                        =
 \
> > +                     &this_cpu_ptr(&kvm_host_data)->host_ctxt;       \
> > +             u64 val, c =3D 0, s =3D 0;                               =
   \
> > +                                                                     \
> > +             ctxt_sys_reg(hctxt, reg) =3D read_sysreg_s(SYS_ ## reg); =
 \
> > +             compute_clr_set(vcpu, reg, c, s);                       \
>
> You are referring to a variable name that is in the scope of the macro
> user, and not the macro itself. It is so fragile it isn't funny.
>
> Why don't you simply pass the vcpu as a parameter to the function?
>
> Another thing is that this read/write can be expensive. How about not
> doing anything when there is no change to the value of the sysreg?

What do you think of this (spacing will be fixed):

#define update_fgt_traps_cs(vcpu, reg, clr, set)                         \
    do {
                           \
        struct kvm_cpu_context *hctxt =3D
         \
            &this_cpu_ptr(&kvm_host_data)->host_ctxt;                  \
        u64 val, c =3D 0, s =3D 0;
                  \

                             \
        ctxt_sys_reg(hctxt, reg) =3D read_sysreg_s(SYS_ ## reg);   \
        compute_clr_set(vcpu, reg, c, s);
          \
        val =3D __ ## reg ## _nMASK;
          \
        val |=3D (s | set);
                        \
        val &=3D ~(c | clr);
                       \
        if (ctxt_sys_reg(hctxt, reg) !=3D val)
              \
            write_sysreg_s(val, SYS_ ## reg);
           \
    } while(0)

If it looks good to you, I'll fix it on the respin.

Thanks,
/fuad

>
> I'll see if I can come up with something.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

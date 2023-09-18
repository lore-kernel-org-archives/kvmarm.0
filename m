Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D360123774
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 17:25:06 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-41761e9181eso18791cf.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 10:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695057905; x=1695662705; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JpfHnxzUVMMWabALTl0v26Xf5DOzz1X5VHLZhINkdjo=;
        b=snTCews8jHDvaR3lhLmRqfijJcXqQj0ageKm4cHyNu1lcoZmmXQ10SrK63ILYZP5zf
         9gHNM+KiChctSaIGYAdYoPZfYIAK8eSVdzv6L1+5wLmSa8I9edu/RAWysMuyMUFR2Ypy
         WZxqrTxiNu1mRrmvO+cSDMy/lXOzGwSQeQkXHxSp6oqPUoYyk4uFwBHzmjr/Exd/LntK
         k1IwQ7N2bVhsmMIDY3prACiIXW5u5rsUfMxF8fxhCfNXjtsP75l+35qrA3xLa6NohLC/
         +MFfyKwmR2bVJGMl+ErSBagdQFZOgkDuln8H8wh9RZ/lBTKzLSZZmC/ReqFXOYOr57QS
         9McA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057905; x=1695662705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JpfHnxzUVMMWabALTl0v26Xf5DOzz1X5VHLZhINkdjo=;
        b=nlKnCXBOYQtwDtGpm6+ghgSyI4mD296VJUFU9VB5icetFVgcwTom3KqkkXaGF4CMtE
         8tZdbLnQJqvHwRF1VzMCMiAV7G0s1xN4mK65CCFa6Do7apTUThcG2pWIIOntsQz0Jrjz
         RMRm6VWxMJPdUR0KmArxPA2Z0QDW8tLYhMEf7VvTkYDeoU4K3LpSgR74A+Y4D/bAZuRI
         kVxbW7uaJQXiZfa0KuTcuPKTPqU2nUasfzxP//tXpf6Jmv8F4GlpcW454RmAHxoZuM9V
         BDJplnwV3AE48XzMSD2q0DsK7jJMhXrm4HIMVx0Sz5D6UeJAv6RFzY72XMLxBlJu/VLX
         OoFQ==
X-Gm-Message-State: AOJu0YwkskI7GpP4H55VntdVOOuc4P3/49S7lBU5aEA2E29IvWx4ye5a
	+goG+93HgnPaXr1Cbaod4sSfqeR/EJaKQdF/e0d+Ww==
X-Google-Smtp-Source: AGHT+IGXcCZbbS4ArJa/YBg3SDkl1c2jMvOnRFmN6r7bxpBzmZyDDMDABzE75sg1fulhUmN1NSPOxFtp0zWGBCHDd4c=
X-Received: by 2002:a05:622a:1b9f:b0:3de:1aaa:42f5 with SMTP id
 bp31-20020a05622a1b9f00b003de1aaa42f5mr440373qtb.15.1695057905499; Mon, 18
 Sep 2023 10:25:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-2-rananta@google.com>
 <ZQSvB4ZZ25eIHt/G@linux.dev>
In-Reply-To: <ZQSvB4ZZ25eIHt/G@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 18 Sep 2023 10:24:53 -0700
Message-ID: <CAJHc60zdow4OPTh27V=LR3TNHjUqtuxq5KOqKrAj0Fyw9VORBA@mail.gmail.com>
Subject: Re: [PATCH v5 01/12] KVM: arm64: PMU: Introduce a helper to set the
 guest's PMU
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 12:22=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Raghu,
>
> On Thu, Aug 17, 2023 at 12:30:18AM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Introduce a new helper function to set the guest's PMU
> > (kvm->arch.arm_pmu), and use it when the guest's PMU needs
> > to be set. This helper will make it easier for the following
> > patches to modify the relevant code.
> >
> > No functional change intended.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 52 +++++++++++++++++++++++++++------------
> >  1 file changed, 36 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 5606509724787..0ffd1efa90c07 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -865,6 +865,32 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int =
irq)
> >       return true;
> >  }
> >
> > +static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu=
)
> > +{
> > +     lockdep_assert_held(&kvm->arch.config_lock);
> > +
> > +     if (!arm_pmu) {
> > +             /*
> > +              * No PMU set, get the default one.
> > +              *
> > +              * The observant among you will notice that the supported=
_cpus
> > +              * mask does not get updated for the default PMU even tho=
ugh it
> > +              * is quite possible the selected instance supports only =
a
> > +              * subset of cores in the system. This is intentional, an=
d
> > +              * upholds the preexisting behavior on heterogeneous syst=
ems
> > +              * where vCPUs can be scheduled on any core but the guest
> > +              * counters could stop working.
> > +              */
> > +             arm_pmu =3D kvm_pmu_probe_armpmu();
> > +             if (!arm_pmu)
> > +                     return -ENODEV;
> > +     }
> > +
> > +     kvm->arch.arm_pmu =3D arm_pmu;
> > +
> > +     return 0;
> > +}
> > +
>
> I'm not too big of a fan of adding the 'default' path to this helper.
> I'd prefer it if kvm_arm_set_vm_pmu() does all the necessary
> initialization for a valid pmu instance. You then avoid introducing
> unexpected error handling where it didn't exist before.
>
>   static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>   {
>         lockdep_assert_held(&kvm->arch.config_lock);
>
>         kvm->arch.arm_pmu =3D arm_pmu;
>   }
>
>   /*
>    * Blurb about default PMUs I'm too lazy to copy/paste
>    */
>   static int kvm_arm_set_default_pmu(struct kvm *kvm)
>   {
>         struct arm_pmu *arm_pmu =3D kvm_pmu_probe_armpmu();
>
>         if (!arm_pmu)
>                 return -ENODEV;
>
>         kvm_arm_set_pmu(kvm, arm_pmu);
>         return 0;
>   }
>
Sounds good. We can adapt to your suggestion.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver

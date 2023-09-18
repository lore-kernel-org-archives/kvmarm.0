Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C205E21102
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 17:02:32 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-34fcc39fae1so3615ab.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 10:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695056552; x=1695661352; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAIfwvZ+63Hgn0zk0yrYnb3ogYKWcNYJOySoDjwnNsI=;
        b=LjooyziYOpVnBPTS1ptzdb3Z2/TvLY0nDqZ1aXU5ih1S6RK4gheZDXPESONeuLjoxm
         zqr+Dtyr/dyKnhFPZTcwklfct+bqCUWOlIUK9iiWG9xz8KkpKMpnwkK2URjIVcYRqxda
         eCruzHzlsDCgDHoSs+A9sMd5k9wekAiA1EVdrSdikCJMjoFV3hxbZ3AI1N/lms+82rpn
         CtVSre/N/r5WENSIRCMBdEV3SD1p7ECrTYOM0x4ZX4VgZLcIyB2Xkg8mEx8HjjD1eAsU
         KcydVOtdiFJfCO3qYdAQfZr0ijhwB3gJHMwhjuYkoT/tPeswq9ny4jZYBf651CZ8/ovs
         X63g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056552; x=1695661352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UAIfwvZ+63Hgn0zk0yrYnb3ogYKWcNYJOySoDjwnNsI=;
        b=o3BXEAEaQ0DITNFARh4xf+dRbygGYppQecx5KP8oahwHp7u7UaKW0S0WJHa1OKxfu1
         Y5jZ2DKWaLEcy65KBuTqFOKAzYXrr/NlAOfwtVt65uyxwk3Ff68ZEvHJk5H6i0Xzkjfg
         GGKnamjgadZhY2TKEcOzTmNQxcnJMIUhYgNcxjzVOJTA2ZM4eu2LLQKJtLvFAwpVr+aK
         FN9JR4j2y4OH9DojudGaVd+dVGtVVwSFVrE8/+hcYZDiHjAozwCLSEkUZtB8Uc6W22KP
         ftgUVIyLUnTSB035q1Cc+QuM2v4zIVm9jj6DKgxV4hrU/hoE2cYR1F7Yk3VEffZqh2EO
         FtEw==
X-Gm-Message-State: AOJu0Yw8CYPLml8AGmaYGwJ2uTVs0QKnSLEuAqwVKVR0F+poch789gzs
	Hh+gOs2k2r1JHXIISQKaVdNdR2QV+iaJELpHrZkBWQ==
X-Google-Smtp-Source: AGHT+IGbG5HCAHrf21JXiJ2VopMjnmhcCdJ+ID6HHTdX+uCNc+yb9AJgBSzDPxGjHJugKAvODmx8+FJZW+RvRyCe3Kw=
X-Received: by 2002:a05:6e02:144e:b0:34c:acb5:11bd with SMTP id
 p14-20020a056e02144e00b0034cacb511bdmr598183ilo.16.1695056551832; Mon, 18 Sep
 2023 10:02:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <6dc460d2-c7fb-e299-b0a3-55b43de31555@redhat.com> <CAJHc60whpvOHYCFueqh0Q=SbmmeRBG_x90QOvX+vOun73ttjPA@mail.gmail.com>
 <e479914b-7ba2-3a9a-2b07-9965532cbcfa@redhat.com> <ZQTAOcTsGPos/mBD@linux.dev>
In-Reply-To: <ZQTAOcTsGPos/mBD@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 18 Sep 2023 10:02:20 -0700
Message-ID: <CAJHc60zNaCOckeBdqfq1Ac8p7TTRFK6j7bMGMA49Twa763NTkA@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Shaoqin Huang <shahuang@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 1:36=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Tue, Aug 22, 2023 at 11:26:23AM +0800, Shaoqin Huang wrote:
>
> [...]
>
> > > > > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r,
> > > > > +                 u64 val)
> > > > > +{
> > > > > +     struct kvm *kvm =3D vcpu->kvm;
> > > > > +     u64 new_n, mutable_mask;
> > > > > +     int ret =3D 0;
> > > > > +
> > > > > +     new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > > > > +
> > > > > +     mutex_lock(&kvm->arch.config_lock);
> > > > > +     if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> > > > > +             /*
> > > > > +              * The vCPU can't have more counters than the PMU
> > > > > +              * hardware implements.
> > > > > +              */
> > > > > +             if (new_n <=3D kvm->arch.pmcr_n_limit)
> > > > > +                     kvm->arch.pmcr_n =3D new_n;
> > > > > +             else
> > > > > +                     ret =3D -EINVAL;
> > > > > +     }
> > > >
> > > > Since we have set the default value of pmcr_n, if we want to set a =
new
> > > > pmcr_n, shouldn't it be a different value?
> > > >
> > > > So how about change the checking to:
> > > >
> > > > if (likely(new_n <=3D kvm->arch.pmcr_n_limit)
> > > >          kvm->arch.pmcr_n =3D new_n;
> > > > else
> > > >          ret =3D -EINVAL;
> > > >
> > > > what do you think?
> > > >
> > > Sorry, I guess I didn't fully understand your suggestion. Are you
> > > saying that it's 'likely' that userspace would configure the correct
> > > value?
> > >
> > It depends on how userspace use this api to limit the number of pmcr. I
> > think what you mean in the code is that userspace need to set every vcp=
u's
> > pmcr to the same value, so the `unlikely` here is right, only one vcpu =
can
> > change the kvm->arch.pmcr.n, it saves the cpu cycles.
> >
> > What suggest above might be wrong. Since I think when userspace want to
> > limit the number of pmcr, it may just set the new_n on one vcpu, since =
the
> > kvm->arch.pmcr_n is a VM-local value, every vcpu can see it, so it's
> > `likely` the (new_n <=3D kvm->arch.pmcr_n_limit), it can decrease one c=
hecking
> > statement.
>
> How about we just do away with branch hints in the first place? This is
> _not_ a hot path.
>
Sounds good to me.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver

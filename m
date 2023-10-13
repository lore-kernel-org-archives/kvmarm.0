Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8814323751
	for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 20:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eRg5N51C"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1c9d4f08d7cso13145ad.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 13:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697228891; x=1697833691; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQUYjiIQQuKU5hgKTdO4y33bIv6BP+oihrBBQRGii7o=;
        b=eRg5N51CkcYApKScYl+TZYU10yhi3yeg9tX1UrwxccHdPeACIVMqUCN1Bqq2s8zpxe
         5ZBtMZPybE/YZavFg5IKb5dW0zMF1sOtck5OYF6AWcbQabiUNqakLcdxXq2Ec1fixRzM
         OHYz/k88z83WqCIeRXVasR1FDBY97qZmkxojoSJvsaoFsQ9goMola9SpNTSKUAQMBmEa
         CcIfZ235SiyHjLwxZRPZgfTdclqGT5vTpUOO0nMTYOafmnLwjkdtr03Pgz71NJEMEnOe
         OwAMB9mjgdO4qPslRW8HHwYF3V+OtRt1FsZ4rgWQrUzHF8q9lyB1lZxt/NGM1xzH4O17
         Enkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697228891; x=1697833691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hQUYjiIQQuKU5hgKTdO4y33bIv6BP+oihrBBQRGii7o=;
        b=TyplYF1xbSVLvkbQXAImnYBXbvY341dv8Z3ZZIiPQAwkxZ9E0vBW9ravTFjp8SFcZM
         GNcPakQpJFFQO7mFG+/SK/uLMnnnVsDephEEMIlbkfixheDYLwiATxvFB5gqvRA91/hK
         quxRNzoJn+1QWVmTVNf9HYkJZ+LKVWpOELCFrZLn1DRpQictSa5p9yjzBSKwtNwUnhlT
         TYJGSxepCcmbBZurwK/hqrOrLKa0G2LXkQyt1M8GJRMh+Je+UzV0k5RHUOWbFCw2G+2i
         bPZaPua05+a1ijhYABYUkNxHEtaNG2CkUAAexQzANX5fPo2TXigdqbh1Ds6C5CR03TC4
         4+lA==
X-Gm-Message-State: AOJu0YxC/yTBglVju+E2yvu5VeK8hiU9PYPK1ltAi0wHygY2g4rNVa8e
	z5vk1El8SDR6lhKoNhztHoz2w4gGCy6kp+Ti9WmTNg==
X-Google-Smtp-Source: AGHT+IF+wbBQUzCClYbIsavRQnVYMQpZNLI2ELD+7IF1suaSE/kY6/BRJ0kMNOpbN7SpoHfHj5jpKNFUpadFhMTbM8Q=
X-Received: by 2002:a17:903:40c1:b0:1ca:42a:1773 with SMTP id
 t1-20020a17090340c100b001ca042a1773mr33105pld.12.1697228890595; Fri, 13 Oct
 2023 13:28:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-3-rananta@google.com>
 <ZSXPbKH519uWXytf@linux.dev>
In-Reply-To: <ZSXPbKH519uWXytf@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 13 Oct 2023 13:27:58 -0700
Message-ID: <CAJHc60yBnA00Vv=vVeDuS=ccN-Ak4ZEgYvCfGWcfP3g3Zq+Uzg@mail.gmail.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest before vCPU reset
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

On Tue, Oct 10, 2023 at 3:25=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghu,
>
> On Mon, Oct 09, 2023 at 11:08:48PM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > The following patches will use the number of counters information
> > from the arm_pmu and use this to set the PMCR.N for the guest
> > during vCPU reset. However, since the guest is not associated
> > with any arm_pmu until userspace configures the vPMU device
> > attributes, and a reset can happen before this event, assign a
> > default PMU to the guest just before doing the reset.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/arm.c      | 20 ++++++++++++++++++++
> >  arch/arm64/kvm/pmu-emul.c | 12 ++----------
> >  include/kvm/arm_pmu.h     |  6 ++++++
> >  3 files changed, 28 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 78b0970eb8e6..708a53b70a7b 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1313,6 +1313,23 @@ static bool kvm_vcpu_init_changed(struct kvm_vcp=
u *vcpu,
> >                            KVM_VCPU_MAX_FEATURES);
> >  }
> >
> > +static int kvm_vcpu_set_pmu(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +
> > +     if (!kvm_arm_support_pmu_v3())
> > +             return -EINVAL;
>
> This check is pointless; the vCPU feature flags have been sanitised at
> this point, and a requirement of having PMUv3 is that this predicate is
> true.
>
Oh yes. I'll avoid this in v8.

> > +     /*
> > +      * When the vCPU has a PMU, but no PMU is set for the guest
> > +      * yet, set the default one.
> > +      */
> > +     if (unlikely(!kvm->arch.arm_pmu))
> > +             return kvm_arm_set_default_pmu(kvm);
> > +
> > +     return 0;
> > +}
> > +
>
> Apologies, I believe I was unclear last time around as to what I was
> wanting here. Let's call this thing kvm_setup_vcpu() such that we can
> add other one-time setup activities to it in the future.
>
> Something like:
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 96641e442039..4896a44108e0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1265,19 +1265,17 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu=
 *vcpu,
>                              KVM_VCPU_MAX_FEATURES);
>  }
>
> -static int kvm_vcpu_set_pmu(struct kvm_vcpu *vcpu)
> +static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
>  {
>         struct kvm *kvm =3D vcpu->kvm;
>
> -       if (!kvm_arm_support_pmu_v3())
> -               return -EINVAL;
> -
>         /*
>          * When the vCPU has a PMU, but no PMU is set for the guest
>          * yet, set the default one.
>          */
> -       if (unlikely(!kvm->arch.arm_pmu))
> -               return kvm_arm_set_default_pmu(kvm);
> +       if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
> +           kvm_arm_set_default_pmu(kvm))
> +               return -EINVAL;
>
>         return 0;
>  }
> @@ -1297,7 +1295,8 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *v=
cpu,
>
>         bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEAT=
URES);
>
> -       if (kvm_vcpu_has_pmu(vcpu) && kvm_vcpu_set_pmu(vcpu))
> +       ret =3D kvm_setup_vcpu(vcpu);
> +       if (ret)
>                 goto out_unlock;
>
>         /* Now we know what it is, we can reset it. */
>
Introducing kvm_setup_vcpu() seems better than directly calling
kvm_vcpu_set_pmu(), which feels like it's crashing a party.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver

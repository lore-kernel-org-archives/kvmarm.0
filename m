Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0624438F9C
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 17:07:30 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-34fc9b461b6so3055ab.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 10:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695056850; x=1695661650; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rYA2c6obTkYF/X7G/B4Xb9ciRYUkDwbnPL4CtJ0MRDU=;
        b=QmxU46UIIYfTsE5QzVFE35k9VwMupM6DT6L55UiUgS3B9iCpew24jSkyDpBpSDNbP6
         XKrSpbQ9EHpvdH9o/U09OPL34suBjJTs0it+PTerBJTqZrqxD7QVD+emVCB293ollRk3
         RvxA0oCRYYh18nmvMoTCq9jobQeEOI+fyI4VoHNI2PZne9Bcyu8Na5Uk3awk/sV0pffV
         owH7IpyH5B7ezMGxXOTQthI3AOvt1L2UnVwbHVKdWIKb14pumxiLCkSN6n7Dh7qNpiaK
         ao4QrlDoTzIyvm21j/USS+D3rhiQ5ECGaN5FV70WGzgURxvzYo9VVkwgpymc0JSlyOEe
         2njw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056850; x=1695661650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rYA2c6obTkYF/X7G/B4Xb9ciRYUkDwbnPL4CtJ0MRDU=;
        b=G/69ezLenGSQ748pe5WSn+3UmFSiwvRaGWqYvCfmStcivA3UTdTROyq+TZ8hRHcu4I
         4EwcIgepxMJqKDjMKQ04+TP2gRddViR1xqQqHGEoJcAswVEl6UOk50V//uhzLe8u16hN
         gRow2B2eF/Tr8Ld6gJIJeTfGMQ+JjpTBIYEjdMguYGodDxYqeGmSw+8xjaFRTQln4EZM
         YQ9xJxrBJD9VlWTKwWceAeIsUrT/2EZE7Y8f95KJUQPt1SR87ZU5F9Ef5qwuFdnmej/4
         1QNfZp0kbwP+I5sQa6Gl7JdaQr+4VX2p7OK1wnXxQM6bXCmmXl1C18fkPLQfRTXRloFF
         H+/Q==
X-Gm-Message-State: AOJu0YzVfqCPkxd0CvVNVoe1yO3sKrXhJBSW61z1Yczkiu8ZPN1lc+l8
	QMAXYsgCTpGdQoHlrx6VSfPjv+Cp095X5irCjbw/gg==
X-Google-Smtp-Source: AGHT+IGVdeQMwoGs8//hYqXO7csKKsfJ0eIi9bZUpFtpSAzGyoAbEGyZpqkX1zVCm9RwmUqBlnWF0EA3iIlyCely84U=
X-Received: by 2002:a05:6e02:170f:b0:34d:f90f:d42a with SMTP id
 u15-20020a056e02170f00b0034df90fd42amr602937ill.1.1695056850063; Mon, 18 Sep
 2023 10:07:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <ZQTEN664F/5PzyId@linux.dev>
In-Reply-To: <ZQTEN664F/5PzyId@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 18 Sep 2023 10:07:18 -0700
Message-ID: <CAJHc60wUgvmXHajwV2cb+f1aLOu7Zb+VyckedENPzsPw2URBGA@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
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

On Fri, Sep 15, 2023 at 1:53=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghu,
>
> On Thu, Aug 17, 2023 at 12:30:25AM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > KVM does not yet support userspace modifying PMCR_EL0.N (With
> > the previous patch, KVM ignores what is written by upserspace).
>
> typo: userspace
>
Noted.
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index ce7de6bbdc967..39ad56a71ad20 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_=
pmu *arm_pmu)
> >        * while the latter does not.
> >        */
> >       kvm->arch.pmcr_n =3D arm_pmu->num_events - 1;
> > +     kvm->arch.pmcr_n_limit =3D arm_pmu->num_events - 1;
>
> Can't we just get at this through the arm_pmu instance rather than
> copying it into kvm_arch?
>
Yeah, I suppose we can directly access it in set_pmcr().

Thank you.
Raghavendra
> >       return 0;
> >  }
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 2075901356c5b..c01d62afa7db4 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r,
> >       return 0;
> >  }
> >
> > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
> > +                 u64 val)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +     u64 new_n, mutable_mask;
> > +     int ret =3D 0;
> > +
> > +     new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > +
> > +     mutex_lock(&kvm->arch.config_lock);
> > +     if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> > +             /*
> > +              * The vCPU can't have more counters than the PMU
> > +              * hardware implements.
> > +              */
> > +             if (new_n <=3D kvm->arch.pmcr_n_limit)
> > +                     kvm->arch.pmcr_n =3D new_n;
> > +             else
> > +                     ret =3D -EINVAL;
> > +     }
>
> Hmm, I'm not so sure about returning an error here. ABI has it that
> userspace can write any value to PMCR_EL0 successfully. Can we just
> ignore writes that attempt to set PMCR_EL0.N to something higher than
> supported by hardware? Our general stance should be that system register
> fields responsible for feature identification are immutable after the VM
> has started.
>
> --
> Thanks,
> Oliver

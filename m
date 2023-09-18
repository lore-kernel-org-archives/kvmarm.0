Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BE42421B
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 17:11:30 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-34fa117f92bso4225ab.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 10:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695057090; x=1695661890; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3k+upgBrLGSSOmHlswDoCSbrUwpeYXhWKscYPZe5kLQ=;
        b=pSHPktHP2c/t6vt6PbLHT/4nFSfiTfjbT1A4xYX4Gaob0JcJJQz987X4cbtZ619bVW
         Ys5MUUQq77G8SC0SNi28hMrWZTy71L78Q6vEiloM3wu9nNvtdQ+MyEmzOzr/pqOOHvwz
         cp5wvnSfi6shdjlU9QGFDyHkg0OXcYCd97Zugh03lAk/Qeltouce96vkQp1T+uWcVE+W
         6DSdYzmNMXIKB5qzglSX9znz0ZtC7D/8gWOH9tKa22TrNiq/HKSa2HJlV2uOytQSSvfA
         hInsliS/ZpD53wvLeG824Syx7mnMgHQdi3Y/q85beqGyfc0hp4qNWFo+RaqHrICFWIR6
         QUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057090; x=1695661890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3k+upgBrLGSSOmHlswDoCSbrUwpeYXhWKscYPZe5kLQ=;
        b=l8nK4vcy1r5YDYi+oneCrbLwPRAN6uBB+25bV+MXathBQoLwP+SFiKkytOKXDuyObu
         kv42iz9eyOBCkbOb/lID1Tt+g0kkv53kr3HgBaBrmJ2FhzZvoAywUa4qxQ6m03YL1pkO
         P2zj51CRqDUQccsWrRW2gZ4FssdemjggfbFhG9tryAZNPUPB9Y726zjkzvX63b1DKmtX
         feTR6bnxL01EczVlzV1OHvbREvqTGEJxDZB7nvAjI2JMt5vB589vZT5zAeY797Ci3eus
         ApJq9VWATe8lqFHE9Q089mn8feD56YGSwArqGIykv/6vSVRstriDTrFDj3r6hagDsbYn
         Ar3g==
X-Gm-Message-State: AOJu0Yx442xWOXiBNYde3A2CPSc3iJvW7epDplvrcF+aK9EsvZOlXcJ8
	HQJg5wojV0E/UpkMphiW6jRkeJdrWVbmniJpZ/TjdA==
X-Google-Smtp-Source: AGHT+IFXnWVBdmal21Mo0WOdEFrfSBufsaS+Fo7roEwvkyqUs6Wh6JTU3kxhl16Zf6PSyXCLyOwgCR1YaZoJgobr8mg=
X-Received: by 2002:a92:c247:0:b0:346:139d:4549 with SMTP id
 k7-20020a92c247000000b00346139d4549mr459650ilo.1.1695057089709; Mon, 18 Sep
 2023 10:11:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <ZQTEN664F/5PzyId@linux.dev> <ZQTSffkkI1x5lWIG@linux.dev>
In-Reply-To: <ZQTSffkkI1x5lWIG@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 18 Sep 2023 10:11:17 -0700
Message-ID: <CAJHc60y+xwV3oYk7-YxE1WiOfnSNFzroM419UDJwTeb=MCJdkA@mail.gmail.com>
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

On Fri, Sep 15, 2023 at 2:54=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Sep 15, 2023 at 08:53:16PM +0000, Oliver Upton wrote:
> > Hi Raghu,
> >
> > On Thu, Aug 17, 2023 at 12:30:25AM +0000, Raghavendra Rao Ananta wrote:
> > > From: Reiji Watanabe <reijiw@google.com>
> > >
> > > KVM does not yet support userspace modifying PMCR_EL0.N (With
> > > the previous patch, KVM ignores what is written by upserspace).
> >
> > typo: userspace
> >
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > index ce7de6bbdc967..39ad56a71ad20 100644
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct ar=
m_pmu *arm_pmu)
> > >      * while the latter does not.
> > >      */
> > >     kvm->arch.pmcr_n =3D arm_pmu->num_events - 1;
> > > +   kvm->arch.pmcr_n_limit =3D arm_pmu->num_events - 1;
> >
> > Can't we just get at this through the arm_pmu instance rather than
> > copying it into kvm_arch?
> >
> > >     return 0;
> > >  }
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 2075901356c5b..c01d62afa7db4 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, con=
st struct sys_reg_desc *r,
> > >     return 0;
> > >  }
> > >
> > > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r,
> > > +               u64 val)
> > > +{
> > > +   struct kvm *kvm =3D vcpu->kvm;
> > > +   u64 new_n, mutable_mask;
> > > +   int ret =3D 0;
> > > +
> > > +   new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > > +
> > > +   mutex_lock(&kvm->arch.config_lock);
> > > +   if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> > > +           /*
> > > +            * The vCPU can't have more counters than the PMU
> > > +            * hardware implements.
> > > +            */
> > > +           if (new_n <=3D kvm->arch.pmcr_n_limit)
> > > +                   kvm->arch.pmcr_n =3D new_n;
> > > +           else
> > > +                   ret =3D -EINVAL;
> > > +   }
> >
> > Hmm, I'm not so sure about returning an error here. ABI has it that
> > userspace can write any value to PMCR_EL0 successfully. Can we just
> > ignore writes that attempt to set PMCR_EL0.N to something higher than
> > supported by hardware? Our general stance should be that system registe=
r
> > fields responsible for feature identification are immutable after the V=
M
> > has started.
>
> I hacked up my reply and dropped some context; this doesn't read right.
> Shaoqin made the point about preventing changes to PMCR_EL0.N after the
> VM has started and I firmly agree. The behavior should be:
>
>  - Writes to PMCR always succeed
>
>  - PMCR_EL0.N values greater than what's supported by hardware are
>    ignored
>
>  - Changes to N after the VM has started are ignored.
>
Reiji and I were wondering if we should proceed with this as this
would change userspace expectation. BTW, when you said "ignored", does
that mean we silently return to userspace with a success or with EBUSY
(changing the expectations)?

Thank you.
Raghavendra
> --
> Thanks,
> Oliver

Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E70200BF
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 17:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GsQ7hU09"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3575da42138so5285ab.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 10:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698082975; x=1698687775; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBXLA8TPJ+R5jc8eUaCSA4IRG8aS6kWKghdqJo/ZP+w=;
        b=GsQ7hU09Nz6vYiRBtkmNkU3PpTXrZtcla/KuN7kcIQuF8RqodLnRSc3yvCxsnb8fj/
         BApfvNpuJHti789sCt2oWRBPx92snYxHhLQZTAVXwQOCnBIblAGgFyVqGIY/sMOWUFXJ
         kqzwiyhTWOHTIezlB4XW028pJTB5bjeVxTdpUkzqueN3sR8Z4qrM0zuBWykn4yTIp0J8
         G9InLj76q+0/rvv6arZPCS/nZfD1RrsGSuTOVKnhM/anQGOuVrkOPYCyrK+iJ8XQLac3
         R5f2ciYSDSC8F//kd+uV53hMhEKqzp5b3jH9m2uK/eBD3Z5e1bIEQeKe3HPZ19aB7OI7
         mKNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698082975; x=1698687775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DBXLA8TPJ+R5jc8eUaCSA4IRG8aS6kWKghdqJo/ZP+w=;
        b=TheXtY1/gGBsTCCxhS9TNBs2oeTeNPhS9MrOVAl61qsg6POexOpg0w3uqelrj1TgPn
         ZLE0CMxS4poIvnvuuG2rVYdLgUFBQdoR2MrGbVsWT2Z+0+jJqlkqIwYIDdcW7uPYgyOa
         szXjnPAGZqPwdC4CHQQ2JucUhF6SnOqufxmoTUOsj/jHqUd2GQ/k3L8IMBfm0/q0Stqq
         fbJ/3Kp+0aGCwezIuG09u3qwobRwCGzOmo42eNX8ZCAAdv7/4st5Yt0L3aNXTX/LVwuz
         FOSWjmS/ZnWvtDcAGigsvnHVMGJoVYPIUkYEBjNGmMMycBCUfgsDiwgL3UfKPJjxVaEL
         NUvw==
X-Gm-Message-State: AOJu0YxNJCgt6dzBADTbrsxR3U/OMT+DgU5LGrBxm/D0wZsbi4O9XZ2d
	avFK4wO8aXR/ENpcjG1RGv+EOpC+nNsp5hAuI13h0g==
X-Google-Smtp-Source: AGHT+IFOLMLfZ/CbMtl3aYr9wCDJJ/AkWXKomQ1ThhlnhF2P9M/9E+1cO1Nj9S7F060LZgwP9Ug5HzsRJ/45KmsTmjY=
X-Received: by 2002:a05:6e02:1d0a:b0:357:ca4f:a275 with SMTP id
 i10-20020a056e021d0a00b00357ca4fa275mr13270ila.29.1698082975047; Mon, 23 Oct
 2023 10:42:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-7-rananta@google.com>
 <86y1ft4ijm.wl-maz@kernel.org>
In-Reply-To: <86y1ft4ijm.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 23 Oct 2023 10:42:43 -0700
Message-ID: <CAJHc60xijk_QpxK-eDzdY2g2OXXaQ3En=fBfBe45hAjuJMFNUw@mail.gmail.com>
Subject: Re: [PATCH v8 06/13] KVM: arm64: Sanitize PM{C,I}NTEN{SET,CLR},
 PMOVS{SET,CLR} before first run
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 5:42=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 20 Oct 2023 22:40:46 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > For unimplemented counters, the registers PM{C,I}NTEN{SET,CLR}
> > and PMOVS{SET,CLR} are expected to have the corresponding bits RAZ.
> > Hence to ensure correct KVM's PMU emulation, mask out the bits in
> > these registers for these unimplemented counters before the first
> > vCPU run.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/arm.c      |  2 +-
> >  arch/arm64/kvm/pmu-emul.c | 11 +++++++++++
> >  include/kvm/arm_pmu.h     |  2 ++
> >  3 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e3074a9e23a8b..3c0bb80483fb1 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -857,7 +857,7 @@ static int check_vcpu_requests(struct kvm_vcpu *vcp=
u)
> >               }
> >
> >               if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
> > -                     kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu=
));
> > +                     kvm_vcpu_handle_request_reload_pmu(vcpu);
>
> Please rename this to kvm_vcpu_reload_pmu(). That's long enough. But
> see below.
>
Sounds good.

> >
> >               if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
> >                       kvm_vcpu_pmu_restore_guest(vcpu);
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 9e24581206c24..31e4933293b76 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -788,6 +788,17 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool=
 pmceid1)
> >       return val & mask;
> >  }
> >
> > +void kvm_vcpu_handle_request_reload_pmu(struct kvm_vcpu *vcpu)
> > +{
> > +     u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> > +
> > +     kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
> > +
> > +     __vcpu_sys_reg(vcpu, PMOVSSET_EL0) &=3D mask;
> > +     __vcpu_sys_reg(vcpu, PMINTENSET_EL1) &=3D mask;
> > +     __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &=3D mask;
> > +}
>
> Why is this done on a vcpu request? Why can't it be done upfront, when
> we're requesting the reload? Or when assigning the PMU? Or when
> setting PMCR_EL0?
>
The idea was to do this only once, after userspace has configured the
PMCR.N (and has no option to change it), but before we run the guest
for the first time. So, I guess this can be done when we are
requesting the reload, if you prefer.

When assigning the PMU, it could be too early to sanitize as the
userspace would not have configured the PMCR.N yet.
It can probably be done when userspace configures PMCR.N, but since
this field is per-guest, we may have to apply the setting for all the
vCPUs during the ioctl, which may get a little ugly.

Thank you.
Raghavendra

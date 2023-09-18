Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529A510E5
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 16:41:15 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-34f1ffda46fso1745ab.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 09:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695055274; x=1695660074; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5aqGbaeNMJotwM7iCcNvbcrR77QfKFKAxShP18uzRjU=;
        b=XyKVaq5d1PRq3FmMTziaVO2keAhcB3+MZ+ltePL1zSKzLSdo1HhlCuDyVwxcExRtWD
         TtZUlchdH3+NGgWJxoyN0cl3wdIE+6Au93tbPQ36bWnmg8NTgkz+g3mCp8bx8Pfdpd7t
         Kl9bzQ7GH8wH7EhIE5yp8ElAyY9t0NTDex+wLrwgfgTyBOaDF2CRsh2YKT0c00DjX3kW
         xsgVpxTP9mRjYDpItGfHRUkN6G43b1Cw7KOePeJ/8LMJAffCgYwQ15XfhTU80vvTOq87
         ucITJ8K1lzJEH0EgREhf/M2RSV6o8qAyWJor+lESZsuNPRFvTM9MP2XQgaopB08ProMj
         cSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695055274; x=1695660074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5aqGbaeNMJotwM7iCcNvbcrR77QfKFKAxShP18uzRjU=;
        b=BZIZVkdJRRixuzbjiC/kg0HXWuEXbvzMYAiSKDONd6HC9GQ0Ch7EkzVTELZX2wT6II
         s423at9YTZCLjv7Vb5Mx+gfsUA73s1ndtVm+FZ91pDCg61JzUrlrVhp4wAa9vFljYSpf
         IC//uCEgogBpcPOYJQuznILsfUCe5PHEmWoCet0N5sX61nAPtFpOewGrk0ou7xtzwQ7x
         HCz7xYfGyvd6kW6cDRHHztTuBDJ1RKWcHE2tuQUrSl8giIdijg0dT9ZlyiQFw2GH3JRL
         XZ6FxnUiREcIYwCjeUFYcwcAhGkRKICfQpoC++ChNiTDUyMrvn8SysFFEfr7fc0NrLI/
         WbLw==
X-Gm-Message-State: AOJu0Ywjo2pj1JT7yKFd0e7qvTnye3eFN/LPQMsS/WEz0xi4bypmO8vp
	ziq6oQm5z13lq8IiY/O1j41V6RlU1xemhouhqj6q5Q==
X-Google-Smtp-Source: AGHT+IEjfMXn2J6ovPUYwQwB4N3TZ7e0VJro4Y/MYTineoS/HmnF09g/ZrKe8qRHFCo3KYHd3FCjmghRT+DcQsanPW8=
X-Received: by 2002:a05:6e02:1c47:b0:34d:ec9d:df60 with SMTP id
 d7-20020a056e021c4700b0034dec9ddf60mr409293ilg.17.1695055274260; Mon, 18 Sep
 2023 09:41:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-3-rananta@google.com>
 <ZQSxgWWZ3YdNgeiC@linux.dev>
In-Reply-To: <ZQSxgWWZ3YdNgeiC@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 18 Sep 2023 09:41:02 -0700
Message-ID: <CAJHc60ytL7T73wwabD8C2+RkVgN3OQsNuBwdQKz+Qen9b_hq9A@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
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

On Fri, Sep 15, 2023 at 12:33=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Thu, Aug 17, 2023 at 12:30:19AM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > The following patches will use the number of counters information
> > from the arm_pmu and use this to set the PMCR.N for the guest
> > during vCPU reset. However, since the guest is not associated
> > with any arm_pmu until userspace configures the vPMU device
> > attributes, and a reset can happen before this event, call
> > kvm_arm_support_pmu_v3() just before doing the reset.
> >
> > No functional change intended.
>
> But there absolutely is a functional change here, and user visible at
> that. KVM_ARM_VCPU_INIT ioctls can now fail with -ENODEV, which is not
> part of the documented errors for the interface.
>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c |  9 +--------
> >  arch/arm64/kvm/reset.c    | 18 +++++++++++++-----
> >  include/kvm/arm_pmu.h     |  6 ++++++
> >  3 files changed, 20 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 0ffd1efa90c07..b87822024828a 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -865,7 +865,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int i=
rq)
> >       return true;
> >  }
> >
> > -static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu=
)
> > +int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
> >  {
> >       lockdep_assert_held(&kvm->arch.config_lock);
> >
> > @@ -937,13 +937,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,=
 struct kvm_device_attr *attr)
> >       if (vcpu->arch.pmu.created)
> >               return -EBUSY;
> >
> > -     if (!kvm->arch.arm_pmu) {
> > -             int ret =3D kvm_arm_set_vm_pmu(kvm, NULL);
> > -
> > -             if (ret)
> > -                     return ret;
> > -     }
> > -
> >       switch (attr->attr) {
> >       case KVM_ARM_VCPU_PMU_V3_IRQ: {
> >               int __user *uaddr =3D (int __user *)(long)attr->addr;
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index bc8556b6f4590..4c20f1ccd0789 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -206,6 +206,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu =
*vcpu)
> >   */
> >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >  {
> > +     struct kvm *kvm =3D vcpu->kvm;
> >       struct vcpu_reset_state reset_state;
> >       int ret;
> >       bool loaded;
> > @@ -216,6 +217,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >       vcpu->arch.reset_state.reset =3D false;
> >       spin_unlock(&vcpu->arch.mp_state_lock);
> >
> > +     /*
> > +      * When the vCPU has a PMU, but no PMU is set for the guest
> > +      * yet, set the default one.
> > +      */
> > +     if (kvm_vcpu_has_pmu(vcpu) && unlikely(!kvm->arch.arm_pmu)) {
> > +             ret =3D -EINVAL;
> > +             if (kvm_arm_support_pmu_v3())
> > +                     ret =3D kvm_arm_set_vm_pmu(kvm, NULL);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
>
> On top of my prior suggestion w.r.t. the default PMU helper, I'd rather
> see this block look like:
>
>         if (kvm_vcpu_has_pmu(vcpu)) {
>                 if (!kvm_arm_support_pmu_v3())
>                         return -EINVAL;
>                 /*
>                  * When the vCPU has a PMU but no PMU is set for the
>                  * guest yet, set the default one.
>                  */
>                 if (unlikely(!kvm->arch.arm_pmu) && kvm_set_default_pmu(k=
vm))
>                         return -EINVAL;
>         }
>
> This would eliminate the possibility of returning ENODEV to userspace
> where we shouldn't.
>
I understand that we'll be breaking the API contract and userspace may
have to adapt to this change, but is it not acceptable to document and
return ENODEV, since ENODEV may offer more clarity to userspace as to
why the ioctl failed? In general, do we never extend the APIs?

Thank you.
Raghavendra
> --
> Thanks,
> Oliver

Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB0D266DB
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 17:36:42 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1c6052422acso13945ad.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 10:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695836202; x=1696441002; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qCVNsJJaiR6CMnhGVjseVngepymRi6tNcmHrCszc8zo=;
        b=NArm5hVPPLZWr19fmPKD6ov4Wg2mEaa0QzZ1N/grUL69GjJZhWSr68e0CCsHkUQ5lT
         jJOjYrmo01QUbnuem/QZlSwmPEIGhegOSrRZxBm3YHzcPdrKfQ8PMsPMG1DKFA1z4WE+
         fhtM0sEtPHrvmEbUxfx5wctmwApcl13Kpx0sIfBqqqTWEYu0TG29xCaaFJ4T6+I+BtIl
         RUOUMcRa+GzRgWICqiYy3WScwuACftUWOYWkuacMc7UUeGOq/6z6jJYBCgoJDW0Kg4jY
         NF0l25Ac7QWirptO4aC5hPpLFF/Q28SCXQjt07q9sFHCCnB4u4Cu7iTfrNDL1AgyI6SI
         SQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695836202; x=1696441002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qCVNsJJaiR6CMnhGVjseVngepymRi6tNcmHrCszc8zo=;
        b=pClg73CCMpfvaEEvjuxvg9bkKyeemXgRM6IHWQ3dtw9yPsRqlvH4ajrIy4g6/tAywh
         L8FG2HmGvP8fmQteq5IQ8WMvyMNwIvQqAEJ3acbI2YhjUJeiFU/dXaHscd3LIPcPMCTi
         Qakjt7kPrIMwTHCZrMpolJ+RrOtxc3R4XAIOPRwC4Ao8ezb3RRViJzan8+PQI94dRC96
         cHMWZ/uZUoknwwTc3J6NawIhjnrc5tEQrptp3DscHDk4YeIh5DU/m0feOBVlR2P4GAq/
         bRtFv8D2LaXG/iJiDjA8+cUqayXi85xQQxeggTnpA262pYQNW7Kayj3GsBd7p2iDeSsT
         /oEg==
X-Gm-Message-State: AOJu0YwVMKpmZbfwVY+9wzGVNymsy5hWF++1NV2gICCxy+ZkHQ5S0Ea3
	QI+nqP508DZkSEJN2HCM3L5Ot1tvd4AwmKN60unzyQ==
X-Google-Smtp-Source: AGHT+IEVnwRkoJxc9UMrhf/mKiCwfxKglFuJfMCXqjV+dVaug9XIC4yr0Lkz6SA1D9Le6iCxPsNM2IAH3FHBtUiQxHg=
X-Received: by 2002:a17:903:2447:b0:1bc:66f2:4bb with SMTP id
 l7-20020a170903244700b001bc66f204bbmr542482pls.8.1695836201617; Wed, 27 Sep
 2023 10:36:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com> <20230926234008.2348607-3-rananta@google.com>
 <ZRPhoExoiU3_Jvxy@linux.dev>
In-Reply-To: <ZRPhoExoiU3_Jvxy@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 27 Sep 2023 10:36:29 -0700
Message-ID: <CAJHc60wRuqo3d=7J0jkoKehsrDWbZkwy2ADrPQpqaF-YYpH6DA@mail.gmail.com>
Subject: Re: [PATCH v6 02/11] KVM: arm64: PMU: Set the default PMU for the
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

Hi Oliver,

On Wed, Sep 27, 2023 at 1:02=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghu,
>
> On Tue, Sep 26, 2023 at 11:39:59PM +0000, Raghavendra Rao Ananta wrote:
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
> I would argue there still is a functional change here, as PMU
> initialization failure now shows up on a completely different ioctl for
> userspace.
>
> > @@ -216,6 +217,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >       vcpu->arch.reset_state.reset =3D false;
> >       spin_unlock(&vcpu->arch.mp_state_lock);
> >
> > +     if (kvm_vcpu_has_pmu(vcpu)) {
> > +             if (!kvm_arm_support_pmu_v3())
> > +                     return -EINVAL;
> > +
> > +             /*
> > +              * When the vCPU has a PMU, but no PMU is set for the gue=
st
> > +              * yet, set the default one.
> > +              */
> > +             if (unlikely(!kvm->arch.arm_pmu) && kvm_arm_set_default_p=
mu(kvm))
> > +                     return -EINVAL;
> > +     }
> > +
>
> Ah, this probably will not mix well with my recent change to get rid of
> the return value altogether from kvm_reset_vcpu() [*]. I see two ways to
> handle this:
>
>  - Add a separate helper responsible for one-time setup of the vCPU
>    called from KVM_ARM_VCPU_INIT which may fail.
>
>  - Add a check for !kvm->arch.arm_pmu to kvm_arm_pmu_v3_init().
>
> No strong preference, though.
>
Thanks for the pointer. I think adding it in kvm_arm_pmu_v3_init() may
not be feasible as the reset (reset_pmcr()) may happen before this
init and we may end up setting 0 as PMCR.N for the guest. I'll explore
the other option though.

Thank you.
Raghavendra
> [*]: https://lore.kernel.org/r/20230920195036.1169791-8-oliver.upton@linu=
x.dev
>
> --
> Thanks,
> Oliver

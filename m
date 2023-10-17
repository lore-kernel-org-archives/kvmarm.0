Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C16B2D054
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 16:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YeI5Dagi"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1c9c145bb5bso4905ad.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 09:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697561901; x=1698166701; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmPJRnpivnS9Ld3ifHaIxKEN+4gdJjCgtDpfk6S2hXE=;
        b=YeI5DagihAgCaqtsVCgSLzJBmc3GC/xW9yB/zn/MnCwOkUPR5Vk1eFdQ2NaXodQiln
         Upr4a69k6AQNuNMtN1+33d6K02a2x3qcd2OUdCJtNhVPBzgajQsTOeNafd0057+4mnsu
         2L2qgDxhHFlavc8UtASTqbYbCzm60AW24uoYpixOXThrt3msnz9pZpPqbTJ9BrkP7lPw
         rxqdo6ekYK5zyIqlIqU2cj1H3aKUSAD3s5AccbVjcHtirICCDoAAku6BXl9+gXikjgCx
         kg0VfPZ9magEG5vLqDsQwD8GVOzX7t3lcpcRzuhSYUbhk3rhUYtkpSAq6FbAlfc92c5U
         cncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697561901; x=1698166701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cmPJRnpivnS9Ld3ifHaIxKEN+4gdJjCgtDpfk6S2hXE=;
        b=Fqd43IBtu4QZfsDPLWlBFXgaTon2fto8QVgn4QVhWVnwK4LTIqhPXPUIkBlZBUMXrb
         0v9/RxdQ9kfapwuzuzAhrnHTQAFrUT1FL/3R+p5gFne7WLc+4sXs/MrCF8CJ4mS+6JCd
         AI5o/tCZfP5xcBnW8uE2xzzoLqBveMhtW5vedxVG8QDO2uE/IkEEDH9sNeOg0r8Sz6mY
         qOXgilIMUhtTT2EghmyO4vpAMDrfSE7Dzr3bOCOInpOidAKfdhWdsWAJyMOPFegm438H
         VzXMrJZKYNFt8VzDkQ9RnsIUaqLe8pkKd/k0KfJN5xUVtJsbWsO9E4NOV8YqMSmsMMeK
         hAAQ==
X-Gm-Message-State: AOJu0Yz27Q32IPe2gNcYYvBq52mQ9VShBoAqtU70UHl04L5L+c+HwKF4
	X5JP3g2YeE9AGqWtFoFnVOzqlMmupCdOVcphN7Yo8w==
X-Google-Smtp-Source: AGHT+IFdak6zKVvjh5pTE9PJ2mNYXu9g1c5yLqvHo5vfOMsPNjzinB8Vi5laVHN/edB4nVpOLqI1r90pCnv5KDaCrls=
X-Received: by 2002:a17:903:290:b0:1ca:16b8:b541 with SMTP id
 j16-20020a170903029000b001ca16b8b541mr6265plr.24.1697561900478; Tue, 17 Oct
 2023 09:58:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com> <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev> <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
 <ZS4hGL5RIIuI1KOC@linux.dev>
In-Reply-To: <ZS4hGL5RIIuI1KOC@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 17 Oct 2023 09:58:08 -0700
Message-ID: <CAJHc60zQb0akx2Opbh3_Q8JShBC_9NFNvtAE+bPNi9QqXUGncA@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16, 2023 at 10:52=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Mon, Oct 16, 2023 at 02:35:52PM -0700, Raghavendra Rao Ananta wrote:
>
> [...]
>
> > > What's the point of doing this in the first place? The implementation=
 of
> > > kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped val=
ue.
> > >
> > I guess originally the change replaced read_sysreg(pmcr_el0) with
> > kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
> > But if you and Sebastian feel that it's an overkill and directly
> > getting the value via vcpu->kvm->arch.pmcr_n is more readable, I'm
> > happy to make the change.
>
> No, I'd rather you delete the line where PMCR_EL0.N altogether.
> reset_pmcr() tries to initialize the field, but your
> kvm_vcpu_read_pmcr() winds up replacing it with pmcr_n.
>
I didn't get this comment. We still do initialize pmcr, but using the
pmcr.n read via kvm_vcpu_read_pmcr() instead of the actual system
register.

Thank you.
Raghavendra
> > @@ -1105,8 +1109,16 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
> >  /**
> >   * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
> >   * @vcpu: The vcpu pointer
> > + *
> > + * The function returns the value of PMCR.N based on the per-VM tracke=
d
> > + * value (kvm->arch.pmcr_n). This is to ensure that the register field
> > + * remains consistent for the VM, even on heterogeneous systems where
> > + * the value may vary when read from different CPUs (during vCPU reset=
).
>
> Since I'm looking at this again, I don't believe the comment is adding
> much. KVM doesn't read pmcr_el0 directly anymore, and kvm_arch is
> clearly VM-scoped context.
>
> >   */
> >  u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> >  {
> > -     return __vcpu_sys_reg(vcpu, PMCR_EL0);
> > +     u64 pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0) &
> > +                     ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT=
);
> > +
> > +     return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SH=
IFT);
> >  }
>
>
> --
> Thanks,
> Oliver

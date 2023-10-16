Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3188034182
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VDJwAU69"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1c9c496c114so36975ad.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 12:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697482959; x=1698087759; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOzjlLla6gf/R2odr013SLR7czPeJxtYfJ4GpduX1qQ=;
        b=VDJwAU69HjF6hOWn6z8PV7dJ5Cf9gS+eQLHxAJU0vbFVZD//Fg/D9wnKz/HqvChCas
         CpgjBqD+QD3HlbbGK5uSyEZMErDDIIfXGEZUXc+OBb3EnL4rkDvgw2HfqwZjCdbOpQBn
         70pCzFDJ79SGiQL1o5Sdf/B/VEjGj/J3nLHo9T7BGQbJK2ejisb8DriaFaNHii2SEaHt
         cBw9rPl0D92fB+WM1aKoP9h4iPmPWADafCWbSi7No9isLzFjSbKMm1WxIsuiKHVt6kSz
         YLEvpcmHo7WVkq6OhdJQNvymSq+crNCGncQZIPVt8skKbs7X1XIcw1oURPSM/xjlbw6q
         YXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697482959; x=1698087759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eOzjlLla6gf/R2odr013SLR7czPeJxtYfJ4GpduX1qQ=;
        b=Thr+xSuYTeZfD5z2DuNzUJZVOIGVghmPQcau7xdmtieOYhNkWg6/nzAfY9qTXPvFO1
         57CzhcHo2UW8mRmI8EjF5F5FtEbtA/V6/gpl76194yMftwi7PL6b1EW0SX6MjigETEYE
         KAkhSe2VZaLh/5XMqz1xwnp+90OdtJTcZLlF9sJIIH2nJbF19Rt1ZPLqW+tN82b8gu+y
         Wybkaz5e0JTHBi5eeA/hOkojNfZBszcjU57uzMPjCms/C2Wgsaz0TbISmcxTJo9k6HJk
         xNcm0t0nI2J3Q2SwE8YK3cdv7YoiRBJzC8Ett1kp8gjcPD2Gud0OtqdM7Ib5YXrZghoF
         TCSQ==
X-Gm-Message-State: AOJu0Ywy4DwMoHNV+T+PnoNI3o60fLgvKM6sRhJtEo1Vs2I7/m5DUmVR
	6eSqk6/JXif/P5A8yfd2r/C/q5bBCbDGhSomsos3Kw==
X-Google-Smtp-Source: AGHT+IHqX1FgDxN0Mas1wc4pev7LzweHD3IABO+VgwAeIVNA6y5WXfAi4taMg2wCM+3ptaDOC8hcAkvkOunXNYaEWVM=
X-Received: by 2002:a17:903:1c1:b0:1c9:af6a:6d0d with SMTP id
 e1-20020a17090301c100b001c9af6a6d0dmr25087plh.9.1697482959233; Mon, 16 Oct
 2023 12:02:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
In-Reply-To: <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 16 Oct 2023 12:02:27 -0700
Message-ID: <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
To: Sebastian Ott <sebott@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16, 2023 at 6:35=E2=80=AFAM Sebastian Ott <sebott@redhat.com> w=
rote:
>
> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> > u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> > {
> > -     return __vcpu_sys_reg(vcpu, PMCR_EL0);
> > +     u64 pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0) &
> > +                     ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT=
);
> > +
> > +     return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SH=
IFT);
> > }
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index ff0f7095eaca..c750722fbe4a 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -745,12 +745,8 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r)
> > {
> >       u64 pmcr;
> >
> > -     /* No PMU available, PMCR_EL0 may UNDEF... */
> > -     if (!kvm_arm_support_pmu_v3())
> > -             return 0;
> > -
> >       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> > -     pmcr =3D read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_=
PMU_PMCR_N_SHIFT);
> > +     pmcr =3D kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK << ARM=
V8_PMU_PMCR_N_SHIFT);
>
> pmcr =3D ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> Would that maybe make it more clear what is done here?
>
Since we require the entire PMCR register, and not just the PMCR.N
field, I think using kvm_vcpu_read_pmcr() would be technically
correct, don't you think?

Thank you.
Raghavendra

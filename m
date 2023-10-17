Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082623B7AD
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 18:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2lp14g2i"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1c9c496c114so26725ad.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 11:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697568333; x=1698173133; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gqavKeNNzn95rvZivCvxVtN3hspWT+sEglrWLEE2E/M=;
        b=2lp14g2iqKhu034XmpkmaOulfouhkascZPaC06JybqaMUJlt3cd5wrWh7FlP7zvN2z
         u95y7dpF8NtDOpRImLMMRvrzK+qF4Vw6RoRCJr4Ow/CEHCcwMd8D8JGUMQfvPn0YMrOK
         3GJcNIi5sHDaHqhAfm1vNkXHE+hhWmb9eDd8qYzNw40vOg4rNt9h33Wp2K1Ag4qsIoG8
         uHA0f4w9gez21I+qECl2HBzz53zBL2jQzOQDBD8zgRdemg6Aysgc6k6+hUJTcOpzgh38
         XC3mL7FByzSQQ8kh7Frj79ZS3ZOWpuJuASzymVqNeabsz7qG7ICrp8fqFy4xhmbzob8k
         JKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697568333; x=1698173133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqavKeNNzn95rvZivCvxVtN3hspWT+sEglrWLEE2E/M=;
        b=PahZ9Y1gyHpR1IrVnN9TsQZJJpHgfvRtsiWA+4tfzx67b1P1d7ci4L4xpmrHb8SlkE
         ToAXYZRgEQ3whw2Pg18PyTmd0TFbe1SbYwegWxUaexk/utcmt19GzTKzICGar7lSPgOv
         IhY1yNdJ3lQO2n3MR9taVohtRFd0Fqigclrbg6W+5NDWUc/xer+m62XXkJrn82DXnEcg
         gJxs/qXHFzO9UJiinD9hMFfMfQ6fb6yIagJNnURsL8WEjFasBmZ4s20/X/pHuRWeTuFF
         rwIfiJNoVuXjcX8KjuQPO0nAexf/xcCwSW2A1AddnDTrUYgtKrFhqzJfHXwxodO9U2kA
         Cw7g==
X-Gm-Message-State: AOJu0Yy283I5iI0ylWMf9cv0V0s/XZKyFk1S/WHQdDxzcFrZzepGn/Ou
	Wzu/6j+TQBzl/wk98J4N3eYbXyITlrj54wlRwep51Q==
X-Google-Smtp-Source: AGHT+IEvnrKElYIr+WwV++S1q681XL7zbfbJLiJziy9CXgLJP0/YH3N3e7BkeqvohOyFpDrX7yf5F7P2Gg3U3PXN12Q=
X-Received: by 2002:a17:903:54:b0:1b9:d96c:bca7 with SMTP id
 l20-20020a170903005400b001b9d96cbca7mr35746pla.25.1697568333106; Tue, 17 Oct
 2023 11:45:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com> <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev> <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
 <ZS4hGL5RIIuI1KOC@linux.dev> <CAJHc60zQb0akx2Opbh3_Q8JShBC_9NFNvtAE+bPNi9QqXUGncA@mail.gmail.com>
 <ZS6_tdkS6GyNlt4l@linux.dev> <CAJHc60w-CsqdYX8JG-CRutwg0UyWmvk1TyoR-y9JBV_mqWUVKw@mail.gmail.com>
 <ZS7OLRy6BwJljOV8@linux.dev>
In-Reply-To: <ZS7OLRy6BwJljOV8@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 17 Oct 2023 11:45:20 -0700
Message-ID: <CAJHc60w5oipHoOVbnYv_9zbHZbXZQRPUVX0+5nxD5HUjp5pA6A@mail.gmail.com>
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

On Tue, Oct 17, 2023 at 11:11=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Oct 17, 2023 at 10:25:50AM -0700, Raghavendra Rao Ananta wrote:
> > On Tue, Oct 17, 2023 at 10:09=E2=80=AFAM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
> > >
> > > On Tue, Oct 17, 2023 at 09:58:08AM -0700, Raghavendra Rao Ananta wrot=
e:
> > > > On Mon, Oct 16, 2023 at 10:52=E2=80=AFPM Oliver Upton <oliver.upton=
@linux.dev> wrote:
> > > > >
> > > > > On Mon, Oct 16, 2023 at 02:35:52PM -0700, Raghavendra Rao Ananta =
wrote:
> > > > >
> > > > > [...]
> > > > >
> > > > > > > What's the point of doing this in the first place? The implem=
entation of
> > > > > > > kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-sc=
oped value.
> > > > > > >
> > > > > > I guess originally the change replaced read_sysreg(pmcr_el0) wi=
th
> > > > > > kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
> > > > > > But if you and Sebastian feel that it's an overkill and directl=
y
> > > > > > getting the value via vcpu->kvm->arch.pmcr_n is more readable, =
I'm
> > > > > > happy to make the change.
> > > > >
> > > > > No, I'd rather you delete the line where PMCR_EL0.N altogether.
> > > > > reset_pmcr() tries to initialize the field, but your
> > > > > kvm_vcpu_read_pmcr() winds up replacing it with pmcr_n.
> > > > >
> > > > I didn't get this comment. We still do initialize pmcr, but using t=
he
> > > > pmcr.n read via kvm_vcpu_read_pmcr() instead of the actual system
> > > > register.
> > >
> > > You have two bits of code trying to do the exact same thing:
> > >
> > >  1) reset_pmcr() initializes __vcpu_sys_reg(vcpu, PMCR_EL0) with the =
N
> > >     field set up.
> > >
> > >  2) kvm_vcpu_read_pmcr() takes whatever is in __vcpu_sys_reg(vcpu, PM=
CR_EL0),
> > >     *masks out* the N field and re-initializes it with vcpu->kvm->arc=
h.pmcr_n
> > >
> > > Why do you need (1) if you do (2)?
> > >
> > Okay, I see what you mean now. In that case, let reset_pmcr():
> > - Initialize 'pmcr' using  vcpu->kvm->arch.pmcr_n
> > - Set ARMV8_PMU_PMCR_LC as appropriate in 'pmcr'
> > - Write 'pmcr' to the vcpu reg
> >
> > From here on out, kvm_vcpu_read_pmcr() would read off of this
> > initialized value, unless of course, userspace updates the pmcr.n.
> > Is this the flow that you were suggesting?
>
> Just squash this in:
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d1db1f292645..7b54c7843bef 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -743,10 +743,8 @@ static u64 reset_pmselr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r)
>
>  static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r)
>  {
> -       u64 pmcr;
> +       u64 pmcr =3D 0;
>
> -       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> -       pmcr =3D kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK << ARM=
V8_PMU_PMCR_N_SHIFT);
>         if (!kvm_supports_32bit_el0())
>                 pmcr |=3D ARMV8_PMU_PMCR_LC;
>
>
Oh, I get the redundancy that you were suggesting to get rid of!
Thanks for the diff. It helped.

- Raghavendra
> --
> Thanks,
> Oliver

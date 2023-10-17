Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A772D030
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="snEU7hv1"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1c9c496c114so11195ad.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 10:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697563563; x=1698168363; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b98W+/GnlYMBBaEIRZ/yrKu+yROp6z3ItYJheiFNfWY=;
        b=snEU7hv1ZtoYZ057qeu04j0giTwGif9nwgfPokpphq5wyH/o8AGML2xLvWxT6INh+e
         vEmOrrAtykGtiyLEYWvA2M+TqF9WJwPtGOmfv9Kw8OMnGoQ8jp5ZvUDnlwWZbc9AYiqy
         NVzyIXKFVXOv/uMEvBYkx5l4XIOVw/bOzURBlw65H+LRPTY+urYUh/8PlnVb92lEymNq
         MclR1G/dkyUaIN0QEOEZ102+CVjd9/cfYtg0K6LWiuSQnZMuLfUme8iBsM4jcgDOVscM
         AuWCELVOiM23BgK05uE4603VInhnIhoc+dxH2e8rCWK2mV793mepv0/cqgVqkRFm9QFz
         KcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697563563; x=1698168363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b98W+/GnlYMBBaEIRZ/yrKu+yROp6z3ItYJheiFNfWY=;
        b=ZYpbmhAWFndsH6m/Dqx7WVDG+pnd/m7XXdIX9qBMiA3oXKo0HPTATjNcW17iMF4iah
         pxqXDU9qiHBLsHYWjhgvO/XaXzRB8JY8wknnD12Ai8V27WGdku6x+iuOzuuojEN96Pw6
         0SUrkI6ZX0flIDfmVuVvSMw8LHHpZ8rs3+zRq8ynINqsLON3cJQhJdyPbjV28MasgSPH
         o7vCgz3c05jRl54fT2y7jKg6af4JsvED42PGgLOpjsm7SvFt8wyt3Aw3TKXjVQ7sAuCn
         feHWfjDBnbq7klttJ8hUcRqQqlFB/S05MnlmONmglzrejZG0endgKh0E5iUHp9hAUvqC
         lv8w==
X-Gm-Message-State: AOJu0Yy3MMRH5o1M9a4Wxzz2qwnmtPGxAmh3Ns5rv8nFBndxzVr9Aibs
	gp8eNCb4LTZ9Ludy+iy71yIuHaQSDgdvG84HyvmYSA==
X-Google-Smtp-Source: AGHT+IHb5B0YZuQ8upjbjeL9ha316DU4/zeX9v9YItDefLh84Iu+cQVZ7EJdEAX5vIIp6CqyfVqxyGhsl1ayop2hEX8=
X-Received: by 2002:a17:902:f611:b0:1b8:b564:b528 with SMTP id
 n17-20020a170902f61100b001b8b564b528mr8101plg.7.1697563563148; Tue, 17 Oct
 2023 10:26:03 -0700 (PDT)
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
 <ZS6_tdkS6GyNlt4l@linux.dev>
In-Reply-To: <ZS6_tdkS6GyNlt4l@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 17 Oct 2023 10:25:50 -0700
Message-ID: <CAJHc60w-CsqdYX8JG-CRutwg0UyWmvk1TyoR-y9JBV_mqWUVKw@mail.gmail.com>
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

On Tue, Oct 17, 2023 at 10:09=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Oct 17, 2023 at 09:58:08AM -0700, Raghavendra Rao Ananta wrote:
> > On Mon, Oct 16, 2023 at 10:52=E2=80=AFPM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
> > >
> > > On Mon, Oct 16, 2023 at 02:35:52PM -0700, Raghavendra Rao Ananta wrot=
e:
> > >
> > > [...]
> > >
> > > > > What's the point of doing this in the first place? The implementa=
tion of
> > > > > kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped=
 value.
> > > > >
> > > > I guess originally the change replaced read_sysreg(pmcr_el0) with
> > > > kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
> > > > But if you and Sebastian feel that it's an overkill and directly
> > > > getting the value via vcpu->kvm->arch.pmcr_n is more readable, I'm
> > > > happy to make the change.
> > >
> > > No, I'd rather you delete the line where PMCR_EL0.N altogether.
> > > reset_pmcr() tries to initialize the field, but your
> > > kvm_vcpu_read_pmcr() winds up replacing it with pmcr_n.
> > >
> > I didn't get this comment. We still do initialize pmcr, but using the
> > pmcr.n read via kvm_vcpu_read_pmcr() instead of the actual system
> > register.
>
> You have two bits of code trying to do the exact same thing:
>
>  1) reset_pmcr() initializes __vcpu_sys_reg(vcpu, PMCR_EL0) with the N
>     field set up.
>
>  2) kvm_vcpu_read_pmcr() takes whatever is in __vcpu_sys_reg(vcpu, PMCR_E=
L0),
>     *masks out* the N field and re-initializes it with vcpu->kvm->arch.pm=
cr_n
>
> Why do you need (1) if you do (2)?
>
Okay, I see what you mean now. In that case, let reset_pmcr():
- Initialize 'pmcr' using  vcpu->kvm->arch.pmcr_n
- Set ARMV8_PMU_PMCR_LC as appropriate in 'pmcr'
- Write 'pmcr' to the vcpu reg

From here on out, kvm_vcpu_read_pmcr() would read off of this
initialized value, unless of course, userspace updates the pmcr.n.
Is this the flow that you were suggesting?

Thank you.
Raghavendra

> --
> Thanks,
> Oliver

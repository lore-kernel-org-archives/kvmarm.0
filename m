Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965082770A
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 21:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qepMJzBJ"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4195fe5cf73so38121cf.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 14:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697492164; x=1698096964; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gG0OkIWDPYdZRvQuvf3btCaImiKQgqO1e18TbAYg8Pg=;
        b=qepMJzBJCX2/mMcCU3odX5tvd0DCi3+mN/WXC34oaiWkKij5AYJPYw4gVOqL2zV+yV
         yF78Xw9hVoN1qTDn1IedWpnrxcf57py/4nBadrkAEPt420dax8H8ZGR+RUAy2cgYpH2t
         Piq83k2GUQuhZehGbbqM1BiySkD3g1nu4m479CIfNalARN/p3IliDCBfxfvxmyGWaBc5
         /xn35XGN7ZNDvPuDQOTFIf3JYxqKF3uG1x0c4BjrX7U3lDgA9y89coEyLx8hnf99B+Fc
         3ThUr4maviUX2JVr1BjWb+SqNcez6tT9oqUmBfQUw7frOROOqwkt/5q2zb0K70AM3jcH
         UofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697492164; x=1698096964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gG0OkIWDPYdZRvQuvf3btCaImiKQgqO1e18TbAYg8Pg=;
        b=hMII5sj0Y0/5y2VSnHJR6oM2GQb5WfGbXDarTRWoaTvLnPYMDfbXb7wgV1e4zBDUle
         wg9Af6THHV2smjtKTYCWYgn4hHQsA2rhdr8FqC2nBbXv5VdLegg903EPGRQKoPPQqoae
         yw9V8FwMRqiZQ/KRA2Qbqr1wtLETq9tb1K/7UwhRmCOdEVFT/Fnz43DjfcHjSfuqlEOj
         NL4HNbPZTQGVSeHF4KcpjidTSpEyPCWy/HTnSSFqlR4yWrS41j/K1nfjCx+13rPZK+G1
         dOdH1Rz9CNc5XHnL5W4O81Wgs/7gzu8KNyQ5U9bX/4BumIuszcGizVCvAyhIeyZQa69w
         6T/Q==
X-Gm-Message-State: AOJu0YzXNJtNn6ikZ2oWHQG3r0UDRIrTcx+AJ2mY0FwK0t3769xl+7RT
	eBff8l8HY/cnQJWuIkXchJmkOGA4P+kH9KoGSKfCmQ==
X-Google-Smtp-Source: AGHT+IGiZ5BGU5400y71INeUK7EWTSUyP0Peqa8/UWdHZGXz4uUZXSH6XpGpm7cIwuhSjMBV95+dfOrxfv9aNZqsJTg=
X-Received: by 2002:a05:622a:760f:b0:410:9855:acd with SMTP id
 kg15-20020a05622a760f00b0041098550acdmr76659qtb.14.1697492164218; Mon, 16 Oct
 2023 14:36:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com> <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev>
In-Reply-To: <ZS2L6uIlUtkltyrF@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 16 Oct 2023 14:35:52 -0700
Message-ID: <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
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

On Mon, Oct 16, 2023 at 12:16=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Mon, Oct 16, 2023 at 12:02:27PM -0700, Raghavendra Rao Ananta wrote:
> > On Mon, Oct 16, 2023 at 6:35=E2=80=AFAM Sebastian Ott <sebott@redhat.co=
m> wrote:
> > >
> > > On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> > > > u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> > > > {
> > > > -     return __vcpu_sys_reg(vcpu, PMCR_EL0);
> > > > +     u64 pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0) &
> > > > +                     ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_S=
HIFT);
> > > > +
> > > > +     return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_=
N_SHIFT);
> > > > }
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index ff0f7095eaca..c750722fbe4a 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -745,12 +745,8 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, c=
onst struct sys_reg_desc *r)
> > > > {
> > > >       u64 pmcr;
> > > >
> > > > -     /* No PMU available, PMCR_EL0 may UNDEF... */
> > > > -     if (!kvm_arm_support_pmu_v3())
> > > > -             return 0;
> > > > -
> > > >       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> > > > -     pmcr =3D read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << AR=
MV8_PMU_PMCR_N_SHIFT);
> > > > +     pmcr =3D kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK <<=
 ARMV8_PMU_PMCR_N_SHIFT);
> > >
> > > pmcr =3D ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> > > Would that maybe make it more clear what is done here?
> > >
> > Since we require the entire PMCR register, and not just the PMCR.N
> > field, I think using kvm_vcpu_read_pmcr() would be technically
> > correct, don't you think?
>
> No, this isn't using the entire PMCR value, it is just grabbing
> PMCR_EL0.N.
>
Oh sorry, my bad.
> What's the point of doing this in the first place? The implementation of
> kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped value.
>
I guess originally the change replaced read_sysreg(pmcr_el0) with
kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
But if you and Sebastian feel that it's an overkill and directly
getting the value via vcpu->kvm->arch.pmcr_n is more readable, I'm
happy to make the change.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver

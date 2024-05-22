Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B201CAA1
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716389387; cv=none; b=O8mQoGRP/HwDRUS5OIKx965F/8SZmU6Ze1srIyuaPm2f5RJCpArPt91qgMfmn1v5F+9JEC3M5+29dv00In6Ys0e7ccQPnW4OILUVMcsHBSStaI/89yiFwinNbIa2x4L4XpbwrQ1YJ59CxBPM4exLrGlCH8v7juTQlzQZRhdRSzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716389387; c=relaxed/simple;
	bh=gHPdL0TzUaO/UYsKvyNx/qiaKSglvseFLDJ6Ouwr/KM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W5v0B9pk1DMuoQFKU7xDwqYWMsqcE44YV1mMdik/L9ZxFLv2iFu14sDEv1kO070baG+fLwrm1gc4qfTuTc4bU1LOsUnkOijUwYHxvyUYYlABb3vKMrrFBW3Ab4ux05B5YSEXwTUVQLndeRm4YvOb9aGdMn1a9lpMeg73ReF+nr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T0yWXJOw; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T0yWXJOw"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4e12478c3f8so345972e0c.3
        for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 07:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716389384; x=1716994184; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zr6dN2A1I1sXKX4TqppbWaPNz/Ev3VGS0mw/BHrFzlE=;
        b=T0yWXJOwmx8Xu2k3yB01L25V+QbKlnuSNlMtDxS2UArjIjCLWPa2iLwzOWBMMfu4Ug
         grI11DJUvmvvTzu5abHjr41q4llqcCeY6lwOd83BCr2GIxFm1tyh/QxCv4ZDaqJYegDA
         7efNMN1naAPFRmL9FZxZg8tWfpK9uBZ0bpRnrN9peVCXJidcan0uD0HcL207+qNAbYnF
         bZHYaz17yBoa03prlRX2hKlSV8UcA5aCzdBGzUGu7EMxX9dtewr4lbLJiCviboE7N8to
         URcAaIYtm0FcvNR8DqlHRhcX+EUt6nC1algDvuhwmrTJyd4Ag0xhx7AZFRRrBQ9Bgldh
         f/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716389384; x=1716994184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zr6dN2A1I1sXKX4TqppbWaPNz/Ev3VGS0mw/BHrFzlE=;
        b=nw2b5aFLgJbYoNPHmDdLeKBgSFlSOBdS63NUnf1EW/vp4hvJDeuKmp4NbK8Hhw5Y7d
         FB44XMTT2llnv1budkx7jWJFBwaFP+qA6GNhMJfnpAGPpQSe0EJfcDkcWJ918qEocLJl
         2txdj7V52Yd3jViozgTwA9/63Ql3vAC/YL6PGNK5pZoH/FjlAh04vKiZXZDmF/EWGANw
         KFCpWYJZn4FjEa/QhnXJfzDyAAQdgZRCSwJz+IxcrdrtyZPwlDE7VSfokTquDRqU+99p
         Y5kSc5N1/7wm4CoZmsp85w9ow4meMkNX8xZ63cXI0gCQRPP/MbBql7B/IHtX7oPJ8yPC
         fHlA==
X-Gm-Message-State: AOJu0Yz0BjwThGpD+hQBp2IBmbHR0DlXruDK8rsw1bQp+TbPOfO2HpE7
	OPVot5J/8irKZn1+mRWYrDg9X1E9SlqiCLWuyn0oz+juvXsHkg/1AYUIA50y1u/QkTbyewcfa7S
	j5jj3nn5oZ+N7gIBhNG8eJ5nEBvBP69XjTcW7
X-Google-Smtp-Source: AGHT+IGlq1EwLhWE1PFA4cMw/UHYtWyY7NHusYhBT7+Kx41m3nn7A1a/W8Iklo9SqeKbTv+b5ZSZ5JSJYla+dn8UQc8=
X-Received: by 2002:a05:6102:e11:b0:47c:2879:bbe1 with SMTP id
 ada2fe7eead31-489008e60c3mr1860198137.6.1716389384542; Wed, 22 May 2024
 07:49:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com> <20240521163720.3812851-8-tabba@google.com>
 <86msoin5ac.wl-maz@kernel.org>
In-Reply-To: <86msoin5ac.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 22 May 2024 15:49:07 +0100
Message-ID: <CA+EHjTzS6E6V5qO_weTA5wNtxYUcfVK2cHCmJhuWmu4zG1DiLw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] KVM: arm64: Consolidate initializing the host
 data's fpsimd_state/sve in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, broonie@kernel.org, joey.gouly@arm.com, 
	rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, May 21, 2024 at 11:56=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 21 May 2024 17:37:20 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Now that we have introduced finalize_init_hyp_mode(), lets
> > consolidate the initializing of the host_data fpsimd_state and
> > sve state.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h      | 10 ++++++++--
> >  arch/arm64/kvm/arm.c                   | 18 ++++++++++++------
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 -
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 11 -----------
> >  arch/arm64/kvm/hyp/nvhe/setup.c        |  1 -
> >  5 files changed, 20 insertions(+), 21 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 7b3745ef1d73..8a170f314498 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -536,8 +536,14 @@ struct kvm_cpu_context {
> >  struct kvm_host_data {
> >       struct kvm_cpu_context host_ctxt;
> >
> > -     struct user_fpsimd_state *fpsimd_state; /* hyp VA */
> > -     struct user_sve_state *sve_state;       /* hyp VA */
> > +     /*
> > +      * All pointers in this union are hyp VA.
> > +      * sve_state is only used in pKVM and if system_supports_sve().
> > +      */
> > +     union {
> > +             struct user_fpsimd_state *fpsimd_state;
> > +             struct user_sve_state *sve_state;
> > +     };
> >
> >       /* Ownership of the FP regs */
> >       enum {
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index a9b1b0e9c319..a1c7e0ad6951 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2445,14 +2445,20 @@ static void finalize_init_hyp_mode(void)
> >  {
> >       int cpu;
> >
> > -     if (!is_protected_kvm_enabled() || !system_supports_sve())
> > -             return;
> > -
> >       for_each_possible_cpu(cpu) {
> > -             struct user_sve_state *sve_state;
> > +             if (system_supports_sve() && is_protected_kvm_enabled()) =
{
> > +                     struct user_sve_state *sve_state;
> >
> > -             sve_state =3D per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->s=
ve_state;
> > -             per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state =3D k=
ern_hyp_va(sve_state);
> > +                     sve_state =3D per_cpu_ptr_nvhe_sym(kvm_host_data,=
 cpu)->sve_state;
> > +                     per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_sta=
te =3D
> > +                             kern_hyp_va(sve_state);
> > +             } else {
> > +                     struct user_fpsimd_state *fpsimd_state;
> > +
> > +                     fpsimd_state =3D &per_cpu_ptr_nvhe_sym(kvm_host_d=
ata, cpu)->host_ctxt.fp_regs;
> > +                     per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->fpsimd_=
state =3D
> > +                             kern_hyp_va(fpsimd_state);
> > +             }
>
> nit: SVE support and protected state do not change on a per CPU basis,
> so checking for these inside the loop is pretty counter intuitive.

I'll fix this.

Thanks for all the reviews!
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

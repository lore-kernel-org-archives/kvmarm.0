Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1991B25394C
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 18:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754419464; cv=none; b=a1uD8V+cp8i1sXOJiwyg8r8fImqtOTm0rwfl+yJm9J1FdMuMaCI+UkAJvRs6ZPD5ArkGUXAraIcARlX9337+kPndwCm2INxo6Ozf96fdLaePl2AylmJkAEMlSKqaqm2WIkQzGiO6BJxmsanwCkHbPbbUSTNkS99KW406i7Ajqbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754419464; c=relaxed/simple;
	bh=+Z9inQJ8opwvJy7yCNDeFuzgVPrUfb4OI7ABdHomxoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C404SrXDs+5r/VtMy7Z2ddbtIDb5q0HbnolKqQ0hqNjEJrj8ksNqs6wGtttDrVU786kps4VfJ9bCx5v1CxtGpjvtBKUleXspRaDXFJB0+sLR7pdfRNiUWp1t22pDvzS9vXdE4yZ4qtDRKkNUheyYApH3Oqpuov4A0C48DMXunFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UFIqV5Wu; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UFIqV5Wu"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b0673b0a7cso99911cf.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 11:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754419462; x=1755024262; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0PxF5y08A38YpdaMcqzOlRCenhTDSuzrVTjgj8T8DAM=;
        b=UFIqV5WudOzpA/ruj0Q6k/99HqSpFLKN0sLrJ+TNfdx9+GCZ2AThF0ZUJc0hfMd/90
         5y2lNGWZjGWwOfQyxeykvPuzOM2jR9qYTWIpYyQjsRXoI5kr2naP9RUAqfurgtf2m0L0
         zunMH1K3uzAXM7eeAED88LMPWabgnaRxFb+f1SAuCUReC9qBr+kpZDC2Ka2OiGxC38Oo
         +xxt2gjyj3Wk4Pd1Yt21IZ/xRUY5IZO7ZknjJSBh6QgfdaUUdZrKjlpbLWba2kgkPz4x
         +HcpHQ6qobvQshk6kgLb4Zhmv6cIR4u7tAQ1I9i3EL/C44y483nf+mz1VBoTsn2PvBdA
         gCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754419462; x=1755024262;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0PxF5y08A38YpdaMcqzOlRCenhTDSuzrVTjgj8T8DAM=;
        b=sf5unWclX1gERQvAPgIeNNrGNfvLTbOnBv6bpwGOxlF3IXBPOMbsI1/qFI6hx22M6M
         /4s26BNCYjjsX2XFhL9FlF93MNnwnJunbi6gDejJL511NzSQ0GYyYxTUQUPnmG4BJlNQ
         XaRHJ+O/k+nxMSEi0Jma/TIiK6r5/+0/BI7CstZQdZGXNgxrHvQ54MgVw7TXJJrdGEDe
         0cBzfVH2wqi9jJFqp60dRRhEdusBjShQuDyDMcE2xDYyceXQHCqcwAkGkLMDIQaCBH+0
         rODxiM0549lFJqssOD0DcYFaUDO2PYT407GY0fiJavrbj6SVP4cf08R3I9ZVn4btP0tf
         dErg==
X-Gm-Message-State: AOJu0Yw9dL+SnARWNJW8XiqDhxXtZdprT8FzhXIwU5vwySTc/uDx8noB
	hyrZzVSmxcpcp4wHYih3+pF7ZAgR+dizz4BBLzWQJiqU091ivFclyBuOlbDFkODlzSsN5b946Er
	mgE/Ggs66vMazxjYeQo9fZietSyoYzH9rMVpqwDkU
X-Gm-Gg: ASbGncuPAg90qfH4EGzBfV0+BJtaZkkneczyZ8TbfBTvQCqLSJ3Q/s4UG8TTRLTOiGi
	vgJK+3EbIEgKYKkkMPigSF/wQjIHUkPQzcLr38dYGN9NHO6pEyZkEs88YCuIZ541oeHjJN+LKGn
	3qJRu/B/MV4B0Czi43TA2C/8EPGocnWLJ/JBk4eKsJl9McQ401yD9q93yhGd9S33XsrDFQ4ZfqM
	2C3aZNS
X-Google-Smtp-Source: AGHT+IG8aoeJB7I0f6JIa+/eNsj12PpL/1xAQoEUxQjKL9ZpIzyNXRrY+GpXP6I6aBoKI2tK45JiQ72Yo2WxAC/IrRU=
X-Received: by 2002:a05:622a:1a03:b0:4a6:fc57:b85a with SMTP id
 d75a77b69052e-4b090697c64mr418011cf.14.1754419461429; Tue, 05 Aug 2025
 11:44:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250805135617.831971-1-tabba@google.com> <20250805135617.831971-4-tabba@google.com>
 <86cy99a9wp.wl-maz@kernel.org>
In-Reply-To: <86cy99a9wp.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 5 Aug 2025 19:43:45 +0100
X-Gm-Features: Ac12FXwO9qw_EV3ciLp2SE0fBGATXymKWD32AKnjSHnkZm8XRrtP_adt5aM1ga4
Message-ID: <CA+EHjTzGLLR3rM5Dmn8S0bZ5mugB9x2e-_-nDp_zKNB77F3J2g@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] KVM: arm64: Sync protected guest VBAR_EL1 on
 injecting an undef exception
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 5 Aug 2025 at 19:41, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 05 Aug 2025 14:56:16 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > In pKVM, a race condition can occur if a guest updates its VBAR_EL1
> > register and, before a vCPU exit synchronizes this change, the
> > hypervisor needs to inject an undefined exception into a protected
> > guest.
> >
> > In this scenario, the vCPU still holds the stale VBAR_EL1 value from
> > before the guest's update. When pKVM injects the exception, it ends up
> > using the stale value.
> >
> > Explicitly read the live value of VBAR_EL1 from the guest and update the
> > vCPU value immediately before pending the exception. This ensures the
> > vCPU's value is the same as the guest's and that the exception will be
> > handled at the correct address upon resuming the guest.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > index bbd60013cf9e..b34b10be1ad7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -253,6 +253,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
> >
> >       *vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
> >       *vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
> > +     vcpu_write_sys_reg(vcpu, read_sysreg_el1(SYS_VBAR), VBAR_EL1);
> >
> >       kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
> >
>
> There is something I don't understand. vcpu_write_sys_reg() is only
> useful if you make use of the SYSREGS_ON_CPU flag. Which is only
> driven by the VHE code (in arch/arm64/kvm/hyp/vhe/sysreg-sr.c).
>
> As a consequence, this only writes to memory, since the flag is always
> false, and we take the following path:
>
> static inline void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> {
>         u64 (*xlate)(u64) = NULL;
>         unsigned int el1r;
>
>         if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
>                 goto memory_write;
>
> [...]
> memory_write:
>         __vcpu_assign_sys_reg(vcpu, reg, val);
> }
>
> My conclusion so far is that you only ever need to write to the shadow
> view of the register, and that the previous patch serves no purpose.
>
> Am I missing anything?

No, you're not. I realized that when I replied to Will (patch 2). I'll
drop that patch and fix this when I repin.

Cheers,
/fuad

/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

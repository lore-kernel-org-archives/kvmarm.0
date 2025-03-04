Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0995202F96
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091647; cv=none; b=D0MSHTi8vyKuzmR5laoEwz0LBwkmHwCD+/l9cbXoc9QKEXxVCy4xpdCaGCsWspEKjiaDVo7MBCfr9r5rcfrzBrRvY5iLDDUgnC6kWsNsAR5gPONCghCkFF6g3uohtL0aPc7qX9/g2xxvPB8O6SDzWkiTfsfTWBJnYtZcFBeGrU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091647; c=relaxed/simple;
	bh=6eaSD8OTca9wJGHukn8L+aK3G6J7ybysiiuzv7kiYpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cpz7+fRxQgTqcZqm/RqA2lFt5xwyJyZOmflJAggbJ8OpRs5VLs1ZzNCC1WgEjHPI+1NwywfqhmZpPe38zETKpHOTzMDTUGChb51z4OuKi3mNtHHdZCs/T9Zu0ZFsdf4kDEPFyDUwv9l5/cyWYky+FclM5h7xo60En3G9rJE0RFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E9b9Jz5M; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E9b9Jz5M"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-474fdb3212aso216981cf.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 04:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741091644; x=1741696444; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4LJRch3g6p8/qLpu/3lOk7LZ1OdHfNWmv1WKY/EEqh0=;
        b=E9b9Jz5MR+VYV9UNM/9vb500M/9rRlBoGwYcTyNimKp/PbehvLk8i2mWcRW4KW5emF
         t58WGFVU0E87ynZ02ItB9mgc60UyHrpAjml1mhZimGVzlYzd3GNE3mdzFOBd3vNEnCKX
         0eT6J3WhDyrjDv0vg/wQS/a54TOikzOlbNL5XVhwtDlzsmeM6AdAKsm7MKLnvPJ610DU
         vY5Qj5RHSIXC9Q32XSEXUp1rsypd6rB1cl3jdRrglU/rlMycgdHjWHcUfFSo/80LZRQ1
         HdhTYZSa65yFooqwZtuAgGosa5LDyIKD/cploeYkk/GpadY74JKQ18QPbaTfQPjJe+Pd
         wxug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741091644; x=1741696444;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4LJRch3g6p8/qLpu/3lOk7LZ1OdHfNWmv1WKY/EEqh0=;
        b=hyiyJtQne6GIfvnUGbj+oKcIkTKJpVvpw+yytXiCn2gtDyEsfIIGVkmJyW5XAkVClG
         LhKVyoLnpFQ+mRDyjYul/Ofe71wAO9l+IMgjKOSHm5k/gRKsAHHWHTLv4nWGzmgYvLZD
         CdxYeI+ivfY3gda46PklyoLOv+T1mKV74X6OZi++m2z381g0fkWBPpG+bn/SC5sHfDkD
         VKKDw9AaKVzRfZFj4JMAklBL0wzHviR1v7IGY6DuPTtxlopIrZqFzoWCOMmEknHbVM8v
         NGGU63psx2VPwEJg6foxE0Mfreqw6C5DaBKVvGbLLDvz0qDjlfkIcqVvQOfrdLWGBtPa
         gNew==
X-Forwarded-Encrypted: i=1; AJvYcCWJV8/H3eEpxDi6MhxDaME8PINWrVTuP2fBNkqm7cru0jJyCIsLuCyJROVx9BCRquqX37P41cI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzk7vJF9BuxeMKOOJn4fguitgsDy4q8Df7ToCN8/rWV+lFg13AV
	Wwt8OZOG1PYwS2dk4gDEf+NWM+tr7c7LEkX2x//VTyUEBjKy7PkZ4eewMZzD14+joe88rxC92bb
	L+nFDzn5Wz81fS9PzhRWHTyzSY4yMPwHK4Di5iGdq3fuoFo/fAw==
X-Gm-Gg: ASbGncvnJPhgffyHN6F/Ll13l2tGRlLG2sN4UT/Cv4D8kUPZ65f3d/Dwy1PILKx7OZj
	VY8WNtSN+C1HR10gng1nDmAi2u+BjkM9l2JcAklfBMUTJUTbaMscFPUyf1vVFyDyrRZ2QoHr0Kf
	ZEklYfOHKJXz+ugAdqiGrt3PXagcLyk+FX2S7MXw8L4mEof8wQf/CRODQ=
X-Google-Smtp-Source: AGHT+IG1wmb/E6zAyXf4gMbux2A/gpA3lOEtVh4lPWuPnUJ8LGWx86QRVEpJ7fTHwzq0tK63uaGZr22OB+UQPL1UizY=
X-Received: by 2002:a05:622a:654:b0:474:cd63:940d with SMTP id
 d75a77b69052e-474fc3ab73bmr4600141cf.0.1741091644342; Tue, 04 Mar 2025
 04:34:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250226215520.1759218-1-tabba@google.com> <20250226215520.1759218-4-tabba@google.com>
 <Z8ISLxQRcsx2uuHw@google.com> <CA+EHjTympdi0wei2Qx=hF2cYvHpzE0sWto2ypcJB3ddmonTROg@mail.gmail.com>
 <20250303191811.GA30361@willie-the-truck> <CA+EHjTySqDHDpOy=Vix5ZaNKWg61coySvV3Yk=+i0p8vg3mXTQ@mail.gmail.com>
 <20250303214947.GA30619@willie-the-truck>
In-Reply-To: <20250303214947.GA30619@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Mar 2025 12:33:27 +0000
X-Gm-Features: AQ5f1JqOSOB-yVZxEjRDtO7BCysCBkkK48aeNEIBsUlYTe__dZnJkeRCsaRBrIQ
Message-ID: <CA+EHjTzZQ6UnOdaqpZ86JNiY=Gr_UoBAjZxk4CS3Q6nMJYdV2w@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to
 separate function
To: Will Deacon <will@kernel.org>
Cc: Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Mon, 3 Mar 2025 at 21:49, Will Deacon <will@kernel.org> wrote:
>
> On Mon, Mar 03, 2025 at 07:21:33PM +0000, Fuad Tabba wrote:
> > On Mon, 3 Mar 2025 at 19:18, Will Deacon <will@kernel.org> wrote:
> > > On Mon, Mar 03, 2025 at 07:57:00AM +0000, Fuad Tabba wrote:
> > > > On Fri, 28 Feb 2025 at 19:44, Quentin Perret <qperret@google.com> wrote:
> > > > > On Wednesday 26 Feb 2025 at 21:55:19 (+0000), Fuad Tabba wrote:
> > > > > >  static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > > > > >  {
> > > > > > -     size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
> > > > > > +     size_t pgd_sz, hyp_vm_sz;
> > > > > >       struct kvm_vcpu *host_vcpu;
> > > > > > -     pkvm_handle_t handle;
> > > > > >       void *pgd, *hyp_vm;
> > > > > >       unsigned long idx;
> > > > > >       int ret;
> > > > > > @@ -161,33 +178,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > > > > >       if (ret < 0)
> > > > > >               goto free_vm;
> > > > > >
> > > > > > -     handle = ret;
> > > > > > +     WRITE_ONCE(host_kvm->arch.pkvm.handle, ret);
> > > > >
> > > > > What's the reason to make this a WRITE_ONCE? Does it mean we should
> > > > > update the readers to be READ_ONCE()?
> > > >
> > > > I don't remember the original reason, to be honest. In this case, it
> > > > was to make it consistent with downstream code in Android. That said,
> > > > I plan on revising all of these soon and fixing this (and related
> > > > code) in light of Will's comment regarding potential specter gadgets:
> > > >
> > > > https://lore.kernel.org/all/20250218092705.GA17030@willie-the-truck/
> > >
> > > I'm not sure the spectre stuff changes the concurrency aspects here, so
> > > Quentin's question presumably still stands even after that.
> > >
> > > Looking at the Android code, this WRITE_ONCE() pairs with a READ_ONCE()
> > > in pkvm_is_hyp_created() which is called without the config_lock held
> > > by kvm_arch_prepare_memory_region(). However, given that
> > > pkvm_is_hyp_created() is only testing against 0, I don't think the
> > > _ONCE() accessors are doing anything useful in that case.
> > >
> > > The more confusing stuff is where 'kvm->arch.pkvm.handle' is read
> > > directly without the 'config_lock' held. The MMU notifiers look like
> > > they can do that, so I wonder if there's a theoretical race where they
> > > can race with first run and issue TLB invalidation with the wrong handle?
> > > That would apply equally to the upstream code, I think.
> >
> > Would using _ONCE accessors with the MMU notifiers be enough to avoid
> > the race, or do we need to reconsider the lock protecting the handle
> > and apply it to the notifiers?
>
> I'm not entirely sure... if we used _ONCE() then we'd get either the
> correct handle or zero, but we presumably need to order that against the
> page-table somehow. The 'mmu_lock' looks like it gives us that, but I
> don't think the notifiers are expecting an uninitialised handle in the
> case where the page-table is empty (i.e. if they fire before first run).
>
> Given that the handle is necessary for TLB invalidation, I'd be inclined
> to make sure that the handle is allocated and published _before_ the
> kvm_pgtable pointer checked by the notifiers is set, but that means
> moving the handle allocation into kvm_arch_init_vm(). Is that do-able?

It is doable, but it won't be a simple patch. Up until now, the
creation of the hyp view of a vm is associated with the first run of
the vm, rather than its allocation at the host. Part of the reason for
that is that much of the vm state (mainly the vcpu state) isn't
finalized until then.

This patch series fixes this in part, by decoupling the initialization
of the individual vcpus from the vm. Because of that, it would be
doable, but it might be better as another patch series that we could
test and analyze separately.

If you agree, I could whip up something and send it soon.

Cheers,
/fuad
> Will

Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EB122318
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741793517; cv=none; b=hje8QFNGp9BbGjBLaEijjH3q2AmgtJ58GC9SyG/DwtAmzvo9ntYp9tbOW+3Wn/MvLsKtro3r3ZLbdCRt2heyv6V5DCrRWwlDroSzcPEtkcgYqCqpHB1+B8JbGqTVqQiQs4gsQhCFuw/X0YSoT7TzHQoOfqiZILnuLam0oMjSw0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741793517; c=relaxed/simple;
	bh=r9ZyMxl5GtZvCxm1XgZVX1P2vlBu0AqQ9eitY8dEOq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ogb4X2JDZbr/xl1akemiNMqtapHSfnmfVjr9szmAAI+xgXvWlL62MaaZ2aaxup+9SHVNX5R1P3lu/kL4NB0WSBIGrgSROJseOJPwj9RN270SWuYlqxQcnHwJ7Xk1RBACSXNLK5NoL0EQClozFKbNebwd/xx8h42K6U+/hfoVgXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rR5VnbpF; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rR5VnbpF"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-476693c2cc2so286501cf.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 08:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741793515; x=1742398315; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tG82S1dPB3gesttVeiU27NqmP0CvoM5o/lmxjPR26s4=;
        b=rR5VnbpFrt4iN6j82j5/4lo4tgMpRLfCFcNGHS9AuO1jsWw5ewdZ+FXV0onT16lq8S
         mUz9Ltuv7JPFqnaMJYHOLpNzU2ANMlGPkcNpJM8xG/Oi/OugSzzk3RpGRn6XW0CB8nTV
         hVJtYGIFeQLsUfuGD+gCaYtcUFzLcBpmL/v8pq1HsfjK8xzbKhAHX3D+2GIQhC+39Rhn
         FHHkXZMSz0Yhld1FIlwHQCqcChzK7jFW7rRmhkA1i+0EtfSEUcp57dNUU5XyZBMVbqFC
         QHUf0oLI9MScKh/Sf8gDjlEpaZU3tmYzjiNvM/q2oRQ7EQRWGFl/Q1xen6QxiFGJcFsI
         Gt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741793515; x=1742398315;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tG82S1dPB3gesttVeiU27NqmP0CvoM5o/lmxjPR26s4=;
        b=e1oVRyknnOBLK2okY/+bdEvnuDX5rBEklKlG1I56kgDnd+XZ6Vxb52IcZdCPF6CGUj
         4mKf/rT4j3/7RGKYkedoADVmsWo42qIRowXPHRiA5sPu5AAsRoS3CcaNc6xFDVcIbk6g
         3vbF1VeUhaYhq6c9M4BS+ZkEQC/KbukhcMqie+2TTxZway23nswlC/s5nzhpHaNST/4J
         8uNEWLSkrH5M+ByCPBKtn+XmiGGCcKV89xj/lnCIs0CQrcfZFpi+ZRBcgzez7sGSKEZc
         UnS+dwdC7W3EJBDQl4zQgC0zQQhovKQlb+gJX4yL4twAPetSvx0JF7qJFDqaVyB0LbE5
         uBqw==
X-Forwarded-Encrypted: i=1; AJvYcCUxCfAXpNpazZjUTPzyub5CZ67nLA/PcHFI5xhOczeHdBpqQVnCY7FdTzntfoAl/+Cefs2QGs8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEbwIDiuY8KdFcvycdHAL798cR8vbvlZMfYZU0hKLp0VPNabi8
	dsDnPPwkI0vhVrwTPd8/6J0ANxQmJBjhhFVSHLW3CjzBbSWjJQl+DrbZ6+mSX68JHYxuOMl17vW
	5sRaD7HBLeVpdVulYN3q+gEr0VDd+AxhooruJ
X-Gm-Gg: ASbGncsu0q/0x6h0rMceSceNGEYDz8W8uaP7rdCoe61WbnWqTOWcMx3u7yWMiRTWsEJ
	L+NZeQTnCHxA844zDDEACA2gxzO71BMHBxZzjqZ9l+Mf74f+L7t+hJDaUz5jHHdAzlQdzRaUH+s
	xE4OueCg3JOrAAr2h+B+3x2Miwh6I7cRxYoO94X+4kgfWPSEHUO9udCg==
X-Google-Smtp-Source: AGHT+IEHK6oT5TlE+REnvTokAeXQuuw9qmZ5nHudPNlpFHJvl0FT9GKH5ET9eQ9MIP2gY64AZ1oLmbLYWRl16Veuld0=
X-Received: by 2002:a05:622a:607:b0:474:fa94:8d20 with SMTP id
 d75a77b69052e-476b78bf69bmr323061cf.2.1741793514642; Wed, 12 Mar 2025
 08:31:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250226215520.1759218-1-tabba@google.com> <20250226215520.1759218-4-tabba@google.com>
 <Z8ISLxQRcsx2uuHw@google.com> <CA+EHjTympdi0wei2Qx=hF2cYvHpzE0sWto2ypcJB3ddmonTROg@mail.gmail.com>
 <20250303191811.GA30361@willie-the-truck> <CA+EHjTySqDHDpOy=Vix5ZaNKWg61coySvV3Yk=+i0p8vg3mXTQ@mail.gmail.com>
 <20250303214947.GA30619@willie-the-truck> <CA+EHjTzZQ6UnOdaqpZ86JNiY=Gr_UoBAjZxk4CS3Q6nMJYdV2w@mail.gmail.com>
 <20250312152903.GA6488@willie-the-truck>
In-Reply-To: <20250312152903.GA6488@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 12 Mar 2025 15:31:17 +0000
X-Gm-Features: AQ5f1JocXlbciVxJNch5-JMEVaLmoWVDEmiXQ76WjlCy0ZdcQpp4l1-Jr17BKJU
Message-ID: <CA+EHjTwHb9mDj20WxeqKky6oAfRDV2R7iiQpwmuBmdZ4aWuS4A@mail.gmail.com>
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

On Wed, 12 Mar 2025 at 15:29, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Mar 04, 2025 at 12:33:27PM +0000, Fuad Tabba wrote:
> > On Mon, 3 Mar 2025 at 21:49, Will Deacon <will@kernel.org> wrote:
> > >
> > > On Mon, Mar 03, 2025 at 07:21:33PM +0000, Fuad Tabba wrote:
> > > > On Mon, 3 Mar 2025 at 19:18, Will Deacon <will@kernel.org> wrote:
> > > > > On Mon, Mar 03, 2025 at 07:57:00AM +0000, Fuad Tabba wrote:
> > > > > > On Fri, 28 Feb 2025 at 19:44, Quentin Perret <qperret@google.com> wrote:
> > > > > > > On Wednesday 26 Feb 2025 at 21:55:19 (+0000), Fuad Tabba wrote:
> > > > > > > >  static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > > > > > > >  {
> > > > > > > > -     size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
> > > > > > > > +     size_t pgd_sz, hyp_vm_sz;
> > > > > > > >       struct kvm_vcpu *host_vcpu;
> > > > > > > > -     pkvm_handle_t handle;
> > > > > > > >       void *pgd, *hyp_vm;
> > > > > > > >       unsigned long idx;
> > > > > > > >       int ret;
> > > > > > > > @@ -161,33 +178,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
> > > > > > > >       if (ret < 0)
> > > > > > > >               goto free_vm;
> > > > > > > >
> > > > > > > > -     handle = ret;
> > > > > > > > +     WRITE_ONCE(host_kvm->arch.pkvm.handle, ret);
> > > > > > >
> > > > > > > What's the reason to make this a WRITE_ONCE? Does it mean we should
> > > > > > > update the readers to be READ_ONCE()?
> > > > > >
> > > > > > I don't remember the original reason, to be honest. In this case, it
> > > > > > was to make it consistent with downstream code in Android. That said,
> > > > > > I plan on revising all of these soon and fixing this (and related
> > > > > > code) in light of Will's comment regarding potential specter gadgets:
> > > > > >
> > > > > > https://lore.kernel.org/all/20250218092705.GA17030@willie-the-truck/
> > > > >
> > > > > I'm not sure the spectre stuff changes the concurrency aspects here, so
> > > > > Quentin's question presumably still stands even after that.
> > > > >
> > > > > Looking at the Android code, this WRITE_ONCE() pairs with a READ_ONCE()
> > > > > in pkvm_is_hyp_created() which is called without the config_lock held
> > > > > by kvm_arch_prepare_memory_region(). However, given that
> > > > > pkvm_is_hyp_created() is only testing against 0, I don't think the
> > > > > _ONCE() accessors are doing anything useful in that case.
> > > > >
> > > > > The more confusing stuff is where 'kvm->arch.pkvm.handle' is read
> > > > > directly without the 'config_lock' held. The MMU notifiers look like
> > > > > they can do that, so I wonder if there's a theoretical race where they
> > > > > can race with first run and issue TLB invalidation with the wrong handle?
> > > > > That would apply equally to the upstream code, I think.
> > > >
> > > > Would using _ONCE accessors with the MMU notifiers be enough to avoid
> > > > the race, or do we need to reconsider the lock protecting the handle
> > > > and apply it to the notifiers?
> > >
> > > I'm not entirely sure... if we used _ONCE() then we'd get either the
> > > correct handle or zero, but we presumably need to order that against the
> > > page-table somehow. The 'mmu_lock' looks like it gives us that, but I
> > > don't think the notifiers are expecting an uninitialised handle in the
> > > case where the page-table is empty (i.e. if they fire before first run).
> > >
> > > Given that the handle is necessary for TLB invalidation, I'd be inclined
> > > to make sure that the handle is allocated and published _before_ the
> > > kvm_pgtable pointer checked by the notifiers is set, but that means
> > > moving the handle allocation into kvm_arch_init_vm(). Is that do-able?
> >
> > It is doable, but it won't be a simple patch. Up until now, the
> > creation of the hyp view of a vm is associated with the first run of
> > the vm, rather than its allocation at the host. Part of the reason for
> > that is that much of the vm state (mainly the vcpu state) isn't
> > finalized until then.
> >
> > This patch series fixes this in part, by decoupling the initialization
> > of the individual vcpus from the vm. Because of that, it would be
> > doable, but it might be better as another patch series that we could
> > test and analyze separately.
> >
> > If you agree, I could whip up something and send it soon.
>
> Yeah, I think we should fix this as a separate series and drop the
> WRITE_ONCE() from this patch.

I'll send a fix soon.

Oliver, would you like me to respin this series, or can you drop the
WRITE_ONCE()?

Thanks,
/fuad

> Will

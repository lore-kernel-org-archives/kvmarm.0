Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7661DFFC
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 12:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740660475; cv=none; b=FmWL60YaeSGczZNqiXgHX3oohFjgq2g479ldgB7DB+KwvJlVfTY3c6uKudgFJSbmCm7xqKLWoBEdbX+aXzEg0dYfVfiOXSeK7XblJreB9xsX+EfyGkjzAjo0gShVsHyE9JdyEjFgUviRGaf/SJo3y+GB2BCL1bCY0oAJt44cWp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740660475; c=relaxed/simple;
	bh=9SRzvcFS+n40UnLuLet9S2Bq2rXaiPkiAH5EblUs2Tg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OfwUG9PD7P2mlYNzbiqY5FXz/rdeJDMyrk4yX3ZLqsFJClw3ak7AWUsMxI/wUWa68BCqWprU97WMd6XkiIYXkP6/qHhHiGNwVaDKTT6AYIPyTSRRDsa2X7t/0HftPKMYX/pb/5W7M095lAtF2RRdoi02QLFmd7ZXn3rBpYZrus0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nzWUP4a3; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nzWUP4a3"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-472098e6e75so198631cf.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 04:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740660473; x=1741265273; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jKfAa0Y4QqMGJoYxTlrv1q30VfaaUBgzdpc7bbsXTMU=;
        b=nzWUP4a3S8sj8CzGtJCVpYQIUi++XNWx4FvGivlaqglDn4l4/5cGIDnImg8zJlSwmp
         4UNBtauqfA5FJcVrKwyQF04oC+5LHpNmof5zXeu8mrN1GD8qNpkzHfpKGoYqfjv4dOem
         Rx3N9tI7zyFSIFudUzUyPAFdpU6u3CsmnsqC1uQl2sdrT9Y/NgbmRe3UNCXaZpJkk0gX
         SsQTZVfUHZQUH3ZsyAsffrdnamhYxCV4Z6PjLLsCj10SSKy0M710e3/r/xjIf0r9kUY0
         U3qqUUupVk+xwmwCYZ2VFK0ntfTCmmGEmpDANbY4YOnNOtbbcpkeI4qlDGOX2g3aHWBD
         YLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740660473; x=1741265273;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jKfAa0Y4QqMGJoYxTlrv1q30VfaaUBgzdpc7bbsXTMU=;
        b=q1O6grtqO/Vj6AiYL70IVt8Yf4Ey9Nx7/9LSf1+X/ts8Y8Ll1gtYS/+7i689w5qFXI
         NiZhY7uLNT80pFbiYz24MrmHmhb6uYttBgcvaFoSiZOAtDaSlxs82uWrImBsC0bLsdaL
         2hTwPxAFget2oN/noVzPjMZVRRVlzHuIthbgRSoopsUyZhcI9rzN3TzqHQ5n8ZeaFBVj
         226wcwk7w9MNBKjopAIXnzbCLSCiCAjO1rUrdcJ9EFvo1qFb1nMI324rWQ6w1C8aES/f
         80mgFrKPVM4NHejLN5kqiiVVF/nqR52fhzEswLLEqeKp2VoTg1T0vVdgg8xErhymlqnn
         u+wQ==
X-Gm-Message-State: AOJu0YxI2xBVtwJAGa3lsVu6QhFU4B9kUdKA3qtDVPB/c8HpueZwmdzT
	4RfVYiAewqbB9+p4l49oVCwzG2aZy06fEMj1Cz5rtg9YCCiC0nnlUl7o7EiPTSg+CoqsStsCAQI
	4e6W9AXsI8whU6KaKgOfZ4WTOtVqucM/+7Sg6
X-Gm-Gg: ASbGncu3gSIu6KsTVHB+4w7ZBfCZIbtAMHyIa2pZAPfJde8FZfQyKgfiqyLVvVFHzL0
	kDu30ND5Hnc7DWnzaIojuVwCq1Zr8AQV+HEhGrNihYs6CcpuFb8+61A8JGhD4xGXlkGH+geH5Ch
	MwQsg=
X-Google-Smtp-Source: AGHT+IHWUM9StvpMxTR1veAWbKD3F0IvKPiFCSnfuUozdIUs6NKdtI7rvvBzOdmVI68lbvumaPJTvMO7DJi2qSftbmE=
X-Received: by 2002:ac8:5943:0:b0:46d:f29d:4173 with SMTP id
 d75a77b69052e-4742e10ab22mr3399631cf.16.1740660472515; Thu, 27 Feb 2025
 04:47:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250226215520.1759218-1-tabba@google.com> <20250226215520.1759218-5-tabba@google.com>
 <8634fzr3m1.wl-maz@kernel.org>
In-Reply-To: <8634fzr3m1.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 27 Feb 2025 04:47:16 -0800
X-Gm-Features: AQ5f1Jrj0OYH1ko9OQCBTsbltlCUH5L-oDvJ4j9ZT42gtFRD7R39beJcLhGtUNY
Message-ID: <CA+EHjTzPH_K1BUrNW9EkaFWj3qCdr4uwJS1pZhCYYfi2Uecu=Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Create each pKVM hyp vcpu after its
 corresponding host vcpu
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, mark.rutland@arm.com, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 27 Feb 2025 at 04:09, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 26 Feb 2025 21:55:20 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Instead of creating and initializing _all_ hyp vcpus in pKVM when
> > the first host vcpu runs for the first time, initialize _each_
> > hyp vcpu in conjunction with its corresponding host vcpu.
> >
> > Some of the host vcpu state (e.g., system registers and traps
> > values) is not initialized until the first time the host vcpu is
> > run. Therefore, initializing a hyp vcpu before its corresponding
> > host vcpu has run for the first time might not view the complete
> > host state of these vcpus.
> >
> > Additionally, this behavior is inline with non-protected modes.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h      |  2 +
> >  arch/arm64/include/asm/kvm_pkvm.h      |  1 +
> >  arch/arm64/kvm/arm.c                   |  4 ++
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  6 ---
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 54 +++++++++++++++-----------
> >  arch/arm64/kvm/pkvm.c                  | 28 ++++++-------
> >  6 files changed, 53 insertions(+), 42 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 3a7ec98ef123..4a0e522f6001 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -869,6 +869,8 @@ struct kvm_vcpu_arch {
> >  #define VCPU_INITIALIZED     __vcpu_single_flag(cflags, BIT(0))
> >  /* SVE config completed */
> >  #define VCPU_SVE_FINALIZED   __vcpu_single_flag(cflags, BIT(1))
> > +/* pKVM VCPU setup completed */
> > +#define VCPU_PKVM_FINALIZED  __vcpu_single_flag(cflags, BIT(2))
> >
> >  /* Exception pending */
> >  #define PENDING_EXCEPTION    __vcpu_single_flag(iflags, BIT(0))
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index eb65f12e81d9..abd693ce5b93 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -19,6 +19,7 @@
> >  int pkvm_init_host_vm(struct kvm *kvm);
> >  int pkvm_create_hyp_vm(struct kvm *kvm);
> >  void pkvm_destroy_hyp_vm(struct kvm *kvm);
> > +int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
> >
> >  /*
> >   * This functions as an allow-list of protected VM capabilities.
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index b8e55a441282..cd7a808eeb64 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -833,6 +833,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> >               ret = pkvm_create_hyp_vm(kvm);
> >               if (ret)
> >                       return ret;
> > +
> > +             ret = pkvm_create_hyp_vcpu(vcpu);
> > +             if (ret)
> > +                     return ret;
> >       }
> >
> >       mutex_lock(&kvm->arch.config_lock);
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > index e42bf68c8848..ce31d3b73603 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > @@ -43,12 +43,6 @@ struct pkvm_hyp_vm {
> >       struct hyp_pool pool;
> >       hyp_spinlock_t lock;
> >
> > -     /*
> > -      * The number of vcpus initialized and ready to run.
> > -      * Modifying this is protected by 'vm_table_lock'.
> > -      */
> > -     unsigned int nr_vcpus;
> > -
> >       /* Array of the hyp vCPU structures for this VM. */
> >       struct pkvm_hyp_vcpu *vcpus[];
> >  };
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 6efb9bf56180..4ef3748dc660 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -245,10 +245,12 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
> >
> >       hyp_spin_lock(&vm_table_lock);
> >       hyp_vm = get_vm_by_handle(handle);
> > -     if (!hyp_vm || hyp_vm->nr_vcpus <= vcpu_idx)
> > +     if (!hyp_vm || hyp_vm->kvm.created_vcpus <= vcpu_idx)
>
> Why is it reasonable to trust kvm.created_vcpus here? It looks like
> something that is under direct control of the host, and that could be
> arbitrarily changed to allow dereferencing the vcpus[] array past its
> actual boundaries.
>
> What guarantees that it is stable at load-time?
>
> I have similar misgivings about the init and teardown paths.

This is the hypervisor's view of created_vcpus
(hyp_vm->kvm.created_vcpus), i.e., not the host's (not
host_kvm->created_vcpus). We read it once from the host at
__pkvm_init_vm(). We should know that it wouldn't overflow the vcpus
array since it's the value of created_vcpus (nr_vcpus) we use when we
calculate the vm_size in __pkvm_init_vm(), and try to map the
corresponding amount of donated memory for the hyp_vm (all in
__pkvm_init_vm()).

Since it's all hyp values, it should be fine, right?

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

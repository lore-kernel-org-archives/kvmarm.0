Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60773A75B8;
	Wed, 23 Sep 2026 16:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790181726; cv=none; b=bKQBWh5cisfhy0d2LJcVPFfUUFc4bNvCYUglif7L0flmVpulUdeZ2jOPWB+/4nJVAGvkgTp1Ey0I/6mejdrWrAfnkq77vdzKY1JIddhOB79fmeXiQ8f+mr9bx/5MjLJlIzqvwPhC8O9Usqgg6uDy6nmQQSDRtTJz2Q+f2+MHTbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790181726; c=relaxed/simple;
	bh=xOZIm6bqo4y68oG1OtMjuRu5Wf7wgmjgjrbJ2UFvh5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJQMrllYSQOveyQxH306TWF3nevgNqaVDWfNot6ga/uKtOPHhc7+nDbfWoZfR9l/KyliOwXARYNKGz4ZHWlXo5+oAEjEqDiVhTXCcZ44dkSWx0nTrW1zaga5LWrUs5BSHqjEpqkduZiGKia9napAQrHvsPQ5OPmHLBecO9sMJFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NH5I5xKQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NH5I5xKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9BA1F00893;
	Wed, 23 Sep 2026 16:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790181715;
	bh=6wsmFKsZ5fCzZ4EY98wEhAeDRg8SsIHUlKL3Es/G0VU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NH5I5xKQ1nd6/2kvbVVde9pEjBC0BgR67EKQo8GB1Dtr4j/bIPWXamiY16OI9c3H4
	 /a/Rgs1UCaegLbltOyTEEL1EICXFNO6PN9n3DrivgjBbmQuy1m8sPTf6n58tCNc33y
	 RPAc3Y4J6DJhP1tsIFBhy35YSNj9l57l+jjlsOwPn7e07GNg4pScKZLA5WONcnRo/I
	 hcHXUyCiPAOxssC+SL7/XNqh345DcIkkl0evAU7c7L5AQ5eeGZuvF+aN7sMU1YLOST
	 ejBa2Zsyb9Jj3rPz5tT//UI+Z+/fJOxXUWOAbCiJLlWlCm1X3N2ZiZSVyqt3bas4dg
	 IP+iHORuEkTOg==
Date: Wed, 23 Sep 2026 09:41:53 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] KVM: arm64: vgic: Stop the VM when disabling LPIs
Message-ID: <arQBUZJ_uUDQapbw@kernel.org>
References: <20260922214212.3327146-1-maz@kernel.org>
 <20260922214212.3327146-4-maz@kernel.org>
 <20260922220125.91CC01F000FF@smtp.kernel.org>
 <86v77w50us.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v77w50us.wl-maz@kernel.org>

Hey,

On Wed, Sep 23, 2026 at 12:21:15AM +0100, Marc Zyngier wrote:
> I think there is a kernel of truth here, and I reckon this is a *very*
> old bug. Something like the below should help. Oliver what do you
> think?
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90b..5f5dd8bead4b9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1352,7 +1352,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  
>  		ret = kvm_arm_vcpu_enter_exit(vcpu);
>  
> -		vcpu->mode = OUTSIDE_GUEST_MODE;
>  		vcpu->stat.exits++;
>  		/*
>  		 * Back from guest
> @@ -1386,6 +1385,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  
>  		kvm_arch_vcpu_ctxsync_fp(vcpu);
>  
> +		/*
> +		 * All the state has been synchronised, let advertise
> +		 * we're outside of the guest.
> +		 */
> +		smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
> +
>  		/*
>  		 * We must ensure that any pending interrupts are taken before
>  		 * we exit guest timing so that timer ticks are accounted as
> 

Yeah, this looks reasonable to me.

> > 
> > >  		vgic_its_invalidate_all_caches(vcpu->kvm);
> > >  		atomic_set_release(&vgic_cpu->ctlr, 0);
> > > +		kvm_arm_resume_guest(vcpu->kvm);
> > 
> > [Severity: High]
> > Does this block need to hold a VM-wide lock?
> > 
> > Since vgic_mmio_write_v3r_ctlr() only synchronizes locally using an atomic
> > cmpxchg on the target vgic_cpu->ctlr, multiple vCPUs could concurrently
> > write to different VGIC redistributors to disable their LPIs.
> > 
> > If this happens, multiple vCPUs will concurrently call kvm_arm_halt_guest()
> > and race to set vcpu->arch.pause = true:
> > 
> > arch/arm64/kvm/arm.c:kvm_arm_halt_guest() {
> >     ...
> > 	kvm_for_each_vcpu(i, vcpu, kvm)
> > 		vcpu->arch.pause = true;
> >     ...
> > }
> > 
> > The first vCPU to finish flushing will call kvm_arm_resume_guest() which
> > unconditionally clears the pause boolean:
> > 
> > arch/arm64/kvm/arm.c:kvm_arm_resume_guest() {
> >     ...
> > 	kvm_for_each_vcpu(i, vcpu, kvm) {
> > 		vcpu->arch.pause = false;
> > 		__kvm_vcpu_wake_up(vcpu);
> > 	}
> >     ...
> > }
> > 
> > Could this unpause the VM prematurely while another vCPU is still tearing
> > down VGIC state in vgic_flush_pending_lpis(), allowing guests to run and
> > modify their VGIC state concurrently?
> 
> Just as interesting. It appears that this doesn't nest correctly,
> while we really rely on it to work. An obvious way to do this is to
> actually turn pause into a refcount. Something like the (untested)
> hack below.
> 
> 	M.
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7a..08dc8f816824c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -889,11 +889,10 @@ struct kvm_vcpu_arch {
>  	/*
>  	 * Don't run the guest (internal implementation need).
>  	 *
> -	 * Contrary to the flags above, this is set/cleared outside of
> -	 * a vcpu context, and thus cannot be mixed with the flags
> -	 * themselves (or the flag accesses need to be made atomic).
> +	 * Contrary to the flags above, this is updated outside of
> +	 * a vcpu context, and thus cannot be mixed with the flags.
>  	 */
> -	bool pause;
> +	refcount_t pause;
>  
>  	/*
>  	 * We maintain more than a single set of debug registers to support
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90b..62b683107ccae 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -561,6 +561,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
>  
>  	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
> +	refcount_set(&vcpu->arch.pause, 0);
>  
>  	/*
>  	 * This vCPU may have been created after mpidr_data was initialized.
> @@ -835,6 +836,11 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> +static bool vcpu_can_run(struct kvm_vcpu *vcpu)
> +{
> +	return !kvm_arm_vcpu_stopped(vcpu) && !refcount_read(&vcpu->arch.pause);
> +}
> +
>  /**
>   * kvm_arch_vcpu_runnable - determine if the vcpu can be scheduled
>   * @v:		The VCPU pointer
> @@ -850,8 +856,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  		      (kvm_timer_should_notify_user(v) ||
>  		       kvm_pmu_should_notify_user(v)));
>  
> -	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
> +	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v)) && !vcpu_can_run(v));
>  }
>  
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> @@ -1014,7 +1019,7 @@ void kvm_arm_halt_guest(struct kvm *kvm)
>  	struct kvm_vcpu *vcpu;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
> -		vcpu->arch.pause = true;
> +		refcount_inc(&vcpu->arch.pause);
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
>  }

No issues with this approach but it is worth noting that all other
callers of kvm_arm_halt_guest() do so behind the config_lock today. You
could probably do the same with the LPI disable path.

Thanks,
Oliver

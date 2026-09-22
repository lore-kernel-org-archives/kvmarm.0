Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F102486B99;
	Tue, 22 Sep 2026 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102117; cv=none; b=BLl4dxEWMVVjhGtYwlhHqxJYkdc2N1kDcTXpP1dGGj/dPTueruMd9L+ldYza6NVu7KwVO3j94wY04hAaTgHKsj6N+ipjR4YEzI5VpScZ0KUqor9LTnS5fK8Rzw4msx2CTIy3kXTFERzrul7ueeSol8xR6cjMuGYlZNlM9TzfwZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102117; c=relaxed/simple;
	bh=IVlpFEDWfSAfJLkX+yFwnPAe6E+OntAzgc8fkBaOFsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qU35ubY+JB0a/rYJ2yOqVUecyCwnkGYJjsPJ6TGkEsGBxOJ/tk73UbmFrE07mLw7T8O/DYKiKtbC9pAtC6/t0kSn0NpO+xgRG6bvpJr8WNWmUQSrxvBFyyPpT6Jel7EJiOb1r2R9bMgVCKMnAfcuV5ghuKj/YQVby+3a8DAImag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gS7H4VV1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gS7H4VV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575E61F000FF;
	Tue, 22 Sep 2026 18:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790102115;
	bh=V2Wnj5RPep/Gg6xTG2yJLcOcZWZlxZ40baoPjkIZDiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gS7H4VV15RsjyjT0PbQmFK2HFd32m/D7+DDeNvMhGVYWksjlGofm/M9HiqrSYX2TV
	 JRovjuYETfq/88zMYxw4w0+Ki1klGj7H3zpzdqFXuHvyNThugWFqn4kkcqIOYIToaj
	 AhUe4m3XXJ+IViD1k6FmV92REZDTseLIXQcPqYgsEUzILWmpAU/Sx+Gxykl/j2i3hB
	 30uM1juMZRb0rsJQelVrYbEYU5iJiDW38igpw9qFtHwS3jWGj+maui80P5nNtG9ltK
	 wWQpTzIrNHeMBWh7k9HUGaocCddJsWYub0pLTqGBMZU/LE9w+YLPUVSRtWVXqvFRHA
	 smLpJQLrdrPGg==
Date: Tue, 22 Sep 2026 19:35:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 01/14] KVM: Allow architectures to disallow pre-fault
Message-ID: <arLJ4AbNN9Y_IUna@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org>
 <arKxjsxuO1F5ExrY@kernel.org>
 <arK5n9HrbZMCOHOt@google.com>
 <arK5ynpRi7VbY7Ek@gremlin>
 <arK8seJVT9wYgVCP@google.com>
 <arLD-eZ6dRvfZ52q@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arLD-eZ6dRvfZ52q@kernel.org>

On Tue, Sep 22, 2026 at 11:07:53AM -0700, Oliver Upton wrote:
> On Tue, Sep 22, 2026 at 10:36:49AM -0700, Sean Christopherson wrote:
> > On Tue, Sep 22, 2026, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Sep 22, 2026 at 10:23:43AM -0700, Sean Christopherson wrote:
> > > > Rather than have kvm_arch_vcpu_allow_pre_fault_memory(), what if we add a more
> > > > generic kvm_is_vcpu_loadable()?  That way we don't need to worry as much about
> > > > the return value, the connection to vcpu_load() is obvious, and we don't need to
> > > > add another pre-check if future (or cleaned-up existing?) ioctls want to do
> > > > vcpu_load() in common code.
> > >
> > > ...this is exactly what I started out with.
> > >
> > > But then you are in a pickle, because _really_ you need to do that check in
> > > vcpu_load(). Which is a void function. Which is called by every single
> > > architecture all over the place.
> > >
> > > So you'd have actually no way of signalling the error back.
> > >
> > > Of course those places are arch code and you could say 'arches should know
> > > better and if they call it it's fine not to call the arch 'can you load'
> > > function.
> >
> > Yes, that's my vote.  It'd be easy enough to clarify that "rule" with a comment
> > in linux/kvm_host.h.
>
> I feel like trying to make this generic will wind up under-documenting
> the single example we have with the pre fault ioctl. Putting the comment
> into a header practically guarantees that nobody will read it either.
>
> I'd favor doing something like below and sticking the comment inline in
> the ioctl handler. Unless I'm missing something blatantly obvious, I
> don't see why the x86 or s390 pre-conditions can't be tested early too.
>
> But I don't care enough to bikeshed this any further.

Haha yup :) this is eminately bikesheddable territory.

>
> Thanks,
> Oliver

I'm fine with the below if x86/s390 people are.

The inline comment is a cheeky trick that should help clarify intent (I think
perhaps Sean that's what you meant re: people assuming it would check some local
state?)

Anyway if people think that's sane I can do on respin and we can settle on the
lovely shade of purple or whatever the shed looks like now ;)

>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90..396e64875fe7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1852,6 +1852,14 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>  	return __kvm_arm_vcpu_set_events(vcpu, events);
>  }
>
> +int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
> +{
> +	if (!kvm_vcpu_initialized(vcpu))
> +		return -ENOEXEC;
> +
> +	return 0;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> diff --git a/arch/s390/kvm/s390/s390.c b/arch/s390/kvm/s390/s390.c
> index 5c73f43782a7..47fe032444f4 100644
> --- a/arch/s390/kvm/s390/s390.c
> +++ b/arch/s390/kvm/s390/s390.c
> @@ -5784,6 +5784,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm, struct kvm_memory_slot *old,
>  	s390_kvm_mmu_commit_memory_region(kvm, old, new, change);
>  }
>
> +int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_is_ucontrol(vcpu->kvm))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  /**
>   * kvm_arch_vcpu_pre_fault_memory() -- pre-fault and link gmap dat tables
>   * @vcpu: the vcpu that shall appear to have generated the fault-in.
> @@ -5810,9 +5818,6 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu, struct kvm_pre_fault_
>  	gpa_t end;
>  	int rc;
>
> -	if (kvm_is_ucontrol(vcpu->kvm))
> -		return -EINVAL;
> -
>  	rc = kvm_s390_faultin_gfn(vcpu, NULL, &f);
>  	if (rc == PGM_ADDRESSING)
>  		return -ENOENT;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 064ecc33b926..c35fd2868c20 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5086,6 +5086,14 @@ static int kvm_tdp_page_prefault(struct kvm_vcpu *vcpu, gpa_t gpa,
>  	}
>  }
>
> +int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
> +{
> +	if (!vcpu->kvm->arch.pre_fault_allowed)
> +		return -EOPNOTSUPP;
> +
> +	return 0;
> +}
> +
>  long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				    struct kvm_pre_fault_memory *range)
>  {
> @@ -5095,9 +5103,6 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	u64 end;
>  	int r;
>
> -	if (!vcpu->kvm->arch.pre_fault_allowed)
> -		return -EOPNOTSUPP;
> -
>  	if (kvm_is_gfn_alias(vcpu->kvm, gpa_to_gfn(range->gpa)))
>  		return -EINVAL;
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 03bfc92864b6..bff842548c04 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1693,6 +1693,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
>  bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu);
> +int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu);
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>  void kvm_arch_create_vm_debugfs(struct kvm *kvm);
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 65eb26a0520d..07f2ce7a3cb3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3961,6 +3961,11 @@ bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
>  	return false;
>  }
>
> +int __weak kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +
>  void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  {
>  	int nr_vcpus, start, i, idx, yielded;
> @@ -4353,7 +4358,7 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
>  static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				     struct kvm_pre_fault_memory *range)
>  {
> -	int idx;
> +	int idx, ret;
>  	long r;
>  	u64 full_size;
>
> @@ -4365,6 +4370,14 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	    range->gpa + range->size <= range->gpa)
>  		return -EINVAL;
>
> +	/*
> +	 * Certain architectures (e.g. arm64) need to reject the ioctl 'early'
> +	 * before vcpu_load().
> +	 */
> +	ret = kvm_arch_pre_fault_allowed(vcpu);
> +	if (ret)
> +		return ret;
> +
>  	vcpu_load(vcpu);
>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>
> Thanks,
> Oliver

--
Cheers, Lorenzo

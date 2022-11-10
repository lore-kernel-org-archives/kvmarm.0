Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9B91E9E4
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 21:14:01 +0000 (UTC)
Date: Thu, 10 Nov 2022 21:13:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668114839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ckG15L9PrceppUGg6WFZqlBg6XN5ZaFg+y1ysjbNu/U=;
	b=S/LtaSEChtFI7NOXzqtvopanfsQ+gFUFi5nKDCkuzuVplC5C2wjeiTY8sSjjluiTEyLRiX
	XZnFBoQWbLn+QEOjXqYXsM2tRiT7J3HztitomeQV3boT78ySJwD29pa1VjJ3PsTBc2mtjk
	Tyy1KxRko7TWqbMVtr/OZ+ltGnvkdUQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] KVM: arm64: Allow userspace to trap SMCCC
 sub-ranges
Message-ID: <Y21pktYPLPM6eYga@google.com>
References: <20221110015327.3389351-1-oliver.upton@linux.dev>
 <20221110015327.3389351-3-oliver.upton@linux.dev>
 <86o7tfov7v.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o7tfov7v.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221110211354.WqjV3cz1oAIkOqUEpLXQ8FDOmGJ0jLks0zLf7UwPjZo@z>

On Thu, Nov 10, 2022 at 12:22:12PM +0000, Marc Zyngier wrote:
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index e33ed7c09a28..cc3872f1900c 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -52,6 +52,9 @@
> >  
> >  #define KVM_HAVE_MMU_RWLOCK
> >  
> > +#define KVM_ARM_USER_HYPERCALL_FLAGS	\
> > +		GENMASK_ULL(KVM_ARM_USER_HYPERCALL_FLAGS_COUNT - 1, 0)
> > +
> >  /*
> >   * Mode of operation configurable with kvm-arm.mode early param.
> >   * See Documentation/admin-guide/kernel-parameters.txt for more information.
> > @@ -104,11 +107,13 @@ struct kvm_arch_memory_slot {
> >  /**
> >   * struct kvm_smccc_features: Descriptor of the hypercall services exposed to the guests
> >   *
> > + * @user_trap_bmap: Bitmap of SMCCC function ranges trapped to userspace
> >   * @std_bmap: Bitmap of standard secure service calls
> >   * @std_hyp_bmap: Bitmap of standard hypervisor service calls
> >   * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
> >   */
> >  struct kvm_smccc_features {
> > +	unsigned long user_trap_bmap;
> 
> nit: I strongly object to the word 'trap'. By definition, this is a
> trap. The difference here is that you *forward* something to userspace
> instead of implementing it in the kernel.

I think you're being polite calling this a 'nit' :-)

Naming came about lazily to shorten some names, but completely breaks
the notion of what a trap is. Oops.

> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 62ce45d0d957..22a23b12201d 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -92,6 +92,49 @@ static bool kvm_hvc_call_default_allowed(u32 func_id)
> >  	}
> >  }
> >  
> > +static bool kvm_hvc_call_user_trapped(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +	unsigned long *bmap = &kvm->arch.smccc_feat.user_trap_bmap;
> > +
> > +	switch (ARM_SMCCC_OWNER_NUM(func_id)) {
> > +	case ARM_SMCCC_OWNER_ARCH:
> > +		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_ARCH, bmap);
> > +	case ARM_SMCCC_OWNER_CPU:
> > +		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_CPU, bmap);
> > +	case ARM_SMCCC_OWNER_SIP:
> > +		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_SIP, bmap);
> > +	case ARM_SMCCC_OWNER_OEM:
> > +		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_OEM, bmap);
> > +	case ARM_SMCCC_OWNER_STANDARD:
> > +		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_STANDARD, bmap);
> > +	case ARM_SMCCC_OWNER_STANDARD_HYP:
> > +		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_STANDARD_HYP, bmap);
> > +	case ARM_SMCCC_OWNER_VENDOR_HYP:
> > +		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_VENDOR_HYP, bmap);
> > +	case ARM_SMCCC_OWNER_TRUSTED_APP ... ARM_SMCCC_OWNER_TRUSTED_APP_END:
> > +		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_TRUSTED_APP, bmap);
> > +	case ARM_SMCCC_OWNER_TRUSTED_OS ... ARM_SMCCC_OWNER_TRUSTED_OS_END:
> > +		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_TRUSTED_OS, bmap);
> > +	default:
> > +		return false;
> > +	}
> 
> You have multiple problems here:
> 
> - the granularity is way too coarse. You want to express arbitrary
>   ranges, and not necessarily grab a whole owner range.
> 
> - you have now an overlap between ranges that are handled in the
>   kernel (PSCI, spectre mitigations) and ranges that userspace wants
>   to observe. Not good.

We need to come to agreement on what degree of mix-and-match should be
supported.

Spectre really ought to be in the kernel, and I don't think anyone is
particularly excited about reimplementing PSCI. Right now my interest
in this starts and ends with forwarding the vendor-specific hypercall
range to userspace, allowing something like Hyper-V PV on KVM.

> If we are going down this road, this can only be done at the
> *function* level. And userspace must know that the kernel will refuse
> to forward some ranges.

The goal of what I was trying to get at is that either the kernel or
userspace takes ownership of a range that has an ABI, but not both. i.e.
you really wouldn't want some VMM or cloud provider trapping portions of
KVM's vendor-specific range while still reporting a 'vanilla' ABI at the
time of discovery. Same goes for PSCI, TRNG, etc.

> So obviously, this cannot be a simple bitmap. Making it a radix tree
> (or an xarray, which is basically the same thing) could work. And the
> filtering request from userspace can be similar to what we have for
> the PMU filters.

Right, we'll need a more robust data structure for all this.

My only concern is that communicating the hypercall filter between
user/kernel with a set of ranges or function numbers is that we could be
mutating what KVM *doesn't* already implement into an ABI of sorts.

i.e. suppose that userspace wants to filter function(s) in an
unallocated/unused range of function numbers. Later down the line KVM
adds support for a new shiny thing and the filter becomes a subset of a
now allocated range of calls. We then reject the filter due to the
incongruence.

> > +}
> > +
> > +static void kvm_hvc_prepare_user_trap(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_run *run = vcpu->run;
> > +
> > +	run->exit_reason	= KVM_EXIT_HYPERCALL;
> > +	run->hypercall.nr	= smccc_get_function(vcpu);
> > +	run->hypercall.args[0]	= smccc_get_arg(vcpu, 1);
> > +	run->hypercall.args[1]	= smccc_get_arg(vcpu, 2);
> > +	run->hypercall.args[2]	= smccc_get_arg(vcpu, 3);
> > +	run->hypercall.args[3]	= smccc_get_arg(vcpu, 4);
> > +	run->hypercall.args[4]	= smccc_get_arg(vcpu, 5);
> > +	run->hypercall.args[5]	= smccc_get_arg(vcpu, 6);
> 
> All of which is readily available through the ONE_REG interface. I'm
> mildly reluctant to expose another interface that disclose the same
> information (yes, I understand the performance impact).

I can drop this bit for now, always easy to add it back in and advertize
with a flag if the overhead is too great.

--
Thanks,
Oliver

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BC1284671
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 23:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762557686; cv=none; b=tNhF/XQ61k4U1Z1xuU+rCSsAvYoxgfWqO7FNKAbewgTiJrOj72rIizhOgDmidWstT7xaSTX9yPiwjaobjQCIR83fj3z+y1dbpbKxMFZIoFmC1wV/X8wHcEL2US+WM+lEUhRL/h/WByOrDfinjK1JUW96iKY5QuRhEBgFf8t74V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762557686; c=relaxed/simple;
	bh=CUUuS8pprmMGGLz7wegIQEujEfE4Gb2O/WZVgS7MqME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNiBfQRIGQo40WssyAmRbT7oop/tIsud3trd1XZRgo1RSsPZoUp2Ts0sHEGJlYH31BFUMPqHW5Ot3dlAhTSE6fYjwW7/HVfoxcHESOKBpO+CgwsjZ1ZRI9m0mofcEkUQibwiGhPQqqrKga5+CXZMaokk+7Wmc+jm5xPYW4aGV3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPTGRFWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPTGRFWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0162BC4CEF7;
	Fri,  7 Nov 2025 23:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762557686;
	bh=CUUuS8pprmMGGLz7wegIQEujEfE4Gb2O/WZVgS7MqME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OPTGRFWALroD5xLQ6hlpiA6i+i3394e6x06fYD1XpQhJr8O7BFLj6IYEm5ZqKxN4N
	 p76Qch5FEKXd4URov25mOvc/30EBxn+CRXK5r0ZeMrnIpKC3C9MN5AfWU54/eq6XcI
	 3MrhR4IJpXnBiah1CbvBR9SEJOduw9MlCIEZZ712lAGMIyPcoc27N3HUo9pwPt9rjA
	 CFd1I3L1ntgcfXLxhP0jnnXFIVOjX5hbmVfAg53tWQSqUOjelvfujIwZKw+gooHwWI
	 c5kghsRDGSStWstPRyUyjFvdOXRQmDUfXcg7XLR96aw8WRnFHTIxOI36/Gnyd7VIBT
	 kHFCHO7D5agRA==
Date: Fri, 7 Nov 2025 15:21:24 -0800
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vladimir.murzin@arm.com
Subject: Re: [PATCH v2 4/5] KVM: arm64: Prevent host from managing timer
 offsets for protected VMs
Message-ID: <aQ5-9PsBl3z9UxOS@kernel.org>
References: <20251106144418.2847443-1-tabba@google.com>
 <20251106144418.2847443-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106144418.2847443-5-tabba@google.com>

On Thu, Nov 06, 2025 at 02:44:16PM +0000, Fuad Tabba wrote:
> For protected VMs, the guest's timer offset state is private and must
> not be controlled by the host. Protected VMs must always run with a
> virtual counter offset of 0.
> 
> The existing timer logic allowed the host to set and manage the timer
> counter offsets (voffset and poffset) for protected VMs.
> 
> This patch disables all host-side management of timer offsets for
> protected VMs by adding checks in the relevant code paths.

"This patch ..." is generally discouraged in changelogs, just state what
you're doing in an imperative tone.

> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/arch_timer.c | 18 +++++++++++++-----
>  arch/arm64/kvm/sys_regs.c   |  6 ++++--
>  2 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3f675875abea..69f5631ebf84 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1056,10 +1056,14 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>  
>  	ctxt->timer_id = timerid;
>  
> -	if (timerid == TIMER_VTIMER)
> -		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
> -	else
> -		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
> +	if (!kvm_vm_is_protected(vcpu->kvm)) {
> +		if (timerid == TIMER_VTIMER)
> +			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
> +		else
> +			ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
> +	} else {
> +		ctxt->offset.vm_offset = NULL;
> +	}
>  
>  	hrtimer_setup(&ctxt->hrtimer, kvm_hrtimer_expire, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
>  
> @@ -1083,7 +1087,8 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  		timer_context_init(vcpu, i);
>  
>  	/* Synchronize offsets across timers of a VM if not already provided */
> -	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
> +	if (!vcpu_is_protected(vcpu) &&
> +	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
>  		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
>  		timer_set_offset(vcpu_ptimer(vcpu), 0);
>  	}
> @@ -1687,6 +1692,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
>  	if (offset->reserved)
>  		return -EINVAL;
>  
> +	if (kvm_vm_is_protected(kvm))
> +		return -EBUSY;
> +

This should be -EINVAL as pVMs do not even advertise the capability.

Since we already have a generic helper for filtering KVM_CAPs, I'd
prefer that we have a similar thing for enforcing ioctl limitations too.

For example, you could maintain the ioctl => KVM_CAP mapping in a table
and use kvm_pvm_ext_allowed() as the source of truth.

>  	mutex_lock(&kvm->lock);
>  
>  	if (!kvm_trylock_all_vcpus(kvm)) {
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e67eb39ddc11..3329a8f03436 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1606,11 +1606,13 @@ static int arch_timer_set_user(struct kvm_vcpu *vcpu,
>  		val &= ~ARCH_TIMER_CTRL_IT_STAT;
>  		break;
>  	case SYS_CNTVCT_EL0:
> -		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> +		if (!vcpu_is_protected(vcpu) &&
> +		    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
>  			timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read() - val);
>  		return 0;
>  	case SYS_CNTPCT_EL0:
> -		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> +		if (!vcpu_is_protected(vcpu) &&
> +		    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
>  			timer_set_offset(vcpu_ptimer(vcpu), kvm_phys_timer_read() - val);

Isn't there a general expectation that userspace not have access to the
vCPU state of a pVM? That should be the mechanism of enforcement instead
of special-casing these registers.

Thanks,
Oliver

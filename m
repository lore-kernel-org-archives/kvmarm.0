Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BF31741C3
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 22:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722985144; cv=none; b=MEfxnQDmElxgihiwzBGdg2bqTZVFqUdZ2UW5z1wqYFxSGdjLhmld38jrQonPHNZUg/wzRLX3ILBpgbyjFEN86yFBtq+YLPSrHB4FQc238G6iauVAuNDYwSjy9xqFijGNwKyl5E1XZOcRj38fMZXPsz6lKyhzaGasiiM0CovI7Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722985144; c=relaxed/simple;
	bh=Q0ZK1NZ0/1G1Bc9S2Bkbkfss4kUIKpeyfHdQCbRTI5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NkYTtigXaicrzx4RMfY0w+ZAQMpgbjaUDicQXTeqciYYaxLLUwbzzgAl3CjmEy5O9tZFtQc9bjIq0bPHVz/9Tnz5ErkEfCigen6DS6Dy5bTajBnp1Qers4FMphA+pPlC/DdoFB5O7GbYLwXcIP8icBmgeKTmuRrXSdDOwNfKtcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MT7SOl/8; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MT7SOl/8"
Date: Tue, 6 Aug 2024 15:58:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722985137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WqjCWx3iKIIOBiEbdFwU6vk7tX5x9+cQDaS5Z4GhKug=;
	b=MT7SOl/8Qd4gf4AEhDylb4Tm6ZeYRaOaSslKQvFF4ia4a3atanaVQO6Og1knthtaT3Wpvu
	f1jJgXNaYtwNpEJFN/BBB/A1miGtQhrkA/cL3/4wYElzBYDnAH/craMZsRCUWOso2hStin
	AowjlBMtaUV65lr67ZlbOX8CE/OebHI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Rutherford <srutherford@google.com>
Subject: Re: [PATCH 2/2] KVM: Protect vCPU's "last run PID" with rwlock, not
 RCU
Message-ID: <ZrKqrCnNpNQ_K_qi@linux.dev>
References: <20240802200136.329973-1-seanjc@google.com>
 <20240802200136.329973-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802200136.329973-3-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 02, 2024 at 01:01:36PM -0700, Sean Christopherson wrote:
> To avoid jitter on KVM_RUN due to synchronize_rcu(), use a rwlock instead
> of RCU to protect vcpu->pid, a.k.a. the pid of the task last used to a
> vCPU.  When userspace is doing M:N scheduling of tasks to vCPUs, e.g. to
> run SEV migration helper vCPUs during post-copy, the synchronize_rcu()
> needed to change the PID associated with the vCPU can stall for hundreds
> of milliseconds, which is problematic for latency sensitive post-copy
> operations.
> 
> In the directed yield path, do not acquire the lock if it's contended,
> i.e. if the associated PID is changing, as that means the vCPU's task is
> already running.
> 
> Reported-by: Steve Rutherford <srutherford@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  include/linux/kvm_host.h          |  3 ++-
>  virt/kvm/kvm_main.c               | 32 +++++++++++++++++--------------
>  3 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a33f5996ca9f..7199cb014806 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1115,7 +1115,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>  
> -#define vcpu_has_run_once(vcpu)	!!rcu_access_pointer((vcpu)->pid)
> +#define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
>  
>  #ifndef __KVM_NVHE_HYPERVISOR__
>  #define kvm_call_hyp_nvhe(f, ...)						\
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 689e8be873a7..d6f4e8b2b44c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -342,7 +342,8 @@ struct kvm_vcpu {
>  #ifndef __KVM_HAVE_ARCH_WQP
>  	struct rcuwait wait;
>  #endif
> -	struct pid __rcu *pid;
> +	struct pid *pid;
> +	rwlock_t pid_lock;
>  	int sigset_active;
>  	sigset_t sigset;
>  	unsigned int halt_poll_ns;

Adding yet another lock is never exciting, but this looks fine. Can you
nest this lock inside of the vcpu->mutex acquisition in
kvm_vm_ioctl_create_vcpu() so lockdep gets the picture?


> @@ -4466,7 +4469,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		r = -EINVAL;
>  		if (arg)
>  			goto out;
> -		oldpid = rcu_access_pointer(vcpu->pid);
> +		oldpid = vcpu->pid;

It'd be good to add a comment here about how this is guarded by the
vcpu->mutex, as Steve points out.

-- 
Thanks,
Oliver

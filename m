Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA80576410
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 07:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728977877; cv=none; b=rjH1zYXk3eslCoZl6uszrhIxvmmhkvucC0NStRmo0ePmdFCdg6NtFgkt2Jxsmm//YsAUsXs8mV5gA1oK2lLTPbbO/hZL7a+VNwC5a2tcczvVMXUgotKvE7VXOa7H9p/I073mmfXH/qepAhnPez5WJhOIGE3b44BzwFelQrKySfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728977877; c=relaxed/simple;
	bh=a9My1obh12n0rw4Z0caKwvaihDkUlBTf9Gn8rin69oA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+eRkQJcBYaIXiBDF5SBEjZTgcniuR0qjRfnToxsd2AVpZMibD2TTzEQvCPd2nyQ5PnqbFSNx1fR988T5Rq0GVCu8GGBz19GHUzuDJFTN9FOqVFxLSX2nJCfrOxUNfvC6ZX1qQUMwFgLxF+xMpRErgTPMhR2JNBm3rz6+bEBtsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cSGY0yhY; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cSGY0yhY"
Date: Tue, 15 Oct 2024 00:37:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728977873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G8+Y76Rw6Xbz0/9P9EhPniThY8QceIGtCmcxBuUFWM8=;
	b=cSGY0yhY0RHJyiSUe1O6g0ew8syUbMA9L886RYgZNZJbFJL5YOHMTVRyUtef8aWLaaQT9j
	039WG1UXkY+X5qmMEK5wqzM6fHDfP6ORG/IFsftWfNWvNV5tIehnicuJIfUIkaS2Ra34j9
	HLKBAywCW2NPaEcTc7j+BZWUo1x02oo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org
Subject: Re: [PATCH v1 1/4] KVM: arm64: Move pkvm_vcpu_init_traps() to
 init_pkvm_hyp_vcpu()
Message-ID: <Zw4byVfZngXV19ni@linux.dev>
References: <20241014102413.4092725-1-tabba@google.com>
 <20241014102413.4092725-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014102413.4092725-2-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 14, 2024 at 11:24:09AM +0100, Fuad Tabba wrote:
> Move pkvm_vcpu_init_traps() to the initialization of the
> hypervisor's vcpu state in init_pkvm_hyp_vcpu(), and remove the
> associated hypercall.
> 
> In protected mode, traps need to be initialized whenever a VCPU
> is initialized anyway, and not only for protected VMs. This also
> saves an unnecessary hypercall.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h               | 1 -
>  arch/arm64/kvm/arm.c                           | 8 --------
>  arch/arm64/kvm/hyp/include/nvhe/trap_handler.h | 2 --
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c             | 8 --------
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                 | 4 +++-
>  5 files changed, 3 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index b36a3b6cc011..7f7866d2bfc2 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -76,7 +76,6 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
>  	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
>  	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
> -	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a0d01c46e408..ece934bb4531 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -856,14 +856,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  		static_branch_inc(&userspace_irqchip_in_use);
>  	}
>  
> -	/*
> -	 * Initialize traps for protected VMs.
> -	 * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
> -	 * the code is in place for first run initialization at EL2.
> -	 */
> -	if (kvm_vm_is_protected(kvm))
> -		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
> -

Can we instead get rid of this hypercall by implementing the one-time
late initialization as the comment suggests?

It'd be great if the feature configuration for non-protected and
protected VMs is done in a similar way, and that is userspace changes to
the ID registers before KVM_RUN.

So we need this sort of 'late' initialization for that behavior to work.

-- 
Thanks,
Oliver

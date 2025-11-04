Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC46F2F90C4
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 13:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762263888; cv=none; b=K1BecfEhY3C0gJhTWMQa68xywsZ1uyS8GSoxpJVXkysVtWzFrBslcAgQhAWBqMgSx7OXL2X3+QgPVVdYc+JnH3y8vlgMvU0W2J/ZBYaWBKL0X37pVUj+0RN5tUAUlHb2OhmypOHvceG5Eg0YhDZL84ImQyVgUdLk2jNhKOIwin0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762263888; c=relaxed/simple;
	bh=uTrMA8ZhlTtKMJeq+WTHyRnoaVOPZ/x2fXMeWKhhrZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTwIvHDRFY74t3yHBFTYPyn2itMxDLngz4RNyjuQtsNQsCya4j2fCYj0qspzRheZEmOZlhr68eHMusrpVGwJ0u1Y5YMB2EFeDpa6siMDQw6pBghSvmqd52/6rDfgFr8tZCCexDg06SkpObzhC3UDzlTV+YH9CRdMEHCU8eyWxtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FD161CE0;
	Tue,  4 Nov 2025 05:44:38 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D5CF3F66E;
	Tue,  4 Nov 2025 05:44:44 -0800 (PST)
Date: Tue, 4 Nov 2025 13:44:39 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vladimir.murzin@arm.com
Subject: Re: [PATCH v1 1/8] KVM: arm64: Route MOPS exceptions to EL2 when
 guest lacks support
Message-ID: <20251104134439.GA285975@e124191.cambridge.arm.com>
References: <20251104125906.1919426-1-tabba@google.com>
 <20251104125906.1919426-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104125906.1919426-2-tabba@google.com>

Hi Fuad,

On Tue, Nov 04, 2025 at 12:58:59PM +0000, Fuad Tabba wrote:
> MOPS exceptions must be routed to the hypervisor (EL2) when the guest
> does not support the feature. If the guest does support MOPS, exceptions
> should be handled by the guest at EL1.
> 
> The existing logic was inverted: exceptions were trapped to EL2 (by
> setting HCRX_EL2_MCE2) when the guest supported MOPS, and left to be
> handled at EL1 when it did not.
> 

This doesn't seem quite right? Check the commit message of 2de451a329:

  A KVM guest may use the instructions at EL1 at times when the guest is
  not able to handle the exception, expecting that the instructions will
  only run on one CPU (e.g. when running UEFI boot services in the guest).
  As KVM may reschedule the guest between different types of CPUs at any
  time (on an asymmetric system), it needs to also handle the resulting
  exception itself in case the guest is not able to. A similar situation
  will also occur in the future when live migrating a guest from one type
  of CPU to another.

So it's intentionally trapping MOPS to EL2.

Also with HCRX_EL2.MSCEn=0, execution of the MOPS instructions are UNDEFINED at
EL0/EL1, so you wouldn't take any MOPS exceptions to EL2 anyway.

Thanks,
Joey

> Fix this by moving the setting of HCRX_EL2_MCE2 from the feature-check
> block to the 'else' block, ensuring exceptions are only trapped to EL2
> when the guest cannot handle them.
> 
> Fixes: 84de212d739e ("KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index c9eab316398e..0f8311263edf 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -684,7 +684,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>  		vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
>  
>  		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
> -			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_MSCEn;
> +		else
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_MCE2;
>  
>  		if (kvm_has_tcr2(kvm))
>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
> -- 
> 2.51.2.997.g839fc31de9-goog
> 

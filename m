Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748161E7C20
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 20:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744230327; cv=none; b=M1XtALWmJG8u1dFyOHJ30BjfTPBKwEObOEq4w3rpO3iA5h9jUbmKRyCkm5pptkIitn6c4F1/OoXnY9EXFTdvMAhovH9FQ7ae9C5jl51H3pOUnaujdyU4V6WBIWx81KbMSt76xANNjusgWTl4KP2ywUKkj8WWCUijJB+lrsptWK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744230327; c=relaxed/simple;
	bh=VG0asJgSWz31f+eUjtw4b+Lr54h+IDbMM3L2m+p7ous=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qLY/jgu+vm68sXUuTRFIWv0fDQdUtZyvFcyokDLjCIaz7rS50ANSMGx7M6UUOr61TLPOnsQJYNfwmv8k4fs4Ijs3ttGAOBCOIGMfOIyGMLGdIrMOhHf9/ZT7XeSwPYjOYPg8qJXP/70sRNUUaZjjWndB3SLphJwExAX+UcbETc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EfPl9gvZ; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EfPl9gvZ"
Date: Wed, 9 Apr 2025 13:25:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744230323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5jlmwYBu2oRH1liodMvw0DLZE3UBmvT9dFMsw7V0bHU=;
	b=EfPl9gvZnpeSw5sXS4Rbq0dN+b3wrz2h4fSxxTDu77H8iiDoD3YLFak7Z8bFhLNpzs+n1U
	DCKhd+TczuEWxIqgE6DhyE6xnadpqBBZqtVXvs9AAm0tWxfg/52e5wmf43/y5jPTHZSOEk
	0g/1jQK86hQbrpF9nbVfqYLNymKmrv4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 3/6] KVM: arm64: Allow userspace to limit the number
 of PMU counters for EL2 VMs
Message-ID: <Z_bXr5izZdn93ryv@linux.dev>
References: <20250409160106.6445-1-maz@kernel.org>
 <20250409160106.6445-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409160106.6445-4-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 09, 2025 at 05:01:03PM +0100, Marc Zyngier wrote:
> As long as we had purely EL1 VMs, we could easily update the number
> of guest-visible counters by letting userspace write to PMCR_EL0.N.
> 
> With VMs started at EL2, PMCR_EL1.N only reflects MDCR_EL2.HPMN,
> and we don't have a good way to limit it.
> 
> For this purpose, introduce a new PMUv3 attribute that allows
> limiting the maximum number of counters. This requires the explicit
> selection of a PMU.
> 
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 24 ++++++++++++++++++++++++
>  arch/arm64/include/uapi/asm/kvm.h       |  9 +++++----
>  arch/arm64/kvm/pmu-emul.c               | 24 ++++++++++++++++++++++++
>  3 files changed, 53 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 31a9576c07afa..6eef154a2e396 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -137,6 +137,30 @@ exit_reason = KVM_EXIT_FAIL_ENTRY and populate the fail_entry struct by setting
>  hardare_entry_failure_reason field to KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED and
>  the cpu field to the processor id.
>  
> +1.5 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_SET_PMCR_N

Similar to my comment on the kvm_arch field, this should be renamed to
something other than PMCR_N.

Otherwise the implementation of the ioctl itself LGTM.

> +---------------------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address to an unsigned int
> +	     representing the maximum value taken by PMCR_EL0.N
> +
> +:Returns:
> +
> +	 =======  ====================================================
> +	 -EBUSY   PMUv3 already initialized, a VCPU has already run or
> +                  an event filter has already been set
> +	 -EFAULT  Error accessing the value pointed to by addr
> +	 -ENODEV  PMUv3 not supported or GIC not initialized
> +	 -EINVAL  No PMUv3 explicitly selected, or value of N out of
> +	 	  range
> +	 =======  ====================================================
> +
> +Update the maximum value allowed in PMCR_EL0.N, defining the number of
> +counters visible to the guest.

Set the number of implemented event counters in the vPMU

Thanks,
Oliver

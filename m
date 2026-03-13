Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B85E3A4F5A
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773412229; cv=none; b=CKHHp75dTP6MTRTBlEGiIFUDdv2dHNXGUhZIFyEd4+VyxWludVPdTCXMCC58njj4kj2Ty06cddieDRWR0v35Qg7SwHDHEBasv3sIAnVJAhAbThvcXK8o7Jq3sD4WhM3lzSA51pW3+NJUz85Jeu0l9Ch+sJhF2B+rdOXUDb6Fsho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773412229; c=relaxed/simple;
	bh=nYwqeFc8OgCowD+Gzv8JyACPtM0oEhL1VoJpKzVF6cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REYmqPX78xmZ+Qq0SBNtOZmi0I7QWjLsQ3JW0VTIDN0nQxOnEnwWqwSI3ynVOdDtXS1OGPc/yFbnX5IPGG9DkRIMv04NBLDe4G2zWMIUx+hCKjX3YQ0fAaz+s6zmq1gq/b90LbTaUI2a5jMXKZLLvg8cxBS+fBF6O6CxS/V8o1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A91E5165C;
	Fri, 13 Mar 2026 07:30:18 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4AA23F7BD;
	Fri, 13 Mar 2026 07:30:23 -0700 (PDT)
Date: Fri, 13 Mar 2026 14:30:19 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Discard PC update state on vcpu reset
Message-ID: <20260313143019.GA3369094@e124191.cambridge.arm.com>
References: <20260312140850.822968-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312140850.822968-1-maz@kernel.org>

On Thu, Mar 12, 2026 at 02:08:50PM +0000, Marc Zyngier wrote:
> Our vcpu reset suffers from a particularly interesting flaw, as it
> does not correctly deal with state that will have an effect on the
> execution flow out of reset.
> 
> Take the following completely random example, never seen in the wild
> and that never resulted in a couple of sleepless nights: /s
> 
> - vcpu-A issues a PSCI_CPU_OFF using the SMC conduit
> 
> - SMC being a trapped instruction (as opposed to HVC which is always
>   normally executed), we annotate the vcpu as needing to skip the
>   next instruction, which is the SMC itself
> 
> - vcpu-A is now safely off
> 
> - vcpu-B issues a PSCI_CPU_ON for vcpu-A, providing a starting PC
> 
> - vcpu-A gets reset, get the new PC, and is sent on its merry way
> 
> - right at the point of entering the guest, we notice that a PC
>   increment is pending (remember the earlier SMC?)
> 
> - vcpu-A skips its first instruction...
> 
> What could possibly go wrong?
> 
> Well, I'm glad you asked. For pKVM as a NV guest, that first instruction
> is extremely significant, as it indicates whether the CPU is booting
> or resuming. Having skipped that instruction, nothing makes any sense
> anymore, and CPU hotplugging fails.

Would the normal method of offlining/onlining via sysfs also be affected?

> 
> This is all caused by the decoupling of PC update from the handling
> of an exception that triggers such update, making it non-obvious
> what affects what when.
> 
> Fix this train wreck by discarding all the PC-affecting state on
> vcpu reset.

Good job on tracking it down.. makes you wonder why the DSB "fixed" things!

> 
> Fixes: f5e30680616ab ("KVM: arm64: Move __adjust_pc out of line")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/reset.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 959532422d3a3..b963fd975aaca 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -247,6 +247,20 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  			kvm_vcpu_set_be(vcpu);
>  
>  		*vcpu_pc(vcpu) = target_pc;
> +
> +		/*
> +		 * We may come from a state where either a PC update was
> +		 * pending (SMC call resulting in PC being increpented to
                                                           incremented
> +		 * skip the SMC) or a pending exception. Make sure we get
> +		 * rid of all that, as this cannot be valid out of reset.
> +		 *
> +		 * Note that clearing the exception mask also clears PC
> +		 * updates, but that's an implementation detail, and we
> +		 * really want to make it explicit.
> +		 */
> +		vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
> +		vcpu_clear_flag(vcpu, EXCEPT_MASK);
> +		vcpu_clear_flag(vcpu, INCREMENT_PC);
>  		vcpu_set_reg(vcpu, 0, reset_state.r0);
>  	}
>  

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

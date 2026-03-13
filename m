Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7E03C345D
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 16:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773418580; cv=none; b=dlLhsAMg4FNELut3dQ4JiseG+NrsgRtnLF0dsiMBRpwxcVDbtfBBQ3yeL2n9KLtfgEDfmIpHAmC6nzZ+r+YhhD/iia8tjmSx5wrI1zR4md+fgFLkNwPaFgoTie8eOJxxLvRrvXSojFu/hZELYeH6oEy98papCqg73JhvosGTuVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773418580; c=relaxed/simple;
	bh=xpb+sAZZFW4cZzQqktbvtQyTfq7nsxB6lk9Mqo8D8Mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PHSi+YPu8JhomPs4ulBWf8N56LtiBvyeqrZNGssswRNyQ3muOPRsW5PpL8woBe3s6twrVH7yGkdVhB5Tq1HAD+ZmmvE/xvN6kBBTaSzDwP45q9RDaqunmICGN9NFXKWVzQokzRvAsWmEJpvVL6fl5abnuPoeUArJUMZnZ6RJSvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B102176A;
	Fri, 13 Mar 2026 09:16:11 -0700 (PDT)
Received: from [10.57.18.169] (unknown [10.57.18.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9780F3F7BD;
	Fri, 13 Mar 2026 09:16:16 -0700 (PDT)
Message-ID: <10f5de0b-1fdc-4867-8ccb-e9362fc553fe@arm.com>
Date: Fri, 13 Mar 2026 16:16:15 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Discard PC update state on vcpu reset
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
References: <20260312140850.822968-1-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260312140850.822968-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/03/2026 14:08, Marc Zyngier wrote:
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
>    normally executed), we annotate the vcpu as needing to skip the
>    next instruction, which is the SMC itself
> 
> - vcpu-A is now safely off
> 
> - vcpu-B issues a PSCI_CPU_ON for vcpu-A, providing a starting PC
> 
> - vcpu-A gets reset, get the new PC, and is sent on its merry way
> 
> - right at the point of entering the guest, we notice that a PC
>    increment is pending (remember the earlier SMC?)
> 
> - vcpu-A skips its first instruction...
> 
> What could possibly go wrong?
> 
> Well, I'm glad you asked. For pKVM as a NV guest, that first instruction
> is extremely significant, as it indicates whether the CPU is booting
> or resuming. Having skipped that instruction, nothing makes any sense
> anymore, and CPU hotplugging fails.
> 
> This is all caused by the decoupling of PC update from the handling
> of an exception that triggers such update, making it non-obvious
> what affects what when.
> 
> Fix this train wreck by discarding all the PC-affecting state on
> vcpu reset.
> 
> Fixes: f5e30680616ab ("KVM: arm64: Move __adjust_pc out of line")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>   arch/arm64/kvm/reset.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 959532422d3a3..b963fd975aaca 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -247,6 +247,20 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   			kvm_vcpu_set_be(vcpu);
>   
>   		*vcpu_pc(vcpu) = target_pc;
> +
> +		/*
> +		 * We may come from a state where either a PC update was
> +		 * pending (SMC call resulting in PC being increpented to
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
>   		vcpu_set_reg(vcpu, 0, reset_state.r0);
>   	}

Wow! Thats it finally !! Glad you found the root cause.


Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



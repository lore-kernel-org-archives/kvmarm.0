Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D6F3A1691
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 10:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801791; cv=none; b=ZeXmOGVYsLrce2ds+sowg4A8Pnqn3zj4F0TmCjJx9bvLc3v+65v5p7YJJYjVa9pMmie7X2z7vpfbXFLkkxlvtd5WjabQRsP0BemTyjZ9pVTGUCne0OPQ4SxupQGC4mmERccd3nL3iV5MaRwUs4+FLaKGaMwqs+7cRDfRsGFFm20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801791; c=relaxed/simple;
	bh=wxKPMgVdqQs8f3ozDud5AHV0AleLO9sbUs1KNlaMwiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EaN3hzIXDprhp/EkMsDYZxxhnFC4OIdW6voVWZIkP8IA+N00nhtonch+cPXaC/deELpOskTrvFtbU+LffxIDNKnZLmsqJoRDVKInhuYXcdVjTVdBX6F/TYINhrS/RZyu+CrmVJxQHBW1pRc1BUVz0Chk21BY+EXbw1uCz2GCFxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gqfBpIsa; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gqfBpIsa"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BEA71655;
	Mon, 12 Oct 2026 03:43:06 -0700 (PDT)
Received: from [10.0.128.125] (Suzukis-MBP.cambridge.arm.com [10.0.128.125])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 175983F66F;
	Mon, 12 Oct 2026 03:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791801789; bh=wxKPMgVdqQs8f3ozDud5AHV0AleLO9sbUs1KNlaMwiQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gqfBpIsa8MgxhW9DUlEvs4HuSOq3Vj7/vxqVW3nO3wnF2B+HjWPJ6oXZTBgfyn/R2
	 mfGbyF8+CHP4frwxGmu0lwXFW2J+p4VK7PAPRXawy9ua2Prfz+U+tW4046CzXkU+nw
	 3r7r6EmoQiV8x3+qM8/B3hoqQQJeySBeu4pB4d+A=
Message-ID: <b941a0c8-6d17-4a21-9eb7-30ad06bd6748@arm.com>
Date: Mon, 12 Oct 2026 11:43:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] KVM: arm64: Reject the GICv5 CPU interface
 hypercalls under pKVM
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, maz@kernel.org, oupton@kernel.org,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
 seiden@linux.ibm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
 vdonnefort@google.com, qperret@google.com, Sascha.Bischoff@arm.com,
 steven.price@arm.com, tabba@google.com
References: <20261011143648.211337-1-fuad.tabba@linux.dev>
 <20261011143648.211337-2-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261011143648.211337-2-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/2026 15:36, Fuad Tabba wrote:
> __vgic_v5_save_apr() and __vgic_v5_restore_vmcr_apr() remain callable
> once pKVM has finalised. pKVM never registers a GICv5 vgic, so neither
> has a valid caller in protected mode, and on a GICv3 machine both reach
> a register that is UNDEFINED at EL2 and panic the hypervisor.
> 
> Move both into the band the dispatcher rejects once pKVM has finalised.
> 
> Fixes: af325e87af5da ("KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_asm.h   | 4 ++--
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index e5b92ac09e69e..ea319c496bb26 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -62,6 +62,8 @@ enum __kvm_host_smccc_func {
>   	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
>   	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
>   	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
> +	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
> +	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
>   
>   	MARKER(__KVM_HOST_SMCCC_FUNC_MIN_PKVM),
>   

Any calls above are rejected after pKVM is initialized, so the calls are 
indeed rejected.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



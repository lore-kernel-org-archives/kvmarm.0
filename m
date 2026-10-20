Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792500348;
	b=z83I3ZYofUyQ6Q/G3tLQcfNOgElJYuQ59bFDBbkx6Sk/ZQDrAvTu4GHwS9uw1+sOLsKv
	 DoqxpX5oRptW1KqB+KcptQOfTwzsRd+uxs2FI2cjghuoxWkZoUYNiCrzuVjbDkbZOXhZq
	 CnhfjRbDgCdnx/YMQLtgjixi+hbzABqSoq9uRqkLLBvH8CgBZ9CbAXlMgLkHwQi2pLMh3
	 NehBNY20ir98F0ab+ROrQfvE+kGjGOvkUQX3jTqyf3f0EEUVluqdiClnDEoeXn0ffXAar
	 pRvGFO3FKkFB4nn9V3ahlhF9R0z4j9d9W99J9FBs6qszvLleQe8PYpE2jG83ZD9wzVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500348;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=xuei+CRi+YTC+w1w98cKTUkZqf74pwWNLSk3Y5bwTTw=;
	b=lfSPPRkxdpT0f01V+ka9mjZ/pYMIeUbbwQtl3u6RIXN8qCScMtoCAvP/+wYZsGS/4rb+
	 abFl7JyqjSF8oZL3vHVm9rP4nPc/9eHmvjybrH1LTGHKQY2i7ckzJWr2oZZ5S/FzeZDSj
	 wEAoqmtiqjf7fC2Bei/EJJG0tMHofgnA86LTHWMTtJC8G6q7v/ohXaEcW+efIRQCdQopw
	 7UjwfBEBcBZyAzMQzTVkreu/PBEG8W8GE75SmzyU1j5iC44nTsNvZuwgsxDbHeZxwII2k
	 bVUtTLVLc2cTEa5XSkUpQi8GdPAdbdBbODJBW/Gy3MDBWtD2AmazQrZ++IZcSzEvFow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="XK0/Ckz1";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE6B606A31A
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 12:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DE6B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XK0/Ckz1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 544C31596;
	Tue, 20 Oct 2026 05:45:43 -0700 (PDT)
Received: from [10.0.136.108] (M0PRX50XMG.cambridge.arm.com [10.0.136.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 739FB3F7D8;
	Tue, 20 Oct 2026 05:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792500346; bh=k/J+BLE6vPdQdmPvLoLHbEAnQDYiSHhsZ1irxSZ1S0c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XK0/Ckz10HfdOrQ2gW5EXmYrluTZNl1MEA6/Znp4ylSv0NXe7N7cfX7V6MYHngkzp
	 2K6qBeew0yi5eud1JcnMy7Wu+FNWywvpohQ70Fdg75XLJJCf88uq06G9vGkSbrYnp9
	 Co20daI7xoU1EBK2ytn+oVqt4ixIQUr++Hh7Kngg=
Message-ID: <36a94626-f760-4eb6-acf2-13c1ad128391@arm.com>
Date: Tue, 20 Oct 2026 13:45:43 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Decouple computation of the GICv5 trap
 registers from FEAT_FGT
To: Gustavo Romero <gromero@redhat.com>, kvmarm@lists.linux.dev,
 fuad.tabba@linux.dev
Cc: maz@kernel.org, oupton@kernel.org, eric.auger@redhat.com, seott@redhat.com
References: <20261020104138.2641586-1-gromero@redhat.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <20261020104138.2641586-1-gromero@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Gustavo,

On 20/10/2026 11:41, Gustavo Romero wrote:
> Currently, kvm_vcpu_load_fgt() returns early when the CPU lacks FEAT_FGT,
> so the per-vCPU ICH_HFGRTR_EL2, ICH_HFGWTR_EL2 and ICH_HFGITR_EL2 values
> are never computed and stay 0, meaning any access to several GICv5
> registers will trap, like an access to ICC_PPI_PRIORITYR0_EL1.

This is never a valid configuration for GICv5 on a system that has EL2, 
i.e., one that supports KVM.

* FEAT_GCIE (GICv5) is optional from v9.3.
* FEAT_FGT is mandatory from v8.6, if an implementation has EL2 or EL3.
* v9.1 must be v8.6 compliant.
* If we are running KVM, we must have EL2.

There's no way to legally have GICv5 without also having support for 
FEAT_FGT.

FWIW, Marc caught me making the same mistake:

https://lore.kernel.org/all/86o6o3oehl.wl-maz@kernel.org/

> 
> On the other hand, __activate_traps_ich_hfgxtr() is gated only on the
> GICv5 CPU interface and writes them on every guest entry, which is
> correct.
> 
> Returning early when the CPU lacks FEAT_FGT and leaving the GICv5 traps
> enabled can lead to a KVM "Unsupported guest access at" error when a
> GICv5 register access by the guest traps to KVM, because the register
> has no emulation handler.
> 
> A real machine with no FEAT_FGT and with GICv5 support enabled is
> unlikely to exist

Given the above, very unlikely. I hope... :)

> , but such a setup can happen on some simulators, like
> FVP with the following flags:
> 
> -C cluster0.has_arm_v8-5=1
> -C bp.is_gicv5_used=1

Even if the simulator allows it, it isn't a valid configuration. You 
want v9.3 or greater here. Moreover, we shouldn't be writing code to 
support architecturally invalid configurations.

Thanks,
Sascha

> 
> Hence, because the ICH trap registers are part of FEAT_GCIE, not part of
> FEAT_FGT, compute them before the FGT check, making this computation
> independent of FEAT_FGT.
> 
> Fixes: 9d6d9514c08f ("KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs")
> Signed-off-by: Gustavo Romero <gromero@redhat.com>
> ---
>   arch/arm64/kvm/config.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 1053676551af..8a526704af59 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1744,6 +1744,12 @@ static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
>   
>   void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>   {
> +	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> +		__compute_ich_hfgrtr(vcpu);
> +		__compute_ich_hfgwtr(vcpu);
> +		__compute_fgt(vcpu, ICH_HFGITR_EL2);
> +	}
> +
>   	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>   		return;
>   
> @@ -1761,10 +1767,4 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>   		__compute_fgt(vcpu, HDFGRTR2_EL2);
>   		__compute_fgt(vcpu, HDFGWTR2_EL2);
>   	}
> -
> -	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> -		__compute_ich_hfgrtr(vcpu);
> -		__compute_ich_hfgwtr(vcpu);
> -		__compute_fgt(vcpu, ICH_HFGITR_EL2);
> -	}
>   }

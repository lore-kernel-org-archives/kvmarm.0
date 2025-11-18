Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6A1280CE0
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 11:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763464290; cv=none; b=SurST6FLGk7kLw/JDnyhKI3nvEqn73rfP5rjojqEeTYkjnhdzBD1PFHHckE2tIjlB8puzXiObPLju5hovD1C98D+lHdyd3clYmWXOLisHPQU6nBvlAvbnzUxZWK4LO0pswSRwlXtvYQsTY4VjQ/BYOLWuaQ9CzattAuxVCCca1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763464290; c=relaxed/simple;
	bh=y0wYQAyznWUNd+atm01iGm5cUUY14HMyPyJY3h5+s7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O5Ns9/zyhhqsdyyYU/37QfnEwo20AYljDam4Bu6gZJFWhrGZsipf77figgv+wuDunbnLivp4gAQ3CVNRIcg1WfyIhHykZ/dAF3VtMnKp+4CLhtZo4Dkn78eddUWjDoV4M29ZhUAFA+issGX0DfPEjgpOF3mqQtVm3a0/jH1H9Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 912EB1007;
	Tue, 18 Nov 2025 03:11:20 -0800 (PST)
Received: from [10.57.73.50] (unknown [10.57.73.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CBB83F66E;
	Tue, 18 Nov 2025 03:11:26 -0800 (PST)
Message-ID: <3413a31a-6949-4a2c-95d0-97aa72823216@arm.com>
Date: Tue, 18 Nov 2025 11:11:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
Content-Language: en-GB
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
 joey.gouly@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 vladimir.murzin@arm.com
References: <20251118103807.707500-1-tabba@google.com>
 <20251118103807.707500-3-tabba@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251118103807.707500-3-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/11/2025 10:37, Fuad Tabba wrote:
> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
> register accesses. These accesses are trapped to EL2 when the bits are
> clear.
> 
> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
> had the polarity inverted. When a guest did not support the Trace Buffer
> feature, the code was setting E2TB. This incorrectly disabled the trap,
> potentially allowing a protected guest to access registers for a feature
> it was not given.
> 
> Fix this by inverting the operation.
> 
> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 8d06a246dfd1..f6f8996c4f97 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
>   		val |= MDCR_EL2_TTRF;
>   
>   	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
> -		val |= MDCR_EL2_E2TB_MASK;
> +		val &= ~MDCR_EL2_E2TB_MASK;

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



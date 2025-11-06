Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64F925C6F1
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446523; cv=none; b=VR3cXmuHM4tVZEapS3RHOWzy9phZ5T9H2bbycc5fg2TlWxsfBOPOTIy4h2zQn2YRlaq63iZvKrrbomnu/nyI6NAMeHr7w8MH4KMyNZYjFKExGx+aEJZuW2AKiu8xLl02IwOij+0upyQNUgL+rtcCIDvIBttEtZrg47qp5HH8+6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446523; c=relaxed/simple;
	bh=GroSsoGcsliztLd+3XfOdcZw68EFoP7bfoFNZmavBmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BG8TNMrmLzl6hBkGwVumhNmy0HXUvRIUer156Vg6p4RPy3QUk4lhBVrRbrK+HU1f0uUsFN2uDjounPV15dJDDwkkUBRRpa0t8IF2NjuxZ7hJPfZwscGuF8LFId6clccQ7+FD8fqB+aCYnSoi0+uTUwRtYHib6WMxxcjzeVks8f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70F561477;
	Thu,  6 Nov 2025 08:28:33 -0800 (PST)
Received: from [10.57.71.244] (unknown [10.57.71.244])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB0333F66E;
	Thu,  6 Nov 2025 08:28:39 -0800 (PST)
Message-ID: <48fc6886-be29-4c7f-a08a-a218bf9579b4@arm.com>
Date: Thu, 6 Nov 2025 16:28:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] KVM: arm64: Fix Trace Buffer trapping for
 protected VMs
Content-Language: en-GB
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
 joey.gouly@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 vladimir.murzin@arm.com
References: <20251106144418.2847443-1-tabba@google.com>
 <20251106144418.2847443-2-tabba@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251106144418.2847443-2-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/11/2025 14:44, Fuad Tabba wrote:
> For protected VMs in pKVM, the hypervisor should trap accesses to trace
> buffer system registers if Trace Buffer isn't supported by the VM.
> However, the current code only traps if Trace Buffer External Mode isn't
> supported.
> 
> Fix this by checking for FEAT_TRBE (Trace Buffer) rather than
> FEAT_TRBE_EXT.
> 
> Fixes: 9d5261269098 ("KVM: arm64: Trap external trace for protected VMs")
> Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 43bde061b65d..8d06a246dfd1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -117,7 +117,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
>   	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
>   		val |= MDCR_EL2_TTRF;
>   
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
> +	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
>   		val |= MDCR_EL2_E2TB_MASK;


Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B7BB2D3EC6
	for <kvmarm@lists.linux.dev>; Thu, 10 Jul 2025 08:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752137958; cv=none; b=jvny5uRCW58ec5TCPfg3UoEPxp4CaGPG5oJi1wucXg0SvrbuGpEQipH3Ig5mnjgIb41eq1kKrMqLrEggwWFHnbnNwHJqcRuxWPHkoNVN9lGGZnw8MrAnIz6sZgveCT9wQ/ZJ39PPI07DzSau1sFbiQM4nN4TvFfed83SUhfEYAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752137958; c=relaxed/simple;
	bh=GKq4R2GIY68yJTdyVLLiVkg5V4hq6epT7nk8903zHlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gXT8W8nAJHE+HThq1CvRVjArwZnpqCsRq8Hhmcas5Ani83zfp+M0PPoWSub4yrTvIhFZFdcLP/NavaHitu+fInz0NnoV4froAAmkigumazaZes13ixKNXnfJSJSnmhKBHFVoOS/9zbLyJa4Q7bJvvxZ63yRSlNk93Rsi2J7A+Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EF751EA6;
	Thu, 10 Jul 2025 01:59:05 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 943053F66E;
	Thu, 10 Jul 2025 01:59:15 -0700 (PDT)
Message-ID: <e421874a-322b-4da1-9fe9-f3a94e9036f5@arm.com>
Date: Thu, 10 Jul 2025 09:59:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] KVM: arm64: Disambiguate support for vSGIs v.
 vLPIs
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Zhou Wang <wangzhou1@hisilicon.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-2-oliver.upton@linux.dev>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250709211417.2074487-2-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 7/9/25 22:14, Oliver Upton wrote:
> vgic_supports_direct_msis() is a bit of a misnomer, as it returns true
> if either vSGIs or vLPIs are supported. Pick it apart into a few
> predicates and replace some open-coded checks for vSGIs.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
>   arch/arm64/kvm/vgic/vgic-mmio-v3.c | 16 ++++++++++------
>   arch/arm64/kvm/vgic/vgic-v4.c      |  4 ++--
>   arch/arm64/kvm/vgic/vgic.c         |  4 ++--
>   arch/arm64/kvm/vgic/vgic.h         |  7 +++++++
>   5 files changed, 23 insertions(+), 12 deletions(-)
> 
[snip]
>   		/* Dist stays enabled? nASSGIreq is RO */
> @@ -133,7 +137,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
>   		if (is_hwsgi != dist->nassgireq)
>   			vgic_v4_configure_vsgis(vcpu->kvm);
>   
> -		if (kvm_vgic_global_state.has_gicv4_1 &&
> +		if (vgic_supports_direct_sgis(vcpu->kvm) &&
>   		    was_enabled != dist->enabled)
>   			kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_RELOAD_GICv4);
>   		else if (!was_enabled && dist->enabled)
> @@ -178,7 +182,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
>   		}
>   	case GICD_CTLR:
>   		/* Not a GICv4.1? No HW SGIs */
> -		if (!kvm_vgic_global_state.has_gicv4_1)
> +		if (vgic_supports_direct_sgis(vcpu->kvm))
Missing negation.
>   			val &= ~GICD_CTLR_nASSGIreq;
>   
>   		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index 193946108192..e7e284d47a77 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
I note that the two further calls to vgic_supports_direct_msis() in this 
file look correct.
> @@ -356,7 +356,7 @@ int vgic_v4_put(struct kvm_vcpu *vcpu)
>   {
>   	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>   
> -	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
> +	if (!vgic_supports_direct_irqs(vcpu->kvm) || !vpe->resident)
>   		return 0;
>   
>   	return its_make_vpe_non_resident(vpe, vgic_v4_want_doorbell(vcpu));
> @@ -367,7 +367,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
>   	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>   	int err;
>   
> -	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
> +	if (!vgic_supports_direct_irqs(vcpu->kvm) || vpe->resident)
>   		return 0;
>   
>   	if (vcpu_get_flag(vcpu, IN_WFI))
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 8f8096d48925..f5148b38120a 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
[snip]

Thanks,

Ben


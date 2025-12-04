Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C471E2882BE
	for <kvmarm@lists.linux.dev>; Thu,  4 Dec 2025 10:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845485; cv=none; b=J/wQJAgn25XHL6UfWK0nXv/4pgqnsvLUPyImmu0ftZv4de6wv5MON8HYqEQ0itJV5SNbD9JM6T2/y+QQa3DcT/EMSK06pSfVMWlgPGJBrFXNHZg7MWVVee3iauEnETXyHlYEyOVSv6CI+Mb+Irbac1R6qHT4lLWmbKBE0+D0HGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845485; c=relaxed/simple;
	bh=9zBoHpSsXVZiwHMRXnfhwLIXCCnHzO+5ikF9YtUUDak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vgs3Fv0In6Ch+A9EuNRppAVhIcE+FSFFqHbssDKegAYXWuEOhBshHA4NaVyJV1jv6bRR+NJ1BEmTJMlo246NhSTHYaD+Bgw/QKEzug3MH+c7vAaAv3qTVL3aJWIhCjl1eALGq7dc3wf1DSy45S9fx/K9D9dsq9uQxkr9wz5mEn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E45B0339;
	Thu,  4 Dec 2025 02:51:14 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 061513F73B;
	Thu,  4 Dec 2025 02:51:20 -0800 (PST)
Message-ID: <7f853a85-f1da-4e6f-ab3f-63507731f8ee@arm.com>
Date: Thu, 4 Dec 2025 10:51:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] KVM: arm64: pkvm: Report optional ID register
 traps with a 0x18 syndrome
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-9-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251204094806.3846619-9-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 12/4/25 09:48, Marc Zyngier wrote:
> With FEAT_IDST, unimplemented system registers in the feature ID space
> must be reported using EC=0x18 at the closest handling EL, rather than
> with an UNDEF.
> 
> Most of these system registers are always implemented thanks to their
> dependency on FEAT_AA64, except for a set of (currently) three registers:
> GMID_EL1 (depending on MTE2), CCSIDR2_EL1 (depending on FEAT_CCIDX),
> and SMIDR_EL1 (depending on SME).
> 
> For these three registers, report their trap as EC=0x18 if they
> end-up trapping into KVM and that FEAT_IDST is implemented in the guest.
> Otherwise, just make them UNDEF.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 876b36d3d4788..efc36645f4b5a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -347,6 +347,18 @@ static bool pvm_gic_read_sre(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool pvm_idst_access(struct kvm_vcpu *vcpu,
> +			    struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, NI))
> +		inject_undef64(vcpu);
> +	else
> +		inject_sync64(vcpu, kvm_vcpu_get_esr(vcpu));
> +
> +	return false;
> +}
> +

Just wondering, why is the pkvm version register specific? You changed
the non-pkvm from register specific to generic.

>  /* Mark the specified system register as an AArch32 feature id register. */
>  #define AARCH32(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch32 }
>  
> @@ -472,6 +484,9 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
>  
>  	HOST_HANDLED(SYS_CCSIDR_EL1),
>  	HOST_HANDLED(SYS_CLIDR_EL1),
> +	{ SYS_DESC(SYS_CCSIDR2_EL1), .access = pvm_idst_access },
> +	{ SYS_DESC(SYS_GMID_EL1), .access = pvm_idst_access },
> +	{ SYS_DESC(SYS_SMIDR_EL1), .access = pvm_idst_access },
>  	HOST_HANDLED(SYS_AIDR_EL1),
>  	HOST_HANDLED(SYS_CSSELR_EL1),
>  	HOST_HANDLED(SYS_CTR_EL0),

Thanks,

Ben


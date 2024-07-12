Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E4813DDB9
	for <kvmarm@lists.linux.dev>; Fri, 12 Jul 2024 08:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720773640; cv=none; b=Z4WIcz6tyer0sX/2bKxhs3ic1pzIQi791wjI+k+N6NPAQtInpgttUYzPvoQaQio/A2EG5lqFpvaR41pdKETOxNm13/5VD8dTYqjDvJgz3sEVyCOYwn6vktZbWa7cUg/khiI+A4a7fAgixHlixEcFWsf3R3Vay/oPMlgtVsVq/oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720773640; c=relaxed/simple;
	bh=ltLjDfKdWvKKz9H6nMh77gNr8vD1HxpJwvrK6q/HV6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eW432GCDshdH0Dv+DVx5q/56fsgAtKhV/mRLWWfVPXSiy3Hn4sb5v867pzbDYnY7h1dqJd3v1ipcHta3CuV47YH/DzdCQ3CLekJk/3zx76LMczizDH0jlPj9Njjw0SOqLjmq5tM6BKGvtWc0HHb7Kla81bZDzjCSfiw8ip9mjD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CB931007;
	Fri, 12 Jul 2024 01:41:03 -0700 (PDT)
Received: from [10.162.16.42] (a077893.blr.arm.com [10.162.16.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8634B3F762;
	Fri, 12 Jul 2024 01:40:35 -0700 (PDT)
Message-ID: <e298568d-7b9a-4e01-95c1-ef98e1f50c82@arm.com>
Date: Fri, 12 Jul 2024 14:10:32 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] KVM: arm64: nv: Honor absence of FEAT_PAN2
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Joey Gouly <joey.gouly@arm.com>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240625133508.259829-5-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240625133508.259829-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 19:05, Marc Zyngier wrote:
> If our guest has been configured without PAN2, make sure that
> AT S1E1{R,W}P will generate an UNDEF.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 832c6733db307..06c39f191b5ec 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4585,6 +4585,10 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
>  						HFGITR_EL2_TLBIRVAAE1OS	|
>  						HFGITR_EL2_TLBIRVAE1OS);
>  
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
> +		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_ATS1E1RP |
> +						HFGITR_EL2_ATS1E1WP);
> +
>  	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
>  		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
>  						HFGxTR_EL2_nPIR_EL1);
As you had explained earlier about FGT UNDEF implementation, the above
code change makes sense.

FWIW

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A0B282F1
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 17:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741800017; cv=none; b=sjGyqn/V4QIwq3XNFq0nU8xIShnWuZ46iTbqDwJXfJfA3XxlZUT3jx2D814S0aWpvaaC0gr28Ng8zpaeM3fdEp9a88C2WDL9jP+xe/XNh0slAA7zJTsBGnzejSY7lJq2VzT0LEiJf0OtnJKgf9fYaXnaT3X7/EwfrGOvxG+UYCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741800017; c=relaxed/simple;
	bh=BgkmSmEqdAivThIbrZrYiT0kLf6v8P60d84U77VcbSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hdu9mrAzmxiqLXSPPPt1uEf32+Holgg08JzGLHRTyQDZGQBhLPI/21Q4IYoKJZeVN9HhcxWB546sqVcnWLqZKowsdz5oVr96zNR6QRuOa1+nbiFxUmwd2E8FjvVDL7yM1zBG+fjE7ryqeHDwlhrJ5Sw9bZFnwDlRkgEKeBjmqyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K9VX7JmH; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K9VX7JmH"
Date: Wed, 12 Mar 2025 10:20:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741800012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mOs7eQJLJCUGEFSay4U24A8ybWT+TL/OSie+j9EubR4=;
	b=K9VX7JmHz2x3px/JqTTXS6bOObpnE8iYmASgHZpf3YaLhlObaD2TuQ6CegwZRFbF1bPcsu
	zsfhYfG64gFgM94Jjm6QbVRfeDERlVdDlrZwDlfU8QJWPWAxySkVUdGzcVY7Vqq77Ibu56
	DwzXcJmp8MdTB6NrovutjeQmdpHOAEM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Writable TGRAN*_2
Message-ID: <Z9HCQ40LxShzL4nj@linux.dev>
References: <20250306184013.30008-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306184013.30008-1-sebott@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Sebastian,

On Thu, Mar 06, 2025 at 07:40:13PM +0100, Sebastian Ott wrote:
> Allow userspace to write the safe (NI) value for ID_AA64MMFR0_EL1.TGRAN*_2.
> Disallow to change these fields for NV since kvm provides a sanitized view
> for them based on the PAGE_SIZE.
> Also add these bits to the set_id_regs selftest.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>

I can't tell what you've based this patch on, it certainly doesn't apply
on a 6.14 rc. Consider telling git to include the base commit next time
you generate a patch.

> ---
>  arch/arm64/kvm/sys_regs.c                     | 21 +++++++++++++++----
>  .../testing/selftests/kvm/arm64/set_id_regs.c |  3 +++
>  2 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 14faf213d483..0730ed8314d0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1948,6 +1948,21 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
>  	return set_id_reg(vcpu, rd, user_val);
>  }
>  
> +static int set_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd, u64 user_val)
> +{
> +	u64 sanitized_val = kvm_read_sanitised_id_reg(vcpu, rd);
> +	u64 tgran2_mask = ID_AA64MMFR0_EL1_TGRAN4_2_MASK |
> +			  ID_AA64MMFR0_EL1_TGRAN16_2_MASK |
> +			  ID_AA64MMFR0_EL1_TGRAN64_2_MASK;
> +
> +	if (vcpu_has_nv(vcpu) &&
> +	    ((sanitized_val & tgran2_mask) != (user_val & tgran2_mask)))
> +		return -EINVAL;
> +
> +	return set_id_reg(vcpu, rd, user_val);
> +}
> +
>  static int set_id_aa64mmfr2_el1(struct kvm_vcpu *vcpu,
>  				const struct sys_reg_desc *rd, u64 user_val)
>  {
> @@ -2787,10 +2802,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	ID_UNALLOCATED(6,7),
>  
>  	/* CRm=7 */
> -	ID_WRITABLE(ID_AA64MMFR0_EL1, ~(ID_AA64MMFR0_EL1_RES0 |
> -					ID_AA64MMFR0_EL1_TGRAN4_2 |
> -					ID_AA64MMFR0_EL1_TGRAN64_2 |
> -					ID_AA64MMFR0_EL1_TGRAN16_2 |
> +	ID_FILTERED(ID_AA64MMFR0_EL1, id_aa64mmfr0_el1,
> +				      ~(ID_AA64MMFR0_EL1_RES0 |
>  					ID_AA64MMFR0_EL1_ASIDBITS)),
>  	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
>  					ID_AA64MMFR1_EL1_HCX |
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index 1d65f4a09e6f..322b9d3b0125 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -146,6 +146,9 @@ static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
>  static const struct reg_ftr_bits ftr_id_aa64mmfr0_el1[] = {
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, ECV, 0),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, EXS, 0),
> +	REG_FTR_BITS(FTR_EXACT, ID_AA64MMFR0_EL1, TGRAN4_2, 1),
> +	REG_FTR_BITS(FTR_EXACT, ID_AA64MMFR0_EL1, TGRAN64_2, 1),
> +	REG_FTR_BITS(FTR_EXACT, ID_AA64MMFR0_EL1, TGRAN16_2, 1),
>  	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, TGRAN4, 0),
>  	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, TGRAN64, 0),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, TGRAN16, 0),

Please do selftests changes in a separate patch.

Don't worry about respinning, I'll fix this up and queue it in a moment.

Thanks,
Oliver

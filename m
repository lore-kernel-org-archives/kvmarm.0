Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C406ADD
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501867; cv=none; b=ZUnMFXtH1Krded/RdSuNpVe5hlSbdVQiMJMZ4+IdQtdE4DqaatbfpIAH60N9+CJMHqGlandSWFbikPwKxw6FN9tBY+2FllKIMIErydGTTpf2MssBOQCnY9ZDLCviFsslU3ZDgkem3/SrCu58Igql7X3+L+n+gcmPaR2aL65MHSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501867; c=relaxed/simple;
	bh=ItwQQinzoy1k9xRaJDcDyAfhcb+Qxxt685cUb9oSdMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXxWzY91DopJ82p8qH707Amqg8LXz1BQeuDLmn3B8A80nGZp49pogEKXOoZystaTA/R6nbqD7LpC1p/mp9vbXMuwFPb6+enxpDuTFPZnp5PPo7VjlbxOdy6fzld8HG+LuyE102jlZs2uIGBIVhdv075yJUm/fiYAb47l9yyjHp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OsFNdeLe; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OsFNdeLe"
Date: Wed, 6 Aug 2025 10:37:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754501862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Ds8ZTCnuuJX8YoiEXe67S5tyk4cccTW3kTX4rJWKqc=;
	b=OsFNdeLeDvZyIFiiB1P4x4mWtoQy5vL5ZWA2tYr/zzJpw2Mrs7Cza1OvWrHba5WqdpThxY
	ZJkFFBys3aoF1VbW3jltvWSIZw8COfKcGBhuwLT5bC5+pnuoitfF0MIV6t4ADdf2E8EfgB
	9XgTfpziVOpPqpPoi8bypZ12rtBJyYA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 1/2] KVM: arm64: nv: fix S2 translation for nVHE guests
Message-ID: <aJOS3oOwUWeRLS4j@linux.dev>
References: <20250806141707.3479194-1-volodymyr_babchuk@epam.com>
 <20250806141707.3479194-2-volodymyr_babchuk@epam.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806141707.3479194-2-volodymyr_babchuk@epam.com>
X-Migadu-Flow: FLOW_OUT

Hi Volodymyr,

Thanks for catching this.

On Wed, Aug 06, 2025 at 02:17:55PM +0000, Volodymyr Babchuk wrote:
> According to ARM architecture specification (ARM DDI 0487 L.a, section
> C5.4.3), Stage 2 translation should be skipped when VHE is active, or,
> in other words, E2H bit is set. Fix the code by inverting both check
> and comment.
> 
> Signed-off-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
> ---
>  arch/arm64/kvm/at.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index a25be111cd8f8..5e7c3fb01273c 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1412,10 +1412,10 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  		return;
>  
>  	/*
> -	 * If we only have a single stage of translation (E2H=0 or
> +	 * If we only have a single stage of translation (E2H=1 or
>  	 * TGE=1), exit early. Same thing if {VM,DC}=={0,0}.
>  	 */
> -	if (!vcpu_el2_e2h_is_set(vcpu) || vcpu_el2_tge_is_set(vcpu) ||
> +	if (vcpu_el2_e2h_is_set(vcpu) || vcpu_el2_tge_is_set(vcpu) ||

The check should be HCR_EL2.<E2H,TGE> == '11'. Maybe instead:

	/*
	 * Exit early if we only have a single stage of translation
	 * either because we're in the EL2&0 translation regime or
	 * stage-2 translation is disabled (i.e. HCR_EL2.{VM,DC}=={0,0}).
	 */
	 if (compute_translation_regime(vcpu, op) == TR_EL20 ||
	     !(vcpu_read_sys_reg(vcpu, HCR_EL2) & (HCR_VM | HCR_DC)))
	     return;

Thanks,
Oliver

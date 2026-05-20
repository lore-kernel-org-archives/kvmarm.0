Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0441F5437
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 13:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779285285; cv=none; b=qCAABpb2PcQaE84huZfZU2Hfx9QAIgcmjNBnBWpA06cz/acLxZfxQjA/ZOfJ4EuQQY1OGDJikTLoHrFQEXS6DljEpFhVKnA0MBdbV0fpNe9A3jagE4pk84xTDfRGewENpgFfu4ZLSkGOG/YX2Y+OEq4ovbs+O7K5CE6voV4Uz3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779285285; c=relaxed/simple;
	bh=/RmDA6+Bl7H/V0dVFxBbUuFNuutxEkFoHlUy6TU9LOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzYawHn7eB42WLSy2xFd/vbR3FV3zcBxAJpESR9OO4ArQBSGVi0bDA9HqSq4NYH/qZXEU5xE1I5JmbOR/qHz/7CKTojTWvCXfTtbCCoSTEPMLnEeAUEXftrIn3umNXSw/tRZd5eyBCqSnQfzNnax/5MRCpjw77KvkyPISk1Oouo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DCUht/4z; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DCUht/4z"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE58028C7;
	Wed, 20 May 2026 06:54:37 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF3413F632;
	Wed, 20 May 2026 06:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779285282; bh=/RmDA6+Bl7H/V0dVFxBbUuFNuutxEkFoHlUy6TU9LOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DCUht/4z8YOxEl7qvK/IkpWfUlEHN+FDmEpu2UGWV3eBWkKCIKwXVn6ZI9q3ZHQNt
	 Tby0Ncxg05qzRlWKmw6gamgpJyj9mASdHwSgKWHWQeEDPKv9UFdPt80us3oL8UkjHH
	 aNtwH7fc9o8/zp/KwnYau84O3qcZEfeaewFYc/W4=
Date: Wed, 20 May 2026 14:54:39 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH v2 10/18] KVM: arm64: vgic-v5: Add missing trap handing
 for NV triage
Message-ID: <20260520135439.GB4027812@e124191.cambridge.arm.com>
References: <20260520091949.542365-1-maz@kernel.org>
 <20260520091949.542365-11-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520091949.542365-11-maz@kernel.org>

On Wed, May 20, 2026 at 10:19:41AM +0100, Marc Zyngier wrote:
> From: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> As things stand, there is no support for Nested Virt with GICv5 guests
> yet. However, this is coming and therefore we need to be able to
> correctly triage the traps when running with NV.
> 
> Add the missing fgtreg lookups required for that to
> triage_sysreg_trap(). These are specific to the FGT regs added as part
> of GICv5:
>    * ICH_HFGRTR_EL2
>    * ICH_HFGWTR_EL2
>    * ICH_HFGITR_EL2
> 
> Fixes: 9d6d9514c08f "(KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs")
> Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/emulate-nested.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index dba7ced74ca5e..a4eb36b4c4421 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2631,6 +2631,14 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  		fgtreg = HFGITR2_EL2;
>  		break;
>  
> +	case ICH_HFGRTR_GROUP:
> +		fgtreg = is_read ? ICH_HFGRTR_EL2 : ICH_HFGWTR_EL2;
> +		break;
> +
> +	case ICH_HFGITR_GROUP:
> +		fgtreg = ICH_HFGITR_EL2;
> +		break;
> +
>  	default:
>  		/* Something is really wrong, bail out */
>  		WARN_ONCE(1, "Bad FGT group (encoding %08x, config %016llx)\n",
> -- 
> 2.47.3
> 

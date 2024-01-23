Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05FC45FDB0
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 14:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706019280; cv=none; b=oU36kdqki6GDNYZWfsOC4UOUQIB4Ivd1sDchh1RSoPZk1RWRrmDTBQqncOYrl+GRDqBokWTdEzGaK7VnyBWFH1mB7Rk4/aSwKHT/2xy5JukCLm4JKeGQHrQZByfgsZ/H/abuzetFQxRLqu7Irg1fVbINRFpOlEHyrVjVbmlGhBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706019280; c=relaxed/simple;
	bh=f9hoS1PpExE8ZVUKILvQurqEa7mcZ6N17XhXSz/+cLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qq6zbMxJEmMSfMPKcX/iTaW5v0xh0KQB1wbGnZTcb1YROBSLjZX0R2UadXIKYciwpICRwLnMYU0XZJl75EsTwokPiZy/NTFKMP7LHOovbini6/KfDfZJ95hRuIRz0OT21IvOfabUYlBkT6IEsncYz5xXX8hScCDgFltyDCIixkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9AD81FB;
	Tue, 23 Jan 2024 06:15:22 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B0823F762;
	Tue, 23 Jan 2024 06:14:36 -0800 (PST)
Date: Tue, 23 Jan 2024 14:14:33 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 08/25] KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
Message-ID: <20240123141433.GD1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-9-maz@kernel.org>

Hi,

On Mon, Jan 22, 2024 at 08:18:35PM +0000, Marc Zyngier wrote:
> There is no reason to have separate FGT group identifiers for
> the debug fine grain trapping. The sole requirement is to provide
> the *names* so that the SR_FGF() macro can do its magic of picking
> the correct bit definition.
> 
> So let's alias HDFGWTR_GROUP and HDFGRTR_GROUP.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 7a4a886adb9d..8a1cfcf553a2 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -1010,7 +1010,7 @@ enum fgt_group_id {
>  	__NO_FGT_GROUP__,
>  	HFGxTR_GROUP,
>  	HDFGRTR_GROUP,
> -	HDFGWTR_GROUP,
> +	HDFGWTR_GROUP = HDFGRTR_GROUP,
>  	HFGITR_GROUP,
>  	HAFGRTR_GROUP,
>  
> @@ -1938,7 +1938,6 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  		break;
>  
>  	case HDFGRTR_GROUP:
> -	case HDFGWTR_GROUP:
>  		if (is_read)
>  			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
>  		else

I guess you could rename it to HDFGxTR_GROUP like for HFGxTR_GROUP but that
means changing all those tables, so I think it's fine.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

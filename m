Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CE920110A
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 07:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728546667; cv=none; b=ejVRo55uzqRH60fAfJJCFfLH0NZosZY4Fc2HQ6wLtiaxzHJH/cI3Ux0NkezEGDO7tquPYBnUfkkwnlE5E+bEkrsa5IEH1I/sXm1gQYWzS16dBE6UPtkY7ijr3GJpnk75bxyUVrdz6syhQB85wvTsuLh5F7nU3d7zzpK8yakhf1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728546667; c=relaxed/simple;
	bh=uWStj+xilcv9N3dioWNYj7e75BdSNr2PhR0d2cGpAts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDS6a/DeG07xLO5tNUcIAlND7tbd3kBkNwTiS2sHbUPwpo9jZSjBh2DkhVwesZE9/whEKtMme3K67f4VEI5StVUeHzMX+YDrkHbWMMcuA4f6vZZFlq6WIo6FST1glf0qvBciOoZHlclaea4nEHF4KY4DLMtyErHKGf0N5IywbTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QA9sA4Tb; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QA9sA4Tb"
Date: Thu, 10 Oct 2024 00:50:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728546660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n9ENzHg7tPYpJtE43PefYJwyU05UEoBmVVMbi+fFu3o=;
	b=QA9sA4TbDGSie23xU+ntyEWDGUOLiEwOX3TkWQYWCbFKYsmJmdpKWBYZYLvyRymvlauJG+
	LedOFexrTPRxdSlRldpf1A5Q29PMCM4vnNrjnVzPBCSKl+Ooq5s9jnBuPqfyQRQXcAc1Bd
	thdOH+OIX1WMpZV1l2oz3boZKN2PwOM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 23/36] KVM: arm64: Hide TCR2_EL1 from userspace when
 disabled for guests
Message-ID: <ZweHXW2lUMmFLw5h@linux.dev>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-24-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-24-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 08:00:06PM +0100, Marc Zyngier wrote:
> From: Mark Brown <broonie@kernel.org>
> 
> When the guest does not support FEAT_TCR2 we should not allow any access
> to it in order to ensure that we do not create spurious issues with guest
> migration. Add a visibility operation for it.

This should come at the beginning of ths series (same for the subsequent
S1PIE patch) so the EL2 registers use the correct visibility filtering
from the start.

> Fixes: fbff56068232 ("KVM: arm64: Save/restore TCR2_EL1")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Link: https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-2-376624fa829c@kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/sys_regs.c         | 29 ++++++++++++++++++++++++++---
>  2 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1a5477181447c..197a7a08b3af5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1511,4 +1511,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>  	(system_supports_fpmr() &&			\
>  	 kvm_has_feat((k), ID_AA64PFR2_EL1, FPMR, IMP))
>  
> +#define kvm_has_tcr2(k)				\
> +	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))
> +

nit: we should consistently use this predicate if we want to keep it.

-- 
Thanks,
Oliver

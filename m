Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79C91BD503
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 07:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728546826; cv=none; b=i4zhGe/2wMytuoqhDWQGa2H40LCuBb0cnY8muaNqx/cNpEZjoDWU7NeQMU1f8BDgIoejIRzlO7M2/LhXl6JGZYL2Jru3at8P4W/tiHEAxXgYG5PI5iRDgJw9EivG9OFGJzGJTbJaNT91NeRTOOzs9NffeBeUPpA2Eh1w0VfQdo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728546826; c=relaxed/simple;
	bh=wTkZRZ/vbNluKyAk2HTagc3gkd1h6vnz+dDGfdwi9Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYPBxaBdLKuqUlTJFinLtgbcaBXGLgEpchN+an8tkMSlKQcAj3M4QWuW4PyW0Rjk/sXXmfPUS9hhbYBYVK/nRk5Oc/sZ+RK2yWDI5byyC0YJIdB/i89EQBJ6C+Fs3LOUhcRn8Db4ru+dDoUobK8mMP1G0QfVY8O84EHA/Zvn+vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cliKSiQI; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cliKSiQI"
Date: Thu, 10 Oct 2024 00:53:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728546822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uvex2072kSqEXNvE9lc55fHy7VD5yiL1TNOcRVGLrdk=;
	b=cliKSiQIhdo0vIMUoaxCLuMUMwCsh0utwm22gQ2gvmB01/UGczP+qim9dadB6EsGb3Lziz
	sAuNCCp4mOIvC23XAcpZYz9A9zqvUX4wakcr79NwK7ZNl6QCE9wqqWpVeNkaz9y5PSkv1i
	83Y36CReuYULHpKzq0oh0D10uKzWvhc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 29/36] KVM: arm64: Subject S1PIE/S1POE registers to
 HCR_EL2.{TVM,TRVM}
Message-ID: <ZweH_1KQlQEc9tUY@linux.dev>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-30-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-30-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 08:00:12PM +0100, Marc Zyngier wrote:
> All the El0/EL1 S1PIE/S1POE system register are caught by the HCR_EL2
> TCM and TRVM bits. Reflect this in the coarse grained trap table.

typo: TVM

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index ddcbaa983de36..0ab0905533545 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -704,6 +704,10 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
>  	SR_TRAP(SYS_MAIR_EL1,		CGT_HCR_TVM_TRVM),
>  	SR_TRAP(SYS_AMAIR_EL1,		CGT_HCR_TVM_TRVM),
>  	SR_TRAP(SYS_CONTEXTIDR_EL1,	CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_PIR_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_PIRE0_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_POR_EL0,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_POR_EL1,		CGT_HCR_TVM_TRVM),
>  	SR_TRAP(SYS_TCR2_EL1,		CGT_HCR_TVM_TRVM_HCRX_TCR2En),
>  	SR_TRAP(SYS_DC_ZVA,		CGT_HCR_TDZ),
>  	SR_TRAP(SYS_DC_GVA,		CGT_HCR_TDZ),
> -- 
> 2.39.2
> 

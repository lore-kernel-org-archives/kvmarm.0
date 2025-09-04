Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4B72BEFF8
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 07:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756972781; cv=none; b=RZtov0VbRid82G2gD3i2xfPsmev+ThU2rswue3HrCjNGmLqVPOBkhtmQH7msfnt+Hr4+vJGz3eEGjUeu8i13nH62nfSEnW914l6cjXwH1ZVK2Rz5m2Lbwy60XmaI1AeSnizZNeFl8kiE+q/KO6EBgqQscO41dB+0tKMoG7Bofbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756972781; c=relaxed/simple;
	bh=JSSolZeE+sq56IqPPyCnsMoKgTpLyB65r6cJ7mkshKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3oiNoj9zm+uaFi6Ik6kWpGVgw9fprCwtYnYEL6sJ+PNYgk+s7qjhSwqeGQ5jRjpQe7Rh2GwIlftJh/sKrPWrmOV4PNWe56SQLBV952U5f75YB5f95wzBCB8MwRk8B8falPgcNR/mVfc6DbpxGymSgIfui7fJpf/rDekzmx5PO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jmZk3j5d; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jmZk3j5d"
Date: Wed, 3 Sep 2025 23:55:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756972777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4EghQiz4fNiRlJcfHUyDaJ9colM5Al8GK6C22CPulc8=;
	b=jmZk3j5d2GrS8ZZp0HJVIXAZU3gPfu+kv2H8ziDQYobWptCllCEC1sbizguIYhV08h9vUW
	7rgI1rW7GbmYGW6tIKtgy1veeuNqesfJlKRlfV2Kx8RdKCF37tgQzhpT5s8DWwc0JIcahp
	8ciyoUk/UmV3Q+XyZHFn7B4wiBWfU2A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: VHE: Initialize PMSCR_EL1
Message-ID: <aLk3xLd8ylxP63hH@linux.dev>
References: <20250902130833.338216-1-alexandru.elisei@arm.com>
 <20250902130833.338216-2-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902130833.338216-2-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 02, 2025 at 02:08:32PM +0100, Alexandru Elisei wrote:
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 381382c19fe4..e7ce0d5a622d 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -74,13 +74,19 @@ void kvm_init_host_debug_data(void)
>  	*host_data_ptr(debug_brps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
>  	*host_data_ptr(debug_wrps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
>  
> +	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
> +	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P)) {
> +		if (has_vhe()) {
> +			/* Clear E{0,1}SPE, which reset to UNKNOWN values. */
> +			write_sysreg_el1(0, SYS_PMSCR);
> +		} else {
> +			host_data_set_flag(HAS_SPE);
> +		}
> +	}
> +

nit: While this is correct, from a code organization perspective it
doesn't belong here. The rest of this function is concerned with probing
hardware state and initializing the corresponding host data.

I prefer Marc's suggestion which could be wrapped up in a function called
'kvm_debug_init_vhe()' or similar.

Thanks,
Oliver

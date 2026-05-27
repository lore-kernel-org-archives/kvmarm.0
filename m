Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C363254A8;
	Wed, 27 May 2026 18:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779908162; cv=none; b=uJkQxJ5i504clKGL6y5ycaAHv+AiTjeu5KEWPNqG0Mb3slCdRa1L7y5DkD+Er06rYlG3WnYklfeQoe0ISshY1bqJXL0gTRXTgwE8MB0c9WFPejGwv+ErmxJKlUWyga/6Zd5aVP2nOHxq90Zlv4mN7T4/n0wcUmF8GjIOZaH2Eiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779908162; c=relaxed/simple;
	bh=P2+6W9UmUo/Zi9QFAGg+h1wefmR0kkt/vhLPG3MBoOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oJTlOEI2ehr+9IwyVs3gO8L3ZyarVOBHqcWlHbmWCme6yrEnWaORMBatAK4J+O0K3XpSn6iVH9eI2I9Xm+T6FVS15URdE/aHHYnVmQybunpdxBOhsnXSV5J3JpOgDnuz8vPTSkVkPAmgyRhH3yiOQPmfNj8ZjDw42Nlxye2zX2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dP6ly0G9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dP6ly0G9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C151A1F000E9;
	Wed, 27 May 2026 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779908161;
	bh=liULdT5hPG3Hs3MVsuBYqbmNhVl/Zh1MhxhFa73l698=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dP6ly0G9qXtPakMjOJ5zrOUCUfpqM9+qBvvNugELgTNwDZhk9vDhIXM3lkgvo64H1
	 vPO5lINGavUCUdfxIqR2GD7X5PvkjsCV/EyeHVCW6mTXOmkyNZe9ln9cQRWx5Bqzhl
	 J5hopodkj4fUjifJUtiLdkceAghSStOLmdZVl0/jmdsaUXJ6MV+uLg92bzmN8+XVQT
	 dSj4f6Nw/y+FjXQJ7ir+dcMde2lKGmROBUf81E0X5hCDj9lxZvy8OCv65o2XmNcsCq
	 aS7KRB4rNvFcISCxQAyzpWi0j6jwYlh+N3UvYf2Sq6K7+ZVHLHPtmY3NK9XEtXAk1P
	 En+j8KLCuIelg==
Date: Thu, 28 May 2026 00:25:56 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, catalin.marinas@arm.com,
	jens.wiklander@linaro.org, sebastianene@google.com,
	vdonnefort@google.com, sudeep.holla@kernel.org
Subject: Re: [PATCH v6 1/6] optee: ffa: Add NULL check in
 optee_ffa_lend_protmem
Message-ID: <ahc-PMwAbFfo-4Q8@sumit-xelite>
References: <20260527150236.1978655-1-smostafa@google.com>
 <20260527150236.1978655-2-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527150236.1978655-2-smostafa@google.com>

On Wed, May 27, 2026 at 03:02:31PM +0000, Mostafa Saleh wrote:
> Sashiko (locally) reports a possible null dereference under memory
> pressure due to the lack of validation of the allocated pointer.
> 
> Fix that by adding the missing check.
> 
> Fixes: 2b78d79cdf96 ("optee: FF-A: dynamic protected memory allocation")
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/tee/optee/ffa_abi.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

-Sumit

> 
> diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
> index b4372fa268d0..633715b98625 100644
> --- a/drivers/tee/optee/ffa_abi.c
> +++ b/drivers/tee/optee/ffa_abi.c
> @@ -698,6 +698,9 @@ static int optee_ffa_lend_protmem(struct optee *optee, struct tee_shm *protmem,
>  	int rc;
>  
>  	mem_attr = kzalloc_objs(*mem_attr, ma_count);
> +	if (!mem_attr)
> +		return -ENOMEM;
> +
>  	for (n = 0; n < ma_count; n++) {
>  		mem_attr[n].receiver = mem_attrs[n] & U16_MAX;
>  		mem_attr[n].attrs = mem_attrs[n] >> 16;
> -- 
> 2.54.0.746.g67dd491aae-goog
> 

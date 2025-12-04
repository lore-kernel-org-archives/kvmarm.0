Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975832882DE
	for <kvmarm@lists.linux.dev>; Thu,  4 Dec 2025 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764868659; cv=none; b=G/il3rPde7yXiMXYL5Bn7omR8ERIviCMQbPwICLuJ8+MAB1Pt+gp03j5Ay91sij18wV0JDq4IpKYrCt51jUkbweRPYlauq28aZ/siFWQ7fun6ICmDNEjCiee3IUw+AWUfibgDohqmljnDs5UoE0Blid7mbdkRjuxe+Y4jFTVS+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764868659; c=relaxed/simple;
	bh=a8JURBPSJ8uIDGog29g8ltCK4xdKqpe1NmYZANWC3B0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kj6ANDxt7pZDonwk4Wyx/7OUQyAJVsunEkCZCwf96x0HVtfY7iR7ewv9nppXiuk2VnHknrbZ+3aGUCMlC5pNeHbIi/0DyzkLj1HJ8kW5yDbjNw+dQ1gk+j4E5uG8Dj769f37m+fNTJmHJ8czSo59htzbk++Bw6q/4DZRyRaPxbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BgxrN3fx; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BgxrN3fx"
Date: Thu, 4 Dec 2025 11:17:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764868654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XC1sbM4opFUgAlcAOyxkNmruPBxhfUkhy9p4bBsCMtw=;
	b=BgxrN3fxl/NF0UJOQlThiutyY6bZF08yz9HvdKsaRB8nuZWyNR0U4T6PlK5AZHLahBLfLU
	bsKMRAz4BCYzWqVOzm1K39OuOvdg28DM8+DvT4bzyl67pYweTJ+Es4hxl4BKolZMAUNqyd
	k7V71Z5D+Xp1uMhpPpsZPQQA/ARvcfI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v4 11/11] arm64: add EL2 environment
 variable
Message-ID: <20251204-203dfc57adef00b4f6fdf910@orel>
References: <20251204142338.132483-1-joey.gouly@arm.com>
 <20251204142338.132483-12-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204142338.132483-12-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 04, 2025 at 02:23:38PM +0000, Joey Gouly wrote:
> This variable when set to y/Y will cause QEMU/kvmtool to start at EL2.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/run | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arm/run b/arm/run
> index 858333fc..dd641772 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -59,6 +59,10 @@ function arch_run_qemu()
>  		M+=",highmem=off"
>  	fi
>  
> +	if [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then

I wanted to keep '1' and also add 'y' and 'Y'. We already allow those
three (and only those three) in other places, see errata().

Thanks,
drew

> +		M+=",virtualization=on"
> +	fi
> +
>  	if ! $qemu $M -device '?' | grep -q virtconsole; then
>  		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
>  		exit 2
> @@ -116,6 +120,9 @@ function arch_run_kvmtool()
>  	fi
>  
>  	command="$(timeout_cmd) $kvmtool run"
> +	if [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
> +		command+=" --nested"
> +	fi
>  	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
>  		run_test_status $command --kernel "$@" --aarch32
>  	else
> -- 
> 2.25.1
> 

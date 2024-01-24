Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 144127C0AF
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706113525; cv=none; b=E9N6Bf6hvB6ydPDkB8iJLP91iYRREaIkMuSgN6EMD5f1/imU3zW6hJ6uqztO6xn9pxFM3dd/wsTFBlWhxWMiAO3JUePHmjqAy68jxOfVkj+Xn8KskAGkxExDqlISg6XezMbjcFWvveb9NGFWb+tOxNfwwBQKK9VU/FzP5XvFxx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706113525; c=relaxed/simple;
	bh=VORfUB/vnexUDkBwBG9BqkwRQkb0fN/5/lLrrguM3lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnU4S0od5tAW4Ve3/P8j82csBZqbWhuDUjVvU1b1h+O1SmcFkT8kGy1XcW+Gi0IidW2CpHJaBV76NAtp8coGbbRCFAxgx8HjDMXD3Lj94ts8J1ezpnjeGaZ8SZrIo0ijsOmFBWVqvmBlwGNPxA+2G/bkG6PP6yxXFHGJH+5i6IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 626581FB;
	Wed, 24 Jan 2024 08:26:08 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 194C03F762;
	Wed, 24 Jan 2024 08:25:21 -0800 (PST)
Date: Wed, 24 Jan 2024 16:25:19 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 13/25] KVM: arm64: Always populate the trap configuration
 xarray
Message-ID: <20240124162519.GI1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-14-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-14-maz@kernel.org>

On Mon, Jan 22, 2024 at 08:18:40PM +0000, Marc Zyngier wrote:
> As we are going to rely more and more on the global xarray that
> contains the trap configuration, always populate it, even in the
> non-NV case.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 501de653beb5..77cd818c23b0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3997,8 +3997,5 @@ int __init kvm_sys_reg_table_init(void)
>  	if (!first_idreg)
>  		return -EINVAL;
>  
> -	if (kvm_get_mode() == KVM_MODE_NV)
> -		return populate_nv_trap_config();
> -
> -	return 0;
> +	return populate_nv_trap_config();
>  }

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

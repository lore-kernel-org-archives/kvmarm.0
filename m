Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008F82C324C
	for <kvmarm@lists.linux.dev>; Tue, 12 Aug 2025 20:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755030225; cv=none; b=eKf78uR1sfwWvzdASiyIHDJ0Fj5iCjJZr9JPvmqNPIymR/gOoorTjFxogCHmztktya/V/QiUM0j174ExbIkZiDsXRvwWYCo10ADldRj4zqngdfNqvfV6WR0Kkqe0GQXCt3hmu/jE/GrEgk3cCJs4uhJ/fmfFp8ReNbZXdNWAI7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755030225; c=relaxed/simple;
	bh=k5QHTsV5iHCWb13OOgut1Pzojt8eXPSw86LNEfbERlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yr4XdmnuuiZvpED0j4RMxKISY6mq7ejF9aQNlcs2u/AW6xqt0/CwNiBSghlWEsvVgQshwbBvXAHZPxwmVZkHPz13uEY7WMHS/il/sBwS4YGrtEGDkHuib3VpdNTJ3HvZmUGKb17Oo+B977/GCHN9RU5A8fTOM2ffgzw6lIrroJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DvGpu18S; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DvGpu18S"
Date: Tue, 12 Aug 2025 13:23:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755030221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dX2j6jftY29+KqweHY3PNwIJjp/qX5H2Xz/6o7CjN9A=;
	b=DvGpu18So3vkJyOQpg+tmeRHcr48tG/vyY1KhUQykdF3gbmyFffjVYlwFxqfZlVDQTeWD1
	95RC24rxOwiA2fGc7eYeNy910rqsW2vFNkYz8I3PafN3NrevVvqht97maiJUDgkPjxuP8R
	Q48yWTa0hneV16oFYLk5CKNOW+tDNtI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Fix vcpu_{read,write}_sys_reg() accessors
Message-ID: <aJuixWlc87f2UlK0@linux.dev>
References: <20250809144811.2314038-1-maz@kernel.org>
 <20250809144811.2314038-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250809144811.2314038-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 09, 2025 at 03:48:11PM +0100, Marc Zyngier wrote:
> @@ -144,125 +156,120 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
>  		MAPPED_EL2_SYSREG(ZCR_EL2,     ZCR_EL1,     NULL	     );
>  		MAPPED_EL2_SYSREG(CONTEXTIDR_EL2, CONTEXTIDR_EL1, NULL	     );
>  		MAPPED_EL2_SYSREG(SCTLR2_EL2,  SCTLR2_EL1,  NULL	     );
> +	case CNTHCTL_EL2:
> +		/* CNTHCTL_EL2 is super special, until we support NV2.1 */
> +		loc->loc = ((is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu)) ?
> +			    SR_LOC_SPECIAL : SR_LOC_MEMORY);
> +		break;
> +	case TPIDR_EL0:
> +	case TPIDRRO_EL0:
> +	case TPIDR_EL1:
> +	case PAR_EL1:
> +		/* These registers are always loaded, no matter what */
> +		loc->loc = SR_LOC_LOADED;
> +		break;
>  	default:
> -		return false;
> +		/*
> +		 * Non-mapped EL2 registers are by definition in memory, but
> +		 * we don't need to distinguish them here, as the CPU
> +		 * register accessors will bail out and we'll end-up using
> +		 * the backing store.
> +		 *
> +		 * EL1 registers are, however, only loaded if we're
> +		 * not in hypervisor context.
> +		 */
> +		loc->loc = is_hyp_ctxt(vcpu) ? SR_LOC_MEMORY : SR_LOC_LOADED;

Hmm... I get the feeling that this flow is becoming even more subtle.
There's some implicit coupling between this switch statement and the
__vcpu_{read,write}_sys_reg_from_cpu() which feels like it could be
error prone. Especially since we're gonna lose the WARN() that would
inform us if an on-CPU register was actually redirected to memory.

I'm wondering if we need some macro hell containing the block of
registers we handle on-CPU and expand that can be expanded into this
triage switch case as well as the sysreg accessor.

What you have definitely seems correct, though. I'll twiddle a bit and
see if I come up with something, although I imagine what you have is
what we'll use in the end anyway.

Thanks,
Oliver

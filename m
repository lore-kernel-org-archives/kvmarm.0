Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FBC33BBB8;
	Wed, 25 Feb 2026 22:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772058973; cv=none; b=JHlWxB1Ddpv8ujh1ZpRc+Lmyd4e8LMf1w7NkGOMO4M0UA5vjCknzwwVJTKPx1uk/qeNciUslUYUHPKG1ah42LOx+jpDIATbo2E6oqwXcThaqPg+toe4/TwYkdES8qm7imwt7x66Td/vMaaLYy52bPDlx1FQ+IcN0ScvHzaqyJt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772058973; c=relaxed/simple;
	bh=4dMpk9jZRV2L4OpJP1psz2eDKkvTItd6ZbPD/pD6LcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdVRzvdSck3FhNlOKrcSuvdd7HsDf9Y6OCEK6KPLlmE15GFSoT8CtonR3IP3N4+lCr7t4bN2YbqRz00k2QKk/aUOV2xrgqXttFctkYL1rSPFcNvPBkCRKq0jjWY06z8Cy7Y/E91GHNcd66eRuhqZaU05ntOY4/Mo79xk9alw4yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qlKTOAOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qlKTOAOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D41C19425;
	Wed, 25 Feb 2026 22:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772058973;
	bh=4dMpk9jZRV2L4OpJP1psz2eDKkvTItd6ZbPD/pD6LcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qlKTOAOTMAWpDlNCoz3OQq5C7N2ckgTlhUJ7x39fjDvjEA3GXmu3ZlYZ/KwwK78k/
	 r0D9hwsUzoZ8X6c4q8szO467fCxbRGeC8sHI2EWO1x72TVOqWP5NXxoop59JSF5kcX
	 fx1RhGbUwshfnUNroAMHi8CfvkDOr58ppCt13v86qgZbT36MYmJ+0HZH8oczEEwmIE
	 S8DwDuQ/9fGXXyiCsh1DjaltRaBnbR1XY6+H8Pc/ZIllj8i5n1j3ssMNEN6797cknU
	 w4PR9Ry0jAsOEEzq+Oo1944YjKQwBtq24XHL54CE6u3Fh1TRYDCq2woDuaQDVZvZdg
	 lxb/0Kv/lp9XA==
Date: Wed, 25 Feb 2026 22:36:07 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Hyesoo Yu <hyesoo.yu@samsung.com>,
	Quentin Perret <qperret@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Force the use of CNTVCT_EL0 in __delay()
Message-ID: <aZ95V8XIYYysd13m@willie-the-truck>
References: <20260213141619.1791283-1-maz@kernel.org>
 <aZw3EGs4rbQvbAzV@e134344.arm.com>
 <86ldgja5v3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ldgja5v3.wl-maz@kernel.org>

On Mon, Feb 23, 2026 at 02:31:44PM +0000, Marc Zyngier wrote:
> Crucially, arch_counter_get_cntvct_stable() does disable preemption,
> and we should preserve it. Something like this:
> 
> diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
> index d02341303899e..25fb593f95b0c 100644
> --- a/arch/arm64/lib/delay.c
> +++ b/arch/arm64/lib/delay.c
> @@ -32,7 +32,16 @@ static inline unsigned long xloops_to_cycles(unsigned long xloops)
>   * Note that userspace cannot change the offset behind our back either,
>   * as the vcpu mutex is held as long as KVM_RUN is in progress.
>   */
> -#define __delay_cycles()	__arch_counter_get_cntvct_stable()
> +static cycles_t __delay_cycles(void)
> +{
> +	cycles_t val;
> +
> +	preempt_disable();
> +	val = __arch_counter_get_cntvct_stable();
> +	preenpt_enable();
> +
> +	return val;
> +}

(nit: arch_counter_get_cntvct_stable() uses the _notrace() variants of
 the preempt disable/enable helpers)

>  void __delay(unsigned long cycles)
>  {
> 
> The question is whether there is a material benefit in replicating the
> arch_timer_read_counter() indirection for the virtual counter in order
> to not pay the price of preempt_disable() when we're on a non-broken
> system (hopefully the vast majority of implementations).

That sounds nice, especially as we can assume (for now) that CPUs
implementing WFIT don't need the cntvct workarounds. However, I can't
really figure out how to implement it after reminding myself of all the
fun we had trying to use a static key for these workarounds in the past.

If a CPU being onlined has a timer erratum, we wouldn't be able to
migrate any tasks in the middle of a preempt-enabled delay loop onto
it. :/

Will

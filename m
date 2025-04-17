Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC0515A8
	for <kvmarm@lists.linux.dev>; Thu, 17 Apr 2025 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744898513; cv=none; b=DHvATZWEyUtXwNyG8wEfbpoL5tdtUE45fuAUiz+aTd2nnvyxWBL5xvz/5xK5sZ5CGDRMFvE8Xxo5mogCQKV7dvcX286TYVnwNpwgv+09fNeDnavRWHao636nMuFCodO6+os7lpJSnQJ2BzXlZ4M3eBKGciZsh9I7DSBJaJ43XLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744898513; c=relaxed/simple;
	bh=3xdgWL9BKZ5VadvNoLxSAhmUejSLg6O3MJWTTyYsSOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoB6vNI+1OsYMLZbqxyvIMcABISduUvGFccBIiBRiNO86TQ927/CY+rfGcj8dCNcxxCfy3MVVDvYuxefrCtmrqIDkFRG71g6oQ045gNDwWQJ5Eloeb1YjyJtyPJz8BGVIe3EGBPAF8iZHQ0WItBIT+QuXI39CiNMTsQG/WoLBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G++VQaD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G++VQaD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922ABC4CEE4;
	Thu, 17 Apr 2025 14:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744898512;
	bh=3xdgWL9BKZ5VadvNoLxSAhmUejSLg6O3MJWTTyYsSOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G++VQaD7jw3OMS5E8HEUmfYc98bJHaUmmQ1qOlNrlUq2yLKlTYcAmDVB2I/q3iABG
	 z4bxahr+sds/BQWJxPAc1VADMfe+X5aoANVMVeogzzHbT/BSh0R+/wbf7IqoUcFUia
	 T/duQmQyLQjHaK4YXPiQC45Axry+bydvLoKn7iYQPYX8IwANI9DWzHAzZVfyQasH6P
	 qrp+uGkFQKPtJZ93McqdOnVNNxdyM0Lvq12G3ASVTkRN8SeGTw2rLm4QbFww180Ttb
	 EnZHq9u/l/MBCBRklxqYO2SgdSeE3oZDdliSB3gZOXUED8dWq/sOvRUqR8A9qd6Pfr
	 pn/bee+NmaVPQ==
Date: Thu, 17 Apr 2025 15:01:48 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] arm64: Remove checks for broken Cavium HW from the PI
 code
Message-ID: <20250417140147.GA13109@willie-the-truck>
References: <20250416123534.1108220-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250416123534.1108220-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Apr 16, 2025 at 01:35:34PM +0100, Marc Zyngier wrote:
> Calling into the MIDR checking framework from the PI code has recently
> become much harder, due to the new fancy "multi-MIDR" support that
> relies on tables being populated at boot time, but not that early that
> they are available to the PI code. There are additional issues with
> this framework, as the code really isn't position independend *at all*.
> 
> This leads to some ugly breakages, as reported by Ada.
> 
> It so appears that the only reason for the PI code to call into the
> MIDR checking code is to cope with The Most Broken ARM64 System Ever,
> aka Cavium ThunderX, which cannot deal with nG attributes that result
> of the combination of KASLR and KPTI as a consequence of Erratum 27456.
> 
> Rather than adding extra complexity for something that is actually
> a very dead horse, let's simply drop that check. On my own machine,
> the firmware doesn't provide a KASLR seed, preventing the pathological
> case to show up.
> 
> And if someone does have a broken box that passes a seed to the kernel,
> "nokaslr" on the command-line is an easy enough workaround.
> 
> Fixes: c8c2647e69bed ("arm64: Make  _midr_in_range_list() an exported function")
> Reported-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/3d97e45a-23cf-419b-9b6f-140b4d88de7b@arm.com
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/mmu.h   | 11 -----------
>  arch/arm64/kernel/cpu_errata.c |  2 +-
>  arch/arm64/kernel/image-vars.h |  4 ----
>  3 files changed, 1 insertion(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
> index 30a29e88994ba..6e8aa8e726015 100644
> --- a/arch/arm64/include/asm/mmu.h
> +++ b/arch/arm64/include/asm/mmu.h
> @@ -94,17 +94,6 @@ static inline bool kaslr_requires_kpti(void)
>  			return false;
>  	}
>  
> -	/*
> -	 * Systems affected by Cavium erratum 24756 are incompatible
> -	 * with KPTI.
> -	 */
> -	if (IS_ENABLED(CONFIG_CAVIUM_ERRATUM_27456)) {
> -		extern const struct midr_range cavium_erratum_27456_cpus[];
> -
> -		if (is_midr_in_range_list(cavium_erratum_27456_cpus))
> -			return false;
> -	}
> -
>  	return true;
>  }
>  
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index b55f5f7057502..6b0ad5070d3e0 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -335,7 +335,7 @@ static const struct midr_range cavium_erratum_23154_cpus[] = {
>  #endif
>  
>  #ifdef CONFIG_CAVIUM_ERRATUM_27456
> -const struct midr_range cavium_erratum_27456_cpus[] = {
> +static const struct midr_range cavium_erratum_27456_cpus[] = {
>  	/* Cavium ThunderX, T88 pass 1.x - 2.1 */
>  	MIDR_RANGE(MIDR_THUNDERX, 0, 0, 1, 1),
>  	/* Cavium ThunderX, T81 pass 1.0 */
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 5e3c4b58f2790..2004b4f41ade6 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -47,10 +47,6 @@ PROVIDE(__pi_id_aa64smfr0_override	= id_aa64smfr0_override);
>  PROVIDE(__pi_id_aa64zfr0_override	= id_aa64zfr0_override);
>  PROVIDE(__pi_arm64_sw_feature_override	= arm64_sw_feature_override);
>  PROVIDE(__pi_arm64_use_ng_mappings	= arm64_use_ng_mappings);
> -#ifdef CONFIG_CAVIUM_ERRATUM_27456
> -PROVIDE(__pi_cavium_erratum_27456_cpus	= cavium_erratum_27456_cpus);
> -PROVIDE(__pi_is_midr_in_range_list	= is_midr_in_range_list);
> -#endif

Hmm, I'm not really sure about this as it seems to be punishing the poor
user of the box who really hasn't done anything wrong. The firmware might
not be passing a KASLR seed to the host, but what about guest VMs? It's
pretty easy for the VMM to stuff a seed into the DT, so if somebody was
running VMs on TX1 with kaslr before c8c2647e69bed ("arm64: Make
_midr_in_range_list() an exported function") and things worked, I don't
think we should be breaking that so that it crashes in weird ways.

Could we just read MIDR_EL1 (read_cpuid_id()) in the PI code to detect
ThunderX that way? I'm less fussed about the multi-MIDR code working on
this machine as it's a new feature (and we could disable the new
hypercalls here if we really cared).

Alternatively, we could properly rip out the TX1 support and fail to boot
if we detect it. At least that's deterministic and we could have a useful
error message about the thing being unsupported.

Will

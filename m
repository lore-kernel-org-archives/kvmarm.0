Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544C6455182;
	Thu, 27 Aug 2026 12:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787835418; cv=none; b=FD+6zs+0v29NvR7nULuXRTsn+vZozV9ptivGgoi+ooJI6Ci+W7+LO0AYxoLxzEvyt7m9H1cRF6mSpp1oECggYB4sccJzUpgEsiMvSVeJ+f5IYU3oeieglmIaRyuivTM/3IANUJhqNxYFS7eMLONBY9SUQj64GlUVRbA4vmSz1oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787835418; c=relaxed/simple;
	bh=PgvSykzIwy9uc/lVtTS5okw21TByEUZjdTjgC0Jiss8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C0Lo5IHG9wY/IcIlybSWlmsB8bTkQbdAUDkH7TklptF6SeFe9+a5R63KKiv8FkbcZaLPc2+7OB2D+fjac8uprSEnaZR7MuHZd8VR6z704BmtEN5LbMeLaMxYFRkjZm+SedXAfZk26bdMMFxNoiHvqqBJANIQCHMMxoNVIAI0Lxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EqdhRjO6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EqdhRjO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139751F00AC4;
	Thu, 27 Aug 2026 12:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787835401;
	bh=84D7JGfn3OSGzXIWSGTcG//xl0whJ+rapCqk+y7kxGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EqdhRjO69TFsGv7z/qz2fyi5pLykZxzEtoKo0V+rVh/cnSQIBfdBnPXXribWkEPs0
	 EkPCCscmhMTXOUmeMn1BllS3Q3CL728VtQKsOw2bemkg62e0f+I128SIZ6Vb1JgxT6
	 XehR/1K2kCTwSRsrxSjqt7Z2gkJSfQMBtIzy5NUheyhMTI2WAmUBkTDN7VWXDZ/LkO
	 jcpwp3EjrvygKkh7q94ZzeHRtZJQjuFZfSOLF9BQsMjE8wNpSC8N5w1yYzDP+zFqeU
	 5+O6y6huLTq+ENkzXOy3w3ecJM04r08p4KOyRS2bEpnNA/GvhjEQV0F+3o/l7SEEue
	 u3Vtvq2qPkP+A==
Date: Thu, 27 Aug 2026 13:56:35 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 2/2] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <apA0A-bqLVBcmdSv@willie-the-truck>
References: <20260825164219.3347229-1-fuad.tabba@linux.dev>
 <20260825164219.3347229-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825164219.3347229-3-fuad.tabba@linux.dev>

On Tue, Aug 25, 2026 at 05:42:19PM +0100, Fuad Tabba wrote:
> __cpuinfo_store_cpu() gates the GMID_EL1 read on the raw
> ID_AA64PFR1_EL1, so it reads the register even when the kernel has
> disabled MTE (CONFIG_ARM64_MTE=n or arm64.nomte). KVM sets HCR_EL2.TID5
> in that case, and pKVM injects an UNDEF the host cannot handle:
> 
>   Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
>   pc : __cpuinfo_store_cpu+0xf4/0x264
>   Kernel panic - not syncing: Attempted to kill the idle task!
> 
> Only pKVM reaches it, and only after a CPU is offlined and brought back
> online: its CPU_ON relay sets the host HCR before the CPU enters EL1,
> while plain nVHE sets it at CPUHP_AP_KVM_ONLINE.
> 
> Gate the read on __read_sysreg_by_encoding(), which applies the cmdline
> override, and on CONFIG_ARM64_MTE, which no register reflects.
> 
> Fixes: f35abcbb8a084 ("KVM: arm64: Trap MTE access and discovery when MTE is disabled")
> Cc: stable@vger.kernel.org # needs "arm64: Apply overrides to CPU local capabilities"
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/include/asm/cpufeature.h | 9 +++++++++
>  arch/arm64/kernel/cpufeature.c      | 6 ++----
>  arch/arm64/kernel/cpuinfo.c         | 2 +-
>  3 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index a57870fa96db5..0b374e938f708 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -1085,6 +1085,15 @@ static inline bool cpu_has_lpa2(void)
>  #endif
>  }
>  
> +/* No ID register reflects CONFIG_ARM64_MTE. */
> +static inline bool gmid_el1_accessible(void)
> +{
> +	if (!IS_ENABLED(CONFIG_ARM64_MTE))
> +		return false;
> +
> +	return id_aa64pfr1_mte(__read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1));

I'm planning to internalise __read_sysreg_by_encoding() into cpufeature.c
so I'd prefer to avoid adding another user of it, if possible. In this case,
__cpuinfo_store_cpu() has already read the thing, so all it needs is the
override logic (but see below).

> +}
> +
>  #endif /* __ASSEMBLER__ */
>  
>  #endif
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 88b15b5ef2f7f..23f174b3c4e26 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1228,7 +1228,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
>  		init_cpu_ftr_reg(SYS_MPAMIDR_EL1, info->reg_mpamidr);
>  	}
>  
> -	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
> +	if (gmid_el1_accessible())
>  		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
>  }
>  
> @@ -1523,11 +1523,9 @@ void update_cpu_features(int cpu,
>  	 * they read/write depends on the GMID_EL1.BS field. Check that the
>  	 * value is the same on all CPUs.
>  	 */
> -	if (IS_ENABLED(CONFIG_ARM64_MTE) &&
> -	    id_aa64pfr1_mte(info->reg_id_aa64pfr1)) {
> +	if (gmid_el1_accessible())
>  		taint |= check_update_ftr_reg(SYS_GMID_EL1, cpu,
>  					      info->reg_gmid, boot->reg_gmid);
> -	}
>  
>  	/*
>  	 * If we don't have AArch32 at all then skip the checks entirely
> diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
> index d50e2a9b066b3..389fca84f106b 100644
> --- a/arch/arm64/kernel/cpuinfo.c
> +++ b/arch/arm64/kernel/cpuinfo.c
> @@ -502,7 +502,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
>  	info->reg_id_aa64smfr0 = read_cpuid(ID_AA64SMFR0_EL1);
>  	info->reg_id_aa64fpfr0 = read_cpuid(ID_AA64FPFR0_EL1);
>  
> -	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
> +	if (gmid_el1_accessible())
>  		info->reg_gmid = read_cpuid(GMID_EL1);

I'm not sure this is safe. For the boot CPU, __cpuinfo_store_cpu() is
called before init_cpu_features(), so the arm64_ftr_regs[] array hasn't
been sorted and we can't call get_arm64_ftr_reg() reliably. In fact, it
doesn't even look like the overrides will have been processed.

So we're in a bit of a chicken-and-egg problem here. Perhaps we need an
early (__init) function that can apply the override manually to the
value read from hardware using arm64_ftr_safe_value(). You'll probably
need something like my old hack [1] to avoid the bsearch though :/

Will

[1] https://lore.kernel.org/all/20230110161651.GB9436@willie-the-truck/

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02F91422D4
	for <kvmarm@lists.linux.dev>; Fri, 12 Apr 2024 14:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712932886; cv=none; b=pHuSV9kWpEbsgQ4pMY48XoTgkrB8qJJiRsgqAIPiHvjbfnjGemdRatgG5YLe8EGGLwAZUFyYoCiDB9xXQEe+Az5GtwZdhezEue5yBhcse4vFMcy0HyemII8xicvCHbqTckVauB83inYKmU+8x2+QBzsRmc08TXwa2TC1QsR0HlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712932886; c=relaxed/simple;
	bh=Uu4Cj6SWMI9qJ0zfNeteActA4eMTFDKFo85S630fpAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2YF05f94KPcgFx30tKMml7wabJLy5f9N7I5GnuZj1Z8mj6AKPymKenwHpotgIsNAip8LpCgZ7DJZY+CJfnLDDHGHAEEh+PA/rJ56RPjGC60NjPqwp6hJGYvtl+7rJUUTRfpCsiTRDU6Z80iDFLKKqomjS3naeCugEJ4x/WeD+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X59K5Jxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X59K5Jxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D74C113CC;
	Fri, 12 Apr 2024 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712932885;
	bh=Uu4Cj6SWMI9qJ0zfNeteActA4eMTFDKFo85S630fpAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X59K5JxusBEugPPxsVs8bLijrtlq7YUQmP38m2iI+b67Liv1MdzGYxa8BeWkyNDRB
	 kF4KQ0pRI3rX8lNFN8AloQUdUA4ewMjLupMWMqj9AqYkptRuQ3wyf2A6pckRdmXMRK
	 xgDU+7nyLTwtI9eCqfPrDXeinI0wAhQerr8yb6WNr1uTpM+880A80szkiLtCdKEexf
	 FOf0E5yBdUu1Ls/hszDkrfdmVoQ2N0y6aznNcxEQqFX5vHjIzFMIxH2XfLnLktTZDw
	 8nK2vw1hVwtcPyydFtNhrvkxCRvLwQQdwJuBskymOJeLnAVtOrele4TK/Qs3eAHGpH
	 XYpazvTN6Tydg==
Date: Fri, 12 Apr 2024 15:41:20 +0100
From: Will Deacon <will@kernel.org>
To: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v3 2/6] arm64: cpufeature: discover CPU support for MPAM
Message-ID: <20240412144119.GB28052@willie-the-truck>
References: <20240321165728.31907-1-james.morse@arm.com>
 <20240321165728.31907-3-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321165728.31907-3-james.morse@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi James,

On Thu, Mar 21, 2024 at 04:57:24PM +0000, James Morse wrote:
> ARMv8.4 adds support for 'Memory Partitioning And Monitoring' (MPAM)
> which describes an interface to cache and bandwidth controls wherever
> they appear in the system.
> 
> Add support to detect MPAM. Like SVE, MPAM has an extra id register that
> describes some more properties, including the virtualisation support,
> which is optional. Detect this separately so we can detect
> mismatched/insane systems, but still use MPAM on the host even if the
> virtualisation support is missing.
> 
> MPAM needs enabling at the highest implemented exception level, otherwise
> the register accesses trap. The 'enabled' flag is accessible to lower
> exception levels, but its in a register that traps when MPAM isn't enabled.
> The cpufeature 'matches' hook is extended to test this on one of the
> CPUs, so that firmware can emulate MPAM as disabled if it is reserved
> for use by secure world.
> 
> Secondary CPUs that appear late could trip cpufeature's 'lower safe'
> behaviour after the MPAM properties have been advertised to user-space.
> Add a verify call to ensure late secondaries match the existing CPUs.
> 
> (If you have a boot failure that bisects here its likely your CPUs
> advertise MPAM in the id registers, but firmware failed to either enable
> or MPAM, or emulate the trap as if it were disabled)

I'm probably reading this wrong, but I'm a bit confused about the mixture
of open-coded system register definitions and updates to the 'sysreg'
file. For example:

> +/* CPU Registers */
> +#define MPAM_SYSREG_EN			BIT_ULL(63)
> +#define MPAM_SYSREG_TRAP_IDR		BIT_ULL(58)
> +#define MPAM_SYSREG_TRAP_MPAM0_EL1	BIT_ULL(49)
> +#define MPAM_SYSREG_TRAP_MPAM1_EL1	BIT_ULL(48)
> +#define MPAM_SYSREG_PMG_D		GENMASK(47, 40)
> +#define MPAM_SYSREG_PMG_I		GENMASK(39, 32)
> +#define MPAM_SYSREG_PARTID_D		GENMASK(31, 16)
> +#define MPAM_SYSREG_PARTID_I		GENMASK(15, 0)

MPAM_SYSREG_EN is then used in conjuntion with SYS_MPAM1_EL1:

> +static bool __maybe_unused
> +test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	if (!has_cpuid_feature(entry, scope))
> +		return false;
> +
> +	/* Check firmware actually enabled MPAM on this cpu. */
> +	return (read_sysreg_s(SYS_MPAM1_EL1) & MPAM_SYSREG_EN);
> +}

But that register has a 'sysreg' entry:

> +Sysreg	MPAM1_EL1	3	0	10	5	0
> +Res0	63:48
> +Field	47:40	PMG_D
> +Field	39:32	PMG_I
> +Field	31:16	PARTID_D
> +Field	15:0	PARTID_I
> +EndSysreg

where bit 63 is RES0.

Will

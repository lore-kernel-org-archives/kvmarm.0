Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0A3456E05;
	Thu, 10 Sep 2026 10:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036860; cv=none; b=campJdZXaX8Z50SgT9QOHYSmpt9XrFqbuXEoDJZ/Ew1OZZ7dQeLITDJfgnb9DpEoPOQX0qOWMyWWOGbnm03ap0SCHsYr6GskAeMSWJJw4ciqHnCYrB9i0+tbBVOv5VQFqNDZd/Gnu6sRUjpkW3HcuEE7Ejgbm/nzt3FQn6auZV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036860; c=relaxed/simple;
	bh=hkkcVOj/rSJNbATKfUukGH582NyaCnD1NBGF1zphExk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ogj8WnZtUSSnL6MWQ3x3SDmO59qBJtAZlnS7FKjDGzYpLYdWo1XZ6yB//MPO5tBSRw8MvRTM9OMVk9vSqW3EyBpyc8wFPOj1IyGqZFZinf6wCqBZY8/C1MSj880qjmlaR+QbfGNG2tRvkcIeCKMxdsw8/LjULaLO9MeiNGVpaWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1EYKIpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1EYKIpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B305D1F00893;
	Thu, 10 Sep 2026 10:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036858;
	bh=KWxT80cynlb4zIAOYzQS8Ncj1BaRkxy5Cmg155xMdQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b1EYKIpKm/JybExizljNgQKizptuBMZ8kMH8KT/8JlC207RHIAqutl7A3bWFHHdqe
	 8rqzWkPBn/6YzUcXbJaF8uWbEdf7iRhK16HGLS1IpdAKC5JxD8vpATCuXozp75NPcM
	 CrV/7Sl2KQZN8gABJf7/jjsKNZvUjwuO2KfgEQ0Dtu484kb6z1QjAPpcb5NvhKyY4C
	 AgMCV3uTgBKXLJSSKkCLxbxI1wQswZiz0OvbcMHkcrs760ZQ9XNpYQ/+8I83y/+LVG
	 /B/XpqZOkOcMwjlOC2xkuvujKjmrdRWa/4hr/kMHRTk9eoykIPT+6YDTGyo512kcS9
	 9SdZ6ZHA27ipg==
Date: Thu, 10 Sep 2026 11:40:51 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>, Ben Horgan <ben.horgan@arm.com>,
	Xi Ruoyao <xry111@xry111.site>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Gavin Shan <gshan@redhat.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>, Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
 implemented
Message-ID: <aqKJM3CF-i3VyJk2@willie-the-truck>
References: <20260908145651.2828597-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908145651.2828597-1-fuad.tabba@linux.dev>

On Tue, Sep 08, 2026 at 03:56:51PM +0100, Fuad Tabba wrote:
> finalise_el2_state() clears the EL2 MPAM traps whenever the ID
> registers advertise MPAM, while KVM sets them only under ARM64_MPAM,
> which also requires MPAMEN. Without EL3 nothing sets that enable, so a
> guest reaches the MPAM registers while ID_AA64PFR0_EL1.MPAM reads 0
> for it.
> 
> Gate the traps on the ID registers alone: MPAMEN isn't a term in any
> MPAM accessor, so they take effect without it. The cap tests the
> sanitised ID fields, which never exceed a CPU's own, so it's set only
> where finalise_el2_state already wrote MPAM2_EL2. MPAM3_EL3.TRAPLOWER
> is clear there, and arm64.nompam turns the cap off too.
> 
> Fixes: 23b33d1e168c ("arm64: head.S: Initialise MPAM EL2 registers and disable traps")
> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
> 
> Notes:
>     Changes since v1:
>      - Commit message only. The code is unchanged, so Yuan Yao's
>        Reviewed-by is carried.
>      - Fixes: names the commit that cleared the traps, rather than the
>        one that added KVM's trapping.
>      - Says why the sanitised ID fields are the safe gate: the cap is set
>        only where finalise_el2_state already wrote MPAM2_EL2.
>     
>     Not covered, and answered on the v1 thread: a machine whose CPUs
>     differ on MPAM, raised by Ben and by sashiko.
>     
>     v1: https://lore.kernel.org/all/20260903160819.831518-1-fuad.tabba@linux.dev/
> 
>  arch/arm64/include/asm/cpufeature.h     |  5 +++++
>  arch/arm64/kernel/cpufeature.c          | 13 +++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
>  arch/arm64/tools/cpucaps                |  1 +
>  4 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 7404a6e83a930..8863ae99596bc 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -873,6 +873,11 @@ static __always_inline bool system_supports_mpam_hcr(void)
>  	return alternative_has_cap_unlikely(ARM64_MPAM_HCR);
>  }
>  
> +static __always_inline bool system_supports_mpam_sysregs(void)
> +{
> +	return alternative_has_cap_unlikely(ARM64_MPAM_SYSREGS);
> +}
> +
>  static inline bool system_supports_pmuv3(void)
>  {
>  	return cpus_have_final_cap(ARM64_HAS_PMUV3);
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 17b83a2518a8f..36a27692e5cf7 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2501,6 +2501,13 @@ test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
>  	return (read_sysreg_s(SYS_MPAM1_EL1) & MPAM1_EL1_MPAMEN);
>  }
>  
> +static bool
> +test_has_mpam_sysregs(const struct arm64_cpu_capabilities *entry, int __unused)
> +{
> +	/* The registers exist whether or not firmware enabled MPAM. */
> +	return detect_ftr_has_mpam();
> +}
> +
>  static void
>  cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
>  {
> @@ -3116,6 +3123,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = test_has_mpam,
>  		.cpu_enable = cpu_enable_mpam,
>  	},
> +	{
> +		.desc = "Memory Partitioning And Monitoring system registers",
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.capability = ARM64_MPAM_SYSREGS,
> +		.matches = test_has_mpam_sysregs,
> +	},

We already have two system capabilities for MPAM so I'm not overly keen
to add a third, especially as the MPAM code is largely confined to the
resctrl driver. In fact, this feels a bit similar to things like TRBE
and SPE in the sense that (a) we have to probe it per-cpu (b) it can
be disabled by a higher EL and (c) most of the code is in a driver, but
KVM needs to know how to switch it.

Neither TRBE nor SPE need entries in arm64_features[] at all, so something
isn't right here...

Will

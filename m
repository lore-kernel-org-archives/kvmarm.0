Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7EC448393
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 09:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772375; cv=none; b=CaR37KU4eLzUZ2q+FuLP7hqPObH/kejqORPC/8gpgt3CZ4Ulpa0hAhFRKWuV/y8kUCOwt1gi1eQ2g9Ynds/EatMKVVtgCHpRuqYCAfuMgaumXv4Er8y+fzyHQ2EqcQPiZYWpqSqk/yPyN+1wg+Yfc5bvFDflUlVAAPRuo2P8M5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772375; c=relaxed/simple;
	bh=xNzQIWKCtWQx9BvtJkARbD3SnPKoaTr+qsEbwFKZu7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gGnvOXKfXY+9nkwBdfbUnfsyJ7k6PPAEGEO1Chq/MX77BNj9AbU2KlcFNoMi7apuBXBG2/8AHz9xybjse/UP3ut0QUVNcAMORF6brvpNHHz/vmBUAqI56XTYUQF5TRHQy4O/Q5cxo1sT0eZbQqgV+nKlJAiNN2j2snWgJgK7KoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=n69aa6Gq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="n69aa6Gq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC98C1477;
	Mon,  7 Sep 2026 02:12:45 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 47A403F7B4;
	Mon,  7 Sep 2026 02:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788772369; bh=xNzQIWKCtWQx9BvtJkARbD3SnPKoaTr+qsEbwFKZu7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n69aa6Gq9h2AXejw1H0OMLJncluZeNDSc45O5MVqiMUcreOrcliEQohSFQyfe3Lhl
	 hm99XNBJVIy88H2By2LNUM1M08qYKvNaYb5u+/dFW4PuvHC3NZ63euYYD3gqc8R05W
	 1Q/maFWaEyjUK+/mXtiuXLsAifjEIg65+1foOYRk=
Message-ID: <dd850141-ea85-4d94-9793-393f24a2fdc2@arm.com>
Date: Mon, 7 Sep 2026 10:12:45 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
 implemented
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>, Xi Ruoyao <xry111@xry111.site>,
 Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Gavin Shan <gshan@redhat.com>, Fuad Tabba <tabba@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260903160819.831518-1-fuad.tabba@linux.dev>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20260903160819.831518-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 03/09/2026 17:08, Fuad Tabba wrote:
> finalise_el2_state() clears the EL2 MPAM traps whenever the ID registers
> advertise MPAM, but KVM sets them only when ARM64_MPAM is set, which
> also requires MPAMEN. Without EL3 the enable is EL2's own and nothing
> sets it, so the cap stays off and a guest reaches the MPAM registers
> while ID_AA64PFR0_EL1.MPAM reads 0 for it.

Good spot.

> 
> Gate the traps on the ID registers alone. MPAMEN is not a term in any
> MPAM accessor, so they take effect without it. finalise_el2_state
> already wrote MPAM2_EL2 under the same condition, so MPAM3_EL3.TRAPLOWER
> is clear wherever the cap is set, and arm64.nompam still clears it.
> 
> Fixes: 31ff96c38ea3 ("KVM: arm64: Fix missing traps of guest accesses to the MPAM registers")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
> Found this while working on the other MPAM thread [1].
> 
> [1] https://lore.kernel.org/all/CA+EHjTxeWxZiuSmnKLGLxTBXP4oJT7-LuffbPAyCSZZ5TW=5Ew@mail.gmail.com/
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

The sashiko comments reminded me about the possibility of mismatched systems. I see two cases to
consider here. One is if the firmware doesn't touch the MPAM system registers and leaves
MPAM3_EL3.TRAPLOWER set to 1. In which case the user is required to add arm64.nompam to the cmdline
as the MPAM registers can't be accessed from EL2. The second is if the f/w clears
MPAM3_EL3.TRAPLOWER, in which case arm64.nompam can't be used without making MPAM1_EL1 etc, shared
between guests. Perhaps for these mismatched systems we need to unconditionally enable the EL2 traps
for the cpus that support MPAM and not advertise any support for MPAM. Furthermore, if we, before
kvm gets involved, unconditionally enable the EL2 traps on systems where MPAM can't be enabled then
I'm not sure that we need to distinguish system_supports_mpam_sysregs() and system_supports_mpam()
in the kvm code. What do you think? Does that fit in with the pattern of how cpu features are
generally handled?

Thanks,

Ben


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
>  	{
>  		.desc = "Memory Partitioning And Monitoring Virtualisation",
>  		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 1ce7130e25490..8941335724f6b 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -298,7 +298,7 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
>  	u64 clr = MPAM2_EL2_EnMPAMSM;
>  	u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
>  
> -	if (!system_supports_mpam())
> +	if (!system_supports_mpam_sysregs())
>  		return;
>  
>  	/* trap guest access to MPAMIDR_EL1 */
> @@ -317,7 +317,7 @@ static inline void __deactivate_traps_mpam(void)
>  	u64 clr = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1 | MPAM2_EL2_TIDR;
>  	u64 set = MPAM2_EL2_EnMPAMSM;
>  
> -	if (!system_supports_mpam())
> +	if (!system_supports_mpam_sysregs())
>  		return;
>  
>  	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 2775ba3359cfe..aa5be51385f68 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -78,6 +78,7 @@ KVM_PROTECTED_MODE
>  MISMATCHED_CACHE_TYPE
>  MPAM
>  MPAM_HCR
> +MPAM_SYSREGS
>  MTE
>  MTE_ASYMM
>  MTE_FAR
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935


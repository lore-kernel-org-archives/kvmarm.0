Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FA622423A
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 09:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515906; cv=none; b=bCjJovyCOvf67a/7qHesqJEJRiGlmwPAfFnG3Si2FZs21K57/YbztKTYokTn4CzQ6Qp3sKng9R0QmgjvbJR/lQMAcJNfEiWDKfjUOXKf6U9+4NubUCA+FUHhRqKin0MHltMi5JYIIUaAx9hwxKJPQc8eGJCLcfFxJ0A+WXeaI9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515906; c=relaxed/simple;
	bh=b/7ox1qHVpfTiJId5Ik9DmFYK53QC3NjIIZU5pQ4xx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMUEU0yLJzzO8HmE2FEf1mdtqrOjWBc8z7BsbDCtcCQNS+XRTuVEOcKFzsCCEsi9emyvljjjEj4e3X4+GXs2FnBUOGZCFU19NVnLPhyjH2vcVDr6ammDXc/uc+qlM0t18te43Qholzt7CB0oD+0KVkS9o1nKVWLTCa0G84csDTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BxV6PgOG; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BxV6PgOG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788515900; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=YMXNyqxxAHPj5mHagYpPD2DOChjfDsBWFwDX5331fZs=;
	b=BxV6PgOGy0R4MT5UcMqm3Yx3eWL5ZktZxShXvXyjtrNteWQmBtZpYCxYvIWG3Gx0DXz3tveaIu4blZ9FnsQ1AZMp4PVUqwwc8wE/ItqC9IxxE16x/0KV2/DNclt9H65IHgziNaS9VJ8JBffHLiLREZyGCUZgM7QANPzXYp6KUtQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XAIV0Lb_1788515898;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0XAIV0Lb_1788515898 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 17:58:19 +0800
Date: Fri, 4 Sep 2026 17:58:18 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Ben Horgan <ben.horgan@arm.com>, Xi Ruoyao <xry111@xry111.site>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Gavin Shan <gshan@redhat.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
 implemented
Message-ID: <xmhaptfcp2gyoovgus35yhx2uloe2zt3zniwscd2dwnatf2fii@jqobvjdmkqed>
References: <20260903160819.831518-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160819.831518-1-fuad.tabba@linux.dev>

On Thu, Sep 03, 2026 at 05:08:19PM +0800, Fuad Tabba wrote:
> finalise_el2_state() clears the EL2 MPAM traps whenever the ID registers
> advertise MPAM, but KVM sets them only when ARM64_MPAM is set, which
> also requires MPAMEN. Without EL3 the enable is EL2's own and nothing
> sets it, so the cap stays off and a guest reaches the MPAM registers
> while ID_AA64PFR0_EL1.MPAM reads 0 for it.
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

Hi Tabba,

> +static bool
> +test_has_mpam_sysregs(const struct arm64_cpu_capabilities *entry, int __unused)
> +{
> +	/* The registers exist whether or not firmware enabled MPAM. */
> +	return detect_ftr_has_mpam();
> +}

My understanding: arm64.nompam affects detect_ftr_has_mpam(),
thus when arm64.nompam = 1 w/ MPAM is supported in hardware,
the KVM's trap setting is skipped yet, and it's possible that
SYS_MPAM2_EL2 and SYS_MPAMHCR_EL2 are configured not trap anything
by firmware, thus guest can still access MPAM registers.

Do we need check the raw id register values for the real support
state of MPAM here ?

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
> --
> 2.39.5
>

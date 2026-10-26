Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793029307;
	b=3atkLGN+bQJPF7js/KIqdJBT/t/WJu2BEGj6vJP/qp0smbOGdjrXkCxIz9Yq5AavSabK
	 QLtUhWeLx109/icjZCiLuY0HHnvoUl7pwZG7Uplq1RkQbpjO/nvUWqlGOxWN9TC0kCeTA
	 gOKdv032eZus2cHy0XTrgtep5mZBVoA0g+kBHR8gFYBmAEARCgp4Js7wMv8RsIDJpWCDx
	 aNzanlRP0a22Vw/v1puUwetSifRz3VnDAqVa96rLkJzxA+FzCd3Hc3DFWHkpUGhxFSgkl
	 BTrFz+oMjyvl9Nk1VvsgQ/lmVgX1/q5Ae8QgyZNbEwnC9Ciwb0HhkN2EmRamOXWMcYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793029307;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=GKj9JFfk8I4IU3vVzFmwmNrdflyxwhRRx6GsvWvD46w=;
	b=X2PBn2GUy5b5iaOaoOSZIA+8IGUTLvHhpVB1i6QOpKGBgqgZWr4nDa6va7svZpfCWm2o
	 3tTBgm8sBODFWUshHFXgnYpwUDvCJX3EpTBGwN4IUJrsvzRKba7uKJkbNZ8vTguuuv9eA
	 JCo9frDn9+qHHcvdSo0g7jS87imcR2n/gpsZOjQFGmJzo0oWlI8kIaFKMM6XPSz19hiKX
	 pYgts0Ho5vq/cQaastrgKEE8bDjcjO6VKwjTBDHk4n4wfE18d7JNPP9kymVyzRyWsVLVx
	 uWSl2gCGjXALhEivGaM63m2UHHCx4W8Rc4Ou1ciBIXk7j8RV40F/0M/e6i8pnhZk84g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="kUwXwSd/";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3A9606A31B
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 15:41:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D3A9606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kUwXwSd/
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38E9819F6;
	Mon, 26 Oct 2026 08:41:42 -0700 (PDT)
Received: from [10.57.10.231] (unknown [10.57.10.231])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 199523F59E;
	Mon, 26 Oct 2026 08:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793029305; bh=cmexXTKLOSAI+heYuz0JDdMhnzANsLX6gihKP09ScZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kUwXwSd/nn5jBPQbUkRuYeXNe3OVLuPy3WXmLnpGX+CIDo6d3qTUCjK+OljzDFHAY
	 hHak9JAT251sASlhwcYogAAeQ/6wJIWTHJItJTmkwOuL6KIbI8P7oyuE95FgDmbwB5
	 ar8e8neaJQw3JFISwK7KgFX43wTDM7oEPFDEOhCg=
Message-ID: <a86348e5-a55a-4a99-a3c6-24b3213ed3d1@arm.com>
Date: Mon, 26 Oct 2026 15:41:41 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] KVM: arm64: Add context-switch of ACCDATA_EL1
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>,
 Yicong Yang <yangyicong@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>,
 Arnd Bergmann <arnd@arndb.de>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261025075138.2919734-1-fuad.tabba@linux.dev>
 <20261025075138.2919734-4-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261025075138.2919734-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad

On 25/10/2026 07:51, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Add ACCDATA_EL1 save/restore as part of the EL0 context. This is
> conditioned on the guest's view of ID_AA64ISAR1_EL1.LS64 reporting
> that this register is supported.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: 58ce78667a641 ("arm64: Add support for FEAT_{LS64, LS64_V}")
> Link: https://lore.kernel.org/r/20240815125959.2097734-5-maz@kernel.org
> Cc: stable@vger.kernel.org
> [Fuad: rebased; switch ACCDATA_EL1 for guests only, as the host never
>   uses it; gate it on a new ARM64_HAS_LS64_ACCDATA capability, since
>   in pKVM the host controls a non-protected guest's ID registers, and
>   an EL2 access to ACCDATA_EL1 on a CPU without the feature is UNDEFINED]
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>   arch/arm64/kernel/cpufeature.c             |  7 +++++++
>   arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 23 ++++++++++++++++++++++
>   arch/arm64/tools/cpucaps                   |  1 +
>   3 files changed, 31 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 32102c3912fa7..b5720c56eebc9 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -3225,6 +3225,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.cpu_enable = cpu_enable_ls64_v,
>   		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LS64, LS64_V)
>   	},
> +	{
> +		.desc = "LS64_ACCDATA",
> +		.capability = ARM64_HAS_LS64_ACCDATA,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_cpuid_feature,
> +		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA)
> +	},
>   #ifdef CONFIG_ARM64_LSUI
>   	{
>   		.desc = "Unprivileged Load Store Instructions (LSUI)",
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index c382848d31947..4a008c8a696ba 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -17,6 +17,7 @@
>   #include <asm/kvm_mmu.h>
>   
>   static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt);
> +static inline bool ctxt_has_accdata(struct kvm_cpu_context *ctxt);
>   
>   static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
>   {
> @@ -67,6 +68,13 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
>   {
>   	ctxt_sys_reg(ctxt, TPIDR_EL0)	= read_sysreg(tpidr_el0);
>   	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
> +
> +	/*
> +	 * Despite the appearances, ACCDATA_EL1 is part of the EL0
> +	 * context, as it can only be used using ST64BV0.
> +	 */
> +	if (ctxt_has_accdata(ctxt))
> +		ctxt_sys_reg(ctxt, ACCDATA_EL1)	= read_sysreg_s(SYS_ACCDATA_EL1);
>   }
>   
>   static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
> @@ -131,6 +139,18 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
>   	return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
>   }
>   
> +static inline bool ctxt_has_accdata(struct kvm_cpu_context *ctxt)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	/* The host never uses ACCDATA_EL1 */
> +	if (!cpus_have_final_cap(ARM64_HAS_LS64_ACCDATA) || !ctxt_is_guest(ctxt))
> +		return false;
> +
> +	vcpu = ctxt_to_vcpu(ctxt);
> +	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA);

minor nit: Aligning with the other kvm_has_feat() usecsaes, should we 
wrap this under kvm_has_accdata() (with moving the cpus_have_final_cap()
to the wrapper ?)

Otherwise looks good to me.

Suzuki



> +}
> +
>   static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>   {
>   	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
> @@ -210,6 +230,9 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
>   {
>   	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL0),	tpidr_el0);
>   	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
> +
> +	if (ctxt_has_accdata(ctxt))
> +		write_sysreg_s(ctxt_sys_reg(ctxt, ACCDATA_EL1), SYS_ACCDATA_EL1);
>   }
>   
>   static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 2775ba3359cfe..f01719bbd6037 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -49,6 +49,7 @@ HAS_LPA2
>   HAS_LSE_ATOMICS
>   HAS_LS64
>   HAS_LS64_V
> +HAS_LS64_ACCDATA
>   HAS_LSUI
>   HAS_MOPS
>   HAS_NESTED_VIRT


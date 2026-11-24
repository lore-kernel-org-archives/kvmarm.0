Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521613;
	b=1j6fGuLonIS4aM5kX81HdFDG5D49PYruHbQ2aEKOiw+O1n9EbA2cFcyDXLhTABRTmFNk
	 +KMxEaOHVGZD3dBd3V4A8X6b7Pypvnon9Vs6ogXQdY8NQSwOg8E5yyn9F11iFa+R3FLUf
	 r5/cU0w0vibF27yQhgj5FzDuTcocq4HBs8hJ48vjZvADi+VZF/1Q6wj1HNWV80duTy4H2
	 9GuX+nGquneoa3hExBOG754oPl5Q+U0tZbrkxQvxDDnnU3/cGcP6od7/MIqsGWPnHyC0c
	 MZ0OwbAOf4lpn90urDFqO/OhYk+fbPxifsIMqeKf6LyDOK2YpUM3UJbzGOZL/YuExYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521613;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=h5wQQ7f1ar5cJYDkFl+pZ9+cYyLrpIguOheOkQ4y6uQ=;
	b=zo5rb2z5PX/fx/iRa+Yhq7cVbTSTTX8r+7mtJK5XLuVHm0WiDHutNW9jqfdPLvox5tDO
	 n+RA+DgCgRitAOaIy4Eqb4VZIfPuxCO0dp6nOmFTLFP96l98RWl4skFI3K21PIlPnDyfn
	 JYvuFVfWR9iVzxzSKGIJP0aV3TPefBMsKEslIf8Wg8sA4lDf0km7n1RwPx54YzYDlhA+T
	 VXpuo5EltNGFNBpaPvL/0P0rLjp4dhUjpLM4uxc3a0zih81mwoWy6dhoaER7PFwtVNXJN
	 DCAH44huTWgTW/iMxGei3ZWyQn5YXStZv0dGf/ntrJ6prnb34PWo9kHZmBYjiNP0v1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=lsDcQAN9;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FF5606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 12:00:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80FF5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=lsDcQAN9
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAF4B339;
	Tue, 24 Nov 2026 04:00:07 -0800 (PST)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2BF83F86F;
	Tue, 24 Nov 2026 04:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795521610; bh=jiz/KmB886ULkylTGCTD9Mfzgphbfa2Ch+aTgzZXGJs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lsDcQAN9sHDwXQ6eWQr9134ntQyDSsW5CnsxVZ6SCvBf0jx100UN/4sOY3u1U0wuI
	 ZUY1xcd9mFzsztUbL2ibphYi/8JWrSvrPVp/fYaQ23PG26IqIkKAg3EE10oadM8TFu
	 UhgFsUleZ0qIUC925PscD8dMiHpwCZWmtXEIXCmI=
Message-ID: <2576e9e5-395e-4842-aa83-e09494e97d4d@arm.com>
Date: Tue, 24 Nov 2026 12:00:06 +0000
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
Subject: Re: [PATCH v5] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
 implemented
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>, Xi Ruoyao <xry111@xry111.site>,
 Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Gavin Shan <gshan@redhat.com>, Yuan Yao <yaoyuan@linux.alibaba.com>,
 Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261102095656.2948964-1-fuad.tabba@linux.dev>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20261102095656.2948964-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 02/11/2026 09:56, Fuad Tabba wrote:
> finalise_el2_state() clears the EL2 MPAM traps on every CPU whose ID
> registers advertise MPAM once the arm64.nompam override is applied.
> KVM sets them again on guest entry only when ARM64_MPAM is set, a
> capability that also requires MPAM1_EL1.MPAMEN. Without EL3, only
> MPAM2_EL2.MPAMEN is writable, and the kernel never sets it, so
> ARM64_MPAM stays clear and so do the traps. A guest can then access
> MPAM0_EL1, MPAM1_EL1, MPAMSM_EL1 and MPAMIDR_EL1 while its
> ID_AA64PFR0_EL1.MPAM reads 0.
> 
> Record two per-CPU flags at KVM's CPU init: whether MPAM is
> implemented as finalise_el2_state() tests it, and whether
> MPAMIDR_EL1.HAS_HCR is set (MPAMHCR_EL2 is UNDEFINED without it).
> Read ID_AA64PFR0_EL1, ID_AA64PFR1_EL1 and MPAMIDR_EL1 from cpu_data,
> which holds them with the overrides applied since commit 342e62ded77c6
> ("arm64: cpufeature: Read MPAMIDR_EL1 in __cpuinfo_store_cpu()"). Set

Ok as long as this patch isn't expected to be backported.

> the traps from those flags. MPAMEN isn't part of any MPAM trap
> condition, so the traps take effect whether or not it is set.
> 
> Fixes: 31ff96c38ea3 ("KVM: arm64: Fix missing traps of guest accesses to the MPAM registers")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>


Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

> ---
> 
> Notes:
>     Changes since v4:
>      - Take ID_AA64PFR0_EL1, ID_AA64PFR1_EL1 and MPAMIDR_EL1 from cpu_data
>        (was __read_sysreg_by_encoding() and read_sysreg_s()).
>      - Commit message tightened, and the TIDR comment no longer
>        rewritten.
>      - Ben's Reviewed-by dropped, since the probe changed.
>      - Rebased on 7.4-rc1.
>     
>     Based on Linux 7.4-rc1 (6628e7d4c6b25).
>     
>     v4: https://lore.kernel.org/all/20260924165329.1684155-1-fuad.tabba@linux.dev/
>     v3: https://lore.kernel.org/all/20260911104715.307500-1-fuad.tabba@linux.dev/
>     v2: https://lore.kernel.org/all/20260908145651.2828597-1-fuad.tabba@linux.dev/
>     v1: https://lore.kernel.org/all/20260903160819.831518-1-fuad.tabba@linux.dev/
> 
>  arch/arm64/include/asm/kvm_host.h       |  2 ++
>  arch/arm64/kvm/arm.c                    | 12 ++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  8 ++++----
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 97332ffcb1300..d6b9538cbec36 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -839,6 +839,8 @@ struct kvm_host_data {
>  #define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		4
>  #define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		5
>  #define KVM_HOST_DATA_FLAG_HAS_BRBE			6
> +#define KVM_HOST_DATA_FLAG_HAS_MPAM			7
> +#define KVM_HOST_DATA_FLAG_HAS_MPAM_HCR			8
>  	unsigned long flags;
>  
>  	struct kvm_cpu_context host_ctxt;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 157bf4b812020..5bab4833c9d33 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -32,6 +32,7 @@
>  #include <asm/mman.h>
>  #include <asm/tlbflush.h>
>  #include <asm/cacheflush.h>
> +#include <asm/cpu.h>
>  #include <asm/cpufeature.h>
>  #include <asm/virt.h>
>  #include <asm/kvm_arm.h>
> @@ -2496,9 +2497,20 @@ static void cpu_set_hyp_vector(void)
>  
>  static void cpu_hyp_init_context(void)
>  {
> +	struct cpuinfo_arm64 *info = this_cpu_ptr(&cpu_data);
> +	u64 pfr0 = info->reg_id_aa64pfr0;
> +	u64 pfr1 = info->reg_id_aa64pfr1;
> +
>  	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
>  	kvm_init_host_debug_data();
>  
> +	/* cpu_data has the overrides applied, as finalise_el2_state() does. */
> +	if (id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1)) {
> +		host_data_set_flag(HAS_MPAM);
> +		if (info->reg_mpamidr & MPAMIDR_EL1_HAS_HCR)
> +			host_data_set_flag(HAS_MPAM_HCR);
> +	}
> +
>  	if (!is_kernel_in_hyp_mode())
>  		cpu_init_hyp_mode();
>  }
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e0c55644224cb..f487d3a93fe27 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -298,11 +298,11 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
>  	u64 clr = MPAM2_EL2_EnMPAMSM;
>  	u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
>  
> -	if (!system_supports_mpam())
> +	if (!host_data_test_flag(HAS_MPAM))
>  		return;
>  
>  	/* trap guest access to MPAMIDR_EL1 */
> -	if (system_supports_mpam_hcr()) {
> +	if (host_data_test_flag(HAS_MPAM_HCR)) {
>  		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
>  	} else {
>  		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
> @@ -317,12 +317,12 @@ static inline void __deactivate_traps_mpam(void)
>  	u64 clr = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1 | MPAM2_EL2_TIDR;
>  	u64 set = MPAM2_EL2_EnMPAMSM;
>  
> -	if (!system_supports_mpam())
> +	if (!host_data_test_flag(HAS_MPAM))
>  		return;
>  
>  	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
>  
> -	if (system_supports_mpam_hcr())
> +	if (host_data_test_flag(HAS_MPAM_HCR))
>  		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
>  }
>  
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4


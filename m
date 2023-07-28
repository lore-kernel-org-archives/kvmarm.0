Received: from out-107.mta1.migadu.com (out-107.mta1.migadu.com [95.215.58.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161C5156D2
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:26:59 +0000 (UTC)
Date: Fri, 28 Jul 2023 17:26:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690565218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JjPRYfaaVZj6od9S4f1dY2TX29itGG1Kz5FzJSCjOZ4=;
	b=QT7pSrGwqR6PrTh/VyyTZz7nb6f1yqTwnLpA49oeInTAAHgIiavo4rICblFVNaDOXfuvIN
	Z11YQ8O4rp4BtWJ7iPS/J0Wm9jzgmsDaOggqou93l68zdvEgnaLG1JnakhJuk95dSpfFVO
	hnVJf4ylsJ+DVLe4uAU0hPnDbh+51AI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 13/26] KVM: arm64: Restructure FGT register switching
Message-ID: <ZMP6XBfPrgKMQ/ik@linux.dev>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-14-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728082952.959212-14-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

Looks good, just a typo to fix.

On Fri, Jul 28, 2023 at 09:29:39AM +0100, Marc Zyngier wrote:
> As we're about to majorly extend the handling of FGT registers,
> restructure the code to actually save/restore the registers
> as required. This is made easy thanks to the previous addition
> of the EL2 registers, allowing us to use the host context for
> this purpose.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> -static inline void __activate_traps_hfgxtr(void)
> +static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>  	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
> +	u64 r_val, w_val;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +		return;
> +
> +	ctxt_sys_reg(hctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
> +	ctxt_sys_reg(hctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
>  
>  	if (cpus_have_final_cap(ARM64_SME)) {
>  		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
> @@ -98,26 +97,31 @@ static inline void __activate_traps_hfgxtr(void)
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>  		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
>  
> -	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
> -	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
> +
> +	/* The default is not to trap amything but ACCDATA_EL1 */

typo: anything

-- 
Thanks,
Oliver

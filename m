Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67AB27A906
	for <kvmarm@lists.linux.dev>; Mon, 22 Sep 2025 23:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758583648; cv=none; b=gCWnu2fehJzPaVw3ME4cBQ0HIe/JpPnpS/EpOxiu91SmgP8YOTZeuLi+QEu6QMhi2wDkyK011kdBQvGnsj0C58bwSyLMI21SganzAAUQX+mUG0McWlI1PjmkMHD8ecd7m6Yz0ld8atspv5VVUkCFhx9lItTUCTD9tZgYRW31+es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758583648; c=relaxed/simple;
	bh=ZXX+CFA0G/zoD33DMEjaMH/vL172/ljPCfyp5hx8hHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oHqxeyOexDlNpMyKxvuZAVdxiEVEtIXmyJnr4UYWIhIQ0chwXt5Xy75+aagMSqREyzs6liTVntP7LZkmCqqzx9a9PO9aO1MsoqydlCYpge2lr4F2UEZfJoljKOaK+A+LOJq8r2WT9O7GjSQWzmgxY8pA/PraPCAx8Sa6c6Qngiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L2GvIUii; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L2GvIUii"
Date: Mon, 22 Sep 2025 16:27:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758583644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dq7+iioGGBjdY4sZUiiwAdtrKxyUAcd9xWPR2FHx19w=;
	b=L2GvIUiiyYrNMbg/rAqi2PZY32HhmJC1v8/9oNKOpk0DSAxUJSxTSE5F/EiqZfPx4CpGmh
	bl0OxUFnk/j4FYgOmLza+Znwlrh0zg1DjJN5firsACIogIVIu1CTxTC1d322T7mC/krIOI
	ChBHzIZcP7FoSBkjhM/EkTC97tUUGQE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Priscilla Lam <prl@amazon.com>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, dwmw@amazon.co.uk, gurugubs@amazon.com,
	christoffer.dall@arm.com, graf@amazon.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Implement KVM_TRANSLATE ioctl for arm64
Message-ID: <aNHbUqTi4nOK_w5I@linux.dev>
References: <20250922202452.45810-1-prl@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922202452.45810-1-prl@amazon.com>
X-Migadu-Flow: FLOW_OUT

Hi Priscilla,

On Mon, Sep 22, 2025 at 01:24:52PM -0700, Priscilla Lam wrote:
> There is a KVM_TRANSLATE ioctl for x86 to translate a GVA
> (guest virtual address) to a GPA (guest physical address) in EL1
> which is not yet implemented for arm64.
> 
> Implement KVM_TRANSLATE on arm64 for both configurations that
> support and do not support VHE. The VHE path uses the AT
> instruction directly while the non-VHE implementation wraps the
> AT call in a hypercall to allow for its execution in EL2. Add
> selftest that tests the ioctl in both configurations.
> 
> Signed-off-by: Priscilla Lam <prl@amazon.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |   2 +
>  arch/arm64/kvm/guest.c                        |  89 ++++++++++++++-
>  arch/arm64/kvm/hyp/nvhe/Makefile              |   3 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  10 ++
>  arch/arm64/kvm/hyp/nvhe/translate.c           |  84 ++++++++++++++
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  tools/testing/selftests/kvm/arm64/translate.c | 107 ++++++++++++++++++

Please do selftests changes in a separate patch.

> +static int kvm_translate_vhe(struct kvm_vcpu *vcpu, struct kvm_translation *tr)

So arch/arm64/kvm/at.c exists for this exact purpose: walking guest page
tables. While it was previously constrained to handling NV-enabled VMs,
Marc's SEA TTW series opens up the stage-1 walker for general use.

I am not keen on adding yet another page-table walker implementation for
the sole purpose of servicing this ioctl.

https://lore.kernel.org/kvmarm/175845226586.1792635.11249464012956393475.b4-ty@kernel.org

> +{
> +	unsigned long flags;
> +	uint64_t hcr_old, hcr_new, par;
> +	const uint64_t gva = tr->linear_address;

"linear_address" is a delightful x86-ism. I'd prefer naming that was
either architecture-generic -or- an arm64-specific struct that used our
architectural terms.

> +	preempt_disable();
> +	local_irq_save(flags);
> +
> +	/* Ensure we're in the expected VHE regime and enable S2 so PAR returns IPA. */
> +	hcr_old = read_sysreg(hcr_el2);
> +	hcr_new = hcr_old | HCR_E2H | HCR_VM;
> +	hcr_new &= ~HCR_TGE;
> +	write_sysreg(hcr_new, hcr_el2);
> +	isb();

Thanks to borken hardware, this needs to go through the write_sysreg_hcr()
accessor.

> +
> +	/* Load guest EL1 S1 context into *_EL12 (do not write into _EL1). */
> +	write_sysreg_s(vcpu_read_sys_reg(vcpu, TTBR0_EL1), SYS_TTBR0_EL12);
> +	write_sysreg_s(vcpu_read_sys_reg(vcpu, TTBR1_EL1), SYS_TTBR1_EL12);
> +	write_sysreg_s(vcpu_read_sys_reg(vcpu, TCR_EL1), SYS_TCR_EL12);
> +	write_sysreg_s(vcpu_read_sys_reg(vcpu, MAIR_EL1), SYS_MAIR_EL12);
> +	write_sysreg_s(vcpu_read_sys_reg(vcpu, SCTLR_EL1), SYS_SCTLR_EL12);

KVM supports both FEAT_S1PIE and FEAT_S1POE, so this is not a complete
MMU context.

> +	/* Check address read */
> +	asm volatile("at s1e1r, %0" :: "r"(gva));
> +	isb();

The AT instruction can generate an exception, which is why __kvm_at()
exists.

And this is where reusing the existing translation infrastructure is
really important. The AT instruction *will* fail if the stage-1
translation tables are unmapped at stage-2. The only option at that
point is falling back to a software table walker that potentially faults
in the missing translation tables.

> +
> +	par = read_sysreg(par_el1);
> +	if (!(par & 1)) {
> +		tr->valid = true;
> +		tr->physical_address = par_to_ipa(par, gva);

What about permissions besides RW?

> +int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu, struct kvm_translation *tr)
> +{
> +	if (has_vhe())
> +		return kvm_translate_vhe(vcpu, tr);
> +	else
> +		return kvm_translate_nvhe(vcpu, tr);
>  }

Yet another interesting consideration around this entire infrastructure
is the guest's view of the translation that the VMM will now use. KVM uses a
pseudo-TLB for the guest's VNCR page and maintains it just like a literal
TLB.

How would the guest invalidate the translation fetched by the VMM when
unmapping/remapping the VA? Doesn't the stage-1 PTW need to set the
Access flag as this amounts to a TLB fill?

Understanding what it is you're trying to accomplish would be quite
helpful. I'm concerned this trivializes some of the gory details of
participating in the guest's virtual memory.

Thanks,
Oliver

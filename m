Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A28361973
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790354047; cv=none; b=BDuugiLpSI/04WQAMbHedRGe8bh2BB4g+04RFXDB/3daRcIMEPdpOYPVL8BOhjuOMkAUAg3IVKmv/H/we6KUzbFmvTnPUUrWqriJ8O+lwWV7K8dzVbpk/8sFprrxn6wTr4npZVYPFXb4hoBExB3mYY090HIKU4E0c/5WiLR5Seg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790354047; c=relaxed/simple;
	bh=z1MMBW/k+eb49Qcp/2rEAdku+hrMenCSSpsg1SGiR6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CTXT9mnl2e+6GOJoHJy8R/TfTD3xdW3ELmitKfs2R0N/M+kPbXmDgj0CGHE4JhlJbvWjgL9l3YTrYV1t8vSXdNIIrvtiQ8QwA+hGJ6fZUa87xo9ZBbkmDfcYHdwKcQ+PXvrIRwF1w7nnL1rm0ueYSGN5NCeda+V3D3C5J/gpFac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UAfsBFPJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UAfsBFPJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C1EA169C;
	Fri, 25 Sep 2026 09:34:01 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 135E43F86F;
	Fri, 25 Sep 2026 09:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790354044; bh=z1MMBW/k+eb49Qcp/2rEAdku+hrMenCSSpsg1SGiR6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UAfsBFPJw7gPQ3SEOl4sjuq+C4NIG+QvCaZyg5xh4qIysSIbcRSEWQXPZRw7Fochj
	 QgIzag8v8ZZWI5/+gZdT244vkTar1eEHFB7IiJDATTpjYHuxBDiRhIAozS9FgV9+vC
	 DxiQY9F6qIxqeuSBpJwiOlUSIdCnvf77/QH7Af/Q=
Date: Fri, 25 Sep 2026 17:33:47 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Fuad Tabba <tabba@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/4] KVM: arm64: Don't WARN on an unsupported TLBI OS
 from vEL1
Message-ID: <qn2q3e3hagurkljew23gnpbf5xg5dwagzzujw4z5c7vutyic3x@fvhragb3jlz6>
References: <20260925090619.852995-1-fuad.tabba@linux.dev>
 <20260925090619.852995-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925090619.852995-2-fuad.tabba@linux.dev>

On Fri, Sep 25, 2026 at 10:06:16AM +0100, Fuad Tabba wrote:
> A VMM can trigger the WARN_ON(!vcpu_is_el2()) in handle_tlbi_el1() on a
> CPU with FEAT_EVT2 and FEAT_TLBIOS but no FEAT_FGT, by setting
> ID_AA64ISAR0_EL1.TLB to NI and having the guest execute TLBI VMALLE1OS.
> 
> Without FGT, HCR_EL2.TTLBOS traps the instruction. KVM records no FGT
> trap information on such a host, so triage_sysreg_trap() doesn't UNDEF
> it. The instruction reaches handle_tlbi_el1(), which warns before
> checking whether the guest supports it.
> 
> Check support before the warning.
> 
> Fixes: 0cb8aae226768 ("KVM: arm64: nv: Add handling of outer-shareable TLBI operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Looks correct to me:

Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>

> ---
>  arch/arm64/kvm/sys_regs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d7..0ce29ce678b08 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4257,6 +4257,10 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  {
>  	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
>  
> +	/* Without FGT, HCR_EL2.TTLBOS also traps a hidden TLBI OS from vEL1 */
> +	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding))
> +		return undef_access(vcpu, p, r);
> +
>  	/*
>  	 * If we're here, this is because we've trapped on a EL1 TLBI
>  	 * instruction that affects the EL1 translation regime while
> @@ -4279,9 +4283,6 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  
>  	WARN_ON(!vcpu_is_el2(vcpu));
>  
> -	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding))
> -		return undef_access(vcpu, p, r);
> -
>  	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)) {
>  		kvm_handle_s1e2_tlbi(vcpu, sys_encoding, p->regval);
>  		return true;
> -- 
> 2.39.5
> 

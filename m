Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C431F1507
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 13:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745329819; cv=none; b=OOvVT2+REYTPPbivgxWxvxsZSCadGlxA682UKp3QGplEr2X+LjuFyZAwYX4C3fxp6DPY8rWkiZNSRC3gjAc5AvLZ/Ebr734/LRxqxDm/546dBU5FomNxTuVxEDUPIy2KFcESDxqioGrv6CZGgwYxmK+nE5ouih6AOZKmKEIuRSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745329819; c=relaxed/simple;
	bh=0IrOnZ3RBDi28F2g36bNAAX/rOePU/eP1D6gPIzMSiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igqrD7AsGS4bC61Cj5BV6PAImEmRVuk5QRCau6OBbHIbJ+MFEpaowryyNRD0P+CYUi8gXtRdQnFhsEGr7n0efbi803bynAtca8t51X5Hj59G6UarVTLNG8p30Yw8AIPE6az0OACgNlwxwPaV4XO6jQz1sbxZ1eRqxJViUcV8tQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CD1E152B;
	Tue, 22 Apr 2025 06:50:11 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C0A03F5A1;
	Tue, 22 Apr 2025 06:50:14 -0700 (PDT)
Date: Tue, 22 Apr 2025 14:50:08 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Teach address translation about access
 faults
Message-ID: <20250422135008.GA747658@e124191.cambridge.arm.com>
References: <20250422122612.2675672-1-maz@kernel.org>
 <20250422122612.2675672-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422122612.2675672-3-maz@kernel.org>

On Tue, Apr 22, 2025 at 01:26:11PM +0100, Marc Zyngier wrote:
> It appears that our S1 PTW is completely oblivious of access faults.
> Teach the S1 translation code about it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 3a4568e2de910..c40583edebc4f 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -456,6 +456,11 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	if (check_output_size(desc & GENMASK(47, va_bottom), wi))
>  		goto addrsz;
>  
> +	if (!(desc & PTE_AF)) {
> +		fail_s1_walk(wr, ESR_ELx_FSC_ACCESS_L(level), false);
> +		return -EACCES;
> +	}
> +
>  	va_bottom += contiguous_bit_shift(desc, wi, level);
>  
>  	wr->failed = false;
> @@ -1209,7 +1214,8 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>   * If the translation is unsuccessful, the value may only contain
>   * PAR_EL1.F, and cannot be taken at face value. It isn't an
>   * indication of the translation having failed, only that the fast
> - * path did not succeed, *unless* it indicates a S1 permission fault.
> + * path did not succeed, *unless* it indicates a S1 permission or
> + * access fault.
>   */
>  static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  {
> @@ -1312,19 +1318,29 @@ static bool par_check_s1_perm_fault(u64 par)
>  		 !(par & SYS_PAR_EL1_S));
>  }
>  
> +static bool par_check_s1_access_fault(u64 par)
> +{
> +	u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
> +
> +	return  ((fst & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_ACCESS &&
> +		 !(par & SYS_PAR_EL1_S));
> +}
> +
>  void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  {
>  	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
>  
>  	/*
> -	 * If PAR_EL1 reports that AT failed on a S1 permission fault, we
> -	 * know for sure that the PTW was able to walk the S1 tables and
> -	 * there's nothing else to do.
> +	 * If PAR_EL1 reports that AT failed on a S1 permission or access
> +	 * fault, we know for sure that the PTW was able to walk the S1
> +	 * tables and there's nothing else to do.
>  	 *
>  	 * If AT failed for any other reason, then we must walk the guest S1
>  	 * to emulate the instruction.
>  	 */
> -	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
> +	if ((par & SYS_PAR_EL1_F) &&
> +	    !par_check_s1_perm_fault(par) &&
> +	    !par_check_s1_access_fault(par))
>  		par = handle_at_slow(vcpu, op, vaddr);
>  
>  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);

Reviewed-by: Joey Gouly <joey.gouly@arm.com>


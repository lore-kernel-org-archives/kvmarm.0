Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273791;
	b=eV2ZQQAP6ccWAzGHbrBxiVh23G1VBAcsI45EEF1DacZyggipAmxD/mcAV7zZ9jH8elwO
	 k7qzUFsyRNpA6hbYN3zQpicZfuglfF9qM3y3LgAaKTjBrW0G/B7a0+zG+Yd5eDPm99A+s
	 0s8X3xOXYFQ13rPwsrD4P4MF1S2YQ0ytMJ/k+hdbV1k5OcdQtSf18TgFglQTS+urMSE7f
	 KR3hGTiPxpq75UbbqludpqEYXhdK7m8ddMBA753TAWqPOAefNZ7Cza2ovAON0abWqt6L6
	 31wlEL/Ar9enaxLQOxUzIueOb9Wxb7kgLoAvsRsEFxq9dTwGHigzeyoA/YHnE6T6E/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273791;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=EONOj0OHaUwSYU9N/VrCCNs20gpUnplCCd7yehPjBGA=;
	b=zIZcsvPrzAv1ZCUlaHGL1N07q8dKj+zeScawAXgbaK15rWjGbOmuzIDYu92qKncdGGFl
	 moaqSySmGxztxVHkm6zMxhut/ARUeDKgYmEOUh30cTS6mqJObdxokYIzz14q1dqDssgcV
	 n0NEVwsomqetVDm5+mHHROoUhW9sbxN1LjE+zxD7zizH7HdC+oOZc8by89xg0CWXnczut
	 IopBrN6HNiN/3lunMU26IdDFgOpSHJcDUh1P5LhxcJj9lWESZcRs0nmgyGQSswWgQ80kY
	 Zlt9Y7wACQb+yvud4rCbjywKBjvWB6qDPtayzps+FuK1itY38yxkBs1UnSRzD/HvVjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="KjZbwEu/";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A1D606A31A
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 11:36:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3A1D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KjZbwEu/
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E03931BB2;
	Thu, 29 Oct 2026 04:36:25 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F6E83F59E;
	Thu, 29 Oct 2026 04:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793273789; bh=dTGDCsCEyj7FTwEr3QOxyYhJdKuSWQypWjxORP+0gqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KjZbwEu/7pDEST1UcOZipx4PNL9nNtV9k4JfrRVNhaXNfLarV45iCTWV4XZJHtYBg
	 7Qp8V4vg0BATp9y3eKpby/88Kdy0oRFzOenzdRcLRn8qQk5gAomlm+R8fdT7xSPCqV
	 SKKx4Ybb/qFPlXDLhYwX4++/hczTt+/4/Xj4mTiw=
Date: Thu, 29 Oct 2026 11:36:17 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	James Clark <james.clark@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Thomas Huth <thuth@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Reset TCR_EL2 according to guest's
 E2H mode
Message-ID: <auMvsSOJ7canv8lh@e143914.arm.com>
References: <20260917214215.74135-1-weilin.chang@arm.com>
 <20260917214215.74135-4-weilin.chang@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917214215.74135-4-weilin.chang@arm.com>

On Thu, Sep 17, 2026 at 10:42:13PM +0100, Wei-Lin Chang wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Previously vCPU TCR_EL2's reset value didn't consider TCR_EL2's
> different formats based on the value of HCR_EL2.E2H. It always resets to
> the E2H == 0 version.
> 
> This didn't cause any problem because the bits set in the E2H == 0
> version (TCR_EL2_RES1) all reset to UNKNOWN for E2H == 1 per the
> architecture.
> 
> Still, it's better to fix it. Choose the correct reset value by checking
> KVM_ARM_VCPU_HAS_EL2_E2H0.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/sys_regs.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d..62c059747fbb 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3275,6 +3275,14 @@ static u64 reset_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	return vcpu->kvm->arch.nr_pmu_counters;
>  }
>  
> +static u64 reset_tcr_el2(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	__vcpu_assign_sys_reg(vcpu, r->reg,
> +			      vcpu_has_feature(vcpu, KVM_ARM_VCPU_HAS_EL2_E2H0) ?
> +			      TCR_EL2_RES1 : VHE_TCR_EL2_RES1);
> +	return __vcpu_sys_reg(vcpu, r->reg);
> +}
> +
>  /*
>   * Architected system registers.
>   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> @@ -3853,7 +3861,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
>  	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
> -	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
> +	EL2_REG(TCR_EL2, access_rw, reset_tcr_el2, 0),
>  	EL2_REG_FILTERED(TCR2_EL2, access_rw, reset_val, TCR2_EL2_RES1,
>  			 tcr2_el2_visibility),
>  	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
> -- 
> 2.43.0
> 

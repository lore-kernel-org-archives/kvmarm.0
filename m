Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E86178CDE
	for <kvmarm@lists.linux.dev>; Tue,  8 Oct 2024 09:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728379873; cv=none; b=e1NbrUunSnydim1ojDwMlbDs4jv0TcwlMdsjVbZGNw6UywjbQj/tf+Ib99sOzbqFlUIvXzcAOqSkUOXqThi8HP4tMJ/hBj2DorBKtisDQIRobGCVOlgOWWQXmuY16m293LkAgJ1v79z9d3mo/MfGM7AgUqWWyY+afh5GORqSpIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728379873; c=relaxed/simple;
	bh=b9RTzeR57UOTEqw72jIpxGvD10dfbOkvkljL/g9Ddbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLmJfz7tLofJpCv5dgMgZigBMocCrN6DCQ657YFtDX/j1ArlJWTRxQFGtPG36yEdNEnow78LESx+kHxf9Y0rRDC+HhPAoWbZM95fI1HUEpk+AsW2BvH7IRpFgZfAmIM2nRH/s6mlLJRggu2pQBpNb07lOSM2vq97LSSsV7RBL2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29100DA7;
	Tue,  8 Oct 2024 02:31:40 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14EA53F640;
	Tue,  8 Oct 2024 02:31:08 -0700 (PDT)
Date: Tue, 8 Oct 2024 10:31:04 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Expose S1PIE to guests
Message-ID: <20241008093104.GA2623892@e124191.cambridge.arm.com>
References: <20241005-kvm-arm64-fix-s1pie-v1-1-5901f02de749@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241005-kvm-arm64-fix-s1pie-v1-1-5901f02de749@kernel.org>

Hi,

On Sat, Oct 05, 2024 at 12:19:37AM +0100, Mark Brown wrote:
> Prior to commit 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
> we just exposed the santised view of ID_AA64MMFR3_EL1 to guests, meaning
> that they saw both TCRX and S1PIE if present on the host machine. That
> commit added VMM control over the contents of the register and exposed
> S1POE but removed S1PIE, meaning that the extension is no longer visible
> to guests. Reenable support for S1PIE with VMM control.
> 
> Fixes: 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index dad88e31f9537fe02e28b117d6a740f15572e0ba..d48f89ad6aa7139078e7991ce6c8ebc4a0543551 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1550,7 +1550,8 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
>  		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
>  		break;
>  	case SYS_ID_AA64MMFR3_EL1:
> -		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE;
> +		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE |
> +			ID_AA64MMFR3_EL1_S1PIE;
>  		break;
>  	case SYS_ID_MMFR4_EL1:
>  		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
> @@ -2433,6 +2434,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  					ID_AA64MMFR2_EL1_NV |
>  					ID_AA64MMFR2_EL1_CCIDX)),
>  	ID_WRITABLE(ID_AA64MMFR3_EL1, (ID_AA64MMFR3_EL1_TCRX	|
> +				       ID_AA64MMFR3_EL1_S1PIE   |
>  				       ID_AA64MMFR3_EL1_S1POE)),
>  	ID_SANITISED(ID_AA64MMFR4_EL1),
>  	ID_UNALLOCATED(7,5),
> 
> ---

Sorry, silly mistake by me.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256C519AD8D
	for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 10:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723546641; cv=none; b=uV/7m+Ed5h33d7fDL4x7oJLPtIrtB5asHC0Dau/z824k9O9aoBhIKt1ojvCPR03Z1YvsjKUkocqIhB4AFg+KqoF8wbnY3crzY08MzuYFf3UKHX+XRnpjC2xn9P6TpzV4LXEzBDzvlfMo4tC5VMNst3imD+e/aMy+3J9Yig+6bSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723546641; c=relaxed/simple;
	bh=0CM555P4TDe9NXVLbFtgJqoPE81YdUZznXRYeBbk4dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHW/m7EaSeNJeAEulqXYh13R+pPSeDhueNcWE8qDO4+cVRq1E7ul9an3iE5mZNP7e+gJXxHabYiqJok0a2Pba3mm8CLPi5Rqg+RmhZYZzWotmg0FEfSno5pISxAO7Zu98ryr/+XKN1utA0052qHLjjmtNAx3KR0x0x1jcaLcWNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6607012FC;
	Tue, 13 Aug 2024 03:57:44 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AABA3F587;
	Tue, 13 Aug 2024 03:57:17 -0700 (PDT)
Date: Tue, 13 Aug 2024 11:57:10 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 8/8] KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace
 and guests
Message-ID: <20240813105710.GA3154421@e124191.cambridge.arm.com>
References: <20240813104400.1956132-1-maz@kernel.org>
 <20240813104400.1956132-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813104400.1956132-9-maz@kernel.org>

Hello!

On Tue, Aug 13, 2024 at 11:44:00AM +0100, Marc Zyngier wrote:
> Everything is now in place for a guest to "enjoy" FP8 support.
> Expose ID_AA64PFR2_EL1 to both userspace and guests, with the
> explicit restriction of only being able to clear FPMR.
> 
> All other features (MTE* at the time of writing) are hidden
> and not writable.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 51627add0a72..da6d017f24a1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1722,6 +1722,15 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	return val;
>  }
>  
> +static u64 read_sanitised_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
> +					  const struct sys_reg_desc *rd)
> +{
> +	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR2_EL1);
> +
> +	/* We only expose FPMR */
> +	return val & ID_AA64PFR2_EL1_FPMR;
> +}

Wondering why you're adding this function instead of extending __kvm_read_sanitised_id_reg()?

> +
>  #define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
>  ({									       \
>  	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
> @@ -2381,7 +2390,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  		   ID_AA64PFR0_EL1_AdvSIMD |
>  		   ID_AA64PFR0_EL1_FP), },
>  	ID_SANITISED(ID_AA64PFR1_EL1),
> -	ID_UNALLOCATED(4,2),
> +	{ SYS_DESC(SYS_ID_AA64PFR2_EL1),
> +	  .access	= access_id_reg,
> +	  .get_user	= get_id_reg,
> +	  .set_user	= set_id_reg,
> +	  .reset	= read_sanitised_id_aa64pfr2_el1,
> +	  .val		= ID_AA64PFR2_EL1_FPMR, },

Then I think this would just be ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR).

>  	ID_UNALLOCATED(4,3),
>  	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
>  	ID_HIDDEN(ID_AA64SMFR0_EL1),

Thanks,
Joey

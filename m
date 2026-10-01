Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ECC2D238F;
	Thu,  1 Oct 2026 16:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872172; cv=none; b=OrFJCq+g1+FYnoiDZa+UM5iOQm5mzSo2ECjcsm2g4Qg9Ffl30qYTTSDm43uWGt/sBktCVW4z1DfP0qm/ivZTfcGL7pawe2RxLzUWjcc6atCeyPmFnfKnAx9GfodvI59oy9wV2/wHQeAfsdpHKzhJpRCSDKXwQ20eh9JDYUUh6aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872172; c=relaxed/simple;
	bh=7AIf8lTnSPZzMKd0ZIklYylTiiYQOR4tFoz57vWUuLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3AVxO1r1fjZ8fXDWhCqu+s8wuaTEcnV4t0Xb7xdhSklgSDvtGcPIQyW9F57UUSyZaGac5SxGq/xp8O6BcV0ejjnsTPZxP0uIbjInm8sofI7Q355+woN4fXV4DIyZl/RJxkHxDeImOig18RnpyK+hTR/481dSbkp/VRioBHeYoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwIgQsS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwIgQsS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1013C1F000FF;
	Thu,  1 Oct 2026 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790872171;
	bh=BuUbaFBNSrrB8IgOuIPv+TnQNAwEe+8kiRexfQtDWws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FwIgQsS42B0bEij1RkBtFxKf/q9IqBVPCfs5ZSeyrhmmPKCQ0E8t1btz3XQ9NY9qi
	 iREcH6z61mzhKSaAQ1B1aysUfFlK80C0ReRx4J/IxrVeFA7EA2jhe8UrJIR9KUKjYa
	 s2drbqjpR/7OD9iYXYIvUv8oBuTWTfSjxlYcX2hchs2k49dj6Ra1Ta7syj5tB0eGOA
	 RY6pGWVxQlbSfaPVLvVLIYXnsab0A1LBxeyQqkCbpV8e0wR1w814h7/1W4p2to03mg
	 nFDEnCHe6sb1gflLnbbXBl2uDBhvrOvjetdUlRF5RzY2pWmsSspFSYkEkOj1ftZHba
	 lMrNHquOnVThA==
Date: Thu, 1 Oct 2026 17:29:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 09/15] KVM: arm64: Allow GCS to be enabled for guests
Message-ID: <ar6J_q6wc7a54rII@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-9-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-9-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:19PM +0100, Mark Brown wrote:
> Now that required functionality for GCS is in place expose
> ID_AA64PFR1_EL1.GCS, allowing guests to be given the feature.
>
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

This looks straightforward and sensible so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/kvm/nested.c   | 3 +--
>  arch/arm64/kvm/sys_regs.c | 5 +++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 3c4fc566eafc..f62d9ab7f31c 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1702,11 +1702,10 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  		break;
>
>  	case SYS_ID_AA64PFR1_EL1:
> -		/* Only support BTI, SSBS, CSV2_frac */
> +		/* Only support GCS, BTI, SSBS, CSV2_frac */
>  		val &= ~(ID_AA64PFR1_EL1_PFAR		|
>  			 ID_AA64PFR1_EL1_MTEX		|
>  			 ID_AA64PFR1_EL1_THE		|
> -			 ID_AA64PFR1_EL1_GCS		|
>  			 ID_AA64PFR1_EL1_MTE_frac	|
>  			 ID_AA64PFR1_EL1_NMI		|
>  			 ID_AA64PFR1_EL1_SME		|
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index faecf4657ec5..5de4ba1bef6b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2193,10 +2193,12 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val)
>  	      SYS_FIELD_GET(ID_AA64PFR0_EL1, RAS, pfr0) == ID_AA64PFR0_EL1_RAS_IMP))
>  		val &= ~ID_AA64PFR1_EL1_RAS_frac;
>
> +	if (!system_supports_gcs())
> +		val &= ~ID_AA64PFR1_EL1_GCS;
> +
>  	val &= ~ID_AA64PFR1_EL1_SME;
>  	val &= ~ID_AA64PFR1_EL1_RNDR_trap;
>  	val &= ~ID_AA64PFR1_EL1_NMI;
> -	val &= ~ID_AA64PFR1_EL1_GCS;
>  	val &= ~ID_AA64PFR1_EL1_THE;
>  	val &= ~ID_AA64PFR1_EL1_MTEX;
>  	val &= ~ID_AA64PFR1_EL1_PFAR;
> @@ -3444,7 +3446,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  				     ~(ID_AA64PFR1_EL1_PFAR |
>  				       ID_AA64PFR1_EL1_MTEX |
>  				       ID_AA64PFR1_EL1_THE |
> -				       ID_AA64PFR1_EL1_GCS |
>  				       ID_AA64PFR1_EL1_MTE_frac |
>  				       ID_AA64PFR1_EL1_NMI |
>  				       ID_AA64PFR1_EL1_RNDR_trap |
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo

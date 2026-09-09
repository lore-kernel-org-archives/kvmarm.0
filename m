Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F81A279DB6
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788971687; cv=none; b=VbRdGK/2Ny0/6I2AYaIYOSXci0sd36Jtyw/y9mc3Ar2yBraGAAur4bDIFPypuKsTIL6p7X/xccauwBRToAUcwZ1fCBiLjXnwDV3445Asg0EzZVel1lTFNvqz4VLVfMc9m505Vmsue7+P3EDiIF9nxecJd+OxsOA+1Jeg3iDKfcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788971687; c=relaxed/simple;
	bh=qOUYammRv9EjNcGeEMpov2EJisgMbi2/GIrImMJBmbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ZF/AmHO3tGBfnNJbarhtNg49W2w88CuphmEZCmCgNbVpNZZEPdE0HLUjIkAxEGwLjjcg3ePmJv70sSMsam8uK0ofZ2mSREeduhuphwp07CVTVZhopSCdKqJx8WqDiDyNZ2D3Qk/lfnmgnYn4zhzNXvZ4vHOKXqRk4HcdGXT/th0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ahXBd+Ct; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ahXBd+Ct"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3A7B1576;
	Wed,  9 Sep 2026 09:34:40 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61F703F7B4;
	Wed,  9 Sep 2026 09:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788971684; bh=qOUYammRv9EjNcGeEMpov2EJisgMbi2/GIrImMJBmbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahXBd+CtAdAUGE7tnGjU8sKS/DnIy1sMSRbI6q74yb7gyVXsUmmuvleGtp1MyOK+1
	 DuxLt0Lk64FBGI7W7XSLwUbieHuQwu9R4LIhwMIFXQlSm2raAcnEFp8YnlAy8Y4+2F
	 Tnic1LYUYx9gA+9HouvrqZFLvKcYOc90ra5LMEyo=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 09/14] KVM: arm64: Allow GCS to be enabled for guests
Date: Wed,  9 Sep 2026 17:34:37 +0100
Message-ID: <aqGKnQZOe6leuXgG@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-9-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-9-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 10:47:07PM +0100, Mark Brown wrote:
> Now that required functionality for GCS is in place expose
> ID_AA64PFR1_EL1.GCS, allowing guests to be given the feature.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/nested.c   | 3 +--
>  arch/arm64/kvm/sys_regs.c | 5 +++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 17123f0b6dab..a9dea85b6192 100644
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

So, IIUC, this is used to filter features for guests that believe to have 
an EL2, and now this allows GCS to be used by them.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1f80c26a9839..fb2c9fd42e24 100644
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

And here it says to only mask the feature bit if it's not available.

IIUC this sanitize function is called when resetting a vcpu, is that right?


> @@ -3444,7 +3446,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  				     ~(ID_AA64PFR1_EL1_PFAR |
>  				       ID_AA64PFR1_EL1_MTEX |
>  				       ID_AA64PFR1_EL1_THE |
> -				       ID_AA64PFR1_EL1_GCS |
>  				       ID_AA64PFR1_EL1_MTE_frac |
>  				       ID_AA64PFR1_EL1_NMI |
>  				       ID_AA64PFR1_EL1_RNDR_trap |
> 

This one looks like to be a mask that's used to compare with 
arm64_ftr_regs[] on arm64_check_features(). That seems to be called on 
set_id_aa64pfr1_el1() which is used when we get an ioclt to set a system 
register.

So, basically, does it use this mask to check if the set value is valid?

(So, 1 for nested, 1 for reset, and one for user trying to set a value?)

If I did not miss anything, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo

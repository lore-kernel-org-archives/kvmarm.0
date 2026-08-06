Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FD83F4845
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 08:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004734; cv=none; b=uUyiTC7TFglJJqiYcgsd6xCaHZapNmPTGs+gFOhaIm2bAoWeJG9M0v7y6A45TWZB/Jrscpf+cjCa/HUHc0BylVshgZTdcv2HzNuoLQRLen8Hy2t5pQJEUD8CGlAY3Ui3fy2cBBV6AkUG25tkNFkTUJlVDTn1dTShnqAMWXTcK2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004734; c=relaxed/simple;
	bh=EtoUC10RvYxFSimpW9zBON3W+wVo+Kuru8pdzr+Zm94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMQ+Rfomg8v9qvrMxsGXSKsFpgGWW0G7hb77Km0y1kI9l2I7haOSyGtZj74PB3vGxqF3KUB9Ckl2uz+avUDsiHv2ub2I58JmXr6q+kKe17CgUKUf0PN7fNHDjI5p6WhVpC6dQ9dNvjNI7co9Jbvr66AMCdOv88hTtdkY/rTdpls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mcxP7Igm; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mcxP7Igm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786004718; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=6n9+tn1FX85xHqa53wOOTAdXVH64YAjilIMF7HdWsJo=;
	b=mcxP7Igm1hPNnZOzVtzFvgx8aT3Cv8t+pEIF9BmY3Omj07iNj5xM8X2KeaasuJ6ZQh2OcCY6N4pTcYe1SuP2GKwcWt8WPKAhI96lhuKOfnPriu7BAFWcjO3WrmSJb9gm6dKRBWwORXIizxwzH/+60JZUQC4182ri4puegrTUcUY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8TPEvo_1786004716;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X8TPEvo_1786004716 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 16:25:17 +0800
Date: Thu, 6 Aug 2026 16:25:16 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Oliver Upton <oupton@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 04/14] KVM: arm64: Ensure GCS memory effects are
 visible
Message-ID: <q2kb7muy5d3rdl2d3pvipggc33xkgq2o7tn6wy6p75qeegas5n@ijikgyexqt74>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
 <20260803-arm64-gcs-v18-4-fd8c40f5ad88@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803-arm64-gcs-v18-4-fd8c40f5ad88@kernel.org>

On Mon, Aug 03, 2026 at 11:56:49PM +0800, Mark Brown wrote:
> In order to allow efficient implementation of GCS implementations are
> permitted to do GCS specific caching, with barriers implicit in stack
> switch operations and GCSB DSYNC as an explicit barrier.  Since we do
> not use GCS in the hypervisor or host kernel the hypervisor cannot rely
> on any barriers being present in vCPU context switches other than those
> it explicitly inserts.  Add explicit barriers when loading and saving
> vCPU state.
>

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/switch.c   | 13 +++++++++++++
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 14 ++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 7318e3e6a5f3..fe8727bf2833 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -301,6 +301,12 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 */
>  	dsb(nsh);
>
> +	/*
> +	 * Ensure any GCS memory effects are visible to this CPU.
> +	 */
> +	if (ctxt_has_gcs(guest_ctxt))
> +		gcsb_dsync();
> +
>  	__kvm_adjust_pc(vcpu);
>
>  	/*
> @@ -345,6 +351,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 */
>  	dsb(nsh);
>
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere.
> +	 */
> +	if (ctxt_has_gcs(guest_ctxt))
> +		gcsb_dsync();
> +
>  	__deactivate_traps(vcpu);
>  	__load_host_stage2();
>
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> index 2431c18f5792..4594992b008c 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -239,6 +239,13 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
>  	if (vcpu_has_nv(vcpu))
>  		dsb(nsh);
>
> +	/*
> +	 * Ensure any GCS memory effects are visible to the incoming
> +	 * vCPU.
> +	 */
> +	if (ctxt_has_gcs(guest_ctxt))
> +		gcsb_dsync();
> +
>  	/*
>  	 * Load guest EL1 and user state
>  	 *
> @@ -299,5 +306,12 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
>  	/* Restore host user state */
>  	__sysreg_restore_user_state(host_ctxt);
>
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere.
> +	 */
> +	if (ctxt_has_gcs(guest_ctxt))
> +		gcsb_dsync();
> +
>  	vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
>  }
>
> --
> 2.47.3
>

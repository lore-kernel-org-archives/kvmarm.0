Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90D93F54D8
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 09:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785404547; cv=none; b=Ju5ViAc8U1aGZ/XiokACUKQk7IbW7FIV3IlQdUel2ZUHITJemjNfBXZEAzoRzLFufVf3CWQjqQwi+NJlR0ClHZe94ycExKoMzf0y5yJqv4ic30r2LwE3yDVF1AB7uDbdoddtgrA66dnYx6uZ0BBWcpembwcn0WgWjNMsIzNC028=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785404547; c=relaxed/simple;
	bh=lHBav+NnSbaievhmsIcyM4nMmorZWzeCuHUGA/WlAUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+Mzke6LmKfvaR5yAM6fRlF+ytSbBtEU5B/hlW3iXh+O9mU+goIcytKQQtU3u7VJLliN4uFw5KmZRkfmCoc815NPfSMbs6//Go+AAd9fthEWXaFZiguQMP9J2QsvmMegK/EsdJFgcw0Aun7eEhITgwZHTbXGO2WBC79rSC5jvlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bvf4P35Z; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bvf4P35Z"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21F751684;
	Thu, 30 Jul 2026 02:42:19 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 901423F763;
	Thu, 30 Jul 2026 02:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785404543; bh=lHBav+NnSbaievhmsIcyM4nMmorZWzeCuHUGA/WlAUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bvf4P35ZuMEw6g5GS4WbbaROy2H5MVn8hCWTX5hoPi10fjAcJRak4SEwjGFv+PawJ
	 IId/lbdJHF2TF9n29cyx3OswKHL1dwPGhZ88DwVyaQ9zRqzHO3xx4MU4Q57S4mV9rg
	 T2mXeYo764JP3APdwbZ5HLfBdtWUQCWYQhH42/rw=
Date: Thu, 30 Jul 2026 10:42:16 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v4 03/29] KVM: arm64: Merge guest's HCRX_EL2 using
 NV_HCRX_GUEST_EXCLUDE
Message-ID: <amscW_LCL_5RkJFQ@e143914.arm.com>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730071022.296811-4-maz@kernel.org>

On Thu, Jul 30, 2026 at 08:09:56AM +0100, Marc Zyngier wrote:
> The way we merge the guest-provided HCRX_EL2 value with the host's
> is bonkers. We try to make it look like the FGT registers by using
> positive and negative polarities for traps, but most of these bits
> are not strictly about trapping, as they actively change the way
> some architectural state is managed.
> 
> It would be far better to deal with these bits like we do for
> HCR_EL2, by enumerating the list of bits we don't allow the guest
> to override. This is simplified by the fact that HCRX_EL2 only
> affects EL1, and not EL2.
> 
> Re-jig the HCRX_EL2 handling with a macro that list the bits excluded
> from the merge (TMEA, PTTWI, EnIDCP128).
> 
> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 4bf624a49591d..8e5f492f39086 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -325,6 +325,24 @@ static inline void __deactivate_traps_mpam(void)
>  		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
>  }
>  
> +/*
> + * Just like for HCR_EL2, we can't let the guest mess with some of the
> + * basics we rely on in HCRX_EL2. However, the major difference is that
> + * HCRX_EL2 only affects EL1, and never EL2 (sudden outburst of sanity, I
> + * guess). So it is always the guest inflicting it on its own guestx.

Unsure if "guestx" is a typo or a funny way of saying guest's HCRX_EL2!

> + *
> + * Things we don't want to let the guest control are:
> + *
> + * - TMEA: That's for us to decide how an SEA is routed, not the guest.
> + *
> + * - PTTWI: Similarly, it is for us to decide whether Reduced Coherency for
> + *   the PTW is a thing. It really isn't.
> + *
> + * - EnIDCP128: We don't allow IMPDEF sysregs -- full stop.
> + */
> +#define NV_HCRX_GUEST_EXCLUDE	(HCRX_EL2_TMEA	    | HCRX_EL2_PTTWI | \
> +				 HCRX_EL2_EnIDCP128)
> +
>  static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
> @@ -350,8 +368,8 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  		u64 hcrx = vcpu->arch.hcrx_el2;
>  		if (is_nested_ctxt(vcpu)) {
>  			u64 val = __vcpu_sys_reg(vcpu, HCRX_EL2);
> -			hcrx |= val & __HCRX_EL2_MASK;
> -			hcrx &= ~(~val & __HCRX_EL2_nMASK);
> +			hcrx |= (val & ~NV_HCRX_GUEST_EXCLUDE);
> +			hcrx &= ~(~val & ~NV_HCRX_GUEST_EXCLUDE);
>  		}
>  
>  		ctxt_sys_reg(hctxt, HCRX_EL2) = read_sysreg_s(SYS_HCRX_EL2);

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

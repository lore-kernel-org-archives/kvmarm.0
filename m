Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F1C2405F8
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762541633; cv=none; b=pek1T9XTzoEGLRqPfUBvP2H4jqNeBApkqd5hlOC3dVhsPG/dX5VS8N5Fg/CUVSxPwWnXQ6eOBrkpmgqx0JNke9EGdAg79HEJiFJPF4XSR0SavhOWtP2drkJYnhXgocu7jQg1IPHcjSQxmihmJ8nEbtOr5ywBExFIvTrohMhyAIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762541633; c=relaxed/simple;
	bh=RIXw7Xojbsu8fNwBlN6lueulv3Ht7IrJjqveZA3dqNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EteR05/O0xXGreaib6NIm6S1oNQlYudkqJl0HluIOPQ/aoOdHg7wSL0Er5BVDCvk+C6W5j51k/Vquqw9wc8J0jn7yZfIZ4dN8T8srw1Le+bOSjaubAri3Nsy6EJtp9t0o+jvvjZTOvM4HL5PQZK4L1DuEXEuovyvThc+qhMmF5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBHo2vDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBHo2vDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F137EC116C6;
	Fri,  7 Nov 2025 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762541632;
	bh=RIXw7Xojbsu8fNwBlN6lueulv3Ht7IrJjqveZA3dqNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SBHo2vDvH4Ug3Szqt6A3FavNSuCOZhtpLXYvwGvZHgJczlRDIv1z54KWDtLFpuNRX
	 34kFzDIOOT1RLXivNfvn1S8lTiiMR5kPRBlTumU7ayO7tFUP9DfUZGvcQgY2A79CRv
	 oGWnH0fLyQdU3s4CPQ6cZv0l7HAyueYMsxdRKxM8+I7x7MxP9+5SiuilTYUd1v5E7z
	 ju4H+mZAvigE19A8s2087AgWOC7xd9wDFq8WGUr3S8BIT7l0HDwWZK3vlPhLp3fREC
	 lDUM7y2h3xb8MZEE09Aejtiy6o1xJ74UV5/oV/ALYK9UBjcuiTYHgIyyG0Sld35lqB
	 uE1lEYc+ANadg==
Date: Fri, 7 Nov 2025 10:53:50 -0800
From: Oliver Upton <oupton@kernel.org>
To: Zhou Wang <wangzhou1@hisilicon.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	yangyccccc@gmail.com, prime.zeng@hisilicon.com, xuwei5@huawei.com
Subject: Re: [PATCH v7 6/7] KVM: arm64: Enable FEAT_{LS64, LS64_V} in the
 supported guest
Message-ID: <aQ5APpLg0Elv4YoH@kernel.org>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-7-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107072127.448953-7-wangzhou1@hisilicon.com>

Hi Zhou,

On Fri, Nov 07, 2025 at 03:21:26PM +0800, Zhou Wang wrote:
> From: Yicong Yang <yangyicong@hisilicon.com>
> 
> Using FEAT_{LS64, LS64_V} instructions in a guest is also controlled
> by HCRX_EL2.{EnALS, EnASR}. Enable it if guest has related feature.
> 
> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>

The ordering of this patch is incorrect as patch #5 has the side-effect
of exposing ID_AA64ISAR1_EL1.LS64 to KVM guests. This one should come
first instead.

Thanks,
Oliver

> ---
>  arch/arm64/include/asm/kvm_emulate.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index bab967d65715..29291e25ecfd 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -695,6 +695,12 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>  
>  		if (kvm_has_sctlr2(kvm))
>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_SCTLR2En;
> +
> +		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnALS;
> +
> +		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>  	}
>  }
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> -- 
> 2.33.0
> 
> 

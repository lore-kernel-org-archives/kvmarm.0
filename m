Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1302F84F
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 00:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784074638; cv=none; b=I5Ob1qUKNeITLiz1RQngcT/9MrkV1htkqv6i4veeO1z9NX2dlE4eAL/aByZrgawXLgl2qxa6QE5OKOkS4ouKT+tdsFwgNmZWA0p6CxxuVtx22jWQptzlGOtLpYpZrAGBVWkQzbWX9Uf91eNu4AlB8iZcxZMnU4M8M4v48AxVzUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784074638; c=relaxed/simple;
	bh=yKfQ0GflKniKbcTiQEcokqqiBLZSSKEnGRM/ps+7LEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i7uIiLgKL308YVAYhFX0KdEGPnkKb5KwGSOflvauyQMppXaXCh5Ei/ImRmNe+t0E9nPP9aiQv7dW68VmJAycjTycbayXBldndQ1Y/kUVLiOKjvvwjun1HVD+nMrqU83vndrrw7pK8KxkwHjnMIxaDbrUcFqX7LoPvqZk937NCDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fRua4iHZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fRua4iHZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B1BE339;
	Tue, 14 Jul 2026 17:17:09 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C67573F7D8;
	Tue, 14 Jul 2026 17:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784074633; bh=yKfQ0GflKniKbcTiQEcokqqiBLZSSKEnGRM/ps+7LEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fRua4iHZvThGUR/J15sDSpBSVZDSq6MoZM6eoRmjBJ/YIJW0HpdFfris79gLUuOcR
	 HE43sySB5EsjwfP/Q3jUaSMJgqZwaUahQJAFu2eNtvT60+DnwWfLtA8L3x7bA8oUYW
	 EXfqwaFXdu3vj+FUWVM1qh3SEn8n+cPYopQ8l2cw=
Date: Wed, 15 Jul 2026 01:16:44 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 25/28] KVM: arm64: Engage NV3 TLBI trap elision
Message-ID: <nre6kiamcmf4azxni5def5kd5p74ia7rp7ynenpyczqticjcof@4inxwalqfyth>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-26-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714091641.1970822-26-maz@kernel.org>

On Tue, Jul 14, 2026 at 10:16:38AM +0100, Marc Zyngier wrote:
> Similarly to the ERET elision mechanism, FEAT_NV3 can elide TLBIs
> that only affects the guest's S1 translation. Enable this, with the
> express condition that the guest isn't NV2 aware, as we otherwise
> need to trap these TLBIs to deal with VNCR mappings.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index b32870a5e1236..d17b161d4ba3a 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -715,6 +715,19 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>  		if (cpus_have_final_cap(ARM64_HAS_NV3) &&
>  		    vcpu_has_nv(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {
>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_NVTGE;
> +
> +			/*
> +			 * If the guest is NV2-capable, then we need to see
> +			 * all the TLBIs, as configured in HCR_EL2.
> +			 * Otherwise, relax the TLBI traps to only TGE=0.
> +			 */
> +			if (!kvm_has_nv2(vcpu->kvm)) {
> +				vcpu->arch.hcrx_el2 |= (HCRX_EL2_NVnTTLB   |
> +							HCRX_EL2_NVnTTLBIS);
> +
> +				if (kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
> +					vcpu->arch.hcrx_el2 |= HCRX_EL2_NVnTTLBOS;;
> +			}

I also suspected if this is dead code, but Sashiko had beat me to it :P
So from your response in v1, is this code here just for completeness?

It's amusing that we're not able to take advantage of this feature at
all!

Thanks,
Wei-Lin Chang

>  		}
>  	}
>  }
> -- 
> 2.47.3
> 

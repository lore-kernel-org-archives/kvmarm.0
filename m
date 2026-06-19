Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2088D40D58E
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781875858; cv=none; b=hsSpqVkVFnmCdqkby1ZkotVKgoZfaaZCvBOE0P+aUgpnvKi7rvwce6kMOjtftu8LCxgFywjGLsiJeROaaaGmL8JYr4RPsIAkqqL76X5JSU7D3WvEOi/upzjHtb3sM2StkPVrXSSvr23Yfx4zCf+aUsXVJT0qF50FBl9uG+S/37s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781875858; c=relaxed/simple;
	bh=liIbQvJAKQSTMKQlJX/BN70PZg+kVCxw1ywqeFHjGUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYB2f1NZYf7YI54kEj95uugcZgr690qEHxMEu6CqBku99KQ/7sjMRUwr/SqpoOFBNDuB7CcGQROAM5C1sCnM7q+JCqZJarymXSJoCyrzIDxNqYuim7P/zj+sVGtfyyNCU/5svi5oSWOyA1xbLaLlkuiZ4osM5T7Gb6WENalDoMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ewsUa2Xf; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ewsUa2Xf"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bec49f7e35eso303746566b.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 06:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781875854; x=1782480654; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3TpHNc6do1SKJbtgxSVn8RTCsd27hNGE1sd8vLk5+cE=;
        b=ewsUa2XfCwWxiK2+P9VWuqE4IoFkwOAOEH4AB2SPZw46LtJLmrn5N+2UvNjfPrqgXY
         RY0nu2SC/ezs6lCCFGfzbP4diknU1pRBNqxG9GeMjdgWdNwVrevVm0H9xXAPndAP8FMZ
         KMpjIuv8v5RGeZYcUUzU6GizUDquOwMiu2XLhvJy/11TkCzzG+j8P4ycT4mSLsxCtg48
         e1Cu0MzwrdPnLAHbEe3rJPsWvaxrdudtllqQvllACojyhfoT4r+WA1q0/ykSd8vzdtrr
         YE+ZbMQdNlwra45ZRj0Kuf/G/a5kK9v6VLXfxdaiH3r2KuZb9jstSKlvboFAZ/FFchx8
         t4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875854; x=1782480654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3TpHNc6do1SKJbtgxSVn8RTCsd27hNGE1sd8vLk5+cE=;
        b=PnAGd1REs0dotkphadCqxoLxfiAcjX2NhT5/tR8pX2+uj1gR8EzaSJMiUE0/Hg8VWu
         5j0o2LqrZc9SnYoc4l29dDd/DH0mxmDXQof6UGXW+VUGLDwSj7KpW3UMALwe7UQEyiDL
         7EnsJJ0DCf+g6R0YQLkEQhfQYvUsUHO8u0b9sqKIc31ebltESDgUuOboPqKtBdduP1Kf
         F7q7mL33brwMx3N/NUaFy3o2QpUfGvPW9YWEQI7TSnJP7AU6UPpQiBZwdMlCQCLuPNuG
         uN6bTsnvyfy4gvyg4Vh/EQ6QNhGs1QbMy2lBwKh9CXR181y72fGWwEwxO1HfM64AMrLK
         +ZIA==
X-Forwarded-Encrypted: i=1; AFNElJ+ar8jCL5+a7KpHZwaqTolyhcFWY9BIG9mR029ZXaCe5YIhwK4OWWt+pMJo6mBVUCoaQUH81ow=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBI4FEgeq/gDlcwOrx3OuaS4h2WYRHVZo38t7q4NE3VS+BkVOg
	18wlHWFdE0VTNWEbwUL56NAFJD4icdlsEN6CtfWreIk95iLmqdJArq265mokhBgKGA==
X-Gm-Gg: AfdE7cnYAw8LYv/RE0csvQt6gazhe2VAA9PgGZfZU0D/d/+kSKidfURqIE3vaFODG05
	ZwFqcpbICapUxI+X2mORWIzqssj//JgSt8zDs8aoth2YRPvkM9UXzIHF2jXrTjOKjqlWct5gVtJ
	jQh61KSgJQFL70rCQcVuoJ3klWF3Z0rAtw0PT6vXmab7x7ijx7eLvkS6Jf51f6YdcVN2ewW7Nu0
	jYOa8l83c2gfX6M6JBPKEtB2wse/mah3vVC3fpOJekMk6D5m/Lfde9ehkQyzHSKBMDUCWd4vdyA
	8HgphABLXWUNIZAsqU3ZKh3Ej8urLTTIunAlX9VihKIPJmU7xGotHZup/GZG3O+KW7huaW1Vyvc
	y/NVKC6eebwmy8iHRiPPmOml9QcmGNPsUXKeZnvn2vtwJH76Mxq2OGdIVZERyS4PIqSEgbxQkE9
	peWmWRmBk7jURg74Oq+eKyArzPFLxincEGkpe06mc8Zb30tvpMAVlTHXMe
X-Received: by 2002:a17:907:c1b:b0:bab:e742:aba with SMTP id a640c23a62f3a-c097ccbfcaamr195069766b.42.1781875853661;
        Fri, 19 Jun 2026 06:30:53 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650c115fd8sm8260734f8f.35.2026.06.19.06.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 06:30:52 -0700 (PDT)
Date: Fri, 19 Jun 2026 14:30:48 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH v2 4/8] KVM: arm64: Move PSCI helper functions to a
 shared header
Message-ID: <ajVEiM3QJfcEabbt@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619070719.812227-5-tabba@google.com>

On Fri, Jun 19, 2026 at 08:07:15AM +0100, Fuad Tabba wrote:
> Move kvm_psci_valid_affinity() and kvm_psci_narrow_to_32bit() from
> psci.c to include/kvm/arm_psci.h, and move psci_affinity_mask() there
> too, renaming it kvm_psci_affinity_mask() now that it is no longer
> file-local. A follow-up series handles some protected-guest PSCI calls
> at EL2 using these helpers.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/psci.c  | 30 +-----------------------------
>  include/kvm/arm_psci.h | 27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 3b5dbe9a0a0e..e3db84400d1f 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -21,16 +21,6 @@
>   * as described in ARM document number ARM DEN 0022A.
>   */
>  
> -#define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
> -
> -static unsigned long psci_affinity_mask(unsigned long affinity_level)
> -{
> -	if (affinity_level <= 3)
> -		return MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
> -
> -	return 0;
> -}
> -
>  static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>  {
>  	/*
> @@ -51,12 +41,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>  	return PSCI_RET_SUCCESS;
>  }
>  
> -static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
> -					   unsigned long affinity)
> -{
> -	return !(affinity & ~MPIDR_HWID_BITMASK);
> -}
> -
>  static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  {
>  	struct vcpu_reset_state *reset_state;
> @@ -135,7 +119,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>  		return PSCI_RET_INVALID_PARAMS;
>  
>  	/* Determine target affinity mask */
> -	target_affinity_mask = psci_affinity_mask(lowest_affinity_level);
> +	target_affinity_mask = kvm_psci_affinity_mask(lowest_affinity_level);
>  	if (!target_affinity_mask)
>  		return PSCI_RET_INVALID_PARAMS;
>  
> @@ -220,18 +204,6 @@ static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
>  	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>  }
>  
> -static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
> -{
> -	int i;
> -
> -	/*
> -	 * Zero the input registers' upper 32 bits. They will be fully
> -	 * zeroed on exit, so we're fine changing them in place.
> -	 */
> -	for (i = 1; i < 4; i++)
> -		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
> -}
> -
>  static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
>  {
>  	/*
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index cbaec804eb83..f86a006d6713 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -38,6 +38,33 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
>  	return KVM_ARM_PSCI_0_1;
>  }
>  
> +/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
> +static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	/*
> +	 * Zero the input registers' upper 32 bits. They will be fully
> +	 * zeroed on exit, so we're fine changing them in place.
> +	 */
> +	for (i = 1; i < 4; i++)
> +		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
> +}
> +
> +static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
> +					   unsigned long affinity)
> +{
> +	return !(affinity & ~MPIDR_HWID_BITMASK);
> +}
> +
> +static inline unsigned long kvm_psci_affinity_mask(unsigned long affinity_level)
> +{
> +	if (affinity_level <= 3)
> +		return MPIDR_HWID_BITMASK &
> +			~((0x1UL << (affinity_level * MPIDR_LEVEL_BITS)) - 1);
> +
> +	return 0;
> +}
>  
>  int kvm_psci_call(struct kvm_vcpu *vcpu);
>  
> -- 
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
> 

Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DCB206274
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733505033; cv=none; b=inMd5xMP7NG2lbeEU1wIEjQsUSX45tZC+C+Y2bZlagyc5IXfjxSIZonUeEvA2HhmB50JuFLneQpFdNfnlWRugnSNdbtHD3OzduKt1KIqWpSdfQcPy+diNd6gKTeUfJ1DDY/SzZifgBU/ya8RI4Ic+qTkauEKbOJlTOOwRSydD5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733505033; c=relaxed/simple;
	bh=Z4d9ykve0reu+0R+SGiBlgL+TGnubgOw0vEJdYMxnak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1ufxBkuErvfFTtWwOuy4Tu2udHhXYYaQq06Go+h1voYzy5eRq2Qa0fR47UMOTn05fdN2y+MQj65JXmlYC6byLD+bXfiiM++nHaBLVhj11S9jXWZzlQ6nY1J1SNAHzjNjJr/brMufMkJIlFkx3R7WTwjC94YMp1S328cMuDA7ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eSuzqBPD; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eSuzqBPD"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa5366d3b47so364637666b.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Dec 2024 09:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733505030; x=1734109830; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B95bOgoo9xr1fzCcAj11xs8eX1WhbVvkY5/fLcOASRk=;
        b=eSuzqBPDXnhWQs+n1TSPu/TSJd0RcPBdBReN9WQOSKjSH7/mE/CaT4v8mtPZird3PB
         Dy79E3qotUwuwi/zXkrPD8musiOb3XsDu6CjlIs0/mOhBmrU80V/lMhi4yYxYrwdg8GF
         cfzGn1DQe/XYoOCMOp1VdcPXp8VRk2U3JFJZIkIcnyEW2k07eF0a16qCnVfjZb0B4GvJ
         lxC6rEMe7pAJ4pHeDs1QKZXbYbmqmolpiaAD+Y3/PsQLqgg13Ig6rO4GQYTMhfwD7Tjr
         HD51jCozSW+C+jW+g334Rvu7pJzSMlyPnzQktWLxTAYr1leQXUs3LrX7Mysfc49DVGQM
         OVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733505030; x=1734109830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B95bOgoo9xr1fzCcAj11xs8eX1WhbVvkY5/fLcOASRk=;
        b=mZ4u0/FP8Vvz25aRl+/n+RyJfU7wCkl54iX/5vzDKwni4gUz1aDPstO/zUDFAdkd1w
         V46fa+yPgnW7NZ//DhTfzh8PwlYSEAigqomNmQR3LP2a06m2VwTlCNCuK0EegFB6VT3X
         vzhnoCdHU8/Xg8B38TIt+IJbBUC9wxaZbhMdJvfDrwDKkg7aXWee3CBtM6DyAotyVahl
         JIMgsj98b4A/RV7okm5AoGNzgx1O02nURB6Z5Rcxvuo5JP9gxI0B+HWWgQH+bXKcCMNZ
         76X89a+5gQftwuuDuaW4FYY2aI4c5+tygXzsMHjmgcF/aG3ZW5i6CFcxVtu3lCrk+8Tw
         uYjw==
X-Gm-Message-State: AOJu0YzsyJfsamr9KAQjoOd6OdpzBRr3O5rqgcI8tROwJp/RmhCOKhoe
	b2Q81Q+xt37omvjvDh8KU5qJucWz1sRBi/hRSqfE7MaGjrKRPMHRrWwOmkTyYw==
X-Gm-Gg: ASbGncvWLwn/n81cUEKmwPb+kDIiSZ2X+kM7yJItLYmGi6ldiqXwFR/ILQWkNPiu54d
	zE1GiYa9H4eDLdkK0BjWQF2TP5tRmSavqL9uwZOcF3YJOv+AAnB201j5XurIROWgP33yBmo8jT0
	4Cow5Tv7xfwl8JKhR28ynwgVhDxdxxTkaZKLsquuViAw7x2OdVg7F2WVNbYWxqhyzuWNclzXOcB
	Mctu7/7U3ijwl5/qEOqizrM3ExbXVxbd3adAZh52GHXQkxUfUypIJJU8wvPOU2XEhQMnU+rt1Nx
	mXVbltli
X-Google-Smtp-Source: AGHT+IGnuHB5ICLuzG6mtiwbXrV3pRKWr5Ln6X/XDkBvgaGXRwlNrtHngS7/Y9V4qXxe1GWH1CS/Bg==
X-Received: by 2002:a17:906:1ba1:b0:aa6:4a5b:b72d with SMTP id a640c23a62f3a-aa64a5bb77emr36267466b.23.1733505028919;
        Fri, 06 Dec 2024 09:10:28 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa625e58dbcsm264604666b.15.2024.12.06.09.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 09:10:28 -0800 (PST)
Date: Fri, 6 Dec 2024 17:10:26 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 04/14] KVM: arm64: Use KVM extension checks for
 allowed protected VM capabilities
Message-ID: <Z1MwAomiLhnMn--k@google.com>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202154742.3611749-5-tabba@google.com>

On Monday 02 Dec 2024 at 15:47:31 (+0000), Fuad Tabba wrote:
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index fb733b36c6c1..59ff6aac514c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -329,34 +329,20 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
>  
>  	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
>  
> -	/*
> -	 * For protected VMs, always allow:
> -	 * - CPU starting in poweroff state
> -	 * - PSCI v0.2
> -	 */
> -	set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);

For my understanding, why do we drop this bit?

>  	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
>  
> -	/*
> -	 * Check if remaining features are allowed:
> -	 * - Performance Monitoring
> -	 * - Scalable Vectors
> -	 * - Pointer Authentication
> -	 */
> -	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), PVM_ID_AA64DFR0_ALLOW))
> +	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PMU_V3))
>  		set_bit(KVM_ARM_VCPU_PMU_V3, allowed_features);
>  
> -	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), PVM_ID_AA64PFR0_ALLOW))
> -		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
> -
> -	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), PVM_ID_AA64ISAR1_ALLOW) &&
> -	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), PVM_ID_AA64ISAR1_ALLOW))
> +	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_ADDRESS))
>  		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
>  
> -	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI), PVM_ID_AA64ISAR1_ALLOW) &&
> -	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA), PVM_ID_AA64ISAR1_ALLOW))
> +	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_GENERIC))
>  		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
>  
> +	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_SVE))
> +		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
> +
>  	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
>  		   allowed_features, KVM_VCPU_MAX_FEATURES);
>  }
> -- 
> 2.47.0.338.g60cca15819-goog
> 

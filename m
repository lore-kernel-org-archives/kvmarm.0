Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA80206276
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733503466; cv=none; b=qN1lIVVP8DgS5Y3+7Outlxqbe1sqJEi9n/FVWDS7BFXw/o9xD/Z6RjR/ZKhKYaymH/f/xHIWWSNUpwpxmeIY1RPZvvGkshDvpfAvDPU1cvw/EjU3KPK5nY+7iYv0iPwiMZNPOER032RzWlTbCc8TWfnAxhRuB/t6FBJN0IU9IcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733503466; c=relaxed/simple;
	bh=a4zV7lPw38egBJQcx5jVnUZBDnQB4+FpFJiIRDw28Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJRcti9jt/EnrMP6wx8Ru/Nsx8YC5n4urDUniTqD1iUGJN9x/XadDSNOwvXnJoVF7yKby31cW8H5R/yDKMZZHryqfz9XPGsI1MRkqJ40c/PBHsYdAWncx801queyGrpRtcEXzHfHJoXj2g4DqTwWGBDJW1tmR7so4VyxCqq9gwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BtmTWDfE; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BtmTWDfE"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53e2baf3160so1478644e87.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Dec 2024 08:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733503463; x=1734108263; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ysUdSa/C5jKZEQ7ZSsgdqgHiInBvjlhj+IVqf9OnWrc=;
        b=BtmTWDfEY7GV4xymJZSF6CV2RlQGJvAkqjvC+zhd/iIYERV6hNf3jWtwhnDpSWUZKV
         iMyz4u270vNyUa19CTBsvPTFZUwoQmk3nxRuMu4QxOkEGojKkNzraprp9A3CW14tUl7g
         mmOqJA1ZM/umB4JtYrQ4SUJ0ygjpEFV0t8OQtftWXCOw/VX59UGa5R6rADowdoG9M/wf
         vphWmCFskKCFnXMsmxFTxqEjH7R7Nw13/nQxoe5Wghs8X7Fvb2dtKh0PkZnf5YbDOMyw
         XeFNW6HnlV6rcMX2Uv0ugTRKgyJm6cXd3sxj7MaIx7njhbsOvC4vSx0t41q2f2mHyrh6
         AY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733503463; x=1734108263;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysUdSa/C5jKZEQ7ZSsgdqgHiInBvjlhj+IVqf9OnWrc=;
        b=X9CneinXdD7UtSYcjWR+JxcT43TYe0rB3rhn+/rPBA2YVRhONQdPBWsDqrhD585oeO
         j+D5/rwdSpufOvn8ZU0oSrUpS3SP8mkJ/02oeEUZ/Ne5wI3OkXgEhyjFG78bijrV3o8M
         ggAq8S2Nozs4JLee2B3vQJi0iedWUlWR9J3uYp+89jD2agoM3UbuBt9vc44pemIGiwbU
         yQlf4n0ruAfhB/wFlU/JZfBWXL2rRmIxAes/n/spl9QZWu9MvBYC0EWd943lOGHaGJEN
         KT4q2XlqAdYoLS0ee9yMHL0wGPN8tVHMOwZRC5rvCkdEWlFBmivzLNOmjnaz2JqsPsAB
         jSDA==
X-Gm-Message-State: AOJu0YyUlQH0xXLpZ+zY/LPWBrJeqpro59U1xGgFllZTh4w/K/jZxag5
	a2Papxz/GkgY5E6zJSdv1Xuus3QP2Qs+hQ/UfVgUBuMAFf01XMMW0I9jslRqvQ==
X-Gm-Gg: ASbGnctpUuKwKeUjUMV9nVXP7KREgfRxcUWeg3riSXN4TLxV9v05cfp+NWjNI9ZDsVK
	iiQp4VexwXM3f1sT1QDbuGt4iBMPb7melQQmG9dh2GJ+FyHKaAohDiikhLn7aiZtEfKU5f9T3U+
	8ou0u1g4Dz9wc61voQuxwDpAFEsIaRocYOtl8uCcwcplJWyPPzTJR+hbah7yR/Fs3CRPdHNvxoP
	VmR+R1+mzgbq4pIW7il7Zk0FMWfFPdy+a2JxM5Cfq9TIbTcTNuRYCB9Yl02Z1mCti9yblbugc8g
	G6aonkW8
X-Google-Smtp-Source: AGHT+IEvuVGdPXLw1St7F0IenI1aA5BaUiBY9n0je7W3zaUCWSMiyC/W3sPWwSnrsWo2qQDMpIPXqg==
X-Received: by 2002:a05:6512:104d:b0:539:f7ba:c982 with SMTP id 2adb3069b0e04-53e2c2c23bamr2147192e87.33.1733503462424;
        Fri, 06 Dec 2024 08:44:22 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa6260abcc5sm262404266b.168.2024.12.06.08.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 08:44:22 -0800 (PST)
Date: Fri, 6 Dec 2024 16:44:19 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 02/14] KVM: arm64: Group setting traps for protected
 VMs by control register
Message-ID: <Z1Mp4zmZRL_8QEmb@google.com>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202154742.3611749-3-tabba@google.com>

On Monday 02 Dec 2024 at 15:47:29 (+0000), Fuad Tabba wrote:
> +static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
>  {
> -	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> -	u64 mdcr_set = 0;
> -	u64 mdcr_clear = 0;
> -	u64 cptr_set = 0;
> +	const u64 id_aa64pfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
> +	const u64 id_aa64pfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
> +	const u64 id_aa64dfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> +	u64 val = vcpu->arch.cptr_el2;
>  
> -	/* Trap/constrain PMU */
> -	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), feature_ids)) {
> -		mdcr_set |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
> -		mdcr_clear |= MDCR_EL2_HPME | MDCR_EL2_MTPME |
> -			      MDCR_EL2_HPMN_MASK;
> +	if (!has_hvhe()) {
> +		val |= CPTR_NVHE_EL2_RES1;
> +		val &= ~(CPTR_NVHE_EL2_RES0);

It's a bit odd to do that at the beginning of the function no? Perhaps
do it last to be sure to overwrite all the changes below?

Also, not sure we need the RES1 part here, kvm_get_reset_cptr_el2()
should have set those for us.

>  	}
>  
> -	/* Trap Debug */
> -	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), feature_ids))
> -		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
> -
> -	/* Trap OS Double Lock */
> -	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DoubleLock), feature_ids))
> -		mdcr_set |= MDCR_EL2_TDOSA;
> +	/* Trap AMU */
> +	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), id_aa64pfr0))
> +		val |= CPTR_EL2_TAM;
>  
> -	/* Trap SPE */
> -	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer), feature_ids)) {
> -		mdcr_set |= MDCR_EL2_TPMS;
> -		mdcr_clear |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
> +	/* Trap SVE */
> +	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), id_aa64pfr0)) {
> +		if (has_hvhe())
> +			val &= ~(CPACR_ELx_ZEN);
> +		else
> +			val |= CPTR_EL2_TZ;
>  	}
>  
> -	/* Trap Trace Filter */
> -	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceFilt), feature_ids))
> -		mdcr_set |= MDCR_EL2_TTRF;
> +	/* No SME support in KVM. */
> +	BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME), id_aa64pfr1));
> +	if (has_hvhe())
> +		val &= ~(CPACR_ELx_SMEN);
> +	else
> +		val |= CPTR_EL2_TSM;
>  
>  	/* Trap Trace */
> -	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), feature_ids)) {
> +	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), id_aa64dfr0)) {
>  		if (has_hvhe())
> -			cptr_set |= CPACR_EL1_TTA;
> +			val |= CPACR_EL1_TTA;
>  		else
> -			cptr_set |= CPTR_EL2_TTA;
> +			val |= CPTR_EL2_TTA;
>  	}
>  
> -	/* Trap External Trace */
> -	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_ExtTrcBuff), feature_ids))
> -		mdcr_clear |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
> -
> -	vcpu->arch.mdcr_el2 |= mdcr_set;
> -	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
> -	vcpu->arch.cptr_el2 |= cptr_set;
> -}
> -
> -/*
> - * Set trap register values based on features in ID_AA64MMFR0.
> - */
> -static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
> -{
> -	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR0_EL1);
> -	u64 mdcr_set = 0;
> -
> -	/* Trap Debug Communications Channel registers */
> -	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_FGT), feature_ids))
> -		mdcr_set |= MDCR_EL2_TDCC;
> -
> -	vcpu->arch.mdcr_el2 |= mdcr_set;
> +	vcpu->arch.cptr_el2 = val;
>  }

Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB61A23FD26
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 12:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733921179; cv=none; b=u2YUxayR1eVta6IW1WiEAV8LATqWA2wAR2gb/xq6FCD55zIDpKioYP9ouGfh5WxjQHlag7b1XGMTiRVeQuD5ULjhRCtgaE8KH+rg2li3eAI/6yrUK+mhGaMWjrQbzOuUK+f/KrHTr0ieZtT3aZM0JlG08Fylm/PfqPfYRlmy3KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733921179; c=relaxed/simple;
	bh=7os9DTuVuyWfPeUG1lDx/lShWjdSZgs2CIoq+zSPFMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unF1QndMJwT42xkuSKOtS0YWVNOelTKhNKIpVnqODsmZUXHWxet2nINltsDoEcEhpJQq8yGGsPmM6lgTymMlga2Pg+YiC/04TvHjkRv1UC6KPlG8bOBStMGsYk5Ozi2V70dlEGBIHI5j/f1RfAp/L26SHBQ77NBoe98HPXywLfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F5h+3LxO; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F5h+3LxO"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso1001061266b.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 04:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733921176; x=1734525976; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zCBMc5V1Q6INqCw1DV7Kyq9p0CzJoNlOKxNfceyx2rg=;
        b=F5h+3LxOTFjXqXFZXXXXD+0HEWXj35J2bma9cKDjiBAEBjHB0PSd+F/jMXhBU2Z3GA
         VBnTg9dS3A86igE1bF16h6jerAmQ2rzItKfX11Hs9oN00HnV5REtMDxMxQ/Cx6Z1vRHq
         Z7SGF7a5qBwUgmmaLIZXmXQ9ci/+wXeg2EpqI1yYw/18qEdqDih90ODh44orup26/h7S
         9v8Yo7d4julUcgu+ivZ46VDWFNfU34B5/Q31Zkdh0afPrSpgwts4l/eqNqTLHENIHYGL
         RunLIrS/N91YmNbiYjSIitDMnlgIAmS/rB+EKoVyE7l2LGxOn4yCjk+dL6aOaCnL6WOk
         PiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733921176; x=1734525976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCBMc5V1Q6INqCw1DV7Kyq9p0CzJoNlOKxNfceyx2rg=;
        b=UfAZPu/hdERq6NgNYRU36lugT9uma3rn3C/z1zvlBbJcnqTPrfj1SSeSIOxBfU2m9S
         pQyektU+PuDDNUsUPSm5tLzrmH+BxASxwwiapWMcQOToVfF0QKeO8/fCAYw8Cx3aEkCR
         OHlS7Efl0ID33fzIzTGsZ8lXrphKGBbOi9raOdJ3iDQ270eVQ3qgB8RuDrkdDjB7BkOu
         I6gcaFZvsV3FiexfiVLuAr6BvmbCv+btDSMJoW1Tlq6n7gOBLxfLJbmofK+FHIywU1VG
         mHCvGRiXdPKRy86i3Vhy/s9YLVhHADhzIGd2NVSoX5uqVFPw0F6xlmRaT8cl3Ju7CI0q
         nhgw==
X-Gm-Message-State: AOJu0Yy2id6wC+SwvUKQfDIQMnpB5bdrePHWbSSu9HnH1zWbPcYAveGf
	PQrlnpEYq40V7XNUxhNZmPg5VJTl4lqOoV0bviNeQzteaLarq2bODfxI4lzm2A==
X-Gm-Gg: ASbGncvNdXOEKEtTLlX8sxmAue9sSAkRV4D1F7TZeBls3DaLye/pwg4sgFLpDyLte9q
	OY9JTUv5gSdauY8QblXCfMtijNJ02Vt7FeoKXOG7anBysa7/aOT1nakFCb9gmbHWfx3rIC+HeCR
	ZGN/1AGHS77K8kqOrQaY7qt9/mEi652GGBOfGyW4hnOIW9VwUgiaYR3ylDFJ1sP3YzgXFRhQtfz
	A+yZxQS6Jlhm/2mmEREiZS5AgiJBsJ2EC3cOPZZDhCRgnD+pEiZwFeMP0ydmhH/HNB/qQthzCb4
	ZUaIqbc0Hl4O
X-Google-Smtp-Source: AGHT+IH/RE5oNf25c/+lQTgnA7YehMT2JtPDIfujCd0btPu97B7K6upI7Fo8An7YN62TiZ5r0yZtQw==
X-Received: by 2002:a17:906:4c2:b0:aa6:84d4:8021 with SMTP id a640c23a62f3a-aa6b14f0ec0mr224014566b.61.1733921175479;
        Wed, 11 Dec 2024 04:46:15 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa689addd0dsm444642566b.6.2024.12.11.04.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 04:46:15 -0800 (PST)
Date: Wed, 11 Dec 2024 12:46:12 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 10/14] KVM: arm64: Calculate cptr_el2 traps on
 activating traps
Message-ID: <Z1mJlF-H5R_-f83I@google.com>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-11-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202154742.3611749-11-tabba@google.com>

On Monday 02 Dec 2024 at 15:47:37 (+0000), Fuad Tabba wrote:
> -static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm *kvm = vcpu->kvm;
> -	u64 val = vcpu->arch.cptr_el2;
> -
> -	if (!has_hvhe()) {
> -		val |= CPTR_NVHE_EL2_RES1;
> -		val &= ~(CPTR_NVHE_EL2_RES0);
> -	}
> -
> -	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
> -		val |= CPTR_EL2_TAM;
> -
> -	/* SVE can be disabled by userspace even if supported. */
> -	if (!vcpu_has_sve(vcpu)) {
> -		if (has_hvhe())
> -			val &= ~(CPACR_ELx_ZEN);
> -		else
> -			val |= CPTR_EL2_TZ;
> -	}
> -
> -	/* No SME support in KVM. */
> -	BUG_ON(kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP));
> -	if (has_hvhe())
> -		val &= ~(CPACR_ELx_SMEN);
> -	else
> -		val |= CPTR_EL2_TSM;
> -
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP)) {
> -		if (has_hvhe())
> -			val |= CPACR_EL1_TTA;
> -		else
> -			val |= CPTR_EL2_TTA;
> -	}
> -
> -	vcpu->arch.cptr_el2 = val;
> -}

Mooh, wasn't this function added in this very series? Not a huge deal,
but is there any way we could consolidate things a bit?

Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA5833FE
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730741518; cv=none; b=ZfrlXstUxwFVi9u/DUoK8wJXQVkUIedkcNbmEjyvM2+N+R/rqm1vYTXRwG8KSs48WEOzBPhvMk2qUiligmYEDAtrUNlt2hBwkzh22k7v3DtV0nfVzJyMqKzFO8+XGzN9x8Qqr45KDSfjb8aVyyBdCT5rsFeiwlR9PSCL6F/J08A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730741518; c=relaxed/simple;
	bh=bnVxizLxpO8STPwMmkuIRHUe7oPgu5FuCiJviNm+udY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XjvTkCBeIP/ddB3I2y+P1UweicMJBp/7F1NzHMzhdEKOl3HDFbxOAb1IgqZcuTpKP7MdGL5bmWKaHgjvqT7zOLjCo+G8PsgVnsDw5gaf7mN8MT8+9MTaVMwD9gR/ftmUuN8jEGn5BzP3vC6R7I4IFd2IWbSzF7qnlnexx2pZigw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3C9MySE; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3C9MySE"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539e681ba70so31548e87.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 09:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730741514; x=1731346314; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m+gWQBW59oA/smxkvbCMiuP+EZcz3YoEze7WyvjSzCI=;
        b=F3C9MySEc9tsx4qeMTzMCJHyxfgL70s74WMqavZkseB4yjSwb3x0ooyjBe+V9izD1Z
         q9JBG5tjCRRaAsdQ1QR8Jp3PFghuotjyJL5t6BJalCeM5CjynTGDnBhljV1cb32wqK4j
         Y0CqaQPQkCCYwjf+xjtUuTsZ/5yaEToCZ10B9xvboTtWoyWWI+j9C9jym2w28PgdUcwc
         QEYEhXq62R+RwIlxLPnSbOXa62x1774nfIOpCcQ9UZpAFIoui7M1HYxAbbb/y1zXTir/
         6aRrmvkwIDNU8DZXkgz7T+dUH3AWNL0DGuQmg/UrRMChgm/M/OUuZ95J5yHtk61ygwon
         0qBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730741514; x=1731346314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+gWQBW59oA/smxkvbCMiuP+EZcz3YoEze7WyvjSzCI=;
        b=mAQIF4tM7jTI8MGCnt2O8P/wTz556r+Sdib1z2CUVAv6P3mmOnZQHZ2JI+Z73nD8i7
         Dcxng06aG6PmoFtiBz++3kT+aJLlLo40e0Qg2Btln37oETJIDeUTQ15eQnekTb54yv9e
         KBKqi6ySPxOAfyD21BWSxf+12JwFzb56M716WmAVt82+rSZ+cmmQMOltGiFF6DaM2jvv
         WGSr3Se/6BljIDhvxCUROjc6P/uV5D1QJcpm1mh+TczsFVL7nIFNQa0Ehi/4e/vKJ/2p
         XE9UQ2iodo51t7a5vl9tNZkBM9/r2/03mitf10sb18Ene6Wt9s86HJkdF3Z+LjyL4Ygh
         v4mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvY8zvePCpKqbE9Sk91wV3h31g2FNdPA16CjVXFXFr02D2+7Fyil4KKV20JDcYOuZe1CKgTA8=@lists.linux.dev
X-Gm-Message-State: AOJu0YySqlFgNTFT9YMJG6WlAz9biOUbJMF8i1DkMYfP/CcYOsXB4c3M
	9wby5rAshn1235T3bTX3VkU0b1iEtLPpAlEBj6tbVw1vKBdHgvuQzEkUx1Ylvw==
X-Gm-Gg: ASbGnctpdpmb1FXOYi5JQJ0WZ8Y7Q88Ehzc1uwpSojbiaxdwkCPS8V0+FIWUFImNbJ8
	nEqqkQ6egc3HzPh9Oj54AgrtLwwgsxdHDQIRLfWd1X1pEdZjPIIK7cKdTGyb27DBR8lkWbK5+4l
	EYvqkLJqhgOxr2Ehvj/4fJRbUEjIiF+jCK9rKGNfwvoezZgJxSBHYC/k5ft6cdG9BELdr8LAegS
	ZjWYK99HL0osilrxMmiW9oBv2+2X7yLY3ULTDHgEgQmj/Y2Pkl73UvMV7Js2j/lT+u/pT56cfiu
	xAUn91Y3W6uupmo=
X-Google-Smtp-Source: AGHT+IEFzR5K452HH5vqMM377aknN6V/3WvRGaWelqf2PQHhiSRldASVdDARr7JWsAF1t8ICdL9ygQ==
X-Received: by 2002:a05:6512:3985:b0:530:ae18:810e with SMTP id 2adb3069b0e04-53d6b1b3362mr519219e87.5.1730741514166;
        Mon, 04 Nov 2024 09:31:54 -0800 (PST)
Received: from google.com (145.16.38.34.bc.googleusercontent.com. [34.38.16.145])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9ca704sm189791515e9.41.2024.11.04.09.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 09:31:52 -0800 (PST)
Date: Mon, 4 Nov 2024 17:31:50 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] KVM: arm64: Change the layout of enum
 pkvm_page_state
Message-ID: <ZykFBhlzrUQtjEjy@google.com>
References: <20241104133204.85208-1-qperret@google.com>
 <20241104133204.85208-2-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104133204.85208-2-qperret@google.com>

On Mon, Nov 04, 2024 at 01:31:47PM +0000, Quentin Perret wrote:

Hi Quentin,

> The 'concrete' (a.k.a non-meta) page states are currently encoded using
> software bits in PTEs. For performance reasons, the abstract
> pkvm_page_state enum uses the same bits to encode these states as that
> makes conversions from and to PTEs easy.
> 
> In order to prepare the ground for moving the 'concrete' state storage
> to the hyp vmemmap, re-arrange the enum to use bits 0 and 1 for this
> purpose.
> 
> No functional changes intended.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 0972faccc2af..ca3177481b78 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -24,25 +24,28 @@
>   */
>  enum pkvm_page_state {
>  	PKVM_PAGE_OWNED			= 0ULL,
> -	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
> -	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
> -	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
> -					  KVM_PGTABLE_PROT_SW1,
> +	PKVM_PAGE_SHARED_OWNED		= BIT(0),
> +	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
> +	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
>  
>  	/* Meta-states which aren't encoded directly in the PTE's SW bits */
> -	PKVM_NOPAGE,
> +	PKVM_NOPAGE			= BIT(2),
>  };

I guess we will still have to keep around the software bit annotation
for sharing MMIO regions from the host. This would not be tracked by the
vmemmap but it will still be in the s2 pagetable. As this is tagged with no
functional changes intended, are we safe because we are not supporting
MMIO sharing currently ?

> +#define PKVM_PAGE_META_STATES_MASK	(~(BIT(0) | BIT(1)))
>  
>  #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
>  static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
>  						 enum pkvm_page_state state)
>  {
> -	return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
> +	BUG_ON(state & PKVM_PAGE_META_STATES_MASK);
> +	prot &= ~PKVM_PAGE_STATE_PROT_MASK;
> +	prot |= FIELD_PREP(PKVM_PAGE_STATE_PROT_MASK, state);
> +	return prot;
>  }
>  
>  static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
>  {
> -	return prot & PKVM_PAGE_STATE_PROT_MASK;
> +	return FIELD_GET(PKVM_PAGE_STATE_PROT_MASK, prot);
>  }
>

Thanks,
Sebastian

>  struct host_mmu {
> --
> 2.47.0.163.g1226f6d8fa-goog
> 

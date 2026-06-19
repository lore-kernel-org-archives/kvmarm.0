Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FDF363087
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781875507; cv=none; b=Gq1nFljWpbFhor7FWSRhfgWQUy5oSm/31dM8w4n9jLeHPsdv5+GaA7S8qmvudc3Htp4LCPHHfGWsIyybz/UrOBSnbXJpSEyc9rCyVP+WerLaogWpYs+9peINqVMZsymrts/2WoB17IGGwB5XVuRvRtyHhFCNml5JDN87ZD3VEus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781875507; c=relaxed/simple;
	bh=MCPUgNfD7XPKbkrogKRoQJewGXB6Ez80+b/hjQKKx5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BL8vsPS1EOyF5s2I/3QLaNMCCe4LfRofLOWty6S5lNnWN0b+GoFZbN1KAtzu95PaMuHVaqitmh2G3sFU4FJGTIvPWOIF6UxDAnp0R99XPKjTaENKhWoEFX8PZp6iowLxsbrhN600GWHz08b6JkKjTeQENG/UKnwkR+034qVcbIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G+F1/buR; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G+F1/buR"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-462342ac290so2420029f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 06:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781875504; x=1782480304; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Q3QiE1tVQhgfjgih42D2xG7NK3u5XRzBnEUMr8TJAM=;
        b=G+F1/buROQS4bBV0Okf3qxdiZEH3YHLBXUEq2n7eQOzCQBV3vhFm0f2SEXAMtS/hOa
         4psGMNON/3H34k9OEEDY3rFipz1sVbzVhWYQc5uQXHqYCj4/a9+Qa4e/tDIpOWx2Aghy
         gbVYI5mVUFxPWpV9zWSQn4daPwJ9bHgHaRZKlJ3lnLJydB9yicq9b/LMRGfYBdR/s3yG
         dcz42bxiRu24pVOk0Kvs4B1IF5+cZuC4OP8jaAQDLsR+DdrfHyW+16mD3GtMwivgGIMD
         5DdiuOeEu4YmmDIeOaYo7VsMBHbWGlLNgZcdQ4jnl6KOOtiI7762eO99K4zjLVx/pL/t
         3olw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875504; x=1782480304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Q3QiE1tVQhgfjgih42D2xG7NK3u5XRzBnEUMr8TJAM=;
        b=d+p+z9/OEak7oV87/3x6Asjrw4Dj8aix5QnHNauhwKV79lAy2gcpauChcUeRvOA45r
         FGyw8yo7/XSEiVS36KVVhFeJa9wqIZXQz8a+UDMDVpEVCyd0A3cF1fV+KgVpQdX2NzsU
         Y/WpsJdR0SrCN8WVBkVtS/uo97QGzFJ1Si1gENZg35hRMTOdyj8Ywn+DjblHzTnyUXnU
         e8ftEJXNOtWjo3QpAxPwiEMWQ7aap7FCpXjeWED3nluyoecOLGWRCHwiAb4mQSwBkTy1
         9MhN8NozHxfWDLH+RVuV9DUgDbMv3B+k9bYJd+Xcc1bRzwFY2Cvptq0Otv6+AGdlVNtD
         eBlQ==
X-Forwarded-Encrypted: i=1; AFNElJ9HdyXa/gozflNkQRVNfRALeYYkKyV3eyJCwBlFHLohyKNfvXmsZQ9vvtXq53OWaIqaK4GibN0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTBvUlsKsxKqIun+bEONsJbVl4P2TqLEd2n96+TaZj/SCLq1Ui
	qBJ78nS+MYOKgKah/DGVj2SujkelfrS3MpcHfb3fuzqW02+ALdNT3qiz97didjBiMG/kJckVNDY
	c0j050g==
X-Gm-Gg: AfdE7cnGsKU4fScyUpFRge0JZGk72Cep596cYeOdSTGjdsY5KZN+sP5ON77T0J8yKVU
	qN0siyGHiDd+UGw9cVmipA1ivh7F+Vj6Bv79AVhEZxnkdYjLtCDHoZClzw5OvZa7EZ1jJCSM5uR
	cdFgZzoDtsGb8snQUcHLjYNZRDGis+j2PUu+2LhKzvtl3CuLF+PvmXN5K2AZFBTGxYEIfdzwmnf
	GfX4LTVwDNk6o9BSRJBUK4OiTx9YzEXEoGBBz1Gsl+mQA+3AeQJsNPC2cTS11Z6W1nadYK9VBeI
	F2J0VtjOzFwJCvN7WHpL4CMbNEWEfjd7LXGxkCBEUFz66wskgK0BOUrUt/0O9MrQCKAn4F9FA4Q
	2fVCZyKzGNNBczYJdl7F31ygCKzeQOCLCKLMDOckR2YDYP8CC/HtoM+X3jdGTFkTmpVftS5r1ay
	MOHxjsp5SajJr91BQN4m6KyL+bISahjeLwZIhUTEaFiuzu38iUM3qDK10j
X-Received: by 2002:a05:6000:1447:b0:45e:ec18:f20a with SMTP id ffacd0b85a97d-4656e5c4b14mr3772654f8f.32.1781875503600;
        Fri, 19 Jun 2026 06:25:03 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650c114e22sm7285121f8f.34.2026.06.19.06.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 06:25:03 -0700 (PDT)
Date: Fri, 19 Jun 2026 14:24:59 +0100
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
Subject: Re: [PATCH v2 1/8] KVM: arm64: Extract MPIDR computation into a
 shared header
Message-ID: <ajVDK06_gDKYBro6@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619070719.812227-2-tabba@google.com>

On Fri, Jun 19, 2026 at 08:07:12AM +0100, Fuad Tabba wrote:
> Extract the vCPU MPIDR computation embedded in reset_mpidr() into a
> kvm_calculate_mpidr() inline in sys_regs.h, so it can be computed
> without duplicating the logic. A follow-up series reuses it to reset
> protected vCPUs at EL2.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/sys_regs.c | 14 +-------------
>  arch/arm64/kvm/sys_regs.h | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 33c921df19b5..674fabe1d40d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -976,21 +976,9 @@ static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  
>  static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
> -	u64 mpidr;
> +	u64 mpidr = kvm_calculate_mpidr(vcpu);
>  
> -	/*
> -	 * Map the vcpu_id into the first three affinity level fields of
> -	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
> -	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
> -	 * of the GICv3 to be able to address each CPU directly when
> -	 * sending IPIs.
> -	 */
> -	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> -	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> -	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> -	mpidr |= (1ULL << 31);
>  	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
> -
>  	return mpidr;
>  }
>  
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 2a983664220c..bd56a45abbf9 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -222,6 +222,25 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
>  	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
>  }
>  
> +static inline u64 kvm_calculate_mpidr(const struct kvm_vcpu *vcpu)
> +{
> +	u64 mpidr;
> +
> +	/*
> +	 * Map the vcpu_id into the first three affinity level fields of
> +	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
> +	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
> +	 * of the GICv3 to be able to address each CPU directly when
> +	 * sending IPIs.
> +	 */
> +	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> +	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> +	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> +	mpidr |= (1ULL << 31);
> +
> +	return mpidr;
> +}
> +
>  const struct sys_reg_desc *get_reg_by_id(u64 id,
>  					 const struct sys_reg_desc table[],
>  					 unsigned int num);
> -- 
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
> 

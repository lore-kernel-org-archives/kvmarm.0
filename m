Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9D719CCFC
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714855; cv=none; b=KT1UfsZECHCjFhQNHm/jec/lVJdxHlbZWuenel2Qxomc3Tomiz6/DlaoWr3eaAHDwML141Lz31FbOi9OXzoqS13fEo5mTdB15XX6xs3r0oqYbNzudCZ1fVc/h8yMpbhl+/f3N7k7RRlz31WZ3+4JHiSL5YXMIbW15MMDcQyKL2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714855; c=relaxed/simple;
	bh=Y1irm17NYDZB4GbwArsvV23tXA9EJODuvScqv2WHo68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZSu5LB5vmcrn8c+BI80EyBez+pH3O72JU3DapqzJx3li1nwi+XoetCxeINmVnbM4x9MTt/FpBK+CYyaAXeb9UZtKd9akEBYpAqsiDXoSyxi3SIa90jdATTHDH85ickuhs1ji1Buw0pjPgFOnr5BJo5s2UH1WxnBfZiqFIeXfBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KxYCpi9y; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxYCpi9y"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-59b6c905a46so257049e87.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 07:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767714850; x=1768319650; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zN3gm9omWhJ2I79tHQv97PtdD9jIxIIRpoGDLMdPnsQ=;
        b=KxYCpi9yLlFdFpkGH5zG8OXlsE6SmYY2/Xy9Ve+QGVkddGF+YvVwB7vzBTAlBG1yju
         GjGMt3cAq3hYF276MGoNfCGanrWJmPu+JpE+/GVw1S34PqBYFGui98Q+YrebdiCKcjD3
         GysglGF0DEIJ6JytEf5k50jSzHtHVxe8mfgpZyPv4DyE3YvRJvHEKsphUG7cwEtCBs1r
         GBZdppbFSraf+rVxHNmQgLr7YVB5VFEYmjOjugiZxrh7ai7P2yn1KngfvFUE2oSDZ1FK
         j9Afrqw5B/TPbcNvTFb9y9zamMdy1hM4+qj3edvTA8KQoe/YdBkbx7u41oA4WPsK9hI4
         R1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714850; x=1768319650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zN3gm9omWhJ2I79tHQv97PtdD9jIxIIRpoGDLMdPnsQ=;
        b=FU2Wqf1ZlLJvvIzSPudWaV6kl+lHjexlx5WVOqaQ0bi6yiHz48XsV8yAAlkZB3EH9l
         gRKA+01E38uv1YVsFcUZDTmPPDzKj1txo7UJET3pwgS524mqWXwf2kmDqSFtay+iYzKz
         FT9fGVFpXyQpDZDzNFW6YbH9dAgI+yrArsXV+ng1N2AHxSdSNBKipHo/kQH1rYRtOrYa
         sB1KolOmRalV7O/M6lPvQxtDqr9PrKdLqFaZ6q3MtO9apJxaJAO9JR9Jk6aYK0M51y0f
         X+7akNBzCKQ+dROAhyMrDRNZZp3Eg6UP2kdGcZ+nYfoqHG0g6iXhfef/6HRGuu37CV9J
         aTog==
X-Gm-Message-State: AOJu0YwGFoc3JZlF9Uu3/tzQWdeluFbGFSDW0hycBzpo4DFSo3E/Ok4B
	gw/i6jm9IPAW4Mtkj9R/A28Qk5b3JRC/DwVj1KZBd1OKxlYqyqaCvGcklvCxSSaG9g==
X-Gm-Gg: AY/fxX4ReEVR8DvKU/M5V3anjNcWk1bNTWIOrzf/tTY1Kv/uqfdI+r6Kd7wa2KgsO55
	5DSQtT2F4jBx7icUkckfxf/Dq9poY1oSPTVUC1EudEEWp/a1V3bQ1dMmZ/ZXJ18wZ2RHGZEuAS5
	7mWmvXrWZEbamPgNAbz8NcyifQ2nhSfWHrAkIiwkQI+R5hsJZNz74Nn/GTMF59M4Y69wfZA5lQN
	DrGtsw36lAL1rdelyJpXJOGqpUymnfUZ84pWWUi8w8Afx5FRNYKDJ5FyFD9UHYG4uWVtDPQZGDc
	NyMAO8Qm5YmUbNSGAGqutSFjlJoKslrHsI6sRmCy56qD9txEBtFjl5krCzs0pv7y4ML1hxOHWsr
	/q4d/927vLCHC5b7CrKhejlbSIv3EpG3LcmSo75eWojzlQKxa/TWqd02KHZ9IlsfZh5saikj+vO
	zZ88KSEEnvmiqlmKlN5dB/nBVG+3yW8S79rvKrdbjc8i/QUcPA
X-Google-Smtp-Source: AGHT+IEr+Qb6RHsvXmYC4gn7IGjWj58AVOeQ/r2Dl9ZagyqZLq/pQSe8SUdL75TLTQ5bpqptdehJHg==
X-Received: by 2002:a05:6512:3503:b0:598:eecb:c891 with SMTP id 2adb3069b0e04-59b652e85d0mr1319033e87.52.1767714849732;
        Tue, 06 Jan 2026 07:54:09 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d5dc8dsm642216e87.46.2026.01.06.07.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:54:09 -0800 (PST)
Date: Tue, 6 Jan 2026 15:54:06 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 22/30] KVM: arm64: Return -EFAULT from VCPU_RUN on access
 to a poisoned pte
Message-ID: <s4p2ximtz7pki3waw245jtbl5znuco2ijrzsddlmln5x6rgxee@qbek4vpwn3kl>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-23-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-23-will@kernel.org>

On Monday 05 Jan 2026 at 15:49:30 (+0000), Will Deacon wrote:
> +int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> +	kvm_pte_t pte;
> +	s8 level;
> +	u64 ipa;
> +	int ret;
> +
> +	switch (kvm_vcpu_trap_get_class(&hyp_vcpu->vcpu)) {
> +	case ESR_ELx_EC_DABT_LOW:
> +	case ESR_ELx_EC_IABT_LOW:
> +		if (kvm_vcpu_trap_is_translation_fault(&hyp_vcpu->vcpu))
> +			break;
> +		fallthrough;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ipa = kvm_vcpu_get_fault_ipa(&hyp_vcpu->vcpu);
> +	ipa |= kvm_vcpu_get_hfar(&hyp_vcpu->vcpu) & GENMASK(11, 0);

Why is all the above needed? Could we simplify by having the host pass
the IPA to the hcall?

> +	guest_lock_component(vm);
> +	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
> +	if (ret)
> +		goto unlock;
> +
> +	if (level != KVM_PGTABLE_LAST_LEVEL) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	ret = guest_pte_is_poisoned(pte);
> +unlock:
> +	guest_unlock_component(vm);
> +	return ret;
> +}
> +
>  int __pkvm_host_share_hyp(u64 pfn)
>  {
>  	u64 phys = hyp_pfn_to_phys(pfn);
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index d1926cb08c76..14865907610c 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -417,10 +417,13 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  			return -EINVAL;
>  
>  		/*
> -		 * We raced with another vCPU.
> +		 * We either raced with another vCPU or the guest PTE
> +		 * has been poisoned by an erroneous host access.
>  		 */
> -		if (mapping)
> -			return -EAGAIN;
> +		if (mapping) {
> +			ret = kvm_call_hyp_nvhe(__pkvm_vcpu_in_poison_fault);

It's not too bad, but it's a shame we now issue that every time we have
such a race (which is frequent-ish). Could we perhaps only issue it if
at least one page has been forcefully reclaimed since boot?

> +			return ret ? -EFAULT : -EAGAIN;
> +		}
>  
>  		ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn);
>  	} else {
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

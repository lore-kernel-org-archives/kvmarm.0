Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6E212F36D
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714573623; cv=none; b=MKBV2+qup0XmRYWJIOAm7ur3RZ+45STPbhUf0Kwjyk0f55c9N0FG4wHHbqKyr0spam5JvNavVbpUneu3RQZX2Xn06rAaDPxXyjJJsWRu+b5ZI1dH9oMGOZ0N9juGj7ysGPcgSiIICo1gRB1Yz/mDt6B74KndXe9Fa39dCR63GII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714573623; c=relaxed/simple;
	bh=VLDaNGeiHmozD59IvSgOUbhpYMSflJM6reIT+ykbn0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHObN3SOF7k+QABqYKj6JizGW4fONBTFVGAYnRqwjGi8Wdkw7EMot3MBa72gBw4Lm82Ga7E06t3U5keTkSRS3rxX4nDYAAHuxuHR+v6x5r5NXGaP4KiWrCF65CxOeHn6Igp2OtyTgHzuR+RFk5awfq9OYpiHb6G7BkA2xIhE8LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D9rrjMCf; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D9rrjMCf"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2e01d666c88so39791541fa.2
        for <kvmarm@lists.linux.dev>; Wed, 01 May 2024 07:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714573620; x=1715178420; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZjthxVOkAIkSgJpgMhl5+EWLLpCqE1AJWtsVBUVw14=;
        b=D9rrjMCf/sEZKI1mCv6SUffkUyvx/sUQ7CHUeVa7aQhN5jan6R1gEc1QxXkQ1Oo2tf
         i7qXSqXXF/CSS4ou1y/oXrtF/oCVerw5OTo924EYJ9EGIF1TaevLiTahy1sdGXSFWrMd
         DZvcmYrg0FJ3bJ6QsrJObc/n9XV9z8wwIVZ1QDcSytL86jl9sr40fa3QW2NaG33qaNSH
         UTiT/EPW2IoOy2Grp4UCpD8FOF6K3AIavdjtEcS0YbKAxJJnD4rXN8Nvwdbt77YP/+nn
         teQMUhUJL7IU35G8NBYQQNEq+hkczzr71wFXg/wOV2LT5ME8W/+5mVpjalv6UFxk3e2n
         2G/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714573620; x=1715178420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZjthxVOkAIkSgJpgMhl5+EWLLpCqE1AJWtsVBUVw14=;
        b=ETM4JDeYTS9eNcuoc9XfqN08wiuPvOYpKeYa34wPu+1ZfyQ97/LjaCBAPkRj602/4o
         VGlA0gnhIfOcW0eCev4p2r1/B5bl4CWchMrVEETO/s66StUqQNTfzVbOXjVKoBWwuFmr
         UnqE0PdOHwGI4PuI4ditlhAWCwln0T2erLaGlHxzudCI6/wNI9GQaO0w0g9eCaxiElFE
         FlD+ongMNqfKOWYtZvmjJhSqSZ8oqyKuOrBDGD2DgXCFqaubD+/AyY5GDaAKLnoMJEpW
         6BM1tEM0l1SE7VbQFErB80DqI7ZuH1qPRceUfSAaTmrm1J044aOsmPtcdKBYRuc8Ppqa
         Di3w==
X-Forwarded-Encrypted: i=1; AJvYcCVdfYDJtFE6AMPLn774nuAzxlebttF2PI5+ShbALIOrStB7NaafPDX4LM8BHqtrSiOjG8BXhrZ2P2aKuC3pYDMCJRow6hrS
X-Gm-Message-State: AOJu0YxAXqSziDnP31UpqZP+jlIlmsEUiwjpWI1PLMVPlSa4NiEXCenG
	1Kg3GZ3ElzhQS2ej254hGO5/d8mycTJPlF0wKyNmSbUWtpLAf9AJS9l3NHMERnE=
X-Google-Smtp-Source: AGHT+IFP00lEVMK3ZoYagazXRbuD0jd0lzZYQqIAYWDPU+So3WVKQ11BgdI+7AOnv7sHvxT3s2Lbbg==
X-Received: by 2002:a2e:87d6:0:b0:2e0:c6ec:bcf8 with SMTP id v22-20020a2e87d6000000b002e0c6ecbcf8mr1753294ljj.41.1714573620325;
        Wed, 01 May 2024 07:27:00 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id p18-20020a7bcc92000000b0041bfa2171efsm2340897wma.40.2024.05.01.07.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 07:26:59 -0700 (PDT)
Date: Wed, 1 May 2024 15:27:12 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 17/43] arm64: RME: Allow VMM to set RIPAS
Message-ID: <20240501142712.GB484338@myrica>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-18-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084309.1733783-18-steven.price@arm.com>

On Fri, Apr 12, 2024 at 09:42:43AM +0100, Steven Price wrote:
> +static inline bool realm_is_addr_protected(struct realm *realm,
> +					   unsigned long addr)
> +{
> +	unsigned int ia_bits = realm->ia_bits;
> +
> +	return !(addr & ~(BIT(ia_bits - 1) - 1));

Is it enough to return !(addr & BIT(realm->ia_bits - 1))?

> +static void realm_unmap_range_shared(struct kvm *kvm,
> +				     int level,
> +				     unsigned long start,
> +				     unsigned long end)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	ssize_t map_size = rme_rtt_level_mapsize(level);
> +	unsigned long next_addr, addr;
> +	unsigned long shared_bit = BIT(realm->ia_bits - 1);
> +
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return;
> +
> +	start |= shared_bit;
> +	end |= shared_bit;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +		int ret;
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		if (align_addr != addr || next_addr > end) {
> +			/* Need to recurse deeper */
> +			if (addr < align_addr)
> +				next_addr = align_addr;
> +			realm_unmap_range_shared(kvm, level + 1, addr,
> +						 min(next_addr, end));
> +			continue;
> +		}
> +
> +		ret = rmi_rtt_unmap_unprotected(rd, addr, level, &next_addr);
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (next_addr == addr) {
> +				next_addr = ALIGN(addr + 1, map_size);
> +				realm_unmap_range_shared(kvm, level + 1, addr,
> +							 next_addr);
> +			}
> +			break;
> +		default:
> +			WARN_ON(1);

In this case we also need to return, because RMM returns with next_addr ==
0, causing an infinite loop. At the moment a VMM can trigger this easily
by creating guest memfd before creating a RD, see below

> +		}
> +	}
> +}
> +
> +static void realm_unmap_range_private(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	ssize_t map_size = RME_PAGE_SIZE;
> +	unsigned long next_addr, addr;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		int ret;
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		ret = realm_destroy_protected(realm, addr, &next_addr);
> +
> +		if (WARN_ON(ret))
> +			break;
> +	}
> +}
> +
> +static void realm_unmap_range(struct kvm *kvm,
> +			      unsigned long start,
> +			      unsigned long end,
> +			      bool unmap_private)
> +{

Should this check for a valid kvm->arch.realm.rd, or a valid realm state?
I'm not sure what the best place is but none of the RMM calls will succeed
if the RD is NULL, causing some WARNs.

I can trigger this with set_memory_attributes() ioctls before creating a
RD for example.

> +	realm_unmap_range_shared(kvm, RME_RTT_MAX_LEVEL - 1, start, end);
> +	if (unmap_private)
> +		realm_unmap_range_private(kvm, start, end);
> +}
> +
>  u32 kvm_realm_ipa_limit(void)
>  {
>  	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
> @@ -190,6 +341,30 @@ static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>  	return ret;
>  }
>  
> +static int realm_create_rtt_levels(struct realm *realm,
> +				   unsigned long ipa,
> +				   int level,
> +				   int max_level,
> +				   struct kvm_mmu_memory_cache *mc)
> +{
> +	if (WARN_ON(level == max_level))
> +		return 0;
> +
> +	while (level++ < max_level) {
> +		phys_addr_t rtt = alloc_delegated_page(realm, mc);
> +
> +		if (rtt == PHYS_ADDR_MAX)
> +			return -ENOMEM;
> +
> +		if (realm_rtt_create(realm, ipa, level, rtt)) {
> +			free_delegated_page(realm, rtt);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int realm_tear_down_rtt_level(struct realm *realm, int level,
>  				     unsigned long start, unsigned long end)
>  {
> @@ -265,6 +440,68 @@ static int realm_tear_down_rtt_range(struct realm *realm,
>  					 start, end);
>  }
>  
> +/*
> + * Returns 0 on successful fold, a negative value on error, a positive value if
> + * we were not able to fold all tables at this level.
> + */
> +static int realm_fold_rtt_level(struct realm *realm, int level,
> +				unsigned long start, unsigned long end)
> +{
> +	int not_folded = 0;
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return -EINVAL;
> +
> +	map_size = rme_rtt_level_mapsize(level - 1);
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		phys_addr_t rtt_granule;
> +		int ret;
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
> +
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			if (!WARN_ON(rmi_granule_undelegate(rtt_granule)))
> +				free_page((unsigned long)phys_to_virt(rtt_granule));
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (level == RME_RTT_MAX_LEVEL ||
> +			    RMI_RETURN_INDEX(ret) < level) {
> +				not_folded++;
> +				break;
> +			}
> +			/* Recurse a level deeper */
> +			ret = realm_fold_rtt_level(realm,
> +						   level + 1,
> +						   addr,
> +						   next_addr);
> +			if (ret < 0)
> +				return ret;
> +			else if (ret == 0)
> +				/* Try again at this level */
> +				next_addr = addr;
> +			break;
> +		default:

Maybe this also deserves a WARN() to be consistent with the other RMI
calls

Thanks,
Jean

> +			return -ENXIO;
> +		}
> +	}
> +
> +	return not_folded;
> +}

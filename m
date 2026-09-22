Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686BA559C82
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091059; cv=none; b=NL43IlIYTtpBEgWX6SVlgCbOMg0MI31HV31BKCvqaDyN+S629YLVhEx81IBCMMY0iO1drnjsMFQndvAhNmjct8cArTkzT5A7ihf1ehQE6p7ADnoRAL0Ped6zOcgBqsz/Xa5FIf+2oP9W+oQWCHvzuu9uLQPW4ebIGas2YaO93Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091059; c=relaxed/simple;
	bh=vNjOMpe/XMDvYnFfJwC48AyuS1vuPk+FSssxslTQZJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNO0de01YHq0nFd5tzmm18VtKfBv4BrsRn8b/YvdfiI4zerxI2+jKJ45LnLUprshT6q8sO2vulyUsrQ1Weua9mzaOPW9o4OSHICR0C7q0RZNe2tuvN9+dUCtLvOtXEkz4V8aMFFUICGm+Z3eQFQ9mc8hOzSXBN9rvBwT85IpVmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SKvZaBmV; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SKvZaBmV"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-498012a61f6so47715e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 08:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790091055; x=1790695855; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a74MW44grhNadd50edVJgnCMHiCGD4sP0/5a9THSw4A=;
        b=SKvZaBmV5o/fmVjClr/ZtDZ+1UHPFeNKlUs7EW2V/h0RflIGYhYwoPUjG+pZNk65VT
         lM6HnSySCrV2bg0y4agiQzSI4mO29SCHDF6zf9TYjN4ybS06hxkryjLfaEVIp8RcIC3y
         vNVLyiski4RvVYLM8NyjiY1MiTB+ulLKLxoSrRrpcHvkPENX2iUwbVQDLUyvlRrRUIqg
         9aVscvpfVW7wqEPtKuFgSoGDE9QDjIZesWEjWW0YGarE7b1tPY0XddAOAcUkUUzQHzsJ
         X+aBSsEXsHFROj7lIDF0MRksCZzPnUDs8zyksXBcL8tDbzZB4vNFs73ou4FfzIw63mPE
         COqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790091055; x=1790695855;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=a74MW44grhNadd50edVJgnCMHiCGD4sP0/5a9THSw4A=;
        b=FF/3GjwzTFT7WXiFh7DKw3NtIRWZciglAGGBcvpbD5vEkel3ICNQzrV6ZDgawzskEi
         Abs1nvAh79jJknkgOlJPJD2tWT0OaG0nyw09DpxGAR8ILiTcZg/SddxXVwgBs5GKpywe
         at6RIXQ4qUvzINiq7MB3aWJDKocmZ7vTIIE0IGeiGzI248mW4I4FDSfq2OiTjspS1PiT
         5XOZDmhyIaJCJw65FEEbNhQA5cQbI95LawWZkqI4UqHur1DIb8VSzpQT/0tvSfEmAe0A
         Sk0cLV8+INUzvV1yaLm4HHbPJ54hIxMq4Hjil40MlvWU1RQFfLw5AYtwNpRb4E8L5o3m
         avlA==
X-Forwarded-Encrypted: i=1; AKwUvBwHNht2aey0W0dxWWklS7klhO7LMJ2fqcfAVLjMbryd4mgKKUvRPN4ov9Wtpdl0SGJBkHb6ZH8=@lists.linux.dev
X-Gm-Message-State: AFuF++n7oY85otmw+dy5f3TvI+aaCkLR4omwW/TsLQRyyvprEeOtDyjl
	kE5AjRYGctKYH+lev2RkZc8bpByiKNw5zhexhhoxF4jmqsr27en3R3CB+Rn2jA/B7g==
X-Gm-Gg: AYBFou2n/X5Ub9Kieh8wrBP5IJwj4kairbPBR9wh5UGu71MA91LLcyZdM7iWAKidFPE
	69yjD7H6x2To0pxHj7QQ6P+7w+yqhyp6HmnkOfqMtgqwplx7OHkX2r8W9ga0S16DbYybQfWxJ/c
	9tanAPJrkBG074XVsA7hZwtj9NNoqdK9+Em6raYTzCAuW4Jvat+SHv5xz8QtFgQ0LQnPPcQz3Ow
	OdryeShHLsV1Y5fS5jwpKBZnjk8U5RBQs9pHQvWJnwr0m9m0CbvdLR/rKATxCb8eVluABlhTtIA
	8jy5SBhPQObUO54Hzdzq+IeCpZN2wePlpB7xJoTiWHQXo8KAlJK47ucwUHyeRMR0tx+y2qOFAy0
	bjDpPfQxGomPVCdC/tm5CqIATy3UYYQ9uI+FyJe7D42EJ0nI5Egw66cRUdjHulHZCi3rwJLxwS4
	58rjRim9vSqzaZDyMxuymZjnwIhtaY6kd7nYtRXzDyJkJFDqGDZkrA0tbgtdCJnfymyF1zwo2NL
	ZHvRhK9cFPyiXTiavC0o+1wQAsizHtc1urZqfT7gQ==
X-Received: by 2002:a05:600c:22d2:b0:49c:fee1:5095 with SMTP id 5b1f17b1804b1-49fdd9c6041mr158085e9.16.1790091055045;
        Tue, 22 Sep 2026 08:30:55 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fddfe361esm2281105e9.11.2026.09.22.08.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:30:53 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:30:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v8 13/25] iommu/arm-smmu-v3-kvm: Add MMIO emulation
Message-ID: <arKfKqwNN11C3yad@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-14-smostafa@google.com>
 <20260922132232.B2E301F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922132232.B2E301F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:22:32PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] hyp: fatal WARN_ON(!mask) on host SMMU MMIO access
> --
> 
> commit 0f61ec17741805782c471d3c6da0d9dad62368e6
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Add MMIO emulation
> 
> Add data abort handler for the SMMUs, at the moment most registers
> are just passthrough.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > index f8b7c5406017e..7a51cb70205fe 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> [ ... ]
> > +static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> > +			     struct user_pt_regs *regs,
> > +			     u64 esr, u32 off)
> > +{
> [ ... ]
> > +	case ARM_SMMU_CR1:
> > +		if (len != sizeof(u32))
> > +			break;
> > +		/* Don't mess with shareability/cacheability. */
> > +		if (is_write &&
> > +		    (val != (FIELD_PREP(CR1_TABLE_SH, ARM_SMMU_SH_ISH) |
> > +			     FIELD_PREP(CR1_TABLE_OC, CR1_CACHE_WB) |
> > +			     FIELD_PREP(CR1_TABLE_IC, CR1_CACHE_WB) |
> > +			     FIELD_PREP(CR1_QUEUE_SH, ARM_SMMU_SH_ISH) |
> > +			     FIELD_PREP(CR1_QUEUE_OC, CR1_CACHE_WB) |
> > +			     FIELD_PREP(CR1_QUEUE_IC, CR1_CACHE_WB))))
> > +			break;
> > +
> > +		mask = read_write;
> > +		break;
> [ ... ]
> > +	}
> > +
> > +	if (WARN_ON(!mask))
> > +		goto out_ret;
> 
> [Severity: Medium]
> Is it safe to use WARN_ON() here to validate host-controlled input?
> 
> If the host writes an unallowed value to ARM_SMMU_CR1 (breaking out of the
> switch before setting mask), or accesses an unhandled register offset,
> mask remains 0. The subsequent WARN_ON(!mask) will trigger a fatal
> BRK instruction at EL2, crashing the hypervisor and the host.
> 
> Since WARN_ON() is fatal at EL2 and does not execute the goto out_ret
> recovery path, should this validation gracefully handle the abort instead of
> asserting?

Yes, no well behaved host will attempt this, so a WARN_ON() is better
than ignoring it and making it really hard to debug.

Thanks,
Mostafa

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=13

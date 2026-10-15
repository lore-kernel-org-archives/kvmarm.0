Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4AF481255
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099442; cv=none; b=F9+sW3AagHO4107wDHuaUPaKojvlaghNPD33htgi0BkdORUchCcZtO6xHGLP8n/uDTtQ2F9yRAjcAjgKU5WPBXpfuy11rj5pP3dT2aAvYkUvlljr/t/8TP4SP1cEA1oat6SJhgWsugXII2JWKnWLeGlfLfk+8NoyqNThxNAXRVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099442; c=relaxed/simple;
	bh=S8fYKrfNvJJv66Z4s8STvMnElaZy7qPGtoS/PedPDTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caVWeZoB5dfeD8BGaWQIzD/AK92Qa2J/qQvR58U7f9oIdyT41V8q3wUm0z3cAh+zSUTsPM5v/VDoHAuHRaSTw3ye0td5V3/1Tkv3p9PoOlLVXnshzDz0zIMPUFnI8Tc6Uik45rRU8J2L5qYE6ceKE8WSvMeU2yTJ25hfDH2riR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NLOCV02y; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NLOCV02y"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a026611b2cso6085e9.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792099434; x=1792704234; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uFAkmU2KNoHsXl07ym0ghH6ndIdP/5rBqBbNPJbL8TM=;
        b=NLOCV02yBwVfuzDbnh9p9p0EVw3msUTwxVxRzNeNUErw8Edxk2lYebb8X1wp2s2D1Z
         0q5oWEbgPfwoAIxy/NkYy7azodm+yME4Yy8c4IHE0QYUYiT+8exXNKn5JiFFfrEvntWe
         WXjuLEpS6SadQXwG6oHTz+Y2tEwpm/9OyD2+4/0pcYwvn6CeXseWNAKe1SJV2qPNXMOI
         garitaxrx3a60S8E61d4k5vcMe0kJjo243iZthTH4noTHtpr9GOOo0SKkVQ0qgl/inAb
         FmuUWoj5LEGIRINWGUxRXfcSpHxkLKpKriJmkeCmItne3cZRbDwEJKfWdboqocaETRTm
         HBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792099434; x=1792704234;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uFAkmU2KNoHsXl07ym0ghH6ndIdP/5rBqBbNPJbL8TM=;
        b=dESkWs+VaDbHL8BuR52leueakaVtRIjt28CGCILhGqPMtfDrIoSFge3f96ad+3rmvE
         KtGudXS0j8neaeNsk2X8sEEDfScjP3S2UArddujC2aYrD229Six/eDjRBGd1wafUCEsz
         mOh8vZrQxe8F4DVFyyy9ddD2xFjjRCp5jZ5/ob+zlx9lepChZEgP7GODsNCD19ZgO+/A
         jgxBUE+Kt3YPDbmCowKVOTH57lrqVV7vfuCFhiYFbQ8hWSa8fX1ZMQWflmN/7GrmEOz4
         EuyzvMIgJWXM2jTEHLn6P1lwFeFnaaAO+v3iMOCHjNPl9Z/+810aMggOjK4/OWEyTDX1
         sJKA==
X-Gm-Message-State: AFq9FYLjyN+aN5Xle5tYsJqkTdZi96czsXt+0m78D7haqbmHHTRUzQA5
	U1UyQTjvVvXXbGXwH6WHsBkIHvDBmduKiu9rHnzWRiL6l8phpmQiz/NNK6vjvu4StQ==
X-Gm-Gg: AYBFou2tiTWGbLmVyXkwYvyhS7L66qqQTfOW8tbIRqOBh5FmLPTvhCJCNDtPVXmXsGW
	ohDHACVHbLip7XFrYfmuMmiUAioBbZSXHMpVglFmJXqP95fN744J5xyxsjvbbhqshfI7+GRlrYa
	AaAhaOWYUAjLO/tdR4b6/8isaezWjpf4tnVF8fPLyBIQaE94KiVRBCyaFnRq5mXb/1muayBWjMT
	+2f8lqda8XqFJFBeyRWu8i5wN2FVR+BqiW5LEKHavbtRPPsuvBe6PU+MiHbpkwbEDWjq03Ngkw9
	2Z91qVBUXhlbnlXw51uOKcVBg7E2hTWbyREEc2dOQDM4Wvn63nfLj6HDPL6ywfBkeV0Wsj+V8bY
	Aoc8ZN2f38RgAxfiof5tK3gmTK2Lo63xXj8fr51e52dRXMzjIrd0HmdBEzynx/WXOYxFlC9nx1W
	e9pzzwhd/gSfFI7bE5vfRjpsIE/8ctsiCOYkdpe+yWuZdB33Qa4l1UV98fDp+zeKnG/A7CwiWmx
	SbB/SsmPN+Ou9TiSxv4TIZZN9mXdfRAOIlH0YYSRqQyehjiwAY=
X-Received: by 2002:a05:600c:6b09:b0:4a1:80d4:55ce with SMTP id 5b1f17b1804b1-4a1c851de60mr249445e9.4.1792099433592;
        Thu, 15 Oct 2026 14:23:53 -0700 (PDT)
Received: from google.com (160.193.189.35.bc.googleusercontent.com. [35.189.193.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8af2fcesm7139825e9.8.2026.10.15.14.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:23:53 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:23:49 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 19/25] iommu/arm-smmu-v3-kvm: Share other queues
Message-ID: <atFEZVR0zT00l1y_@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-20-smostafa@google.com>
 <sashiko-outbox-173392@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173392@kernel.org>

On Thu, Oct 15, 2026 at 08:29:08PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] iommu/arm-smmu-v3-kvm: EL2 panic on kexec due to locked EVTQ/PRIQ base addresses
> --
> 
> commit bfd6e271a581b5d4148ccc397cc5a82480d46470
> Author: Mostafa Saleh <smostafa@google.com>
> 
>     iommu/arm-smmu-v3-kvm: Share other queues
> 
> This commit introduces pinning and sharing of the event and PRI queues in the
> hypervisor to prevent the host from writing to protected memory. It enforces
> that the host cannot change the base addresses of these queues once they are
> shared.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > index 132f3a9ba3084..1972df1d2a8dc 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> [ ... ]
> > @@ -806,6 +852,34 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  
> >  		mask = read_write;
> >  		break;
> > +	case ARM_SMMU_EVTQ_BASE:
> > +		if (len != sizeof(u64))
> > +			break;
> > +
> > +		if (is_write) {
> > +			/* See ARM_SMMU_CR0 */
> > +			if (is_evtq_enabled(smmu) ||
> > +			    (smmu->evtq_shared && smmu->evtq_base != val))
> > +				break;
> 
> [Severity: High]
> Does this rigid check prevent the host from performing a successful kexec?
> 
> When the host executes a kexec, the new kernel boots and initializes its own
> SMMUv3 driver, allocating new memory for the EVTQ and writing the new base
> address here. Since EL2 state persists across kexec and the hypervisor never
> clears smmu->evtq_shared upon disable, this condition evaluates to true.
> 
> The break leaves mask = 0, which then triggers the WARN_ON(!mask) at the end
> of the handler, resulting in a fatal hypervisor panic.
> 

kexec is not supported in pKVM.

> > +			smmu->evtq_base = val;
> > +		}
> > +		mask = read_write;
> > +		break;
> > +
> > +	case ARM_SMMU_PRIQ_BASE:
> > +		if (len != sizeof(u64))
> > +			break;
> > +
> > +		if (is_write) {
> > +			/* See ARM_SMMU_CR0 */
> > +			if (is_priq_enabled(smmu) ||
> > +			    (smmu->priq_shared && smmu->priq_base != val))
> > +				break;
> 
> [Severity: High]
> Similarly, does this check for the PRIQ base address cause the hypervisor to
> panic during kexec?
> 
> Just like EVTQ, the new kernel initialized during kexec will write a new
> PRIQ base address, triggering this break and hitting the same fatal
> WARN_ON(!mask) further down.
> 

Same as above.

Thanks,
Mostafa

> > +			smmu->priq_base = val;
> > +		}
> > +		mask = read_write;
> > +		break;
> > +
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=19

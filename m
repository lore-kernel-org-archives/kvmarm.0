Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE1E2DE711
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 09:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763632521; cv=none; b=aBRSweV0YTRsqkXl402qqAuDghFHdQHL4laB/xBtbBjZ4ew16XEf/o3pL6FSnPZFuMpCyLN/oewUIdAtbxYX5XJ32ZmWhP6pyVZ1xf61mgMEQTKH/tJaur459A6+6BBtmUSGctX64WoLOu8vY4aWSPjL9SFbPwY9Z7Ry91S6I8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763632521; c=relaxed/simple;
	bh=ArxGOMiOJjMc3O/3BTttrN1R0+lQiHUEPUxEsA7xDDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZX1gWnQW0hvQowAAJuxX7BxY9w+FKKCNtJW9E0EKiFFn1Gb1kmer55LzJYyL/SwHna+tE1S3i6eVEA3tDaN8d7097nWAnooV06/AI1aERDvyLmJq7rJCNYPzllbk8rABy5GLaFswP8VQBWMmP1TKfZlO9oK4eAG4pwY1SI/tll8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mumKMI8G; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mumKMI8G"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477a219db05so4318945e9.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 01:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763632518; x=1764237318; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XJ1a6GXdAz13/z+frt7ZsPUiHK+rVmDTT+AWenA3aKw=;
        b=mumKMI8G41H8H9Vx4jR8ykTyHhYfDChbtHeJNZbPAoIYzE+Fdxk4jbpxQeutevlELd
         sWTOgIM8bKCiJ3k0ilEEU5gPPAIcsYw7MHTGxUghEhTL1VyeU/3Nc87Ioex+anTf+7I8
         oeS9/ZzwbwPbZSQYRV2Y9BbZc/uBor6WXJgfHlD+DLYXcpOY4Z3Ic+FoG8k1DBXEV+MQ
         KbPoBQ1Ej6/LXAt9xrqz7X27REqyTB9waslmojUsKJ2o3xBtQcaWdyP2ENl2+14XFLIc
         Ir49+QM3W+a+xFD5+AzVezZmAXOWDJd44qfErMxXfTm9HSjnq3vEqnzaEhCbySkL7UoQ
         QwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763632518; x=1764237318;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJ1a6GXdAz13/z+frt7ZsPUiHK+rVmDTT+AWenA3aKw=;
        b=Yt+GIEwqBh98332oT3f7vAHo43Qve3EEUpga/1ZZ+djytLyNdcVgPypU9OKfqf5ou7
         8GfAPPmjTMEfw3g5YzzrO3gkfmbMh/7enXG6HyH3TMUzYvZqLQl9CWg0YSx5VFV4zDX+
         r+HUR/PhuYGvmYdE6EGaruSer4If99bhJZxJNM98odO5MAN4zrCQGvEAMZB3knL25Mib
         yNVJRpZqLFF3LQIocLrDT/gejajUIXDOrSFo0HrbERQ0YXM4Yv+SPEDqCoVAOqkLNCAX
         /bMewlJ4tMJ5fW4ktIUuyJnPFhzssJgSR2vQyxhADRE1uvWSD4y2bniTb/vaGV+slpzg
         qCXg==
X-Forwarded-Encrypted: i=1; AJvYcCW4t3Wy8cYt3GIBrRD9iS+hi9RCeeyFNdnjISQFIlxXY6LEm/p1wzpPy1tu0Ui/RTgnH7T0C/k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx47SWqTiZjtY6A6ACu1cOgJBCJcUpMngPp8rud3l9FnoAGNn3E
	/qDR3XEnrhuPq7ytuDi2wIak6d/oBCfUrwPPDnPW2/8mRqMmGpH2B8DUFcB+KW9yCw==
X-Gm-Gg: ASbGncu90BHsaxXo3AWvA1koJi+rR8rIkup8uDuYoqBUZPoZCW+01YBA6RXjy9yo79K
	jXvhw93SjqGEbZu0iUc3m2ypCJHelE2LFR6zPxz1qFyHUcufBKOUbw1SUK2m9cT8IXO8LWyCfCf
	/oBEIsNaej9vek2bdSTuy1yvRG9p2RsIJkI62N+fs3FFpgFIuMHVZo1+jd3NcgDrywPbMhFydIe
	cetHjm+GzeGtjUPOBBtVDTYxIlX6kM9UdXfNDQfcYUP23ZniFELCad3xaQ2IZdIP4qS3/q97YXs
	07Fw87c7OO2J3z32kgFituh4i7kRAzhcCFWXaLvoDKnDUT80qQ9Ee3Ux/Hxt29/SBkVLH+Qcez2
	xq/+aeltJNA2JDJWIlpKAVoLzEXf0Km2/7yEHLZkwEwJcxB5Fr9fa0/mxk+wxCRv2s7KWOTF3Mw
	sd5kcKjHddx84wRgXuM9RszrYebGRJ//yVLCV2WawoklKuZvtsIQ==
X-Google-Smtp-Source: AGHT+IFJRNp2sRsVEs1GlQW6MJTcF2zwsPsEOfrLSK/NN3A774PXikUBAOOjBZgY44x25hx3cSpDQg==
X-Received: by 2002:a05:600c:4ecd:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-477b8a9b267mr18043455e9.25.1763632517489;
        Thu, 20 Nov 2025 01:55:17 -0800 (PST)
Received: from google.com (120.54.38.34.bc.googleusercontent.com. [34.38.54.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b831421fsm37963635e9.10.2025.11.20.01.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 01:55:17 -0800 (PST)
Date: Thu, 20 Nov 2025 09:55:14 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 19/28] KVM: arm64: Support unaligned fixmap in the
 pKVM hyp
Message-ID: <aR7lggObvo-2Yrg5@google.com>
References: <20251107093840.3779150-1-vdonnefort@google.com>
 <20251107093840.3779150-20-vdonnefort@google.com>
 <86ecpurq13.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ecpurq13.wl-maz@kernel.org>

Hi Marc,

Thanks for having a look at the series.


On Wed, Nov 19, 2025 at 03:38:32PM +0000, Marc Zyngier wrote:
> On Fri, 07 Nov 2025 09:38:31 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > Return the fixmap VA with the page offset, instead of the page base
> > address. This allows to use hyp_fixmap_map() seamlessly regardless of
> > the address alignment.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > index ae8391baebc3..75014dc7d82e 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > @@ -239,7 +239,7 @@ static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
> >  	WRITE_ONCE(*ptep, pte);
> >  	dsb(ishst);
> >  
> > -	return (void *)slot->addr;
> > +	return (void *)slot->addr + offset_in_page(phys);
> >  }
> >  
> >  void *hyp_fixmap_map(phys_addr_t phys)
> 
> This looks slightly odd. fixmap_map_slot() should return *a slot*, not
> something in it. Can't hyp_fixmap_map() do that instead?

That was fixing hyp_fixblock_map() at the same time. I will move the
offset_in_page() in both callers.

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294904AA01E
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 12:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792413751; cv=none; b=rtEJuou7ukAUl0iok3WtT2IHpbkbOt+VGUlnZLCzaOTkypUPe1BZTrvXDAZv0iK+g+yny+es0zFTq6xeLknehOZt4s8N9kAkoikimZR4slj+wrHvQmF0efgft7/w1R/m5uwIPWuY6HBxk0OgUSG1P3Ev3/V2ovsXaIgw+5gGvDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792413751; c=relaxed/simple;
	bh=7iJWaNZjgRSi040bMTpFn/A5Npb6/NW/Z7ByvR+hrS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ghz3pyGVvDB2uFe7Rg1sCtTvME/mkoYcLuOtouIl9uqBiUoxLdvwaRL/wlccOBI56NYjuvtFUHK3r5ivf7A4uI3a0qLvib6YNPo/xSOf+Debjj6TAnWm2q2rZRhMFITAKKFnmY/YyyYA4huwSvvT7WcXPB0C+V3JD9sq8qTPCyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oN22hDeN; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oN22hDeN"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48b042c0759so1270230f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 05:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792413742; x=1793018542; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y7EoCo9+cczE65jwKsEPVDD2E1w/i2GesRReq0VwToI=;
        b=oN22hDeNoSnKvPCeDWBLa6PHbk9kMrfo5lqWrlbaR9MwUV+pIO9IuM0WKcsvxP1LWk
         On1v1VQjKLQ/LKpacOzeTbjucWLC5R5Fcp4fTqC/9ZD6vuWI1NLxbdELfw+a9623Mxfw
         4tvGEKPXKVWu94TIHvOeMQyyOqHenWsRsgP7I8kQmQNw3FDY1CCoL2w/8uFCuPth4Rck
         i/Na7KrICaMGFedcSfNIFrCQoHXmblZUVqNJuasHXHT/xSgN5NI+fTUz/wEcjc1Eclsf
         h4Afk6mwQzvUa6uhsZ9+lBkDTVQ0NxBYMPa0JFL2mZM6kNqlxiYk/ZDfcI4wM2o10tKi
         8oRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792413742; x=1793018542;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y7EoCo9+cczE65jwKsEPVDD2E1w/i2GesRReq0VwToI=;
        b=dDQXtTkoHCGgZB0WgrGLBOAySDO2s5zik+A69DQjJ5NfmM2N712olahODjgKQsfAhS
         iAAsadivMB8aMybTbEwLCvEypUsWi/Ml+jN58WRVIEb/38Cm/cciCNZHdn8vnKvd3yW2
         xeutz6xV8DQyGs73y8ylMj0HiETnsJFou86u4y7eIDCs/8b4V1M82UPFlq2cMVBpd2Db
         7T3OyPlovbS3t1cnot6pP8DuzT/6kKQlef+XEfaPddn762hArwjtY7RWmSZ1apckd7FV
         LjdwGyYZfbnlrMpARnjYf8G8otz3ooAMdid5or0l8Yl+7kYV3WerMQlTiVZAgmV7VbCT
         Qt0A==
X-Forwarded-Encrypted: i=1; AKwUvBxj6xQffd21UHuT2MKjFZ7DprCTCgDO25W495+UY/pWKpEzeMPHwNSvUuiQzF/nkRUXSdh8SpM=@lists.linux.dev
X-Gm-Message-State: AFq9FYK50ajY2hZnoRYVLTotti3WpU8cXQgk1b+13otPSOKkv8f6iIh9
	XD+U9eAfR4TeXj3/c4VyNrLlNKool0SkMXVk0UrFSSjU9xzOttEFvV6kEYJiMCQPPQ==
X-Gm-Gg: AYBFou3WzU+E0FlOFBtsaBDBiK/SjtHhbGkIH3oLm2a31wJ1nyqQERwHoajVkpLuO61
	cD84pmwWtTxcll8Gunh2BrwVQOYDg2UgIBZJ+f5LjMhVSKoywaHoFLYxNCQZAqi3J3X4Kjyzdu2
	C0GBnefiwMKM/GTVqszKEhhBMImozPXSjMqaHTGouUKKMkPkUZzT5bjvprI63syEyhjnI0iabpl
	Eywg8VzcGq2WnTNwgoMcULEkmGtLSTbEeiH871t5k4+NAOI5BZG3HmpW5+4FDr+u8efPVbdxlFf
	GqOfH3sBvK9aQiIJCHTkLeZozrrbPW7qP50nUxFcH75sAnFkI9wljVJADxKsJ60yjNdENPVeSv7
	x2uVZ2FIbeXIooKP0dmUciGb6dw8FfFvxO9RdKIxgF4CUyJykD+NkOATc9wNvPFIB2HWgf0viId
	SV55mR8M1/87QAjaAlZbDpPLQuJMkq+3WSeuugPxdmMbixesitQXsebO2VDLA6dRh8/j+BRlsVS
	E7XTexe+cky+sI4lbYGWHqDwBn/8IBaVixdUXBrMDk=
X-Received: by 2002:a5d:4904:0:b0:488:7787:469d with SMTP id ffacd0b85a97d-48e07fbbf4emr11756626f8f.25.1792413741500;
        Mon, 19 Oct 2026 05:42:21 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd503a0dsm23717496f8f.47.2026.10.19.05.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 05:42:20 -0700 (PDT)
Date: Mon, 19 Oct 2026 13:42:17 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Ensure TLBs and I-cache are private to
 each vCPU in pKVM
Message-ID: <atYQKaLo4VJDoNJn@google.com>
References: <20261014125510.2928306-1-fuad.tabba@linux.dev>
 <20261014125510.2928306-3-fuad.tabba@linux.dev>
 <atXqLxU5bBtJ8U9W@google.com>
 <20261019114357.3528498-1-fuad.tabba@linux.dev>
 <atYPZeJuw2grFDlz@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atYPZeJuw2grFDlz@google.com>

On Mon, Oct 19, 2026 at 01:39:01PM +0100, Vincent Donnefort wrote:
> On Mon, Oct 19, 2026 at 12:43:57PM +0100, Fuad Tabba wrote:
> > Hi Vincent,
> > 
> > On Mon, 19 Oct 2026 11:00:15 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> > [...]
> > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > [...]
> > > > @@ -54,6 +54,9 @@ struct pkvm_hyp_vm {
> > > >          unsigned short refcount;
> > > >          hyp_spinlock_t lock;
> > > >  
> > > > +        /* Per physical CPU, the vcpu_idx of the last vCPU of this VM loaded there. */
> > > > +        int *last_vcpu_ran;
> > > 
> > > Unlikely to be a problem in pratice, but vcpu_idx is "unsigned int". I wonder if
> > > this shouldn't be unsigned int here too and initialised to UINT_MAX?
> > 
> > I'd copied int and -1 from the host's mmu->last_vcpu_ran, but the
> > vcpu_idx it's comparing against here is unsigned int, so I'll switch to
> > unsigned int and UINT_MAX in v2.
> > 
> > Thanks,
> > /fuad
> 
> Also,
> 
> as it is always allocated when pkvm_hyp_vm is, Would it make sense to add this
> to pkvm_get_hyp_vm_size() instead of allocating separately?
> 
> -- 
> Vincent

Ha, I just saw your answer to Marc and you will switch to a per-cpu approach
anyway it seems?

-- 
Vincent

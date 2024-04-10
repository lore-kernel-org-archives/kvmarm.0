Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BC6155733
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 10:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712744304; cv=none; b=lGYTXhHcEinNANz25p5Rre69pbkJyVlAkkK+xRUPYyNauusKwZ9Zyt/DZxg19A6wZRcpKrVHGS8r2If0HwODwHtDO2hZyz5TJu3MZL6u1HP0xjKB1sxnI4Nez5mLMUXAXGnOPHWaIhIjYeh35rzWjqekv7avGgq7bLP/Zcx+VFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712744304; c=relaxed/simple;
	bh=QNa9q7fl0QpNcL5PdvTdh8BoZUPCJ2zBMZ3FZ5JDDRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpnIYcn2nCKvjfSYDQzHDJh0GAUqZOxhcyswp3YaTwF0AezdXups4QGRDrQmwdO+ieioPODEmIsjguZV6JbhcEBx80egq0KnFhp/4HBnP6eDhGTrONtL2n8mVmn2r6G4kqwD84UVWDgIyghYPxDoPpPCpW67vtdfCkOY3CXUzYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aQmzY97C; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aQmzY97C"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-41641a889ccso48845e9.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 03:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712744301; x=1713349101; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vT68oS4RVQULaWAEFFaBC6rqDsXdkDc5eppWUMWD6Io=;
        b=aQmzY97C9Be+KIy0kgyzPfA7kaL698z8f/e/zQllccqEBpGCF6u70D3tIS6EDpP/a7
         B1CLJzuyOROTLUo+tHAqE2EaBXmDRxInWon5iqB7m67siEFP2wcCUFCZCzwf8SRCAD9L
         s1qZNw3ddBPFoYIJLaDKGZiitnLMiBIM6L/bcI32zcXqjtTXl8V820gqWecMYDfKfEv/
         hCeOcWDRc4yGLacQKuyE9JpTa12B5y4GL3ecJDzPcCamw5o9ZPs6GGHtex2D/i3l8fhF
         ZzMk48P17OuqoTIYYN/LylFTe4XVFsXmN2sKVYQ2ULCplSKL3kG9ODQfXn2WOfIM2GDS
         YC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712744301; x=1713349101;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vT68oS4RVQULaWAEFFaBC6rqDsXdkDc5eppWUMWD6Io=;
        b=P6yXB/jIVG/dqQM3jRTmlS50uR3RQu/4Ly+7h8RUJzOOJJFbydCve0q5uDRg3/mxbL
         dDeaPuFaQtcK2maCLI3oQ+adN8WwDc9/aOBN1Rwe9wg/GQ9XuOmrva06xby/NPeTMUYS
         0YS1yYXif5DjJ3qm9OLsjf39G5r38mdRAjeiYAoXuJMgC5FKfmLJb4adcJbUJzvJrYWt
         i+GHGmGrTB+qPfi9MFLkeimYBcmYdw99ODCQxXFzIyIX2+ppHJATZFCRR0Yp7w2NRdee
         4LYa8qXyzFckeIpfZpVykoNdkDZ9TymilLGfQ3dwNqJOL3UlerBWLxs7Agw8lTYqxesQ
         4tNg==
X-Forwarded-Encrypted: i=1; AJvYcCWdRUahXgZWm7Aef2aDWZNwE2Mr63b95gknba9tR+dUOw3LJlgkV3z1ZV+rnpNq8zbKzb2ZaR40iJDN8V17oQinvczVNihF
X-Gm-Message-State: AOJu0YxFvIfjDMVyU09eeN1DsGdgjzKso92kR+jMxDWoOzr967Q2GqpK
	d4G+ynzY6M9oGFbtJME1UcvVOaKcMrcuffRNrSDb0/CWBiXEMh5LWppUmEHVGQ==
X-Google-Smtp-Source: AGHT+IF04oIgLfak4zpgaHX/QvWLj2Gry8uOBqaulhtF8YFr4xta0pvMXzu6sMK/eZd+mX/Vi1I/5w==
X-Received: by 2002:a05:600c:5105:b0:414:1400:a776 with SMTP id o5-20020a05600c510500b004141400a776mr111247wms.5.1712744300762;
        Wed, 10 Apr 2024 03:18:20 -0700 (PDT)
Received: from google.com (248.199.140.34.bc.googleusercontent.com. [34.140.199.248])
        by smtp.gmail.com with ESMTPSA id r6-20020a05600c458600b004162a9f03a6sm1832887wmo.7.2024.04.10.03.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 03:18:19 -0700 (PDT)
Date: Wed, 10 Apr 2024 10:18:18 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
Message-ID: <ZhZnaibTBaa2J4a5@google.com>
References: <20240409151908.541589-1-sebastianene@google.com>
 <ZhVpmF2js1NJp1qF@google.com>
 <ZhZYsuqggl_Hzv8X@google.com>
 <ZhZhm4UXyClAqXDM@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhZhm4UXyClAqXDM@google.com>

On Wed, Apr 10, 2024 at 10:53:31AM +0100, Vincent Donnefort wrote:
> [...]
> 
> > > > +static void do_ffa_part_get(struct arm_smccc_res *res,
> > > > +			    struct kvm_cpu_context *ctxt)
> > > > +{
> > > > +	DECLARE_REG(u32, uuid0, ctxt, 1);
> > > > +	DECLARE_REG(u32, uuid1, ctxt, 2);
> > > > +	DECLARE_REG(u32, uuid2, ctxt, 3);
> > > > +	DECLARE_REG(u32, uuid3, ctxt, 4);
> > > > +	DECLARE_REG(u32, flags, ctxt, 5);
> > > > +	u32 off, count, sz, buf_sz;
> > > > +
> > > > +	hyp_spin_lock(&host_buffers.lock);
> > > > +	if (!host_buffers.rx) {
> > > > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > > > +		goto out_unlock;
> > > > +	}
> > > > +
> > > > +	arm_smccc_1_1_smc(FFA_PARTITION_INFO_GET, uuid0, uuid1,
> > > > +			  uuid2, uuid3, flags, 0, 0,
> > > > +			  res);
> > > > +
> > > > +	if (res->a0 != FFA_SUCCESS)
> > > > +		goto out_unlock;
> > > > +
> > > > +	count = res->a2;
> > > > +	if (!count)
> > > > +		goto out_unlock;
> > > 
> > > Looking at the table 13.34, it seems what's in "count" depends on the flag.
> > > Shouldn't we check its value, and only memcpy into the host buffers if the flag
> > > is 0?
> > > 
> > 
> > When the flag is `1` the count referes to the number of partitions
> > deployed. In both cases we have to copy something unless count == 0.
> 
> I see "Return the count of partitions deployed in the system corresponding to
> the specified UUID in w2"
> 
> Which I believe means nothing has been copied in the buffer?
> 

When the flag in w5 is 1 the size argument stored in w3 will be zero and
the loop will not be executed, so nothing will be copied to the host
buffers.

> > 
> > > > +
> > > > +	if (ffa_version > FFA_VERSION_1_0) {
> > > > +		buf_sz = sz = res->a3;
> > > > +		if (sz > sizeof(struct ffa_partition_info))
> > > > +			buf_sz = sizeof(struct ffa_partition_info);
> > > 
> > > What are you trying to protect against here? We have to trust EL3 anyway, (as
> > > other functions do).
> > > 
> > > The WARN() could be kept though to make sure we won't overflow our buffer. But
> > > it could be transformed into an error? FFA_RET_ABORTED?
> > > 
> > >
> > 
> > I think we can keep it as a WARN_ON because it is not expected to have
> > a return code of FFA_SUCCESS but the buffer to be overflown. The TEE is
> > expected to return NO_MEMORY in w2 if the results cannot fit in the RX
> > buffer.
> 
> WARN() is crashing the hypervisor. It'd be a shame here as we can easily recover
> by just sending an error back to the caller.

I agree with you but this is not expected to happen unless TZ messes up
something/is not complaint with the spec, in which case I would like to
catch this.

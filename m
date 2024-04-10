Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D314817B503
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712769045; cv=none; b=fi43AQNYENysYHIkJVuXUCA67OeyfHx4IWKNX1IQSaI0ve6biMZwOc+IiuaQ9rQ+Q2U7gbEZJHYO/Pr5FfaBveQMbKw30uQYGCR42KBrzyduuLOOvpVmrTY0hH/T0VLvpmOCIxCTmiQfZ0lyWlFTBA5H+OZ8VKWfOMo5FwTRXy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712769045; c=relaxed/simple;
	bh=BnpeD//y6Emyg6pwhX/1SvzsGe/D9scnMaicPrlWrg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d92tCpyG9kWN6sIE07iP7s58BQonHcKt2ju8uPFXfCoRHywj1/0cdWvy4kjCpcXvdwqE+9rJbbIafJ+ZYLzLasyVQmgKrWUSd+Tb2VxPxhjEbhlLDKrnQZeSYCy2TqxIdqe95vRnrc0PrsWvQGiQJm8q8hD/7/gvJLVAG90vZBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pyqY+TsA; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pyqY+TsA"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-416f04059beso5869665e9.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 10:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712769042; x=1713373842; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jPAolQcDDgJY4OktndQFfIkIGL4ln6Jfg8j7dRhT7sM=;
        b=pyqY+TsAbOTkMS3jxvT/lsMB7+v2cDWsnIVOAHDBIltBuogOpIYb3E7bGKS7RwLWrS
         NcRV5b3Lw8HWZjaJwncG7bga4mErrudfuxQUqZq3OR1CYcfom1eSvH8RVDB5T9bjZya7
         pFIZSKBNaU/mkABU+EOIhomwt6vPP4FXgN4/grA1OdaSFQjaDUoRYD4Dmy+bM8qmWsNe
         pOOEzKAqqx51osAA/zdHMuFWKNp73iwY6Qsq0CyRurO8qrvVzZHGaUkCiY03CQ8FIbbT
         dD1e7sPCBID8DO84gm2QQpE54o2RGBVcsbJf4Ecze6dsHddrzqHY9erofhEtRog9EpL+
         L92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712769042; x=1713373842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPAolQcDDgJY4OktndQFfIkIGL4ln6Jfg8j7dRhT7sM=;
        b=JlNJVYwAqwGH9IK1yFKPWIJvelk3bjYiXsLE7P1Qud5y1MEsVNo6sjAiK4PiDJGbF4
         wJlsXwOAWXqFEPuSwY8K96oysPNQz4b/SSNmk8xT4tB8rtTCGh1ev0IFDVP6rbHFmqEa
         qVy3Rp+TD4w24dFs79fdSi5kMPrDn5U3rVWJrhWS5vAbeklAy69lFaPSTGrDe0O2a4fW
         1HEZ1d5xNstbQVUJGElxtKGREiri9TT7XY3YMb9hSFMJPsvuHRDn/gUdxv7MHWGxJyiF
         z0X+a6V4auYaF+gorcbUzCw2skpMjcPUEcCItdQiKpSN/gM6gFWLYKntLzm9HNFtueJX
         9jJw==
X-Forwarded-Encrypted: i=1; AJvYcCWxTf02Yha1/mEyYXjf+4ccxUQ93MzfaTeTnddr5shOPvsk+AT6jBl5FbDF08lePQNLNefj6fs4Nn8o5PlKbq0PfgcHTzkR
X-Gm-Message-State: AOJu0YwoU1oxjEAa8ST+9RfflGdAlvEMeAC4NWR088T95w8xEPO3AtQQ
	QXTBPm7QWJYtEXxLvBQHsczmspiYcw1C34rPfD+ovh8q3wy7bxRiSEEUJJHCOw==
X-Google-Smtp-Source: AGHT+IFuiUBGc1CYJe0Ub3hOpD127J9JpZKYHIWmsNnnCQ5/iQn3KNoIGFXIGnRIbSfXm9fkSnUotg==
X-Received: by 2002:a05:6000:225:b0:346:4d41:8d5a with SMTP id l5-20020a056000022500b003464d418d5amr1974050wrz.56.1712769041816;
        Wed, 10 Apr 2024 10:10:41 -0700 (PDT)
Received: from google.com (161.126.77.34.bc.googleusercontent.com. [34.77.126.161])
        by smtp.gmail.com with ESMTPSA id j11-20020adff54b000000b003433bf6651dsm13429411wrp.75.2024.04.10.10.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 10:10:41 -0700 (PDT)
Date: Wed, 10 Apr 2024 18:10:37 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
Message-ID: <ZhbIDUO9BULaiSh3@google.com>
References: <20240409151908.541589-1-sebastianene@google.com>
 <ZhVpmF2js1NJp1qF@google.com>
 <ZhZYsuqggl_Hzv8X@google.com>
 <ZhZhm4UXyClAqXDM@google.com>
 <ZhZnaibTBaa2J4a5@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhZnaibTBaa2J4a5@google.com>

On Wed, Apr 10, 2024 at 10:18:18AM +0000, Sebastian Ene wrote:
> On Wed, Apr 10, 2024 at 10:53:31AM +0100, Vincent Donnefort wrote:
> > [...]
> > 
> > > > > +static void do_ffa_part_get(struct arm_smccc_res *res,
> > > > > +			    struct kvm_cpu_context *ctxt)
> > > > > +{
> > > > > +	DECLARE_REG(u32, uuid0, ctxt, 1);
> > > > > +	DECLARE_REG(u32, uuid1, ctxt, 2);
> > > > > +	DECLARE_REG(u32, uuid2, ctxt, 3);
> > > > > +	DECLARE_REG(u32, uuid3, ctxt, 4);
> > > > > +	DECLARE_REG(u32, flags, ctxt, 5);
> > > > > +	u32 off, count, sz, buf_sz;
> > > > > +
> > > > > +	hyp_spin_lock(&host_buffers.lock);
> > > > > +	if (!host_buffers.rx) {
> > > > > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > > > > +		goto out_unlock;
> > > > > +	}
> > > > > +
> > > > > +	arm_smccc_1_1_smc(FFA_PARTITION_INFO_GET, uuid0, uuid1,
> > > > > +			  uuid2, uuid3, flags, 0, 0,
> > > > > +			  res);
> > > > > +
> > > > > +	if (res->a0 != FFA_SUCCESS)
> > > > > +		goto out_unlock;
> > > > > +
> > > > > +	count = res->a2;
> > > > > +	if (!count)
> > > > > +		goto out_unlock;
> > > > 
> > > > Looking at the table 13.34, it seems what's in "count" depends on the flag.
> > > > Shouldn't we check its value, and only memcpy into the host buffers if the flag
> > > > is 0?
> > > > 
> > > 
> > > When the flag is `1` the count referes to the number of partitions
> > > deployed. In both cases we have to copy something unless count == 0.
> > 
> > I see "Return the count of partitions deployed in the system corresponding to
> > the specified UUID in w2"
> > 
> > Which I believe means nothing has been copied in the buffer?
> > 
> 
> When the flag in w5 is 1 the size argument stored in w3 will be zero and
> the loop will not be executed, so nothing will be copied to the host
> buffers.

Ha right, all good here then.

> 
> > > 
> > > > > +
> > > > > +	if (ffa_version > FFA_VERSION_1_0) {
> > > > > +		buf_sz = sz = res->a3;
> > > > > +		if (sz > sizeof(struct ffa_partition_info))
> > > > > +			buf_sz = sizeof(struct ffa_partition_info);
> > > > 
> > > > What are you trying to protect against here? We have to trust EL3 anyway, (as
> > > > other functions do).
> > > > 
> > > > The WARN() could be kept though to make sure we won't overflow our buffer. But
> > > > it could be transformed into an error? FFA_RET_ABORTED?
> > > > 
> > > >
> > > 
> > > I think we can keep it as a WARN_ON because it is not expected to have
> > > a return code of FFA_SUCCESS but the buffer to be overflown. The TEE is
> > > expected to return NO_MEMORY in w2 if the results cannot fit in the RX
> > > buffer.
> > 
> > WARN() is crashing the hypervisor. It'd be a shame here as we can easily recover
> > by just sending an error back to the caller.
> 
> I agree with you but this is not expected to happen unless TZ messes up
> something/is not complaint with the spec, in which case I would like to
> catch this.

Hum, still I don't see the point in crashing anything here, nothing is
compromised. The driver can then decide what to do based on that reported
failure.

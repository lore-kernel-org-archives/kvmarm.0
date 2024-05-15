Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A74155749
	for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 15:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715787661; cv=none; b=SJjklaFO1n2ZD4KumeoYV2f1jqql5H75Xg9ZLvfI3atfCcFJ/Ijvbedx7HofK04iM90L/fIyK0FVD7zURi+/ggUt/LNPMpZgmuxxPFswCI13RLvw7w5JQTVv97hQ8mP7axfpTm9zAJb9gj8NfccX01mOZM1s+m6zBYUuXpOQFDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715787661; c=relaxed/simple;
	bh=Lf2nT4HegNDNqGDTyxgxTlXmuF0Xo/B3kUCwsMk/AxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZUbp6HFvUalpb/ZV+UUeCLQfkvN9mw1+4WmDghGsyNMF7IeSphRxeyamvnWsiGFw/zJi0stzZ6cl8p/MQg6I3YIj2DBh5cM4Q0oCOgdmGGzPe4lIn4f1JjWS2elmcCmFYoV3XEFSpJXjTb9iX8C3NFE2WlHHh3e1lCE1WB4B8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fN/AGTMX; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fN/AGTMX"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42012c85e61so285225e9.0
        for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 08:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715787658; x=1716392458; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vO+JXqkTWjh4IOLAvLgHOUrmin8Jhsgi5Im6h/wkV6k=;
        b=fN/AGTMXkGI3faVhDsReVo/ey74jDEQgwxqCZOOsTvRpCyyxa1CLaweuW9ln75KxzU
         0cd16lm0VTzFL0otJx4stc50I09as0FVyazBzXT7iNzpD8w8cKEDvGnxcXNvnOzbgsP4
         bjUlYJZusX8o36K7VIzgbdavuYQrU8eesOcFZBoXsbJGq1RhT7FfZ+NhQ4/8G7U5faFV
         ehyGxveISkyDpMcH6iEDAF4pLIrw93UuvuM3e3jVGZ1eAix32V4k+E9em3RTIK/zMPdK
         0Clk34PTpqG249vbDb2nJSGqC4I6eWW9gapCUPzYiFueknnqD5TKx+fH/aIIRlULE+g4
         vkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715787658; x=1716392458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vO+JXqkTWjh4IOLAvLgHOUrmin8Jhsgi5Im6h/wkV6k=;
        b=U5xEidH+p3qPRKFTPa1m4D7G3rbiU3i5KMjnRz3DJ4x9yMqbOMtAT9F7V+pfkQ51gT
         YvQm16cREghLkrBPir4409bqmqN7axP3j4BMB/xLhpVKuBrRPO2UaorJ2MCtNQIGevzp
         x8PEQl8mzM3z3Q9SCkBnM/5+MUBtWpa9coFjXB/xbo++wS/H6tGmf3MKbH6D2gTpEFSh
         T7eQCqXJh9wUe02r7b4XhKreSFvgnNgiyIymkOkguluQvs7bx9jTdTx89btkMjblUq1z
         pHTUlXVm/Yh9P3LK6/QQ9i1qyg9sv/u9jTbw7XZNLF6J+Bn+E4pe9PAVS6VvuOdVxT++
         PWGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhoiB9gxXjymykPz3UL5hAEdz+TNIRlzCM9tTa9z0yKuK1jAvC+r/hALA34nAOIAgS/msvVXHToM/JM1HQX381hxZ/cMCI
X-Gm-Message-State: AOJu0YymvfPrePjjCkjM93HcCiinJPhG71z+JbeAqsQLahDOKyLbTXwT
	mjmUMZOVgaoLawDSVS0vdd+wqRSreTRZkze1TgGEI34lTwSztsOnuGKpwBSowg==
X-Google-Smtp-Source: AGHT+IHpV0wJBjkz/uiNnJbApuw4cK0JvcZtxkvSENnR0QDdzmWnFUZlqPQiOoJqXfr/mDKKEF4FGw==
X-Received: by 2002:a05:600c:5010:b0:41b:4c6a:de6d with SMTP id 5b1f17b1804b1-4200f8b159fmr8618745e9.5.1715787657840;
        Wed, 15 May 2024 08:40:57 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42014c21260sm125210465e9.3.2024.05.15.08.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 08:40:57 -0700 (PDT)
Date: Wed, 15 May 2024 15:40:55 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, yuzenghui@huawei.com, lpieralisi@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 2/4] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
Message-ID: <ZkTXh_m9F8VA2dds@google.com>
References: <20240418163025.1193763-2-sebastianene@google.com>
 <20240418163025.1193763-4-sebastianene@google.com>
 <20240503150114.GB18656@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503150114.GB18656@willie-the-truck>

On Fri, May 03, 2024 at 04:01:16PM +0100, Will Deacon wrote:
> On Thu, Apr 18, 2024 at 04:30:24PM +0000, Sebastian Ene wrote:
> > Handle the FFA_PARTITION_INFO_GET host call inside the pKVM hypervisor
> > and copy the response message back to the host buffers. Save the
> > returned FF-A version as we will need it later to interpret the response
> > from the TEE.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 46 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 023712e8beeb..d53f50c73acb 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -674,6 +674,49 @@ static void do_ffa_version(struct arm_smccc_res *res,
> >  	hyp_spin_unlock(&host_buffers.lock);
> >  }

Hello Will,

> >  
> > +static void do_ffa_part_get(struct arm_smccc_res *res,
> > +			    struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, uuid0, ctxt, 1);
> > +	DECLARE_REG(u32, uuid1, ctxt, 2);
> > +	DECLARE_REG(u32, uuid2, ctxt, 3);
> > +	DECLARE_REG(u32, uuid3, ctxt, 4);
> > +	DECLARE_REG(u32, flags, ctxt, 5);
> > +	u32 off, count, sz, buf_sz;
> > +
> > +	hyp_spin_lock(&host_buffers.lock);
> > +	if (!host_buffers.rx) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> 
> This should be FFA_RET_BUSY per the spec.
> 

Good catch, thank you ! I am fixing this.

> > +		goto out_unlock;
> > +	}
> > +
> > +	arm_smccc_1_1_smc(FFA_PARTITION_INFO_GET, uuid0, uuid1,
> > +			  uuid2, uuid3, flags, 0, 0,
> > +			  res);
> > +
> > +	if (res->a0 != FFA_SUCCESS)
> > +		goto out_unlock;
> > +
> > +	count = res->a2;
> > +	if (!count)
> > +		goto out_unlock;
> > +
> > +	if (host_buffers.ffa_version > FFA_VERSION_1_0) {
> 
> The spec says that the size field is populated based on the flags
> parameter. Why aren't you checking that instead of the version number?
>

Right but the flags were introduced in the latest version (they were not
in 1.0). In 1.0 the content of w5 is reserved and this is why I need the
version check.

> > +		buf_sz = sz = res->a3;
> > +		if (sz > sizeof(struct ffa_partition_info))
> > +			buf_sz = sizeof(struct ffa_partition_info);
> 
> I don't think this is right, as if the payload really is bigger than
> 'struct ffa_partition_info' we'll truncate the data (and you don't
> adjust res->a3 afaict).
> 
> Can't we just copy the whole thing back to the host? We're not
> interpreting the thing, so we can just treat it like a stream of bytes.
>

Let me rewrite this. You are right, we should treat it like a stream of
bytes.

> > +	} else {
> > +		/* FFA_VERSION_1_0 lacks the size in the response */
> > +		buf_sz = sz = 8;
> 
> Can you define that as a constant in arm_ffa.h, please? It's the size of
> a 1.0 partition info structure.
> 

Yup, I am adding this.

> > +	}
> > +
> > +	WARN_ON((count - 1) * sz + buf_sz > PAGE_SIZE);
> 
> We should bounds-check against 'KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE' and
> return an error (FFA_RET_ABORTED) if the size is over that.
> 

Thanks, this should work I will do this.

> > +	for (off = 0; off < count * sz; off += sz)
> > +
> > +		memcpy(host_buffers.rx + off, hyp_buffers.rx + off, buf_sz);
> 
> I think this is wrong if bit 0 of 'flags' is set to 1. In that case, I
> think you just get back the number of partitions and that's it, so we
> shouldn't be going near the mailboxes.
> 

I removed this, thanks for the review !

> Will

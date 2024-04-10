Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5702D13D28F
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 09:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712742819; cv=none; b=B/SyMkHInwE01qew9LjgiVRwr7/OLaLFJUGdWKy588MpZmc0/1jev5d41ugnduEYUxtPMZtTGbCzUjuFAy0Xd0YUwK8M1JcaWo4qj3TgFkb8nSgI0sQ2TCbmYAml5+VCCew+qD3oEHyRc4aNHz45F+sZF4qIamlToYl+4mZIKLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712742819; c=relaxed/simple;
	bh=ZfZs2OEOLT/Lt0O35IJPmq35XOrtA4O0leIUv8gpuzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pnh7bdX3hpdsWpwH57L6+mlUD7h2TmsCyNyakDt49k/m7lUbCCKKMCpKx3sqMqLi961e4AvxWYt1v1UyYmED4xKBAYxOxjlWnB7FhRBbNpnEHqtcCxKXPCztzEulEoEK/MU2hN4is1MwLBuHOQI7wG3c+Fr/esYmxknTL1DZXmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P06ZnzMo; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P06ZnzMo"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d4a8bddc21so90757661fa.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 02:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712742815; x=1713347615; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a5V6Ab5KYZlb0KtyTlJwyIxL2QcpWe2gp9lR05o6q98=;
        b=P06ZnzMo5ZtA9gJm5nZi5LVIidGemQNWaPoMoi6DpuVzI/dKkf4mOmE9pE8fnuIzy7
         zRp5hBpGviVZav7IX+1lMn/4InBFG8h3qaQTInA/6uacXREfkVYXh69Jx6fHthOaCr0K
         AH9hslMunEEiK+aTfWV7cWpBSI+6UgFANjivEcdF8dudshegCaoU+2mZqvnmVQdWbZhg
         GNsZIVRpaOQlpMkladX3NW1x8vg2z0bNrq97sxgM4FPanjMP2VUixXkwvXKv1zgEAEFF
         VN1WOnmEJF2IHVAKVr/n+pdsqOpGPOb5ISunJeA24WmJaJvJZSBWf9mVAoIZQxAyHNrX
         CYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712742815; x=1713347615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5V6Ab5KYZlb0KtyTlJwyIxL2QcpWe2gp9lR05o6q98=;
        b=ORMpw0PuTo+kYHKPfek8s6mgo7Dx5VYDTrJVE6DQRdvPXAOoHjNyDQStT4mBjOuJQ9
         DXqjcchc/ncGI4lM2gPiB6JeKGPFkSQ65l+ZhKSdmxhZZOLOu6SpoMKWwjOWMULfXnZX
         H/uagcEw5fFWkw36IJYhYkiilqINw4bUzR7kRgzqyyKPw6TxBDHgEl0iutLsMtf/Iui9
         P+1OGja5xCS9507gew2JwdALqRWDvA8uwwXYgewC4DZAAqeH3lKUBt+K/xqC1xRJm/dC
         GpMX10smtYRQ0ONk078PxyG3K8Inp6Scb6HbBNSbtBoRzp1SYxru8kPCE0E8hDXUXsVC
         EYZg==
X-Forwarded-Encrypted: i=1; AJvYcCUfmIWHYRW4fzEaox0KDiyeOkU/U5xnYc+oTCzVL2OI3GiedtxzSM1B4660A/Xd/zUETwE0OCcL0A4/oJOe0kWeBNGrJ3xM
X-Gm-Message-State: AOJu0Yz9Mf5YzIYXKye54HsTowjNZF2B8bQWhXOM6CYH+Vt4UAxlV6ZD
	N58N2+VeA5oqzLy3u5jOy79TZMDMRMH85A1wTtagMJIghxF+lEA6gXVO6SSuog==
X-Google-Smtp-Source: AGHT+IFI7ac6E7BZYOo32rnOqFa6a7C6UIEWBLNvFOj/PVUT5To2IkCy5/i4IwMhkFIMY9cwo/mWyA==
X-Received: by 2002:a2e:a9a6:0:b0:2d8:be29:4ca9 with SMTP id x38-20020a2ea9a6000000b002d8be294ca9mr2001820ljq.39.1712742815139;
        Wed, 10 Apr 2024 02:53:35 -0700 (PDT)
Received: from google.com (161.126.77.34.bc.googleusercontent.com. [34.77.126.161])
        by smtp.gmail.com with ESMTPSA id he8-20020a05600c540800b00416a08788a5sm1757388wmb.27.2024.04.10.02.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 02:53:34 -0700 (PDT)
Date: Wed, 10 Apr 2024 10:53:31 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
Message-ID: <ZhZhm4UXyClAqXDM@google.com>
References: <20240409151908.541589-1-sebastianene@google.com>
 <ZhVpmF2js1NJp1qF@google.com>
 <ZhZYsuqggl_Hzv8X@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhZYsuqggl_Hzv8X@google.com>

[...]

> > > +static void do_ffa_part_get(struct arm_smccc_res *res,
> > > +			    struct kvm_cpu_context *ctxt)
> > > +{
> > > +	DECLARE_REG(u32, uuid0, ctxt, 1);
> > > +	DECLARE_REG(u32, uuid1, ctxt, 2);
> > > +	DECLARE_REG(u32, uuid2, ctxt, 3);
> > > +	DECLARE_REG(u32, uuid3, ctxt, 4);
> > > +	DECLARE_REG(u32, flags, ctxt, 5);
> > > +	u32 off, count, sz, buf_sz;
> > > +
> > > +	hyp_spin_lock(&host_buffers.lock);
> > > +	if (!host_buffers.rx) {
> > > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	arm_smccc_1_1_smc(FFA_PARTITION_INFO_GET, uuid0, uuid1,
> > > +			  uuid2, uuid3, flags, 0, 0,
> > > +			  res);
> > > +
> > > +	if (res->a0 != FFA_SUCCESS)
> > > +		goto out_unlock;
> > > +
> > > +	count = res->a2;
> > > +	if (!count)
> > > +		goto out_unlock;
> > 
> > Looking at the table 13.34, it seems what's in "count" depends on the flag.
> > Shouldn't we check its value, and only memcpy into the host buffers if the flag
> > is 0?
> > 
> 
> When the flag is `1` the count referes to the number of partitions
> deployed. In both cases we have to copy something unless count == 0.

I see "Return the count of partitions deployed in the system corresponding to
the specified UUID in w2"

Which I believe means nothing has been copied in the buffer?

> 
> > > +
> > > +	if (ffa_version > FFA_VERSION_1_0) {
> > > +		buf_sz = sz = res->a3;
> > > +		if (sz > sizeof(struct ffa_partition_info))
> > > +			buf_sz = sizeof(struct ffa_partition_info);
> > 
> > What are you trying to protect against here? We have to trust EL3 anyway, (as
> > other functions do).
> > 
> > The WARN() could be kept though to make sure we won't overflow our buffer. But
> > it could be transformed into an error? FFA_RET_ABORTED?
> > 
> >
> 
> I think we can keep it as a WARN_ON because it is not expected to have
> a return code of FFA_SUCCESS but the buffer to be overflown. The TEE is
> expected to return NO_MEMORY in w2 if the results cannot fit in the RX
> buffer.

WARN() is crashing the hypervisor. It'd be a shame here as we can easily recover
by just sending an error back to the caller.

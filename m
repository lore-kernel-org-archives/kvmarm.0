Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9552FB99E
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 15:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971414; cv=none; b=ra+RjA22URcNImFpUdUQLrNkZ5gA3T3dppVe++5qA9Pc6fuyvA9jGpeFjbnJqxZXtH/pv0nU6p+xK2Ym9+9ITb/r2iXFLT1JkzNaFz2xHEdO5BDm2eNysxY5yaG6nzrGfTGdfs2sCIyUsT5x9tuZjGXYdVO9cebk0Y4EmwRSAhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971414; c=relaxed/simple;
	bh=uXlXUXQvxCTZWbhpcdPGRdDTYu61p7ZChPJPksVumKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVejP3s1nmaB5Strp4ErhFgHuMYbi47kJTWvS5mW8CG9qcvYLnGitmeer85gAwz88KcfW3argB19jfO2XzFjFY7oXCxsBQDf7fKLhbmdPUPrzHjI357r6BSQ/nY/9LPBlSk9MfUI6XTs2UGk4v2cV/msebjmkCAThN0OyB7l2XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mlncOP8B; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mlncOP8B"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59b6a987346so3264232e87.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 07:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767971411; x=1768576211; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yv4+HiN+yqOKOu3jmdjrQOPhk/51CyYpn99UE5n2Bh8=;
        b=mlncOP8BGncR35hMYvGQ8DeCLN9S/UIm3yis7LJq3pWcU6rSHRP7Bb8MuthK7hFzxz
         OgdqHQ7c20cL1pZ7Rs1FdJBRfvo/9h2PK0spG5oWmEsNHg0ji41xHCPa7cLDy7wmOunn
         OjasYDXZMTEZLy0YZi3w5jhHKgrx78jr6S7ok2eLc1vXFzavwXZo0DHj5hy2Odl4NeX+
         YFk0ifu2qkQS6F15o2Zm3HUo19PLdmRnHHDoZXe0lM9y/LswVKcQgqBHi/mkcykIaZOI
         IKxmFWTy+hkV+oRqSAf7DEpsNrUxcSKGFxzABWkSC83NcqI/TO0RWx38UC8OqlAtAHF7
         zpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767971411; x=1768576211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yv4+HiN+yqOKOu3jmdjrQOPhk/51CyYpn99UE5n2Bh8=;
        b=CDHvFn9ZzpCGRVJz+FGLvfhf3OA+9Crd4iJN4rESxFw9QyBwNbmAc3aa5sooYpfeTK
         hEbruDKxku4j3Y4lQK1RYmoArgANE5xOT4Jbx0rrIQ1EqwVMLDLkFmLTPYRt9hpTSWsp
         jis8JGSvXzhfgl035zYKxGsvZ75StHpdje1gp3IR8KdSnAFcF/g+hmWgW4anJ8ZA9has
         dUdKEv4KBVfro+Db5Ee4n2bO0HwBcPujw4HaMohiTgXAYxvKt8y/WU/fLPpFpXa13CPq
         uKdvmccHoWpfsFRUwJTmmJutZSEL8g/6uheokRUs/3Ug4valPLKJ+qvAFpV0SXyDAb9w
         OS6w==
X-Gm-Message-State: AOJu0Yz1mbtS7LnhVga1DHY7tMWH/sWysE8roWS57E0JHPSyrHvbm7Ty
	QsLxaIHhQ9zmba7J+K6hPMop+4f12TtDJgByTUvo9Y/HnjzebghaSayluTiXKU8T+A/u5jEazwi
	AUKw5+w==
X-Gm-Gg: AY/fxX7kJI3T5ZyVvGLBjNbvW0UndDH2bm26ZkWfhPDC63QWH5wJNdO68hRzkrE05Zp
	vpO7Khj63CfsU8hn8i6wQcsjHymRdPQ6781q+zSxzEvSdUABjPqlVTHn8yV8lLK8TzNw1cEPfzh
	kb0i9YvdoIjSUAEknzRfqrle89fRtnzM5+X3Lxldl0ISQysBO+bm25DTN3DtuEDagpOhpvC5QEZ
	3Sqe0YXqeJ6p7EiUIBsXC9Y7zscXqb+znkIzQI78PmUcTtcAV+/yuPZ40/lQPGZyKVOOKgDI6bM
	BAq/hsV+VCpTU3XHqT6GpVLuYTLBAc4zE+RRejOGQIMhU9DgSP70GqkPpbfvKI+KvupUvyIytNy
	eRpgc1Ka1UYRYEg/O8aluQ0jmla21ump/B9nPoH3Q0b0OVaTZbRvSnW4aVjwxSmn4lOQXTq0bvP
	8aSSGUrsBNCIfsZveF3y01coUhlmwIbFAYjrES50lj+qY0cCBv2oyxyGwVYYI=
X-Google-Smtp-Source: AGHT+IF8ZU8/OXrPqqCYUZcC7FlQRUXnd7JW5KZdJvEvqxw8os3Wm5I5Rrtd6HZ/MikKPOBlVL/jBA==
X-Received: by 2002:a05:6512:2308:b0:598:ee5e:d8bf with SMTP id 2adb3069b0e04-59b6f0212c4mr3116876e87.15.1767971411207;
        Fri, 09 Jan 2026 07:10:11 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d0d108sm2870289e87.27.2026.01.09.07.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 07:10:09 -0800 (PST)
Date: Fri, 9 Jan 2026 15:10:06 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 10/30] KVM: arm64: Introduce __pkvm_host_donate_guest()
Message-ID: <bb6e722uvhqhhaijen6y7arny2qc4jozq34fu5fq27rchlrqye@cg236pt5ztzf>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-11-will@kernel.org>
 <ocpyeygxhp52jt2mcqq4tmdodubrfdwo4xqvbphmr34x4etrkk@f3ag3a7j5fru>
 <aWERFx9PwX1yED9H@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWERFx9PwX1yED9H@willie-the-truck>

On Friday 09 Jan 2026 at 14:30:47 (+0000), Will Deacon wrote:
> On Tue, Jan 06, 2026 at 02:48:00PM +0000, Quentin Perret wrote:
> > On Monday 05 Jan 2026 at 15:49:18 (+0000), Will Deacon wrote:
> > > +static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
> > > +{
> > > +	DECLARE_REG(u64, pfn, host_ctxt, 1);
> > > +	DECLARE_REG(u64, gfn, host_ctxt, 2);
> > > +	struct pkvm_hyp_vcpu *hyp_vcpu;
> > > +	int ret = -EINVAL;
> > > +
> > > +	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> > > +	if (!hyp_vcpu)
> > 
> > I guess we should check this is a protected VM here, else a malicious
> > host could donate pages to an np-guest. I didn't try to think through
> > the implications, perhaps it's fine, but it feels unecessary so I'd say
> > let's be restrictive here.
> 
> It's definitely harmless to add the check, but it's also hard to justify
> in my opinion. Can you think of anything that can actually go wrong it
> a malicious host donates memory to a non-protected guest? Generally,
> I think the fewer places where we have to distinguish between a
> protected and a non-protected guest in the hypervisor, the better.

I agree with the principle. Now, we already _must_ check that
host-to-guest shares are not allowed for pVMs, so this would simply make
things symmetrical I think, and this is really a simple check.

Right now a page donated to an np-guest is probably just leaked and
doesn't harm security with the current code, but I'd personally rather
not have to reason about this known-to-be-broken state as we add more
transitions in the future -- I write more than enough bugs just thinking
about the known-good ones :-).

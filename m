Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7CF2F8EB6;
	Mon, 15 Jun 2026 04:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781497238; cv=none; b=J7FM5sKZeAWldvDcHH6wgVAO95vtN+u5X1i2fS1iuIB8Ok+1cKLbc9lUr8nvNf/VTqKibxwxZDPP48Iqfv/Hg5A6kmlDQOPRCGxuGQb72foyjy2wkijthDoaEJpORIVhnc/VdHSl1UgLzuq6jwPyF+zS+A9yJ+ORQqjhV09D7es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781497238; c=relaxed/simple;
	bh=UksVRTlAqSD4+7IbNboXF1B0hoUG2Q1f2xUxVeKHEMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k56rBFNxFbzAqxgsBZfMApuSS+7nb2hh47D4PzR/99fNTxRuWWqOiQg/AOi8opMT/GcAuSLYy3k5bSTxKlxudvjG1krXXowUWnOLiPM3fg76Am6iaCnI1mhl+7OqqknRUCTKpCu0MItcwQZ2SBuxA/uCRl/sPXMcx3uOX+GWHVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlTGV7Qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlTGV7Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294641F00A3A;
	Mon, 15 Jun 2026 04:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781497237;
	bh=a+Z2Dt9ryYhrGsmSIRjwkLP0ik7jqavGeB4vvngR7aY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TlTGV7QoVcaCV6CoUy4BURvVwsWAR3qf9cz6j2kdp8moLzM+7u2nXPjSw1J6YqCAS
	 l5FJiQO2sv4hI8FTTcI80+GexzjMGB4uSmxXSKSYBVPHOh8i4uXbKiYGDeMSNQN+5M
	 5KHtY9nd5lNRn8UWgCFWkuf7emx0Nrts8ADXMkBPRNtdxGZAf9Le+n2jCJ8u+H78u1
	 OAE9Zz7JJi2DCJeMJX9ugWiDtcOlPwpM5HcNeAZRgfpU8ZdGx+VDnqBODAeCs7gt8a
	 NIRsuM797PKumMfY6CQNbgedJaL6v+/usfMltxYe/943MsgdjE5/Ni3UQBw3WBZTUl
	 i+Pin5AGgDo7g==
Date: Sun, 14 Jun 2026 21:20:35 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: fuqiang wang <fuqiang.wng@gmail.com>, Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	dongxu zhang <xu910121@sina.com>,
	wangfuqiang49 <wangfuqiang49@jd.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Skip unreset vCPUs in MPIDR lookup
 table
Message-ID: <ai99kwiaJq-VIAUk@kernel.org>
References: <20260611144042.97981-1-fuqiang.wng@gmail.com>
 <20260611144042.97981-3-fuqiang.wng@gmail.com>
 <87o6hd8oc7.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o6hd8oc7.wl-maz@kernel.org>

On Sun, Jun 14, 2026 at 10:26:32AM +0100, Marc Zyngier wrote:
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3732ee9eb0d4..fccfa97370df 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -887,8 +887,18 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
> >  	data->mpidr_mask = mask;
> >  
> >  	kvm_for_each_vcpu(c, vcpu, kvm) {
> > -		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
> > -		u16 index = kvm_mpidr_index(data, aff);
> > +		u64 aff;
> > +		u16 index;
> > +
> > +		/*
> > +		 * Skip vCPUs that haven't been reset yet; their MPIDR_EL1 is
> > +		 * zero.
> > +		 */
> > +		if (!kvm_vcpu_mpidr_is_reset(vcpu))
> > +			continue;
> 
> But what about the initial loop that computes the significant bits
> amongst the vcpus?
> 
> > +
> > +		aff = kvm_vcpu_get_mpidr_aff(vcpu);
> > +		index = kvm_mpidr_index(data, aff);
> 
> In all honesty, I think this is a userspace bug more than anything
> else, and checking for random bits in MPDR_EL1 to verify whether the
> value is plausible is gross.

+1. Checking the MPIDR value is also broken because userspace can write
whatever it wants to the register, which could even clear the RES1 bit
that's getting tested here.

> Yhis isn't different from setting MPIDR_EL1 to the same value on all
> vcpus, which we don't try to mitigate. Late setting of MPIDR_EL1 also
> defeats the whole point of having a cache for the affinity to index
> conversion, making SGIs pretty slow for late CPUs.
> 
> I really think that by not finalising your vcpus and start running the
> guest, you have cornered yourself pretty badly, and we shouldn't try
> to paper over it.

I generally agree, although I wouldn't be against a change that nuked
any of the cached routings in case of userspace doing stupid things like
collisions and whatnot.

Thanks,
Oliver

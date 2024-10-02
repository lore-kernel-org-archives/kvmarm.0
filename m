Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89692621
	for <kvmarm@lists.linux.dev>; Wed,  2 Oct 2024 00:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727827581; cv=none; b=LX1oiNRGLBAUX0zTI/3m1jWJtEKnSRUapmYXQh6g4prCvw46IjEXy41A9q9TlOv4PymDCmjW3x7qqhC8rdEfR+wtamijfdo3HU5ZMlsWV7kvBXMvNpRw9emT/zW2IcVD/VqAnNIg8iEOb4RBu2uMi/Kjf1RPY7D+2MJmA8hY81U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727827581; c=relaxed/simple;
	bh=ij4SmkciXnRJ1HUvYaUAu9aXaO3b/vYOMpmTgX1dVCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3h6Qh1lQNeFIuX55e2rWuKkoDITjLMDYHylop7iEsYWaQxGxfr6S5zw+hPmTCcLSMdWdO+PKw60+j3tKiPsyUGCz0DLLnj6I5BgRON+sq+JyQyD9nqZZHN+68vdBaHeQaR7SbLsBM6Q2+hwvfe6jnaBfeFmkh4GaHJN5qGFDMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X3ruRY+H; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X3ruRY+H"
Date: Tue, 1 Oct 2024 17:06:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727827576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wUSBZVSGa6OO7S1u87tdZWAoBJdrmPFbu4KW3ameA8A=;
	b=X3ruRY+HWS295UlfrWNYMVbZ8R8h9k9H6ppsAXfxnUQjgCMrWn6sFEnxh7I3P1xf2jvxkM
	G2uolrJTIy3E+ZVCD5kl2Y43I1W/M/JgczP0CJ7L1OTmmw+IThze1lmorygUoZVzBuYl7q
	7w7ZZgsIyyXK2N974KeDbyRvsD1tGY0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU
 request
Message-ID: <ZvyOcnZqNzfD7MZx@linux.dev>
References: <20241001001709.1303668-1-oliver.upton@linux.dev>
 <20241001001709.1303668-4-oliver.upton@linux.dev>
 <ZvxH3el9SNuNWwi8@google.com>
 <ZvxeeVn8LphHxWeS@linux.dev>
 <ZvyFkqsRFBAYwqP7@google.com>
 <86cykj75a0.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cykj75a0.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 02, 2024 at 12:49:27AM +0100, Marc Zyngier wrote:
> On Wed, 02 Oct 2024 00:28:18 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Tue, Oct 01, 2024, Oliver Upton wrote:
> > > Hey,
> > > 
> > > sidebar: I was a bit confused by the diff for a second, since it looks
> > > like your email client lowercased some stuff :)
> > 
> > Wasn't my mail client, it was PEBKAC.  I copy+pasted a large chunk in Vim because
> > I wanted to pull in the changelog (which I had deleted from my response), but then
> > I changed my mind, and in doing so I managed to fat-finger something that converted
> > everything to lowercase.  And yeah, it confused me too.
> > 
> > > > >  out:
> > > > > +	if (s2_mmu->pending_unmap)
> > > > > +		kvm_make_request(kvm_req_nested_s2_unmap, vcpu);
> > > > 
> > > > If I followed everything correctly, I don't think a request is needed.  the
> > > > request will never be cross-vCPU, and each vCPU holds a reference to the MMU, so
> > > > the MMU can't be recycled, i.e. pending_unmap is guaranteed to be relevant to the
> > > > vCPU's usage of the MMU.  More thoughts below in check_nested_vcpu_requests().
> > > 
> > > I'm (ab)using the request to prevent the vCPU thread from actually
> > > entering the VM without first having done the laundry. We have other
> > > examples of strictly per-vCPU tasks that are tracked with a request so
> > > this doesn't stick out that much.
> > > 
> > > Otherwise we'd need an open-coded check in kvm_vcpu_exit_request() to
> > > catch a 'dirty' MMU or take a pin on it from the point we check the
> > > dirtiness to the point we disable preemption.
> > 
> > Ewww, because kvm_arch_vcpu_put() puts the nested stage-2 when the vCPU is
> > scheduled out.  Mostly out of curiosity, why?  99.9% of the time, the vCPU will
> > be scheduled back in.
> 
> Because s2 MMU structures are a scarce resource. and other vcpus could
> have the opportunity to make use of an unused slot.
> 
> > Now that vcpu->scheduled_out is a thing, retaining the nested s2 MMU should be
> > quite straightforward.  kvm_arch_vcpu_destroy() would need to put the MMU, but
> > that should also be straightforward.
> 
> This code long predates scheduled_out, and I don't think this brings
> much to the table. If the vcpu comes back quickly, it will find its
> toys where it left them. If not, someone else will have borrowed them,
> and it will have to pick new ones. It isn't any different from TLBs,
> which s2 MMUs model.

In line with what Sean is recommending, it might make sense to explore
holding the reference while a vCPU is loaded and runnable, i.e. the vCPU
isn't scheduling out due to an emulated WFI. While not perfect, it would
increase the likelihood that we evict a 'cold' MMU.

But again, we should make sure we're actually happy with this allocation
scheme first before bothering with optimizing it a lot.

-- 
Thanks,
Oliver

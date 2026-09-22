Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FE025A321;
	Tue, 22 Sep 2026 18:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790103284; cv=none; b=ZqZ7q0rMWvNv0OxhHvUu6D5PsC4xoiB2LAi/2ge6Yl+oe2PBiRDwtX3tsSGNXDs8XFIY+dF4/7QOuz+aaBC4zYKKQmS/sqf+Lht9T8XhTdHdP0kqPFFs1/sruoQgUJuEWNri61x+2ioxSjUSuSQVLnZU5s+pX1Bhl6yFktrs9Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790103284; c=relaxed/simple;
	bh=zBFx0iHHzZvP5Cna47RqAxQwN2SWJ8HnFtvoenOrRyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNpkDg92QcIKed/bYIyQMTuHp2euLYsu38F0bricT/RcMD66tF8Z3pUTmLSS5ZXNpXxH2DONNNnasvWm1rRbNj3X+I+NsmSsBSGvkfB9hSB/0uHnxa/Hmym9bdP6CnNHoAP6wvM6o47HFB6wRV8diZf41BCs1sUTPZuXcFLujcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXm+/bDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXm+/bDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D671F0089A;
	Tue, 22 Sep 2026 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790103274;
	bh=fMv2HRQWdI7L1EwnVqaI+B6hRyZmxW7nfB0fpJ4Rdio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jXm+/bDndA1K7nV2TVA2OZew3t2LMKoY2U41Xm37ETzJXswGN7qSuV2hjBBflMwyK
	 axDrW6s7WkRuuSTt1eseU+bUHh+18gEbk9yHlwDhLxTsZ9Buj2TaWQs1a4t7kJcChc
	 inCyrVZOg63PPJEFjnEDiOe/fsVPfJqgXYR+7Lbx7mpp9vvfhUF1KmoRv7P0SKnIWu
	 I3Grt4Lc/l48/koMYkNzv7/dm4OxPWMqkL+mLE5sk29TUcavHAmcA6TWWdzarBHyR4
	 WtV96sN96nZg/PT9N2jxlxzs7R/XWwRZaHt2YGz5YIh5v/HTdhiWTCTqy8l29MOjYI
	 HwtBQcXixVirA==
Date: Tue, 22 Sep 2026 19:54:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 01/14] KVM: Allow architectures to disallow pre-fault
Message-ID: <arLOn49vQ4EA1brY@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org>
 <arKxjsxuO1F5ExrY@kernel.org>
 <arK5n9HrbZMCOHOt@google.com>
 <arK5ynpRi7VbY7Ek@gremlin>
 <arK8seJVT9wYgVCP@google.com>
 <arLD-eZ6dRvfZ52q@kernel.org>
 <arLJ4AbNN9Y_IUna@gremlin>
 <arLM-vJDoO7gQJXM@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arLM-vJDoO7gQJXM@google.com>

On Tue, Sep 22, 2026 at 11:46:18AM -0700, Sean Christopherson wrote:
> On Tue, Sep 22, 2026, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Sep 22, 2026 at 11:07:53AM -0700, Oliver Upton wrote:
> > > On Tue, Sep 22, 2026 at 10:36:49AM -0700, Sean Christopherson wrote:
> > > > On Tue, Sep 22, 2026, Lorenzo Stoakes (ARM) wrote:
> > > > > On Tue, Sep 22, 2026 at 10:23:43AM -0700, Sean Christopherson wrote:
> > > > > > Rather than have kvm_arch_vcpu_allow_pre_fault_memory(), what if we add a more
> > > > > > generic kvm_is_vcpu_loadable()?  That way we don't need to worry as much about
> > > > > > the return value, the connection to vcpu_load() is obvious, and we don't need to
> > > > > > add another pre-check if future (or cleaned-up existing?) ioctls want to do
> > > > > > vcpu_load() in common code.
> > > > >
> > > > > ...this is exactly what I started out with.
> > > > >
> > > > > But then you are in a pickle, because _really_ you need to do that check in
> > > > > vcpu_load(). Which is a void function. Which is called by every single
> > > > > architecture all over the place.
> > > > >
> > > > > So you'd have actually no way of signalling the error back.
> > > > >
> > > > > Of course those places are arch code and you could say 'arches should know
> > > > > better and if they call it it's fine not to call the arch 'can you load'
> > > > > function.
> > > >
> > > > Yes, that's my vote.  It'd be easy enough to clarify that "rule" with a comment
> > > > in linux/kvm_host.h.
> > >
> > > I feel like trying to make this generic will wind up under-documenting
> > > the single example we have with the pre fault ioctl. Putting the comment
> > > into a header practically guarantees that nobody will read it either.
> > >
> > > I'd favor doing something like below and sticking the comment inline in
> > > the ioctl handler. Unless I'm missing something blatantly obvious, I
> > > don't see why the x86 or s390 pre-conditions can't be tested early too.
>
> Oh, they definitely can.  I'm a-ok with using kvm_arch_pre_fault_allowed() on
> s390 and x86, the only option I am against is adding kvm_arch_pre_fault_allowed()
> but then not using it on architectures that obviously perform that exact check.
>
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3961,6 +3961,11 @@ bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
> > >  	return false;
> > >  }
> > >
> > > +int __weak kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
> > > +{
> > > +	return 0;
> > > +}
>
> There should be no need for a __weak placeholder since this code is guarded by
> CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY=y.  I.e. force architectures to define the
> API.  I don't think it's a coincidence that all of arm64, s390, and x86 ended up
> with restrictions; pre-faulting is far from a simple operation.
>
> Actually, that's an argument for a dedicated kvm_arch_pre_fault_allowed() versus
> a generic kvm_is_vcpu_loadable(): it helps force future architectures to actually
> think about when exactly pre-faulting is safe.

Ack on all and I agree __weak is not necessary in this case and probably quite
useful to make arches define it.

Will take this approach on respin thanks all!

--
Cheers, Lorenzo

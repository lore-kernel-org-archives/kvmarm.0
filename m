Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F65A3E51C6;
	Tue, 22 Sep 2026 18:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100118; cv=none; b=Te6rU1I8b6Vd5OnUdjqLoQFQ++o9hKP5h/cOnbHlTrDY+ydGCxTgodH2HweFeFBuYuHxEk90FS8Q0AeFOiMib9jpRSwEF+YjBV4X/SOuphmvgS+8eQeX5qicq4hITJlVaUQuXGNvp5nLZjNq3cLYYAi1yWlvz7jePjyIUDAwQ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100118; c=relaxed/simple;
	bh=6gafUH01UEnEOFZ/RPOfxlqwmZj2EPGoGIHEuVJ2b30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ieZK1rKS1GEFW+9R9kwc1tU7YRu/oUxdx/Blc2xOGwyvT0iQpX3UVOlPUPpsaRJs90jsz7nQPSTifIASayCvuzf6uvhzE+HPa8jF8D7nTKPwxZipVKsq+N7ZWUYS9DFEqSswHtq79/3lr19X5pCI+0Glcx4lkNTRx9L+tG3hHrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTFAgg2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTFAgg2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74781F000FF;
	Tue, 22 Sep 2026 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790100116;
	bh=XYSOqVERmoLufYUc+VgdIGa26F88+bWdDgX4ohmoDow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cTFAgg2FOfaMX2m8EsEsOewd3kmF8o+nqmZIgHsg1+9dfNvjg7UsJBnBr7cQLe1gc
	 NRZa7rq/dJvOZbE4iJ8qwH9xFN5HvTNU602lYu19aCdlJ8/ZK8eFBFvjLwON208EmW
	 XDFJRh666HOdgBM4mCysh18oZxVAtffvfijp+CEreSklJcAeStfU5ZVdmz/W+G1cMw
	 tvX2+GxoohyHrtHGMZv+Cxrry+VZhichA61P71tzJM/TfaD+SUPE5zsm6ygKShkw1+
	 aQtV+4k7suG2DbR/RXLPSqzlhNoXCFydrrlCIBti5D3+SZI3a/BwrfTF6KEv229og0
	 k/Vt3CWjh0zuQ==
Date: Tue, 22 Sep 2026 19:01:48 +0100
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
Message-ID: <arK8-Hec3-5o4jYs@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org>
 <arKxjsxuO1F5ExrY@kernel.org>
 <arK5n9HrbZMCOHOt@google.com>
 <arK5ynpRi7VbY7Ek@gremlin>
 <arK8seJVT9wYgVCP@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arK8seJVT9wYgVCP@google.com>

On Tue, Sep 22, 2026 at 10:36:49AM -0700, Sean Christopherson wrote:
> On Tue, Sep 22, 2026, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Sep 22, 2026 at 10:23:43AM -0700, Sean Christopherson wrote:
> > > Rather than have kvm_arch_vcpu_allow_pre_fault_memory(), what if we add a more
> > > generic kvm_is_vcpu_loadable()?  That way we don't need to worry as much about
> > > the return value, the connection to vcpu_load() is obvious, and we don't need to
> > > add another pre-check if future (or cleaned-up existing?) ioctls want to do
> > > vcpu_load() in common code.
> >
> > ...this is exactly what I started out with.
> >
> > But then you are in a pickle, because _really_ you need to do that check in
> > vcpu_load(). Which is a void function. Which is called by every single
> > architecture all over the place.
> >
> > So you'd have actually no way of signalling the error back.
> >
> > Of course those places are arch code and you could say 'arches should know
> > better and if they call it it's fine not to call the arch 'can you load'
> > function.
>
> Yes, that's my vote.  It'd be easy enough to clarify that "rule" with a comment
> in linux/kvm_host.h.

I note you dodge the actually difficult question of what this wrapper function
would look like ;)

So maybe like:

static int kvm_vcpu_load(struct kvm_vcpu *vcpu)
{
	int err;

	err = kvm_arch_allow_vcpu_load(vcpu);
	if (err)
		return err;

	vcpu_load(vcpu);
	return 0;
}

?

And I do like that you'd actually gate the right thing, I feel you on that,
obviously since this kind of predicate is what I started out with.

But I'm also looking to do the smallest possible thing here that fits the series
and doesn't preface it with a 'change how core kvm does something'.

But if Oliver/Marc feel this is viable then sure can go with it.

(Also naming is hard, kvm_vcpu_load()? do_vcpu_load()? maybe_vcpu_load()?
checked_vcpu_load()? vcpu_load_checked()? :P)

>
> > But you're still stuck with the problem of where exactly you put this check.
> >
> > So then do you put that check in a wrapper around it?
> >
> > Instead you can make the predicate 'don't prefault on a not-yet-initialised
> > vCPU' which is pretty sensible I think, have a specific place to put it and
> > all's well with the world.
>
> But look at it from an x86 perspective.  Pretty much everyone will look at this
> and expect:
>
>   bool kvm_arch_vcpu_allow_pre_fault_memory(struct kvm_vcpu *vcpu)
>   {
> 	return vcpu->kvm->arch.pre_fault_allowed;
>   }

I'm not sure I really get your point here at all? :)

Why would it matter what people who are too lazy to go check the implementation
assume about an arch hook?

>
> > > I'd also be tempted to say it can be a macro, not a __weak function.  E.g.
> >
> > Yeah it can be many things but why would you want a macro if you could possibly
> > avoid it? :)
>
> Because it allows arch code to dererefence "struct kvm_vcpu" in kvm_host.h,
> i.e. allows "inlining" the check.

Yeah I mean, micro-optimising a path run on a costly startup operation seems a
little unnecessary? :)

It seems the convention is __weak but I'm not going to die on this hill.

(C type safety is something of a myth but I do prefer to try to have what
little protection it offers when possible :)

--
Cheers, Lorenzo

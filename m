Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DED735B137
	for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761152249; cv=none; b=WKmqp3ziYeA5Vdy/R3lDBwHWpN5XLas/gjl29WvPFXuygBQRfqSPblsbyz6+LHFaRvC9z6F09aDuQI13rLd5cfipP7GP6BHt4kS+XZAJ0WMU5v+wGoj7R6UNRgCkehjyVek60wEtTSQWOpjgNf75Bxf8OSLmAzuEHOc6CjKVb8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761152249; c=relaxed/simple;
	bh=+lOAX0WH45ZYFvjGkq6Mdrk+bT97xMbOy4Azki/BfzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tE4vNWIb6djDFGU6NRQXRyAgtdKJ4f3U5s4S/nRjH2Z5CfATNQmUVLvutWP53ZAPsxCEf6Au2cEGvC9IsUDFT9BmHWSCp/iXLC3ucbal0N8te5s+7W0MTrHCFRTYBSldI1ZyerMBKfeuXqDYKGaMeYJs4YdoO72qsiBf07kvyMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nP69cQy2; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nP69cQy2"
Date: Wed, 22 Oct 2025 16:57:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761152245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IkEz7N5i+wARmWWm/YQGjO04JZJy0XHZdRwYsn6WAUs=;
	b=nP69cQy2ibAnsk59KeFvUNTFltYAYgIfkdBAwrWLoANE/Z5vQkad5QyfWB2XWcx9cIAJfp
	4cNFnwG+SSM6kPgWMQaYIkS7+aEMVgtP5ok4H3iAsLq3a8IaJLdJ26owmS+UA+6hVoAnV7
	6w9AKH3saWBQOY5p65J7qs/qsgaYhUM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, 
	Itaru Kitayama <itaru.kitayama@linux.dev>, kvmarm@lists.linux.dev, Jim Mattson <jmattson@google.com>
Subject: Re: RFC KVM: arm64: selftest: stage 2 mapping helpers
Message-ID: <62kml5omikxsb3ppd4yewcvbuje4xojffi6nkcnpxddsy77hpb@plprg57waxnb>
References: <10A5745B-411F-4EB3-A168-0BC6CA99FF4D@linux.dev>
 <aPbL8NCPCfLHIB3w@linux.dev>
 <aPjdgqHlxFOyjSKT@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPjdgqHlxFOyjSKT@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 22, 2025 at 06:34:58AM -0700, Sean Christopherson wrote:
> +Yosry and Jim
> 
> On Mon, Oct 20, 2025, Oliver Upton wrote:
> > > +void virt_arch_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr);
> > > +
> > > +static inline void virt_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
> > > +{
> > > +	virt_arch_s2_map(vm, ipa, paddr);
> > > +}
> > 
> > This is all going to be arm64-specific, no need for indirection through
> > something pretending to be arch-generic.
> 
> I was going to ask about that.  Do we want to try and provide a generic interface?
> 
> Yosry (and Jim) are working on unifying as much of the AMD vs. Intel logic as
> possible, and if my wishes come true, unifying stage-1 and stage-2 mapping code
> as well.

Your wishes already came true:
https://lore.kernel.org/kvm/20251021074736.1324328-1-yosry.ahmed@linux.dev/.

For x86, the patches reuse most of the stage-1 mapping code for stage-2,
with the only exception being using a different sets of bitmaks.

We end up with a nested_map() API (and some friends) for creating
stage-2 mappings for L1 (by L0). I imagine we can make that an
arch-agnostic interface.

A cooler thing (but probably far-fetched) thing to do is to reuse
virt_pg_map() in nested_map() in the arch-agnostic code. Example, each
arch provides bitmasks and other stuff, and then the generic code calls
virt_map() (and friends) directly.

The feasibility depends on how similar stage-2 page tables are between
archs, and how much differences would need to be conveyed to virt_map().

> I.e. if we envision any arch-agnositic tests that can do nested things,
> now's the time.  E.g. running dirty logging tests in L2 maybe?

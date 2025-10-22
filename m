Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B2D2DC350
	for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761155441; cv=none; b=D2tOSt8hMx/MGw56CxEknbWylplCwH3rmJZypgyJ9sFyHat3kVi8JNqtyt/HI/ISvm/F1e+bJLfQzl/69Vn77tmUQgoslZcyEZPvAUee1cpMftmFChVxGNwQS97IGshgg9NvDkEgzHz1vA5cZbG8nPimeZvWW4BfbwnSkD19I4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761155441; c=relaxed/simple;
	bh=6CHmjI3yZ69786GhD7BIGbIes8WfBr6aBYUrXcsCp5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LIhNLWTfnDYdNFd96y0cUHkVYC6O98m19KpWxqa1jFevgjprfPiMELlAUnqb3grS29gXhdhDRzy330IR8ctprd+3X2kM4XYD9HRUslkGJNL6F5C6xsDoxIw2ovgBzJiIma6AGaBSwHCnw7g02ynSbDXlIpCoZsV4HMwmn0WquKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mvlQTlpK; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mvlQTlpK"
Date: Wed, 22 Oct 2025 17:50:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761155436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4D4r+gnYc8QDeR2V7bg4SB1yLrqRV0hyazuL9oViJLw=;
	b=mvlQTlpK1K/gSJ/CrpM95wBz0OcPMKAe10hj5bbAnI2h22U2ueWbOOqaWRaahCB3p35D3C
	ub6/pMxiXOYh9tAEZjCimraNGjYD6/imHSSCqGtKhgFOHqYUco6q9bTGFQk5fKGqiiq6KA
	Bj1/8lU7/AQJLCMComxxG3ztkzEBv9U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, 
	Itaru Kitayama <itaru.kitayama@linux.dev>, kvmarm@lists.linux.dev, Jim Mattson <jmattson@google.com>
Subject: Re: RFC KVM: arm64: selftest: stage 2 mapping helpers
Message-ID: <zqtfz6k3mud5rjmnfy45pdvqhmf33mkqvmtsvayf7pjz2buoiw@m5z5rqqhiqh6>
References: <10A5745B-411F-4EB3-A168-0BC6CA99FF4D@linux.dev>
 <aPbL8NCPCfLHIB3w@linux.dev>
 <aPjdgqHlxFOyjSKT@google.com>
 <62kml5omikxsb3ppd4yewcvbuje4xojffi6nkcnpxddsy77hpb@plprg57waxnb>
 <aPkYox4XLwrYi9qJ@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPkYox4XLwrYi9qJ@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 22, 2025 at 10:47:15AM -0700, Oliver Upton wrote:
> On Wed, Oct 22, 2025 at 04:57:16PM +0000, Yosry Ahmed wrote:
> > On Wed, Oct 22, 2025 at 06:34:58AM -0700, Sean Christopherson wrote:
> > > +Yosry and Jim
> > > 
> > > On Mon, Oct 20, 2025, Oliver Upton wrote:
> > > > > +void virt_arch_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr);
> > > > > +
> > > > > +static inline void virt_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
> > > > > +{
> > > > > +	virt_arch_s2_map(vm, ipa, paddr);
> > > > > +}
> > > > 
> > > > This is all going to be arm64-specific, no need for indirection through
> > > > something pretending to be arch-generic.
> > > 
> > > I was going to ask about that.  Do we want to try and provide a generic interface?
> 
> The problem is it isn't just page tables. It's the whole nested CPU
> context, hypervisor trap configuration, and means of entering/exiting
> the guest (i.e. ERET & exception entry vs. VMRUN).
> 
> I'm not fundamentally opposed to trying to do nested in common tests,
> but I'd like to have a rough idea of how all the necessary parts will
> fit together.
> 
> > > Yosry (and Jim) are working on unifying as much of the AMD vs. Intel logic as
> > > possible, and if my wishes come true, unifying stage-1 and stage-2 mapping code
> > > as well.
> > 
> > Your wishes already came true:
> > https://lore.kernel.org/kvm/20251021074736.1324328-1-yosry.ahmed@linux.dev/.
> > 
> > For x86, the patches reuse most of the stage-1 mapping code for stage-2,
> > with the only exception being using a different sets of bitmaks.
> > 
> > We end up with a nested_map() API (and some friends) for creating
> > stage-2 mappings for L1 (by L0). I imagine we can make that an
> > arch-agnostic interface.
> > 
> > A cooler thing (but probably far-fetched) thing to do is to reuse
> > virt_pg_map() in nested_map() in the arch-agnostic code. Example, each
> > arch provides bitmasks and other stuff, and then the generic code calls
> > virt_map() (and friends) directly.
> > 
> > The feasibility depends on how similar stage-2 page tables are between
> > archs, and how much differences would need to be conveyed to virt_map().
> 
> One of the other things for arm64 right now is enabling the 'common'
> tests seems less interesting than doing low level testing on our nested
> MMU implementation. That probably means we're going to deviate quite a
> bit from virt_map() (e.g. using a different translation granule than
> vm->page_size)

Makes sense.

> 
> IOW, the starting point for us is fine-grained control over potentially
> multiple stage-2 MMUs with modal descriptor fields that change meaning
> based on the current MMU context.
> 
> > > I.e. if we envision any arch-agnositic tests that can do nested things,
> > > now's the time.  E.g. running dirty logging tests in L2 maybe?
> 
> We can just as easily implement an agnostic wrapper after the fact;
> enabling architectural validation of the arm64 nested implementation is
> the highest priority at the moment for us.

Oh 100%, I was not suggesting that we need to do this now, not sure if
Sean was.

> 
> Thanks,
> Oliver

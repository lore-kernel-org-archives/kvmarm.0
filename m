Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794326549;
	b=m4gtuCqOh4z5nNnwvbWVaIGJ8dyxPzvHSWZJSEf7cbyibgGdzMqbL1uk/GM+Jxq2Pqmm
	 1Q9FMbtSKxtcQGshlFN1o7FIUfbM567Nes4h3zCgPN67aLgpQZwACFNR1kOIqapUxhBO0
	 kc+GjqVKDyY1+aapMTEhZohWc/BQYwXtzPhJKlSUCD98dfg+AyEW2LMwFaQk6iF+SLvzs
	 /lspT8orDnotBR9P/V+0UnyaZ1MvgS8CEIR8jsDVLfy2Y1XfMZ/9zSHl/+06dBUlFn2u3
	 Z/bYyCPpv47CSbX1qna02aswRn9jEutsfoSJDSAN3QavNX8bKpvBCeT/gZYsihbQhHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794326549;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8npCNmyNjIE2pJbjFcsGaVN8VHiMIR3RoakRQ7io9Yc=;
	b=Pjn8Aro1zcHhvKKuATMZzO+wu6fnhlqH8AMMw93xP57FmlBu/GPfvh2Zi/+xLirvqxye
	 e2maJakMCC0cDgJUfP8w4mCCFnijsLZM+fllNz+OGvGq2rt5jMszngvBNtBenqR7RNB9r
	 VdTTJSR8ttwCV6Yic2ANJeXEjJgKMqfG6LpZNUBYsdl3eGa4Oo4JM5V0vrXP9CmDbKU7p
	 RToIDv7jsXseuo/NapntEOo/NpJTCNU8IrMoJgGJZw82giUQge3byhF+aZKMG2YWro4N+
	 izSZooNhMuFTfFOQPDK35uvLvpZn5KNgOhvpkqNBZz0TYO6daYj2jL7d6+ZfPp4I+Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CQ3xHtNM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3475D606A31C;
	Tue, 10 Nov 2026 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CQ3xHtNM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C1A1F0089F;
	Tue, 10 Nov 2026 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326548;
	bh=8npCNmyNjIE2pJbjFcsGaVN8VHiMIR3RoakRQ7io9Yc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CQ3xHtNM0fEUOWRCRgWtk59j0P8jSaTryPnb2RKY4dFnKizwLXx4yGZfLdlYmHAgx
	 TAo0sFtyqTc+3ZGkL80xa9+Cu06CgzQBDFEzIxFKi5ZsYK8tWB1ZVKnqp/Yn7wcDmA
	 1X7Y5I1ooIc2wDkaWs7EwLkCDhqj1sBUjwR09JrV7uCU0ofja+oiZ/UZvGjINFSoaW
	 LGbJ9ajsorBJEyPsfQNw1oSlQvI2v/XJJU2d5nGMgib2ub1Z4edaLtJJeKgVpSok0v
	 8sdin6B+NaKId7yQrwE3chP/YXRk4cm6kxCPRx+ksI4RkJmM88sSP3ta+BbGogi1IE
	 CUIrG8UAgHYsg==
Date: Tue, 10 Nov 2026 16:02:21 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, Wei-Lin Chang <weilin.chang@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/2] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a
 full dirty ring
Message-ID: <avM_FXXF9oBkderF@gremlin>
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-3-fuad.tabba@linux.dev>
 <avMoubwqgXbpflwM@gremlin>
 <CA+EHjTxT_9NghyLSZmOOi_oQboQw-g+6z9WxwaF=-7RdaGbMNw@mail.gmail.com>
 <avM9_7aWUDJSL3Lq@seanjc-mac.roam.internal>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avM9_7aWUDJSL3Lq@seanjc-mac.roam.internal>

On Tue, Nov 10, 2026 at 07:53:35AM -0800, Sean Christopherson wrote:
> On Tue, Nov 10, 2026, Fuad Tabba wrote:
> > Hi Lorenzo,
> >
> > On Tue, 10 Nov 2026 14:38:27 +0000, "Lorenzo Stoakes (ARM)"
> > <ljs@kernel.org> wrote:
> > > On Tue, Nov 10, 2026 at 11:07:24AM +0000, Fuad Tabba wrote:
> > > > Pre-fault more populated, dirty-logged pages than the vCPU's dirty ring
> > > > holds, and check that each call stops before the ring overflows, that a
> > > > retry returns ENOSPC without progress, and that the harvested entries
> > > > are the pages in order. A read pre-fault can map a page read-only, or
> > >
> > > Are we asserting an invariant that prefaulting happens in address order
> > > here?  Is that explicitly presumed in the prefault API, or just how it
> > > happens to pan out?
> > >
> > > I wonder if we might decide for whatever reason in future to do things
> > > differently there. Bit nitty I know, but wonder if it's asserting an
> > > implementation detail?
> >
> > Yes, the API doesn't guarantee an order. I'll assert that every page
> > is reported exactly once instead.
> >
> > [...]
> > > > diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> > [...]
> > > > +static void test_pre_fault_dirty_ring(void)
> > [...]
> > > > +    /* Populate the pages, so that pre-faulting can map them writable. */
> > >
> > > Reviewed below, but I wonder how x86 could then read fault these?
> >
> > KVM_PRE_FAULT_MEMORY is defined as a read fault, but x86 maps the page
> > writable when the host page is, and marks it dirty, unless it falls
> > back to access tracking (below). Populating the pages makes sure they
> > aren't backed by the zero page.
>
> Before we effectively solidify the behavior, I think we should have an explicit
> discussion about the desired behavior of KVM_PRE_FAULT_MEMORY when dirty logging
> is enabled.  E.g. the only reason I kept the existing behavior in my auto-prefault
> series was because I couldn't think of a good reason to change it.  But we never
> made a concious decision in the first place, i.e. we never considered what would
> happen if prefaulting collided with dirty logging (as evidenced by this bug).

Yeah, I do worry about implicit assumptions (also commented re: ordering).

I guess what makes sense, given the general approach for prefaulting = injecting
a synthetic read fault, is for the expectation to be that it matches the
behaviour of an ordinary read fault.

Or do you feel that it makes sense for the pre-faulting to do something special
in these cases and establish a sensible invariant?

If the pre-faulting does indeed dirty the pages, you'd need the dirty logging to
do its usual thing (not familiar with the code, so I'm guessing logging the page
:) though right?

--
Cheers, Lorenzo

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794326265;
	b=WyQQy68/y/P5o2UuQe4DDsT/Gajpca2ax+rSH6+8bQKuuGwijzR2dImL/B7q9iVRdXJK
	 kLd6TRwo9b2O0UaJwLVwLOQ0HXHTXCAt7G49wU8xSAh+F/lUNYfj6rOwXnH/BC6goKR07
	 CQeuNRZiBlMXTCvTtDDDN8PZeKgu01vPUxPGVNXbEVVxgpVRbsVMQa261hOw93USxBgly
	 SuUgIPpV1M3w35fi12JwyOc3FFOTKQd7S406z3gmPwYs97Gs4rFR42A3bdSr/mSgqVM0h
	 zW0FkVT5ojZ5Vx5B1/RtRx2OVjVr8m/U8GWVnJxsAxDfb6Y7ZPrI8Z0pAbrQc96Nn6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794326265;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XJwsefjVaveYZaUliYO/CZG3zDAU8kboouxJy1sNukw=;
	b=MmnC1TlKimLtfTXHeEI/xFdl8NyKF2GGaVw4Hp8n031MxfaG2GJkN/wDKLM/NhVcHELh
	 eqzyMRqyBqeViCHECpyF2iE2wVsx8oaWdlSChFM+2WvU/38D+R8Pp2VRlfxSMEWibJF5O
	 uOoC0icQSToDvzO+B4TjPrneV1U9rPaIm8QQjAwUqBzSKEtcSWtF1mhUyM069ed/VxEBx
	 DFcDnvLP8eM1HyVAR5PCgNgZlmM5lBtofu3ZfICbMBX6p/XuwzDMjlMGTp93lX505wk/7
	 NcAC7iIsE/cg/qGQ/PiNYe+hmrxFTuOFBVXoYbBvmMNwrY9B5Jjzu/ippc02+c8yFlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f3hlURjL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9F5606A330;
	Tue, 10 Nov 2026 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f3hlURjL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C081F008BE;
	Tue, 10 Nov 2026 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326264;
	bh=XJwsefjVaveYZaUliYO/CZG3zDAU8kboouxJy1sNukw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f3hlURjLe6WtMd1ogimfqcw5Fy5jhN0/5fGaM9qQ1j71lr5gyWspl8BX6XdY/mgfv
	 NAtItad9jotkAVbrbqn5HjD8gDv9DBAm5qPCxVkNzwUGW0CnQa4ivlYKO8K+AAbc+o
	 6M0c3y2PVvOKQmTha6q4iyKrb9UQrPww8ppZGxlk6ez7ZutpJpmSskCjD6jqs3Fb5g
	 cZgot1B1WaQneHRwD59XrlWaxDesOlnWmzVkNN+FcCt0XivIKw60DKzJUvFrQsl0VV
	 1iOkTwSegXSamFk9u0pUlL1+rhsXOH5PQyY6/FZ+7sZT2H1M8boAjN99RVdP9dcIM6
	 MGJHnVnXg5faA==
Date: Tue, 10 Nov 2026 15:57:37 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, Wei-Lin Chang <weilin.chang@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/2] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a
 full dirty ring
Message-ID: <avM9i8xWNZ2fU8_2@gremlin>
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-3-fuad.tabba@linux.dev>
 <avMoubwqgXbpflwM@gremlin>
 <CA+EHjTxT_9NghyLSZmOOi_oQboQw-g+6z9WxwaF=-7RdaGbMNw@mail.gmail.com>
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
In-Reply-To: <CA+EHjTxT_9NghyLSZmOOi_oQboQw-g+6z9WxwaF=-7RdaGbMNw@mail.gmail.com>

On Tue, Nov 10, 2026 at 03:37:05PM +0000, Fuad Tabba wrote:
> Hi Lorenzo,
>
> On Tue, 10 Nov 2026 14:38:27 +0000, "Lorenzo Stoakes (ARM)"
> <ljs@kernel.org> wrote:
> > On Tue, Nov 10, 2026 at 11:07:24AM +0000, Fuad Tabba wrote:
> > > Pre-fault more populated, dirty-logged pages than the vCPU's dirty ring
> > > holds, and check that each call stops before the ring overflows, that a
> > > retry returns ENOSPC without progress, and that the harvested entries
> > > are the pages in order. A read pre-fault can map a page read-only, or
> >
> > Are we asserting an invariant that prefaulting happens in address order
> > here?  Is that explicitly presumed in the prefault API, or just how it
> > happens to pan out?
> >
> > I wonder if we might decide for whatever reason in future to do things
> > differently there. Bit nitty I know, but wonder if it's asserting an
> > implementation detail?
>
> Yes, the API doesn't guarantee an order. I'll assert that every page
> is reported exactly once instead.

THanks!

>
> [...]
> > > diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> [...]
> > > +static void test_pre_fault_dirty_ring(void)
> [...]
> > > +    /* Populate the pages, so that pre-faulting can map them writable. */
> >
> > Reviewed below, but I wonder how x86 could then read fault these?
>
> KVM_PRE_FAULT_MEMORY is defined as a read fault, but x86 maps the page
> writable when the host page is, and marks it dirty, unless it falls
> back to access tracking (below). Populating the pages makes sure they
> aren't backed by the zero page.

Ack.

>
> [...]
> > > +    while (range.size) {
> >
> > NIT: n could be scoped to this block instead.
>
> Will do.

Thanks!

>
> [...]
> > > +        for (n = 0; ; n++) {
> >
> > Could this loop forever if cur->flags always == KVM_DIRTY_GFN_F_DIRTY? Or
> > is that guaranteed not to be the case?
>
> It can't. Every harvested entry is set to KVM_DIRTY_GFN_F_RESET and
> stays that way until KVM_RESET_DIRTY_RINGS, which runs after the loop,
> so one pass stops after at most a full ring.

Ack OK.

>
> > > +            cur = &gfns[fetch % entries];
> > > +            if (smp_load_acquire(&cur->flags) != KVM_DIRTY_GFN_F_DIRTY)
> >
> > Is this and the below release paired with equivalent stuff in the dirty ring code?
>
> Yes, the acquire pairs with the smp_wmb() in kvm_dirty_ring_push()
> ahead of the flag store, and the release with the smp_load_acquire()
> in kvm_dirty_gfn_harvested(). dirty_log_test does the same.

I know it's test code, but general kernel practice is to add a comment saying
what memory barriers pair with so it's easier to track, could you add those for
these?

>
> [...]
> > > +        /* A read pre-fault can map a page read-only, or access-tracked on x86. */
> >
> > Hmm under what circumstances would that happen? Is there no way to ensure pages
> > are dirtied by prefaulting? I imagine not though!
>
> No, it's up to the architecture. arm64 maps a read fault read-only
> while the slot is logged with a bitmap, and x86 with EPT but no A/D
> bits maps it access-tracked. Neither pushes anything to the ring.

Right, OK, makes sense.

>
> > > +        if (!n && !harvested && !range.size) {
> >
> > Hmm, so !n && (harvested || range_size) will pass this, but then you assert
> > n immediately below, so it seems like n is an unconditional requirement.
> >
> > So I wonder whether this should just be !n in this conditional or maybe the
> > assert afterwards should be dropped?
>
> The skip is for when pre-faulting dirties nothing at all: the first
> call maps the whole range without pushing a single entry, so there's
> nothing to test. Any other empty harvest is a bug, which the assert
> reports, so I'd rather keep both as they are.

OK I see. Really the assert below is !n && (harvested || range.size), maybe
clearer to be explicit but it's also a bit noisy so not a big deal.

--
Cheers, Lorenzo

Received: from out-141.mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B233A92D
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 19:33:34 +0000 (UTC)
Date: Tue, 31 Jan 2023 18:35:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675190155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EbDiM8y7YBdYD3MK4FOU4lm4RYkfE0zS8/MHQwgvtio=;
	b=lPJxKDnPYuz4GT2qEIKMFOVtNb5Q7xVVJ1En1UEedzV1OoPfbjLIan7FbuFaiJMIEQw0vJ
	Y+mTbTC/s7LaUVWQvgO0WKKb/VXlIgcTIFV7W0UNJFI0eAtkUtC7gs5h1+YDxA/snwPqdF
	Ma55cVx2B6IXKvx4unXgnnDyBxeVio8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Ricardo Koller <ricarkol@google.com>, Marc Zyngier <maz@kernel.org>,
	pbonzini@redhat.com, yuzenghui@huawei.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
	reijiw@google.com, rananta@google.com, bgardon@google.com,
	ricarkol@gmail.com
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is
 enabled
Message-ID: <Y9lfhclj3oC6mKSR@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi>
 <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org>
 <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com>
 <Y9hsV02TpQeoB0oN@google.com>
 <Y9lTz3ryasgkfhs/@google.com>
 <CALzav=esLqUWd-1z=X+qzSxQDLS3Lh_cx4MAznp+rC9f-mrY0A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=esLqUWd-1z=X+qzSxQDLS3Lh_cx4MAznp+rC9f-mrY0A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 31, 2023 at 10:01:45AM -0800, David Matlack wrote:
> On Tue, Jan 31, 2023 at 9:46 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Tue, Jan 31, 2023 at 01:18:15AM +0000, Sean Christopherson wrote:
> > > On Mon, Jan 30, 2023, Oliver Upton wrote:
> > > > I think that Marc's suggestion of having userspace configure this is
> > > > sound. After all, userspace _should_ know the granularity of the backing
> > > > source it chose for guest memory.
> > > >
> > > > We could also interpret a cache size of 0 to signal that userspace wants
> > > > to disable eager page split for a VM altogether. It is entirely possible that
> > > > the user will want a differing QoS between slice-of-hardware and
> > > > overcommitted VMs.
> > >
> > > Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
> > > guarantees for all VMs on a system are better met by enabling eager splitting
> > > across the board.
> > >
> > > There are other reasons to use module/kernel params beyond what Marc listed, e.g.
> > > to let the user opt out even when something is on by default.  x86's TDP MMU has
> > > benefited greatly from downstream users being able to do A/B performance testing
> > > this way.  I suspect x86's eager_page_split knob was added largely for this
> > > reason, e.g. to easily see how a specific workload is affected by eager splitting.
> > > That seems like a reasonable fit on the ARM side as well.
> >
> > There's a rather important distinction here in that we'd allow userspace
> > to select the page split cache size, which should be correctly sized for
> > the backing memory source. Considering the break-before-make rules of
> > the architecture, the only way eager split is performant on arm64 is by
> > replacing a block entry with a fully populated table hierarchy in one
> > operation.
> 
> I don't see how this can be true if we are able to tolerate splitting
> 2M pages. Splitting 2M pages inherently means 512 Break-Before-Make
> operations per 1GiB region of guest physical memory.

'Only' was definitely not the right word here.

I fear that there is a rather limited degree of portability for any
observation that we derive from a particular system. Assuming the
absolute worst of hardware, TLBIs + serialization will become even more
of a bounding issue as the number of affected entities on the
interconnect scales.

So in that vein I don't believe it is easy to glean what may or may
not be tolerable.

> It seems more like the 513 cache size is more to optimize splitting
> 1GiB pages.

I don't believe anyone is particularly jazzed about this detail, so I
would be surprised if we accepted this as the default configuration.

> I agree it can turn those 513 int 1, but future versions
> of the architecture also elide BBM requirements which is another way
> to optimize 1GiB pages.

Level 2 break-before-make behavior is helpful but certainly not a
panacea. Most worrying is that implementations may generate TLB
conflict aborts, at which point the only remediation is to invalidate
the entire affected context.

-- 
Thanks,
Oliver

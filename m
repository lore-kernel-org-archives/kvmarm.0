Received: from out-150.mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D571CA922
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 18:24:59 +0000 (UTC)
Date: Tue, 31 Jan 2023 17:45:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675187164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwrOcR2LffC/e+/t1pFYVsPzBZficz7j8jjPmO5CHe4=;
	b=ZOX+OhybnoIrCkkqxXxWIG1SyBX+oFKddZxS5djZNenbmzAbZf1rQX6zFW/doatpLDjNE/
	oTQRNWus2dGGiyDef1EV/Qd5IRfiHXZw1AoPkfnD9ik7y0rkJa1KqzCkrBkmHY7G21JqZf
	NLCgS4oICiLeOkuxbQPwVO8J0m7iA5A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Ricardo Koller <ricarkol@google.com>, Marc Zyngier <maz@kernel.org>,
	pbonzini@redhat.com, yuzenghui@huawei.com, dmatlack@google.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
	catalin.marinas@arm.com, andrew.jones@linux.dev,
	alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is
 enabled
Message-ID: <Y9lTz3ryasgkfhs/@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi>
 <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org>
 <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com>
 <Y9hsV02TpQeoB0oN@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9hsV02TpQeoB0oN@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 31, 2023 at 01:18:15AM +0000, Sean Christopherson wrote:
> On Mon, Jan 30, 2023, Oliver Upton wrote:
> > I think that Marc's suggestion of having userspace configure this is
> > sound. After all, userspace _should_ know the granularity of the backing
> > source it chose for guest memory.
> > 
> > We could also interpret a cache size of 0 to signal that userspace wants
> > to disable eager page split for a VM altogether. It is entirely possible that
> > the user will want a differing QoS between slice-of-hardware and
> > overcommitted VMs.
> 
> Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
> guarantees for all VMs on a system are better met by enabling eager splitting
> across the board.
> 
> There are other reasons to use module/kernel params beyond what Marc listed, e.g.
> to let the user opt out even when something is on by default.  x86's TDP MMU has
> benefited greatly from downstream users being able to do A/B performance testing
> this way.  I suspect x86's eager_page_split knob was added largely for this
> reason, e.g. to easily see how a specific workload is affected by eager splitting.
> That seems like a reasonable fit on the ARM side as well.

There's a rather important distinction here in that we'd allow userspace
to select the page split cache size, which should be correctly sized for
the backing memory source. Considering the break-before-make rules of
the architecture, the only way eager split is performant on arm64 is by
replacing a block entry with a fully populated table hierarchy in one
operation. AFAICT, you don't have this problem on x86, as the
architecture generally permits a direct valid->valid transformation
without an intermediate invalidation. Well, ignoring iTLB multihit :)

So, the largest transformation we need to do right now is on a PUD w/
PAGE_SIZE=4K, leading to 513 pages as proposed in the series. Exposing
that configuration option in a module parameter is presumptive that all
VMs on a host use the exact same memory configuration, which doesn't
feel right to me.

--
Thanks,
Oliver

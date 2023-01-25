Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7E6EC3
	for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 00:51:40 +0000 (UTC)
Date: Wed, 25 Jan 2023 00:51:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674607898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tKZJHCuNcS9wmdGcYa74NyQbaZqjeiShG5FvQ1mhWsM=;
	b=bj8WStw0zxg3MLqdRtbAX0JL3VYIi9naRAx1uWiRdxJdQreQasQOekCNtU6DzYsQo7oi1M
	LHae7+//6q3qHKef5X57sWNCE20HZfjwjIcBMDrz/cOWaVFr+2MFwgmAfiIok12p6RuelG
	1ntXs3GUvHw8B1SPOECe82979r6Pdd4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH 0/7] KVM: Add a common API for range-based TLB
 invalidation
Message-ID: <Y9B9FZReDVwdNNrS@google.com>
References: <20230119173559.2517103-1-dmatlack@google.com>
 <Y9B8A+/FSPCrAANT@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9B8A+/FSPCrAANT@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 25, 2023 at 12:46:59AM +0000, Sean Christopherson wrote:
> On Thu, Jan 19, 2023, David Matlack wrote:
> > This series introduces a common API for performing range-based TLB
> > invalidation. This is then used to supplant
> > kvm_arch_flush_remote_tlbs_memslot() and pave the way for two other
> > patch series:
> > 
> > 1. https://lore.kernel.org/kvm/20230109215347.3119271-1-rananta@google.com/
> > 
> >   Adds ARM support for range-based TLB invalidation and needs a
> >   mechanism to invoke it from common code. This series provides such a
> >   mechanism via kvm_arch_flush_remote_tlbs_range().
> > 
> > 2. https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/
> > 
> >   Refactors the TDP MMU into common code, which requires an API for
> >   range-based TLB invaliation.
> > 
> > This series is based on patches 29-33 from (2.), but I made some further
> > cleanups after looking at it a second time.
> > 
> > Tested on x86_64 and ARM64 using KVM selftests.
> 
> Did a quick read through, didn't see anything I disagree with.

LGTM for the tiny amount of arm64 changes, though I imagine David will
do a v2 to completely get rid of the affected Kconfig.

> Is there any urgency to getting this merged?  If not, due to the dependencies
> with x86 stuff queued for 6.3, and because of the cross-architecture changes, it
> might be easiest to plan on landing this in 6.4.  That would allow Paolo to create
> an immutable topic branch fairly early on.

+1, that buys us some time to go through the rounds on the arm64 side
such that we could possibly stack the TLBIRANGE work on top.

--
Thanks,
Oliver

Received: from out-11.mta1.migadu.com (out-11.mta1.migadu.com [95.215.58.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48462C942
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 19:09:25 +0000 (UTC)
Date: Tue, 4 Apr 2023 19:09:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680635363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S1gwK2nwRYjccyYSDh2DfgE6FA3Ietx2jBphXAwjNbk=;
	b=Yu2TDQQadJpNt4mwGvQ9bzOiNHxLFFVeynE9Zm4Z/2zV4EpNmeVQ0aosrF7mNhuNrIwjzT
	gapdoPi3cKVwSWnN3/qKJohgqXd7/RWoQXLNr/W+t79INkjFQMYcwXRQ4AKeiSxDFLeBKr
	b8zbHPJJu5vXodgmHwXHnG2L+fKTZPM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
	Ricardo Koller <ricarkol@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/7] KVM: arm64: Implement
 kvm_arch_flush_remote_tlbs_range()
Message-ID: <ZCx13Q4nyRghItcI@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-5-rananta@google.com>
 <ZCTdcJLxWBRXItSM@linux.dev>
 <CAJHc60xbhyiVieqzeMcB1S7UWw_J3Jyh8PqjA9GLOhudja5nmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60xbhyiVieqzeMcB1S7UWw_J3Jyh8PqjA9GLOhudja5nmA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Apr 03, 2023 at 02:23:17PM -0700, Raghavendra Rao Ananta wrote:
> On Wed, Mar 29, 2023 at 5:53 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Mon, Feb 06, 2023 at 05:23:37PM +0000, Raghavendra Rao Ananta wrote:
> > > Implement kvm_arch_flush_remote_tlbs_range() for arm64,
> > > such that it can utilize the TLBI range based instructions
> > > if supported.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h |  3 +++
> > >  arch/arm64/kvm/mmu.c              | 15 +++++++++++++++
> > >  2 files changed, 18 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index dee530d75b957..211fab0c1de74 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -1002,6 +1002,9 @@ struct kvm *kvm_arch_alloc_vm(void);
> > >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> > >  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> > >
> > > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
> > > +
> > >  static inline bool kvm_vm_is_protected(struct kvm *kvm)
> > >  {
> > >       return false;
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index e98910a8d0af6..409cb187f4911 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -91,6 +91,21 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> > >       return 0;
> > >  }
> > >
> > > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
> > > +{
> > > +     phys_addr_t start, end;
> > > +
> > > +     if (!system_supports_tlb_range())
> > > +             return -EOPNOTSUPP;
> >
> > There's multiple layers of fallback throughout this series, as it would
> > appear that deep in __kvm_tlb_flush_range() you're blasting the whole
> > VMID if either the range is too large or the feature isn't supported.
> >
> > Is it possible to just normalize on a single spot to gate the use of
> > range-based invalidations? I have a slight preference for doing it deep
> > in the handler, as it keeps the upper layers of code a bit more
> > readable.
> >
> I was a little skeptical on this part, since the
> kvm_arch_flush_remote_tlbs_range() expects to return -EOPNOTSUPP if
> indeed there's no support.

Well, the arch-neutral code can expect whatever it wants :) The only
real contract we have with it is to return 0 iff the specified range has
been invalidated, even if that comes with over-invalidating.

> But I see your point. The if-else in kvm_pgtable_stage2_flush_range()
> seems redundant and I can simply manage this conditions inside
> __kvm_tlb_flush_range_vmid_ipa() itself, but I'll leave the
> kvm_arch_flush_remote_tlbs_range()'s implementation as is. Thoughts?

The largest concern I had is that the series is testing for FEAT_TLBIRANGE
all over the shop and I just raised that concern on this patch. AFAICT,
the iterative approach to invalidating a range of IPAs is effectively
dead code, as all flows into __kvm_tlb_flush_range_vmid_ipa() are gated
by system_supports_tlb_range() somewhere.

Personally, I prefer keeping the higher level software models making
aggressive use of range-based interfaces and letting the actual
implementation under the hood select the appropriate instruction. That
helps readability, as it directly communicates the expected outcome of
the invalidation.

So, if you want to make use of the iterative approach to TLB invalidations on
!TLBIRANGE systems, then this function should _not_ return EOPNOTSUPP.

-- 
Thanks,
Oliver

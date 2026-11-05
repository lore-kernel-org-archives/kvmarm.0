Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793905463;
	b=ODEYABxGsEIkXi6T6tTBVypYw2ix7UVYDUKjUvF8XeW95rkZ30wv3Ka3muw83W+nwlZP
	 uW4mMA0pScMYpJbnIH53RldF2NWIOamfPJdHiMAfeel0KQcn9ioTLoBgo/JvnoLTzsIYE
	 JSYTWWK57S4V27WMCzKXUEQcx9SABVjMMyY++BPKHGmVMHmX7wDnbMRjAZ+61Gr/RdWFH
	 Bt46LENiiSRhDdV/VHFmaipF6GZwJDULtbqL6ilMAY92NWGum/DUsAs8jLRZDkkJTWJja
	 Ecy33QvrATXl70wnncM4WLUPuF4Uvhe46YKjEImavcrntcUf42GdPOdqaEHwDQQ5ACg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793905463;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rLWhvCj1UCjx0H2m7OWzapN/VPTtDSdiXxZNIfUhXCM=;
	b=agUXsLxaDLKE1gxfMdsp1xUB/xsfzbuVKVuLDqD4PGGxq4kBcCQ4KPgz58JR1tldoTml
	 h4APP8HnQ81lNr258iZy1/zu74RBHTgWwqjjFhfCsgiOZ5MqHpDtutYbYYsBaKB8x41nK
	 jLHjxAT1QYuuKICDxWLg19DWQi5ZIRwNOa4fB8PGUUmzrpNjIRlcQ2tS+hqm0Vs0hTbw2
	 ZRTKNGB1tb23iAwqeQK4k75pQPv7Vtk086so24h8pGtNqhfG5ZY6tfT/1wVb+PH+bnCaP
	 bX0TaiNvM1TjDyLLWn8UtAPsOkKYYMklu/+uINe76TWsPkBwa2ObpOiryOv8c5vvk7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a7KRn5UW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC15606A326;
	Thu,  5 Nov 2026 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a7KRn5UW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFCB1F000C1;
	Thu,  5 Nov 2026 19:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793905463;
	bh=rLWhvCj1UCjx0H2m7OWzapN/VPTtDSdiXxZNIfUhXCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a7KRn5UWkD2bg4mfjBaHuZrPBFOQU5noiWBtxbTkRkapYFkzbJooltue1tjMDltFe
	 nQlN1aMdJhscG3nBcJHrK/xth/cma7LTfimTmBAi6sSO48Dwcx52pdvqIfLeFY983J
	 rKElw5cUOWFv+QQns+wpIZnzGGakfW2UyQMgI1DSLqq7FTSlMGkk0PPwe96V9vmfWd
	 dFEDVFmxdKSJhJxngaUkdu0iL1/dwXyr8bsBJWmdzJyZ/bN7VBZY5y71k+/PB1a7cr
	 MCRttZFECSUq18Votb38NZ571RtsP+oIP1IubyMUXpYn4NLj/mxCpIc8KyHAG2aUcW
	 qEsxvANNTEo5w==
Date: Thu, 5 Nov 2026 19:04:18 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	david@kernel.org, mark.rutland@arm.com, ackerleytng@google.com
Subject: Re: [PATCH v2] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
Message-ID: <auzTFiZCiL5m_4yw@gremlin>
References: <20260714160411.302386-1-alexandru.elisei@arm.com>
 <amPCdAswlk24Xilf@google.com>
 <anxAGkdyPYXBlS00@raptor>
 <autwsR83Ii-tRrqF@gremlin>
 <auzSxEsGAcm3MYtN@google.com>
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
In-Reply-To: <auzSxEsGAcm3MYtN@google.com>

On Thu, Nov 05, 2026 at 11:02:28AM -0800, Sean Christopherson wrote:
> On Wed, Nov 04, 2026, Lorenzo Stoakes (ARM) wrote:
> > [updated David's email address to @kernel.org]
> >
> > On Wed, Aug 12, 2026 at 10:42:50AM +0100, Alexandru Elisei wrote:
> > [ ... ]
> > > On Fri, Jul 24, 2026 at 12:52:20PM -0700, Sean Christopherson wrote:
> > > > It'll probably take me a few weeks to circle back to this, as I finally crawled
> > > > out from underneath a pile of urgent and am just now getting back into review
> > > > mode, but this is fairly high on my todo list, so with luck we might still squeeze
> > > > this into 7.3.
> >
> > Hey Sean,
> >
> > I wondered whether you'd had a chance to look at this?
> >
> > After discussing this with Marc and Alex it is clear that this is really a
> > blocker for Alex's SPE series, as we need a sensible means of ensuring
> > that stage-2 mappings stay in place.
> >
> > So ideally would prefer to get something like this in in the next cycle,
> > if you don't have any objections to it? :)
> >
> > If it'd be easier, I think a smaller version of the same patch would also
> > give us what we need? I.e. your snippet from June with the page ageing part
> > dropped, as below.
>
> The GPC invalidation fix landed, so we can go straight to the super simple v1.
> Compile tested only at this point, I'll formally post this (hopefully today),
> assuming nothing explodes in testing.

Perfect, thanks very much :)

>
> --
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> Date: Mon, 15 Jun 2026 16:52:44 +0100
> Subject: [PATCH] KVM: Skip gfn-based MMU notifier invalidations for
>  guest_memfd-only memslots
>
> Don't invalidate gmem-only memslots when responding to MMU notifier
> invalidations, as the entire point of gmem-only memslots is so that KVM
> doesn't need a VMA to install mappings into KVM's MMU.  Specificially,
> page faults are resolved by going straight to guest_memfd, using the gfn
> and the associated memslot's gmem.file.  I.e. whether or not userspace
> happens to have valid mappings to the same gmem instance is irrelevant,
> as are any invalidations for those mappings.
>
> Note!  The exception is KVM's gfn_to_pfn_cache implementation which isn't
> yet wired up to pull pfns directly from guest_memfd, i.e. still relies on
> userspace mappings/VMAs and thus need to be invalidated, e.g. to ensure KVM
> doesn't retain a kernel mapping+pointer to PRIVATE memory.  However, as of
> commit da260bcb56fe ("KVM: pfncache: use a dedicated invalidation sequence
> for cache refresh"), GPC invalidation no longer relies on memslot lookups,
> because GPCs also support HVA-based mappings.  I.e. KVM *must* be able to
> detect and handle relevant MMU notifier invalidations even if there is *no*
> memslot whatsoever.
>
> In addition to the obvious performance benefits, avoiding unnecessary and
> spurious SPTE zaps and TLB flushes will allow KVM to support features like
> ARM's Statistical Profiling Extension (SPE)[1] and x86's Secure AVIC[2],
> both of which rely on the pages *never* being unmapped from the stage-2
> page tables.
>
> Link: https://lore.kernel.org/all/20260903160623.315525-1-alexandru.elisei@arm.com [1]
> Link: https://lore.kernel.org/all/cover.1783490022.git.naveen@kernel.org [2]
> Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: Naveen N Rao (AMD) <naveen@kernel.org>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> [sean: rewrite changelog to capture the new gpc behavior]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf4cb586f140..599dea22afb8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -601,6 +601,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
>  			unsigned long hva_start, hva_end;
>
>  			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
> +
> +			if (kvm_slot_has_gmem(slot) && kvm_memslot_is_gmem_only(slot))
> +				continue;
> +
>  			hva_start = max_t(unsigned long, range->start, slot->userspace_addr);
>  			hva_end = min_t(unsigned long, range->end,
>  					slot->userspace_addr + (slot->npages << PAGE_SHIFT));
>
> base-commit: d21eef2084a9af87ac2a783bc7c2b175ba114e4e
> --

--
Cheers, Lorenzo

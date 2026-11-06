Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961963;
	b=YUwsVnHRdpOz8rBb8fTFUcr/6hHVDnSZk3yxaSFFw9NT1U/leoRqFL/VcCmBJQse96K0
	 DkvimYp126cjBOEAAuGS/qGcWnWpBKhzEA7gUlVOPJ/MNKhJyVa0nbm0DtrUYhD7b6YRB
	 DAtphzVXdykUdq1i3yDoiZcIsZngIWIW2iRBxYNrU6Bnacrxgd5oR6QX8Xd47po8sUSIK
	 agHM/hWrJSxqqjjIx/BE4jnsKCVbT9utYa2OrVD1iXCR8sbofeGNeeJNg+1AGWywDIxgg
	 OXLd/GZs27SKak6BGbxh+sEc1bOvrr0bhqM7fmpyMh/cx/pk69qqSgQwEqATC4hJ8pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961963;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=EBOzhR38zAbfIVOw2so9GKfjXciI6NC0gGb/q053Uvw=;
	b=f0S1l+d9F+3/l5m4T/v8EdTn1A+OcRoes7SiJXX/MQ7wtPAzBhKZ8y8Yl2eRrbc9xi8J
	 tOxZAepwgVvTs4r05rYbFg1MGmQSbkBOz8CE++av5zaJC5hpsxN2ySXBBxVHnhGN58mg7
	 hlQZCXKMjAsCr60ORFKFS0z08zWDo/Hv1D7ncvbZj60nAt+S201fWOwBu+1YuR8r7JvXL
	 QXf6/j9Z7hIpwPUKjAuVrGrM3qAiulAFRVGBU0pj8FTA/PBdYAD2KZTa7K9uola63AMQo
	 AtH4RJkCahnOPNIxjf0E8SYc1Rr0WXrv3WoN6oLLQQbwlF671g8hY0Yy+ghJJ0jzyrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DSxvniHD;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8500606A32C
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 10:46:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8500606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DSxvniHD
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A57415A1;
	Fri,  6 Nov 2026 02:45:58 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74B503F673;
	Fri,  6 Nov 2026 02:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793961961; bh=Kz0mSCmJER1t1vnDARZyfMev49ZrLe9m/+tlQWtAGgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DSxvniHDbqcztfN5wXQ+N71HLuRwr1uD8C0kMxaoe5FTSBtVaGGF4RjPVSfcQL6p3
	 jCXxICd99aAnXYQI66kJlgyBYM5pciaOPd9d5JvxC6SNe5VPJ6jxZ2U60EU2qW5eI5
	 COBjnYgGy5DFy/yemQkddtpjAdQ1ebJFXF5tu96I=
Date: Fri, 6 Nov 2026 10:45:56 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, pbonzini@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org,
	oupton@kernel.org, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, david@kernel.org,
	mark.rutland@arm.com, ackerleytng@google.com
Subject: Re: [PATCH v2] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
Message-ID: <au2v5EoitiAGhoA3@raptor>
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

Hi Sean,

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

Looks great, and thank you for updating the commit message!

Alex

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

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656ED42CB1C;
	Wed, 16 Sep 2026 23:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601242; cv=none; b=fKGXsWlMhHuQV2mwKAO0LHfGBiE/Z3U3yscc2txb32m6iMQ3Rm7YYIbz4PX7HEfoPJ1jB4wZ9/J5iW+tWJYMtgxOY3ogssa5m29crFLICcxr8Dh2V76s5R2/N3WFE9KfRblXrTg2YRiSuYfsTI2Lq7WG807PzwuGB6nKMtME5yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601242; c=relaxed/simple;
	bh=kVukq6PGE++Zf2M92DLF9J8c1ZNhBniKUYbXKgjndWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ftFFwG3P5y3kUzLfv1xjeUGFdiZ7F9+6eIcFQlO7SbuvO963vmyvp3RXTkcK3i0uRy0Hk1sziMoj1PBRA4n4NYiCDy4CJzYFCNmCCx0G333/KyGvhS4dsegZmXVhXIUS4kTwQh3mZpM2HUAme+bFEGa/HinZOZaGhfftYhYR9pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kequ4qrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kequ4qrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1371F000FF;
	Wed, 16 Sep 2026 23:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789601241;
	bh=DdxpGXS/wnimnfN1olqkWbYsmp9jSsthllf3I7l40Ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kequ4qrLA/stLLGW3CIkibGQx0JSpzNkkyEC2GB6l4KbXM1pbpDkBhKYpRYWyRIwm
	 caDnU8ZHFn/B0sKQskme34CLjplcus9b7TlWQJacNToFnA5bAbOllLlXZYmDH6zMAm
	 BXDoZnZZixhR6e0K0+UCYtZ5PemfnyR03j1heAsH8SrfhE6fWfTDnJoje2bpD5xFml
	 DnzY5Qkw80HsnXUwaPjQDtVsHgv0yFNKNOwH0BcPlZ2kCqNFiEGbI5HkXrq3RxF3bS
	 dCDvCwKGfBp8TcOEIkQbawKkW9Lox0zzpsfJ6q9uANwzcHOQHf6I8KpzbqcV35R5vS
	 UCDetSCvp93rw==
Date: Wed, 16 Sep 2026 16:27:19 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on
 migration
Message-ID: <aqsl1_IqnV2r8kUL@kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-6-leo.bras@arm.com>
 <aqneWnlsdpocLIl6@kernel.org>
 <aqqhDs3NyjtkZzXK@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqqhDs3NyjtkZzXK@LeoBrasDK>

On Wed, Sep 16, 2026 at 03:00:46PM +0100, Leonardo Bras wrote:
> On Tue, Sep 15, 2026 at 05:10:02PM -0700, Oliver Upton wrote:
> > Hi,
> > 
> > On Tue, Sep 01, 2026 at 06:15:56PM +0100, Leonardo Bras wrote:
> > > When dirty-logging is disabled, even non-write faults make a page dirty,
> > > which avoids a second fault when the page is actually written to.
> > > 
> > > On dirty-logging enable, this approach causes all (writable) pages on the
> > > memslot to be marked clean, even if they were not written to, which can
> > > take a lot of time, while holding the MMU lock, doing atomic writes to
> > > PTEs.
> > 
> > Do you have any performance numbers for this? Enabling HAFDBS seems a
> > bit involved to avoid some stores on the first pass.
> 
> Not yet, but if the idea does not look too crazy I can find hardware and 
> collect some data :)

TBH this looks like a micro-optimization so I'm not expecting the
performance gains to justify the behavior change.

> > > 						      has_vhe() &&
> > 
> > I don't see a reason why this needs to be constrained to VHE-only.
> > 
> 
> Humm, in nVHE would not the host kernel run in EL1?
> I thought that this being a feature that depends on EL2 registers host 
> would need to be in EL2 to make use of it.
> 
> That being said, I understand very little of how this works, so I 
> constrained to VHE only at the start.
> 
> Would this work in nVHE?

We already pass a stage-2 MMU configuration to EL2 from EL1 in nVHE and
hVHE. How is this any different?

I'm not opposed to making features VHE-only, but there needs to be some
amount of reasoning to justify it.

> > > +		!kvm_vcpu_has_nv(kvm) && cpus_have_final_cap(ARM64_HW_DBM);
> > 
> > Same thing goes for nested... KVM can make use of HAFDBS in the
> > canonical stage-2 MMU (or even a shadow stage-2) independent of the
> > guest hypervisor.
> > 
> 
> Humm, I remember reaching the conclusion that it could not be used if the 
> guest supported NV. Let's say:
> 
> L0 - Host	- Has HAFDBS enabled
> L1 - Hypervisor - Has HAFDBS disabled
> L2 - Guest	-
> 
> Let's say guest writes to a page, and the shadow S2 has DBM=1, so it's 
> marked as WD by HAFDBS. Since no fault was taken, how would the L1 be able 
> to update it's S2 pagetables to mark the page dirty?
> 
> (We would have to transverse the Shadow S2 Pagetable updating the original 
> S2 pagetable)
> 
> I was wondering, thought, that we could emulate it in the last level 
> hypervisor, if it's guest does not support nested guests. That would mean 
> we can have the last-1 level hypervisor to update the S2 pagetable on the 
> last level hypervisor without it having to fault. Ex:
> 
> L0 Host - HAFDBS disabled
> [...]
> Ln-1 Hypervisor - HAFDBS disabled
> Ln   Hypervisor - HAFDBS enabled
> Ln+1 Guest - No E2H feature
> 
> When the guest writes to a page, the host should receive a fault, that IIUC 
> have to propagate down up to Ln Hyp. If Ln Hyp has HAFDBS, we could skip 
> injecting a fault in Ln Hyp, as  Ln-1 Hyp could emulate HAFDBS and write 
> the dirty bit to S2 pagetagle of Ln+1 guest, that resides in Ln memory.
> 
> Not sure if the troulbe would be worth, though.
> Does it make sense?

I'm not following your reasoning here. Treat the shadow stage-2 MMU as a
TLB; that TLB is filled with a writable translation when S2AP[1]=1 in the
L1 translation.

The dirty state of the pseudo-TLB is completely internal. You could then
layer HAFDBS for the L1 translation on top of this (which we don't
support) by potentially relaxing the descriptor _before_ evaluating the
resulting permissions. You'd then take write permission faults to set
S2AP[1] in the L1 translation.

> > The name would suggest this thing takes a vcpu pointer...
> > 
> 
> Ah, that name was based on
> #define kvm_vcpu_has_feature(k, f)  __vcpu_has_feature(&(k)->arch, #(f))
> 
> That takes a kvm struct to check the kvm_arch one, instead of looking into 
> the vcpu. I did it like this because there were some scenarios it was not 
> quite straightforward to get the vcpu to use vcpu_has_nv(), which takes a 
> vcpu.

This thing probably should've been "kvm_has_vcpu_feature()" or similar to
massage the expected typing.

Thanks,
Oliver

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6983437858;
	Tue, 21 Jul 2026 06:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784615662; cv=none; b=emNKBBmPV0QwZkktsnzWUXWGiSh5/sMaSfhCbJGXJI0bwcB0KL2mAqypFv+IkP78ISK39TBFrhj/EmsWZ4yATzweoX+9P93i1Ta6HKaOrN/9eY25kDe1L+mNf9bSwwYroFyrcDswu6RsWjOVRWoJyINMW6wC75ckUx5q0FUImW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784615662; c=relaxed/simple;
	bh=2AmwsAdUabkkEiAO4caxJk6jKmZM3hNecDH462kfEN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jg/vZZoeuSL2pR8zXR8ztyExMBdLDUv3HqXd9k0uljwlzLXX1W7xx+Cp7LWmUpJRMacNky/LKNxPfqsdizpf89I0ibCpgo0+mh8/kt5c63S5Jm3+FKzGNYWPkBVkx/ifG2wcBPUpm7s5BI1gG+5DAXPaWkHDODCAy4VzZVj632w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZcgoyfHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZcgoyfHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3991F000E9;
	Tue, 21 Jul 2026 06:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784615660;
	bh=uuxUr7iCM2koNMPwKDdyaBS3quAo3SF74UDYa07WVDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZcgoyfHHkS7BSzH5pbhW9RN1uhEcXcwlOiSjDPhrKSxOQ37QlGOdqMJvEwI1bYlpW
	 57d19pjpMLHiVvkp7osTUoFcEIs/7Jj33PXf5wYIJz5Caoeta/VlyVHX0tXNcBIIQq
	 CSj0kLcN+QpF/JW37h74+0n0PJfkGcQCsGpJ4eGN0AASVMUmbgldhTHSoyXuWPTdxo
	 fhsZDr7iRT2MOnCbmXx8qg4ODM1SuJITEMXuW7EKnV7Y63YP0+rNqYKWWy8abYNfZW
	 PfZBT1TRju3cHyT3YU4IoZ7SoFZCyRBB+j36Ax8j5hE+PMXBrmssyMwcP8FqHiuKkb
	 pgpdo4cb1vkLg==
Date: Mon, 20 Jul 2026 23:34:18 -0700
From: Oliver Upton <oupton@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	vdonnefort@google.com, tabba@google.com
Subject: Re: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3
Message-ID: <al8S6qAB2o0nLo30@kernel.org>
References: <20260717130901.2239134-1-smostafa@google.com>
 <20260717130901.2239134-3-smostafa@google.com>
 <alqW49CH7eViDpAZ@kernel.org>
 <alvaEgJFJ5DaQaac@google.com>
 <CAFgf54r0xYwUGgPMY=1aTRzcqX7jKp545Jb+p_yFW=JwAX0E4g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFgf54r0xYwUGgPMY=1aTRzcqX7jKp545Jb+p_yFW=JwAX0E4g@mail.gmail.com>

On Mon, Jul 20, 2026 at 09:41:04PM +0100, Mostafa Saleh wrote:
> On Sat, Jul 18, 2026 at 8:55 PM Mostafa Saleh <smostafa@google.com> wrote:
> >
> > Hi Oliver,
> >
> > On Fri, Jul 17, 2026 at 01:56:03PM -0700, Oliver Upton wrote:
> > > Hi Mostafa,
> > >
> > > On Fri, Jul 17, 2026 at 01:09:00PM +0000, Mostafa Saleh wrote:
> > > > If the system supports hardware Break-Before-Make (BBM) level 3, use it
> > > > to replace stage-2 PTEs directly instead of falling back to the software
> > > > break-before-make sequence.
> > > >
> > > > 1) Get a reference count on the containing table for the new PTE.
> > > > 2) Atomically update the PTE with the new valid descriptor.
> > > > 3) Invalidate the TLB for the old PTE.
> > > > 4) Drop the reference count holding the old PTE.
> > > >
> > > > One interesting case, as BBML3 will update the PTE atomically, it
> > > > can only know it raced with another core at the point of the cmpxchg
> > > > failing, unlike the SW implementation which locks the PTE first.
> > > > And as we must issue CMOs to the new mapped page before the update,
> > > > that means with BBML3 racing cores will issue redundant CMOs,
> > >
> > > I'd rather we just predicate BBML3-style transformations on an
> > > implementation having FEAT_S2FWB and DIC. You can definitely come along
> > > later and enable it when using a stage-2 in an SMMU makes this
> > > mandatory, possibly at the expense of some extra CMOs.
> >
> > Makes sense, I will do that in v2.
> >
> 
> Looking into this, I see some existing inefficiencies (or maybe I do
> not understand it well)
> - pKVM still do some work for dcache with FWB I posted a patch for that:
> https://lore.kernel.org/all/20260720203529.1276355-1-smostafa@google.com/
> 
> - KVM does not elide the icache maintainence with DIC, it seems we
> should have something similar for the FWB check in
> __clean_dcache_guest_page() as
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 6eae7e7e2a68..d0a4ae66b069 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -247,6 +247,9 @@ static inline size_t __invalidate_icache_max_range(void)
> 
>  static inline void __invalidate_icache_guest_page(void *va, size_t size)
>  {
> +       if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> +               return;
> +
>         /*
>          * Blow the whole I-cache if it is aliasing (i.e. VIPT) or the
>          * invalidation range exceeds our arbitrary limit on invadations by
> 
> or I am missing something?

Take a look at icache_inval(_all)_pou(), they both internally test for
DIC.

Thanks,
Oliver

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795713488;
	b=eJRAtGPyQxNHXqNXoZDqbPg+5zC/+0nsiWpUOFhkqciJ6H54RH9ZcfqcBuEI7gea4pcH
	 MrQ8RNMfk3GCOciKwi8UKfUagP5HCCZMoJv2x0CohLliQNsuQRSZ0EAVY/wdLd/BrtMG9
	 UJZcnijINIP3UUgZJwCWONNFAhl1q8u0wkty9eaoCTMNIwtMOw5mvs9YxFV20b33DPc5Y
	 h3hW3DIk4fzzt/kQwHYLu0NVs0G/hjtibuwQsTGuf83k6AwCgqZ/ITTadXC612aH8Ym+u
	 Ff5NAsRQdwzuzapj0tv0Q1QI+880UnCUBF63zBzjMxNR/J7fn821zbW+OavVPcAb9OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795713488;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=V5xmoW4LeD92bfUW3nTeFlKJBK+Im2x8DkYDeOLL1Fs=;
	b=5Yx6GmHlEZNpp7IWJQeVmeE0KwC3TPgFGIvb3GdIhUTXS43DeqJMVK4eTqKcf5gzYpoT
	 zjIrMyMai5WJB+CXQfH968jvDQ38cAc9ZxeThaBtkIzigd2fGljRZSbwAJR3yTpDTDM9l
	 JpoK0aeer4OA5UMjyiK+pl/XC/YXc2EjzV761ZERavFnCcehdKFqn2R0mREwSg7vLI7Wc
	 7IUBtj5uYgsarir66HFHSS/434HhdSUX725xaJ/7vl0sz0pYSZcnT7WiSuF0FqOUlTkx4
	 lJwKFQnsbaqYg7r/VSwCiv4QTnB/CkuFOxwMccgo1Nmhi86S2ZPmfGwq16p4yNbltLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HsEOHv2+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7B5606A31C;
	Thu, 26 Nov 2026 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HsEOHv2+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654E41F000C4;
	Thu, 26 Nov 2026 17:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795713488;
	bh=V5xmoW4LeD92bfUW3nTeFlKJBK+Im2x8DkYDeOLL1Fs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HsEOHv2+oDS6M9briT4hHB2Uatfz/gw6X+Xk0j0ANg2CqNC5xpG3J9mRBOJRGsPXh
	 Gi5CsYaHySPyXAbuA1nlGhz2vRbA4Bk+9TRO539iSbDHlg39hYELdBfydxRp2ymQsa
	 sTbKL1Vtp+yPbYpkBHuelzvO4CzcLjSqznelSj/u9WZzfA265COlRvTpFkRzntK9Cq
	 /N0IPPqCgBkQ57it9NFqX8dW5tnOhvNTg0kO5FQL/ert79vv56BRNyVVlRKF5bLPGG
	 6RT3p+ic4McQa4zZJly2dplygUHPVbP2gWd2YR5hLXYZXelHaX9lle6uTf/BekoIiS
	 AP7D/wTnCEXRw==
Date: Thu, 26 Nov 2026 17:18:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Wei-Lin Chang <weilin.chang@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	rkeilty@meta.com, atish.patra@linux.dev, dgreid@meta.com
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Message-ID: <awhpQIWN3msQ2ruf@gremlin>
References: <awcXhk885lqDRAHy@LeoBrasDK>
 <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
 <awcoCklLOKeuXPhh@LeoBrasDK>
 <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev>
 <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>
 <awhODYKXnsBi_s_B@LeoBrasDK>
 <klnyvfxwhpw73wo55y5aq3qliglnf7xkfkmfj6cgzje7z3n2fq@aqjxshyjnldu>
 <awhWYdZVkESY9eJs@LeoBrasDK>
 <awhfXrdkHkY-riN3@gremlin>
 <awhnFrt1GmrTlQZ9@LeoBrasDK>
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
In-Reply-To: <awhnFrt1GmrTlQZ9@LeoBrasDK>

On Thu, Nov 26, 2026 at 05:07:21PM +0000, Leonardo Bras wrote:
> On Thu, Nov 26, 2026 at 04:45:35PM +0000, Lorenzo Stoakes (ARM) wrote:
> > The question is would going from 40 to 3 slow things down?
> >
> > At 40 you do 40 __get_free_page() calls on topup for the _first_ fault that hits
> > it, which adds latency to a random s2 fault (not great).
> >
> > (If the fault doesn't in fact use a page table, this is only done once until a
> > page table is next needed).
> >
> > And then as 37 page tables are mapped, those ones don't get allocations at 38
> > you go again...
> >
> > With 3 in the cache you allocate up to 3 for each fault.
> >
> > So in both cases you allocate the same amount of pages but in the 40 case it's
> > all bunched up on one s2 fault with a jump in latency, in the 3 case it's spread
> > out.
> >
> > I'd say 3 is therefore the better choice.
> >
> > Also, as mentioned elsewhere, you end up leaking pages once the S2 page tables
> > are setup until the vCPU is destroyed, as nothing clears down the cache
> > AFAICT. With 40 that's way more than with 3.
> >
> > --
> > Cheers, Lorenzo
>
> Hi Lorenzo,
>
> When I mention cache locality above, I mean the cpu cache. Running the same
> routine 40 times in a row can be faster since all instructions are already
> cached, and most of the data acessed by it could be local as well.
>
> If you run it more often, it could be that something else used the
> cachelines and the cpu has to fetch them again from lower level caches or
> memory.
>
> That being said, that's the only reason batch allocating 40 would be faster
> than 4 in the long run. For capacity=4, the number of
> mmu_memory_cache_alloc_obj() calls can be even smaller than capacity=40,
> since we don't leave unused pages in the kvm_mmu_memory_cache.

Ah right I see what you mean, true that would be warmer, but I suspect that'd be
lost in the noise vs. zeroing each page anyway, and additionally you can argue
that, if you just zeroed a page before the walk uses it, there's locality
advantages on that vs. batched too.

But again I'd be very surprised if there was any impact on that either way,
really.

In any case it seems we agree that a smaller capacity is the way to go :)

--
Cheers, Lorenzo

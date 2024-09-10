Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03CF1A38F4
	for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 19:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725998010; cv=none; b=uFq53m36hd2UewvlfANOGt9tM4D/oTUVqfLcMq38/8Ns5WuQ/4W2M/rx2wiWQ4v/E/JMGmaPuugNUVfjWtmxybQHNX9zHSYhy05Gr6JrCY/SDsYWhYa9CiDqiggFLlO+VZseGEpMBvv4l7piWf51dGMc6zT4eaIDoRu3L4daJH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725998010; c=relaxed/simple;
	bh=wb0mIEZ445H14RdqGSutn3RkwklWd6CjNMMvc/kGgtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oke6igOu7nIkKGudxTzdV1Jc7fRq21iZ1JDz5N/T+YAj/ig0g0BrxyNN7u2+ZnM6416ufIqfEX9HEWI1/eGLkRONoP/Th14s5jyTNSnI+54Ly5S1I7g1vRtYfuk9rjimlnnt0PKT46ygE2rc8jjvddPSwuKSI7Mc6o6FP6okDc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iEFrinx+; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iEFrinx+"
Date: Tue, 10 Sep 2024 19:53:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725998006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UwT2cDw4vpxQs5a0kYXfI29D3vXun6olssb+L8yJHrI=;
	b=iEFrinx+wGacDxIL48vDE1DP42Urot1X6o5O8GbZpcdj2hbSRSBLB9QNRVno6MFHoNQWFY
	7saLxY37KYfAuS6ZlVfxF6t8EDNm8Sow76TEzNoXmzDFg6YYb3Zqa1cdWDYvMZ3DuI+ZyF
	jt5StS43eWYqKrIPlYhmPRGaG6SDNSo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Snehal Koukuntla <snehalreddy@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Add memory length checks and remove
 inline in do_ffa_mem_xfer
Message-ID: <ZuCjrzNBJQ7sdCi8@linux.dev>
References: <20240909180154.3267939-1-snehalreddy@google.com>
 <rm2pihr27elmdf4zcgrv5khs7qluhn77tkivkr6xkvqcybtl4m@7hesctcacm4h>
 <ZuCNge74gVpJi2Sf@linux.dev>
 <86r09r70hj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r09r70hj.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 10, 2024 at 08:49:28PM +0100, Marc Zyngier wrote:
> On Tue, 10 Sep 2024 19:18:41 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Wed, Sep 11, 2024 at 12:32:29AM +0800, Wei-Lin Chang wrote:
> > > Hi everyone,
> > > 
> > > On Mon, Sep 09, 2024 at 06:01:54PM GMT, Snehal Koukuntla wrote:
> > > > When we share memory through FF-A and the description of the buffers
> > > > exceeds the size of the mapped buffer, the fragmentation API is used.
> > > > The fragmentation API allows specifying chunks of descriptors in subsequent
> > > > FF-A fragment calls and no upper limit has been established for this.
> > > > The entire memory region transferred is identified by a handle which can be
> > > > used to reclaim the transferred memory.
> > > > To be able to reclaim the memory, the description of the buffers has to fit
> > > > in the ffa_desc_buf.
> > > > Add a bounds check on the FF-A sharing path to prevent the memory reclaim
> > > > from failing.
> > > > 
> > > > Also do_ffa_mem_xfer() does not need __always_inline
> > > > 
> > > > Fixes: 634d90cf0ac65 ("KVM: arm64: Handle FFA_MEM_LEND calls from the host")
> > > > Cc: stable@vger.kernel.org
> > > > Reviewed-by: Sebastian Ene <sebastianene@google.com>
> > > > Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 7 ++++++-
> > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > index e715c157c2c4..637425f63fd1 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > @@ -426,7 +426,7 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_res *res,
> > > >  	return;
> > > >  }
> > > >  
> > > > -static __always_inline void do_ffa_mem_xfer(const u64 func_id,
> > > > +static void do_ffa_mem_xfer(const u64 func_id,
> > > 
> > > I am seeing a compilation error because of this.
> > 
> > Thanks for reporting this. Looks like the __always_inline was slightly
> > more load bearing...
> > 
> > Marc, can you put something like this on top?
> > 
> > 
> > From c2712eaa94989ae6457baad3ec459cf363ec5119 Mon Sep 17 00:00:00 2001
> > From: Oliver Upton <oliver.upton@linux.dev>
> > Date: Tue, 10 Sep 2024 16:45:30 +0000
> > Subject: [PATCH] KVM: arm64: Drop BUILD_BUG_ON() from do_ffa_mem_xfer()
> > 
> > __always_inline was recently discarded from do_ffa_mem_xfer() since it
> > appeared to be unnecessary. Of course, this was ~immediately proven
> > wrong, as the compile-time check against @func_id depends on inlining
> > for the value to be known.
> > 
> > Just downgrade to a WARN_ON() instead of putting the old mess back in
> > place. Fix the wrapping/indentation of the function parameters while at
> > it.
> >
> > Fixes: 39dacbeeee70 ("KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer")
> > Reported-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 637425f63fd1..316d269341f3 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -426,9 +426,8 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_res *res,
> >  	return;
> >  }
> >  
> > -static void do_ffa_mem_xfer(const u64 func_id,
> > -					    struct arm_smccc_res *res,
> > -					    struct kvm_cpu_context *ctxt)
> > +static void do_ffa_mem_xfer(const u64 func_id, struct arm_smccc_res *res,
> > +			    struct kvm_cpu_context *ctxt)
> >  {
> >  	DECLARE_REG(u32, len, ctxt, 1);
> >  	DECLARE_REG(u32, fraglen, ctxt, 2);
> > @@ -440,8 +439,10 @@ static void do_ffa_mem_xfer(const u64 func_id,
> >  	u32 offset, nr_ranges;
> >  	int ret = 0;
> >  
> > -	BUILD_BUG_ON(func_id != FFA_FN64_MEM_SHARE &&
> > -		     func_id != FFA_FN64_MEM_LEND);
> > +	if (WARN_ON(func_id != FFA_FN64_MEM_SHARE && func_id != FFA_FN64_MEM_LEND)) {
> > +		ret = SMCCC_RET_NOT_SUPPORTED;
> > +		goto out;
> > +	}
> 
> 
> I'm not overly on the WARN_ON(), as it has pretty fatal effects on
> pKVM (it simply panics).

It's unexpected, what else are you wanting? :P

> What do you think of this instead, which
> compiles with my prehistoric version of clang (14.0.6):

LGTM, macro expansion makes the relation a bit more obvious. Feel free
to add:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

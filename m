Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A293FE57E
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 01:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713834913; cv=none; b=C9CocgCcQG9R1oO2lli8IDs/80HlQTIlNjquO+eHSZMp/3yk7/5LEg0e7r6r3lbRgJjfBWWe6yG2l0cUUbiYHkD8elpKhTxym+JTlXCN9OJw3OF/OAfi94yQc3pTlz2TqxKQP/VSNb/LJ81EbkJUkx2Qyhv8nTS48fSBEeRGeDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713834913; c=relaxed/simple;
	bh=4hQ9clurPT3YTmNUEkuZMCVMl6fxNsaJrzyJvxh3DxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TxCz7vRPmnHrfU90pohuog6/zlcPQ76wd5l+AkqSiXQmz3kk5pjIgShf3oNjsU5sdJu4bv7vEtVByOY35BHcQ4c8232MOGvRmiXPuR7m5ARz2tumMD4ir5DSeab7TSvdK6BUXugronJ28qkpoIjHOmSaKVQ6aoy2IdiX3VDLxpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=COOWXTsg; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="COOWXTsg"
Date: Mon, 22 Apr 2024 18:15:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713834909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9KC50JhmLIfYaNboQoyU769uHCbR9BfCQpz/kpti7qw=;
	b=COOWXTsgc4PdkHwHuRM59+IJ2tS39cYYOLMnMvBl8Pa/nu9quqiwIYBzGmmuP19VzUxteg
	WVBklu7hm9EnhO2SRJfkNCi78x2ypaIc7S/bsJ+NeNbfo5VtCGyVKUhsli/yBmhEInbvbL
	zqH+vG/dZ4osYvU2NYpo2F9TbeetmaA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev, maz@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v3 27/31] KVM: arm64: Use atomic refcount helpers for
 'struct hyp_page::refcount'
Message-ID: <ZicLldy92RDCa4BX@linux.dev>
References: <20240419075941.4085061-1-tabba@google.com>
 <20240419075941.4085061-28-tabba@google.com>
 <ZiLZehsi1_arusae@linux.dev>
 <CA+EHjTx67TOQKzsLJ_9PP_rYRiYb7j0RuJLzDK8B6jK_SdQMHA@mail.gmail.com>
 <CA+EHjTzc6h719kvP9FJA3xqLnOxr5gPWDq7iYOx7JfQz4Wn61w@mail.gmail.com>
 <ZibMlkG-1MnCiXXF@linux.dev>
 <20240422234432.GA6818@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240422234432.GA6818@willie-the-truck>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 23, 2024 at 12:44:32AM +0100, Will Deacon wrote:
> Hi Oliver,
> 
> On Mon, Apr 22, 2024 at 01:46:14PM -0700, Oliver Upton wrote:
> > On Mon, Apr 22, 2024 at 02:08:17PM +0100, Fuad Tabba wrote:
> > 
> > [...]
> > 
> > > > > Adding a BUG_ON() for taking a reference on a non-refcounted page (i.e.
> > > > > p->refcount was 0) would be nice, especially since we're past the point of
> > > > > serializing everything and you can theoretically have a zero count page
> > > > > outside of the free list.
> > > > >
> > > > > Seems like otherwise we'd get actually hit the BUG_ON() in an unrelated
> > > > > allocation path.
> > > 
> > > Actually, the refcount can be 0 without it being an error. For
> > > example, when hyp pins memory shared with it by the host
> > > (mem_protect.c:hyp_pin_shared_mem()).
> > 
> > Are those not by their very definition non-refcounted pages?
> 
> Right, we're using the refcount for two things here: (1) so that the
> allocator knows when to return the page to the pool and (2) so that the
> hypervisor can transiently prevent a page which has been shared by the
> host from being unshared. That second part is needed to e.g. prevent a
> page holding a host vCPU structure being donated to a guest as normal
> memory and then having the hypervisor write to it as a result of a host
> hypercall. We use the refcount for this because the same page can be
> shared with the hypervisor multiple times and we need to know when the
> last host sharer has dropped its pin.

Ah, right. I don't have the muscle memory for the pKVM bits upstream
(even though I should), I missed the very obvious refcount test in
hyp_ack_unshare().

So it is a refcount on the page state, be it allocated or shared. And
the 0 -> 1 transition on a shared page happens through an increment
rather than an initializer like pages from the hyp pool.

> > I can't imagine we'd want pages in a shared state with the host to ever
> > get returned to the hyp allocator. Seems an erroneous hyp_put_page() would
> > get you there, though.
> 
> Given the dual-use above, I don't think a BUG_ON() on the refcount is
> the right fix. Instead, we'd probably want a (cheap) mechanism to
> differentiate pages in states (1) and (2). This could be a new flag in
> 'struct hyp_page' or perhaps we could be creative and set the 'order' to
> HYP_NO_ORDER for pinned pages and then have a BUG() to check 'p->order'
> against 'pool->max_order' in hyp_put_page().
> 
> What do you think?

Excellent idea. Having a way to disambiguate page states would be great,
all the better if it can (ab)use an existing field.

-- 
Thanks,
Oliver

Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED44D36AE0
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 06:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308291; cv=none; b=g52wDwwNUkuKJYNpmxGPv3Z5nKLZAnwQ/RbdOQKQVwEymPKUeu97v3O3Qwb8695XaCNjMQl1g/35kjdXPqQO0SWIyycYhkF74GdNEE42vplIQ3o6Fea5mWjonYXkhuoTQVu1ktvnZSrOuGIVUZVv29sOljxrw1ADCULIvb4ygOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308291; c=relaxed/simple;
	bh=jbC0DB5wuASWk06GDLKHtiUlHALW2rUUePq5AdShjM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HLLajMzZns++n9QvfKQc1/kngl/804cd2wu0NTaQtZy92N+Wu9z4vPiGYsuXKMupcU6RjMbdYNPhEzrm4zD9ufURbjbshWT6l8jEo5nLshl7xihnztJUljAMJ7MBz4VY8rycoVYFsXHlfKjNu2yuoIaPvOb9V+Z16NGB7U23mNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RvmEtmEW; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RvmEtmEW"
Date: Thu, 22 Aug 2024 06:31:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724308285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v9L+ux6eqpfs8HzsN5Mc/twSCks2uxys4IF0TgSNQbs=;
	b=RvmEtmEWo3qrdEPjK0SFllLxQkoGLfOYCr3K1MEV0ZjxRzgIURV9s1vbQoXCQJzDJ1duMt
	sSnffekuUeXRsaafxh/3HzZC0+r2s17FUjz0UodRzfKAXUVtENu164VbYiWAHZC+1BK+aB
	gY/zvvLXMOInTeVNdfCWhKgDTpTgrOY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 03/16] KVM: arm64: nv: Handle shadow stage 2 page
 faults
Message-ID: <ZsbbNNPEjUq1ndt5@linux.dev>
References: <20240614144552.2773592-1-maz@kernel.org>
 <20240614144552.2773592-4-maz@kernel.org>
 <9ba30187-6630-02e6-d755-7d1b39118a32@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ba30187-6630-02e6-d755-7d1b39118a32@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 22, 2024 at 03:11:16AM +0800, Zenghui Yu wrote:
> > +
> > +	if (nested) {
> > +		unsigned long max_map_size;
> > +
> > +		max_map_size = force_pte ? PAGE_SIZE : PUD_SIZE;
> > +
> > +		ipa = kvm_s2_trans_output(nested);
> > +
> > +		/*
> > +		 * If we're about to create a shadow stage 2 entry, then we
> > +		 * can only create a block mapping if the guest stage 2 page
> > +		 * table uses at least as big a mapping.
> > +		 */
> > +		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> > +
> > +		/*
> > +		 * Be careful that if the mapping size falls between
> > +		 * two host sizes, take the smallest of the two.
> > +		 */
> > +		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
> > +			max_map_size = PMD_SIZE;
> > +		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
> > +			max_map_size = PAGE_SIZE;
> > +
> > +		force_pte = (max_map_size == PAGE_SIZE);
> > +		vma_pagesize = min(vma_pagesize, (long)max_map_size);
> > +	}
> > +
> >  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
> >  		fault_ipa &= ~(vma_pagesize - 1);
> >  
> > -	gfn = fault_ipa >> PAGE_SHIFT;
> > +	gfn = ipa >> PAGE_SHIFT;
> 
> I had seen a non-nested guest boot failure (with vma_pagesize ==
> PUD_SIZE) and bisection led me here.
> 
> Is it intentional to ignore the fault_ipa adjustment when calculating
> gfn if the guest memory is backed by hugetlbfs? This looks broken for
> the non-nested case.
> 
> But since I haven't looked at user_mem_abort() for a long time, I'm not
> sure if I'd missed something...

Nope, you're spot on as usual.

Seems like we'd want to make sure both the canonical IPA and fault IPA
are hugepage-aligned to get the right PFN and map it at the right place.

I repro'ed the boot failure, the following diff gets me back in
business. I was _just_ about to send the second batch of fixes, but this
is a rather smelly one.

Unless someone screams, this is getting stuffed on top.

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..a509b63bd4dd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1540,8 +1540,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_pagesize = min(vma_pagesize, (long)max_map_size);
 	}
 
-	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
+	/*
+	 * Both the canonical IPA and fault IPA must be hugepage-aligned to
+	 * ensure we find the right PFN and lay down the mapping in the right
+	 * place.
+	 */
+	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
 		fault_ipa &= ~(vma_pagesize - 1);
+		ipa &= ~(vma_pagesize - 1);
+	}
 
 	gfn = ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);


-- 
Thanks,
Oliver

Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D98D13C9AF
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 16:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711469687; cv=none; b=UcuzjG0vX9PNghwBfZBMOjlxX3Xn7QNvxV6goblz2XFzCmJp0doXXUA9mbIcZu9dpgzxFtGdH+mCbuft0FSg+31hjVJM7AuDbhjeYwJD/OdIpnnLZ5d+DULblQk5HY8JuvzxWdHBw2VwyNhCesjswHUqm0kIEWIc1KffFgUmiQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711469687; c=relaxed/simple;
	bh=O6S5vwbEdVBs596oYk5X3JTDbM7JCZbQYVoIaXWtgJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cM+Ixicv7eSeZUXnm+NZlg/BZeXSoiH3drd8JmGQjbfwEPfl6hklKDxsk9kX8rGkRvSulRIit5bHjLlkURoi8hijEjHx/9RSFhrX17HtH1q8WA0BF2ADtEwyBWw1A/YTwT5QJUQz8pK2baPOls9fMRkqjx49XCDGa61c5+9SONQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iWnrPWx3; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iWnrPWx3"
Date: Tue, 26 Mar 2024 09:14:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711469682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jgz8XF65rx2wCQTQJxyux8jph07RNruismoLWNzkc6M=;
	b=iWnrPWx3pYF6YI2TY3PLb9vcrVcxXjPA7Xp4lbj+tSngz7p/wYyMamSRzzmzTOemQ9rgfg
	VS70C08N6gNAKc9BWW2gNHenkx71ArDFgTAH1Ifbixwm0o6eMgN+R794ZHWXRlbNSuaQzr
	AlrDolUZQpHPf5Ejqk3uv8LIIxOSyoo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't defer TLB invalidation when
 zapping table entries
Message-ID: <ZgL0ae7AffPUw4CS@linux.dev>
References: <20240325185158.8565-1-will@kernel.org>
 <20240325185158.8565-2-will@kernel.org>
 <ZgKIides0YAA2j5Y@linux.dev>
 <ZgLcP9TfMwhfbnEK@linux.dev>
 <20240326161000.GA9723@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326161000.GA9723@willie-the-truck>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 26, 2024 at 04:10:01PM +0000, Will Deacon wrote:
> > @@ -1163,7 +1168,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >  					       kvm_granule_size(ctx->level));
> >  
> >  	if (childp)
> > -		mm_ops->put_page(childp);
> > +		mm_ops->free_unlinked_table(childp, ctx->level);
> 
> Hmm, but doesn't the deferred TLBI still happen after the RCU critical
> section?

Right... We'd need to change that too :) Although I suppose table
invalidations are relatively infrequent when compared to leaf
invalidations.

> I also think I found another bug, so I'll send a v2 with an extra patch...

And I'm sure there's plenty more to be found too, heh.

-- 
Thanks,
Oliver

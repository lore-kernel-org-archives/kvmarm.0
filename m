Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285265FBBD
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 17:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707844241; cv=none; b=bCBJh71a67PnnUvPIbW91MCPrHH+Jm94N/W0TSnmea8IQx4Qrrzjs4aN/fC3koLnklj2EY1w8AqPJaMuNUlIENW9y6WmwJ8dEBa7QtLnN9MceEZh83h+pJ3ZkHYQBz//fnl+phhWlC6AFOK3uBbKjoydOqewn6+X/7YsToJpvrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707844241; c=relaxed/simple;
	bh=7jyPvAGQvkF5KRYVMFV8tgRFEjX4+bvU+GD9z15uSQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+Ke+QBc0a8cIA8F/ufKLAXs+eThPsFIfa3D132+eCySXV81OLfLSuRy+Q5KBTXS33DUf2eP0uOp5amx+9Ynn9Gob6m2CWjskrHBVeUpQ/+IO2CQdRUvwS8kAbaX180ncfRDrcEIea1yvqqSJfFNlVJfOS8WbvMBJGTLgOR7jF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pSy1UV+l; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pSy1UV+l"
Date: Tue, 13 Feb 2024 17:10:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707844237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XY+IFiGgHmCeoZd/AEfpX4a3LV5h8HfarWWWxCHWdMw=;
	b=pSy1UV+lUx8nXsiVimgjdtfBP9tXfN5OBdGUJVJ0i/FeU/0/+KkWuHcwJEhXxFvakfaq7U
	a3h+psZeEeZcRpXELh0tU+MNZmimtkdImBoUpExbCKGUDxnm+gynK0YxqGdmzBGNbI/yD5
	niqgaKB2KlZFrMEr1kLiySYvt1gVcWQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, gshan@redhat.com, james.morse@arm.com,
	mark.rutland@arm.com, maz@kernel.org, rananta@google.com,
	ricarkol@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com,
	vdonnefort@google.com
Subject: Re: [PATCH v5 4/4] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <ZcuihokcWA3q-pZS@linux.dev>
References: <20240207144832.1017815-2-sebastianene@google.com>
 <20240207144832.1017815-6-sebastianene@google.com>
 <Zcq7AoII8qLWwjsu@linux.dev>
 <Zcuf1ZUvwhxBobuG@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zcuf1ZUvwhxBobuG@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 13, 2024 at 04:59:01PM +0000, Sebastian Ene wrote:
> On Tue, Feb 13, 2024 at 12:42:42AM +0000, Oliver Upton wrote:
> > On Wed, Feb 07, 2024 at 02:48:33PM +0000, Sebastian Ene wrote:

[...]

> > > +
> > > +	snprintf(marker_msg, MARKER_MSG_LEN, "IPA bits %2u start lvl %1d",
> > > +		 pgtable->ia_bits, pgtable->start_level);
> > > +
> > > +	ipa_addr_marker[0].name = marker_msg;
> > 
> > Is the dynamic name worth the added complexity? I see nothing wrong with
> > exposing additional debugfs files for simple attributes like the IPA
> > range and page table levels.
> > 
> > I know it isn't *that* much, just looking for every opportunity to
> > simplify further.
> > 
> 
> We can keep them separate, I have no strong opinion about this. I think
> this was Vincent's, original suggestion to have them so I will check with
> him as well.

Well, if we get to the place where there's a single struct containing
all of the required data upfront then this becomes less of an issue.
This is useful information still, so let's see if we can go about it the
other way.

> > > +	ret = kvm_ptdump_parser_init(&parser_state, mmu->pgt, m);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > 
> > Can this be done at open(), or am I missing something?
> > 
> 
> I guess we can do this in open() but then we will have to add again that
> struct that wraps some ptdump specific state tracking. It seemed a bit cleaner in
> this way. What do you think ?

Allocating something that looks like an iterator end embedding it in
->private isn't too uncommon.

> > >  	write_lock(&guest_kvm->mmu_lock);
> > >  	ret = kvm_ptdump_show_common(m, mmu->pgt, &parser_state);
> > >  	write_unlock(&guest_kvm->mmu_lock);
> > >  
> > > +	kvm_ptdump_parser_teardown(&parser_state);
> > 
> > Same question here, can this happen at close()? I guess you'll need a
> > struct to encapsulate pg_state and a pointer to the VM at least.
> >
> 
> Right, I tried to avoid using a separate struct as we discussed in v4.

Sorry, I hope I didn't confuse you in my prior feedback.

What I had issue with was the multiple layers of function ptr / ops
structs for managing the file interface. I have zero concerns with
organizing the _data_ for the walk this way.

> > Actually, come to think of it, if you embed all of the data you need for
> > the walker into a structure you can just do a single allocation for it
> > upfront.

-- 
Thanks,
Oliver

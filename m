Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1C079B81
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 18:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709143687; cv=none; b=HWC9BMEnFWHjzlBDEp09H789Lsk0rbcYoOFsc85z8c5CGaguwBfDRCb8cS7LwPlOTpLcCQAKHy63qCJ4oF1n9ejtcUNxpQZJZsEGO6b89fTZy+MwcHlqwOuGSO5KW7+A+Mt9ISxAKdXUpdurd5+9QOAYOhhhnSAblskezFFMZYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709143687; c=relaxed/simple;
	bh=08G8VN0uzmV56yjMHo0iPxz/zkgkVPCJ9NHkoJphQNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZu8nq1OTIJEjSv25YnbPTvkRcPHsBEt0FcNuR8VW+gLpNna7bTBMMoWH3x1BPfOThkqLJ7eaEBBk3HGjopYg9wj49aVi6RutUtEnAknCFeTdSesG03vQxii/LZB67sm0OP/iJW/3gwmLBpU6Xh2ZQ4u9VKbV4Ndsplqusv7I+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TuyvF59I; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TuyvF59I"
Date: Wed, 28 Feb 2024 18:07:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709143683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1JCZDXl5Ga9ytKJXVUY0cigKZsgRNprFbnl8ggkmc7E=;
	b=TuyvF59IuLAJy568PYp2jn2Bmg+jGuMeP2HsLs49JAte4BlDnOhlvgSQ3O1KC4ocN73jhs
	Rsy73+b0lum+zEjhZIpVrYiYtndf8GxDS08d8d8owJd8/7BigTxxDhE97rN3VwsUNQv8W+
	KJmeb/UIHa673Ai1LvmIhydRW8DJGbk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/20] KVM: Treat the device list as an rculist
Message-ID: <Zd92fobEy4HFOb24@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
 <20240227224249.2209194-2-oliver.upton@linux.dev>
 <Zd9q5KbkLnh5Wddf@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9q5KbkLnh5Wddf@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 28, 2024 at 09:18:28AM -0800, Sean Christopherson wrote:
> On Tue, Feb 27, 2024, Oliver Upton wrote:
> > A subsequent change to KVM/arm64 will necessitate walking the device
> > list outside of the kvm->lock. Prepare by converting to an rculist.
> > Note that this has zero effect the destruction path, as every reader
> > should be protected by a valid reference on the KVM struct.
> 
> This should leave the destruction path alone then.  Simply using list_del_rcu()
> doesn't convert this to an rculist, you need to actually synchronize against RCU
> for this to have any meaning/protection.

Did anything about this diff give you the impression this wasn't
thoroughly understood?

> The above alludes to this, and the
> comment in kvm_destroy_devices() helps a little, but the code itself is actively
> misleading.

Which is what comments are for. I deliberately chose to use a consistent
programming model (albeit unnecessary to anyone who actually understands
how this works) with the hope that _if_ someone comes along and needs to
delete from the list later on they consider the requirements of RCU
protection.

list_del() or list_del_rcu() will fail in an equally-miserable manner if
the previously stated expectation of readers is violated. Poisoning the
forward pointer would be nice from a debugging POV, but readers could
still hit a use-after-free.

> I don't know how I feel about using list_add_rcu() in combination with list_del(),
> but I like it a lot better than using list_del_rcu() in a way that is blatantly
> wrong.
> 
> So if we don't have a better option, I would much rather do only the list_add_rcu(),
> and add a comment _there_ explaining why KVM inserts with RCU protection, but
> frees using regular ol' list_del().

Describing our destruction rules on the insertion path? I feel like that
borders on contempt for the reader. I'm happy to leave list_del() as-is
but I'm going to insist on documenting destructor behavior in the
destructor.

-- 
Thanks,
Oliver

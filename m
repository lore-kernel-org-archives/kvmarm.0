Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963261350EF
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 18:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713291594; cv=none; b=YvfPtYLzsf8rWLCUiAP2oDeZhQlYAVLAPX2XENoPB1BbMScRQt6NngXGWKapdqOrEU18rrSmYmMeKfSYgoxDzgBj6kk9cvYw0qPohbfZZUx46zTxPc2ufHN6pd4GVxGa1zdG11n42Okg/eEzYoxyKL4yP/uyd4bEH9h6e34Ctjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713291594; c=relaxed/simple;
	bh=GrAiJCsxxog1x1TSPI1zLOqAYrtTVgW0lLgoz8AKE5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zju5xYdzFLaKWrWH5wC1zeO2shmRmvUYMFSEzxmZKMWbN1o5hxIcwOoN6xJpti23ZvvJoXsPz6xGiwag3nPxJWB5bYcszEa45VE+0kVyMrijbnTf6zO9eI7SzGg4B67CGvd+9U9ZxQvHdfh1ORI8IW38ZLHgitjRSnzQFDBeTBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iT/aIYCf; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iT/aIYCf"
Date: Tue, 16 Apr 2024 18:19:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713291590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BsgRH5Qf+AKILWbGiz0BXoD1RS7OwULP0bAtuppbTFU=;
	b=iT/aIYCfAd5OfxAySQhsQIBNjVKtEwBjWiyykIPV/+o3oRNVtqTI4NF9PD4wbtLO9gpBWD
	CqlZic7rwYaPSNjteYJEMfMyVU8Pt0AC/ab2niZe3dT+nRmqUo52AFjJWoXIIwB+TQDU81
	2WGmm211m5wLdYvGWheMYXChfHuGbNE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v2 09/47] KVM: arm64: Avoid BBM when changing only s/w
 bits in Stage-2 PTE
Message-ID: <Zh7BQE54GSP19zQQ@linux.dev>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-10-tabba@google.com>
 <Zh6ujO8qbVviKlEk@linux.dev>
 <CA+EHjTz6WZD7VYie1CTnv8F4CAzk+uVJA6hrt4oF0evhHFdwvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTz6WZD7VYie1CTnv8F4CAzk+uVJA6hrt4oF0evhHFdwvQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 16, 2024 at 07:06:37PM +0100, Fuad Tabba wrote:
> > > +     /* If we're only changing software bits, then store them and go! */
> > > +     if (!kvm_pgtable_walk_shared(ctx) &&
> > > +         !((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW)) {
> > > +             bool old_is_counted = stage2_pte_is_counted(ctx->old);
> > > +
> > > +             if (old_is_counted != stage2_pte_is_counted(new)) {
> > > +                     if (old_is_counted)
> > > +                             mm_ops->put_page(ctx->ptep);
> > > +                     else
> > > +                             mm_ops->get_page(ctx->ptep);
> > > +             }
> > > +             WRITE_ONCE(*ctx->ptep, new);
> >
> > IIUC, you're using a naked WRITE_ONCE() to avoid a error path that
> > cleans up the reference count. That's fine, but can you change this to a
> > WARN_ON_ONCE(stage2_try_set_pte())? Should this ever be changed to
> > become a shared walk w/o gracefully handling a cleanup here I'd hope the
> > warning would catch someone's attention.
> 
> I think you mean WARN_ON_ONCE(!stage2_try_set_pte(...)).

Oops :) Yeah, that.

> I can do that, but for now, warnings in protected mode are fatal. Should I do
> that anyway?

I think so. It'd express the expectations of the walk and could avoid
*silently* making this PTE write racy / prone to failure.

-- 
Thanks,
Oliver

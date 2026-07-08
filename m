Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D2C3DFC8C
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 07:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783496144; cv=none; b=H2/5JF3jzRhQh0836wFZGrVpBVzx6vH6rglYU8DsV9+4EPdBXjjgbe02wljYvF+B/v66DPUJmN6X+CI4xXrzAdkm4sndPzlRj2zVoZj9iOihaIMp2l8W7lNSZ4CB2+Jlkk9N+rSd/IQkwbP8FpjXMw9PxT9CmMegABhUpCebxHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783496144; c=relaxed/simple;
	bh=St2sZCr9NHAgjv5yTPGfEIfeyGCZIJL/tRgDlrGh+tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i7aWgtyRBfyIR3NNAe/qHt7Ie+++1NITRP029yW+HTKpzbbDEnygFLtsdnWsoXYcCIC2Ms0BvQZDftN44JR4rd8rEtCvxhxIY4kVr6wQNIdtJJH97beAokiPKUVcogXjCqMJbVEA9P9y9zZOCPkqj7/R4Faowv8EvZ+ZrmhuRtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLsqRk2V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLsqRk2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451071F000E9;
	Wed,  8 Jul 2026 07:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783496131;
	bh=Pd+pzOlXDML+Uj4/IA83ZRyXHr2Fo3zY9NZKouptYuE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oLsqRk2VYjH2qYusNx394n+tuCIg4dkiZG1tC+M/c3trd/UOyYLZR4VgRemcGhK+l
	 H91Fh7LbCAtXIZv6beLlj4a1j6YKLUUawRrZAkZTBrlxZvS1hORigckLfM+CWTNoEX
	 awEbBBqmOsIV4NNsbL0GeunTZBhvbJ0FRHF6j1ie/n5+pP7UhY/Zlr8hDhSIOjEixf
	 PjfYR6oGBk58t5MRRmiD+NIGUcBpK2KBoMyZNZvpXg3dX5fY3XLyCBBIOtxICov93v
	 gzC6YOghXtCwfWJATSotCMgCs9jehdwRwkwAts2iQSlUfJ8fxYNY/NXp02fNxvPYoi
	 qDoR2LRvUoWfg==
Date: Wed, 8 Jul 2026 00:35:30 -0700
From: Oliver Upton <oupton@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 07/22] KVM: arm64: nv: Set dirty state at stage-2
Message-ID: <ak39whrJvABuX-um@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-8-oupton@kernel.org>
 <bnjj67ht3pepmu4hd6jztiymzkkna57atvjr6eec25otuac3jc@jmgtpj4im3ew>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bnjj67ht3pepmu4hd6jztiymzkkna57atvjr6eec25otuac3jc@jmgtpj4im3ew>

On Mon, Jul 06, 2026 at 05:50:14PM +0100, Wei-Lin Chang wrote:
> Hi Oliver,
> 
> On Tue, Jun 23, 2026 at 11:41:46AM -0700, Oliver Upton wrote:
> > Set the dirty state on descriptors at stage-2 for write accesses when
> > DBM is set.
> > 
> > Signed-off-by: Oliver Upton <oupton@kernel.org>
> > ---
> >  arch/arm64/kvm/nested.c | 43 +++++++++++++++++++++++++++++++----------
> >  1 file changed, 33 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index a70af3b3f05d..e5a407fc0880 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -132,6 +132,7 @@ struct s2_walk_info {
> >  	unsigned int	t0sz;
> >  	bool		be;
> >  	bool		ha;
> > +	bool		hd;
> >  };
> >  
> >  struct s2_walk_step {
> > @@ -227,6 +228,20 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
> >  	return 0;
> >  }
> >  
> > +static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
> > +				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
> > +{
> > +	switch (access->type) {
> > +	/* R_RKMHW */
> 
> Just saying that I found that R_RKMHW is not about this behavior anymore
> in the latest M.c Arm ARM. This is covered by R_ZYGHJ now.

Thanks for the callout! What good are the rules if the citations change
over revisions :-/ Although in this case the language was indeed
updated.

Will fix it in v2.

Thanks,
Oliver

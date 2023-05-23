Received: from out-17.mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FA61D2D8
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 08:07:35 +0000 (UTC)
Date: Tue, 23 May 2023 08:07:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684829253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=egNMb28a15n4c3sHtWFH9e+9zVJTUhwvGv6/Dco47WE=;
	b=saPb0XldYatkwDqqep6/PG2P9zPGV8HqRVGhrRMWRInadXayojG4/sWDT3d+U3dQSTyyUq
	2vphfGG6B1wtJDsblgTU36ue4Jcse6mh1WSlolG+rLn7ieiPRlFqvq2W0sB+82hVyNjYHD
	Ml6RrumyXANgSM9DS+rH6XYq89281wE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Quentin Perret <qperret@google.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	kernel-team@android.com, Andrew Walbran <qwandor@google.com>
Subject: Re: [PATCH v2 01/10] KVM: arm64: Block unsafe FF-A calls from the
 host
Message-ID: <ZGx0QBZzFCmm636r@linux.dev>
References: <20230419122051.1341-1-will@kernel.org>
 <20230419122051.1341-2-will@kernel.org>
 <ZFvrkQ8Nt6AUZwrt@linux.dev>
 <20230522112220.GA5965@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522112220.GA5965@willie-the-truck>
X-Migadu-Flow: FLOW_OUT

On Mon, May 22, 2023 at 12:22:20PM +0100, Will Deacon wrote:
> Hi Oliver,
> 
> On Wed, May 10, 2023 at 07:08:01PM +0000, Oliver Upton wrote:
> > On Wed, Apr 19, 2023 at 01:20:42PM +0100, Will Deacon wrote:
> > > +/*
> > > + * Is a given FFA function supported, either by forwarding on directly
> > > + * or by handling at EL2?
> > > + */
> > > +static bool ffa_call_supported(u64 func_id)
> > > +{
> > > +	switch (func_id) {
> > > +	/* Unsupported memory management calls */
> > > +	case FFA_FN64_MEM_RETRIEVE_REQ:
> > > +	case FFA_MEM_RETRIEVE_RESP:
> > > +	case FFA_MEM_RELINQUISH:
> > > +	case FFA_MEM_OP_PAUSE:
> > > +	case FFA_MEM_OP_RESUME:
> > > +	case FFA_MEM_FRAG_RX:
> > > +	case FFA_FN64_MEM_DONATE:
> > > +	/* Indirect message passing via RX/TX buffers */
> > > +	case FFA_MSG_SEND:
> > > +	case FFA_MSG_POLL:
> > > +	case FFA_MSG_WAIT:
> > > +	/* 32-bit variants of 64-bit calls */
> > > +	case FFA_MSG_SEND_DIRECT_REQ:
> > > +	case FFA_MSG_SEND_DIRECT_RESP:
> > > +	case FFA_RXTX_MAP:
> > > +	case FFA_MEM_DONATE:
> > > +	case FFA_MEM_RETRIEVE_REQ:
> > > +	/* Don't advertise any features just yet */
> > > +	case FFA_FEATURES:
> > > +		return false;
> > > +	}
> > > +
> > > +	return true;
> > > +}
> > 
> > Apologies for rehashing something we dicussed in v1...
> > 
> > Enforcing the pKVM policy as a denylist rather than an allowlist
> > deserves a bit more elaboration, at least in the form of a comment. I
> > understand that we must trust EL3 by construction, but it is fuzzy why
> > it gets extended to what EL1 might do with FF-A calls that are unknown
> > to pKVM.
> 
> Sure thing, I'll add a comment for the next version.
> 
> > Broadening the scope for a moment, is my understanding correct that
> > limiting 'unknown' SMCs from host EL1 are an explicit non-goal of pKVM's
> > security model? Assuming a well-intentioned EL3, I'm just a bit worried
> > about any vendor-specific junkware that could be used by a malicious
> > EL1.
> 
> It's a valid concern, but the sad reality is that every shipping Android
> device makes use of 'unknown' SMCs and if we reject them at EL2 then the
> device won't function properly and we've shot ourselves in the foot.
> 
> So we basically have two options:
> 
>   (1) Add per-device logic to EL2 which knows how to introspect the
>       'unknown' SMCs and filter out bad requests from EL1
> 
>   (2) Let them through by default, intercepting standard requests such
>       as PSCI and FF-A at EL2 and rely on the firmware not to expose
>       non-standard memory sharing calls
> 
> We have patches in Android to support modules loading code into EL2,
> which makes option (1) practical, but without that support upstream, (2)
> is the best we can do for now.

Thanks, and fully understand what led to the policy you folks have
implemented. Perhaps in the future we can add an optional, restrictive
model to satisfy users that have a more adversarial relationship with
firmware interfaces. Not worth addressing in this series, though.

Going forwared, can the goals/non-goals of the current pKVM design be
captured somewhere in documentation? I think this can be done
organically as more bits and pieces are upstreamed, but it'd help
reviewers who haven't spent time in the trenches with pKVM to at least
grasp the intent. At least personally, I really like to see the pKVM
stuff landing upstream but haven't had first-hand experience with the
horrors of client devices :)

-- 
Thanks,
Oliver

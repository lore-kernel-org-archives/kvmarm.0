Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544EF257D
	for <kvmarm@lists.linux.dev>; Tue, 18 Apr 2023 12:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CABC433EF;
	Tue, 18 Apr 2023 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681822141;
	bh=YV4Tu2pMz6RUI8MFZPIRH6+lOG73N5CxyhXAeBGXkgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h9Bi+yS/xpqkWIB/6mosBYwBvM24/vYU9VaWAz1BMJXQmvKrTAyp6h36dAvgEVTVQ
	 oxvhM7e16LQ/GQpfUpnHMKzYErShLhAJ4kwXVv6/ZKXX8juA4GV7G7N8xZ8kFltlzg
	 9Thf97cu7qsz5XdAcAUJCEaeH6m8XOm/7axHmk+E2mbIsgn6VANEkHgy4QxUcC/+Mp
	 OmwPPqJTIIdiSyQbq2Pfg+nb37xEN8bexVMPkhr5gIiD23Ur8JTVznVdMXFcvA+Rlk
	 kJUQ7ekSN4yrix6yTaeRTKPNIoEnu42YO6EPWy7uXl9WTmMd2GUyEiDAa7cax7PfEl
	 W/Rj3NYqeIOdw==
Date: Tue, 18 Apr 2023 13:48:54 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Quentin Perret <qperret@google.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Andrew Walbran <qwandor@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH 03/12] KVM: arm64: Block unsafe FF-A calls from the host
Message-ID: <20230418124853.GB32435@willie-the-truck>
References: <20221116170335.2341003-1-qperret@google.com>
 <20221116170335.2341003-4-qperret@google.com>
 <Y3Uiemx6YQxoZWhh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Uiemx6YQxoZWhh@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 16, 2022 at 05:48:42PM +0000, Oliver Upton wrote:
> Sorry, hit send a bit too early. Reviewing the patch itself:
> 
> On Wed, Nov 16, 2022 at 05:03:26PM +0000, Quentin Perret wrote:
> 
> [...]
> 
> > +static bool ffa_call_unsupported(u64 func_id)
> > +{
> > +	switch (func_id) {
> > +	/* Unsupported memory management calls */
> > +	case FFA_FN64_MEM_RETRIEVE_REQ:
> > +	case FFA_MEM_RETRIEVE_RESP:
> > +	case FFA_MEM_RELINQUISH:
> > +	case FFA_MEM_OP_PAUSE:
> > +	case FFA_MEM_OP_RESUME:
> > +	case FFA_MEM_FRAG_RX:
> > +	case FFA_FN64_MEM_DONATE:
> > +	/* Indirect message passing via RX/TX buffers */
> > +	case FFA_MSG_SEND:
> > +	case FFA_MSG_POLL:
> > +	case FFA_MSG_WAIT:
> > +	/* 32-bit variants of 64-bit calls */
> > +	case FFA_MSG_SEND_DIRECT_REQ:
> > +	case FFA_MSG_SEND_DIRECT_RESP:
> > +	case FFA_RXTX_MAP:
> > +	case FFA_MEM_DONATE:
> > +	case FFA_MEM_RETRIEVE_REQ:
> > +		return true;
> > +	}
> > +
> > +	return false;
> > +}
> 
> Wouldn't an allowlist behave better in this case? While unlikely, you
> wouldn't want EL3 implementing some FFA_BACKDOOR_PVM SMC that falls
> outside of the denylist and is passed through.

Given that we're not intercepting all SMCs (rather, only those in the
FF-A service range), I think the denylist works much better because the
default action is "allow". We _have_ to trust EL3 regardless, as it
could just use any allowed SMC for a backdoor if it wanted. Ultimately,
EL3 runs the show in the hierarchical security model of the architecture
and we sadly can't do much about that.

> > +bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	DECLARE_REG(u64, func_id, host_ctxt, 0);
> > +	struct arm_smccc_res res;
> > +
> > +	if (!is_ffa_call(func_id))
> > +		return false;
> > +
> > +	switch (func_id) {
> > +	/* Memory management */
> > +	case FFA_FN64_RXTX_MAP:
> > +	case FFA_RXTX_UNMAP:
> > +	case FFA_MEM_SHARE:
> > +	case FFA_FN64_MEM_SHARE:
> > +	case FFA_MEM_LEND:
> > +	case FFA_FN64_MEM_LEND:
> > +	case FFA_MEM_RECLAIM:
> > +	case FFA_MEM_FRAG_TX:
> > +		break;
> > +	}
> 
> What is the purpose of this switch?

As of this patch, it's not serving any functional purpose. The idea is
that later patches hook in here to provide handling at EL2. I'll remove
it and introduce it bit by bit.

> 
> > +
> > +	if (!ffa_call_unsupported(func_id))
> > +		return false; /* Pass through */
> 
> Another (tiny) benefit of implementing an allowlist is that it avoids
> the use of double-negative logic like this.

I should just rework this to be ffa_call_supported().

Will

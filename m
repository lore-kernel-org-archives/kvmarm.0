Received: from out-29.mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8836C14A81
	for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 19:08:08 +0000 (UTC)
Date: Wed, 10 May 2023 19:08:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1683745686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0dBVt6HfXNNNxtzBb73OxbUykHsM6i8DCnD09j7J8ZE=;
	b=bUr4B8rAtxaqr/EurRvC2NgIQcYisp6yrU6DmX2Up/R9cvYU7YuSdySNy4sfs5Agk7PFZx
	UMj7YspWIuFk5PpgQMuUjrJO3HsdaLrteG3sdXzuMeYeJWcMaFqigLAWMc713GaUP0GZE0
	pLUSD4hfXIVedjJTPuY1Zl0WcUEIg9E=
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
Message-ID: <ZFvrkQ8Nt6AUZwrt@linux.dev>
References: <20230419122051.1341-1-will@kernel.org>
 <20230419122051.1341-2-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419122051.1341-2-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi Will,

On Wed, Apr 19, 2023 at 01:20:42PM +0100, Will Deacon wrote:

[...]

> +/*
> + * Is a given FFA function supported, either by forwarding on directly
> + * or by handling at EL2?
> + */
> +static bool ffa_call_supported(u64 func_id)
> +{
> +	switch (func_id) {
> +	/* Unsupported memory management calls */
> +	case FFA_FN64_MEM_RETRIEVE_REQ:
> +	case FFA_MEM_RETRIEVE_RESP:
> +	case FFA_MEM_RELINQUISH:
> +	case FFA_MEM_OP_PAUSE:
> +	case FFA_MEM_OP_RESUME:
> +	case FFA_MEM_FRAG_RX:
> +	case FFA_FN64_MEM_DONATE:
> +	/* Indirect message passing via RX/TX buffers */
> +	case FFA_MSG_SEND:
> +	case FFA_MSG_POLL:
> +	case FFA_MSG_WAIT:
> +	/* 32-bit variants of 64-bit calls */
> +	case FFA_MSG_SEND_DIRECT_REQ:
> +	case FFA_MSG_SEND_DIRECT_RESP:
> +	case FFA_RXTX_MAP:
> +	case FFA_MEM_DONATE:
> +	case FFA_MEM_RETRIEVE_REQ:
> +	/* Don't advertise any features just yet */
> +	case FFA_FEATURES:
> +		return false;
> +	}
> +
> +	return true;
> +}

Apologies for rehashing something we dicussed in v1...

Enforcing the pKVM policy as a denylist rather than an allowlist
deserves a bit more elaboration, at least in the form of a comment. I
understand that we must trust EL3 by construction, but it is fuzzy why
it gets extended to what EL1 might do with FF-A calls that are unknown
to pKVM.

Broadening the scope for a moment, is my understanding correct that
limiting 'unknown' SMCs from host EL1 are an explicit non-goal of pKVM's
security model? Assuming a well-intentioned EL3, I'm just a bit worried
about any vendor-specific junkware that could be used by a malicious
EL1.

-- 
Thanks,
Oliver

Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EB17F
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 08:14:24 +0000 (UTC)
Date: Wed, 16 Nov 2022 08:14:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668586463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SmFKdEdkwEAGGvbba+Uew4TFmYCA4I8/v/XU6v8w0iw=;
	b=EiQC3QrF9TRB/NYfKenXrf+k5M2yFh3QICvTBjAHp2S2AgBjJTR7+0EESbrJW9MZnTM2ku
	HalxstlcPjFrhMFiUG6PeC1w/Rn21yzoE6U8m4RxGK2nKHc8gl9WjePXjwLsyGfzBN/HBd
	WcAO9UckNtb5AMRTHW2N9kDIujgjrjQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] KVM: arm64: Don't acquire RCU read lock for exclusive
 table walks
Message-ID: <Y3Sb20U9rCIuOU3L@google.com>
References: <20221115225502.2240227-1-oliver.upton@linux.dev>
 <868rkbppdq.wl-maz@kernel.org>
 <Y3SQ3wogsVUEu1Qe@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3SQ3wogsVUEu1Qe@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221116081419.5_wOk5f4DF6xdklzPWtJH4c8Zh8dK0OMHGot6d-QDJk@z>

On Wed, Nov 16, 2022 at 07:27:27AM +0000, Oliver Upton wrote:
> On Wed, Nov 16, 2022 at 03:08:49AM +0000, Marc Zyngier wrote:
> > I'm not crazy about this sort of parameters. I think it would make a
> > lot more sense to pass a pointer to the walker structure and do the
> > flag check inside the helper.
> > 
> > That way, we avoid extra churn if/when we need extra state or
> > bookkeeping around the walk.
> 
> Sure, let's go that way instead. v3 on the way lol :)

Well, going this route is going to require hoisting around a few things.

I'd very much prefer to keep the RCU indirection ifdeffery all in one
place, but I'll need to haul it all after the definitions of kvm_pgtable_walker
and kvm_pgtable_walk_flags but before the definition of kvm_pgtable
(as it needs kvm_pteref_t).

I'm not too bothered by it, but not quite as small of a bandaid this
time around.

--
Thanks,
Oliver

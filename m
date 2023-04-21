Received: from out-21.mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6B92561
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 09:29:29 +0000 (UTC)
Date: Fri, 21 Apr 2023 09:29:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1682069367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oVJEzgVGs/3tfkvVogD4TherS/SH1tpYe53B4oUtuMw=;
	b=hP4f7ImFlEbsDriVplD85wtWwZGBmQPqCDU2bb+Ek2pljaU6vWsk2Oec6KfJU9BJ9EelXa
	Bb4jr6AjJpB/EixKEbhaGzBbBODZY02Bc4xG9YuWd77cPrpD645/ud8pF44kqrLDNIljPG
	JOww5b0R7o3tS7qt+kF/S1ljv+FaLk4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	David Matlack <dmatlack@google.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix for mapping incorrect PA at stage-2
Message-ID: <ZEJXc5pt3af3j+xv@linux.dev>
References: <20230421071606.1603916-1-oliver.upton@linux.dev>
 <86sfctk38v.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sfctk38v.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Fri, Apr 21, 2023 at 10:12:48AM +0100, Marc Zyngier wrote:

[...]

> > Marc, the bug can have some rather ugly (albeit rare) consequences, so
> > I'd like to get this in ASAP. The door is shut on 6.3, but it'd be nice
> > to squeeze in the 6.4 pull request if possible.
> 
> This is a pretty invasive change, and I'd really like to give it some
> -next exposure. I'm not doubting your testing, but experience shows
> that there is always someone with a more tricky setup...
> 
> What I'd suggest is to not include it in the pull request that I'm
> about to send today, but to let it simmer in -next for a week. This
> will give us some confidence that we're OK, and also avoid being
> shouted at for sending stuff that hasn't been in -next at all.
> 
> If everything checks out after a week, I'll send another PR with this
> fix (and whatever will have landed in the meantime).
> 
> Would that work for you?

Absolutely. I had the delusional thought that there was still time to
soak in -next and sneak in for 6.4. But, would you look at that, it's
already Friday :)

-- 
Thanks,
Oliver

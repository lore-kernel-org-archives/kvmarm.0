Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DD044C7E
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 23:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713829479; cv=none; b=u0nf05KStsg4YeqfkwLjwGXPOqLvy1+29Gdq+p9GduvYI++IwS5yB3LX4aFWD5l9Ns14NaJDUe7NBh+rjGHyyOiJWc35+E5Er3tf0Y87CPazCw7D6NRs4k5zWp7fpGKr6u8pm5HVGloW3StaQA8+lLW/Vh9Fp8KKqKL5q8ZFTnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713829479; c=relaxed/simple;
	bh=yAKjVU0tlRTxf6VdiSzAaFg6I7pqSQy/n0Nei1DEvTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+ZbezQTZNx3VqCXMnzYxWiKJEUM792SK9JD8HBrnjSGsLf7U4xa/Xyrz85v85r7VA7EamU0fqP/U+dJsJXTJ34NIGLI0thrQy5kv1MNwOOP17TQ0EyDEhc4+5vaBTinlNaXhW2Gmy9ewBQDfL5ZQ0uad9JTgXOPmQYUyu/6vag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ps4MK4C+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ps4MK4C+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C744C113CC;
	Mon, 22 Apr 2024 23:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713829479;
	bh=yAKjVU0tlRTxf6VdiSzAaFg6I7pqSQy/n0Nei1DEvTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ps4MK4C+6rReKxDL4HlO7WssOuaOLLy/GKvOSAjbA7sspj19GrAmDn/+1xbNFAKxi
	 uw/3DBxZLd8HyH7ErIBCa+HBuKzwI+dUYIYbBRttqEM0xv3/4QTqTmdvffSWKsCuKQ
	 6zW8Dqwg7VUfVREtha8FHOsxCrwnbnhh50ulE5Sk/eQ9ZgSYxGaqg7ZNaiyzHU9jTi
	 wQmlrzS6PAWXl95EVQF5GgOtxSxXTr/dAk8f+4eWSr5VJ700onCzZX7R3WNN7VfTQw
	 Q81VtyeBJbtEyFarYf7zY8UWgJe2lKUA0fgtRbOiJeXglTDYMlpahPCgHTOeEMPCGh
	 XceY8DQqRtacg==
Date: Tue, 23 Apr 2024 00:44:32 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev, maz@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v3 27/31] KVM: arm64: Use atomic refcount helpers for
 'struct hyp_page::refcount'
Message-ID: <20240422234432.GA6818@willie-the-truck>
References: <20240419075941.4085061-1-tabba@google.com>
 <20240419075941.4085061-28-tabba@google.com>
 <ZiLZehsi1_arusae@linux.dev>
 <CA+EHjTx67TOQKzsLJ_9PP_rYRiYb7j0RuJLzDK8B6jK_SdQMHA@mail.gmail.com>
 <CA+EHjTzc6h719kvP9FJA3xqLnOxr5gPWDq7iYOx7JfQz4Wn61w@mail.gmail.com>
 <ZibMlkG-1MnCiXXF@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZibMlkG-1MnCiXXF@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Oliver,

On Mon, Apr 22, 2024 at 01:46:14PM -0700, Oliver Upton wrote:
> On Mon, Apr 22, 2024 at 02:08:17PM +0100, Fuad Tabba wrote:
> 
> [...]
> 
> > > > Adding a BUG_ON() for taking a reference on a non-refcounted page (i.e.
> > > > p->refcount was 0) would be nice, especially since we're past the point of
> > > > serializing everything and you can theoretically have a zero count page
> > > > outside of the free list.
> > > >
> > > > Seems like otherwise we'd get actually hit the BUG_ON() in an unrelated
> > > > allocation path.
> > 
> > Actually, the refcount can be 0 without it being an error. For
> > example, when hyp pins memory shared with it by the host
> > (mem_protect.c:hyp_pin_shared_mem()).
> 
> Are those not by their very definition non-refcounted pages?

Right, we're using the refcount for two things here: (1) so that the
allocator knows when to return the page to the pool and (2) so that the
hypervisor can transiently prevent a page which has been shared by the
host from being unshared. That second part is needed to e.g. prevent a
page holding a host vCPU structure being donated to a guest as normal
memory and then having the hypervisor write to it as a result of a host
hypercall. We use the refcount for this because the same page can be
shared with the hypervisor multiple times and we need to know when the
last host sharer has dropped its pin.

> I can't imagine we'd want pages in a shared state with the host to ever
> get returned to the hyp allocator. Seems an erroneous hyp_put_page() would
> get you there, though.

Given the dual-use above, I don't think a BUG_ON() on the refcount is
the right fix. Instead, we'd probably want a (cheap) mechanism to
differentiate pages in states (1) and (2). This could be a new flag in
'struct hyp_page' or perhaps we could be creative and set the 'order' to
HYP_NO_ORDER for pinned pages and then have a BUG() to check 'p->order'
against 'pool->max_order' in hyp_put_page().

What do you think?

Will

Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC072248F68
	for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 19:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758916095; cv=none; b=hzTddvifs9PMvnmqK50em95Q7H2iR1jgjr9D3rKD5aesBu+1Zy+Nwzu+yAEd9fb8sdaydCvKaUD3WiJ/UJRU2daxu5lDub8hHdzLHTYi2j3UHARSH4Hq7XCyG7LWbKVCZqPKJM5OToxcc8sj/emshwt37fJF2J2U83xpMj+Zc64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758916095; c=relaxed/simple;
	bh=6FrbGOKqat8jkVXU3JQ1opgIZIMQ5ymbS/3VR9FNa6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n6YJgnrEyL1BTxmlrM3HF9eN0zx7McfNdZd4O9yfCumMywezSYwEUELQ7fEBXkrljBLY02oEome0bs1tPvtSzFBdz5Vjh3kMClv1e6zNpw2eZ4XD6niTT0uFsyWIEO/ZcHAkOo6mKBQJAidOvWP6M/PPhecxjz5LWjtr8bJtIM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=POPEo2iW; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="POPEo2iW"
Date: Fri, 26 Sep 2025 12:48:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758916091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rcCXnVQiTv87c83uMCOhKpmcG132oZ4yEroQZJRE6Vg=;
	b=POPEo2iWzU5R2kWw/ncMdbf9yl2uLwd2e9r5U6pnAGChPPq6PZs1NcZGeRxWAl+8DRN/My
	q3Q95t4QPprtpr0KydCef0v3wVWevF52BW+M5j8NeEsSxLTlOdu5ng5tl2QfEJd8ET60ha
	vj4JjTdWTTwNi9evL0zS3/X82YQ9iMM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Track width of arm64's timer counter as
 "int", not "uint64_t"
Message-ID: <aNbt9NH2iVLPeIDX@linux.dev>
References: <20250926155838.2612205-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926155838.2612205-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 26, 2025 at 08:58:38AM -0700, Sean Christopherson wrote:
> Store the width of arm64's timer counter as an "int", not a "uint64_t".
> ilog2() returns an "int", and more importantly using what is an "unsigned
> long" under the hood makes clang unhappy due to a type mismatch when
> clamping the width to a sane value.
> 
>   arm64/arch_timer_edge_cases.c:1032:10: error: comparison of distinct pointer types
>      ('typeof (width) *' (aka 'unsigned long *') and 'typeof (56) *' (aka 'int *'))
>      [-Werror,-Wcompare-distinct-pointer-types]
>    1032 |         width = clamp(width, 56, 64);
>         |                 ^~~~~~~~~~~~~~~~~~~~
>   tools/include/linux/kernel.h:47:45: note: expanded from macro 'clamp'
>      47 | #define clamp(val, lo, hi)      min((typeof(val))max(val, lo), hi)
>         |                                                  ^~~~~~~~~~~~
>   tools/include/linux/kernel.h:33:17: note: expanded from macro 'max'
>      33 |         (void) (&_max1 == &_max2);              \
>         |                 ~~~~~~ ^  ~~~~~~
>   tools/include/linux/kernel.h:39:9: note: expanded from macro 'min'
>      39 |         typeof(x) _min1 = (x);                  \
>         |                ^
> 
> Fixes: fad4cf944839 ("KVM: arm64: selftests: Determine effective counter width in arch_timer_edge_cases")
> Cc: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

In the absence of a __careless_clamp() :)

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver

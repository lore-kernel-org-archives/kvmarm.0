Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAFB13C8F4
	for <kvmarm@lists.linux.dev>; Fri,  9 Aug 2024 17:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723226267; cv=none; b=hPfB7JcQFS+7BRY/3ayo2Jk1xxWwKlzXZeoJ01UVrfwphBzR446NznKvXRZ6QNo6Gd71YWMWEU5c/+Pa8h465+KUYhpxLZyXP7X4Z+aveJA6qpq9RKetuP4P6d3R2Lh4W/ZzKH++Ywx2PZvvK8cvpx+Lsh+vtj7k/bER3vY+YZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723226267; c=relaxed/simple;
	bh=M3I/44k+uR5m7epeM37cjY4gzbwANuK8YqLBOrSkVB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K0YHTEHmmlyqqnO1CYCuOC/iIClqNKvl0ZARSF+Z018WXjXHi1IjGZldZM+hj+ky02c4KLsG1s8rPCcIdbMMxiA9gjGEYetnh/NVIQfmxukYWr/0y6rALIzzQaDxIYVS6hPLQC/Xx9cV80Up+JLnWlQHr6hp4Wf3z1BLtlX9/ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CpghzWq7; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CpghzWq7"
Date: Fri, 9 Aug 2024 10:57:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723226262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pCB95XDzz6j5az3tqR2K6rgl2D1WFAaOInOOblCkU54=;
	b=CpghzWq79A+GWWU1TpKng7AfD3bm/rGpsuk2q3JE5z3uW9ha06y3bZc3aHJqCUN6/ltP1f
	X6lycKrYMXJHCtCNxVTw+f8WXJw0IpfeNuL0Bm5Cq+voqEYkZZ1tGO4/rD9wWwcMQUKdeq
	44rNXpxK//B4aq16MD25e2IypYB2EF8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, jthoughton@google.com, rananta@google.com
Subject: Re: [PATCH 2/3] KVM: arm64: Declare support for
 KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZrZYkCIK3oW47Suq@linux.dev>
References: <20240802224031.154064-1-amoorthy@google.com>
 <20240802224031.154064-3-amoorthy@google.com>
 <ZrFXcHnhXUcjof1U@linux.dev>
 <CAF7b7mouOmmDsU23r74s-z6JmLWvr2debGRjFgPdXotew_nAfA@mail.gmail.com>
 <ZrJ9DhNol2pUWp2M@linux.dev>
 <ZrOBdBBAQZ55uoZt@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrOBdBBAQZ55uoZt@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 07, 2024 at 07:15:16AM -0700, Sean Christopherson wrote:
> On Tue, Aug 06, 2024, Oliver Upton wrote:
> > This sort of language generally isn't necessary in UAPI descriptions. We
> > cannot exhaustively describe the ways userspace might misuse an
> > interface.
> 
> I don't disagree in general, but I think this one is worth calling out because
> it's easy to screw up and arguably the most likely "failure" scenario.  E.g. KVM
> has had multiple bugs (I can think of four off the top of my head) where a vCPU
> gets stuck because KVM doesn't resolve a fault.  It's not hard to imagine userspace
> doing the same.

Yeah, I don't see any reason to go and rip it out, just a suggestion for
the next time around.

-- 
Thanks,
Oliver

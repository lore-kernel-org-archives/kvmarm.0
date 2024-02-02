Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E81C15E5A0
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 19:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706901467; cv=none; b=fiOYxxbt+dx8UJjIgLMZgc+KwbTswSQNJnyQtBsAQthgZnQ5JaiEJza9BC8Nsx9lsrxwTYn4dTCD6Et2RxWOFwBOD+9yjPkuynQN/5OLt2WH6BGZWb8dpS071cNEkLHLKMFx3/kOJoAXZy6LnH0grnWz/ggxsqC21hBnEWYWEtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706901467; c=relaxed/simple;
	bh=7ubNXw4viBJ2sXirokr2xChMuQxVZzBTxsDi8LromhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYtFITZ0bO0PckFcM3DfYXAkvnuEMEMa0rtR3thsQgfkgciOeBtUxpRQHPyn3G6yY4u3C1XjY12KVEatTHqV6Hb9sjSgEXZa1UKkTUmI3df+IFYqtLIqGySV8JJVPq99imU1V9SQCNC1cA0cL4F2ggdGzTUqArlFkMrYchFRoZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qg1f8Q5p; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qg1f8Q5p"
Date: Fri, 2 Feb 2024 19:17:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706901463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YX/YmSgOL3ZRbb8FDX2ykhx1yGPO/NRhs6QxOJjbMjA=;
	b=Qg1f8Q5piP4sjG5RkM8r0F5ZHUcvMUB56G/tUN5LPFNTr2iIpgAXjGz2uAX9E3sO9OFD0q
	iy6diIEnCbctPWQOnrQf8K/4+EG89W6F+1RFtEeT5rTSDy1I0Wde53tsLOJ4eMW9k0KSEk
	xLml+SmR31VewZZV93BX/ZQ/eGY76dg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 06/25] KVM: arm64: nv: Add sanitising to VNCR-backed
 HCRX_EL2
Message-ID: <Zb0_0fq4E1_L7lC6@linux.dev>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-7-maz@kernel.org>
 <ZbytUKPFYiP2cdd8@linux.dev>
 <86h6iq7w3x.wl-maz@kernel.org>
 <Zb0jRzTYyc0IxR00@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zb0jRzTYyc0IxR00@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 02, 2024 at 05:15:51PM +0000, Oliver Upton wrote:
> On Fri, Feb 02, 2024 at 02:56:50PM +0000, Marc Zyngier wrote:
> > No amount of warnings will do, because people don't give a damn.
> > 
> > I'm actually in favour of something far more radical: we snapshot the
> > raw value of all the used RES0/1, and put BUILD_BUG_ON()s that fire if
> > any value has changed. They will have to touch the KVM code to fix
> > that, and we catch them red-handed.
> 
> Oh I like that a lot more.

Unsure which registers you planned to give this treatment, but all of
the ID registers we know about should probably go in this bucket too.

-- 
Thanks,
Oliver

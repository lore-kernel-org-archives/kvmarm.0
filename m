Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7BD14A60C
	for <kvmarm@lists.linux.dev>; Mon,  8 Jul 2024 19:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720468044; cv=none; b=D9Rx/fzDkH/kc4nJ2BLueQAlBpYrTjhwECWasr81lnln1hC9yHTsJQY1daHQez4oRt/NW0ToteXDoF7O4YzRciQK77VG8wxOvzGet2VkEVnDk0yUuAv2OU8JBC1ANCX9LTcwPdtZ3/VF9X+a4/VH4nc98vISZF0FT2F4zt5fHiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720468044; c=relaxed/simple;
	bh=VdK4TPeL/42YAoYOAkneiryFkLJeGzbNBCM/oO/MmV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAfY2h54OTCfQOeqTjFPEG7tjNnDV8/E/+/YG0e5cUXCTpPZFmxs0wXv+ySnrQ/KL8BlmHOF/bCjFdrvLRKckT/q2Hco+EuveTViYlkT7MPOyk8w2R0vvjRZymwQYGERFGCIDW1Uo5s+x24equX5DSJDEu2WdMwCYMDzcEekdtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ADflN0E0; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ADflN0E0"
X-Envelope-To: sebastianene@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720468040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F08eTq/6nl01fY8iwc+0cvJBVd8iVm6DBYfEM30lJgk=;
	b=ADflN0E0yjOghOgax/9LJATZ6vo0QSa/QR9voOkwD3KwJ/jYzDhMGuA2vSEOMFa4ui11mq
	w7kebZgojfFpY42MyVdzXYr+mNohvsZJqsF9hujVgmQAtv3nbcphuRRKPYjePZN4eDbRlS
	SvZCp6hs5yRxVxUEjDsXQXze2O7Bv9A=
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: alexghiti@rivosinc.com
X-Envelope-To: ankita@nvidia.com
X-Envelope-To: ardb@kernel.org
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: christophe.leroy@csgroup.eu
X-Envelope-To: james.morse@arm.com
X-Envelope-To: vdonnefort@google.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: rananta@google.com
X-Envelope-To: ryan.roberts@arm.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: kernel-team@android.com
Date: Mon, 8 Jul 2024 19:47:13 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, maz@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v7 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <ZoxCQTub5NH3lLrE@linux.dev>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-6-sebastianene@google.com>
 <Zn8omLmCSIHun1uq@linux.dev>
 <ZoK6kW1FJiQ0ip0e@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoK6kW1FJiQ0ip0e@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 01, 2024 at 02:17:53PM +0000, Sebastian Ene wrote:
> > <snip>
> > 
> > > +	}, {
> > > +		.mask	= PTE_NG,
> > > +		.val	= PTE_NG,
> > > +		.set	= "FnXS",
> > > +		.clear	= "  ",
> > > +	}, {
> > > +		.mask	= PTE_CONT | PTE_VALID,
> > > +		.val	= PTE_CONT | PTE_VALID,
> > > +		.set	= "CON",
> > > +		.clear	= "   ",
> > > +	}, {
> > 
> > </snip>
> > 
> > Neither of these bits are used at stage-2, why have descriptors for
> > them?
> > 
> 
> Atm, we don't make use of the contiguous bit in stage-2 in upstream (but
> we have it in some experimental patches). I can remove this, no hard
> feelings for them.

Yes, please drop them. I'll nag whoever adds contpte support for stage-2
to add them back :)

-- 
Thanks,
Oliver

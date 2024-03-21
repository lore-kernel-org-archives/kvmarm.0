Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901084A2F
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 23:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711064094; cv=none; b=VpBnw9t2JJ8WtBQBNreMtHLKGLWgBP39ZY6fS4VQuJs49afFGNnHpg/sgZK+J1bjK0EK0HgmCrRcVCfjQt5ZqIxBa3qnNGpejgvHWFjugo38FswzDzOGhLDsxxeUUSB/pv/iMl5qnPs4FqrkcBHeELPxhWLXj4UKVhcKeKhzsJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711064094; c=relaxed/simple;
	bh=Io5JdHehA5Tr6Uf1ck81Ezwo2oGgsljd9/XMUEVswCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DR7RoL+idDmOqATr5RtMQzmTSnVYxF8aSmNwFYWJfWOL+ABl8QoymIFk2wf0pICZNt9gqd2DtWozyJzvqcumopE73os1bNthkA9+L46GOKZMzt/D2V37uKCGYeez0Q5N728OjqlxoMRvnyd1w8t4z0cTCL8NkB/PMXRyspnvWhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kHN+uyMr; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kHN+uyMr"
Date: Thu, 21 Mar 2024 16:34:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711064090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y28AiBsCw/hcVqXY41xh8of+9x1tuzj467kpOpPe2NM=;
	b=kHN+uyMrwB/hsauC/kUzNTYP4eU+Xa4tU2QMLArejIn/vzgA0sbjB27N2ukaGw2bd/STQN
	2HvxPmXcNM2ZhnsC89DjYWPZwEdXhI5jToV97L2tvAtI17G2LgZ1FV/Vyn5TKxKrrJ+Yhi
	cR/GDIea3CGJh1+eMfJDE6IJVRiFR8w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: Fix early handling of FEAT_E2H0 not being
 implemented
Message-ID: <ZfzEEObU-mmZF9_l@linux.dev>
References: <20240321115414.3169115-1-maz@kernel.org>
 <ZfyVj8txU6WngPGH@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfyVj8txU6WngPGH@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 21, 2024 at 08:16:15PM +0000, Catalin Marinas wrote:
> On Thu, Mar 21, 2024 at 11:54:14AM +0000, Marc Zyngier wrote:
> > Commit 3944382fa6f2 introduced checks for the FEAT_E2H0 not being
> > implemented. However, the check is absolutely wrong and makes a
> > point it testing a bit that is guaranteed to be zero.
> > 
> > On top of that, the detection happens way too late, after the
> > init_el2_state has done its job.
> > 
> > This went undetected because the HW this was tested on has E2H being
> > RAO/WI, and not RES1. However, the bug shows up when run as a nested
> > guest, where HCR_EL2.E2H is not necessarily set to 1. As a result,
> > booting the kernel in hVHE mode fails with timer accesses being
> > cought in a trap loop (which was fun to debug).
> > 
> > Fix the check for ID_AA64MMFR4_EL1.E2H0, and set the HCR_EL2.E2H bit
> > early so that it can be checked by the rest of the init sequence.
> > 
> > With this, hVHE works again in a NV environment that doesn't have
> > FEAT_E2H0.
> > 
> > Fixes: 3944382fa6f2 ("arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative")
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks!

> I assume Oliver will take it, otherwise I can pick it up after -rc1
> since I don't have the fixed commit in my tree.

I'll pick it up but wont be sending anything out until -rc1.

-- 
Thanks,
Oliver

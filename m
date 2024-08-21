Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EDA14F9E1
	for <kvmarm@lists.linux.dev>; Wed, 21 Aug 2024 16:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724259240; cv=none; b=T/+suwHvos4hwtkQAV8VzDl/RVa91E5S7VexGggzWFfGsqpnuRPI1ZUR4aorBF5rjRlIIj1zA2eLNTR3vVlXC/7PAFicq2IrF84hVwmq4yCbzQchvdd6i3mAAJju9APyrjlPA5EU1oib2tcYky4D4JgwSep8Q36uIGBHQDToLYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724259240; c=relaxed/simple;
	bh=KRqYf0D7qKIvZDRldP2GF+vIYtADtDZc+uaNUudfuhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5mgicshLoLVRFDhEIMjhrAkNT04lwJUYzqAYw8uOLUbtCGmdHPbYnw/As+H6+XekY9wadzd87VwykhVrGRMCWcSgKfxeqlP0NGN9frWd0PWWIMHjgKDIUIJ+5fI8DZ5pNA+QbpDTYNzKKJ3DkbdouXQglhvNe5YdVlssFwg9d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DtfrdYkV; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DtfrdYkV"
Date: Wed, 21 Aug 2024 09:53:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724259236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vlQGzGWk8tm0muGf8AU98KPFAWS2rZ3ejTpHnzVFAeM=;
	b=DtfrdYkV68G2vLS7xazpLrwqXKOB8+hUKiu+fgS9cXylowM4cw6AsBFHKCeKSSbmzxZFTk
	eLeti0zxH3xtakjmF9lVvK29Ebh/Wfse6rz7P47ZItEpRwXu/cE4RCSjCeq2jdVFNVfpWn
	gUZw1wFLoOLWmOXVa1H2J3aETUp18cE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 01/12] KVM: arm64: Make ICC_*SGI*_EL1 undef in the
 absence of a vGICv3
Message-ID: <ZsYbm1PSqQMGmNyt@linux.dev>
References: <20240820100349.3544850-1-maz@kernel.org>
 <20240820100349.3544850-2-maz@kernel.org>
 <ZsUOtp9kfpqm1enx@linux.dev>
 <86le0qxhsn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86le0qxhsn.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 21, 2024 at 11:59:52AM +0100, Marc Zyngier wrote:
> On Tue, 20 Aug 2024 22:46:30 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Tue, Aug 20, 2024 at 11:03:38AM +0100, Marc Zyngier wrote:
> > > On a system with a GICv3, if a guest hasn't been configured with
> > > GICv3 and that the host is not capable of GICv2 emulation,
> > > a write to any of the ICC_*SGI*_EL1 registers is trapped to EL2.
> > > 
> > > We therefore try to emulate the SGI access, only to hit a NULL
> > > pointer as no private interrupt is allocated (no GIC, remember?).
> > > 
> > > The obvious fix is to give the guest what it deserves, in the
> > > shape of a UNDEF exception.
> > > 
> > > Reported-by: Alexander Potapenko <glider@google.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > Cc: stable@vger.kernel.org
> > 
> > LGTM, and just as an FYI I do plan on grabbing this for 6.11
> 
> Great, thanks. Are you planning to route this via arm64, given that
> Paolo is away for a bit?

Yup, exactly that. I'll send the PR in the next day or two when I have
some time to kick the tires on everything.

-- 
Thanks,
Oliver

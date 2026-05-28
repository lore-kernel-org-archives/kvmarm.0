Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7821352023
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779985535; cv=none; b=KWHvSMdqYRyqDr4A/Nc6wMEfW/ANghfsuU4o7YWThtL1a8Lv+F8zmZibNvtGbIX65O/m8CNA5IZqb8piH7IoeNG02RQ9BsVfiVFUhBBeFWQsesOGawvgaK094cPrB3iLT7KVWQti60Ruxli6PjBOLyBbP/7kxLxdOUrKMkL0SrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779985535; c=relaxed/simple;
	bh=4qVVxVlLrFwja/fGOheikl2q8R1303Pa8aphqsMP7dE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1XVZQS7YNQ7hjs4KaT2ppZb0vk8JhVfNXdH5/ie6Lqf0Tiuu8TrRQqgT2B7h8dSHAsrY3LT08Tml7rfDa/e/4Mx52+wvneb6j+Yew2MW68Zi+RtDxeA8vl6QjF/aWY6ZAbDIzKgJ+Jn5A69PIq/m+kS2tFGVZt9lLdnqWZZFoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W5F3ALW+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W5F3ALW+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C1421EA6;
	Thu, 28 May 2026 09:25:28 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B8B33F905;
	Thu, 28 May 2026 09:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779985533; bh=4qVVxVlLrFwja/fGOheikl2q8R1303Pa8aphqsMP7dE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W5F3ALW+y0jmAvpkAxf42xmDyUgQ9WsBf9lxdFJtM2gNmp2/5bs/7lZO09KVj3gSa
	 u+8WGP8dtkgGZzkCt+i2p8gu1Fl2bqnrD/yFPIN84xa3hfrDMtnTr2YjQdPW9NeAqD
	 vbLaDZuCSZLXxpK+2O15RFZRcodvBrX5qFZU9XsE=
Date: Thu, 28 May 2026 17:25:29 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 13/18] arm64: fpsimd: Use opaque type for SVE state
Message-ID: <ahhseaoJD9hdBrMx@J2N7QTR9R3.cambridge.arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-14-mark.rutland@arm.com>
 <362fe07b-70d5-4933-96d3-6445242f9077@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <362fe07b-70d5-4933-96d3-6445242f9077@arm.com>

On Thu, May 28, 2026 at 10:45:25AM +0100, Vladimir Murzin wrote:
> On 5/21/26 14:25, Mark Rutland wrote:
> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > index 9806fea8fea7c..66d880d081671 100644
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -425,8 +425,7 @@ static void task_fpsimd_load(void)
> >  
> >  	if (restore_sve_regs) {
> >  		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_SVE);
> > -		sve_load_state(sve_pffr(&current->thread),
> > -			       restore_ffr);
> > +		sve_load_state(current->thread.sve_state, restore_ffr);
> 
> I do not know much about this code, I assume that live VL matches to current
> but having some logic to check that assumption would be handy...

At this point in task_fpsimd_load(), the NSVL and/or SVL have been
configured by earlier writes to ZCR_EL1 and SMCR_EL1 respectively.

I agree it might be good to add a check here, but it's less of a concern
than in fpsimd_save_user_state(), where the check is there to detect
cases where ZCR_EL1 and/or SMCR_EL1 were clobbered since the state
was bound (e.g. since historically there was the potential for KVM to
clobber the host state).

For now I'm not going to add that, but I'll see if it makes sense to do
that as part of any further rework.

Mark.

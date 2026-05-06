Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82121375ABE
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 15:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778082525; cv=none; b=aZ7fa2IkwxuGtllhk+z3EmYScyTwyvomZLMnf4h6IikWYpTGYerTflYdT4UtDTizBkM4fEQFq2XuXP4c6xeBw+FkK9lHgo+t0ctQptOYsKMe7UPFEAP63NvCPmnusVgma9UCSMT4uKSZoDkBvrY7Wl6WnOXISFXRipGUbrp4GHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778082525; c=relaxed/simple;
	bh=z7XUoCN/77R+J+QP2gklKMVr4SeXdVKCWZXVt6dBS9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhb06E9GvdF8LJS3dsoTw+bg/ZQlbLtGbqRs+3JrkLy24f5RU3kkYhPQfM9cO2U3nWtR1HHn4p35jeKtiLrmqNcGmWfPV5IoqqGyuSdfultPs7uaoBqCVAcvR6qmIjHndDfpo1ovijd+xZ6625u/MUXKKQ67iBPWZEiNbgBZogs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nOnds1c+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nOnds1c+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97CB51A00;
	Wed,  6 May 2026 08:48:38 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DBAB3F7B4;
	Wed,  6 May 2026 08:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778082523; bh=z7XUoCN/77R+J+QP2gklKMVr4SeXdVKCWZXVt6dBS9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nOnds1c+76H2RtQ05VhAVwQicupDz443xHj4DD4QSJMLNui8EHScbuAZSCewr+lbh
	 MXZ00EgTRq43LNOlxA+spYfCdaBa+PaHwxymfUVycmQhXSSEulmFaPGCFksE02d/4c
	 nEq6QZYVZJJcB9BtgAb1AOdzdZsYerZdykJFqlSA=
Date: Wed, 6 May 2026 16:48:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Work around C1-Pro erratum 4193714 for
 protected guests
Message-ID: <afti13dXA6DjGXR3@arm.com>
References: <20260505165205.2690919-1-catalin.marinas@arm.com>
 <aftEJffxGZ_XSk2E@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aftEJffxGZ_XSk2E@google.com>

On Wed, May 06, 2026 at 02:37:41PM +0100, Vincent Donnefort wrote:
> On Tue, May 05, 2026 at 05:52:03PM +0100, Catalin Marinas wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 28a471d1927c..7d59faa99fee 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -5,6 +5,8 @@
> >   */
> >  
> >  #include <linux/kvm_host.h>
> > +#include <linux/arm-smccc.h>
> > +
> 
> nit: probably not necessary with the nvhe/arm-smccc.h include below.

Ah, yes. Some left-over from before I changed it to use hyp_smccc_* and
had to include nvhe/arm-smccc.h.

Marc, do you want me to respin or you can drop this include when
applying.

-- 
Catalin

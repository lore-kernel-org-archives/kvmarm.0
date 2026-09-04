Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF3039A054
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 23:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788563256; cv=none; b=JyC3tI7AXRvpFGfCbR4cIC6uft9p55JPLRb9YLlsY2KwZH62SzxZPYh9JyMh4B/MkFUw5wtFlQbepk4ro+ZOR0YZEtVU/XmKXYFrYFQQyWsnsV9jgeLxA1wPhFiH6M3FqXMcmOJvY+jZVtqQ3YORqgXqKr7gWo4/81FUQ3VfvWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788563256; c=relaxed/simple;
	bh=WvttKtEcaCMI+iTMj6fHxLxcsoxDPGgctjnzDBBojTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hlO2uwuQWv1JyxPFWiuaFsuL6ixSL66CwMH/wx4M1g3ZkMJATu35bxdDsQ2FGf5zSP6VqcNorlyEJy8HYHBvcrLxduHbPTyoATTBP1La/DRKY4k3GFycecHzd/3JID7gbskOYfqiiJx9Cqgr5PoVW37e3Rf8XS3zlgpmzR0GB9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QtMA2Ava; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QtMA2Ava"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788563245; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=WvttKtEcaCMI+iTMj6fHxLxcsoxDPGgctjnzDBBojTs=;
	b=QtMA2AvaD8LTH1kMmMvttySnxAbK2YVps5+i+iPnnjmkgaldwlNBjlnveFucvEXVzEvDhnlEoKzykLhYwZ8XYkUyxYNbu+Z5t1jFhbvDHKDOwYnfJXoRtDVd0pElPDbtblkgyacwCV7TyIFnc7BCxO5VyQiJ0VJ9T5LLbtDdCuY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAJiLbv_1788563243;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0XAJiLbv_1788563243 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 05 Sep 2026 07:07:23 +0800
Date: Sat, 5 Sep 2026 07:07:23 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Ben Horgan <ben.horgan@arm.com>, Xi Ruoyao <xry111@xry111.site>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Gavin Shan <gshan@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
 implemented
Message-ID: <ans4c7lc4v3ouekqkpxrqyenhsvxoe32zkw2qhqgvtiwsbkaji@rjbgkm3yzq63>
References: <20260903160819.831518-1-fuad.tabba@linux.dev>
 <xmhaptfcp2gyoovgus35yhx2uloe2zt3zniwscd2dwnatf2fii@jqobvjdmkqed>
 <CA+EHjTwNJvqqeGtgxR2q+CRn5DJfigssLRcZxz-zY5XvATwOcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwNJvqqeGtgxR2q+CRn5DJfigssLRcZxz-zY5XvATwOcQ@mail.gmail.com>

On Fri, Sep 04, 2026 at 12:18:00PM +0800, Fuad Tabba wrote:
> Hi Yuan,
>
> > > +static bool
> > > +test_has_mpam_sysregs(const struct arm64_cpu_capabilities *entry, int __unused)
> > > +{
> > > + /* The registers exist whether or not firmware enabled MPAM. */
> > > + return detect_ftr_has_mpam();
> > > +}
> >
> > My understanding: arm64.nompam affects detect_ftr_has_mpam(),
> > thus when arm64.nompam = 1 w/ MPAM is supported in hardware,
> > the KVM's trap setting is skipped yet, and it's possible that
> > SYS_MPAM2_EL2 and SYS_MPAMHCR_EL2 are configured not trap anything
> > by firmware, thus guest can still access MPAM registers.
> >
> > Do we need check the raw id register values for the real support
> > state of MPAM here ?
>
> Under arm64.nompam, finalise_el2_state skips the MPAM2_EL2 and
> MPAMHCR_EL2 writes too, via the same check_override, so the kernel
> does not clear the traps either. What a guest reaches there is
> whatever EL3 left, UNKNOWN when EL3 is implemented.

That's what I was worried before w/ nompam = 1 for guest can still access
the MPAM registers. Now it's fine to me w/ limitation on usage of nompam
described in [1], the limitation on guest behavior described there yet.
Thanks for the reply! I just not aware [1] before.

> This patch is for the case where the kernel cleared the traps itself and
> never set them again.

Yes next time I will explicitly say want to discuss something may
related to the patch's main purpose.

>
> Gating on the raw ID registers would make __activate_traps_mpam()
> write MPAM2_EL2 on guest entry there. AFAICT that traps to EL3
> wherever MPAM3_EL3.TRAPLOWER is still set, which is the firmware the
> option is for: 10f885d63a0e ("arm64: Add override for MPAM") added it
> for firmware that leaves the trap set and does not emulate it.

Make sense, it break the nompam actually on platform need it,
this isn't good idea.

For the purpose of this patch:

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
> The arm64.nompam hazard is documented separately [1].
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/20260903084809.2027326-1-fuad.tabba@linux.dev/

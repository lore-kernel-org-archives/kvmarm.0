Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339A23DDDB0
	for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 23:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.37.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789342050; cv=none; b=EdITpQQANmeSv3wh2WkDrUoTqwY602+n6ljGuv5SSw5RsZ0ymKQiFA+tZk9rXhSXXRbymJajM02VCqhy9LwRYu72110izkxA3TzF0n5Xzi/BYtoeDpJksjPxdyM6+DIjtJ5EfXCxPiwp2EWhB1wbN+89YTaAic9V0rh/HI/GFSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789342050; c=relaxed/simple;
	bh=ul+cr0z2BcSymh+TpscLFzMcdP7+m+oZ1R/UwzI1UOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2LQb2jH0ITEvLJk3dv8gEkVGVfVOhXYgMMu2kn8xFmoth4MDdPyYbBQyV4JzKMxDpdiAt5q2NZry7TMH1vFOa6q7qF/POtFEoQm+dKWptJ5JLvvF8vwwY8KnP8sTwJmXLn03o0n2xPup3Epvd1GUUbyiD3TBwRu9Y3J8fBMdUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=ArYvT5cd; arc=none smtp.client-ip=139.138.37.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="ArYvT5cd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789342048; x=1820878048;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ul+cr0z2BcSymh+TpscLFzMcdP7+m+oZ1R/UwzI1UOc=;
  b=ArYvT5cdyGOw96dXg+CpxYDi18gVLrSyqcoBQ6znMWjfLx8CFbwSAtb6
   S2eahUC7BQArRA4E/myaCYI2ACl6nG7iixXatztlowjqzpK98oEyvTLV9
   8aoIdOoXdKE75knpl6Ygriv1rBX3TS/R5H0pW0kOoQfW9bwuNhulu/sVv
   UHCX1Ey5beV5j2j5RVPtMO+GRcjJRmOlU3M1PCb+iulnHVg+kzTIIIM+f
   bw5DLb6PbSm/m66wfpd0ZESFlyBbvIS/eu3fdFOv5Ud6Z6SmzZ2GmSxGC
   2nP1YSANpfP7jSChpGYCZTHQuUVk5UtQ862iuk1mHhduQaHuXfQ0PP0Ou
   Q==;
X-CSE-ConnectionGUID: gPoxky2tR3qkDsO396Ip7g==
X-CSE-MsgGUID: PxtBh6ADT0aVrtzBbfZoUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="232598963"
X-IronPort-AV: E=Sophos;i="6.27,100,1786978800"; 
   d="scan'208";a="232598963"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 08:27:20 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id DE9FC3D39
	for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 23:27:19 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 8CCFF1C002B1
	for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 23:27:19 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 0032B404329;
	Sun, 13 Sep 2026 23:27:14 +0000 (UTC)
Date: Mon, 14 Sep 2026 08:27:12 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH 0/4] KVM: arm64: Reduce overhead of full S2 teardown
Message-ID: <aqcxUCr9828o1W8V@sm-arm-grace07>
References: <20260912104834.3093878-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912104834.3093878-1-maz@kernel.org>

Hi Marc,

On Sat, Sep 12, 2026 at 11:48:30AM +0100, Marc Zyngier wrote:
> Tearing down a full S2 is a pretty involved process, resulting in a
> lot of TLB invalidation. These TLBIs are either on a per leaf basis if
> the HW doesn't support range invalidation, or by top-level range if it
> does. Amusingly, the latter occurs even when nothing has been
> unmapped.
> 
> Things are made worse with NV, as we have a bucket-load of shadow S2s,
> and the need to invalidate them all on the back of an MMU notifier.
> The latter will eventually be solved by the reverse-map tracking that
> Wei-Lin is working on, but we need to be better at full-S2 teardown.
> 
> This small series adds a "no TLBI" unmapping primitive, which allows
> the caller to then whack the TLBs using a VMID-wide invalidation. This
> results in far fewer TLBIs, and a better recursive virtualisation as
> we get far fewer traps as a consequence.
> 
> This applies on top of my shadow-s2 lifetime fixes, and is expected to
> be a prefix to Wei-Lin's series.

I've tested this series on QEMU with TCG mode, and it boots.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

> 
> Marc Zyngier (4):
>   KVM: arm64: pgtable: Add Stage-2 unmap without TLBI primitive
>   KVM: arm64: MMU: Add kvm_stage2_unmap_all() helper
>   KVM: arm64: nv: Move full s2_mmu unmap over to kvm_stage2_unmap_all()
>   KVM: arm64: nv: Move TLBI VMALLS12E1* emulation over to
>     kvm_stage2_unmap_all()
> 
>  arch/arm64/include/asm/kvm_mmu.h     |  1 +
>  arch/arm64/include/asm/kvm_pgtable.h | 17 +++++++++++++
>  arch/arm64/include/asm/kvm_pkvm.h    |  1 +
>  arch/arm64/kvm/hyp/pgtable.c         | 38 +++++++++++++++++++++-------
>  arch/arm64/kvm/mmu.c                 | 15 +++++++++++
>  arch/arm64/kvm/nested.c              |  4 +--
>  arch/arm64/kvm/pkvm.c                |  2 ++
>  arch/arm64/kvm/sys_regs.c            | 18 ++++++-------
>  8 files changed, 75 insertions(+), 21 deletions(-)
> 
> -- 
> 2.47.3
> 
> 

Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C287332EAC
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 00:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780016140; cv=none; b=FiqlCHI16I4e0u8y2HbsiZZ0XUhE7ohBDj0Kvz4yNDrL0hfM6i1E1fBO4HLjN4T10qRr3I6qR2t9xevVFrBoeLO5Y5d7cifVARAIIiMa3GpVTUGRjd6mY3DVe4P0bp1h8vBascncLOJYFyXg0J5WB7+3Xhe729A7jAb3HqVUV48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780016140; c=relaxed/simple;
	bh=lhpPtqrPlN22mh1WZzcu3aj/wlFlJxXUx2s+ET5Hoyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DvfxTH6bnHrj7K7pPxMxY8T6bEaEzjwZAU69VkBDvzQJid09GqPFd0lYrFFpphafmeWQo/VEJdbLJ1Zrv/T9RUxAjhbo8hloz51YfRvaXK39gohfAflADxqrArYRItXPK9ham1bf+zTmTI+8xqx7Dn1YM2Yiuj5GDKVCcr6+ezY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=bcJVeS2M; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="bcJVeS2M"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1780016139; x=1811552139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lhpPtqrPlN22mh1WZzcu3aj/wlFlJxXUx2s+ET5Hoyw=;
  b=bcJVeS2MBGFFLHRbnhhDHjcAq8Q8TgnjBYXHa7opPcfhGvGEbC8fJVX+
   RVYl/BuTq7vPJi3YNMZgFxht1tzWBe+lHBrx21+iFCwxwi9ithSCi2dKu
   53a42WTvH4SRsi0A/9lSVmrd8qv3lbg13nrBpvf4ewU61i0ymfXkREFQj
   HTWjBJ7PjmYVqQYIn6GKuYN5LiPIXyA7MwK/eapBSXNNFNdwDk8qgGiKH
   mtJOpH8EUkAEo2ZJ497ApPM1sUIuhP2vKBSuMCWqizf6dw+dBkZj9BiHu
   As9NXHSTbIWaEOQVDJcvt5v79Tod4pIAWnF9EYNsp+tiEyfhhzjKcnXbE
   Q==;
X-CSE-ConnectionGUID: 3EtJbeW8RuOoeyikBU5qRQ==
X-CSE-MsgGUID: Q/JT6HYUTGepV2IIawG7iQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="240339039"
X-IronPort-AV: E=Sophos;i="6.24,174,1774278000"; 
   d="scan'208";a="240339039"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 09:55:31 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 9D826ADBD
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 00:55:31 +0000 (UTC)
Received: from az2nlsmom4.fujitsu.com (unknown [10.150.26.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id 5095D188C9A2
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 00:55:31 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom4.fujitsu.com (Postfix) with ESMTPS id 128DA2000752;
	Fri, 29 May 2026 00:55:26 +0000 (UTC)
Date: Fri, 29 May 2026 09:55:24 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Wei-Lin Chang <weilin.chang@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 0/5] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <ahjj_CKuXhDOHhBZ@sm-arm-grace07>
References: <20260510145338.322962-1-weilin.chang@arm.com>
 <ag1jQB3dRX0RSqbR@sm-arm-grace07>
 <86fr3bvnt5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fr3bvnt5.wl-maz@kernel.org>

On Thu, May 28, 2026 at 11:19:34AM +0100, Marc Zyngier wrote:
> On Wed, 20 May 2026 08:31:12 +0100,
> Itaru Kitayama <itaru.kitayama@fujitsu.com> wrote:
> > 
> > Hi Wei Lin,
> > 
> > On Sun, May 10, 2026 at 03:53:33PM +0100, Wei-Lin Chang wrote:
> > > Hi,
> > > 
> > > This is v3 of optimizing the shadow s2 mmu unmapping during MMU
> > > notifiers.
> > > 
> > > Two new preparatory patches are added, one reduces a hole in kvm_s2_mmu
> > > and another refactors the code a bit during s2 faults. Other changes are
> > > listed below.
> > > 
> > > * Changes from v2 [1]:
> > > 
> > >   - Removed "polluted" teminology.
> > > 
> > >   - Use xa_{mk, to}_value() when storing and retriving values from maple
> > >     trees.
> > > 
> > >   - Avoid using the 63rd bit in maple tree values so that xa_{mk, to}_value()
> > >     does not lose us a bit.
> > > 
> > >   - Added reverse map removal during TLBI handling.
> > > 
> > >   - Other suggested refactorings.
> > > 
> > > Thanks!
> > 
> > With this series applied on the recent kvmarm/fixes (minor local modification), 
> > your v3 hello_nested runs fine on all three page granules; without this 16KB 
> > kernel can't handle stage 2 unmapping paths. I tested using the latest QEMU only 
> > so wonder how you're testing.
> 
> Can you clarify this statement?
> 
> Are you saying that 16kB S2 unmap do not work with upstream? That
> seems odd, as it would mean NV wouldn't work on Apple HW, which
> represents two thirds of my development boxes...

Yes, I built this morning's upstream kvmarm/fixes with 16KB granule fresh, and tested
Wei Lin's propsed KVM selftest, hello_nested on QEMU with the small buildroot
filesystem and saw the above i.e., the stage 2 unmapping paths never finish.

I thought it was due to the Ubuntu userspace I was using for testing,
but not sure now.

Thanks,
Itaru.

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

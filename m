Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EDA1C860A
	for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 22:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785191090; cv=none; b=f1DbrB4bLEeTXPrUDnd04iaG2ehiE9s40ypNd3ChcoTsjRxUdauGGWEWHnorPjQ1VCUnqNbj6scVF4jhqsS475seo+xKHeIR24s6eAHAS/5BuF+kKcpbCzRYFl+Qzq7kxJqZD/PP4LNz+uOlqyx+MIk0DQt+VFe4AhX0cUcCOx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785191090; c=relaxed/simple;
	bh=3EuTfDhU7UqVMvj85eqJNeuNbQJACnt857e5rAiZhGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Azz160E/d8biTe2ZqAF2X0tr/UEu2TaWqDpLspxuTKk5XtiTbG8MO71zc7h5laZQfVE4XX1qHD45eKPhetuwOTetwqWeuI2egdNX1fFBzk6Jj4+5gv+cmg3LgAGbkTK95TMLgEwnIuA/a27Bk2cQhG6LiTGISEj3i+0LIaLuO/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=kKh6GIVW; arc=none smtp.client-ip=139.138.36.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="kKh6GIVW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1785191092; x=1816727092;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3EuTfDhU7UqVMvj85eqJNeuNbQJACnt857e5rAiZhGQ=;
  b=kKh6GIVWJ4k8K1us/fhiNJa0f86Z2EgbHqnDE8cibe/vnBAySq+O9nwj
   4104azH5rR7DaPtu5M6ZDXUFBqu57F+JHdVRvBw/NFbVogX9hCcoP0YDS
   wzgI+gkf6afzTiBNpxKKFGHX/+3H1KFBAF9+7A9nYM8047yENHW3QNkw9
   01NsK8eyzQdVR+r9X1D/B1P8XXpkEcvOUl2y4yKiJ0C9Ie9s/1eyXprJL
   47JJFEQjOCrCoydAanZlbLO7NinH1mktzg7Di7zO2xx2Bm70bKDCfEuqg
   MwHkcPtSX7PAzFOFZUljDcO/s05rkJTckJPgPv6nSkqrREU2EzAByHL5g
   g==;
X-CSE-ConnectionGUID: BmOfuB1cShSkaPMtFKOVZQ==
X-CSE-MsgGUID: wUtPXxdFQCCLVbObzB0Kig==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="236205722"
X-IronPort-AV: E=Sophos;i="6.25,189,1779116400"; 
   d="scan'208";a="236205722"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2026 07:24:50 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 1DDC81469
	for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 22:24:47 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id BA9C31C00117
	for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 22:24:46 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 1CE69405E2F;
	Mon, 27 Jul 2026 22:24:41 +0000 (UTC)
Date: Tue, 28 Jul 2026 07:24:39 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v4 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <amfap0e5dhQgo4eW@sm-arm-grace07>
References: <20260714115926.2044757-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714115926.2044757-1-weilin.chang@arm.com>

On Tue, Jul 14, 2026 at 12:59:19PM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> This is v4 of optimizing the shadow s2 mmu unmapping during MMU
> notifiers. The general theme stays the same, but various
> improvements/fixes are added. Thanks for all the feedback. Please see
> below for the changes.
> 
> * Changes from v3 [1]:
> 
>   - Rebased on to the latest kvmarm/fixes.
> 
>   - Removed commit "KVM: arm64: Move shadow_pt_debugfs_dentry to reduce
>     holes in kvm_s2_mmu" because the current shadow ptdump code is found
>     to be buggy and the proposed fix removes shadow_pt_debugfs_dentry [2].
> 
>   - Rename some variables to improve readability e.g. ipa ->
>     canonical_ipa, fault_ipa -> nested_ipa.
> 
>   - Skip reverse map optimization when !mmu->nested_stage2_enabled,
>     and just unmap the canonical IPA range during MMU notifiers.
> 
>   - Change comment above the code that checks whether an identical
>     reverse map already exists in kvm_record_nested_revmap() from saying
>     it could be a permission update to saying another parallel stage-2
>     fault could have inserted an identical reverse map. This is because
>     permission update won't trigger kvm_record_nested_revmap().
> 
>   - Add helpers for checking maple tree entry flags VALID_ENTRY and
>     UNKNOWN_IPA, also warn if both are set at the same time.
> 
>   - Test canonical IPA alignment with the mapping size during reverse
>     map insertion.
> 
>   - Move clean up of kvm_unmap_gfn_range() to its own patch.
> 
>   - Avoid naming variables with "*dir*", as it can be misunderstood to
>     be related to directories.
> 
>   - Use mas_find() instead of mas_find_range() as mas_find_range()
>     returns every range including empty/NULL ranges, for our use case
>     we only want to iterate over non-NULL ranges.
> 
>   - Added a trace point to track when the reverse map maple tree becomes
>     "broken" i.e. maple tree insertion failure.
> 
> Thanks!
> 
> [1]: https://lore.kernel.org/kvmarm/20260510145338.322962-1-weilin.chang@arm.com/
> [2]: https://lore.kernel.org/kvmarm/20260630121005.1130996-1-weilin.chang@arm.com/

Thanks for the update. I know this series is sitll being discussed, but I
went ahead testing the kernel with your proposed hello_nested seltest on a Grace
CPU. 

Before this series applied:
real    0m2.869s
user    0m0.003s
sys     0m2.862s

After this series applied:
real    0m0.027s
user    0m0.001s
sys     0m0.005s

It reduces the time needed for the VM tear-down paths. I will test this series again 
when v5 comes out, since I've git this a try;

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

> 
> Wei-Lin Chang (6):
>   KVM: arm64: Use a variable for the canonical GPA in kvm_s2_fault_map()
>   KVM: arm64: nv: Avoid full shadow s2 unmap
>   KVM: arm64: nv: Add nested revmap broken tracepoint
>   KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables
>   KVM: arm64: nv: Remove reverse map entries during TLBI handling
>   KVM: arm64: nv: Create nested IPA direct map to speed up reverse map
>     removal
> 
>  arch/arm64/include/asm/kvm_host.h   |   9 +
>  arch/arm64/include/asm/kvm_nested.h |   6 +
>  arch/arm64/kvm/mmu.c                |  42 +++--
>  arch/arm64/kvm/nested.c             | 280 +++++++++++++++++++++++++++-
>  arch/arm64/kvm/sys_regs.c           |   3 +
>  arch/arm64/kvm/trace_arm.h          |  27 +++
>  6 files changed, 349 insertions(+), 18 deletions(-)
> 
> -- 
> 2.43.0
> 

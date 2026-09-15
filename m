Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C866D33B969
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789509015; cv=none; b=WMtX9upZNcnu1Wadi1pOwCAvlvrJvQdYLZ/kABxE8TEclJK0uYAcHftYiwe8ewD4+elf4MQ+nnRqcOJ35E1qBMEYLhuRrIHax/1oAKBEZOzzdwyM3rhqFt+l7Y0oBFIxFwK3Y8Icw+E1tlIuriSUn6UyUP8NY/fzH4x7nn5xn+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789509015; c=relaxed/simple;
	bh=XBD1UvlBlRAVfbgJdKlrQtWgl0n/EsOA+/7NfYLSFM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZo4VUTC0e1Uffu4HVi5Hu2MA1kUom3GJcYMOrVeTdRHpyPvf+DgvDDdy48dlDdzWgyE4CMnj8dnN6VMVMzzYdFU1kYZSIT41R+rUGfuwBggJyqYzrLvxgZCklWmulQMrPNI6whqLwK3Bo+S8E83nAalH8DRG6ObU7IeRAI83jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=NQlDH2Z4; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="NQlDH2Z4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789509014; x=1821045014;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XBD1UvlBlRAVfbgJdKlrQtWgl0n/EsOA+/7NfYLSFM4=;
  b=NQlDH2Z4Zo9qcljSjsfrn767jVrpQQDZe4a0Atds3bEBEPV9JM7xBXWp
   eAeIbANwcrJmP3Q/Cm8DgFM9s755gkIcrmHAcrX0gZNDxle1kKvDZW9e5
   Wetc1ydO/H4LwdK/8GHPGGmN5YFt1w4pzZujpCb3dTWyCyWTqhitLasvo
   WFc9EnWd6UNi5hGpibik4NKUz33nDUc4bVIrPGD4PVhweSCwuStuPO1PO
   L7nYRuohWTl2bAAcQz/b49/nNx8qKRUNywwHNd1GS++hIIPUsIiQxkTYR
   GE5yjbHSwTx5S70gl+/qm9o8UK2WMJ1tcrXhvAKMXReAbIAfMNnEWPn9o
   g==;
X-CSE-ConnectionGUID: oXz8rBTERSmEWK8VhyVhfg==
X-CSE-MsgGUID: dAhgYb9bQ1GIR4CCkkm6iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="241349522"
X-IronPort-AV: E=Sophos;i="6.27,103,1786978800"; 
   d="scan'208";a="241349522"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 06:50:06 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 3A2251C1C707
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 21:50:06 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (unknown [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id E255F1800260
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 21:50:05 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom3.o.css.fujitsu.com (Postfix) with ESMTPS id 29FD410001C5;
	Tue, 15 Sep 2026 21:49:59 +0000 (UTC)
Date: Wed, 16 Sep 2026 06:49:57 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v6 0/7] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <aqm9hXB6X9IQ8wHz@sm-arm-grace07>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915154305.3852871-1-weilin.chang@arm.com>

On Tue, Sep 15, 2026 at 04:42:58PM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> This is v6 of optimizing the shadow s2 mmu unmapping during MMU
> notifiers.
> 
> This version fixes a few issues, and adds Marc's space optimization
> for kvm_guest_s2_mapping [1]. Please see the changelog for the details.
> 
> Tested by booting L3, and running in-kernel targetted tests described
> in [2]. v5 got some tested-by's from Itaru and Wang (thanks), I didn't
> carry them over since some bugs fixed in v6 are non-obvious. Some
> retest would be much appreciated!

How did you boot into L3, with KVM selftest or recrusively boot on HW?

Thanks,
Itaru.

> 
> Series based on v7.3-rc3 + Marc's nested mmu lifecycle fixes [3].
> 
> * Changes from v5 [4]:
> 
>   - Align the addresses down to the mapping size when recording the
>     guest s2 mappings. s2fd->fault_ipa isn't necessarily PAGE_SIZE aligned.
> 
>   - Record guest s2 mappings even when page table maps return -EAGAIN.
>     kvm_pgtable_stage2_map() can create mappings while returning -EAGAIN.
>     For example, a 2M block map (A) could race with a 4K page map (B):
>     1. (A) maps the 2M block in kvm_pgtable_visitor_cb()
>     2. (B) breaks that block into a table and maps 4K
>     3. (A) reloads and finds the table after kvm_pgtable_visitor_cb(),
>        then descends into it.
>     4. (A) maps some 4K, but before it finishes reads entry mapped by (B).
>     5. (A) returns -EAGAIN although it had mapped a few pages.
>     In this case, we don't know what subrange is mapped, just track the whole
>     requested mapping range.
> 
>   - Don't remove tracked mappings from the interval trees if they only
>     partially overlap the removal range. Because of the previous bullet point
>     we can have a 4K shadow mapping tracked as a 2M range in the interval
>     trees. It would be wrong to remove the 2M range when a guest TLBI doesn't
>     touch the 4K mapped.
> 
>   - Check mmu->pgt during mmu unmap notifier, as it could race against
>     MMU teardown.
> 
>   - Make guest_s2_tracking_destroy() canonical mmu only. We simply don't
>     need to detach the nodes from the nested mmus' trees. Freeing them
>     during canonical mmu's teardown is enough.
> 
> Thanks!
> 
> [1]: https://lore.kernel.org/kvmarm/86h5jv7qrd.wl-maz@kernel.org/
> [2]: https://lore.kernel.org/kvmarm/gerjpm62a2gszzggc6vuai22bf3prfquvfsp7ueumps7vz2ev3@odlmovaklg2b/
> [3]: https://lore.kernel.org/kvmarm/20260911162203.1919330-1-maz@kernel.org/
> [4]: https://lore.kernel.org/kvmarm/20260810205038.118843-1-weilin.chang@arm.com/
> 
> Marc Zyngier (1):
>   KVM: arm64: nv: Drop kvm_s2_mmu pointer from kvm_guest_s2_mapping
> 
> Wei-Lin Chang (6):
>   KVM: arm64: Use a variable for the canonical IPA in kvm_s2_fault_map()
>   KVM: arm64: nv: Introduce guest stage-2 tracking structures
>   KVM: arm64: nv: Track guest stage-2 mapping creation
>   KVM: arm64: nv: Track guest stage-2 mapping removal
>   KVM: arm64: nv: Avoid full shadow stage-2 unmap
>   KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables
> 
>  arch/arm64/include/asm/kvm_host.h   |  31 +++++-
>  arch/arm64/include/asm/kvm_nested.h |   7 ++
>  arch/arm64/kvm/mmu.c                | 109 +++++++++++++++++++---
>  arch/arm64/kvm/nested.c             | 140 +++++++++++++++++++++++++++-
>  4 files changed, 269 insertions(+), 18 deletions(-)
> 
> -- 
> 2.43.0
> 

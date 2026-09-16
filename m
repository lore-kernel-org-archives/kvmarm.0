Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1DF31B130
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 04:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789534702; cv=none; b=Pu3VzKoSpGokCBebCgjVlePdkLJzBNQjWpNhKX2FNS5kEAGRKrLsn7dDIEWtj9+2ACLtDSWwFeha8j1zbvbw+6CRua/8VC9228nh6KV92lxHQlJVNN50eT0e2Fk8VSzzaGf3Lv0GjUUjzwxcpmm4SiXvzelTkcv6hDoIi3xDmLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789534702; c=relaxed/simple;
	bh=SnAcro5Dui87SihtGm652xAlG5XwDxA05uuCThf6Qp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXLCdIslcbwmfqBIYO/GcO5Hi6bDHs9+T5xK1JTevTMSL/CvkhidfJwHY1YeBS4xueCs9oSnRNruxBg5qAzisMIpsvNpRBGQKVxDSC6UJOvWvcYLuzTkAkzj9roAfnOEmUEpvvpSKYbeusdW9UtDK8f+utAKPVBxdOWqp7YRM6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=uIIWP4gF; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="uIIWP4gF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789534705; x=1821070705;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SnAcro5Dui87SihtGm652xAlG5XwDxA05uuCThf6Qp4=;
  b=uIIWP4gFFId3491bzGj67WGag7pRJig9n6Pe1CTviKS+lu7ooiFkW0kI
   zieg+JC6f+V7gVw3UL0/9FVhujKAy0Ok7fegohwvL+AWY7+/akxhXfK+k
   Ez21ljLjsYvQI/LN8nln1rEYERLBgYcJl2ggNqtB/KbVAJRMy0uxuLND7
   w+eyVmdKlAq+JQUp7QvqCBZcxN8xChQQf/XiWxPPjhUzBhZSa4zm5rpRj
   6miYZ5yfCoQJpayk2AydM6SBfN634jbOPJwC+xmRkwtZZ9RyU5L0mJ3Q0
   tyJpbC00ai9XaVvc7Hi7QaEmc5WzH96X4MHXGzPZmkC6i8hWI6HEeCDbe
   Q==;
X-CSE-ConnectionGUID: GJXO5kmcQreFjaRR2q6NyA==
X-CSE-MsgGUID: qMKfUJCRQU+FhHn5hgmctA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="255212538"
X-IronPort-AV: E=Sophos;i="6.27,103,1786978800"; 
   d="scan'208";a="255212538"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 13:58:17 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id B4EDB407547
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 04:58:12 +0000 (UTC)
Received: from az2nlsmom3.fujitsu.com (unknown [10.150.26.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 653741C00152
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 04:58:12 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom3.fujitsu.com (Postfix) with ESMTPS id 497CD100019E;
	Wed, 16 Sep 2026 04:58:06 +0000 (UTC)
Date: Wed, 16 Sep 2026 13:58:03 +0900
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
Message-ID: <aqoh27cSs5gMHeAL@sm-arm-grace07>
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

Hi Wei-Lin,

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
> 
> Series based on v7.3-rc3 + Marc's nested mmu lifecycle fixes [3].

Observed on QEMU (accel tcg) only, but I saw:

[ 1812.052752] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1630
[ 1812.052896] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 596, name: shadow_stage2

The kernel is built on top of Marc's fix and your version six series, but
the fix for debugfs will be posted later?

Your hello_nested and shadow_stage2 ran without an issue.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

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

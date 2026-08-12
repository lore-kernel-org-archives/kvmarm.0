Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C747372B2B
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 02:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786500753; cv=none; b=h7UXwfBXNSbwKd9t1/QMZWN2keYHFwcdKlmNtI5Qdc2iqSDD29Seu/yZpSVUI6A9MTa2G+WD7OHyUS/uuIABS6Dt1COKLlJ375AEROZtN0n3mr1LFma3bnCS7o8z6DnUqgrGpVPH9bIS+CyC2fYaP1GrAJO4V5MVGopwcqVImAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786500753; c=relaxed/simple;
	bh=RQbAC9lZHMCCiv+OalwsmXeI700Si2jd0Na3NCuH21k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIH/aQgFqAGp6EHUoCuem2HizQVUHJeHsFRWNmhLD5ERmh2NB9o+k6LOBGDe8+VlctnvNLnUKdOPK4rnCTNpHA4PxjkAfnd2EBYFAqnRQyWeos+vIpUsa95NsL61hbt3g1q4LmH5ROPFkDcr5aC+k+BL6mkZgj/IJjYH3g7ee8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=jBh6c4nf; arc=none smtp.client-ip=139.138.36.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="jBh6c4nf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1786500754; x=1818036754;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RQbAC9lZHMCCiv+OalwsmXeI700Si2jd0Na3NCuH21k=;
  b=jBh6c4nfxEsX9UhoEo9a7hR1iCpQGF898+DDTIdsaJwqukat3r88qbXr
   Sgfnfr5P6FFEi8Yd8Qk1CCz7VJvDjV/egntZ37kVCrt/1P1PBpI3PnJF/
   ANOs7B1mVucf8uyeGxZwABw2fY8zLXXNAduevAtJ1NmV1llrSYmU2xmpY
   ftFajRhsNLkDjmK3MpLHgLvTdZK/r/B7wsyo+0J37hu3DrYQIaD7ny5Wv
   uHCmCfliHVxsHctqhnTL/X1bHsptNwvqPqJ0RG/e3VjeCS6tTIHq8M/LA
   T05ryXbRZ9p2TwGZXWRd2oUH5jJlFxAM03QVQ0GdF77xb/W00jlfnFtRD
   A==;
X-CSE-ConnectionGUID: /0NdwqcaR1iKVRpP7QUssg==
X-CSE-MsgGUID: 9GEH+axRTZ+TOWysjstB8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="238068275"
X-IronPort-AV: E=Sophos;i="6.25,218,1779116400"; 
   d="scan'208";a="238068275"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 11:12:26 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id E4F90CA6B
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 02:12:22 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id 946231886334
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 02:12:22 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 96BFA40599C;
	Wed, 12 Aug 2026 02:12:17 +0000 (UTC)
Date: Wed, 12 Aug 2026 11:12:14 +0900
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
	Will Deacon <will@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map (new data structure)
Message-ID: <anvWfkxd1b97xxFw@sm-arm-grace07>
References: <20260810205038.118843-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810205038.118843-1-weilin.chang@arm.com>

On Mon, Aug 10, 2026 at 09:50:32PM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> This is v5 of optimizing the shadow s2 mmu unmapping during MMU
> notifiers.

I've tested your series v5 on a Grace system. L2 booted into prompt
with the Ubuntu filesystem image, your two kvm selftest for nested 
virtualization ran fine in L1, and also did stress-ng in L1:

projects $ sudo stress-ng --kvm 16 --cpu 16 --vm 8 --vma 8 --fork 8 --timeout 10m --verify    --metrics-brief
stress-ng: info:  [1053] setting to a 10 mins run per stressor
stress-ng: info:  [1053] dispatching hogs: 16 kvm, 16 cpu, 8 vm, 8 vma, 8 fork
stress-ng: info:  [1087] vm: using 32MB per stressor instance (total 256MB of 2.75GB available memory)
stress-ng: metrc: [1053] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s
stress-ng: metrc: [1053]                           (secs)    (secs)    (secs)   (real time) (usr+sys time)
stress-ng: metrc: [1053] kvm                  81    602.31    250.98    357.55         0.13           0.13
stress-ng: metrc: [1053] cpu               63310    595.70    166.40      0.60       106.28         379.12
stress-ng: metrc: [1053] vm              4252063    600.90     38.98     56.59      7076.16       44491.45
stress-ng: metrc: [1053] vma               56633    601.76     12.64    157.96        94.11         331.97
stress-ng: metrc: [1053] fork                149    600.98      0.03      0.45         0.25         314.59
stress-ng: info:  [1053] skipped: 0
stress-ng: info:  [1053] passed: 56: kvm (16) cpu (16) vm (8) vma (8) fork (8)
stress-ng: info:  [1053] failed: 0
stress-ng: info:  [1053] metrics untrustworthy: 0
stress-ng: info:  [1053] successful run completed in 10 mins 8.62 secs

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

> 
> This time, a major overhaul is done to the implementation. After
> receiving some suggestions from Marc, I have identified that using the
> interval tree to store the guest stage-2 mappings solves many problems
> compared to using the maple tree.
> 
> Interval Tree vs Maple Tree
> ===========================
> 
> First of all, interval trees are capable of storing overlapping ranges,
> which is helpful when the L1 hypervisor maps something like:
> 
> nested IPA [x, x+4K) -> canonical IPA [a, a+4K)
> nested IPA [y, y+2M) -> canonical IPA [a, a+2M)
> 
> No problems with storing that in the interval tree with different nodes.
> We can avoid the maple tree UNKNOWN_IPA mechanism as a compromise.
> 
> Second, ideally we would want to save the canonical IPA <-> nested IPA
> mapping in both directions to allow MMU notifier unmap speed up, and
> stale shadow mapping removals. If we use the maple tree, we'll have to
> have 2 separate trees, and make sure they store the same mappings, which
> isn't simple given the first point.
> 
> On the other hand, by using this pattern:
> 
> /* Record of a guest stage-2 mapping. */
> struct kvm_guest_s2_mapping {
>        struct interval_tree_node canonical; // CIPA range of the mapping
>        struct interval_tree_node nested;    // NIPA range of the mapping
>        struct kvm_s2_mmu *nested_mmu;       // mmu of the NIPA space
> };
> 
> and equip each mmu with an interval tree storing mapping records
> corresponding to the IPA space it represents, we can insert the
> respective nodes into the canonical IPA tree, and the corresponding
> nested IPA tree. This makes it trivial to find the range of the other
> IPA space from a range in one IPA space.
> 
> Diagram to help understanding:
> 
> struct kvm_guest_s2_mapping mapping1, mapping2;
> 
>     ---------------------> mapping2.canonical
>     |                      mapping1.canonical
>     |                          ^   (both stored in canonical mmu's tree)
>     |                          |
> --*****-----------------------*****----------- CIPA
>    \\\\\                      |||||                  mapping1.nested_mmu
>     \\\\\                     \\\\\                            |
>      \\\\\                     \\\\\                           v
> ------\\\\\---------------------*****--------- NIPA #1 (nested mmu #1)
>        \\\\\                      |
>         \\\\\                     -> mapping1.nested
>          \\\\\                       (stored in nested mmu #1's tree)
>           \\\\\
> -----------*****------------------------------ NIPA #2 (nested mmu #2)
>              |                                                 ^
>              -> mapping2.nested                                |
>                 (stored in nested mmu #2's tree)   mapping2.nested_mmu
> 
> Third, maple tree does its own memory allocation. In the KVM stage-2
> fault path we only find out what the mapping ranges are after taking the
> KVM MMU lock, and the maple tree has to know the range and entry to be
> stored to preallocate, therefore in our case the maple tree is forced to
> only use GFP_NOWAIT, which isn't the best. With the interval tree the
> user does the memory management, and we can just allocate before taking
> the locks.
> 
> Locking
> =======
> 
> The guest_s2_tracking_lock serializes accesses to the tracking interval
> trees. It is taken after the mmu_lock. However in reality it is only
> taken after we take the read mmu_lock in the stage-2 fault path, as
> other accesses have the write mmu_lock already. This saves us some
> manual lock/unlocks.
> 
> vCPU Stage-2 Fault Scalability Reduction
> ========================================
> 
> KVM/arm64 is able to handle stage-2 faults from multiple vCPUs in
> parallel, thanks to the engineering done to the s2 pgtable code. However
> to safely insert mappings into the interval trees we have to serialize
> using the guest_s2_tracking_lock. We trade some performance in stage-2
> fault for faster MMU notifier unmaps, and keeping the unaffected shadow
> mappings.
> 
> Memory Usage
> ============
> 
> Each interval tree node is 48 bytes, and a kvm_guest_s2_mapping is 104
> bytes, residing in 128-byte slab objects. Each shadow stage-2 fault
> requires one kvm_guest_s2_mapping instance. This is 32MB for a fully 4KB
> mapped 1GB region, and 64KB for a 2MB mapped 1GB region.
> 
> Series Structure
> ================
> 
> Patch 1:   Preparatory refactoring.
> Patch 2:   Introduce data structures for guest stage-2 tracking.
> Patch 3-4: Guest stage-2 tracking addition and removal
> Patch 5:   Avoid full unmap during MMU notifier unmap using the tracked
>            guest stage-2 mapping information.
> Patch 6:   Minor clean up.
> 
> As this is a complete rework, I will omit the change log this time.
> Series is based on v7.2-rc5.
> 
> Thanks!
> 
> Link to v4: https://lore.kernel.org/kvmarm/20260714115926.2044757-1-weilin.chang@arm.com/
> 
> Wei-Lin Chang (6):
>   KVM: arm64: Use a variable for the canonical IPA in kvm_s2_fault_map()
>   KVM: arm64: nv: Introduce guest stage-2 tracking structures
>   KVM: arm64: nv: Track guest stage-2 mapping creation
>   KVM: arm64: nv: Track guest stage-2 mapping removal
>   KVM: arm64: nv: Avoid full shadow stage-2 unmap
>   KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables
> 
>  arch/arm64/include/asm/kvm_host.h   |  20 ++++++
>  arch/arm64/include/asm/kvm_nested.h |   7 ++
>  arch/arm64/kvm/mmu.c                | 105 ++++++++++++++++++++++++----
>  arch/arm64/kvm/nested.c             |  95 +++++++++++++++++++++++++
>  4 files changed, 215 insertions(+), 12 deletions(-)
> 
> -- 
> 2.43.0
> 

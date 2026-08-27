Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428743C1D67;
	Thu, 27 Aug 2026 08:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787818088; cv=none; b=hxs+NMOknUXnnDK3RE4j0fHZAGByMU+9j2YvXn3ReuLxPjr47+YibkarHKFvPGq1sAD6UwFniRIyFRcrDz1VnpU91JT+O0GNXHO1dRvpppIozUtNnePGzVkVqUiBb6jDWCCpJjL1qz08rWr0PTJJ1hDRNB7rcf+JDQIZDtXjlzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787818088; c=relaxed/simple;
	bh=HfubrEGF3eKsGUawx1MnfZr959FNLY03HrFmRB8niVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0OmB2rOg93riLlmpWMj6FRahCqcXGAeMHF404L9xmC+nxt04HhKdKsc3xoFQAiZlwEqzSP5kLpynCCfG3onSnTmR7Ev3w8EH+7/5HiGS4osEvHowNDE3Neh6+SUZT50P68GNYcKC9D/ZOf7zaVmGx7HR6K2rTCUFeUcJ+W/GLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=qiFkrJEI; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="qiFkrJEI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1787818080; x=1819354080;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HfubrEGF3eKsGUawx1MnfZr959FNLY03HrFmRB8niVo=;
  b=qiFkrJEIxj9cPo/2sM6cn1l48JdlLOA38GV1oVMco53zTucuMFk1ZJK/
   oheOxI2/45wuoZlFFrD297L8DZzuz+UBNVlQnPZVzvAsJWH+m2BEhZ9jX
   mlxbftFMWCen/nf16XFar+lcv63lUfM03A1VEu9xhcK9NO4TO/te8fDMG
   R8I5eqOdZ9QCTCCdRhk409CiSlhd+WU9xFHHU2OQCP9GKoWhChkIAPO/9
   fpvmWKqpclGkoENGzW8LMyrrvlGXGiWCDkbIgZJcZjUisW+CToY/ryZKf
   kqSN76HHMvlnGROuaasLF40zwCyqMG2+7pXmtnJvFRRRHzFFuX1t5axsg
   g==;
X-CSE-ConnectionGUID: ByX7NcZrTCGeL7bQj1dsIw==
X-CSE-MsgGUID: mJmbNtALSrS3arWrpAVc0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11887"; a="256543812"
X-IronPort-AV: E=Sophos;i="6.25,246,1779116400"; 
   d="scan'208";a="256543812"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 17:07:56 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 63EC1406107;
	Thu, 27 Aug 2026 08:07:52 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (unknown [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id 19D8A180F57B;
	Thu, 27 Aug 2026 08:07:52 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom3.o.css.fujitsu.com (Postfix) with ESMTPS id 670BD1004B16;
	Thu, 27 Aug 2026 08:07:43 +0000 (UTC)
Date: Thu, 27 Aug 2026 17:07:40 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Atish Patra <atish.patra@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 00/20] KVM: selftests: PPC pre-enabling
Message-ID: <ao_wTAq6U2bvWzgu@sm-arm-grace07>
References: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>

On Wed, Aug 26, 2026 at 04:04:51PM -0700, Sean Christopherson wrote:
> This is a big pile of cleanups and refactoring to prepare for PPC support in
> KVM selftests.  PPC has paging modes that require multi-page page tables, and
> those page tables need to be naturally aligned.  The original proposal was to
> plumb in an @align param to the page allocators[*], but I didn't love the idea
> of adding another rarely used param to the allocators.
> 
> Reworking the APIs to take a region type requires a fair bit of churn, and was
> more painful than expected as I didn't realize just how many one-off tests did
> weird things, but overall I think it's worth it?  If only to keep cutting down
> on the use of magic memslot numbers in tests.
> 
> This needs explicit testing on s390.  I tested on arm64 and x86, and given the
> number of failures I had to wade through, I wouldn't be at all suprised if I
> broke something subtle on s390 as well.
> 
> I'm less concerned about RISC-V and LoongArch as they don't have any custom
> tests that are affected (which is where I got burned).

I ran kvm_page_table_test with this series applied on Grace CPUs.

Passes across all the arm64 guest modes supported.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

> 
> [*] https://lore.kernel.org/all/df86b5ccdbdafc3509d9538bd5e6796737bab2db.1781093720.git.ritesh.list@gmail.com
> 
> Nicholas Piggin (1):
>   KVM: selftests: Use goto instead of do-while to retry finding unused
>     physical pages
> 
> Sean Christopherson (19):
>   KVM: selftests: Use MEM_REGION_PT memslot instead of '0' for s390
>     regions/segments
>   KVM: selftests: Bump the minimum GPA for page tables to 0x200000
>   KVM: selftests: Use vm_alloc_page_table() to allocate LoongArch page
>     tables
>   KVM: selftests: Rename "num" param to "nr_pages" for physical page
>     allocators
>   KVM: selftests: Extend page allocator to support naturally aligned
>     allocations
>   KVM: selftests: Make the single-page allocator APIs static inline
>   KVM: selftests: Use the innermost page allocator API in the memslot
>     perf test
>   KVM: selftests: Use the innermost page allocator API in s390's IRQ
>     routing test
>   KVM: selftests: Add a wrapper API to allocate multiple page table
>     pages
>   KVM: selftests: Initialize vm->memslots[] with invalid memslots during
>     creation
>   KVM: selftests: Add APIs to override memory region types with custom
>     memslots
>   KVM: selftests: Add TEST_EXTRA memory region type for "special"
>     memslots
>   KVM: selftests: Use TEST_EXTRA region in arm64's vGIC LPI stress test
>   KVM: selftests: Use TEST_EXTRA region in x86's smaller MAXPHYADDR test
>   KVM: selftests: Use TEST_EXTRA region in set memory region test
>   KVM: selftests: Take the memory region type, not memslot, in page
>     allocators
>   KVM: selftests: Use TEST_ASSERT(), not assert(), in
>     vm_get_mem_region()
>   KVM: selftests: Automatically pick min_gpa for allocations based on
>     region type
>   KVM: selftests: Add arch hook to force page tables to be naturally
>     aligned
> 
>  .../selftests/kvm/arm64/page_fault_test.c     |  18 ++-
>  .../selftests/kvm/arm64/vgic_lpi_stress.c     |  19 ++-
>  .../testing/selftests/kvm/include/kvm_util.h  | 106 +++++++++++++--
>  tools/testing/selftests/kvm/include/x86/smm.h |   2 +-
>  .../selftests/kvm/lib/arm64/processor.c       |   4 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 127 +++++++++++-------
>  .../selftests/kvm/lib/loongarch/processor.c   |   5 +-
>  .../selftests/kvm/lib/riscv/processor.c       |   4 +-
>  .../selftests/kvm/lib/s390/processor.c        |   7 +-
>  .../testing/selftests/kvm/lib/x86/processor.c |  15 ++-
>  .../testing/selftests/kvm/memslot_perf_test.c |   3 +-
>  tools/testing/selftests/kvm/s390/cmma_test.c  |  19 +--
>  .../testing/selftests/kvm/s390/irq_routing.c  |   2 +-
>  .../selftests/kvm/set_memory_region_test.c    |   8 +-
>  .../x86/smaller_maxphyaddr_emulation_test.c   |   9 +-
>  15 files changed, 219 insertions(+), 129 deletions(-)
> 
> 
> base-commit: 76671054f9a1ff6abb976583cd8da37650acdc97
> -- 
> 2.55.0.887.g758fc8c411-goog
> 

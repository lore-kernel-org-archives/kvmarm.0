Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C943E44EC
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 07:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783582573; cv=none; b=bDZb6r1RO+z5rOTJcQcIZkzK//ke1ilEUhxuv5fQSZKnhCwcu7bomC78UeJ3HAnB06dIOkFOmjCtLFQ2aV5FUi2p1omL2ONCTkvmfiMuw7NVwaiidVf689whS7qjYtq8Hc/8CoOrJQCEnkI6YHyTeLVZfjS3c5baAVLgG9fJHes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783582573; c=relaxed/simple;
	bh=E4bCVlb46K+E7Etx51AHeLIHo1jVe+mkYB5G49FAWJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVqi6NpFN6jN6y1Q3VGXhQ15x2ZsM/2OSjgTI06u7kvKqFcyYt1+h4bQQZ8fub/Plarbv1FxrhnuT/eBnZsBojV/1ovGabTwkTEmWCLZN5FhX0HJfr8WXiFjPycy+3Lz+xXNSZBjPL9s76/pBzMND2Ng1xcvPcoXfEI2bLdAdiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=EfeR4RHj; arc=none smtp.client-ip=139.138.61.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="EfeR4RHj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1783582570; x=1815118570;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E4bCVlb46K+E7Etx51AHeLIHo1jVe+mkYB5G49FAWJw=;
  b=EfeR4RHjTD7mowHXWT7i/DNR/Geeub56uIvKAgey5cqkSPEpt48SkNos
   wBVdPFVqHr184crc4mFOg0y1EEk7zjF+1mPP8r0HIhz1+wh65rEGocsMR
   0lZNJRrwYLpEcXhOLP/3eiI26GoGIksAiZ/3IUYeKRosmn7XViN6o21yg
   Ca/x372D3smbdbO/gOwou6PELl5+BRz2y+pMXFZQTfG+PgG3V26nOWTsg
   qIsW+2ezvszjP945joAiiV8FrCLuQRL8Cm1CI0EzlJMrVotcEi0cRi7pT
   C4RrabKhGdoWBrvPzircTcpzqaS2n47ULWIV/Bq4ikwRdCmMLLvppJFlZ
   g==;
X-CSE-ConnectionGUID: nmW8LoUeQX+Gcpmhg+wV1g==
X-CSE-MsgGUID: A6eYL1uiROeCxmZgYfAhDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="234769274"
X-IronPort-AV: E=Sophos;i="6.25,154,1779116400"; 
   d="scan'208";a="234769274"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 16:35:00 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 2F6C11000154
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 07:35:00 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (unknown [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id D413C1C2FB97
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 07:34:59 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom2.o.css.fujitsu.com (Postfix) with ESMTPS id 3A9AC1406396;
	Thu,  9 Jul 2026 07:34:55 +0000 (UTC)
Date: Thu, 9 Jul 2026 16:34:52 +0900
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
Subject: Re: [PATCH v2 0/6] KVM: arm64: ptdump: Shadow ptdump fixes
Message-ID: <ak9PHJJzjliTeiFB@sm-arm-grace07>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
 <akYLdEuPXEGIZx3E@sm-arm-grace07>
 <vfzn6kbhyemhkum2s72yucbgj4shn7j3g7qd3iima242yph2fr@vdihx2sfibki>
 <akbuIDmd_zH9_m6K@sm-arm-grace07>
 <nzvizmyxj4otyo5itl425vdflimp6pnkuwo4qtwzzsbjobhzco@ygxydualln47>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nzvizmyxj4otyo5itl425vdflimp6pnkuwo4qtwzzsbjobhzco@ygxydualln47>

On Fri, Jul 03, 2026 at 11:24:53AM +0100, Wei-Lin Chang wrote:
> On Fri, Jul 03, 2026 at 08:02:56AM +0900, Itaru Kitayama wrote:
> > On Thu, Jul 02, 2026 at 08:41:43AM +0100, Wei-Lin Chang wrote:
> > > On Thu, Jul 02, 2026 at 03:55:48PM +0900, Itaru Kitayama wrote:
> > > > Hi Wei-Lin,
> > > > On Tue, Jun 30, 2026 at 01:09:59PM +0100, Wei-Lin Chang wrote:
> > > > > Hi,
> > > > > 
> > > > > This is v2 of fixing shadow ptdump debugfs files. Unfortunately I couldn't make
> > > > > per mmu ptdump files work after all, mainly because there isn't a clean way to
> > > > > locate the specific nested mmu for each ptdump file as the nested mmus could be
> > > > > freed when the file gets opened. Therefore in this series a single file
> > > > > "shadow_page_tables" is created that dumps all valid mmus' page table
> > > > > information.
> > > > > 
> > > > > An advantage of this is that this new ptdump file have a lifetime identical to
> > > > > other ptdump files i.e. stage2_page_tables, ipa_range, etc., hence avoiding the
> > > > > dentry UAF found last time [1].
> > > > > 
> > > > > With this all ptdump files are only removed when the last kvm reference gets
> > > > > dropped and kvm_destroy_vm_debugfs() is called, in their open(), show()
> > > > > functions the nested mmu array and mmu->pgt are checked with mmu_lock held to
> > > > > prevent UAF.
> > > > > 
> > > > > Patch 1-2: Undo previous shadow ptdump implementation.
> > > > > Patch 3:   Fix a mmu->pgt UAF that happens when ptdump files are read after
> > > > >            mmu->pgt is freed.
> > > > > Patch 4-5: Preparation for the shadow page table dump file.
> > > > > Patch 6:   Implementation of the shadow page table dump file.
> > > > > 
> > > > > The fixes are tested with CONFIG_PROVE_LOCKING,
> > > > > CONFIG_DEBUG_ATOMIC_SLEEP, and CONFIG_KASAN.
> > > > > 
> > > > > Thanks!
> > > > 
> > > > Running your shadow stage 2 kselftest with bpftrace shows me that __kvm_pgtable_stage2_init()
> > > > for shadow stage 2 translation tables are built with ia_bits = 52 and
> > > > start_level = 0, but the debugfs entry for the active shadow stage 2 tables prints
> > > > out that's 3 levels. Is this fully expected?
> > > 
> > > Where is this level information you are seeing from? If it is
> > > "stage2_level", that only reports the number of levels for the canonical
> > > stage-2 (non nested). For nested mmus only the page tables are dumped in
> > > nested/shadow_page_tables.
> > 
> > Yes I know. The initial stage 2 translation table structure information is obtained by 
> > instrumenting the kernel using eBPF fexit to __kvm_pgtable_stage2_init().
> > 
> > Since you're correctly loopin over nested_mmus array, and the output is
> > correctly shown using the kvm_pgtable information via the kvm_s2_mmu for
> > them, I am confused at this moment.
> 
> Two things here:
> 
> Firstly ia_bits being 52 is not expected to me, as I didn't change the
> VM's IPA size via KVM_VM_TYPE_ARM_IPA_SIZE in the selftest, to me I
> would expect ia_bits to be 40 (the default). Start level being 0 looks
> normal.

Instrumenting the ptdump code you're proposing I see the shadow stage 2
translation tables are constructed with the max 52-bit IPA; irrespective
of the IPA bits set in the init_s2_mmu() helper for the guest hypervisor
setup in the selftest, I am guessing here to me fixed? 52-bit IPA size 
because it's awkward if nestd guest's IPA size is larger than the shadow 
stage 2's IPA size.

I confirmed using the __vm_create() helper with various guest modes
supported that canonical stage 2's "ipa_range" changes according to the 
guest (L1) PA size so I wonder if it is a good idea to create something like
shadow_ipa_range and shadow_stage2_levels files under nested directoy.

Thanks,
Itaru.

> 
> Second thing is I still can't get what you are confused about, if it's
> not about the first point. Note that the "3" in ptdump means it is a
> level 3 mapping, not saying the page tables are using 3 levels.
> 
> Happy to discuss more if you clarify. I'll also check the ia_bits when I
> get to it.
> 
> Thanks,
> Wei-Lin Chang
> 
> > 
> > Thanks,
> > Itaru.
> > 
> > > 
> > > Thanks,
> > > Wei-Lin Chang
> > > 
> > > > 
> > > > Thanks,
> > > > Itaru.
> > > > 
> > > > > 
> > > > > * Changes from v1 ([2]):
> > > > > 
> > > > >   - Move from per mmu ptdump files to one file that will dump all shadow page
> > > > >     tables.
> > > > > 
> > > > > [1]: https://lore.kernel.org/kvmarm/ajty6I7ZqodP4ous@sm-arm-grace07/
> > > > > [2]: https://lore.kernel.org/kvmarm/20260623142443.648972-1-weilin.chang@arm.com/
> > > > > 
> > > > > Wei-Lin Chang (6):
> > > > >   KVM: arm64: ptdump: Remove shadow ptdump files
> > > > >   KVM: arm64: ptdump: Undo making the ptdump code mmu aware
> > > > >   KVM: arm64: ptdump: Fix UAF when mmu->pgt is freed
> > > > >   KVM: arm64: ptdump: Factor out initialization of
> > > > >     kvm_ptdump_guest_state
> > > > >   KVM: arm64: ptdump: Extract kvm_ptdump_guest_open() from canonical
> > > > >     ptdump path
> > > > >   KVM: arm64: ptdump: Introduce the shadow ptdump file
> > > > > 
> > > > >  arch/arm64/include/asm/kvm_host.h |   5 +-
> > > > >  arch/arm64/include/asm/kvm_mmu.h  |   4 -
> > > > >  arch/arm64/kvm/nested.c           |  18 +--
> > > > >  arch/arm64/kvm/ptdump.c           | 185 ++++++++++++++++++++----------
> > > > >  4 files changed, 135 insertions(+), 77 deletions(-)
> > > > > 
> > > > > -- 
> > > > > 2.43.0
> > > > > 

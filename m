Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E39377006
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 23:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783033457; cv=none; b=TJHRCSaf+pi0KZlXLJSIULlU6qFlvju1BHYv+3ef7SZmKWAwmPiqNrKyAaCZ0KwBj2uXUds/zLJohi/weyBKI1J75fTFgXPno3u1By4Di43vDroM7E+z5HsKa1yQWhj9oZ9dMBTtrYECljn6gx/c63xbIJrwBe3IkXIdfd1tdeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783033457; c=relaxed/simple;
	bh=SzSr1oCqgTulCTXhvORBDKf3m8KOYxNNU1XaE1bIAds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7VSLcIn6w7Hq/Ahi+NDs2aylvhqM5QWcvl6B9K9lnRa0sYFuuhbUehZrFNxRgpYblCDgik/Ciq28S89V3m5giih7ZT1IX60W7ja6J8nWMhSg6X+c6mAabPnEVjIXPO/J9Q1BKVHl0w8OP3CpClmpRKXNDBOv8r/11zj8PIe9Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Zou+f/3x; arc=none smtp.client-ip=139.138.61.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Zou+f/3x"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1783033456; x=1814569456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SzSr1oCqgTulCTXhvORBDKf3m8KOYxNNU1XaE1bIAds=;
  b=Zou+f/3xKbhJWoEw+/553g4AQ27y3DSzeaN4/7bCSWtciMIudwTdEZNq
   /dNITwfMLp8pOdCuL0/Q1wcG7P3lsL3ZiftfVK9tg/cvNcUygDJLgDnRo
   OlT5mmGzl1DlDkrLGGe3n2ShUT+iyMt+atGHUHqi3G4QY4npAu3LMXRme
   0kQPDmGm4crE09aAjQLGrqm0PbozSLegHIckygbK7Hnp0x/4fDnuuJPzQ
   huL1hkKwIRf9WVcRDGsTPrG0EidTTgKfkhtYD/EytNhD6V5LAKsCQ5Ggw
   wgBQOBgsf+D+r/bcvCp7S8jOJY14m8CehKFO2BtQJXZRFGMUBIGHH3bmk
   A==;
X-CSE-ConnectionGUID: AB11NX/ZSHOhAW94D8zHNA==
X-CSE-MsgGUID: zQOFqf6ISOmbobCO83tTbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="225009869"
X-IronPort-AV: E=Sophos;i="6.25,144,1779116400"; 
   d="scan'208";a="225009869"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 08:03:04 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id B90841C1C707
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 23:03:04 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 70E7CC02F16
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 23:03:04 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 924EA40261C;
	Thu,  2 Jul 2026 23:02:59 +0000 (UTC)
Date: Fri, 3 Jul 2026 08:02:56 +0900
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
Message-ID: <akbuIDmd_zH9_m6K@sm-arm-grace07>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
 <akYLdEuPXEGIZx3E@sm-arm-grace07>
 <vfzn6kbhyemhkum2s72yucbgj4shn7j3g7qd3iima242yph2fr@vdihx2sfibki>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vfzn6kbhyemhkum2s72yucbgj4shn7j3g7qd3iima242yph2fr@vdihx2sfibki>

On Thu, Jul 02, 2026 at 08:41:43AM +0100, Wei-Lin Chang wrote:
> On Thu, Jul 02, 2026 at 03:55:48PM +0900, Itaru Kitayama wrote:
> > Hi Wei-Lin,
> > On Tue, Jun 30, 2026 at 01:09:59PM +0100, Wei-Lin Chang wrote:
> > > Hi,
> > > 
> > > This is v2 of fixing shadow ptdump debugfs files. Unfortunately I couldn't make
> > > per mmu ptdump files work after all, mainly because there isn't a clean way to
> > > locate the specific nested mmu for each ptdump file as the nested mmus could be
> > > freed when the file gets opened. Therefore in this series a single file
> > > "shadow_page_tables" is created that dumps all valid mmus' page table
> > > information.
> > > 
> > > An advantage of this is that this new ptdump file have a lifetime identical to
> > > other ptdump files i.e. stage2_page_tables, ipa_range, etc., hence avoiding the
> > > dentry UAF found last time [1].
> > > 
> > > With this all ptdump files are only removed when the last kvm reference gets
> > > dropped and kvm_destroy_vm_debugfs() is called, in their open(), show()
> > > functions the nested mmu array and mmu->pgt are checked with mmu_lock held to
> > > prevent UAF.
> > > 
> > > Patch 1-2: Undo previous shadow ptdump implementation.
> > > Patch 3:   Fix a mmu->pgt UAF that happens when ptdump files are read after
> > >            mmu->pgt is freed.
> > > Patch 4-5: Preparation for the shadow page table dump file.
> > > Patch 6:   Implementation of the shadow page table dump file.
> > > 
> > > The fixes are tested with CONFIG_PROVE_LOCKING,
> > > CONFIG_DEBUG_ATOMIC_SLEEP, and CONFIG_KASAN.
> > > 
> > > Thanks!
> > 
> > Running your shadow stage 2 kselftest with bpftrace shows me that __kvm_pgtable_stage2_init()
> > for shadow stage 2 translation tables are built with ia_bits = 52 and
> > start_level = 0, but the debugfs entry for the active shadow stage 2 tables prints
> > out that's 3 levels. Is this fully expected?
> 
> Where is this level information you are seeing from? If it is
> "stage2_level", that only reports the number of levels for the canonical
> stage-2 (non nested). For nested mmus only the page tables are dumped in
> nested/shadow_page_tables.

Yes I know. The initial stage 2 translation table structure information is obtained by 
instrumenting the kernel using eBPF fexit to __kvm_pgtable_stage2_init().

Since you're correctly loopin over nested_mmus array, and the output is
correctly shown using the kvm_pgtable information via the kvm_s2_mmu for
them, I am confused at this moment.

Thanks,
Itaru.

> 
> Thanks,
> Wei-Lin Chang
> 
> > 
> > Thanks,
> > Itaru.
> > 
> > > 
> > > * Changes from v1 ([2]):
> > > 
> > >   - Move from per mmu ptdump files to one file that will dump all shadow page
> > >     tables.
> > > 
> > > [1]: https://lore.kernel.org/kvmarm/ajty6I7ZqodP4ous@sm-arm-grace07/
> > > [2]: https://lore.kernel.org/kvmarm/20260623142443.648972-1-weilin.chang@arm.com/
> > > 
> > > Wei-Lin Chang (6):
> > >   KVM: arm64: ptdump: Remove shadow ptdump files
> > >   KVM: arm64: ptdump: Undo making the ptdump code mmu aware
> > >   KVM: arm64: ptdump: Fix UAF when mmu->pgt is freed
> > >   KVM: arm64: ptdump: Factor out initialization of
> > >     kvm_ptdump_guest_state
> > >   KVM: arm64: ptdump: Extract kvm_ptdump_guest_open() from canonical
> > >     ptdump path
> > >   KVM: arm64: ptdump: Introduce the shadow ptdump file
> > > 
> > >  arch/arm64/include/asm/kvm_host.h |   5 +-
> > >  arch/arm64/include/asm/kvm_mmu.h  |   4 -
> > >  arch/arm64/kvm/nested.c           |  18 +--
> > >  arch/arm64/kvm/ptdump.c           | 185 ++++++++++++++++++++----------
> > >  4 files changed, 135 insertions(+), 77 deletions(-)
> > > 
> > > -- 
> > > 2.43.0
> > > 

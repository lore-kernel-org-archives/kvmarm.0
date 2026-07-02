Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AC638E5ED
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 06:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.37.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782975428; cv=none; b=XOuH7X6Ycf+2cuwddyaFMBgDG3XXq7u2saqo23n8gJ6TXx3LnpWNwq5dA3awWea5jWHr90GbsTE271imKM7puKwAIqffC/N862fuM6UaFOUUk37e34jVxTHzuvRfvvM8n8wCSMPZFeDoZW2/y5yY3ehgzYdbzQeaTeLI2+vsS/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782975428; c=relaxed/simple;
	bh=L9PbSvEFuUfcy0PIfWMDM+t+H7IAPxaTJxbuKn8F0f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oO2Op+xMDbLWKVVIxJ8Az+SJBkUSN5zO/fvR+CMwjCdyGFJBP+cca8O3I8MU0iYL3hQbLRLnitKHVaHsKlnf9qCA57IW0a0mrcOCWN1c6uKIms2Tj9l9zs5/O1dpZ5izF88Icwth0MT42SdbgM89m4veN6EdvQg5X/jB7ICf/XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=bfwoTG4X; arc=none smtp.client-ip=139.138.37.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="bfwoTG4X"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1782975426; x=1814511426;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L9PbSvEFuUfcy0PIfWMDM+t+H7IAPxaTJxbuKn8F0f4=;
  b=bfwoTG4Xwh74Ly7zxVf0RYQ68bFMqcIX2NenpPK6dZlWm+z1MuF1PFkP
   XtoLKjpY3yelo8BRhLfPRKcHqS1r0Rbfy0RedKY/qxIOwJhjrLai5xeg6
   R1xSmvvlPbh3fwJnXNuz63ehtkPTc233Bi4yU0mVa1eg9yeRXQaiEUevI
   9xYyYSVkUiNR0FRQrUX0eM/2NgltkOdIP3ETYJwq6CquTD3LTs+QYD5Mx
   YHyVpP/fZ1snizNut/tQfPBOsQcjvbw7yb/6cAvKQTxZ4UzPbzKIHUjBB
   Tlk3kwRPAz2WpLAmHDLvuO5g/jurK8eg8eISZYaOPw8GEEsyyJpP+ARUD
   A==;
X-CSE-ConnectionGUID: ee8kzbcAQHGvr8xA+bPL6Q==
X-CSE-MsgGUID: kpGTRp6CT1WBgCRspDWvUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="223763851"
X-IronPort-AV: E=Sophos;i="6.25,143,1779116400"; 
   d="scan'208";a="223763851"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 15:55:57 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id CE3C01002820
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 06:55:56 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 859B0826794
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 06:55:56 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTPS id 549911802EFD;
	Thu,  2 Jul 2026 06:55:51 +0000 (UTC)
Date: Thu, 2 Jul 2026 15:55:48 +0900
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
Message-ID: <akYLdEuPXEGIZx3E@sm-arm-grace07>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630121005.1130996-1-weilin.chang@arm.com>

Hi Wei-Lin,
On Tue, Jun 30, 2026 at 01:09:59PM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> This is v2 of fixing shadow ptdump debugfs files. Unfortunately I couldn't make
> per mmu ptdump files work after all, mainly because there isn't a clean way to
> locate the specific nested mmu for each ptdump file as the nested mmus could be
> freed when the file gets opened. Therefore in this series a single file
> "shadow_page_tables" is created that dumps all valid mmus' page table
> information.
> 
> An advantage of this is that this new ptdump file have a lifetime identical to
> other ptdump files i.e. stage2_page_tables, ipa_range, etc., hence avoiding the
> dentry UAF found last time [1].
> 
> With this all ptdump files are only removed when the last kvm reference gets
> dropped and kvm_destroy_vm_debugfs() is called, in their open(), show()
> functions the nested mmu array and mmu->pgt are checked with mmu_lock held to
> prevent UAF.
> 
> Patch 1-2: Undo previous shadow ptdump implementation.
> Patch 3:   Fix a mmu->pgt UAF that happens when ptdump files are read after
>            mmu->pgt is freed.
> Patch 4-5: Preparation for the shadow page table dump file.
> Patch 6:   Implementation of the shadow page table dump file.
> 
> The fixes are tested with CONFIG_PROVE_LOCKING,
> CONFIG_DEBUG_ATOMIC_SLEEP, and CONFIG_KASAN.
> 
> Thanks!

Running your shadow stage 2 kselftest with bpftrace shows me that __kvm_pgtable_stage2_init()
for shadow stage 2 translation tables are built with ia_bits = 52 and
start_level = 0, but the debugfs entry for the active shadow stage 2 tables prints
out that's 3 levels. Is this fully expected?

Thanks,
Itaru.

> 
> * Changes from v1 ([2]):
> 
>   - Move from per mmu ptdump files to one file that will dump all shadow page
>     tables.
> 
> [1]: https://lore.kernel.org/kvmarm/ajty6I7ZqodP4ous@sm-arm-grace07/
> [2]: https://lore.kernel.org/kvmarm/20260623142443.648972-1-weilin.chang@arm.com/
> 
> Wei-Lin Chang (6):
>   KVM: arm64: ptdump: Remove shadow ptdump files
>   KVM: arm64: ptdump: Undo making the ptdump code mmu aware
>   KVM: arm64: ptdump: Fix UAF when mmu->pgt is freed
>   KVM: arm64: ptdump: Factor out initialization of
>     kvm_ptdump_guest_state
>   KVM: arm64: ptdump: Extract kvm_ptdump_guest_open() from canonical
>     ptdump path
>   KVM: arm64: ptdump: Introduce the shadow ptdump file
> 
>  arch/arm64/include/asm/kvm_host.h |   5 +-
>  arch/arm64/include/asm/kvm_mmu.h  |   4 -
>  arch/arm64/kvm/nested.c           |  18 +--
>  arch/arm64/kvm/ptdump.c           | 185 ++++++++++++++++++++----------
>  4 files changed, 135 insertions(+), 77 deletions(-)
> 
> -- 
> 2.43.0
> 

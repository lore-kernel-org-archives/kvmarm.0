Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD7539479F
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 07:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782978129; cv=none; b=Cm/W4HPsHO8DTe27SPobaEJzU6D4dyjFhXNefQQtd7DWYl8BaqGy9OUkQx6GYUqTQW6dHMglolvbRPRlMTCO/Z+9A3sdUDT3ByHofEU5uLiDMXplqqrlTE+nYtonoWg9FIFhrjbuhIKNLUnoQnlw6SF5uW8/CRHPWg6pV0Xu7Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782978129; c=relaxed/simple;
	bh=DPzfo6/w+ULEP1PseWJbMhgHybRliNbNTvQjB2jqyGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pi82Ktxqcu+6bbYEnK8zNxV3aIxZSVuSWOqaCuAjUqwBUNzOtXw4g97y1xSDrpN7qrncEwfGC3271yu36jWStAVpgL1cL45JCd0oSgNGCOaXguSqmJ0Iwb5A7LPQD5CXxHPaLgUEZs2N9afkT57nCWzN8jVoxnoEuesx26UyUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c8Gtrz9D; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c8Gtrz9D"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 026C8288E;
	Thu,  2 Jul 2026 00:42:01 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 307CA3F85F;
	Thu,  2 Jul 2026 00:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782978125; bh=DPzfo6/w+ULEP1PseWJbMhgHybRliNbNTvQjB2jqyGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c8Gtrz9D82PDtqc+9tsHSuV/kv/KTXFr41Tx6UUyVGL3vCTtsynONLT5HPkP/YK1U
	 Oj7wS2TVn5u2PM90po5FDjIMhnm72OWFfvNhkWIlD7b9OATWlEZ5fuEbE/N+7mrX3x
	 xQKn0Qcn4cCxI2+d4YZt0stj0pIe4NNXnca7JXNI=
Date: Thu, 2 Jul 2026 08:41:43 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 0/6] KVM: arm64: ptdump: Shadow ptdump fixes
Message-ID: <vfzn6kbhyemhkum2s72yucbgj4shn7j3g7qd3iima242yph2fr@vdihx2sfibki>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
 <akYLdEuPXEGIZx3E@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akYLdEuPXEGIZx3E@sm-arm-grace07>

On Thu, Jul 02, 2026 at 03:55:48PM +0900, Itaru Kitayama wrote:
> Hi Wei-Lin,
> On Tue, Jun 30, 2026 at 01:09:59PM +0100, Wei-Lin Chang wrote:
> > Hi,
> > 
> > This is v2 of fixing shadow ptdump debugfs files. Unfortunately I couldn't make
> > per mmu ptdump files work after all, mainly because there isn't a clean way to
> > locate the specific nested mmu for each ptdump file as the nested mmus could be
> > freed when the file gets opened. Therefore in this series a single file
> > "shadow_page_tables" is created that dumps all valid mmus' page table
> > information.
> > 
> > An advantage of this is that this new ptdump file have a lifetime identical to
> > other ptdump files i.e. stage2_page_tables, ipa_range, etc., hence avoiding the
> > dentry UAF found last time [1].
> > 
> > With this all ptdump files are only removed when the last kvm reference gets
> > dropped and kvm_destroy_vm_debugfs() is called, in their open(), show()
> > functions the nested mmu array and mmu->pgt are checked with mmu_lock held to
> > prevent UAF.
> > 
> > Patch 1-2: Undo previous shadow ptdump implementation.
> > Patch 3:   Fix a mmu->pgt UAF that happens when ptdump files are read after
> >            mmu->pgt is freed.
> > Patch 4-5: Preparation for the shadow page table dump file.
> > Patch 6:   Implementation of the shadow page table dump file.
> > 
> > The fixes are tested with CONFIG_PROVE_LOCKING,
> > CONFIG_DEBUG_ATOMIC_SLEEP, and CONFIG_KASAN.
> > 
> > Thanks!
> 
> Running your shadow stage 2 kselftest with bpftrace shows me that __kvm_pgtable_stage2_init()
> for shadow stage 2 translation tables are built with ia_bits = 52 and
> start_level = 0, but the debugfs entry for the active shadow stage 2 tables prints
> out that's 3 levels. Is this fully expected?

Where is this level information you are seeing from? If it is
"stage2_level", that only reports the number of levels for the canonical
stage-2 (non nested). For nested mmus only the page tables are dumped in
nested/shadow_page_tables.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Itaru.
> 
> > 
> > * Changes from v1 ([2]):
> > 
> >   - Move from per mmu ptdump files to one file that will dump all shadow page
> >     tables.
> > 
> > [1]: https://lore.kernel.org/kvmarm/ajty6I7ZqodP4ous@sm-arm-grace07/
> > [2]: https://lore.kernel.org/kvmarm/20260623142443.648972-1-weilin.chang@arm.com/
> > 
> > Wei-Lin Chang (6):
> >   KVM: arm64: ptdump: Remove shadow ptdump files
> >   KVM: arm64: ptdump: Undo making the ptdump code mmu aware
> >   KVM: arm64: ptdump: Fix UAF when mmu->pgt is freed
> >   KVM: arm64: ptdump: Factor out initialization of
> >     kvm_ptdump_guest_state
> >   KVM: arm64: ptdump: Extract kvm_ptdump_guest_open() from canonical
> >     ptdump path
> >   KVM: arm64: ptdump: Introduce the shadow ptdump file
> > 
> >  arch/arm64/include/asm/kvm_host.h |   5 +-
> >  arch/arm64/include/asm/kvm_mmu.h  |   4 -
> >  arch/arm64/kvm/nested.c           |  18 +--
> >  arch/arm64/kvm/ptdump.c           | 185 ++++++++++++++++++++----------
> >  4 files changed, 135 insertions(+), 77 deletions(-)
> > 
> > -- 
> > 2.43.0
> > 

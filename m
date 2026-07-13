Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA4030D3EF
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783960043; cv=none; b=oYvg03FoR84vrwfG4sS26wRPKQse1t0VjZ1kbZryO/NrcPN0zSGY4b9pJ8rsm4e4DjoqnfLZ7GUK9H9gC/x6xSsJ0xWyMaieSG1eGk4AKBV4PiDjVXxPq3uexxQ7Ey+AQp8PLadvYkunW+s4T7zTf3uYgbD/xtY5j93MGADJmRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783960043; c=relaxed/simple;
	bh=9/dA430eBn0wUibKGs9m2V3IKUxqPP4CnsyZ/vCU/qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=oLa1P4tWDGA4qnMBzHN56qgUALX1SCR6G7f9w5tLHtjBIs9y6DIy7blsO7Tcja3C8u9l1ANKZRmayAh6oHS8QQrYPE+WqJEItwpWKMl4f5BwgbJe1Y+L9cF4Ew81J7Eo7VNlnrYndLn9Zz4At8cixkxy3JGtn/2OVgSmtc6s3Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rQArY0Lh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rQArY0Lh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 481831576;
	Mon, 13 Jul 2026 09:27:14 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F11D3F7B4;
	Mon, 13 Jul 2026 09:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783960038; bh=9/dA430eBn0wUibKGs9m2V3IKUxqPP4CnsyZ/vCU/qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQArY0LhHeb5W5EWwG94eauzoEVyWqhOvcyOeLx/rgVIDDk4KOvti1M6f+btBGsce
	 9Aq68e0rcryOv5o8bxmt7e2c2/4tLhdeESV1+y3iEq1pUSBzfo/TlFlLDcKGnWuyd5
	 GmS527v7pbeRChy4Kt/+Q+CYJzF2OsnvKYeFJu6s=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v4 0/6] Support the FEAT_HDBSS introduced in Armv9.5
Date: Mon, 13 Jul 2026 17:27:09 +0100
Message-ID: <alUR3ez1EKeWb_pM@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <alS-kcwvlASwPIzL@LeoBrasDK>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <alS-kcwvlASwPIzL@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 13, 2026 at 11:31:46AM +0100, Leonardo Bras wrote:
> On Thu, Jul 09, 2026 at 06:40:20PM +0800, Tian Zheng wrote:
> > This series of patches add support to the Hardware Dirty state tracking
> > Structure (HDBSS) feature, which is introduced by the ARM architecture
> > in the DDI0601 (ID121123) version.
> > 
> > The HDBSS feature is an extension to the architecture that enhances
> > tracking translation table descriptors' dirty state, identified as
> > FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
> > page tracking, aiming to significantly reduce the overhead of scanning
> > for dirty pages.
> > 
> > The purpose of this feature is to make the execution overhead of live
> > migration lower to both the guest and the host, compared to existing
> > approaches (write-protect or search stage-2 tables).
> > 
> > The required sysreg definitions for FEAT_HDBSS have been merged into
> > arm64 /sysregs:
> >   [1/5] arm64/sysreg: Add HDBSS related register information
> >         https://git.kernel.org/arm64/c/72f7be0c2e30
> > 
> > 
> > After these patches, the kernel automatically enables HDBSS when dirty
> > logging is enabled on any memslot, and disables HDBSS when dirty logging
> > is disabled on all memslots. This series does not support dirty ring
> > mode.
> > 
> > Depends-on: "KVM: arm64: Enable eager hugepage splitting if HDBSS is available"
> > 	https://lore.kernel.org/linux-arm-kernel/20260629111820.1873540-3-leo.bras@arm.com/
> 
> On this, FYI, there have been some discussion on this:
> https://lore.kernel.org/all/alETGFD2Ogx6N0HB@LeoBrasDK/
> 
> Oliver's suggestion is that we don't automatically enable eager splitting, 
> but instead we have different behaviours if the user enables it.
> 
> This is still under discussion there, but I think it can be useful reading. 
> 
> > 
> > This dependency is mandatory. Unlike v3, where DBM was added lazily on
> > the first dirty access via a page fault, v4 injects DBM into pgt->flags
> > at stage-2 MMU initialization time. Combined with HDBSS being auto-enabled
> > during migration setup, the first dirty access no longer triggers a page
> > fault. Consequently, if lazy hugepage splitting were relied upon (which
> > requires a page fault to trigger splitting), hugepages would never be
> > split, leading to guest hang after migration. Leonardo's patch above
> > ensures eager hugepage splitting is enabled (chunk_size != 0) when HDBSS
> > is available, guaranteeing that hugepages are properly split before
> > migration starts.
> > 
> > v3: https://lore.kernel.org/linux-arm-kernel/20260225040421.2683931-1-zhengtian10@huawei.com/
> > 
> > v3->v4 changes:
> > - Merge sysreg definitions into the FEAT_HDBSS detection patch (was a
> >   separate patch in v3).
> > - Add auto DBM (Dirty Bit Modifier) support as a new patch, suggested
> >   by Leonardo Bras. DBM is now controlled as a page-table level flag
> >   (KVM_PGTABLE_S2_DBM) rather than per-PTE. Note that DBM is injected
> >   at stage-2 MMU creation time, not lazily on first dirty access. This
> >   means the first write to a dirty-logged page does not generate a
> >   page fault, which is a key reason for the mandatory dependency on
> >   Leonardo's eager hugepage splitting patch (see Depends-on above).
> > - Split the v3 "Enable HDBSS support and handle HDBSSF events" patch
> >   into three patches: per-vCPU buffer management, fault handling and
> >   buffer flush, and auto enable/disable on dirty logging change. This
> >   implements kernel-managed automatic HDBSS enable/disable.
> > - Remove the KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl for manual HDBSS
> >   on/off. HDBSS is now automatically enabled/disabled based on dirty
> >   logging state via kvm_arch_commit_memory_region().
> > - Change HDBSS buffer flush triggers to vcpu_put, check_vcpu_requests,
> >   and kvm_handle_guest_abort.
> > - Store hdbss_order at VM level (kvm->arch.hdbss_order) instead of
> >   per-vCPU, since all vCPUs share the same order.
> > - Document patch is not included in this version; will be sent in a
> >   follow-up series.
> > 
> > Leonardo Bras (1):
> >   KVM: arm64: Enable eager hugepage splitting if HDBSS is available
> > 
> > Tian Zheng (2):
> >   KVM: arm64: Add support for FEAT_HDBSS
> >   KVM: arm64: Add auto DBM support for hardware dirty tracking
> > 
> > eillon (3):
> >   KVM: arm64: Add HDBSS per-vCPU buffer management
> >   KVM: arm64: Add HDBSS fault handling and buffer flush
> >   KVM: arm64: Add auto HDBSS enable/disable on dirty logging change
> > 
> >  arch/arm64/include/asm/cpufeature.h    |   5 +
> >  arch/arm64/include/asm/esr.h           |   5 +
> >  arch/arm64/include/asm/kvm_dirty_bit.h |  29 ++++
> >  arch/arm64/include/asm/kvm_host.h      |  14 ++
> >  arch/arm64/include/asm/kvm_pgtable.h   |   4 +
> >  arch/arm64/include/asm/sysreg.h        |  11 ++
> >  arch/arm64/kernel/cpufeature.c         |  12 ++
> >  arch/arm64/kvm/Makefile                |   1 +
> >  arch/arm64/kvm/arm.c                   |  29 ++++
> >  arch/arm64/kvm/dirty_bit.c             | 219 +++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c           |  35 +++-
> >  arch/arm64/kvm/hyp/vhe/switch.c        |  15 ++
> >  arch/arm64/kvm/mmu.c                   |  19 ++-
> >  arch/arm64/kvm/reset.c                 |   4 +
> >  arch/arm64/tools/cpucaps               |   1 +
> >  15 files changed, 399 insertions(+), 4 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
> >  create mode 100644 arch/arm64/kvm/dirty_bit.c
> > 
> > --
> > 2.33.0
> > 

Also, please remember to include the base commit, so it can be applied for 
testing/reviewing.

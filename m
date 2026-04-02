Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F111D3CFF73
	for <kvmarm@lists.linux.dev>; Thu,  2 Apr 2026 12:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775133759; cv=none; b=JybTu8VO8gNZ7oOgBofOlAZl6uhTP4thhI2yXXde1BkHaEmuZde48+sOkSbHD+0Z64gr67o2VUEiJfO9YN4SFelNZHTIQfjkcaSyohVAeSddFfHfeEn7/9n8vS8TktrggUAwP4+wA8qDd/4eC3Hlg1im+smQ8AUFHxoeILQ2SnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775133759; c=relaxed/simple;
	bh=eXuiAgdKHKGDwjhMoJPybkXIHLyx2xl4IR43FDNFuXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=XA4b2YgGv6NM81KAOxdtFxHpVakTwkTfODvLA/uh1KcCWDQwficl+I2gInOA4uIZSI4S2Jib1QpKgQsrRexuKJ3ODXbPvf8KRtE2VdYiY55Sl3ELcH7EXLt+IDw8V+rPDEF+7/22VAje9EGP6kRJb8EkmA6CcxoY/C2VLKtjqE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Mjn/K6ku; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Mjn/K6ku"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2B312C43;
	Thu,  2 Apr 2026 05:42:21 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 534263F915;
	Thu,  2 Apr 2026 05:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775133747; bh=eXuiAgdKHKGDwjhMoJPybkXIHLyx2xl4IR43FDNFuXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mjn/K6kuBcKdeIR3d/RDCeq8IGk9fAR4uLseX84J6PK0lk7X6fvW7GsGpxYK69NPz
	 TagyLFaP67hiiK+hPeAtNGk5rtn59RNu2q84pljWIfC0qxjiqqLoVRn17vHnIWfIIm
	 xNx6D9GvNhQE/O10koxyjTdCvO9Xx4q/DRG6csNA=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	liuyonglong@huawei.com,
	Jonathan.Cameron@huawei.com,
	yezhenyu2@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v3 0/5] Support the FEAT_HDBSS introduced in Armv9.5
Date: Thu,  2 Apr 2026 13:42:17 +0100
Message-ID: <ac5kKQZEnS93qdDm@devkitleo>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <730aaffa-9dfd-40c3-a372-c774d203b6e1@huawei.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com> <acvWnjG0AZBHL21q@devkitleo> <730aaffa-9dfd-40c3-a372-c774d203b6e1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Apr 02, 2026 at 10:40:37AM +0800, Tian Zheng wrote:
> 
> On 3/31/2026 10:13 PM, Leonardo Bras wrote:
> > On Wed, Feb 25, 2026 at 12:04:16PM +0800, Tian Zheng wrote:
> > > This series of patches add support to the Hardware Dirty state tracking
> > > Structure(HDBSS) feature, which is introduced by the ARM architecture
> > > in the DDI0601(ID121123) version.
> > > 
> > > The HDBSS feature is an extension to the architecture that enhances
> > > tracking translation table descriptors' dirty state, identified as
> > > FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
> > > page tracking, aiming to significantly reduce the overhead of scanning
> > > for dirty pages.
> > > 
> > > The purpose of this feature is to make the execution overhead of live
> > > migration lower to both the guest and the host, compared to existing
> > > approaches (write-protect or search stage 2 tables).
> > > 
> > > After these patches, users(such as qemu) can use the
> > > KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl to enable or disable the HDBSS
> > > feature before and after the live migration.
> > > 
> > > v2:
> > > https://lore.kernel.org/linux-arm-kernel/20251121092342.3393318-1-zhengtian10@huawei.com/
> > > 
> > > v2->v3 changes:
> > > - Remove the ARM64_HDBSS configuration option and ensure this feature
> > > is only enabled in VHE mode.
> > > - Move HDBSS-related variables to the arch-independent portion of the
> > > kvm structure.
> > > - Remove error messages during HDBSS enable/disable operations
> > > - Change HDBSS buffer flushing from handle_exit to vcpu_put,
> > > check_vcpu_requests, and kvm_handle_guest_abort.
> > > - Add fault handling for HDBSS including buffer full, external abort,
> > > and general protection fault (GPF).
> > > - Add support for a 4KB HDBSS buffer size, mapped to the value 0b0000.
> > > - Add a second argument to the ioctl to turn HDBSS on or off.
> > > 
> > > Tian Zheng (1):
> > >    KVM: arm64: Document HDBSS ioctl
> > > 
> > > eillon (4):
> > >    arm64/sysreg: Add HDBSS related register information
> > >    KVM: arm64: Add support to set the DBM attr during memory abort
> > >    KVM: arm64: Add support for FEAT_HDBSS
> > >    KVM: arm64: Enable HDBSS support and handle HDBSSF events
> > > 
> > >   Documentation/virt/kvm/api.rst       |  16 +++++
> > >   arch/arm64/include/asm/cpufeature.h  |   5 ++
> > >   arch/arm64/include/asm/esr.h         |   7 ++
> > >   arch/arm64/include/asm/kvm_host.h    |  17 +++++
> > >   arch/arm64/include/asm/kvm_mmu.h     |   1 +
> > >   arch/arm64/include/asm/kvm_pgtable.h |   4 ++
> > >   arch/arm64/include/asm/sysreg.h      |  11 +++
> > >   arch/arm64/kernel/cpufeature.c       |  12 ++++
> > >   arch/arm64/kvm/arm.c                 | 102 +++++++++++++++++++++++++++
> > >   arch/arm64/kvm/hyp/pgtable.c         |   6 ++
> > >   arch/arm64/kvm/hyp/vhe/switch.c      |  19 +++++
> > >   arch/arm64/kvm/mmu.c                 |  70 ++++++++++++++++++
> > >   arch/arm64/kvm/reset.c               |   3 +
> > >   arch/arm64/tools/cpucaps             |   1 +
> > >   arch/arm64/tools/sysreg              |  29 ++++++++
> > >   include/uapi/linux/kvm.h             |   1 +
> > >   tools/include/uapi/linux/kvm.h       |   1 +
> > >   17 files changed, 305 insertions(+)
> > > 
> > > --
> > > 2.33.0
> > > 
> > 
> > Hi Tian,
> > 
> > I was thinking: maybe instead of putting the HDBSS (and HACDBS) stuff
> > across a bunch of KVM files, we should try to focus them all on a single
> > arch/arm64/kvm/dirty_bit.c file (plus a header such as
> > arch/arm64/include/asm/kvm_dirty_bit.h).
> > 
> > What is your opinion on that?
> > 
> > Thanks!
> > Leo
> 
> 
> Sorry for the late reply. Yes, I had the same thought before. In the next
> version, I will
> 
> move all the HDBSS-related content into the same file, such as
> arch/arm64/kvm/dirty_bit.c
> 
> and arch/arm64/include/asm/kvm_dirty_bit.h.
> 
> 
> Tian
> 
> 
> > 
> > 


Awesome! Then I will work my HACDBS enablement that way as well.

Thanks!
Leo

Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7B73E6DCF
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774966446; cv=none; b=dFkBaC88/ZqZnxQrqbOLhdSnXWmYoASx8YxZt9WzSTVtVYd5tJPtJUpuGIh50aMllZWb001eL3nBh4pXnXOCqbvJgjaHrKhYjVopo7XdA7fnF3Ah2zuzYHOatNqs5wUn796B9++vy+NIxdoa4nkPYVMu22jjc7fJ7XGzJf/s0AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774966446; c=relaxed/simple;
	bh=0WokdVZGVQOySMRtOFuViCjuFlNJiqco1s6MePa8OP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=sUsEw9EFppZkHMGgPPqkuXwo3D4a2+A5qPv8PAaGlpX4oQSdd2tlyExhEm8A7kiolL6kDJc8fQqwZzhm0Xhp2C7dO9ehyq/9DdFI2InCF8z5pYkoJMJkoLczgWGxl/NEDUOURj0Yg3T324obIXqHVrez/fxWc5XRHF3ZVLCAxKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SLROPAAq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SLROPAAq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1565249C7;
	Tue, 31 Mar 2026 07:13:57 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC9EF3F641;
	Tue, 31 Mar 2026 07:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774966442; bh=0WokdVZGVQOySMRtOFuViCjuFlNJiqco1s6MePa8OP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLROPAAq4tm06CZlvLbnK6UlSl74cbeF4PnQYHt9YVrFbK4s7f7jkSNb87VbkRboy
	 XXkf4Lg/itNksvkyv6pSBDL/ICC5mCXYYcQ0SnbvaUsn7q3qpwFoRaJP/O5WcrtsmP
	 3Bp268ytYRpb6dxbptQOk8QvUD84hzofzk3QHT0g=
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
Date: Tue, 31 Mar 2026 15:13:50 +0100
Message-ID: <acvWnjG0AZBHL21q@devkitleo>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225040421.2683931-1-zhengtian10@huawei.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Feb 25, 2026 at 12:04:16PM +0800, Tian Zheng wrote:
> This series of patches add support to the Hardware Dirty state tracking
> Structure(HDBSS) feature, which is introduced by the ARM architecture
> in the DDI0601(ID121123) version.
> 
> The HDBSS feature is an extension to the architecture that enhances
> tracking translation table descriptors' dirty state, identified as
> FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
> page tracking, aiming to significantly reduce the overhead of scanning
> for dirty pages.
> 
> The purpose of this feature is to make the execution overhead of live
> migration lower to both the guest and the host, compared to existing
> approaches (write-protect or search stage 2 tables).
> 
> After these patches, users(such as qemu) can use the
> KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl to enable or disable the HDBSS
> feature before and after the live migration.
> 
> v2:
> https://lore.kernel.org/linux-arm-kernel/20251121092342.3393318-1-zhengtian10@huawei.com/
> 
> v2->v3 changes:
> - Remove the ARM64_HDBSS configuration option and ensure this feature
> is only enabled in VHE mode.
> - Move HDBSS-related variables to the arch-independent portion of the
> kvm structure.
> - Remove error messages during HDBSS enable/disable operations
> - Change HDBSS buffer flushing from handle_exit to vcpu_put,
> check_vcpu_requests, and kvm_handle_guest_abort.
> - Add fault handling for HDBSS including buffer full, external abort,
> and general protection fault (GPF).
> - Add support for a 4KB HDBSS buffer size, mapped to the value 0b0000.
> - Add a second argument to the ioctl to turn HDBSS on or off.
> 
> Tian Zheng (1):
>   KVM: arm64: Document HDBSS ioctl
> 
> eillon (4):
>   arm64/sysreg: Add HDBSS related register information
>   KVM: arm64: Add support to set the DBM attr during memory abort
>   KVM: arm64: Add support for FEAT_HDBSS
>   KVM: arm64: Enable HDBSS support and handle HDBSSF events
> 
>  Documentation/virt/kvm/api.rst       |  16 +++++
>  arch/arm64/include/asm/cpufeature.h  |   5 ++
>  arch/arm64/include/asm/esr.h         |   7 ++
>  arch/arm64/include/asm/kvm_host.h    |  17 +++++
>  arch/arm64/include/asm/kvm_mmu.h     |   1 +
>  arch/arm64/include/asm/kvm_pgtable.h |   4 ++
>  arch/arm64/include/asm/sysreg.h      |  11 +++
>  arch/arm64/kernel/cpufeature.c       |  12 ++++
>  arch/arm64/kvm/arm.c                 | 102 +++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         |   6 ++
>  arch/arm64/kvm/hyp/vhe/switch.c      |  19 +++++
>  arch/arm64/kvm/mmu.c                 |  70 ++++++++++++++++++
>  arch/arm64/kvm/reset.c               |   3 +
>  arch/arm64/tools/cpucaps             |   1 +
>  arch/arm64/tools/sysreg              |  29 ++++++++
>  include/uapi/linux/kvm.h             |   1 +
>  tools/include/uapi/linux/kvm.h       |   1 +
>  17 files changed, 305 insertions(+)
> 
> --
> 2.33.0
> 


Hi Tian,

I was thinking: maybe instead of putting the HDBSS (and HACDBS) stuff 
across a bunch of KVM files, we should try to focus them all on a single 
arch/arm64/kvm/dirty_bit.c file (plus a header such as 
arch/arm64/include/asm/kvm_dirty_bit.h).

What is your opinion on that?

Thanks!
Leo


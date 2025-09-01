Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791902E0902
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 08:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756714092; cv=none; b=b678hghi50IfmnVht8k+1tB4ffUoxp9cXaaqHK3LE/uZCvO9oMp/bb/u5P7f4GOli5ZWC8jsa6MJKCFXHHqyteOAbqzeP1QwDrPJd5vv+nOAp22ASR4Kct/xEky7oDrvH7Sk1goSaMbcMj3oFf/eqwLlZiBg9Zh5Frzm72xVbBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756714092; c=relaxed/simple;
	bh=88pJMB2/sESAAsYhfu9LAL+BbLyOCqi2B+Lp2dZaSn8=;
	h=CC:Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=kr+Y/vY9faOi/4fX9HRzmVdnuMvtrFhA8wxRSMuGBFwUpv/poT7GdB4/UCYzuA28fduFsKz0teImt4p1bRHJ2tqHBTFB7LQ+mQUKVLavPOyjPWClwBqlOtRGnf3YMsUL6y1GSdOog3pKTUa9TAPNYbkXBaqUZJ8fTL+gVSKmFPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cFhNT3Dsgz27hSv;
	Mon,  1 Sep 2025 16:09:13 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F05391400D2;
	Mon,  1 Sep 2025 16:08:05 +0800 (CST)
Received: from kwepemq200018.china.huawei.com (7.202.195.108) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Sep 2025 16:08:05 +0800
Received: from [10.67.121.177] (10.67.121.177) by
 kwepemq200018.china.huawei.com (7.202.195.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Sep 2025 16:08:04 +0800
CC: <yangyicong@hisilicon.com>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <shuah@kernel.org>,
	<jonathan.cameron@huawei.com>, <shameerkolothum@gmail.com>,
	<linuxarm@huawei.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	<tangchengchang@huawei.com>, <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v5 0/7] Add support for FEAT_{LS64, LS64_V} and related
 tests
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <corbet@lwn.net>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>
References: <20250818064806.25417-1-yangyicong@huawei.com>
From: Yicong Yang <yangyicong@huawei.com>
Message-ID: <480c7a31-fa0d-89b6-4fa0-90dba64a31b3@huawei.com>
Date: Mon, 1 Sep 2025 16:08:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250818064806.25417-1-yangyicong@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq200018.china.huawei.com (7.202.195.108)

a gentle ping...

hi Marc and Oliver,

the discussion since v2 are mainly about the LS64 fault hanlding by kvm/hypervisor,
does this version a proper one to go ahead?

thanks.

On 2025/8/18 14:47, Yicong Yang wrote:
> From: Yicong Yang <yangyicong@hisilicon.com>
> 
> Armv8.7 introduces single-copy atomic 64-byte loads and stores
> instructions and its variants named under FEAT_{LS64, LS64_V}.
> Add support for Armv8.7 FEAT_{LS64, LS64_V}:
> - Add identifying and enabling in the cpufeature list
> - Expose the support of these features to userspace through HWCAP3
>   and cpuinfo
> - Add related hwcap test
> - Handle the trap of unsupported memory (normal/uncacheable) access in a VM
> 
> A real scenario for this feature is that the userspace driver can make use of
> this to implement direct WQE (workqueue entry) - a mechanism to fill WQE
> directly into the hardware.
> 
> Picked Marc's 2 patches form [1] for handling the LS64 trap in a VM on emulated
> MMIO and the introduce of KVM_EXIT_ARM_LDST64B.
> 
> [1] https://lore.kernel.org/linux-arm-kernel/20240815125959.2097734-1-maz@kernel.org/
> 
> Tested with updated hwcap test:
> [root@localhost tmp]# dmesg | grep "All CPU(s) started"
> [   14.789859] CPU: All CPU(s) started at EL2
> [root@localhost tmp]# ./hwcap
> # LS64 present
> ok 217 cpuinfo_match_LS64
> ok 218 sigill_LS64
> ok 219 # SKIP sigbus_LS64_V
> # LS64_V present
> ok 220 cpuinfo_match_LS64_V
> ok 221 sigill_LS64_V
> ok 222 # SKIP sigbus_LS64_V
> # 115 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> # Totals: pass:107 fail:0 xfail:0 xpass:0 skip:115 error:0
> 
> root@localhost:/mnt# dmesg | grep "All CPU(s) started"
> [    0.281152] CPU: All CPU(s) started at EL1
> root@localhost:/mnt# ./hwcap
> # LS64 present
> ok 217 cpuinfo_match_LS64
> ok 218 sigill_LS64
> ok 219 # SKIP sigbus_LS64
> # LS64_V present
> ok 220 cpuinfo_match_LS64_V
> ok 221 sigill_LS64_V
> ok 222 # SKIP sigbus_LS64_V
> # 115 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> # Totals: pass:107 fail:0 xfail:0 xpass:0 skip:115 error:0
> 
> Change since v4:
> - Rebase on v6.17-rc2 and fix the conflicts
> Link: https://lore.kernel.org/linux-arm-kernel/20250715081356.12442-1-yangyicong@huawei.com/
> 
> Change since v3:
> - Inject DABT fault for LS64 fault on unsupported memory but with valid memslot
> Link: https://lore.kernel.org/linux-arm-kernel/20250626080906.64230-1-yangyicong@huawei.com/
> 
> Change since v2:
> - Handle the LS64 fault to userspace and allow userspace to inject LS64 fault
> - Reorder the patches to make KVM handling prior to feature support
> Link: https://lore.kernel.org/linux-arm-kernel/20250331094320.35226-1-yangyicong@huawei.com/
> 
> Change since v1:
> - Drop the support for LS64_ACCDATA
> - handle the DABT of unsupported memory type after checking the memory attributes
> Link: https://lore.kernel.org/linux-arm-kernel/20241202135504.14252-1-yangyicong@huawei.com/
> 
> Marc Zyngier (2):
>   KVM: arm64: Add exit to userspace on {LD,ST}64B* outside of memslots
>   KVM: arm64: Add documentation for KVM_EXIT_ARM_LDST64B
> 
> Yicong Yang (5):
>   KVM: arm64: Handle DABT caused by LS64* instructions on unsupported
>     memory
>   arm64: Provide basic EL2 setup for FEAT_{LS64, LS64_V} usage at EL0/1
>   arm64: Add support for FEAT_{LS64, LS64_V}
>   KVM: arm64: Enable FEAT_{LS64, LS64_V} in the supported guest
>   kselftest/arm64: Add HWCAP test for FEAT_{LS64, LS64_V}
> 
>  Documentation/arch/arm64/booting.rst      | 12 +++
>  Documentation/arch/arm64/elf_hwcaps.rst   |  6 ++
>  Documentation/virt/kvm/api.rst            | 43 +++++++++--
>  arch/arm64/include/asm/el2_setup.h        | 12 ++-
>  arch/arm64/include/asm/esr.h              |  8 ++
>  arch/arm64/include/asm/hwcap.h            |  2 +
>  arch/arm64/include/asm/kvm_emulate.h      |  7 ++
>  arch/arm64/include/uapi/asm/hwcap.h       |  2 +
>  arch/arm64/kernel/cpufeature.c            | 51 +++++++++++++
>  arch/arm64/kernel/cpuinfo.c               |  2 +
>  arch/arm64/kvm/inject_fault.c             | 22 ++++++
>  arch/arm64/kvm/mmio.c                     | 27 ++++++-
>  arch/arm64/kvm/mmu.c                      | 14 +++-
>  arch/arm64/tools/cpucaps                  |  2 +
>  include/uapi/linux/kvm.h                  |  3 +-
>  tools/testing/selftests/arm64/abi/hwcap.c | 90 +++++++++++++++++++++++
>  16 files changed, 292 insertions(+), 11 deletions(-)
> 

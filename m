Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614104311D3
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 09:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767864080; cv=none; b=DFFoba6+xoDR3Ms85Uk9hwwO30BH4/HMMdd3f4wrQ89gvNYa3hkOS4Fi56jVrB0vy3Op/U2y5scB+fZ5MtkLaUq8nuCxixGbpzPhS98yMdzg7zpWHIx8rYpcZQPkHCH0Jn9GtbUG4qZ3YXWPcCvYlfwpqm2vOVk1SKJNGhhbE6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767864080; c=relaxed/simple;
	bh=Yhm+kvNMMwY0AAcw7KrULiS69CclNuOwE7YYon2Cj5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FFMDr80rC0werQ14c9A703GKYnY1fQLifbL6c/2vJw1XoCPka73+DMvIwp29jLQGDGEE4FI2Dv9l4ITu0pBew/J5MlsYVEBxDZVZE0+Qc/aqacRAUBV31zLTDoOEAxVU+1jpM6y6i1D85iQJ50BZiPVDnTS4HaH/Fr2ddX0bNf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dmzp930JqzLlXJ;
	Thu,  8 Jan 2026 17:17:53 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id BE82140565;
	Thu,  8 Jan 2026 17:21:08 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 8 Jan 2026 17:21:08 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 8 Jan 2026 17:21:07 +0800
Message-ID: <16395515-1b66-8d71-abb0-d63db661ee62@hisilicon.com>
Date: Thu, 8 Jan 2026 17:20:43 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v8 0/7] Add support for FEAT_{LS64, LS64_V} and related
 tests
Content-Language: en-US
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<arnd@arndb.de>, <yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>
References: <20251223093343.3822498-1-wangzhou1@hisilicon.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <20251223093343.3822498-1-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/12/23 17:33, Zhou Wang wrote:
> Armv8.7 introduces single-copy atomic 64-byte loads and stores
> instructions and its variants named under FEAT_{LS64, LS64_V}.
> Add support for Armv8.7 FEAT_{LS64, LS64_V}:
> - Add identifying and enabling in the cpufeature list
> - Expose the support of FEAT_LS64 to userspace through HWCAP3 and cpuinfo
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

Hi,

Gentle ping about this series... If there is no more comment, is there a chance to
take it in this cycle?

Best,
Zhou

> 
> Tested with updated hwcap test(host in VHE):
> [root@localhost tmp]# ./hwcap
> [...]
> # LS64 present
> ok 226 cpuinfo_match_LS64
> ok 227 sigill_LS64
> ok 228 # SKIP sigbus_LS64
> # 120 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> # Totals: pass:108 fail:0 xfail:0 xpass:0 skip:120 error:0
> 
> Tested with updated hwcap test(guest in VHE):
> root@localhost:/mnt# ./hwcap
> [...]
> # LS64 present
> ok 226 cpuinfo_match_LS64
> ok 227 sigill_LS64
> ok 228 # SKIP sigbus_LS64
> # 120 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> # Totals: pass:108 fail:0 xfail:0 xpass:0 skip:120 error:0
> 
> Tested nVHE case as well, same log as above.
> 
> Change since v7:
> - Tiny spelling fix in 1/7
> - Change the order between 5/7 and 6/7
> - Remove has_ls64, use has_cpuid_feature directly in 6/7
> - Add Acked-by from Arnd and Oliver
> - Trap st64bv from EL0 to EL1/EL2
> - Rebase on v6.19-rc1
> Link: https://lore.kernel.org/all/20251107072127.448953-1-wangzhou1@hisilicon.com/
> 
> Change since v6:
> - Add exception inject about nested VM in 3/7
> - Remove __maybe_unused related codes in 7/7, replace to use asm clobber
> - Add my signoff in each patch
> - Rebase on v6.18-rc4
> Link: https://lore.kernel.org/all/20251024090819.4097819-1-wangzhou1@hisilicon.com/
> 
> Change since v5:
> - Rebase on v6.18-rc2 and fix the conflicts
> - Add more description in elf_hwcaps.rst as suggested by Catalin Marinas
> Link: https://lore.kernel.org/all/20250818064806.25417-1-yangyicong@huawei.com/
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
>   KVM: arm64: Enable FEAT_{LS64, LS64_V} in the supported guest
>   arm64: Add support for FEAT_{LS64, LS64_V}
>   kselftest/arm64: Add HWCAP test for FEAT_LS64
> 
>  Documentation/arch/arm64/booting.rst      | 12 ++++++
>  Documentation/arch/arm64/elf_hwcaps.rst   |  7 ++++
>  Documentation/virt/kvm/api.rst            | 43 ++++++++++++++++----
>  arch/arm64/include/asm/el2_setup.h        | 12 +++++-
>  arch/arm64/include/asm/esr.h              |  8 ++++
>  arch/arm64/include/asm/hwcap.h            |  1 +
>  arch/arm64/include/asm/kvm_emulate.h      |  7 ++++
>  arch/arm64/include/uapi/asm/hwcap.h       |  1 +
>  arch/arm64/kernel/cpufeature.c            | 28 +++++++++++++
>  arch/arm64/kernel/cpuinfo.c               |  1 +
>  arch/arm64/kvm/inject_fault.c             | 34 ++++++++++++++++
>  arch/arm64/kvm/mmio.c                     | 27 ++++++++++++-
>  arch/arm64/kvm/mmu.c                      | 14 ++++++-
>  arch/arm64/tools/cpucaps                  |  2 +
>  include/uapi/linux/kvm.h                  |  3 +-
>  tools/testing/selftests/arm64/abi/hwcap.c | 49 +++++++++++++++++++++++
>  16 files changed, 238 insertions(+), 11 deletions(-)
> 

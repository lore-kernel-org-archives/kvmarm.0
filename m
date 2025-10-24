Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FEF307AEA
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 09:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296924; cv=none; b=Dng6+NU7WGzZerPhcRL/IveOhhkQzhSq8HRHeQe5Yx21TiiIMiTU/8fe871NeG5Ehk3cSTrsnIe7gp6YXWaeXX22i/DIsxFAaTsvtDipr7rtS5A9fuLvesGH1AF7lexDhoT6aIBDaCRuEUPMMY0QufmXpaOzmCKWB6lgWhOzRTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296924; c=relaxed/simple;
	bh=LIies+kH+GvWP6NMIsxJjVEVDQtfpR++NjFedgOq6AQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u8HjfcqU9i3ghpaljFDdL0XlF09OxwxmtVWg++DGbMEUenLr0h4cU+JmYDc4j8QV9q9rADONvhyMKNYYOX9E1H64Ed+JndyXlFklhcdBvg5tIVLVMs6rp82unNCpjcDcV6FdlKUpR24QUe8CgLOUN6x9b59TW9srOF6F5CbBtQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ctH4k6RNQzxXDV;
	Fri, 24 Oct 2025 17:03:34 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 61EEE18048E;
	Fri, 24 Oct 2025 17:08:33 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 24 Oct 2025 17:08:33 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 24 Oct
 2025 17:08:32 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>
Subject: [PATCH v6 0/7] Add support for FEAT_{LS64, LS64_V} and related tests
Date: Fri, 24 Oct 2025 17:08:12 +0800
Message-ID: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200004.china.huawei.com (7.202.195.237)

Armv8.7 introduces single-copy atomic 64-byte loads and stores
instructions and its variants named under FEAT_{LS64, LS64_V}.
Add support for Armv8.7 FEAT_{LS64, LS64_V}:
- Add identifying and enabling in the cpufeature list
- Expose the support of these features to userspace through HWCAP3 and cpuinfo
- Add related hwcap test
- Handle the trap of unsupported memory (normal/uncacheable) access in a VM

A real scenario for this feature is that the userspace driver can make use of
this to implement direct WQE (workqueue entry) - a mechanism to fill WQE
directly into the hardware.

Picked Marc's 2 patches form [1] for handling the LS64 trap in a VM on emulated
MMIO and the introduce of KVM_EXIT_ARM_LDST64B.

As Yicong has left HiSilicon, I will help to continue to upstream this patchset.

[1] https://lore.kernel.org/linux-arm-kernel/20240815125959.2097734-1-maz@kernel.org/

Tested with updated hwcap test(host in VHE):
[root@localhost tmp]# ./hwcap
[...]
# LS64 present
ok 226 cpuinfo_match_LS64
ok 227 sigill_LS64
ok 228 # SKIP sigbus_LS64
# LS64_V present
ok 229 cpuinfo_match_LS64_V
ok 230 sigill_LS64_V
ok 231 # SKIP sigbus_LS64_V
# 121 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:110 fail:0 xfail:0 xpass:0 skip:121 error:0

Tested with updated hwcap test(guest in VHE):
root@localhost:/mnt# ./hwcap
[...]
# LS64 present
ok 226 cpuinfo_match_LS64
ok 227 sigill_LS64
ok 228 # SKIP sigbus_LS64
# LS64_V present
ok 229 cpuinfo_match_LS64_V
ok 230 sigill_LS64_V
ok 231 # SKIP sigbus_LS64_V
# 121 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:110 fail:0 xfail:0 xpass:0 skip:121 error:0

Tested nVHE case as well, same log as above.

Change since v5:
- Rebase on v6.18-rc2 and fix the conflicts
- Add more description in elf_hwcaps.rst as suggested by Catalin Marinas
Link: https://lore.kernel.org/all/20250818064806.25417-1-yangyicong@huawei.com/

Change since v4:
- Rebase on v6.17-rc2 and fix the conflicts
Link: https://lore.kernel.org/linux-arm-kernel/20250715081356.12442-1-yangyicong@huawei.com/

Change since v3:
- Inject DABT fault for LS64 fault on unsupported memory but with valid memslot
Link: https://lore.kernel.org/linux-arm-kernel/20250626080906.64230-1-yangyicong@huawei.com/

Change since v2:
- Handle the LS64 fault to userspace and allow userspace to inject LS64 fault
- Reorder the patches to make KVM handling prior to feature support
Link: https://lore.kernel.org/linux-arm-kernel/20250331094320.35226-1-yangyicong@huawei.com/

Change since v1:
- Drop the support for LS64_ACCDATA
- handle the DABT of unsupported memory type after checking the memory attributes
Link: https://lore.kernel.org/linux-arm-kernel/20241202135504.14252-1-yangyicong@huawei.com/

Marc Zyngier (2):
  KVM: arm64: Add exit to userspace on {LD,ST}64B* outside of memslots
  KVM: arm64: Add documentation for KVM_EXIT_ARM_LDST64B

Yicong Yang (5):
  KVM: arm64: Handle DABT caused by LS64* instructions on unsupported
    memory
  arm64: Provide basic EL2 setup for FEAT_{LS64, LS64_V} usage at EL0/1
  arm64: Add support for FEAT_{LS64, LS64_V}
  KVM: arm64: Enable FEAT_{LS64, LS64_V} in the supported guest
  kselftest/arm64: Add HWCAP test for FEAT_{LS64, LS64_V}

 Documentation/arch/arm64/booting.rst      | 12 +++
 Documentation/arch/arm64/elf_hwcaps.rst   | 14 ++++
 Documentation/virt/kvm/api.rst            | 43 +++++++++--
 arch/arm64/include/asm/el2_setup.h        | 12 ++-
 arch/arm64/include/asm/esr.h              |  8 ++
 arch/arm64/include/asm/hwcap.h            |  2 +
 arch/arm64/include/asm/kvm_emulate.h      |  7 ++
 arch/arm64/include/uapi/asm/hwcap.h       |  2 +
 arch/arm64/kernel/cpufeature.c            | 51 +++++++++++++
 arch/arm64/kernel/cpuinfo.c               |  2 +
 arch/arm64/kvm/inject_fault.c             | 22 ++++++
 arch/arm64/kvm/mmio.c                     | 27 ++++++-
 arch/arm64/kvm/mmu.c                      | 14 +++-
 arch/arm64/tools/cpucaps                  |  2 +
 include/uapi/linux/kvm.h                  |  3 +-
 tools/testing/selftests/arm64/abi/hwcap.c | 90 +++++++++++++++++++++++
 16 files changed, 300 insertions(+), 11 deletions(-)

-- 
2.33.0


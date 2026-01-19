Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3334A33
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 02:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768789864; cv=none; b=GOGfEa8WSVFWxnpHNedXoxbDxeobV1iBF4WkZEkOumiODoFbgFM8HcHCRZO9MJgN6yHsIe0JG4r7bhxKRxJv1r7y9byd02e8wUfzM2lFvpxk/hbzsL1Vry1xm9g2zWYqxAZQNToT+284hFd3qb61ild3QxlXb661rQq25Zk47jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768789864; c=relaxed/simple;
	bh=BpxsZfja0NBx1wQhC2rsGIjvTi/HZ0KuuYtozM1xoMk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gxZso6IUNi+uqg+jeU5oJOcnk/7WfFcjd4nS3Kocs0XqYkO8SV0+BZEM8GvOEaJm9uP/+JvQGBwU15sA3N7VoHsdF6vd3wJwLprECDDD8evFzbADP3dme5IkJ+DhQQ2ACpoJ3oZl6+LB87rzB5WJjdcZXd0AtsFLTP9mp9we/eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dvZ8z2bbXznTZb;
	Mon, 19 Jan 2026 10:26:59 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id AF7E640565;
	Mon, 19 Jan 2026 10:30:58 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Jan 2026 10:30:58 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 19 Jan
 2026 10:30:57 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <arnd@arndb.de>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH v8 RESEND 0/7] Add support for FEAT_{LS64, LS64_V} and related tests
Date: Mon, 19 Jan 2026 10:29:21 +0800
Message-ID: <20260119022928.149358-1-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200004.china.huawei.com (7.202.195.237)

Armv8.7 introduces single-copy atomic 64-byte loads and stores
instructions and its variants named under FEAT_{LS64, LS64_V}.
Add support for Armv8.7 FEAT_{LS64, LS64_V}:
- Add identifying and enabling in the cpufeature list
- Expose the support of FEAT_LS64 to userspace through HWCAP3 and cpuinfo
- Add related hwcap test
- Handle the trap of unsupported memory (normal/uncacheable) access in a VM

A real scenario for this feature is that the userspace driver can make use of
this to implement direct WQE (workqueue entry) - a mechanism to fill WQE
directly into the hardware.

Picked Marc's 2 patches form [1] for handling the LS64 trap in a VM on emulated
MMIO and the introduce of KVM_EXIT_ARM_LDST64B.

[1] https://lore.kernel.org/linux-arm-kernel/20240815125959.2097734-1-maz@kernel.org/

Tested with updated hwcap test(host in VHE):
[root@localhost tmp]# ./hwcap
[...]
# LS64 present
ok 226 cpuinfo_match_LS64
ok 227 sigill_LS64
ok 228 # SKIP sigbus_LS64
# 120 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:108 fail:0 xfail:0 xpass:0 skip:120 error:0

Tested with updated hwcap test(guest in VHE):
root@localhost:/mnt# ./hwcap
[...]
# LS64 present
ok 226 cpuinfo_match_LS64
ok 227 sigill_LS64
ok 228 # SKIP sigbus_LS64
# 120 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:108 fail:0 xfail:0 xpass:0 skip:120 error:0

Tested nVHE case as well, same log as above.

Change since v7:
- Tiny spelling fix in 1/7
- Change the order between 5/7 and 6/7
- Remove has_ls64, use has_cpuid_feature directly in 6/7
- Add Acked-by from Arnd and Oliver
- Trap st64bv from EL0 to EL1/EL2
- Rebase on v6.19-rc5
Link: https://lore.kernel.org/all/20251107072127.448953-1-wangzhou1@hisilicon.com/

Change since v6:
- Add exception inject about nested VM in 3/7
- Remove __maybe_unused related codes in 7/7, replace to use asm clobber
- Add my signoff in each patch
- Rebase on v6.18-rc4
Link: https://lore.kernel.org/all/20251024090819.4097819-1-wangzhou1@hisilicon.com/

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
  KVM: arm64: Enable FEAT_{LS64, LS64_V} in the supported guest
  arm64: Add support for FEAT_{LS64, LS64_V}
  kselftest/arm64: Add HWCAP test for FEAT_LS64

 Documentation/arch/arm64/booting.rst      | 12 ++++++
 Documentation/arch/arm64/elf_hwcaps.rst   |  7 ++++
 Documentation/virt/kvm/api.rst            | 43 ++++++++++++++++----
 arch/arm64/include/asm/el2_setup.h        | 12 +++++-
 arch/arm64/include/asm/esr.h              |  8 ++++
 arch/arm64/include/asm/hwcap.h            |  1 +
 arch/arm64/include/asm/kvm_emulate.h      |  7 ++++
 arch/arm64/include/uapi/asm/hwcap.h       |  1 +
 arch/arm64/kernel/cpufeature.c            | 28 +++++++++++++
 arch/arm64/kernel/cpuinfo.c               |  1 +
 arch/arm64/kvm/inject_fault.c             | 34 ++++++++++++++++
 arch/arm64/kvm/mmio.c                     | 27 ++++++++++++-
 arch/arm64/kvm/mmu.c                      | 14 ++++++-
 arch/arm64/tools/cpucaps                  |  2 +
 include/uapi/linux/kvm.h                  |  3 +-
 tools/testing/selftests/arm64/abi/hwcap.c | 49 +++++++++++++++++++++++
 16 files changed, 238 insertions(+), 11 deletions(-)

-- 
2.33.0


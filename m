Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6471DE4FB
	for <kvmarm@lists.linux.dev>; Mon, 31 Mar 2025 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743414200; cv=none; b=GFMb6X/A0VGnvmRJsp0840LwSX67O5FVlYfTWq4hwFmAjwUMJm9ayeG7vaYQ5sIwhHk7MK2sBCxwNvVPA0rxYBlib9UFClaLmS6yXXHekM6oLM8mp3KmfoWTjJqOl54eBomsDYcyb3fwsljejo3PpRAMh4FaCNmqvjh/fLEGpGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743414200; c=relaxed/simple;
	bh=WlikCYQ1K2tBVTFx2dvqaliWh+/7j0/Rp8gBJ+kMY6I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kqzj33zA3SBcd4z1qcFg5qI5AC80SQtC6+KFmWEO9ezRAuD20tIUiSP3eAI8ZJ0O7ueVdDiMlNl6QxvA8G35BHiGA+l5cdxaqTunGnyOHhVzxwiuN9IqRpiYjLS1dKQW7ie3hychCEtmaTucBTZoebNJ205ZydBPCRtYJBUnTGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4ZR5h54JLJzHrMh;
	Mon, 31 Mar 2025 17:39:49 +0800 (CST)
Received: from kwepemd200014.china.huawei.com (unknown [7.221.188.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 0DB091800E2;
	Mon, 31 Mar 2025 17:43:09 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemd200014.china.huawei.com (7.221.188.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 31 Mar 2025 17:43:08 +0800
From: Yicong Yang <yangyicong@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <corbet@lwn.net>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<shuah@kernel.org>, <jonathan.cameron@huawei.com>,
	<shameerali.kolothum.thodi@huawei.com>, <linuxarm@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, <yangyicong@hisilicon.com>,
	<tangchengchang@huawei.com>
Subject: [PATCH v2 0/6] Add support for FEAT_{LS64, LS64_V} and related tests
Date: Mon, 31 Mar 2025 17:43:14 +0800
Message-ID: <20250331094320.35226-1-yangyicong@huawei.com>
X-Mailer: git-send-email 2.31.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200014.china.huawei.com (7.221.188.8)

From: Yicong Yang <yangyicong@hisilicon.com>

Armv8.7 introduces single-copy atomic 64-byte loads and stores
instructions and its variants named under FEAT_{LS64, LS64_V}.
Add support for Armv8.7 FEAT_{LS64, LS64_V}:
- Add identifying and enabling in the cpufeature list
- Expose the support of these features to userspace through HWCAP3
  and cpuinfo
- Add related hwcap test
- Handle the trap of unsupported memory (normal/uncacheable) access in a VM

A real scenario for this feature is that the userspace driver can make use of
this to implement direct WQE (workqueue entry) - a mechanism to fill WQE
directly into the hardware.

This patchset also complement with Marc's patchset v2[1] for handling LS64*
trapped if not advertised for a VM.

[1] https://lore.kernel.org/linux-arm-kernel/20250310122505.2857610-1-maz@kernel.org/

Tested with updated hwcap test:
On host:
root@localhost:/tmp# dmesg | grep "All CPU(s) started"
[    0.504846] CPU: All CPU(s) started at EL2
root@localhost:/tmp# ./hwcap
[...]
# LS64 present
ok 217 cpuinfo_match_LS64
ok 218 sigill_LS64
ok 219 # SKIP sigbus_LS64
# LS64_V present
ok 220 cpuinfo_match_LS64_V
ok 221 sigill_LS64_V
ok 222 # SKIP sigbus_LS64_V
# 115 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:107 fail:0 xfail:0 xpass:0 skip:115 error:0

On guest:
root@localhost:/# dmesg | grep "All CPU(s) started"
[    0.205580] CPU: All CPU(s) started at EL1
root@localhost:/mnt# ./hwcap
[...]
# LS64 present
ok 217 cpuinfo_match_LS64
ok 218 sigill_LS64
ok 219 # SKIP sigbus_LS64
# LS64_V present
ok 220 cpuinfo_match_LS64_V
ok 221 sigill_LS64_V
ok 222 # SKIP sigbus_LS64_V
# 115 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:107 fail:0 xfail:0 xpass:0 skip:115 error:0

Change since v1:
- Drop the suppport for LS64_ACCDATA
- handle the DABT of unsupported memory type after checking the memory attributes
Link: https://lore.kernel.org/linux-arm-kernel/20241202135504.14252-1-yangyicong@huawei.com/

Yicong Yang (6):
  arm64: Provide basic EL2 setup for FEAT_{LS64, LS64_V} usage at EL0/1
  arm64: Add support for FEAT_{LS64, LS64_V}
  KVM: arm64: Enable FEAT_{LS64, LS64_V} in the supported guest
  kselftest/arm64: Add HWCAP test for FEAT_{LS64, LS64_V}
  arm64: Add ESR.DFSC definition of unsupported exclusive or atomic
    access
  KVM: arm64: Handle DABT caused by LS64* instructions on unsupported
    memory

 Documentation/arch/arm64/booting.rst      | 12 +++
 Documentation/arch/arm64/elf_hwcaps.rst   |  6 ++
 arch/arm64/include/asm/el2_setup.h        | 12 ++-
 arch/arm64/include/asm/esr.h              |  8 ++
 arch/arm64/include/asm/hwcap.h            |  2 +
 arch/arm64/include/asm/kvm_emulate.h      |  7 ++
 arch/arm64/include/uapi/asm/hwcap.h       |  2 +
 arch/arm64/kernel/cpufeature.c            | 51 +++++++++++++
 arch/arm64/kernel/cpuinfo.c               |  2 +
 arch/arm64/kvm/inject_fault.c             | 35 +++++++++
 arch/arm64/kvm/mmu.c                      | 37 +++++++++-
 arch/arm64/tools/cpucaps                  |  2 +
 tools/testing/selftests/arm64/abi/hwcap.c | 90 +++++++++++++++++++++++
 13 files changed, 264 insertions(+), 2 deletions(-)

-- 
2.24.0


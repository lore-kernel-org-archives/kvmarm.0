Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554F73FAE08
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 10:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783593638; cv=none; b=PtQVn9BKsO0de4nMxR7ZPLzKFedF8RLrsnQvbE8sPp0fKsGSUWiTVZ7BqRfJBnFLt+xnYAW+fSzS0EZxtG0HMzeR2D1nQzU6grEDUexWeQoYnO09eanuCIFEw6ywVoTDxVFoG8qqw3i3YAqq+HU1RKzaOotQn8TcIIsjc0jHVJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783593638; c=relaxed/simple;
	bh=aTdxvvMMNvK2yVTz3rWc4KZpBciSajhfSA7ggQpEV0o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TtDn5w8EgP2Rwey0ZWAxIdV3f76HYgMia4Xo2FJqaGMhH9NgVnxRfTkyPGD0c0WWUYNM3a9ouX72f8bznsENbR43R04RfZ+xhHzoELLCLd9udhP9d2WRc6Ir1pa7/BEA2BNVF0ckvIKhdvEClEUqTKBB0dIXHb1jztDL+Tdj3jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=JItTGwbY; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="JItTGwbY"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TzxDX/ygReeQrlk1sYNRilh77KKsz9bv6yNc9K4h0lw=;
	b=JItTGwbYHXyulRItA9RnQv+CqUdyX1fM8UlAGlM4b9F+aUA1pw54Uqbz1GTeiuFuA7eU7b8+k
	kQSSZKH+AuhLmhcHpyQLEz5g/ChpAzLTU1nvTMWjg1KK3hGa6YnyI2HqCynAyHf2g06GQuH46XT
	Cb1dNkFZA2dAUhDkglSI758=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gwrpp1CXBzRhQS;
	Thu,  9 Jul 2026 18:31:14 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 8C2A740579;
	Thu,  9 Jul 2026 18:40:27 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 9 Jul
 2026 18:40:26 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <zhengtian10@huawei.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>
Subject: [PATCH v4 0/6] Support the FEAT_HDBSS introduced in Armv9.5
Date: Thu, 9 Jul 2026 18:40:20 +0800
Message-ID: <20260709104026.2612599-1-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

This series of patches add support to the Hardware Dirty state tracking
Structure (HDBSS) feature, which is introduced by the ARM architecture
in the DDI0601 (ID121123) version.

The HDBSS feature is an extension to the architecture that enhances
tracking translation table descriptors' dirty state, identified as
FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
page tracking, aiming to significantly reduce the overhead of scanning
for dirty pages.

The purpose of this feature is to make the execution overhead of live
migration lower to both the guest and the host, compared to existing
approaches (write-protect or search stage-2 tables).

The required sysreg definitions for FEAT_HDBSS have been merged into
arm64 /sysregs:
  [1/5] arm64/sysreg: Add HDBSS related register information
        https://git.kernel.org/arm64/c/72f7be0c2e30


After these patches, the kernel automatically enables HDBSS when dirty
logging is enabled on any memslot, and disables HDBSS when dirty logging
is disabled on all memslots. This series does not support dirty ring
mode.

Depends-on: "KVM: arm64: Enable eager hugepage splitting if HDBSS is available"
	https://lore.kernel.org/linux-arm-kernel/20260629111820.1873540-3-leo.bras@arm.com/

This dependency is mandatory. Unlike v3, where DBM was added lazily on
the first dirty access via a page fault, v4 injects DBM into pgt->flags
at stage-2 MMU initialization time. Combined with HDBSS being auto-enabled
during migration setup, the first dirty access no longer triggers a page
fault. Consequently, if lazy hugepage splitting were relied upon (which
requires a page fault to trigger splitting), hugepages would never be
split, leading to guest hang after migration. Leonardo's patch above
ensures eager hugepage splitting is enabled (chunk_size != 0) when HDBSS
is available, guaranteeing that hugepages are properly split before
migration starts.

v3: https://lore.kernel.org/linux-arm-kernel/20260225040421.2683931-1-zhengtian10@huawei.com/

v3->v4 changes:
- Merge sysreg definitions into the FEAT_HDBSS detection patch (was a
  separate patch in v3).
- Add auto DBM (Dirty Bit Modifier) support as a new patch, suggested
  by Leonardo Bras. DBM is now controlled as a page-table level flag
  (KVM_PGTABLE_S2_DBM) rather than per-PTE. Note that DBM is injected
  at stage-2 MMU creation time, not lazily on first dirty access. This
  means the first write to a dirty-logged page does not generate a
  page fault, which is a key reason for the mandatory dependency on
  Leonardo's eager hugepage splitting patch (see Depends-on above).
- Split the v3 "Enable HDBSS support and handle HDBSSF events" patch
  into three patches: per-vCPU buffer management, fault handling and
  buffer flush, and auto enable/disable on dirty logging change. This
  implements kernel-managed automatic HDBSS enable/disable.
- Remove the KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl for manual HDBSS
  on/off. HDBSS is now automatically enabled/disabled based on dirty
  logging state via kvm_arch_commit_memory_region().
- Change HDBSS buffer flush triggers to vcpu_put, check_vcpu_requests,
  and kvm_handle_guest_abort.
- Store hdbss_order at VM level (kvm->arch.hdbss_order) instead of
  per-vCPU, since all vCPUs share the same order.
- Document patch is not included in this version; will be sent in a
  follow-up series.

Leonardo Bras (1):
  KVM: arm64: Enable eager hugepage splitting if HDBSS is available

Tian Zheng (2):
  KVM: arm64: Add support for FEAT_HDBSS
  KVM: arm64: Add auto DBM support for hardware dirty tracking

eillon (3):
  KVM: arm64: Add HDBSS per-vCPU buffer management
  KVM: arm64: Add HDBSS fault handling and buffer flush
  KVM: arm64: Add auto HDBSS enable/disable on dirty logging change

 arch/arm64/include/asm/cpufeature.h    |   5 +
 arch/arm64/include/asm/esr.h           |   5 +
 arch/arm64/include/asm/kvm_dirty_bit.h |  29 ++++
 arch/arm64/include/asm/kvm_host.h      |  14 ++
 arch/arm64/include/asm/kvm_pgtable.h   |   4 +
 arch/arm64/include/asm/sysreg.h        |  11 ++
 arch/arm64/kernel/cpufeature.c         |  12 ++
 arch/arm64/kvm/Makefile                |   1 +
 arch/arm64/kvm/arm.c                   |  29 ++++
 arch/arm64/kvm/dirty_bit.c             | 219 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c           |  35 +++-
 arch/arm64/kvm/hyp/vhe/switch.c        |  15 ++
 arch/arm64/kvm/mmu.c                   |  19 ++-
 arch/arm64/kvm/reset.c                 |   4 +
 arch/arm64/tools/cpucaps               |   1 +
 15 files changed, 399 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
 create mode 100644 arch/arm64/kvm/dirty_bit.c

--
2.33.0


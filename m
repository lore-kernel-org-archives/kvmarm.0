Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C9E29B77C
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 04:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771992273; cv=none; b=hLKQnmh9sErhu2xCjPClmPeN1J4AKAoU1r1uu9RksipF/aTEAP0PgkQvEfHgennRV54JpfCYtEJF7xBWnA9zwYy5QsCzxXyjo/6oKs5U0hLuW8V0PmWohACJsHsdhgYeyfEysMfIws5H9fkT2WiWYU/dfIrveicvkFQGzmwLKvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771992273; c=relaxed/simple;
	bh=8drHhp+j0jOSlF5jJ/gXFf1BCySUhfoTV4QwNuq35RE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GeGBZTFrhBQqEZMW66OIk+JSHJ4llQOxVprcJcA+SSaNMtg9MlinrT1P1KOxiL2O4ptD7Edvk5i+Z691bCN6fgFFHBvCXus88npNK4oiQKMWjelZlZZ8ToyOi6mys6mQXWpGV9U5A1PQYmiiZGL64h1DDkzE6NXFo1uOus0RSEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=d3Fo55HY; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="d3Fo55HY"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KFA0LtrJmju9DoOCjjWqc6FESXlRgEEAoBovtEGD878=;
	b=d3Fo55HYLZ5YNgsnlNFs+x7lvG6j5XhcIcLkMkciwSwEfmpBAmMpRbx0/K+fYxQtv6kHmqHpg
	Ob73DcFvqR6IbGxdE6UMa7sb/GG1ZOB9aRhJt9xCwl4P3nOz3/81/6YAua1iVC//n13Tw1efNma
	H465TfzKJCm719y2F/p8jgQ=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4fLLSm6860z1cyQ3;
	Wed, 25 Feb 2026 11:59:36 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 50D004048B;
	Wed, 25 Feb 2026 12:04:23 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Feb
 2026 12:04:22 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>,
	<zhengtian10@huawei.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<liuyonglong@huawei.com>, <Jonathan.Cameron@huawei.com>,
	<yezhenyu2@huawei.com>, <linuxarm@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>
Subject: [PATCH v3 0/5] Support the FEAT_HDBSS introduced in Armv9.5
Date: Wed, 25 Feb 2026 12:04:16 +0800
Message-ID: <20260225040421.2683931-1-zhengtian10@huawei.com>
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
Structure(HDBSS) feature, which is introduced by the ARM architecture
in the DDI0601(ID121123) version.

The HDBSS feature is an extension to the architecture that enhances
tracking translation table descriptors' dirty state, identified as
FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
page tracking, aiming to significantly reduce the overhead of scanning
for dirty pages.

The purpose of this feature is to make the execution overhead of live
migration lower to both the guest and the host, compared to existing
approaches (write-protect or search stage 2 tables).

After these patches, users(such as qemu) can use the
KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl to enable or disable the HDBSS
feature before and after the live migration.

v2:
https://lore.kernel.org/linux-arm-kernel/20251121092342.3393318-1-zhengtian10@huawei.com/

v2->v3 changes:
- Remove the ARM64_HDBSS configuration option and ensure this feature
is only enabled in VHE mode.
- Move HDBSS-related variables to the arch-independent portion of the
kvm structure.
- Remove error messages during HDBSS enable/disable operations
- Change HDBSS buffer flushing from handle_exit to vcpu_put,
check_vcpu_requests, and kvm_handle_guest_abort.
- Add fault handling for HDBSS including buffer full, external abort,
and general protection fault (GPF).
- Add support for a 4KB HDBSS buffer size, mapped to the value 0b0000.
- Add a second argument to the ioctl to turn HDBSS on or off.

Tian Zheng (1):
  KVM: arm64: Document HDBSS ioctl

eillon (4):
  arm64/sysreg: Add HDBSS related register information
  KVM: arm64: Add support to set the DBM attr during memory abort
  KVM: arm64: Add support for FEAT_HDBSS
  KVM: arm64: Enable HDBSS support and handle HDBSSF events

 Documentation/virt/kvm/api.rst       |  16 +++++
 arch/arm64/include/asm/cpufeature.h  |   5 ++
 arch/arm64/include/asm/esr.h         |   7 ++
 arch/arm64/include/asm/kvm_host.h    |  17 +++++
 arch/arm64/include/asm/kvm_mmu.h     |   1 +
 arch/arm64/include/asm/kvm_pgtable.h |   4 ++
 arch/arm64/include/asm/sysreg.h      |  11 +++
 arch/arm64/kernel/cpufeature.c       |  12 ++++
 arch/arm64/kvm/arm.c                 | 102 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         |   6 ++
 arch/arm64/kvm/hyp/vhe/switch.c      |  19 +++++
 arch/arm64/kvm/mmu.c                 |  70 ++++++++++++++++++
 arch/arm64/kvm/reset.c               |   3 +
 arch/arm64/tools/cpucaps             |   1 +
 arch/arm64/tools/sysreg              |  29 ++++++++
 include/uapi/linux/kvm.h             |   1 +
 tools/include/uapi/linux/kvm.h       |   1 +
 17 files changed, 305 insertions(+)

--
2.33.0


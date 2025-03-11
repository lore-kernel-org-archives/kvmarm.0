Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482F71E47CA
	for <kvmarm@lists.linux.dev>; Tue, 11 Mar 2025 04:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741665816; cv=none; b=i93Xi+DwDwkkF19jgQVX/ixQkogqQz7eeoaVlWCFyT6QqB81hEWuMOyil7YK1cZKrBluHUBeXYXnBMj4keITrL3FHsLH9Vk0ueRvCo0CW2q06z6dUCvQiwMU5SIwCMy3T9IGFrI42ejFM9QI1X3Zw4I7ZmkIekfNXG/3Pg/PLnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741665816; c=relaxed/simple;
	bh=YKOrTHLvnqlEWXQGD/sjQZMNnxLmpu37j0APp8sQw5E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B/xrTr/o2n6bFt65Sg5lfMp2C56z8NP3uLk/5HRk8vkPl3W7oU6E9ll4xZmJdcjGnsQTYKpPVUNz03ihdk/cTTFXKmLm14dpOWItSgFnBEEtkv7YznISVUfNdyZCzOZ7Umzork+Sm1CX5sY0G4K6DX3IpzYs7FSmJTHyqu2+PH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZBg4q6F8rzvWq2;
	Tue, 11 Mar 2025 11:59:39 +0800 (CST)
Received: from kwepemj500003.china.huawei.com (unknown [7.202.194.33])
	by mail.maildlp.com (Postfix) with ESMTPS id DF0EF140360;
	Tue, 11 Mar 2025 12:03:29 +0800 (CST)
Received: from DESKTOP-KKJBAGG.huawei.com (10.174.178.32) by
 kwepemj500003.china.huawei.com (7.202.194.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Mar 2025 12:03:28 +0800
From: Zhenyu Ye <yezhenyu2@huawei.com>
To: <maz@kernel.org>, <yuzenghui@huawei.com>, <will@kernel.org>,
	<oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <joey.gouly@arm.com>
CC: <linux-kernel@vger.kernel.org>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <wangzhou1@hisilicon.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v1 0/5] Support the FEAT_HDBSS introduced in Armv9.5
Date: Tue, 11 Mar 2025 12:03:16 +0800
Message-ID: <20250311040321.1460-1-yezhenyu2@huawei.com>
X-Mailer: git-send-email 2.22.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemj500003.china.huawei.com (7.202.194.33)

From: eillon <yezhenyu2@huawei.com>

This series of patches add support to the Hardware Dirty state tracking
Structure(HDBSS) feature, which is introduced by the ARM architecture
in the DDI0601(ID121123) version.

The HDBSS feature is an extension to the architecture that enhances
tracking translation table descriptors' dirty state, identified as
FEAT_HDBSS.  The goal of this feature is to reduce the cost of surveying
for dirtied granules, with minimal effect on recording when a granule
has been dirtied.

The purpose of this feature is to make the execution overhead of live
migration lower to both the guest and the host, compared to existing
approaches (write-protect or search stage 2 tables).

After these patches, users(such as qemu) can use the 
KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl to enable or disable the HDBSS
feature before and after the live migration.

See patches for details, Thanks.

eillon (5):
  arm64/sysreg: add HDBSS related register information
  arm64/kvm: support set the DBM attr during memory abort
  arm64/kvm: using ioctl to enable/disable the HDBSS feature
  arm64/kvm: support to handle the HDBSSF event
  arm64/config: add config to control whether enable HDBSS feature

 arch/arm64/Kconfig                    | 19 +++++++
 arch/arm64/Makefile                   |  4 +-
 arch/arm64/include/asm/cpufeature.h   | 15 +++++
 arch/arm64/include/asm/esr.h          |  2 +
 arch/arm64/include/asm/kvm_arm.h      |  1 +
 arch/arm64/include/asm/kvm_host.h     |  6 ++
 arch/arm64/include/asm/kvm_mmu.h      | 12 ++++
 arch/arm64/include/asm/kvm_pgtable.h  |  3 +
 arch/arm64/include/asm/sysreg.h       | 16 ++++++
 arch/arm64/kvm/arm.c                  | 80 +++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c          | 47 ++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c          |  6 ++
 arch/arm64/kvm/hyp/vhe/switch.c       |  1 +
 arch/arm64/kvm/mmu.c                  | 10 ++++
 arch/arm64/kvm/reset.c                |  7 +++
 arch/arm64/tools/sysreg               | 28 ++++++++++
 include/linux/kvm_host.h              |  1 +
 include/uapi/linux/kvm.h              |  1 +
 tools/arch/arm64/include/asm/sysreg.h |  4 ++
 tools/include/uapi/linux/kvm.h        |  1 +
 20 files changed, 263 insertions(+), 1 deletion(-)

-- 
2.39.3


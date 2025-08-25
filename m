Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C6FA41
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 02:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756090052; cv=none; b=PXbL5bLucrIWBl/B9OusYxCMl/lvuoFkYGulGZvhzT1G/UCoLVGZWxZr2paTAcFvcOFh7raIPvV9Gd0ByythD8+hSdk0zwmTJm3dXPbleQK0BbnUW8FZ4H9E/P1sYdXdDwPlXEfdRWSECtdOLqcnJBavxnj2Ry/haSbxTKLwRDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756090052; c=relaxed/simple;
	bh=xLmrqi5aJc98I2OTwZZi8+qOM7TN8qVqpL3k2DZ9i/8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gTArALRM4mUFxKpP1HMG5oGgdq8nKLCi26ROACPhVGpNkmqTEkhlgW+a01LVWLmpwl758u9QwwFld7q+7Q6iR4CA9JkyHgCfV+J6IMq+tGyJgGmXq7QtClPQ0C+onwvXoRu6KWz1rZMq24FU2511+wV42SYjBl+PegqZjxfor0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c9FZJ51K2z14LnR;
	Mon, 25 Aug 2025 10:47:20 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 95C2B140133;
	Mon, 25 Aug 2025 10:47:26 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 10:47:26 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 10:47:25 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <tangnianyao@huawei.com>,
	<wangwudi@hisilicon.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v2 0/4] Add workaround for HIP10/HIP10C erratum 162200802
Date: Mon, 25 Aug 2025 10:39:50 +0800
Message-ID: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200004.china.huawei.com (7.202.195.237)

As the discussion from V1 series, V2 series firstly adds GICD.num_LPIs
writable support, then add HiSilicon erratum 162200802.

Erratum number should be 162200802, make a mistake in V1, so fix it as
well.

Zhou Wang (4):
  KVM: arm64: Allow userspace to write GICD_TYPER.num_LPIs
  KVM: arm64: selftests: Add test for GICD.num_LPIs
  Documentation: KVM: arm64: Add GICD_TYPER.num_LPIs writable
    description
  ARM64: errata: Add workaround for HIP10/HIP10C erratum 162200802

 Documentation/arch/arm64/silicon-errata.rst   |  2 ++
 .../virt/kvm/devices/arm-vgic-v3.rst          |  6 ++++
 arch/arm64/Kconfig                            | 12 +++++++
 arch/arm64/include/asm/cputype.h              |  4 +++
 arch/arm64/kernel/cpu_errata.c                | 15 +++++++++
 arch/arm64/kvm/vgic/vgic-init.c               |  9 +++++
 arch/arm64/kvm/vgic/vgic-its.c                |  9 +++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  1 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 22 +++++++++++++
 arch/arm64/tools/cpucaps                      |  1 +
 include/kvm/arm_vgic.h                        |  1 +
 include/linux/irqchip/arm-gic-v3.h            |  1 +
 tools/testing/selftests/kvm/arm64/vgic_init.c | 33 +++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v3.h      |  2 ++
 14 files changed, 116 insertions(+), 2 deletions(-)

-- 
2.33.0


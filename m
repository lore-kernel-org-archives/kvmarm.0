Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BFF3E0241
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 08:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789719792; cv=none; b=lrsBDEuvF4Z+FNG+v9YGp4Hut1IzgmwIlUDctM8VV0HnnRY61DEJ/7Yng6OSqY3gtNOvBzDr51lEBMTpvL4IK/l/4XJ+YTGnZRGSRQf+hmNT6nwqDOAHJTpnrg8XIcWZytURonoTTHNFUj33CDBzhBDaa6GWhxMwGLXbSnpbo2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789719792; c=relaxed/simple;
	bh=w/nh6uUPzEgopA7HQ+BsZ/YCm600NZfAnwBbJywl7IQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nyFPvHQrfm0lQ5i9Dyydp3iTlkc+BSLRO2TXQSwpW6YyzFhCcIsJB2WQi3aD3QrTiAr/q2/DwnL2gEkbR8PFhCYTg4cPhkbAq/auaqDn7GJBr/viqit9KzvJlgoe0F41k3M5JnxZoBLTJbWLkQnTwkL9UmXCE0/I0jS83ddNldk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PtUEALXx; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PtUEALXx"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xcW4bfYK1y52qnBlOd8nVvzkoV8g+r3/FI00akVKRxo=;
	b=PtUEALXxZaVfFUg9j3OaGZ0WIKweMClyanE+BmBBWLO+Lppb/qvbIn4DiGKeN4qs9nDYtU/gp
	IBPTVE+KH7AcM1lDETlBe2OAxU91vsBSum8Ih9Sy3vjiM90mzFu0GMjfvVwYSyyeWz/FEEr3OSX
	ptqCyEksOFBoQuIV4VF1IeI=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hmQMK5QRwzKm6V;
	Fri, 18 Sep 2026 16:11:57 +0800 (CST)
Received: from dggpemr200003.china.huawei.com (unknown [7.185.36.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 53D9C4057A;
	Fri, 18 Sep 2026 16:23:01 +0800 (CST)
Received: from huawei.com (10.50.159.234) by dggpemr200003.china.huawei.com
 (7.185.36.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Fri, 18 Sep
 2026 16:23:00 +0800
From: Yize Wang <wangyize7@huawei.com>
To: <maz@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <oupton@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<fuad.tabba@linux.dev>, <joey.gouly@arm.com>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <mark.rutland@arm.com>,
	<zhengchuan@huawei.com>, <jiangjiacheng@huawei.com>, <wangyize7@huawei.com>,
	<yize_w1110@163.com>
Subject: [PATCH 0/2] Batch register access for live migration optimization
Date: Fri, 18 Sep 2026 16:18:13 +0800
Message-ID: <20260918081930.4014735-1-wangyize7@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemr200003.china.huawei.com (7.185.36.25)

This series adds batch register access support to KVM/arm64 to reduce
syscall overhead during VM live migration.

Currently, QEMU issues one ioctl per register when saving/restoring VGIC
state. On large VM configurations this means tens of thousands of syscalls,
where lock acquisition and context switch overhead dominates migration
downtime. Thus, we provide a batch register method to allow userspace
read/write multiple distributor and redistributor registers in a single call.
In this way, we can significantly reduce syscalls and migration downtime.

Test the VM migration time under pressure conditions.
The VM specifications for migration are as follows:
- VM use 4-K page;
- the number of VCPU is 160;
- the total memory is 320Gigabit;
- use 'Redis SET-benchmark' to pressurize VM;

Performance results (3-run average, ms):
    | Metric              | Without patch | With patch | Improvement |
    |---------------------|---------------|------------|-------------|
    | Migration downtime  |        536    |     321    |     40%     |
    | Source (total)      |        344    |     230    |     33%     |
    |   - VGIC put        |        158    |      40    |     75%     |
    |   - VGIC get        |        120    |      19    |     84%     |
    | Destination (total) |        192    |      91    |     53%     |
    |   - VGIC put        |        132    |      27    |     80%     |

Yize Wang (2):
  KVM: arm64: Add batch group constant and data structure to UAPI header
  KVM: arm64: Add VGIC v3 batch register access implementation

 arch/arm64/include/uapi/asm/kvm.h     |  10 +++
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 113 +++++++++++++++++++++++++++++++---
 2 files changed, 114 insertions(+), 9 deletions(-)
 

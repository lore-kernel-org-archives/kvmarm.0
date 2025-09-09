Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638DD2737FD
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 03:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757389463; cv=none; b=f2wapaBDPuPYgmJHSoBt5Tx/gCH2QDkzuboP2UQt84YQa8xu9yFFjISRC5GWPsFi/ytKeONxMAfBAq+k6mrXS/hxQHE2tXGd2rpeqslLkun24KqC/6Sh0fFISv6AieUmZhTxLNkvQuT2J+RKb9sy6mJB6IE8dqi8iYr/zeNQkGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757389463; c=relaxed/simple;
	bh=gDCpq+D8chBeC/sjkf+IgkkpMT8NIfZNa1/+6ArkfhE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Q7h6kiBtg3ql9XcknNmTl9o/GZWWoZMp/5DS3rk7b+tdWOXodqRMywHrkxQS1m6I0ITP/QxtG0qJjaxKE4/8xbR38TeC+yDn+JL16yLe//4l5jc1VcuvlLT2ppgDbFc3lAo+Rtd4IECx7acgOBq/j6JiCnld/h0aw9ugI2ACTM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cLV1m65CqzRkDx;
	Tue,  9 Sep 2025 11:39:40 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id C2D111800B1;
	Tue,  9 Sep 2025 11:44:17 +0800 (CST)
Received: from huawei.com (10.50.165.33) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 11:44:17 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <oliver.upton@linux.dev>, <yuzenghui@huawei.com>, <maz@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <liuyonglong@huawei.com>,
	<wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>
Subject: [PATCH v2 0/3] KVM: arm64: make EL2 feature fields writable in ID_AA64MMFR1_EL1
Date: Tue, 9 Sep 2025 11:44:12 +0800
Message-ID: <20250909034415.3822478-1-yangjinqian1@huawei.com>
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
 dggpemf500013.china.huawei.com (7.185.36.188)

Allow userspace to downgrade EL2 features (VH, TWED, HCX) to ensure VM live
migration compatibility between hosts with varying feature support.

v1: https://lore.kernel.org/linux-arm-kernel/20250325121126.1380681-1-yangjinqian1@huawei.com/

Change Log:
v1->v2:
  -Added support for downgrading TWED and VH fields.
  -Added corresponding test cases to the set_id_regs selftest.

Jinqian Yang (3):
  KVM: arm64: Make ID_AA64MMFR1_EL1.HCX writable from userspace
  KVM: arm64: Make ID_AA64MMFR1_EL1.TWED writable from userspace
  KVM: arm64: Make ID_AA64MMFR1_EL1.VH writable from userspace

 arch/arm64/kvm/sys_regs.c                       | 3 ---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.33.0


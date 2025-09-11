Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA0720E6F3
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 11:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591187; cv=none; b=utFGankP+G0mq75iFXN1ofAlpweX5PZja0q8TBi/kN1R7wZmscfc9/KH3Ll2Qq314zKXSmQRLFJJzgiWP2kRDTzfVcl5yej61li6ATrgXRkwIUqvriETJZ9FlPg19DnImw0OoqZZOtpKMZWk0beGRQvKtnzI13WHkKuP7U1lFOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591187; c=relaxed/simple;
	bh=EGRb3OGYajjFz+8JB/DJDwM4RyFKCzgEFAGSASmRrA0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YySIQL5x9DDBtZu71rYd4efzenyoqgqe5OIjpAVHUfQ6YF5Cj6DCSwcGlO0SSOtHLVqDL7N/dXTjnTRQ3ar2lbl89CAh9Zhh8Y0JBHEdxNaRU2uTKCT8Nukg7z7UxxD60Bi0NF95+iIHRSLk9Jk57Ub8DvR/jNxRa5ZbVtHQ0ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cMwd52PKqzRkHY;
	Thu, 11 Sep 2025 19:41:45 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 63E53140156;
	Thu, 11 Sep 2025 19:46:22 +0800 (CST)
Received: from huawei.com (10.50.165.33) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 11 Sep
 2025 19:46:21 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <oliver.upton@linux.dev>, <yuzenghui@huawei.com>, <maz@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <liuyonglong@huawei.com>,
	<wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>
Subject: [PATCH v3 0/2] KVM: arm64: make EL2 feature fields writable in ID_AA64MMFR1_EL1
Date: Thu, 11 Sep 2025 19:46:19 +0800
Message-ID: <20250911114621.3724469-1-yangjinqian1@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500013.china.huawei.com (7.185.36.188)

Allow userspace to downgrade EL2 features (TWED, HCX) to ensure VM live
migration compatibility between hosts with varying feature support.

Although ID_AA64MMFR1_EL1.VH is an EL2 feature, it is still kept as non-
writable in userspace. When FEAT_E2H0 is not implemented, HCR_EL2.E2H is
res1. When E2H=1, EL2 operates in VHE mode. In this case, if userspace
modifies the VH bit to 0, the Guest's kernel will still run in vEL2, leading
to inconsistency. 

v1: https://lore.kernel.org/linux-arm-kernel/20250325121126.1380681-1-yangjinqian1@huawei.com/
v2: https://lore.kernel.org/linux-arm-kernel/20250909034415.3822478-1-yangjinqian1@huawei.com/

Change Log:
v1->v2:
  -Added support for downgrading TWED and VH fields.
  -Added corresponding test cases to the set_id_regs selftest.

v2->v3:
  -Kept VH non-writable.
  -Separated kernel patches and self-test patches.

Jinqian Yang (2):
  KVM: arm64: Make ID_AA64MMFR1_EL1.{HCX, TWED} writable from userspace
  KVM: arm64: selftests: Test writes to ID_AA64MMFR1_EL1.{HCX, TWED}

 arch/arm64/kvm/sys_regs.c                       | 2 --
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.33.0


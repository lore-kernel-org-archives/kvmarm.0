Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B669E23AB90
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 11:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591188; cv=none; b=iqqMQFdgxuTjqU+5I1z1e80+e3iO+XCTHhg1LxgwqI37F6g8Kl/TbmjUcJdIZJuDPDnYAYyVTrBMZMDZcaXYGwk2E7jrnVRMFbs+xH9af0o/d2yK4F2qlcOqorZuId0t8rLlURIZrL4aMeEcb4fWVSyKZwVh2B/fljN26epnEYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591188; c=relaxed/simple;
	bh=BVvc6avrlAjX11VUYHd+lCNmi70xw2LgwgE1ts0rerg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eHs7dxHmyguV+Z5dyFKmDF+3NrUHeroj7o/0pHLHUaiVwcHz7bj7Eu/pLrG3gbQwmXoKv7vFyJYaSBJojBRgSenTXHk0+hwPaYxt++TnFGZ90Akivpt35CzC66ul/D1AHmq5+g0T0ZJrTapggevH9FGoXRIaVeIw0AuvfGdD+r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cMwff2H4wz2VRbB;
	Thu, 11 Sep 2025 19:43:06 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E7C01402CC;
	Thu, 11 Sep 2025 19:46:23 +0800 (CST)
Received: from huawei.com (10.50.165.33) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 11 Sep
 2025 19:46:22 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <oliver.upton@linux.dev>, <yuzenghui@huawei.com>, <maz@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <liuyonglong@huawei.com>,
	<wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>
Subject: [PATCH v3 2/2] KVM: arm64: selftests: Test writes to ID_AA64MMFR1_EL1.{HCX, TWED}
Date: Thu, 11 Sep 2025 19:46:21 +0800
Message-ID: <20250911114621.3724469-3-yangjinqian1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250911114621.3724469-1-yangjinqian1@huawei.com>
References: <20250911114621.3724469-1-yangjinqian1@huawei.com>
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

Assert that the EL2 features {HCX, TWED} of ID_AA64MMFR1_EL1 are writable
from userspace. They are only allowed to be downgraded in userspace.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index d3bf9204409c..a889550d8aa4 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -165,7 +165,9 @@ static const struct reg_ftr_bits ftr_id_aa64mmfr0_el1[] = {
 static const struct reg_ftr_bits ftr_id_aa64mmfr1_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, TIDCP1, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, AFP, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, HCX, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, ETS, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, TWED, 0),
 	REG_FTR_BITS(FTR_HIGHER_SAFE, ID_AA64MMFR1_EL1, SpecSEI, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, PAN, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR1_EL1, LO, 0),
-- 
2.33.0


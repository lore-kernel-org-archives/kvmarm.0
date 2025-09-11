Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AD425A35E
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 11:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591187; cv=none; b=nA8s0wYE/lxfO2JSjCr4w9BZ6reJmef1rKbVwlBSpkD+EZQGmxA5uwoxvQTI9ZdCUoxuM24aGnZtqKfajvGn/5jOnIYQeYVVTbawWsKJxzqxcLcUMZdzoPYTNltjx9w/2V92a3EfKfMLCuhvmlu0ApiFOni2ckDE5NSFELRZOgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591187; c=relaxed/simple;
	bh=F61FcyF6cWFZvrHH/C00p0MLu0n+NSKb6gh+551RPLg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UT1SHCt3oKKTdWm7rSsJesdcIBX5UNXWVsrxOaYzPfU37TYCDi+qsoQoVfJ18yxGl4+4QT+RTOIA7Qb6S70pjUXRqC3kMDk9stUIr6uHDvqi7HormGrQq4J6y/sPOQNh5aP6fpRzlRndvZji4WfJtT+rgmvD3RKlobiYEaBe+mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cMwff1FNbz24j7v;
	Thu, 11 Sep 2025 19:43:06 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 08FDA180042;
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
Subject: [PATCH v3 1/2] KVM: arm64: Make ID_AA64MMFR1_EL1.{HCX, TWED} writable from userspace
Date: Thu, 11 Sep 2025 19:46:20 +0800
Message-ID: <20250911114621.3724469-2-yangjinqian1@huawei.com>
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

Allow userspace to downgrade {HCX, TWED} in ID_AA64MMFR1_EL1. Userspace can
only change the value from high to low.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
---
 arch/arm64/kvm/sys_regs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82ffb3b3b3cf..db49beb8804e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3002,8 +3002,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				      ~(ID_AA64MMFR0_EL1_RES0 |
 					ID_AA64MMFR0_EL1_ASIDBITS)),
 	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
-					ID_AA64MMFR1_EL1_HCX |
-					ID_AA64MMFR1_EL1_TWED |
 					ID_AA64MMFR1_EL1_XNX |
 					ID_AA64MMFR1_EL1_VH |
 					ID_AA64MMFR1_EL1_VMIDBits)),
-- 
2.33.0


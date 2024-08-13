Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31FB19D085
	for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 14:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723559384; cv=none; b=FzkEcWxDIqFvNsTCltx7ATmISP7nRqY6EzzWAAelUWdzz6GW8Bs03bKcf1md078k4/1NmttFXm2v5L8MTNRd22TLXmQq4is1YDBHWtvxcOesA8G+b0KqkslhAvw1yov44AG01SJOM6WlSyvXuxuD7/XbpjZonO1XL28e9plahLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723559384; c=relaxed/simple;
	bh=NAt7Gvnp/snj1nt0vwVV+Qt/HWeC2LfjQ0cr008nIPA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IyOTrRSwdVQ5+IRUC71HpayM7/TJZuXLYmWLW++29/BsBZzqT9SEPxQ2z4NzDrsxJLkl7JcY3k7kgKHInmTlQbrzZCm/k7oReTKzerGOJxfnJcCgKd0rMUXhpkSlyfJQa9LpvdtfiiuPwGbLn8AUWv8LI1HxCYyvIVXb1Gy06Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WjtxC3HzXz6K9YM;
	Tue, 13 Aug 2024 22:26:39 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 1EFAA140136;
	Tue, 13 Aug 2024 22:29:33 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.126.175.172) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 15:29:26 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <will@kernel.org>, <catalin.marinas@arm.com>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>
Subject: [PATCH] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1 writable from userspace
Date: Tue, 13 Aug 2024 15:28:35 +0100
Message-ID: <20240813142835.77180-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

KVM exposes the OS double lock feature bit to Guests but returns
RAZ/WI on Guest OSDLR_EL1 access. This breaks Guest migration between
systems where this feature support differ. Add support to make this
feature writable from userspace by setting the mask bit. While at it,
set the mask bits for other exposed features in the AA64DFR0_EL1
register as well.

Also update the selftest to cover these fields.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
   This is based on the discussion here(Thanks to Oliver),
   https://lore.kernel.org/all/ZrVSlbVwnaMDShah@linux.dev/
---
 arch/arm64/kvm/sys_regs.c                         | 6 +++++-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c | 4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..adb49d681052 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2376,7 +2376,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK |
+	  .val = ID_AA64DFR0_EL1_DoubleLock_MASK |
+		 ID_AA64DFR0_EL1_CTX_CMPs_MASK |
+		 ID_AA64DFR0_EL1_WRPs_MASK |
+		 ID_AA64DFR0_EL1_BRPs_MASK |
+		 ID_AA64DFR0_EL1_PMUVer_MASK |
 		 ID_AA64DFR0_EL1_DebugVer_MASK, },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index d20981663831..1e6b9594daf8 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -68,6 +68,10 @@ struct test_feature_reg {
 	}
 
 static const struct reg_ftr_bits ftr_id_aa64dfr0_el1[] = {
+	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DoubleLock, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, CTX_CMPs, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, WRPs, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, BRPs, 0),
 	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, PMUVer, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, ID_AA64DFR0_EL1_DebugVer_IMP),
 	REG_FTR_END,
-- 
2.45.2


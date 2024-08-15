Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722A1B375F
	for <kvmarm@lists.linux.dev>; Thu, 15 Aug 2024 16:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723737625; cv=none; b=rXKzxrRbJdSoTxnnO8VKMHsfgZIj/kBsRVwEJxeltRdu8Lx+OnwjeQWxYs/P9uZi3yogArT8eP4mO0iv9fxPMr4umFyvBaHeAqN3iLmQwoaDuTi/cnlUIsDbIc1QriK3IgJfm8SkcktQ0RRHK1cQ2dHaf6w2oDU54iv3WTKRWac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723737625; c=relaxed/simple;
	bh=LAlAFNPkLbQZ2rsS1x/8jzamWztOlnH/Ek+3JvMew0c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UBrVdjAAS4DrJHUutNdD7W6w6GZps5FGIoeVax8W++mCMH7P36Yd4+/wTYch9y3Xo477Z6P4TN1vfKqg6uuaiZ+Iv7XfCRWRKC7zhYw8fDCIypQS8Ws7zQMdgxedNDE4fEwu+weCYH/n3/vOBmXWSuLUuBal5CrSoNBdwGV7wH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wl8rz19LXz6D92H;
	Thu, 15 Aug 2024 23:57:23 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id E43AD140119;
	Fri, 16 Aug 2024 00:00:19 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 15 Aug 2024 17:00:14 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <will@kernel.org>, <catalin.marinas@arm.com>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>
Subject: [PATCH v2] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1 writable from userspace
Date: Thu, 15 Aug 2024 16:59:54 +0100
Message-ID: <20240815155954.85480-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

KVM exposes the OS double lock feature bit to Guests but returns
RAZ/WI on Guest OSDLR_EL1 access. This breaks Guest migration between
systems where this feature differ. Add support to make this feature
writable from userspace by setting the mask bit. While at it, set the
mask bits for the exposed WRPs(Number of Watchpoints) as well.
Also update the selftest to cover these fields.

However we still can't make BRPs and CTX_CMPs fields writable, because
as per ARM ARM DDI 0487K.a, section G2.8.2 Breakpoint types and
linking of breakpoints, highest numbered breakpoints must be context aware
breakpoints. And it will be problematic if userspace decreases the number
of non-context aware breakpoints as it will make the context aware
breakpoints for the guest mapped to a wrong one.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
   v1 --> v2:
   Removed making BRPs and CTX_CMPs writable.
   v1: https://lore.kernel.org/all/20240813142835.77180-1-shameerali.kolothum.thodi@huawei.com/
---
 arch/arm64/kvm/sys_regs.c                         | 13 ++++++++++++-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..e77cd6d1abb5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2376,7 +2376,18 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK |
+	/*
+	 * We can't still make BRPs and CTX_CMPx writable as highest
+	 * numbered breakpoints must be context aware breakpoints(ARM ARM
+	 * DDI 0487K.a, section G2.8.2 Breakpoint types and linking of
+	 * breakpoints). Hence, if the number of non-context aware breakpoints
+	 * for the Guest is decreased by userspace, that will be problematic
+	 * as KVM will map context aware breakpoints for the vCPU to different
+	 * numbered breakpoints for the pCPU.
+	 */
+	  .val = ID_AA64DFR0_EL1_DoubleLock_MASK |
+		 ID_AA64DFR0_EL1_WRPs_MASK |
+		 ID_AA64DFR0_EL1_PMUVer_MASK |
 		 ID_AA64DFR0_EL1_DebugVer_MASK, },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index d20981663831..6edc5412abe8 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -68,6 +68,8 @@ struct test_feature_reg {
 	}
 
 static const struct reg_ftr_bits ftr_id_aa64dfr0_el1[] = {
+	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DoubleLock, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, WRPs, 0),
 	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, PMUVer, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, ID_AA64DFR0_EL1_DebugVer_IMP),
 	REG_FTR_END,
-- 
2.45.2


Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807B4156967
	for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 13:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723814925; cv=none; b=EbA21XkKQJLQ4fNIeeATJvdW25fxdZTY8ncxtbsSZUz2W2DL8FqOkg7WkYnodz0WnjkYyhrImQVDl+c7uiNpZXE5p5cbzFuopqWcwEHUQBEIuXfsYNvIS5pOHxd2z5m/2/khdbdZdCVjfkvUHUhTiMnDv5hYcHOvwYlqTPLja6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723814925; c=relaxed/simple;
	bh=Lf7Td2aJBrsVS6sGbAVw2JycKPXUAJiw0B+zerzyxOM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DXxNBmFEprHlqAEXAE5bAnPzvgtobEXfubmvHQg1PxGvAmrSATMddhVWcbd9j1uWPKXRRcJT5d8q0g5Ckjv3mXhMyfV27iughmSDViBl4+91OH7gLilCMa4U2Scgo+cyB+7r11mRgBM1KF7Tpptuxx7V33PLdY2XR+SAUIOUS2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WljRT3gjwz6K90M;
	Fri, 16 Aug 2024 21:25:41 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 961D61400DB;
	Fri, 16 Aug 2024 21:28:39 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 14:28:33 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <will@kernel.org>, <catalin.marinas@arm.com>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>
Subject: [PATCH v3] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1 writable from userspace
Date: Fri, 16 Aug 2024 14:28:19 +0100
Message-ID: <20240816132819.34316-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

KVM exposes the OS double lock feature bit to Guests but returns
RAZ/WI on Guest OSDLR_EL1 access. This breaks Guest migration between
systems where this feature differ. Add support to make this feature
writable from userspace by setting the mask bit. While at it, set the
mask bits for the exposed WRPs(Number of Watchpoints) as well.
Also update the selftest to cover these fields.

However we still can't make BRPs and CTX_CMPs fields writable, because
as per ARM ARM DDI 0487K.a, section D2.8.3 Breakpoint types and
linking of breakpoints, highest numbered breakpoints(BRPs) must be
context aware breakpoints(CTX_CMPs). KVM does not trap + emulate the
breakpoint registers, and as such cannot support a layout that misaligns
with the underlying hardware.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
v2 --> v3:
   -Updated comments on BRPs and CTX_CMPs. Corrected ARM ARM reference.
   v2:https://lore.kernel.org/kvmarm/20240815155954.85480-1-shameerali.kolothum.thodi@huawei.com/
---
 arch/arm64/kvm/sys_regs.c                        | 16 +++++++++++++++-
 .../testing/selftests/kvm/aarch64/set_id_regs.c  |  2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..5a49e8331fbf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2376,7 +2376,21 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK |
+	/*
+	 * Prior to FEAT_Debugv8.9, the architecture defines context-aware
+	 * breakpoints (CTX_CMPs) as the highest numbered breakpoints (BRPs).
+	 * KVM does not trap + emulate the breakpoint registers, and as such
+	 * cannot support a layout that misaligns with the underlying hardware.
+	 * While it may be possible to describe a subset that aligns with
+	 * hardware, just prevent changes to BRPs and CTX_CMPs altogether for
+	 * simplicity.
+	 *
+	 * See DDI0487K.a, section D2.8.3 Breakpoint types and linking
+	 * of breakpoints for more details.
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


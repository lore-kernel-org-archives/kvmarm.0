Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46821487C0
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 12:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723121908; cv=none; b=beTXdFR6WzIC5FFXWYMHNKN0Rr0nqCMbcN9eBGwVU39Vnc2EwPnThK+o7ma1eeT59lBond+HlMOgy9M6oWzQscOLAp2WxmbqrR6VOdCKjb/iHBtwhyxTX9ulxQ2xcBKvBZH1bYFEBFEqldunjZHyOtETa7QdHrz9QPPzFBbTXjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723121908; c=relaxed/simple;
	bh=Z8ZHbqZqEFtjMwwrzeOphbQj08fVPq3hy5xlhDMdDQg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SjSS4yLrDPr2LssgZa/LVGjJp+08H5vApOrDJ4eL6hKKLtJpX0KjUR9iAGQ2bCNzlhQzaeADbDB+EQp0N4O1lShQoWyoyxkw+P4lRC4YnwDHW0nBzRBU8c0RDGtWZVqzyWXYv5bCvd2FoXKvA0T5ZJwvN4MW2vopmaLxaSXoT5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wfn883pWPz6K7cB;
	Thu,  8 Aug 2024 20:55:20 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 9C9EC1401DC;
	Thu,  8 Aug 2024 20:58:17 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 8 Aug 2024 13:58:11 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <will@kernel.org>, <catalin.marinas@arm.com>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>
Subject: [PATCH] KVM: arm64: Disable OS double lock visibility by default and ignore VMM writes
Date: Thu, 8 Aug 2024 13:57:11 +0100
Message-ID: <20240808125711.14368-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

KVM exposes the OS double lock feature bit to Guests but returns
RAZ/WI on Guest OSDLR_EL1 access. Make sure we are hiding OS double
lock from Guests now. However we can't hide DoubleLock if the reported
DebugVer is < 8.2. So report a minimum DebugVer of 8.2 to Guests.

All this may break migration from the older kernels. Take care of
that by ignoring VMM writes for these values.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
Note:
 - I am not very sure on reporting DebugVer a min of 8.2. Hopefully this is
   fine. Please let me know.
   
Thanks,
Shameer
---  
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..06e57d7730d8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1704,13 +1704,14 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return val;
 }
 
-#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
+#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, min_val, max_val)	       \
 ({									       \
 	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
+	(__f_val) = max_t(u64, __f_val, SYS_FIELD_VALUE(reg, field, min_val)); \
 	(val) &= ~reg##_##field##_MASK;					       \
 	(val) |= FIELD_PREP(reg##_##field##_MASK,			       \
 			    min(__f_val,				       \
-				(u64)SYS_FIELD_VALUE(reg, field, limit)));     \
+				(u64)SYS_FIELD_VALUE(reg, field, max_val)));   \
 	(val);								       \
 })
 
@@ -1719,7 +1720,7 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 
-	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P2, V8P8);
 
 	/*
 	 * Only initialize the PMU version if the vCPU was configured with one.
@@ -1732,6 +1733,10 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	/* Hide SPE from guests */
 	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
 
+	/* Hide DoubleLock from guests */
+	val &= ~ID_AA64DFR0_EL1_DoubleLock_MASK;
+	val |= SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DoubleLock, NI);
+
 	return val;
 }
 
@@ -1739,6 +1744,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	u64 hw_val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
 
@@ -1765,6 +1771,28 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	 */
 	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
 		return -EINVAL;
+	else if (debugver < ID_AA64DFR0_EL1_DebugVer_V8P2) {
+		/*
+		 * KVM now reports a minimum DebugVer 8.2 to Guests. In order to keep
+		 * the migration working from old kernels, check and ignore the VMM
+		 * write.
+		 */
+		if ((hw_val & ID_AA64DFR0_EL1_DebugVer_MASK) ==
+		    (val & ID_AA64DFR0_EL1_DebugVer_MASK)) {
+			val &= ~ID_AA64DFR0_EL1_DebugVer_MASK;
+			val |= SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DebugVer, V8P2);
+		}
+	}
+	/*
+	 * KVM used to expose OS double lock feature bit to Guests but returned
+	 * RAZ/WI on Guest OSDLR_EL1 access. We are hiding OS double lock now.
+	 * But for migration from old kernels to work ignore the VMM write.
+	 */
+	if ((hw_val & ID_AA64DFR0_EL1_DoubleLock_MASK) ==
+	    (val & ID_AA64DFR0_EL1_DoubleLock_MASK)) {
+		val &= ~ID_AA64DFR0_EL1_DoubleLock_MASK;
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DoubleLock, NI);
+	}
 
 	return set_id_reg(vcpu, rd, val);
 }
@@ -1779,7 +1807,7 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu))
 		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
 
-	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, NI, Debugv8p8);
 
 	return val;
 }
-- 
2.45.2


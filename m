Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FD514D2A0
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 07:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729582828; cv=none; b=NFrZol6uvSRsS7PtKDRKwfud2vTAp88h2eYjT5sgb+v3AA98nwxzwX/zAy7Qbb55i6aq4RwwTWOQE0TJiTIux35h/f7nJfCVIus8M1urUzwD17N6kVOLc+whbUn6mJ5NPTVeSPwRNXhcL7YxogZzzCcwvagsuYw1uzFb+dsPTZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729582828; c=relaxed/simple;
	bh=DLQGEQhj5L7KhMleIAA8agUAzNfqiSusuj3bfiExWKk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=vAWApZNesdkeNrXVdgkRSrdCUDFsfafnevnFBWmBxfmeW86E5d4ezGlf1iBZoeqhgCGODw5qmSXfVVY5PuxI2wmjG2G/RIs0zY1jVGtgmi7KqskpTgOPaXqx/sBGyV7Fnq5NZxSDDXO6V0KoIN7FxP5pbdRx+PpZn5XKDOBG88w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XXkVn1WGgz6GFRt;
	Tue, 22 Oct 2024 15:35:45 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id C562C1400DB;
	Tue, 22 Oct 2024 15:40:23 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 09:40:18 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <james.morse@arm.com>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<sebott@redhat.com>, <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH v2] KVM: arm64: Make L1Ip feature in CTR_EL0 writable from userspace
Date: Tue, 22 Oct 2024 08:39:43 +0100
Message-ID: <20241022073943.35764-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 frapeml500008.china.huawei.com (7.182.85.71)

Only allow userspace to set VIPT(0b10) or PIPT(0b11) for L1Ip based on
what hardware reports as both AIVIVT (0b01) and VPIPT (0b00) are
documented as reserved.

Using a VIPT for Guest where hardware reports PIPT may lead to over
invalidation, but is still correct. Hence, we can allow downgrading
PIPT to VIPT, but not the other way around.

Reviewed-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
v1: 
https://lore.kernel.org/kvmarm/20241017085925.40532-1-shameerali.kolothum.thodi@huawei.com/

Changes from v1:
 -As per Marc's suggestion modified the way set_ctr_el0() restricted
  the write which implied ordered values for the types. Instead
  explicitly listed  all possible policy types.
 -Added R-by tags(Thanks!).

Thanks,
Shameer
---
 arch/arm64/kvm/sys_regs.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d97ccf1c1558..0a0f336b0edd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1872,6 +1872,34 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, user_val);
 }
 
+static int set_ctr_el0(struct kvm_vcpu *vcpu,
+		       const struct sys_reg_desc *rd, u64 user_val)
+{
+	u8 user_L1Ip = SYS_FIELD_GET(CTR_EL0, L1Ip, user_val);
+
+	/*
+	 * Both AIVIVT (0b01) and VPIPT (0b00) are documented as reserved.
+	 * Hence only allow to set VIPT(0b10) or PIPT(0b11) for L1Ip based
+	 * on what hardware reports.
+	 *
+	 * Using a VIPT software model on PIPT will lead to over invalidation,
+	 * but still correct. Hence, we can allow downgrading PIPT to VIPT,
+	 * but not the other way around. This is handled via arm64_ftr_safe_value()
+	 * as CTR_EL0 ftr_bits has L1Ip field with type FTR_EXACT and safe value
+	 * set as VIPT.
+	 */
+	switch (user_L1Ip) {
+	case CTR_EL0_L1Ip_RESERVED_VPIPT:
+	case CTR_EL0_L1Ip_RESERVED_AIVIVT:
+		return -EINVAL;
+	case CTR_EL0_L1Ip_VIPT:
+	case CTR_EL0_L1Ip_PIPT:
+		return set_id_reg(vcpu, rd, user_val);
+	default:
+		return -ENOENT;
+	}
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -2614,10 +2642,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
-	ID_WRITABLE(CTR_EL0, CTR_EL0_DIC_MASK |
-			     CTR_EL0_IDC_MASK |
-			     CTR_EL0_DminLine_MASK |
-			     CTR_EL0_IminLine_MASK),
+	ID_FILTERED(CTR_EL0, ctr_el0,
+		    CTR_EL0_DIC_MASK |
+		    CTR_EL0_IDC_MASK |
+		    CTR_EL0_DminLine_MASK |
+		    CTR_EL0_L1Ip_MASK |
+		    CTR_EL0_IminLine_MASK),
 	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
 	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
-- 
2.45.2


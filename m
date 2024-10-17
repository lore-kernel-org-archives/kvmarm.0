Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538641D6DA8
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 09:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729155606; cv=none; b=odbPk2GfhEW3U754eylthb4bDjfz7h/uIya16ROjwmgmOWYTDnsVhuu9tZO7HL/OwMgqFlzEtEpbpoEnVx/kpiUMtN4bj3Cc76Vfu4yEUjqzVPhvMv5bAa+tf+M2EMws9sLfQhdTrfLKDmpHAl7TjDdhDEi8F2UMyNWJNabzVlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729155606; c=relaxed/simple;
	bh=zHNKQUYs3rfK8SE3u86OQf3l9WxgQIJBTt3vuvriDA0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gvIadbpPL4hvk1iqmd+DYkpdNzorxqIYZoOu8/e2CY/x3P88C5JxAKOJmnUPM6jf/8kqaJ7bvc8DtqUIrKUfUjcMos271YPxCm14eK+fuTbawwQNVcyb6wOvrkzspCad52z4Acb4G8HC2d1ZHWoCeVQGcFCw/pIjnSjdAjTIQrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XThbX0FFSz6JBH1;
	Thu, 17 Oct 2024 16:59:20 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id D0BE41400DB;
	Thu, 17 Oct 2024 16:59:59 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 17 Oct 2024 10:59:54 +0200
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <james.morse@arm.com>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
Subject: [PATCH] KVM: arm64: Make L1Ip feature in CTR_EL0 writable from userspace
Date: Thu, 17 Oct 2024 09:59:25 +0100
Message-ID: <20241017085925.40532-1-shameerali.kolothum.thodi@huawei.com>
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

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
This is based on the dicsussion here[0].
https://lore.kernel.org/kvmarm/0db19a081d9e41f08b0043baeef16f16@huawei.com/

Also depends on Joey's series[1] as it make use of the ID_FILTERED macro.

I am not sure we need to explicitly make the ftr type as FTR_LOWER_SAFE
in kvm_arm64_ftr_safe_value() or as mentioned below can depend on
arm64_ftr_safe_value() for this ftr bits.

Please take a look and let me know.

Thanks,
Shameer

[0] https://lore.kernel.org/kvmarm/0db19a081d9e41f08b0043baeef16f16@huawei.com/
[1] https://lore.kernel.org/kvmarm/20241015133923.3910916-1-joey.gouly@arm.com/
---
 arch/arm64/kvm/sys_regs.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d97ccf1c1558..819dcb63febd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1872,6 +1872,28 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
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
+	 * as CTR_EL0 ftr_bits has L1Ip field type FTR_EXACT with safe value
+	 * set as VIPT)
+	 */
+	if (user_L1Ip < CTR_EL0_L1Ip_VIPT)
+		return -EINVAL;
+
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -2614,10 +2636,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
-	ID_WRITABLE(CTR_EL0, CTR_EL0_DIC_MASK |
-			     CTR_EL0_IDC_MASK |
-			     CTR_EL0_DminLine_MASK |
-			     CTR_EL0_IminLine_MASK),
+	ID_FILTERED(CTR_EL0, ctr_el0,
+			CTR_EL0_DIC_MASK |
+			CTR_EL0_IDC_MASK |
+			CTR_EL0_DminLine_MASK |
+			CTR_EL0_L1Ip_MASK |
+			CTR_EL0_IminLine_MASK),
 	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
 	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
-- 
2.45.2


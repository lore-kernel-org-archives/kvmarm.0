Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F531E9B1A
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 02:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768789866; cv=none; b=cEPysU2q6p+Y4P+88d6LvrwdVp7DSSn6NDz3IgRHeXfPi/6iMb+aUs2HgHuFMDrm4jD5gdFqKbfodurqyQYBnWSZ9lhLffR+Xa3M5GDvfl4HMyLpvF/qUXfTeeJwe+4OaqNxWPNSFMfVv9Q6EeQcrWJLC8ysbXY9vt2a0BcG1iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768789866; c=relaxed/simple;
	bh=WrutP8IGtvzUgmZkjyqHBNWX/DTRFuU57D9N51F92+8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RSwjVUjLmXdoupaBSp5mm827BjIJDWjY+s5sHE/RDwlLD2tU9dPlLaLr+FOurC02/uc0GTHTh+WyteLGPcfdy0VBs8uhFDYkZVCUSRHi69RZAJCTktER+O614ekNQ+/vXK/mTJ56NWvRDLbvIRhc12HyH5Oqq/5izyzpIArzsMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dvZ920QSPznTYS;
	Mon, 19 Jan 2026 10:27:02 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 648F140565;
	Mon, 19 Jan 2026 10:31:01 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Jan 2026 10:31:01 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 19 Jan
 2026 10:31:00 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <arnd@arndb.de>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH v8 RESEND 5/7] KVM: arm64: Enable FEAT_{LS64, LS64_V} in the supported guest
Date: Mon, 19 Jan 2026 10:29:26 +0800
Message-ID: <20260119022928.149358-6-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20260119022928.149358-1-wangzhou1@hisilicon.com>
References: <20260119022928.149358-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200004.china.huawei.com (7.202.195.237)

From: Yicong Yang <yangyicong@hisilicon.com>

Using FEAT_{LS64, LS64_V} instructions in a guest is also controlled
by HCRX_EL2.{EnALS, EnASR}. Enable it if guest has related feature.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bab967d65715..29291e25ecfd 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -695,6 +695,12 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_sctlr2(kvm))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_SCTLR2En;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnALS;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
 	}
 }
 #endif /* __ARM64_KVM_EMULATE_H__ */
-- 
2.33.0


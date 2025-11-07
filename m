Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5052DF141
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 07:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762500149; cv=none; b=awIcIe9TrNREB+1kzr+SsmN0h8aZc2arZBtunrZTGnvJaV4xtnbkrYnZJ+vMe+0uYRUlYxp/g0fr3jo+PLU6kWWTG6/KFlP91VcvUPLmtZOKyCItKrJ6AwKDegs64mVPi6HKAwagqLQW/Irxo9BHomPIv5Y44/Nsma5KLULBftY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762500149; c=relaxed/simple;
	bh=ZF1WCBc/7BpdhxLUYanafVkhMdYKp/sXJfKD2XkXJNU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oyVYZbipmPG/4QPe5+VoAkfzdQduL25ULTJnLF6KFGBrhhDd5G+SoxGY5wkFtthicu3n8pXZvg16Y2N16XRH0OzTJZoHRfxSF1U0ySlVS6146PlIdMvSK4PiHCpbMBBrzFvCN2e00QxgX9PRQ1Tv5YIPBn0d/CgGw+bWT799jQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4d2r7Z4Df5z1prLF;
	Fri,  7 Nov 2025 15:20:42 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 9684F18048E;
	Fri,  7 Nov 2025 15:22:19 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 7 Nov 2025 15:22:19 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 7 Nov
 2025 15:22:18 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH v7 6/7] KVM: arm64: Enable FEAT_{LS64, LS64_V} in the supported guest
Date: Fri, 7 Nov 2025 15:21:26 +0800
Message-ID: <20251107072127.448953-7-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20251107072127.448953-1-wangzhou1@hisilicon.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200004.china.huawei.com (7.202.195.237)

From: Yicong Yang <yangyicong@hisilicon.com>

Using FEAT_{LS64, LS64_V} instructions in a guest is also controlled
by HCRX_EL2.{EnALS, EnASR}. Enable it if guest has related feature.

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


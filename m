Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1A37E
	for <kvmarm@lists.linux.dev>; Tue, 20 Dec 2022 02:50:22 +0000 (UTC)
Received: from dggpemm500002.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NbgyC1tz5zmWZg;
	Tue, 20 Dec 2022 10:49:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.246) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 20 Dec 2022 10:50:13 +0800
From: Dong Bo <dongbo4@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>
CC: Nianyao Tang <tangnianyao@huawei.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>, Alexandru Elisei
	<alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver
 Upton <oliver.upton@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: Synchronize SMEN on vcpu schedule out
Date: Tue, 20 Dec 2022 18:50:24 +0800
Message-ID: <20221220105024.13484-1-dongbo4@huawei.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.246]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Message-ID: <20221220105024.lvYtjiMoUx25lMtJnM6DHZz_fB46OtumR5ptKNGtUto@z>

From: Nianyao Tang <tangnianyao@huawei.com>

If we have VHE and need to reenable SME for host in
kvm_arch_vcpu_put_fp, CPACR.SMEN is modified from 0 to 1. Trap
control for reading SVCR is modified from enable to disable.
Synchronization is needed before reading SVCR later in
fpsimd_save, or it may cause sync exception which can not be
handled by host.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
---
 arch/arm64/kvm/fpsimd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 02dd7e9ebd39..f5799f571317 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -184,6 +184,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			sysreg_clear_set(CPACR_EL1,
 					 CPACR_EL1_SMEN_EL0EN,
 					 CPACR_EL1_SMEN_EL1EN);
+		isb();
 	}
 
 	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
-- 
1.8.3.1


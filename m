Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966ACC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 22 Dec 2022 12:12:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDF6A4BA81;
	Thu, 22 Dec 2022 07:11:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7LlUz7LXDXn0; Thu, 22 Dec 2022 07:11:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42CBA4BA82;
	Thu, 22 Dec 2022 07:11:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 898154B646
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 21:50:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4v+EMUqyI0Lq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 21:50:17 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 072864B63F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 21:50:16 -0500 (EST)
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
Subject: [PATCH] KVM: arm64: Synchronize SMEN on vcpu schedule out
Date: Tue, 20 Dec 2022 18:50:24 +0800
Message-ID: <20221220105024.13484-1-dongbo4@huawei.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
X-Originating-IP: [10.69.192.246]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Thu, 22 Dec 2022 07:11:57 -0500
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

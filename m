Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABA7C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Dec 2021 14:17:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D82549F08;
	Thu, 30 Dec 2021 09:17:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YLrGR6bJVFcn; Thu, 30 Dec 2021 09:17:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5A1E49EFA;
	Thu, 30 Dec 2021 09:17:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A33D249EFA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 09:17:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gvb6lT3w6x9Q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Dec 2021 09:17:17 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 717D249EF3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Dec 2021 09:17:17 -0500 (EST)
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.54])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JPr1R3k3Hzbjkb;
 Thu, 30 Dec 2021 22:16:43 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 30 Dec 2021 22:17:13 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 30 Dec 2021 22:17:12 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: arm64: Fix comment typo in kvm_vcpu_finalize_sve()
Date: Thu, 30 Dec 2021 22:15:35 +0800
Message-ID: <20211230141535.1389-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
Cc: maz@kernel.org
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

kvm_arm_init_arch_resources() was renamed to kvm_arm_init_sve() in
commit a3be836df7cb ("KVM: arm/arm64: Demote
kvm_arm_init_arch_resources() to just set up SVE"). Fix the function
name in comment of kvm_vcpu_finalize_sve().

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/kvm/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3d4278770525..1cd1c10b6190 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -101,7 +101,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Responsibility for these properties is shared between
-	 * kvm_arm_init_arch_resources(), kvm_vcpu_enable_sve() and
+	 * kvm_arm_init_sve(), kvm_vcpu_enable_sve() and
 	 * set_sve_vls().  Double-check here just to be sure:
 	 */
 	if (WARN_ON(!sve_vl_valid(vl) || vl > sve_max_virtualisable_vl() ||
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

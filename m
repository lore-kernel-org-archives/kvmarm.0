Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B380C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 09:26:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0C814B41C;
	Fri, 20 May 2022 05:26:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GyGVrLqddE9y; Fri, 20 May 2022 05:26:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2728B4B408;
	Fri, 20 May 2022 05:26:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7124B415
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 04:54:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HxNmJt3enmb5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 04:54:09 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A3A44B40A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 04:54:09 -0400 (EDT)
Received: from kwepemi500023.china.huawei.com (unknown [172.30.72.57])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L4L6d3Cm4zQkGR;
 Fri, 20 May 2022 16:51:05 +0800 (CST)
Received: from huawei.com (10.175.112.208) by kwepemi500023.china.huawei.com
 (7.221.188.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 20 May
 2022 16:54:00 +0800
From: Peng Wu <wupeng58@huawei.com>
To: <maz@kernel.org>, <james.morse@arm.com>, <alexandru.elisei@arm.com>,
 <catalin.marinas@arm.com>, <will@kernel.org>
Subject: [PATCH] KVM: arm64: cancel the return value check of
 kvm_arm_init_sve()
Date: Fri, 20 May 2022 08:49:11 +0000
Message-ID: <20220520084911.44253-1-wupeng58@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500023.china.huawei.com (7.221.188.76)
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Fri, 20 May 2022 05:26:45 -0400
Cc: wupeng58@huawei.com, yuehaibing@huawei.com, linux-kernel@vger.kernel.org,
 liwei391@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Currently, kvm_arm_init_sve() has only a unique return value,
so change the return value type of kvm_arm_init_sve() to void.

Meanwhile, there's no need to check the return value of
kvm_arm_init_sve() in kvm_arch_init().

Signed-off-by: Peng Wu <wupeng58@huawei.com>
---
 arch/arm64/kvm/arm.c   | 4 +---
 arch/arm64/kvm/reset.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 400bb0fe2745..5ec90991c68e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2206,9 +2206,7 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		return err;
 
-	err = kvm_arm_init_sve();
-	if (err)
-		return err;
+	kvm_arm_init_sve();
 
 	err = kvm_arm_vmid_alloc_init();
 	if (err) {
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 6c70c6f61c70..abae7b24eb8b 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -43,7 +43,7 @@ static u32 kvm_ipa_limit;
 
 unsigned int kvm_sve_max_vl;
 
-int kvm_arm_init_sve(void)
+void kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
 		kvm_sve_max_vl = sve_max_virtualisable_vl();
@@ -65,8 +65,6 @@ int kvm_arm_init_sve(void)
 			pr_warn("KVM: SVE vector length for guests limited to %u bytes\n",
 				kvm_sve_max_vl);
 	}
-
-	return 0;
 }
 
 static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

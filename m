Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AF5C00A89
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D25F52145D
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D25F52145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 768A14B57E;
	Sun,  1 Nov 2020 22:37:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3g+fOEiHYQUC; Sun,  1 Nov 2020 22:37:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77AAC4B54B;
	Sun,  1 Nov 2020 22:37:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF4534B584
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mSitTBUX95dV for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 Nov 2020 22:37:37 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE19E4B588
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:37 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CPdsC168PzhfbV;
 Mon,  2 Nov 2020 11:37:35 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:37:24 +0800
From: Peng Liang <liangpeng10@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [RFC v3 11/12] kvm: arm64: Check consistent of ID register
Date: Mon, 2 Nov 2020 11:34:21 +0800
Message-ID: <20201102033422.657391-12-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102033422.657391-1-liangpeng10@huawei.com>
References: <20201102033422.657391-1-liangpeng10@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org
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

All vCPUs in same VM need to have same values of ID registers.  If not,
the vCPU is not allowed to run.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/kvm/arm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5a153a109317..0d7c4d4ab204 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -515,6 +515,22 @@ static void update_vmid(struct kvm_vmid *vmid)
 	spin_unlock(&kvm_vmid_lock);
 }
 
+static bool kvm_arm_id_regs_are_consistent(const struct kvm_vcpu *vcpu)
+{
+	int i, j;
+	int online_vcpus = atomic_read(&vcpu->kvm->online_vcpus);
+
+	for (i = 0; i < online_vcpus; ++i) {
+		if (memcmp(vcpu->arch.ctxt.sys_regs + ID_REG_BASE,
+			   vcpu->kvm->vcpus[i]->arch.ctxt.sys_regs + ID_REG_BASE,
+			   sizeof(vcpu->arch.ctxt.sys_regs[0]) * KVM_ARM_ID_REG_MAX_NUM)) {
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -526,6 +542,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	if (!kvm_arm_id_regs_are_consistent(vcpu))
+		return -EPERM;
+
 	vcpu->arch.has_run_once = true;
 
 	if (likely(irqchip_in_kernel(kvm))) {
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

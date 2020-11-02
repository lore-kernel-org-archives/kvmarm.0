Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CC3C55178
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B05E6208A9
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B05E6208A9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 441B14B4E1;
	Sun,  1 Nov 2020 22:37:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mrqA+ZTv4uuN; Sun,  1 Nov 2020 22:37:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27CC94B569;
	Sun,  1 Nov 2020 22:37:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E7A4B555
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DMzqZfld2orl for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 Nov 2020 22:37:33 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E844A4B4E1
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:32 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CPds41DkwzkdNl;
 Mon,  2 Nov 2020 11:37:28 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:37:23 +0800
From: Peng Liang <liangpeng10@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [RFC v3 10/12] kvm: arm64: Make other ID registers configurable
Date: Mon, 2 Nov 2020 11:34:20 +0800
Message-ID: <20201102033422.657391-11-liangpeng10@huawei.com>
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

For other ID registers, we only need to check that each ID field is no
greater than that of host (host support corresponding feature).

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/kvm/sys_regs.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1bcfaf738491..42880800941a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1265,10 +1265,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 
 /*
  * cpufeature ID register user accessors
- *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
  */
 static int __get_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1292,9 +1288,18 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (err)
 		return err;
 
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd, raz))
-		return -EINVAL;
+	if (raz) {
+		if (val != 0)
+			return -EINVAL;
+	} else {
+		u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
+				     (u32)rd->CRm, (u32)rd->Op2);
+
+		err = check_features(reg_id, val);
+		if (err)
+			return err;
+		__vcpu_sys_reg(vcpu, ID_REG_INDEX(reg_id)) = val;
+	}
 
 	return 0;
 }
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

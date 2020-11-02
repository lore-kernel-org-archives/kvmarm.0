Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEB9C00A89
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59FF72080A
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59FF72080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC63E4B542;
	Sun,  1 Nov 2020 22:37:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Obtljo8uuZH; Sun,  1 Nov 2020 22:37:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4EA24B557;
	Sun,  1 Nov 2020 22:37:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 083784B545
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7FLkR8GIeCP9 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 Nov 2020 22:37:28 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B0994B485
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:27 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CPdry561gzLp47;
 Mon,  2 Nov 2020 11:37:22 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:37:19 +0800
From: Peng Liang <liangpeng10@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [RFC v3 07/12] kvm: arm64: Make ID_AA64ISAR1_EL1 configurable
Date: Mon, 2 Nov 2020 11:34:17 +0800
Message-ID: <20201102033422.657391-8-liangpeng10@huawei.com>
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

Except that each ID field should be not greater than that of host, if
the vCPU has not enabled Generic Pointer authentication, then GPA, GPI,
APA, and API must be 0.  Otherwise, GPA and GPI are exclusive; APA and
API are exclusive.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/kvm/sys_regs.c | 42 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76b39cab50b8..2ea165d09c7b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1437,6 +1437,46 @@ static int set_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int set_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
+		const struct sys_reg_desc *rd,
+		const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
+			     (u32)rd->CRm, (u32)rd->Op2);
+	int err;
+	u64 val;
+	unsigned int gpi, gpa, api, apa;
+
+	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
+	if (err)
+		return err;
+	err = check_features(reg_id, val);
+	if (err)
+		return err;
+
+	gpi = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT);
+	gpa = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPA_SHIFT);
+	api = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_API_SHIFT);
+	apa = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_APA_SHIFT);
+	if (!vcpu_has_ptrauth(vcpu) && (gpa || gpi || apa || api))
+		return -EINVAL;
+	/*
+	 * 1. If the value of ID_AA64ISAR1_EL1.GPA is non-zero, then
+	 *    ID_AA64ISAR1_EL1.GPI must have the value 0;
+	 * 2. If the value of ID_AA64ISAR1_EL1.GPI is non-zero, then
+	 *    ID_AA64ISAR1_EL1.GPA must have the value 0;
+	 * 3. If the value of ID_AA64ISAR1_EL1.APA is non-zero, then
+	 *    ID_AA64ISAR1_EL1.API must have the value 0;
+	 * 4. If the value of ID_AA64ISAR1_EL1.API is non-zero, then
+	 *    ID_AA64ISAR1_EL1.APA must have the value 0;
+	 */
+	if ((gpi && gpa) || (api && apa))
+		return -EINVAL;
+
+	__vcpu_sys_reg(vcpu, ID_REG_INDEX(reg_id)) = val;
+	return 0;
+}
+
 static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
 {
@@ -1652,7 +1692,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* CRm=6 */
 	{ SYS_DESC(SYS_ID_AA64ISAR0_EL1), access_id_reg, .get_user = get_id_reg, .set_user = set_id_aa64isar0_el1 },
-	ID_SANITISED(ID_AA64ISAR1_EL1),
+	{ SYS_DESC(SYS_ID_AA64ISAR1_EL1), access_id_reg, .get_user = get_id_reg, .set_user = set_id_aa64isar1_el1 },
 	ID_UNALLOCATED(6,2),
 	ID_UNALLOCATED(6,3),
 	ID_UNALLOCATED(6,4),
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

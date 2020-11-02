Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592F0C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D86B5207BB
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D86B5207BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 749624B229;
	Sun,  1 Nov 2020 22:37:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xVoytMFPBHtd; Sun,  1 Nov 2020 22:37:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67B714B512;
	Sun,  1 Nov 2020 22:37:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A614B4E1
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3aAn-P8lIKXa for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 Nov 2020 22:37:22 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC2094B4E8
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:21 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CPdrs4zzgzLsbr;
 Mon,  2 Nov 2020 11:37:17 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:37:12 +0800
From: Peng Liang <liangpeng10@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [RFC v3 04/12] kvm: arm64: Make ID_AA64PFR0_EL1 configurable
Date: Mon, 2 Nov 2020 11:34:14 +0800
Message-ID: <20201102033422.657391-5-liangpeng10@huawei.com>
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

Except CSV2, which is allowed to set 1 if the value of host is 0, each
ID field should be not greater than that of host.  And FP and AdvSIMD
must have the same value.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/kvm/sys_regs.c | 46 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 68ed83657c07..bcc57cbe0421 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1323,6 +1323,50 @@ static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return __set_id_reg(vcpu, rd, uaddr, true);
 }
 
+static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+		const struct sys_reg_desc *rd,
+		const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
+			     (u32)rd->CRm, (u32)rd->Op2);
+	int err;
+	u64 val, host_val, tmp_val;
+	unsigned int fp, asimd;
+
+	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
+	if (err)
+		return err;
+
+	/*
+	 * If the hardware is not affected by Spectre-v2 and doesn't support
+	 * CSV2 but userspace set CSV2 to 1, we can ignore it when checking.
+	 */
+	host_val = read_sanitised_ftr_reg(reg_id);
+	tmp_val = val;
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED &&
+	    !cpuid_feature_extract_unsigned_field(host_val, ID_AA64PFR0_CSV2_SHIFT) &&
+	    cpuid_feature_extract_unsigned_field(tmp_val, ID_AA64PFR0_CSV2_SHIFT) == 1) {
+		tmp_val &= ~(0xfULL << ID_AA64PFR0_CSV2_SHIFT);
+	}
+	err = check_features(reg_id, tmp_val);
+	if (err)
+		return err;
+
+	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
+	asimd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
+	if (fp != asimd)
+		return -EINVAL;
+
+	if (!vcpu_has_sve(vcpu) &&
+	    cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_SVE_SHIFT))
+		return -EINVAL;
+	if (cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_AMU_SHIFT))
+		return -EINVAL;
+
+	__vcpu_sys_reg(vcpu, ID_REG_INDEX(reg_id)) = val;
+	return 0;
+}
+
 static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
 {
@@ -1517,7 +1561,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	ID_SANITISED(ID_AA64PFR0_EL1),
+	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), access_id_reg, .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1 },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

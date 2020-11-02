Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCBEC2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7480122267
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 03:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7480122267
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0FBC4B58C;
	Sun,  1 Nov 2020 22:37:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NZNFPAZBuRS6; Sun,  1 Nov 2020 22:37:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC5414B565;
	Sun,  1 Nov 2020 22:37:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0617F4B485
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3DgNWt8jvREO for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 Nov 2020 22:37:23 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8112B4B4F7
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Nov 2020 22:37:22 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CPdrm43rPzLsb0;
 Mon,  2 Nov 2020 11:37:12 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:37:05 +0800
From: Peng Liang <liangpeng10@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [RFC v3 03/12] kvm: arm64: Save ID registers to sys_regs file
Date: Mon, 2 Nov 2020 11:34:13 +0800
Message-ID: <20201102033422.657391-4-liangpeng10@huawei.com>
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

To emulate the ID registers, we need a place to storage the values of
the ID regsiters.  Maybe putting them in sysreg file is a good idea.

This commit has no functional changes but only code refactor.  When
initializing a vCPU, get the values of the ID registers from
arm64_ftr_regs and storage them in sysreg file.  And we just read
the value from sysreg file when getting/setting the value of the ID
regs.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/kvm_coproc.h |  2 ++
 arch/arm64/include/asm/kvm_host.h   |  9 ++++++++
 arch/arm64/kvm/arm.c                |  2 ++
 arch/arm64/kvm/sys_regs.c           | 33 +++++++++++++++++++++++++----
 4 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index d6bb40122fdb..76e8c3cb0662 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -35,4 +35,6 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
 int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
 unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu);
 
+void kvm_arm_sys_reg_init(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_COPROC_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0aecbab6a7fb..1b18c53f519a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -40,6 +40,12 @@
 
 #define KVM_VCPU_MAX_FEATURES 7
 
+/*
+ * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2), where
+ * 1<=crm<8, 0<=op2<8.  Hence, the max number of ID registers is 56.
+ */
+#define KVM_ARM_ID_REG_MAX_NUM 56
+
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
@@ -192,6 +198,9 @@ enum vcpu_sysreg {
 	CNTP_CVAL_EL0,
 	CNTP_CTL_EL0,
 
+	ID_REG_BASE,
+	ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8f8fca47abfc..5a153a109317 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -278,6 +278,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
+	kvm_arm_sys_reg_init(vcpu);
+
 	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 41348a7781d9..68ed83657c07 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1116,13 +1116,16 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+#define ID_REG_INDEX(id)						\
+	(ID_REG_BASE + (((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id)))
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
+static u64 read_id_reg(struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
-	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
+	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, ID_REG_INDEX(id));
 
 	if (id == SYS_ID_AA64PFR0_EL1) {
 		if (!vcpu_has_sve(vcpu))
@@ -1267,7 +1270,7 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
  * are stored, and for set_id_reg() we don't allow the effective value
  * to be changed.
  */
-static int __get_id_reg(const struct kvm_vcpu *vcpu,
+static int __get_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
@@ -1277,7 +1280,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct kvm_vcpu *vcpu,
+static int __set_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
@@ -2870,3 +2873,25 @@ void kvm_sys_reg_table_init(void)
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
 }
+
+static int save_id_reg(u32 id, u64 val, void *argp)
+{
+	struct kvm_vcpu *vcpu = argp;
+
+	/*
+	 * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
+	 * where 1<=crm<8, 0<=op2<8.
+	 */
+	if (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+	    sys_reg_CRn(id) == 0 && sys_reg_CRm(id) > 0 &&
+	    sys_reg_CRm(id) < 8) {
+		__vcpu_sys_reg(vcpu, ID_REG_INDEX(id)) = val;
+	}
+
+	return 0;
+}
+
+void kvm_arm_sys_reg_init(struct kvm_vcpu *vcpu)
+{
+	arm64_cpu_ftr_regs_traverse(save_id_reg, vcpu);
+}
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

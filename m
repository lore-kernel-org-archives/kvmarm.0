Return-Path: <SRS0=hhnY=BX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E82C433E8
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 06:14:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8CFD2080C
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 06:14:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8CFD2080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95A424B98F;
	Thu, 13 Aug 2020 02:14:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LZlzwBxRPSWP; Thu, 13 Aug 2020 02:14:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3466E4B989;
	Thu, 13 Aug 2020 02:14:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F1564B7CA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 02:14:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zS+iDJwhwN7n for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Aug 2020 02:14:18 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30D834B979
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 02:14:18 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 5EE47BF876EAF2D86510;
 Thu, 13 Aug 2020 14:14:14 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 13 Aug 2020 14:14:05 +0800
From: Peng Liang <liangpeng10@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [RFC 2/4] kvm: arm64: emulate the ID registers
Date: Thu, 13 Aug 2020 14:05:15 +0800
Message-ID: <20200813060517.2360048-3-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200813060517.2360048-1-liangpeng10@huawei.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.104.175]
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
the ID regsiters.  Maybe putting in kvm_arch_vcpu is a good idea.

This commit has no functional changes but only code refactor.  When
initializing a vcpu, get the values of the ID registers from
arm64_ftr_regs and storage them in kvm_arch_vcpu.  And we just read
the value from kvm_arch_vcpu when getting/setting the value of the ID
regs.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 20 ++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         | 27 +++++++++++++++++++++++----
 include/uapi/linux/kvm.h          | 11 +++++++++++
 4 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f81151ad3d3c..7f7bd36702f7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -336,6 +336,8 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	struct id_registers idregs;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 73e12869afe3..18ebbe1c64ee 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -262,6 +262,24 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
+static int get_cpu_ftr(u32 id, u64 val, void *argp)
+{
+	struct id_registers *idregs = argp;
+
+	/*
+	 * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
+	 * where 1<=crm<8, 0<=op2<8.
+	 */
+	if (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+	    sys_reg_CRn(id) == 0 && sys_reg_CRm(id) > 0) {
+		idregs->regs[idregs->num].sys_id = id;
+		idregs->regs[idregs->num].sys_val = val;
+		idregs->num++;
+	}
+
+	return 0;
+}
+
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	int err;
@@ -285,6 +303,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
+	arm64_cpu_ftr_regs_traverse(get_cpu_ftr, &vcpu->arch.idregs);
+
 	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 138961d7ebe3..776c2757a01e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1092,13 +1092,32 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static struct id_reg_info *kvm_id_reg(struct kvm_vcpu *vcpu, u64 id)
+{
+	int i;
+
+	for (i = 0; i < vcpu->arch.idregs.num; ++i) {
+		if (vcpu->arch.idregs.regs[i].sys_id == id)
+			return &vcpu->arch.idregs.regs[i];
+	}
+	return NULL;
+}
+
+static u64 kvm_get_id_reg(struct kvm_vcpu *vcpu, u64 id)
+{
+	struct id_reg_info *ri = kvm_id_reg(vcpu, id);
+
+	BUG_ON(!ri);
+	return ri->sys_val;
+}
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
+static u64 read_id_reg(struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
-	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
+	u64 val = raz ? 0 : kvm_get_id_reg(vcpu, id);
 
 	if (id == SYS_ID_AA64PFR0_EL1) {
 		if (!vcpu_has_sve(vcpu))
@@ -1238,7 +1257,7 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
  * are stored, and for set_id_reg() we don't allow the effective value
  * to be changed.
  */
-static int __get_id_reg(const struct kvm_vcpu *vcpu,
+static int __get_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
@@ -1248,7 +1267,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct kvm_vcpu *vcpu,
+static int __set_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6d86033c4fa..1029444d04aa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1272,6 +1272,17 @@ struct kvm_vfio_spapr_tce {
 	__s32	tablefd;
 };
 
+#define ID_REG_MAX_NUMS 64
+struct id_reg_info {
+	uint64_t sys_id;
+	uint64_t sys_val;
+};
+
+struct id_registers {
+	struct id_reg_info regs[ID_REG_MAX_NUMS];
+	uint64_t num;
+};
+
 /*
  * ioctls for VM fds
  */
-- 
2.18.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

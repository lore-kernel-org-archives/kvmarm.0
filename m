Return-Path: <SRS0=oENQ=XT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E71C432C1
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:22:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 149B4217D7
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:22:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 149B4217D7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B37ED4A672;
	Tue, 24 Sep 2019 11:22:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pu-2vJUNbRiM; Tue, 24 Sep 2019 11:22:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 730644A66C;
	Tue, 24 Sep 2019 11:22:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F34EF4A64A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:22:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5vHUHVuAOL56 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Sep 2019 11:22:33 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A737C4A5A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:22:33 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 3D655AAB33C626A11C05;
 Tue, 24 Sep 2019 23:22:29 +0800 (CST)
Received: from linux-Bxxcye.huawei.com (10.175.104.222) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Tue, 24 Sep 2019 23:22:20 +0800
From: Heyi Guo <guoheyi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>
Subject: [RFC PATCH 1/2] kvm/arm: add capability to forward hypercall to user
 space
Date: Tue, 24 Sep 2019 23:20:53 +0800
Message-ID: <1569338454-26202-2-git-send-email-guoheyi@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
References: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.104.222]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Russell King <linux@armlinux.org.uk>, Heyi Guo <guoheyi@huawei.com>,
 Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>
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

As more SMC/HVC usages emerge on arm64 platforms, like SDEI, it makes
sense for kvm to have the capability of forwarding such calls to user
space for further emulation.

We reuse the existing term "hypercall" for SMC/HVC, as well as the
hypercall structure in kvm_run to exchange arguments and return
values. The definition on arm64 is as below:

exit_reason: KVM_EXIT_HYPERCALL

Input:
  nr: the immediate value of SMC/HVC calls; not really used today.
  args[6]: x0..x5 (This is not fully conform with SMCCC which requires
           x6 as argument as well, but use space can use GET_ONE_REG
           ioctl for such rare case).

Return:
  args[0..3]: x0..x3 as defined in SMCCC. We need to extract
              args[0..3] and write them to x0..x3 when hypercall exit
              returns.

Flag hypercall_forward is added to turn on/off hypercall forwarding
and the default is false. Another flag hypercall_excl_psci is to
exclude PSCI from forwarding for backward compatible, and it only
makes sense to check its value when hypercall_forward is enabled.

Signed-off-by: Heyi Guo <guoheyi@huawei.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
CC: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm/include/asm/kvm_host.h   |  5 +++++
 arch/arm64/include/asm/kvm_host.h |  5 +++++
 include/kvm/arm_psci.h            |  1 +
 virt/kvm/arm/arm.c                |  2 ++
 virt/kvm/arm/psci.c               | 30 ++++++++++++++++++++++++++++--
 5 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 8a37c8e..68ccaf0 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -76,6 +76,11 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	/* Flags to control hypercall forwarding to userspace */
+	bool hypercall_forward;
+	/* Exclude PSCI from hypercall forwarding and let kvm to handle it */
+	bool hypercall_excl_psci;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f656169..e47ac25 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -83,6 +83,11 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	/* Flags to control hypercall forwarding to userspace */
+	bool hypercall_forward;
+	/* Exclude PSCI from hypercall forwarding and let kvm to handle it */
+	bool hypercall_excl_psci;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 632e78b..9c9a2dc 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -48,5 +48,6 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+void kvm_handle_hypercall_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
 #endif /* __KVM_ARM_PSCI_H__ */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 35a0698..2f4ca21 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -673,6 +673,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
 		if (ret)
 			return ret;
+	} else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
+		kvm_handle_hypercall_return(vcpu, vcpu->run);
 	}
 
 	if (run->immediate_exit)
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 87927f7..7e1f735 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -389,6 +389,7 @@ static int kvm_psci_call(struct kvm_vcpu *vcpu)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	u32 func_id = smccc_get_function(vcpu);
 	u32 val = SMCCC_RET_NOT_SUPPORTED;
 	u32 feature;
@@ -428,8 +429,27 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			break;
 		}
 		break;
-	default:
-		return kvm_psci_call(vcpu);
+	default: {
+		if (!kvm->arch.hypercall_forward ||
+		    kvm->arch.hypercall_excl_psci) {
+			u32 id = func_id & ~PSCI_0_2_64BIT;
+
+			if (id >= PSCI_0_2_FN_BASE && id <= PSCI_0_2_FN(0x1f))
+				return kvm_psci_call(vcpu);
+		}
+
+		if (kvm->arch.hypercall_forward) {
+			/* Exit to user space to process */
+			vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
+			vcpu->run->hypercall.nr = kvm_vcpu_get_hsr(vcpu) &
+						  ESR_ELx_ISS_MASK;
+			vcpu->run->hypercall.args[0] = func_id;
+			vcpu->run->hypercall.args[1] = smccc_get_arg1(vcpu);
+			vcpu->run->hypercall.args[2] = smccc_get_arg2(vcpu);
+			vcpu->run->hypercall.args[3] = smccc_get_arg3(vcpu);
+			return 0;
+		}
+	}
 	}
 
 	smccc_set_retval(vcpu, val, 0, 0, 0);
@@ -603,3 +623,9 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	return -EINVAL;
 }
+
+void kvm_handle_hypercall_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	smccc_set_retval(vcpu, run->hypercall.args[0], run->hypercall.args[1],
+			 run->hypercall.args[2], run->hypercall.args[3]);
+}
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

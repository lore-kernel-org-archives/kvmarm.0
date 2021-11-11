Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E533DC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 21:12:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96DAB61057
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 21:12:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 96DAB61057
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 495E94B1E3;
	Thu, 11 Nov 2021 16:12:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wy3HYsSA7oOA; Thu, 11 Nov 2021 16:12:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EA1F4B238;
	Thu, 11 Nov 2021 16:12:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ABDD4B18A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 16:12:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RoXnAFufQnDD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 16:12:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CDC74B188
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 16:12:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3F80161078;
 Thu, 11 Nov 2021 21:12:18 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mlHMm-004tjr-DU; Thu, 11 Nov 2021 21:12:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/4] KVM: arm64: Change the return type of
 kvm_vcpu_preferred_target()
Date: Thu, 11 Nov 2021 21:11:34 +0000
Message-Id: <20211111211135.3991240-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211111211135.3991240-1-maz@kernel.org>
References: <20211111211135.3991240-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, tabba@google.com, james.morse@arm.com,
 mark.rutland@arm.com, qperret@google.com, rdunlap@infradead.org,
 suzuki.poulose@arm.com, will@kernel.org, yuehaibing@huawei.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, YueHaibing <yuehaibing@huawei.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

From: YueHaibing <yuehaibing@huawei.com>

kvm_vcpu_preferred_target() always return 0 because kvm_target_cpu()
never returns a negative error code.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211105011500.16280-1-yuehaibing@huawei.com
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/arm.c              | 5 +----
 arch/arm64/kvm/guest.c            | 7 +------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d0221fb69a60..f7e36e33406b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -584,7 +584,7 @@ struct kvm_vcpu_stat {
 	u64 exits;
 };
 
-int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
+void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 24a1e86d7128..e2dd575e40f8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1397,12 +1397,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		return kvm_vm_ioctl_set_device_addr(kvm, &dev_addr);
 	}
 	case KVM_ARM_PREFERRED_TARGET: {
-		int err;
 		struct kvm_vcpu_init init;
 
-		err = kvm_vcpu_preferred_target(&init);
-		if (err)
-			return err;
+		kvm_vcpu_preferred_target(&init);
 
 		if (copy_to_user(argp, &init, sizeof(init)))
 			return -EFAULT;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5ce26bedf23c..e116c7767730 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -869,13 +869,10 @@ u32 __attribute_const__ kvm_target_cpu(void)
 	return KVM_ARM_TARGET_GENERIC_V8;
 }
 
-int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
+void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
 {
 	u32 target = kvm_target_cpu();
 
-	if (target < 0)
-		return -ENODEV;
-
 	memset(init, 0, sizeof(*init));
 
 	/*
@@ -885,8 +882,6 @@ int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
 	 * target type.
 	 */
 	init->target = (__u32)target;
-
-	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

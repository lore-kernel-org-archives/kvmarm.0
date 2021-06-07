Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23957C47094
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 11:09:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C9694611C0
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 11:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9694611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79B5F4B07F;
	Mon,  7 Jun 2021 07:09:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T+UZjL9dWKjT; Mon,  7 Jun 2021 07:09:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD264B0BE;
	Mon,  7 Jun 2021 07:09:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8D6B4B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 07:09:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7QZ1lEBzyeAq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 07:08:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CDAA4A4E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 07:08:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE75D11D4;
 Mon,  7 Jun 2021 04:08:51 -0700 (PDT)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 906113F73D;
 Mon,  7 Jun 2021 04:08:48 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v14 6/8] KVM: arm64: Expose KVM_ARM_CAP_MTE
Date: Mon,  7 Jun 2021 12:08:14 +0100
Message-Id: <20210607110816.25762-7-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210607110816.25762-1-steven.price@arm.com>
References: <20210607110816.25762-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

It's now safe for the VMM to enable MTE in a guest, so expose the
capability to user space.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c      | 9 +++++++++
 arch/arm64/kvm/reset.c    | 3 ++-
 arch/arm64/kvm/sys_regs.c | 3 +++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1cb39c0803a4..e89a5e275e25 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -93,6 +93,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		kvm->arch.return_nisv_io_abort_to_user = true;
 		break;
+	case KVM_CAP_ARM_MTE:
+		if (!system_supports_mte() || kvm->created_vcpus)
+			return -EINVAL;
+		r = 0;
+		kvm->arch.mte_enabled = true;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -237,6 +243,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 */
 		r = 1;
 		break;
+	case KVM_CAP_ARM_MTE:
+		r = system_supports_mte();
+		break;
 	case KVM_CAP_STEAL_TIME:
 		r = kvm_arm_pvtime_supported();
 		break;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 956cdc240148..50635eacfa43 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -220,7 +220,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {
+			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) ||
+			    vcpu->kvm->arch.mte_enabled) {
 				ret = -EINVAL;
 				goto out;
 			}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 440315a556c2..d4e1c1b1a08d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1312,6 +1312,9 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
 {
+	if (kvm_has_mte(vcpu->kvm))
+		return 0;
+
 	return REG_HIDDEN;
 }
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

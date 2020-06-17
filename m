Return-Path: <SRS0=IB6K=76=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CEEC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 10:44:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D2A6720739
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 10:44:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2A6720739
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32B6C4B09F;
	Wed, 17 Jun 2020 06:44:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 21Fe2o7XRN-S; Wed, 17 Jun 2020 06:44:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00ADD4B1A0;
	Wed, 17 Jun 2020 06:44:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D854B12C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 06:44:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JyAChnKr62i9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2020 06:44:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C31B84B09F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 06:44:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4960031B;
 Wed, 17 Jun 2020 03:44:03 -0700 (PDT)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A73D53F71F;
 Wed, 17 Jun 2020 03:44:01 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: kvm_reset_vcpu() return code incorrect with SVE
Date: Wed, 17 Jun 2020 11:43:39 +0100
Message-Id: <20200617104339.35094-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
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

If SVE is enabled then 'ret' can be assigned the return value of
kvm_vcpu_enable_sve() which may be 0 causing future "goto out" sites to
erroneously return 0 on failure rather than -EINVAL as expected.

Remove the initialisation of 'ret' and make setting the return value
explicit to avoid this situation in the future.

Fixes: 9a3cdf26e336 ("KVM: arm64/sve: Allow userspace to enable SVE for vcpus")
Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
The problematic chunk isn't visible in the diff, so reproduced here:

	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features)) {
			ret = kvm_vcpu_enable_sve(vcpu);
			if (ret)
				goto out;
		}
	} else {
		kvm_vcpu_reset_sve(vcpu);
	}

 arch/arm64/kvm/reset.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index d3b209023727..f1057603b756 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -245,7 +245,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
-	int ret = -EINVAL;
+	int ret;
 	bool loaded;
 	u32 pstate;
 
@@ -269,15 +269,19 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
-		if (kvm_vcpu_enable_ptrauth(vcpu))
+		if (kvm_vcpu_enable_ptrauth(vcpu)) {
+			ret = -EINVAL;
 			goto out;
+		}
 	}
 
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
+			if (cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {
+				ret = -EINVAL;
 				goto out;
+			}
 			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

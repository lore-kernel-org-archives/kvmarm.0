Return-Path: <SRS0=vvQc=W4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9C5C3A5A8
	for <kvmarm@archiver.kernel.org>; Sun,  1 Sep 2019 21:13:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC10621897
	for <kvmarm@archiver.kernel.org>; Sun,  1 Sep 2019 21:13:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC10621897
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 856FA4A590;
	Sun,  1 Sep 2019 17:13:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4wPCC9Z4LV6i; Sun,  1 Sep 2019 17:13:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A7784A586;
	Sun,  1 Sep 2019 17:13:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 468D44A3B4
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Sep 2019 17:12:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rUqRhXCA2w7P for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 Sep 2019 17:12:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E13E4A4F6
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 Sep 2019 17:12:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB155360;
 Sun,  1 Sep 2019 14:12:57 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A22C3F718;
 Sun,  1 Sep 2019 14:12:56 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH 1/3] arm64: KVM: Drop hyp_alternate_select for checking for
 ARM64_WORKAROUND_834220
Date: Sun,  1 Sep 2019 22:12:35 +0100
Message-Id: <20190901211237.11673-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190901211237.11673-1-maz@kernel.org>
References: <20190901211237.11673-1-maz@kernel.org>
MIME-Version: 1.0
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

There is no reason for using hyp_alternate_select when checking
for ARM64_WORKAROUND_834220, as each of the capabilities is
also backed by a static key. Just replace the KVM-specific
construct with cpus_have_const_cap(ARM64_WORKAROUND_834220).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/switch.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index adaf266d8de8..a15baca9aca0 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -229,20 +229,6 @@ static void __hyp_text __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-static bool __hyp_text __true_value(void)
-{
-	return true;
-}
-
-static bool __hyp_text __false_value(void)
-{
-	return false;
-}
-
-static hyp_alternate_select(__check_arm_834220,
-			    __false_value, __true_value,
-			    ARM64_WORKAROUND_834220);
-
 static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 {
 	u64 par, tmp;
@@ -298,7 +284,8 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 	 * resolve the IPA using the AT instruction.
 	 */
 	if (!(esr & ESR_ELx_S1PTW) &&
-	    (__check_arm_834220()() || (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
+	    (cpus_have_const_cap(ARM64_WORKAROUND_834220) ||
+	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
 		if (!__translate_far_to_hpfar(far, &hpfar))
 			return false;
 	} else {
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

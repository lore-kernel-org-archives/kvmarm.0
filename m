Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805B0C55178
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:55:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB56C2075E
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EaAm8a0X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB56C2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3122F4B488;
	Fri, 30 Oct 2020 12:55:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DH3sYPXWSyyy; Fri, 30 Oct 2020 12:55:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A91E4B2FA;
	Fri, 30 Oct 2020 12:55:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFAC94B28E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:55:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12RmH82NcMwg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 12:55:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84F284B259
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:55:22 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3AC752075E;
 Fri, 30 Oct 2020 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604076921;
 bh=DmlbkjwNIPgqQskMs4fVUuPst6u3+Yia7p5E2TwkbcU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EaAm8a0X+JSoUeByUK2bKd7zye7fMRJt+t0J+IhUg2LEZlfa0JHQIlSXMBXUR0IDl
 WJIqbK0PD70dD5wqfeqWwtRen88F3X3yGfcsRb+nQiNniNLn4cN+yBiijUb9ilY04M
 jMg4u4tCLOLAhvF0T+XvoKNcqY9kvYHAijfHT4kQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYXS4-005noK-5X; Fri, 30 Oct 2020 16:40:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 12/12] KVM: arm64: Handle Asymmetric AArch32 systems
Date: Fri, 30 Oct 2020 16:40:17 +0000
Message-Id: <20201030164017.244287-13-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com,
 james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com,
 qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com,
 will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 Qais Yousef <qais.yousef@arm.com>
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

From: Qais Yousef <qais.yousef@arm.com>

On a system without uniform support for AArch32 at EL0, it is possible
for the guest to force run AArch32 at EL0 and potentially cause an
illegal exception if running on a core without AArch32. Add an extra
check so that if we catch the guest doing that, then we prevent it from
running again by resetting vcpu->arch.target and return
ARM_EXCEPTION_IL.

We try to catch this misbehaviour as early as possible and not rely on
an illegal exception occuring to signal the problem. Attempting to run a
32bit app in the guest will produce an error from QEMU if the guest
exits while running in AArch32 EL0.

Tested on Juno by instrumenting the host to fake asym aarch32 and
instrumenting KVM to make the asymmetry visible to the guest.

[will: Incorporated feedback from Marc]

Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201021104611.2744565-2-qais.yousef@arm.com
Link: https://lore.kernel.org/r/20201027215118.27003-2-will@kernel.org
---
 arch/arm64/kvm/arm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f56122eedffc..a3b32df1afb0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -808,6 +808,25 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		preempt_enable();
 
+		/*
+		 * The ARMv8 architecture doesn't give the hypervisor
+		 * a mechanism to prevent a guest from dropping to AArch32 EL0
+		 * if implemented by the CPU. If we spot the guest in such
+		 * state and that we decided it wasn't supposed to do so (like
+		 * with the asymmetric AArch32 case), return to userspace with
+		 * a fatal error.
+		 */
+		if (!system_supports_32bit_el0() && vcpu_mode_is_32bit(vcpu)) {
+			/*
+			 * As we have caught the guest red-handed, decide that
+			 * it isn't fit for purpose anymore by making the vcpu
+			 * invalid. The VMM can try and fix it by issuing  a
+			 * KVM_ARM_VCPU_INIT if it really wants to.
+			 */
+			vcpu->arch.target = -1;
+			ret = ARM_EXCEPTION_IL;
+		}
+
 		ret = handle_exit(vcpu, ret);
 	}
 
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

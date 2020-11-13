Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5E6C61DD8
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56FE7206F9
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDLBjuEN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56FE7206F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAD4D4B67A;
	Fri, 13 Nov 2020 13:26:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id abi-Et-a7fJT; Fri, 13 Nov 2020 13:26:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82974B880;
	Fri, 13 Nov 2020 13:26:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2F894B728
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfsJdlpPFZ3l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 13:26:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBE2D4B622
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B7514208D5;
 Fri, 13 Nov 2020 18:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605291978;
 bh=8exQ+RJWp7s5beIsrjhtie2H7PoVpSHVfotFblRbfkU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=dDLBjuENH33jZ3V2szqs+b5y1JFD/XbFnnokFDScqJq9ZtTHUXGQkpad2zj8Al0HA
 XVRXvTM6pt4tUUjEebMQ7806QzfHE/OOlfazeu6GY77KPA20YQLlKevtZior7upkkU
 fetX7Q2OrTX8RkQaLXGxZYdEP2mS7d0pCHKM+bHE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kddm4-00APrY-Vy; Fri, 13 Nov 2020 18:26:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 3/8] KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at reset
 time
Date: Fri, 13 Nov 2020 18:25:57 +0000
Message-Id: <20201113182602.471776-4-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113182602.471776-1-maz@kernel.org>
References: <20201113182602.471776-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

We accept to configure a PMU when a vcpu is created, even if the
HW (or the host) doesn't support it. This results in failures
when attributes get set, which is a bit odd as we should have
failed the vcpu creation the first place.

Move the check to the point where we check the vcpu feature set,
and fail early if we cannot support a PMU. This further simplifies
the attribute handling.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 4 ++--
 arch/arm64/kvm/reset.c    | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e7e3b4629864..200f2a0d8d17 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -913,7 +913,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
-	if (!kvm_arm_support_pmu_v3() || !kvm_vcpu_has_pmu(vcpu))
+	if (!kvm_vcpu_has_pmu(vcpu))
 		return -ENODEV;
 
 	if (vcpu->arch.pmu.created)
@@ -1034,7 +1034,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_IRQ:
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
-		if (kvm_arm_support_pmu_v3() && kvm_vcpu_has_pmu(vcpu))
+		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 74ce92a4988c..3e772ea4e066 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -285,6 +285,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 			pstate = VCPU_RESET_PSTATE_EL1;
 		}
 
+		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
+			ret = -EINVAL;
+			goto out;
+		}
 		break;
 	}
 
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

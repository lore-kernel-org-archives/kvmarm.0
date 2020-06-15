Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48285C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 08:20:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 019D12053B
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 08:20:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZuFDXss"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 019D12053B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B039D4B11E;
	Mon, 15 Jun 2020 04:20:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ujG92JrNDp0w; Mon, 15 Jun 2020 04:20:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F744B11F;
	Mon, 15 Jun 2020 04:20:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 161214B0E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 04:20:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tDZjt3JJUyqm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 04:20:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C2394B0DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 04:20:07 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6076620714;
 Mon, 15 Jun 2020 08:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592209206;
 bh=teLpAbnj9atb0pVhfPoGLTjUX7m3uxJIO1TyC1h59vY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=lZuFDXssn8emu7X/tg8N78917FwVRqNDHKQXjkCvvoxpQsRJjQexKxXK61MeK4ODD
 soHkKFhEr2beO4N43BYHW7J2tCp0g8HbhidR4ihWVYGMGxyJTYy0sxvGMpMD4lVR1t
 2neHDmARfYxvJ6wyi6ZzP7btSdSXoboV7R+TOTVU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jkkLc-0031ew-Qn; Mon, 15 Jun 2020 09:20:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/4] KVM: arm64: Allow PtrAuth to be enabled from userspace on
 non-VHE systems
Date: Mon, 15 Jun 2020 09:19:53 +0100
Message-Id: <20200615081954.6233-4-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200615081954.6233-1-maz@kernel.org>
References: <20200615081954.6233-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
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

Now that the scene is set for enabling PtrAuth on non-VHE, drop
the restrictions preventing userspace from enabling it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/reset.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index d3b209023727..2a929789fe2e 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -42,6 +42,11 @@ static u32 kvm_ipa_limit;
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
+static bool system_has_full_ptr_auth(void)
+{
+	return system_supports_address_auth() && system_supports_generic_auth();
+}
+
 /**
  * kvm_arch_vm_ioctl_check_extension
  *
@@ -80,8 +85,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
-		r = has_vhe() && system_supports_address_auth() &&
-				 system_supports_generic_auth();
+		r = system_has_full_ptr_auth();
 		break;
 	default:
 		r = 0;
@@ -205,19 +209,14 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 {
-	/* Support ptrauth only if the system supports these capabilities. */
-	if (!has_vhe())
-		return -EINVAL;
-
-	if (!system_supports_address_auth() ||
-	    !system_supports_generic_auth())
-		return -EINVAL;
 	/*
 	 * For now make sure that both address/generic pointer authentication
-	 * features are requested by the userspace together.
+	 * features are requested by the userspace together and the system
+	 * supports these capabilities.
 	 */
 	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
+	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
+	    !system_has_full_ptr_auth())
 		return -EINVAL;
 
 	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

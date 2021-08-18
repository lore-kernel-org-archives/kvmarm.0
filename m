Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B485C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 08:51:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F0FD606A5
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 08:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F0FD606A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D8A405A9;
	Wed, 18 Aug 2021 04:51:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IYl-G9cvFmNS; Wed, 18 Aug 2021 04:51:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1893F4B0DB;
	Wed, 18 Aug 2021 04:51:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0BA0405A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 04:50:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6i81jbB6uqDW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 04:50:57 -0400 (EDT)
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com
 [209.85.210.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D80DA402C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 04:50:57 -0400 (EDT)
Received: by mail-ot1-f73.google.com with SMTP id
 n42-20020a9d202d0000b02904fc72900a74so652847ota.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 01:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rNQfKENGbYcrJ9HZ66W2jFFkwNGnpkM8Yc93j0DOK3I=;
 b=JZQknkW0IVT2PvxhC7VfQrlcLZxIyyzdHEae1uS7jowhGLCjH0nejpybBBY70AjSUs
 eoMpPIj0h3z8YLUnR/XRd3/dGkGBU3w6IiPAoEv4V/ZeCDtAwemxJ8ITyB8PQ+tKjQRS
 aPswIdjaOmsGq46ikmF0/dE/HtpxycNcDHq8IWWkB+9dezYmbZ+4eqxw9h13jZTg/vyH
 oBWqSDPKS8w0uQB7NeEp753jLeyhNlPYdkiuayR0nkO1YDRHqJfRzhyigvdaautysDID
 Ad631UQ5avZLkJtTCkDNCu8ILAozVRbW44ge5+6GkDwHAlQU2FGo/79zZJFgv6533V8D
 uK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rNQfKENGbYcrJ9HZ66W2jFFkwNGnpkM8Yc93j0DOK3I=;
 b=VGaho7/fP9mrfVQ6zcnV/vUjX2QIWYNCIN1qXsbeCQOg4elLjolmnS4EO290wpLtcS
 gzkZe1B0EL/UbNrf33vkLOz68OYCNPVM9QfWNKcwtzVDzAPvY8kPrO8HNwhtyhWvg42g
 bK6YyJY98w3e2iYb9LUcvDVQtcmtXGFxpbTKvImxXb3ousJtGghT4VI/L0UfAVUh21uM
 q8MOS6ZKkbhcz4hT1jK+qX+KzwFxWeTa0CZdFnzeRBi38YyEhiC6FTw35VGc5/nK5Kz3
 /ezfaA699cXj31rtMsiROPj6DMoUJ0dlr0INyVlbz61vDNsNSqBhIIg1MUDEi36lY3rD
 4k7Q==
X-Gm-Message-State: AOAM530ZztdxfCP3pwcJY/Bc/oBHGbWsLtMjUTqAKn8jPUUYEwx08u+V
 n0O9US0J0WIz16rV/RfidqZ9epqy1Y8=
X-Google-Smtp-Source: ABdhPJwfuGAwKos/jHCv5/X8lVFg3EkO9fNMrPdT+KmWoRTXdruJ/tf9EfzPd+lLSYQIBXydzR1x8ORFbOM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a54:438a:: with SMTP id
 u10mr6369735oiv.131.1629276657161; 
 Wed, 18 Aug 2021 01:50:57 -0700 (PDT)
Date: Wed, 18 Aug 2021 08:50:44 +0000
In-Reply-To: <20210818085047.1005285-1-oupton@google.com>
Message-Id: <20210818085047.1005285-2-oupton@google.com>
Mime-Version: 1.0
References: <20210818085047.1005285-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 1/4] KVM: arm64: Fix read-side race on updates to vcpu reset
 state
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>
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

KVM correctly serializes writes to a vCPU's reset state, however since
we do not take the KVM lock on the read side it is entirely possible to
read state from two different reset requests.

Cure the race for now by taking the KVM lock when reading the
reset_state structure.

Fixes: 358b28f09f0a ("arm/arm64: KVM: Allow a VCPU to fully reset itself")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/reset.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 18ffc6ad67b8..3507e64ff8ad 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -210,10 +210,16 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_reset_state reset_state;
 	int ret;
 	bool loaded;
 	u32 pstate;
 
+	mutex_lock(&vcpu->kvm->lock);
+	memcpy(&reset_state, &vcpu->arch.reset_state, sizeof(reset_state));
+	vcpu->arch.reset_state.reset = false;
+	mutex_unlock(&vcpu->kvm->lock);
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -276,8 +282,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	 * Additional reset state handling that PSCI may have imposed on us.
 	 * Must be done after all the sys_reg reset.
 	 */
-	if (vcpu->arch.reset_state.reset) {
-		unsigned long target_pc = vcpu->arch.reset_state.pc;
+	if (reset_state.reset) {
+		unsigned long target_pc = reset_state.pc;
 
 		/* Gracefully handle Thumb2 entry point */
 		if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
@@ -286,13 +292,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 
 		/* Propagate caller endianness */
-		if (vcpu->arch.reset_state.be)
+		if (reset_state.be)
 			kvm_vcpu_set_be(vcpu);
 
 		*vcpu_pc(vcpu) = target_pc;
-		vcpu_set_reg(vcpu, 0, vcpu->arch.reset_state.r0);
-
-		vcpu->arch.reset_state.reset = false;
+		vcpu_set_reg(vcpu, 0, reset_state.r0);
 	}
 
 	/* Reset timer */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

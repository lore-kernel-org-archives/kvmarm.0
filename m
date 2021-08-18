Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32031C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:21:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BA5BA610F7
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:21:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BA5BA610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6079E4B0CB;
	Wed, 18 Aug 2021 16:21:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cnXv-lWT5wTr; Wed, 18 Aug 2021 16:21:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7D84B0EF;
	Wed, 18 Aug 2021 16:21:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 737A64A19B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 16:21:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NGXGK+uoJZtf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 16:21:43 -0400 (EDT)
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com
 [209.85.167.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FD6F4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 16:21:39 -0400 (EDT)
Received: by mail-oi1-f202.google.com with SMTP id
 p84-20020acabf570000b029026702f1769bso1542038oif.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 13:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hGb/ueygkMqaGjl0KMNjqvYzUKfaiFfnTNnmRtH2qjE=;
 b=LMeoFdjwl26WEwUvEYAKf71IpNGuy6iROwQXK5jLYTWCnMpoiWtHFZSjponxOa6Jw7
 pdxO8BC3LMXSQzkbUTfwccwO0/+FgxPcG39ivpgk/pj1qpS5fIO7wjCGve6hHpYVTny0
 1FNpIMRXx670vuJqd0l8WttCjI3rYAJQkmLNNvxUfB+bp3WFH3TvZjzlr+4dPD+rqNvQ
 Vny4af7srvH9a0H85EYncnqO32HOBqRrtbO4TUv4p+j8osuOEcfDsrfuJZM1sae1KUr4
 6bJm0fySxvg8Oz2KY+PYPDCaoLObDg1WyHigH7e0RB034hG3CUv4UOIck2WDYRaaLHTx
 ecxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hGb/ueygkMqaGjl0KMNjqvYzUKfaiFfnTNnmRtH2qjE=;
 b=Dw4A0Z9GweFbufrzOlXvugtf0uRY6otrDR7IvRLa0WrCONW94MrNmH4M1wHpPwTdRy
 5+P5OdhBLld5qES0iJm366ik7CKAYCUx98j4DEj71fk6+VaFqgDcCUMbq9Tz3ah3bajM
 2Mw6DLijxZg9DPARnGz9aTms9x4XrYhO0j+kJazjN/rtkhivAbRHc82dBJx9y4TDjQwl
 43rQcECXmWvZPv43vvD3uLBI0y9pb4G1D5tEhKniaY58/bVHdiDsYPO9NHsjbi0sRrnj
 yHq49tvBTgnZLr/NtYrKsDpArMX9cgd6FEDaBfduEuiBRJd1XD2WvaHy8MWQCB0YQUeU
 OVeQ==
X-Gm-Message-State: AOAM5328QAvPWS3ZMKobQtXwLlvxGcXUrE6iJBqKjiwUpux9NMXU+kY8
 m/d4/QGE5Tk6fPH5jWu+VV5eaLLsnvs=
X-Google-Smtp-Source: ABdhPJxONHASSnzgn61nsjiHmFL+Yo64sPq7kL1PbwlMuzfrSrfWcFwbsKgj4L0YFIAJ0trU0iitWSJV4pU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:aca:de54:: with SMTP id
 v81mr65294oig.40.1629318098693; 
 Wed, 18 Aug 2021 13:21:38 -0700 (PDT)
Date: Wed, 18 Aug 2021 20:21:32 +0000
In-Reply-To: <20210818202133.1106786-1-oupton@google.com>
Message-Id: <20210818202133.1106786-4-oupton@google.com>
Mime-Version: 1.0
References: <20210818202133.1106786-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 3/4] KVM: arm64: Enforce reserved bits for PSCI target
 affinities
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

According to the PSCI specification, ARM DEN 0022D, 5.1.4 "CPU_ON", the
CPU_ON function takes a target_cpu argument that is bit-compatible with
the affinity fields in MPIDR_EL1. All other bits in the argument are
RES0. Note that the same constraints apply to the target_affinity
argument for the AFFINITY_INFO call.

Enforce the spec by returning INVALID_PARAMS if a guest incorrectly sets
a RES0 bit.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index db4056ecccfd..74c47d420253 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -59,6 +59,12 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
+static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
+					   unsigned long affinity)
+{
+	return !(affinity & ~MPIDR_HWID_BITMASK);
+}
+
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 {
 	struct vcpu_reset_state *reset_state;
@@ -66,9 +72,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	struct kvm_vcpu *vcpu = NULL;
 	unsigned long cpu_id;
 
-	cpu_id = smccc_get_arg1(source_vcpu) & MPIDR_HWID_BITMASK;
-	if (vcpu_mode_is_32bit(source_vcpu))
-		cpu_id &= ~((u32) 0);
+	cpu_id = smccc_get_arg1(source_vcpu);
+	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
+		return PSCI_RET_INVALID_PARAMS;
 
 	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
 
@@ -126,6 +132,9 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	target_affinity = smccc_get_arg1(vcpu);
 	lowest_affinity_level = smccc_get_arg2(vcpu);
 
+	if (!kvm_psci_valid_affinity(vcpu, target_affinity))
+		return PSCI_RET_INVALID_PARAMS;
+
 	/* Determine target affinity mask */
 	target_affinity_mask = psci_affinity_mask(lowest_affinity_level);
 	if (!target_affinity_mask)
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

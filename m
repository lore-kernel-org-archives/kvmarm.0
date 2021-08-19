Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CDCC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:36:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56EDF6109E
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 56EDF6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFED34B116;
	Thu, 19 Aug 2021 18:36:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CAvMhgwqc1we; Thu, 19 Aug 2021 18:36:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBA954B11A;
	Thu, 19 Aug 2021 18:36:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 613124B0EE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5nYfjvHjnspe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 18:36:45 -0400 (EDT)
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com
 [209.85.210.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C9044B0D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:45 -0400 (EDT)
Received: by mail-ot1-f73.google.com with SMTP id
 l16-20020a9d6a90000000b0051a232667abso3515944otq.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 15:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=t7LGVP554kQR/vFvXnoLO0aCqVqH2J9lOsbFtuSIcI4=;
 b=DLI1eqQzEY0keU0Orx7pME9tox5Hvur8IuWHPfTx+TTKqi2uO/ML4CE9piZNe25md6
 olqvrWP8NtlBAC71qgsBVDpcGssFvzk/ndE74qecXRzZvAGHOgBOEp3sWs6pwvrUpP4G
 W+FaQHw5lkFoY7nkPYfpqLPNDmrIa4NaGwi99zBIzahLXGQQJJdusjc+BgbUHnnHfr6S
 Ie/Ww2IOQr+yDkNlgH6Ww4iitlywmC9DIMUYmWqIju1KJT5Wquu/GkhkAuJ9pSxK193H
 vLUZYmTsFJVDFm/Niydj1hZ9mWzk+HKshim0XBlmQNEsVIcyckgzsdTe6llZ4wNL6wVb
 6Eew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=t7LGVP554kQR/vFvXnoLO0aCqVqH2J9lOsbFtuSIcI4=;
 b=CMJIu4Xl5fL16JVqypWcYtADFVnS9g+dMZwD8eKsrrLE2g+ctp8tlOlaZYW+lH/NXc
 C1v0LsQJ3xm87m0u8ZyoIDuWAaoNhe+Bx81b8G4x4RvKJhrxSFPqul33O6ccyuxN0I7u
 3DyWUjvdNBfmGfS4ZexH1+ycZI7YVYWLZqSqzcSlrTW+FiDM1YJ+GfyXXxL2GolLIXCN
 6Zq8rEFDk4viuuh7F8AjRepv4AFZmh3345ls8fFwS8/V5+zjoNrOSn24pFwfFLMM2FXE
 8i6SbXTeQp6AhsokjZc1h32otACEQ0Kxzk80CTosCnalKRQ+tQLslF5q+Kw+3PmCo6+U
 vZRA==
X-Gm-Message-State: AOAM532JEq1M9qzlFykhYeoQESIi+xDX6wlHn/BL3BMMnLlOyln2MbUk
 7suG3krd3SxiazIvUYN9BXPjVF4gA7c=
X-Google-Smtp-Source: ABdhPJy6FTCFvhaf0mQy7xMNvESNDrcZSCkWNkPa6rAsPIGBY1VYRlZ/B+ES23ZKv0Zz9rtSfEUmMv83/Qg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6830:1589:: with SMTP id
 i9mr11062299otr.196.1629412604681; Thu, 19 Aug 2021 15:36:44 -0700 (PDT)
Date: Thu, 19 Aug 2021 22:36:35 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-2-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 1/6] KVM: arm64: Drop unused vcpu param to
 kvm_psci_valid_affinity()
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

The helper function does not need a pointer to the vCPU, as it only
consults a constant mask; drop the unused vcpu parameter.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 74c47d420253..d46842f45b0a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -59,8 +59,7 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
-					   unsigned long affinity)
+static inline bool kvm_psci_valid_affinity(unsigned long affinity)
 {
 	return !(affinity & ~MPIDR_HWID_BITMASK);
 }
@@ -73,7 +72,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	unsigned long cpu_id;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
-	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
+	if (!kvm_psci_valid_affinity(cpu_id))
 		return PSCI_RET_INVALID_PARAMS;
 
 	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
@@ -132,7 +131,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	target_affinity = smccc_get_arg1(vcpu);
 	lowest_affinity_level = smccc_get_arg2(vcpu);
 
-	if (!kvm_psci_valid_affinity(vcpu, target_affinity))
+	if (!kvm_psci_valid_affinity(target_affinity))
 		return PSCI_RET_INVALID_PARAMS;
 
 	/* Determine target affinity mask */
-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

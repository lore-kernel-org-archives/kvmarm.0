Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC20C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58D8C4C3E2;
	Tue, 22 Feb 2022 23:19:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L86L-pAr69Zp; Tue, 22 Feb 2022 23:19:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEA7A4C3E0;
	Tue, 22 Feb 2022 23:19:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 361074C3CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cXdA-FU6JZHn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:09 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3C754C3DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:08 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 o5-20020a25d705000000b0062499d760easo7949186ybg.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ahiLAnvGk5WOtmVeGA8iuyeZCq4rGSdqLgd0ZvQyT98=;
 b=BX8y9VlBKsn8jL1RlTr1OBGGetvgQI1VN5gscUGj5PvXkxsZa7UrKQLI20x3uUoO7l
 ncIJvGbFbopGWOm/mzOqa2srOo9k0/7J/0wCD0l0hzyb2ACFqXFzdziavo7hYedyUxSX
 2G1OWLZcKybblkzNl1aDXnnyJ4zm7cxyAVrc1SkOxupJQ54jHriMPA3K5+DoykZJx3+6
 cGjkgTeHFlKqwPaLgFiuAId2JpQ47d5NIPiPVsYPeeYgkVxzI/9tWIHbQw4QcwXyjR3W
 WJbG90pWIu3Kc+kOKVeGCQokZE25D0T8AeN5qTr2SoRYKK2vm291FZYaZUeETUE9hM4/
 2YYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ahiLAnvGk5WOtmVeGA8iuyeZCq4rGSdqLgd0ZvQyT98=;
 b=XelMUr21VuZ7gdwXXxg7gwFn8JrbMNIklCqg4Osnt+Oh6F1hrjHgzeBdOAFGho9veD
 pxHZFMc7gV/j2qXgpY+ZtjZnlj6nO0BJpgK/rn2KDVU5QxU0Xt0go6Kh/xpbGH56xoGI
 Wi420qYtYarTfCMH/8lM1gLZZO/dzXeKR7+4Q1R6Puy2FyyXQiIOhrg82a2Kvn4n6kMm
 gdwALKdyurYzdyIMLVbf7zSPE/eox5wRMXzTWQrC/P8u9Izk88oCUhDRFDUHZLjKrrvR
 yAQojb5lvnam8Fc66FEXNYjeaKAUFlCqawX6dTM73R7bDn1NzoSnGdjmkkLnjDZc5wG0
 z3rg==
X-Gm-Message-State: AOAM532vPtzTd/KoXVRIUKTHT4KYEfnTlzJfydvd7uIrh3PeWRp2oLEo
 2CVn5Imju64kLDn/Sav46ejTf0zCkG2ADQZtqkyLGEr2Fg1SuooqWNc/aZ5Td2+pNrNisEw8Y3Y
 qKOJBjns18kw7/7DUz7foM0MfyIDiHPlJKrbZpvlPVOrUMtUIdCqAniheHpY7LG8LhIuRPg==
X-Google-Smtp-Source: ABdhPJx9rCAmlwDD8ZGLtxOAhcQ0e/5TNwlmLC3bRH71Gh8ABg+5APqO9HlhVqrCvDpcvj9jNZU6c7uzBKk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a81:9e04:0:b0:2d5:84ae:13c9 with
 SMTP id
 m4-20020a819e04000000b002d584ae13c9mr26571752ywj.435.1645589948342; Tue, 22
 Feb 2022 20:19:08 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:28 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-4-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 03/19] KVM: arm64: Reject invalid addresses for CPU_ON PSCI
 call
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

DEN0022D.b 5.6.2 "Caller responsibilities" states that a PSCI
implementation may return INVALID_ADDRESS for the CPU_ON call if the
provided entry address is known to be invalid. There is an additional
caveat to this rule. Prior to PSCI v1.0, the INVALID_PARAMETERS error
is returned instead. Check the guest's PSCI version and return the
appropriate error if the IPA is invalid.

Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index a0c10c11f40e..de1cf554929d 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -12,6 +12,7 @@
 
 #include <asm/cputype.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 
 #include <kvm/arm_psci.h>
 #include <kvm/arm_hypercalls.h>
@@ -70,12 +71,31 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	struct vcpu_reset_state *reset_state;
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
-	unsigned long cpu_id;
+	unsigned long cpu_id, entry_addr;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
 	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
 		return PSCI_RET_INVALID_PARAMS;
 
+	/*
+	 * Basic sanity check: ensure the requested entry address actually
+	 * exists within the guest's address space.
+	 */
+	entry_addr = smccc_get_arg2(source_vcpu);
+	if (!kvm_ipa_valid(kvm, entry_addr)) {
+
+		/*
+		 * Before PSCI v1.0, the INVALID_PARAMETERS error is returned
+		 * instead of INVALID_ADDRESS.
+		 *
+		 * For more details, see ARM DEN0022D.b 5.6 "CPU_ON".
+		 */
+		if (kvm_psci_version(source_vcpu) < KVM_ARM_PSCI_1_0)
+			return PSCI_RET_INVALID_PARAMS;
+		else
+			return PSCI_RET_INVALID_ADDRESS;
+	}
+
 	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
 
 	/*
@@ -93,7 +113,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 	reset_state = &vcpu->arch.reset_state;
 
-	reset_state->pc = smccc_get_arg2(source_vcpu);
+	reset_state->pc = entry_addr;
 
 	/* Propagate caller endianness */
 	reset_state->be = kvm_vcpu_is_be(source_vcpu);
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

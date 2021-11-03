Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FD8C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5555E61178
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5555E61178
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 036944B1C5;
	Wed,  3 Nov 2021 02:28:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0XDErOm+OMH6; Wed,  3 Nov 2021 02:28:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0D1A4B190;
	Wed,  3 Nov 2021 02:28:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A36A54B195
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N0RXxgYo3-Ru for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:29 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B87CD4B15A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:26 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 f92-20020a25a465000000b005bea37bc0baso2782174ybi.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=IlnnjjxcxTrjMcB8yaJXHdEazmlLXcchfy7IakmUdZE=;
 b=lEBh0vzvOlg1yr5SMNuPf3yBIYSLDFvr1+EhJDIadybQX+1BavYADneMp+UbZDfKsT
 tDPsBoGaE4kyOUe/JIe67Ksbi+weqOPFfbtyfHVxSYKGdGcksQlY3dnWhQYd1hiGjHPG
 QihaOhYE+Yo95wwBLm4eNb7CZ5VFRYkk3X49wCCgsrP/AZ3nrKt+4OyMd5xoaYtofZNB
 ajFywJ1SApAGz1A7JqrmSMnA6QwV1OMcmtLp8YIo3m/HnGubXt2oFhz+uRsKghNKaL/Y
 vuhuosSxAuArRsnX6D/7btRUWlFtcQRaD2wrvvrZCNg6KmjmQaR0AxIBHlUiPshtz796
 xj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IlnnjjxcxTrjMcB8yaJXHdEazmlLXcchfy7IakmUdZE=;
 b=Ke4sfYHmZ4gvkkS37hJxz2RtZg5q2v6dYJGRcSUFgrleZO9jbj13q64njIod8WkPxD
 8tptL9yPyq63V8NF+InjkkXsV1sWxzFKWaM9l/5H6R9mkDeU4Oj7zWRjyzJJMIsop8o5
 2lT0lcJOUuhDLGNsgfP6ZQ53Aw6TsDuIk8vJYcWacycNApiXzTCMHiIX60L7uJdqfN0A
 k5nEKOuMi+JebVehPMuitxI+ukbFD9duj+eWXxIFP9SJQEwuFbdJcocG5bWFEuNZRlj0
 GrlrMOmqVbPRQWGavt6ll2DzH9GQ9/KrjVEKrVf7VUJIRh6MRD/2cdczyS/H/yhCzzB7
 Kt3Q==
X-Gm-Message-State: AOAM530ZkwBOEN+vitTOVztUxhDJkoHE0/De5ucqHZhThBThvBCnu/w5
 O8Uqg78pk9IBS6FAzMaSwxVRrEnZwSE=
X-Google-Smtp-Source: ABdhPJxgJ+HzJWMr3mZLEymaTOFsSPvpEYoeWmz+ySBuR2iPwDl/R17Ye21Yh4kCJ8QQZzyP3Hjs7R3utuo=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6902:114c:: with SMTP id
 p12mr51484992ybu.408.1635920906196; Tue, 02 Nov 2021 23:28:26 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:11 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-20-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 19/28] KVM: arm64: Use vcpu->arch cptr_el2 to track
 value of cptr_el2 for VHE
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Track the baseline guest value for cptr_el2 in struct kvm_vcpu_arch
for VHE.  Use this value when setting cptr_el2 for the guest.

Currently this value is unchanged, but the following patches will set
trapping bits based on features supported for the guest.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 16 ++++++++++++++++
 arch/arm64/kvm/arm.c             |  5 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c  | 14 ++------------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 327120c0089f..f11ba1b6699d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -288,6 +288,22 @@
 				 GENMASK(19, 14) |	\
 				 BIT(11))
 
+/*
+ * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
+ * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
+ * except for some missing controls, such as TAM.
+ * In this case, CPTR_EL2.TAM has the same position with or without
+ * VHE (HCR.E2H == 1) which allows us to use here the CPTR_EL2.TAM
+ * shift value for trapping the AMU accesses.
+ */
+#define CPTR_EL2_VHE_GUEST_DEFAULT	(CPACR_EL1_TTA | CPTR_EL2_TAM)
+
+/*
+ * Bits that are copied from vcpu->arch.cptr_el2 to set cptr_el2 for
+ * guest with VHE.
+ */
+#define CPTR_EL2_VHE_GUEST_TRACKED_MASK	(CPACR_EL1_TTA | CPTR_EL2_TAM)
+
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 87b8432f5719..37e1e07a19eb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1109,7 +1109,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
-	vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
+	if (has_vhe())
+		vcpu->arch.cptr_el2 = CPTR_EL2_VHE_GUEST_DEFAULT;
+	else
+		vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
 
 	/*
 	 * Handle the "start in power-off" case.
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index ded2c66675f0..b924e9d5e6fa 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -38,20 +38,10 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	___activate_traps(vcpu);
 
 	val = read_sysreg(cpacr_el1);
-	val |= CPACR_EL1_TTA;
+	val &= ~CPTR_EL2_VHE_GUEST_TRACKED_MASK;
+	val |= (vcpu->arch.cptr_el2 & CPTR_EL2_VHE_GUEST_TRACKED_MASK);
 	val &= ~CPACR_EL1_ZEN;
 
-	/*
-	 * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
-	 * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
-	 * except for some missing controls, such as TAM.
-	 * In this case, CPTR_EL2.TAM has the same position with or without
-	 * VHE (HCR.E2H == 1) which allows us to use here the CPTR_EL2.TAM
-	 * shift value for trapping the AMU accesses.
-	 */
-
-	val |= CPTR_EL2_TAM;
-
 	if (update_fp_enabled(vcpu)) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN;
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

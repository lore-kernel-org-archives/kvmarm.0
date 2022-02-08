Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D858C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 01:27:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E18E64A119;
	Mon,  7 Feb 2022 20:27:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eB-aZxDozqsQ; Mon,  7 Feb 2022 20:27:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 723C14A7FD;
	Mon,  7 Feb 2022 20:27:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F40484A119
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 20:27:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tEOf-15JNPkZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 20:27:17 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6CC549F3E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 20:27:17 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 b4-20020a05660214c400b00632eb8bff25so10369963iow.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 17:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=gGfwXYlGCeVdn9VPRh3V4tDKjPW4ZQjqWRu/l1nGaXA=;
 b=Rn6x40CqNhj7S3R3b9SiwvoWmH3ai4cKbllf15bsoxy4gRJWCfi7N6Oc9xQaITcyeS
 U9tGKNBkNTBZxAleegnM25vsRDWOE6hvT2Gq5GzWuUTf9n7VJHAubVx3dQijV/DtiJ9w
 tqXba1ti7uChPUXnpq8L4OW4qh89Gw+GlVRfyjPNMPULYh44MCunrH6kYlQB43SCyZPN
 BdY14rb8oYBNOlvPWqsBOeETx8XwvOIvpCiDTvZL/27CZJBgaGOqFPDWI18JKvdVn+kk
 O5X5HYo0/P7rIiWyfbiDTyPIW6zgHs1UQYfSsYyFN1L6U/ds8hG1BbP+TEM6WWjeCk1d
 z51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=gGfwXYlGCeVdn9VPRh3V4tDKjPW4ZQjqWRu/l1nGaXA=;
 b=kQjhMPQzCp6w15/jhsYpR2B6BwpcYDDUpsjecNx7Ti+bjmNuB6W+TippKtGAmjdoVO
 KveYHiCZ6b4EFmVhSpf5DuX89cqdT78tigwIu7OQKPgw5EsZGMIfl61PC4s8JTMnd0mg
 iU58mynLsNMXBI4r7aJEjJjNo7DpjHEaXF/qCBssGe5TkHuUU7c3L3zPDKCigM69rbRi
 ym5O4iP5iipaIFmQsrM36zHx/RojRyTWrsCs1cRyfGjY9Q1bUHp9CrNzVip0sKyv1msl
 px4xyzZDmy7Vpqv1t08I87iLckCTHWN/DgdzuZVjjBlYCXuj31YtMjjkB2xE5oU2Fkpb
 UeJg==
X-Gm-Message-State: AOAM531NSqvgRnWlYzT6FVwmMoUnjw5SXGqExSsjKTenAx6jurWWnLlq
 PMlFEvCk0EcPPHxpRgbNmWHxnTuWCmBuJ4Mx0R749vNCE9jAr9i1kxLt40vQdr4/CykSCxeSOJA
 /7WjKXEBr9rXTULAsR/dFsmZLJaXWP2ndRLF/zW2wSHEg2ffRbduG86Rm9Q1U4mj3MvIVVg==
X-Google-Smtp-Source: ABdhPJz67NVxJW2vaoMGx286+lfyUve0UxOOQS00muAMBgCrDOPr5VxvwaPFBQxM9shyB9jvw/hfAhJ3jr4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:2506:: with SMTP id
 v6mr1140464jat.94.1644283637128; Mon, 07 Feb 2022 17:27:17 -0800 (PST)
Date: Tue,  8 Feb 2022 01:27:05 +0000
Message-Id: <20220208012705.640444-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH] KVM: arm64: Drop unused param from kvm_psci_version()
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
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

kvm_psci_version() consumes a pointer to struct kvm in addition to a
vcpu pointer. Drop the kvm pointer as it is unused. While the comment
suggests the explicit kvm pointer was useful for calling from hyp, there
exist no such callsite in hyp.

Signed-off-by: Oliver Upton <oupton@google.com>
---

Applies to 5.17-rc3.

 arch/arm64/kvm/psci.c  | 6 +++---
 include/kvm/arm_psci.h | 6 +-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3eae32876897..a0c10c11f40e 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -85,7 +85,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 	if (!vcpu->arch.power_off) {
-		if (kvm_psci_version(source_vcpu, kvm) != KVM_ARM_PSCI_0_1)
+		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
 			return PSCI_RET_INVALID_PARAMS;
@@ -392,7 +392,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  */
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
-	switch (kvm_psci_version(vcpu, vcpu->kvm)) {
+	switch (kvm_psci_version(vcpu)) {
 	case KVM_ARM_PSCI_1_0:
 		return kvm_psci_1_0_call(vcpu);
 	case KVM_ARM_PSCI_0_2:
@@ -471,7 +471,7 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	switch (reg->id) {
 	case KVM_REG_ARM_PSCI_VERSION:
-		val = kvm_psci_version(vcpu, vcpu->kvm);
+		val = kvm_psci_version(vcpu);
 		break;
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 5b58bd2fe088..297645edcaff 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -16,11 +16,7 @@
 
 #define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
 
-/*
- * We need the KVM pointer independently from the vcpu as we can call
- * this from HYP, and need to apply kern_hyp_va on it...
- */
-static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
+static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Our PSCI implementation stays the same across versions from
-- 
2.35.0.263.gb82422642f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

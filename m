Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D296EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 84C4E63238
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 84C4E63238
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 177B64B161;
	Wed, 17 Nov 2021 01:53:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9FYUDXX6ifej; Wed, 17 Nov 2021 01:53:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81D3A4B164;
	Wed, 17 Nov 2021 01:53:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0B504B0F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G+j8eJmRvutZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:39 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02E0A4B161
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:39 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 g36-20020a25ae64000000b005c1f46f7ee6so2524662ybe.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wz9t+E+VXiepJL6MLtAC0LvVnUdPh/IHUgmRsgArlcE=;
 b=HvmUEQUJKrrfy7KQn+cPJTS8uyt5JY8g+FZ1ZhWzbq0B0GZkYE8v1oNob9IbqThMf5
 eIVgxeUWlrp58vNANslC25kMYjxXao1OoVVlwkeRdIQBFhpsxv1TvPOC2f7M5KZhw+37
 noAnmBOzEfni+Dz99DJpIx33CHG82FTQtENK+hjXje3ELzg0H/eOgdamlud+8hob8s/n
 d8TeP3wjd8FQ7MzygsQQiCs3/erA2mIHvazIYJTKNSdQxR9t4VI0XVvGS8E0HirEZClb
 c4ryR9AUVbcrH8j7FbGB2L7qnbJQcHQVRsWNS94rrM31RTtDfzmSJIvR8mqT25wutC/n
 BobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wz9t+E+VXiepJL6MLtAC0LvVnUdPh/IHUgmRsgArlcE=;
 b=rzgja549OD9xJscOg6TvtVb0leBb0BwHMck+mS2MLjajSheqXO9hNvIecbDzBSE+a2
 wEHvZAgl49oStvnDfzUVQtYpaboBsjUXKxNwJzwBtcd1YiFD9sn5E+LNDGyl9mGCYSr9
 aQhGy4cRPhd5JTDzSFmcE4bRedUvodFNEbrPgqTRhLYCZAG87p+WHBmIs+YM9phqZS/H
 Gtr0gsAhlrkv6q6tAtg/lDV2xE6evuE0Iy/468BM7tfOlUS6ML0aQ4BRBXEfxAZttQrc
 XH0UjdTHTvBcdY1ol05yAHA/vJJAgrRiKpofSy0lAASZ2WKNWhvuVX/horGrHJzOMc6x
 NEXQ==
X-Gm-Message-State: AOAM531//xsZcUMEgcoU0NPRx+EbGBk7Tm9mrT3UGdoeFU0l3Cp6+1gd
 0HMxYBs4djOIgZQrmRLp3vXAOS+Ef/E=
X-Google-Smtp-Source: ABdhPJyjCsGmjtTxCxe1Vx5kKC6qmnUVUhpi3G5rKbLKiwo+hm36IOcGaCTCDHDDH8Ex13kOFhhfD90EqIo=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:d68e:: with SMTP id
 n136mr15514402ybg.59.1637132018496; 
 Tue, 16 Nov 2021 22:53:38 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:49 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-20-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 19/29] KVM: arm64: Use vcpu->arch cptr_el2 to track
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
index a39fcf318c77..c1e0e1202f30 100644
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
index a54579e7ac91..aa4aff2588b8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1128,7 +1128,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
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
index 5a2cb5d9bc4b..0c3f0bf3fbf2 100644
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
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

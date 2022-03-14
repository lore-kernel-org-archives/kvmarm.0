Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C8DC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 06:22:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C5940BFA;
	Mon, 14 Mar 2022 02:22:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5RX8vyQ8qBSe; Mon, 14 Mar 2022 02:22:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85E9840D26;
	Mon, 14 Mar 2022 02:22:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D247B40BFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 02:22:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a8I3GWKcsgv2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 02:22:41 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A901D40BED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 02:22:41 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 1-20020a630c41000000b00378d9d6bd91so9451117pgm.17
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 23:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xenb/1ISCk7dcRLaKlYQ+e2AP/GZy2ZjysoZ1kcszrY=;
 b=DSUsF7N3aIFH1i1fTiCK9CjN0QW6D948QKOUlGlh2UuiOkdNkXd8RKrg5hzi2McXzo
 Yby/XWXIvNWGESZTDF8EZBUzIjSXbtani23vt4vvf6d5zF+x20Ga5ICMET2gIZ/dvsUX
 QWYoNcTbBByUQiyuTCQYOj9Zti+Di3oUzex757zRF2Ny3h3//N1l284qlz1H1lufVjeg
 l5XOd+QHb3g5ky4wLgKXg5hj0zQZ9TTjtJciJm1xrJ+zgNPRZQb1eMmSeLfRIh9JcB30
 8YS6rj1msDgtrUUuH45JJCSCpPjfij2qrjZgxUxpaXdQdKONK+7IhD224Vxfb1Xkkvln
 Cqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xenb/1ISCk7dcRLaKlYQ+e2AP/GZy2ZjysoZ1kcszrY=;
 b=rITJJGd3K1mXayL/iULjr855dBBV3F6Q5uS8LthDaCEPFe1OYodtfgbpNvRXHozdDi
 NSLTPzNWlJkWj/Mwk4WwuFDAjCUzYyZbe31qRzZsOgDJLGPjRM6S/8FlZdAqRUAzc4BH
 8pXuouNjppvAeIfakcrep1ckwbxWEBH+logaPW/7WX+ILGZnpI3pQ62wzmH/KrEmkJFf
 NGZHfStOY5q0c8H7PKRvZquXpkengo7pHNOEyOUeq/pk565mujo7kx5CMA6NRY0PLDA9
 MbBzcfVb2HubFbTzRrRaut1i9hVvnhpzuZHYRZdJp3sCAvT/tIb7eqPuKWRC9uN5iGHB
 sC9w==
X-Gm-Message-State: AOAM532gq7Qm9/ntXvUUczeEzrqUCEd8Po2LMqnZ9zmzid5JxkEzSyS4
 Qg2eFLvkEofPVToAdj+iNmg5eUf0+48=
X-Google-Smtp-Source: ABdhPJzOI3/KfFAuIBvluYrBdn2RPKcQ0dKj9zPVWBd0OLQsXs16GIBzPmI+10IH5RnAHwVrLDsOYvjMMZ8=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:f708:b0:153:839f:bf2c with SMTP id
 h8-20020a170902f70800b00153839fbf2cmr1817565plo.113.1647238960836; Sun, 13
 Mar 2022 23:22:40 -0700 (PDT)
Date: Sun, 13 Mar 2022 23:19:57 -0700
In-Reply-To: <20220314061959.3349716-1-reijiw@google.com>
Message-Id: <20220314061959.3349716-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220314061959.3349716-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 1/3] KVM: arm64: Generalise VM features into a set of flags
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

From: Marc Zyngier <maz@kernel.org>

We currently deal with a set of booleans for VM features,
while they could be better represented as set of flags
contained in an unsigned long, similarily to what we are
doing on the CPU side.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++-----
 arch/arm64/kvm/arm.c              |  5 +++--
 arch/arm64/kvm/mmio.c             |  3 ++-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5bc01e62c08a..11a7ae747ded 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -122,7 +122,10 @@ struct kvm_arch {
 	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
 	 * supported.
 	 */
-	bool return_nisv_io_abort_to_user;
+#define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
+	/* Memory Tagging Extension enabled for the guest */
+#define KVM_ARCH_FLAG_MTE_ENABLED			1
+	unsigned long flags;
 
 	/*
 	 * VM-wide PMU filter, implemented as a bitmap and big enough for
@@ -133,9 +136,6 @@ struct kvm_arch {
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
-
-	/* Memory Tagging Extension enabled for the guest */
-	bool mte_enabled;
 };
 
 struct kvm_vcpu_fault_info {
@@ -786,7 +786,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
 	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
-#define kvm_has_mte(kvm) (system_supports_mte() && (kvm)->arch.mte_enabled)
+#define kvm_has_mte(kvm)					\
+	(system_supports_mte() &&				\
+	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..9a2d240ef6a3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -89,7 +89,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
 		r = 0;
-		kvm->arch.return_nisv_io_abort_to_user = true;
+		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+			&kvm->arch.flags);
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
@@ -97,7 +98,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			r = -EINVAL;
 		} else {
 			r = 0;
-			kvm->arch.mte_enabled = true;
+			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 		}
 		mutex_unlock(&kvm->lock);
 		break;
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3e2d8ba11a02..3dd38a151d2a 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -135,7 +135,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	 * volunteered to do so, and bail out otherwise.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
-		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
+		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
 			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
 			run->arm_nisv.fault_ipa = fault_ipa;
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

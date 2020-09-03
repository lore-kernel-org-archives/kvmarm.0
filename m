Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709ECC2BC11
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:26:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17C5A2072A
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 15:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="x1flBPDm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17C5A2072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAFFA4B35D;
	Thu,  3 Sep 2020 11:26:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NJrRiJ2KNMr8; Thu,  3 Sep 2020 11:26:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 352224B340;
	Thu,  3 Sep 2020 11:26:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 165674B25C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:26:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5yqyW89YieM7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 11:26:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFE934B275
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 11:26:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 25E812072A;
 Thu,  3 Sep 2020 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599146786;
 bh=3GwlQXC6rqZcwdvQL6Cznwbl4GbO5TFs/sVjhxfanos=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=x1flBPDmW/jxJ/a4aG/VS9HEuAHUbSaI98O7DHosNPJSduZGjAkVACXZsE3x4pVem
 thRA+UwWc7qwVMST6SFp7v17mSTEACsD8RiO/ZNDFec1puJCkXIdKvvUtz969N4c9T
 jPRi4h9Xtyj189+gysNGXqCjh9dcwq5yg4SfT7mE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kDr84-008vT9-Il; Thu, 03 Sep 2020 16:26:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/23] KVM: arm64: vgic-v3: Move early init to
 kvm_vgic_create()
Date: Thu,  3 Sep 2020 16:25:53 +0100
Message-Id: <20200903152610.1078827-7-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com
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

The current early init for the GIC is pretty silly. The data
it initializes only matters for GICv3, which is guaranteed to
be created via a kvm_create_device call. Given that,
it is pointless to initialize the data early, before userspace can
get a file descriptor and mess with it.

Move everything to kvm_vgic_create().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c            |  2 --
 arch/arm64/kvm/vgic/vgic-init.c | 24 +++++-------------------
 include/kvm/arm_vgic.h          |  1 -
 3 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 46dc3d75cf13..41f98564f507 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -120,8 +120,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_free_stage2_pgd;
 
-	kvm_vgic_early_init(kvm);
-
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 8157171b8af3..76cce0db63a7 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -39,25 +39,6 @@
  *   allocation is allowed there.
  */
 
-/* EARLY INIT */
-
-/**
- * kvm_vgic_early_init() - Initialize static VGIC VCPU data structures
- * @kvm: The VM whose VGIC districutor should be initialized
- *
- * Only do initialization of static structures that don't require any
- * allocation or sizing information from userspace.  vgic_init() called
- * kvm_vgic_dist_init() which takes care of the rest.
- */
-void kvm_vgic_early_init(struct kvm *kvm)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-
-	INIT_LIST_HEAD(&dist->lpi_list_head);
-	INIT_LIST_HEAD(&dist->lpi_translation_cache);
-	raw_spin_lock_init(&dist->lpi_list_lock);
-}
-
 /* CREATION */
 
 /**
@@ -72,6 +53,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	int i, ret;
 	struct kvm_vcpu *vcpu;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 
 	if (irqchip_in_kernel(kvm))
 		return -EEXIST;
@@ -116,6 +98,10 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	else
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
+	INIT_LIST_HEAD(&dist->lpi_list_head);
+	INIT_LIST_HEAD(&dist->lpi_translation_cache);
+	raw_spin_lock_init(&dist->lpi_list_lock);
+
 out_unlock:
 	unlock_all_vcpus(kvm);
 	return ret;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 88461ecfa854..8d30fc645148 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -335,7 +335,6 @@ extern struct static_key_false vgic_v2_cpuif_trap;
 extern struct static_key_false vgic_v3_cpuif_trap;
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
-void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

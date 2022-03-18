Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFD7C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 17:00:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 824B649EC0;
	Fri, 18 Mar 2022 13:00:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@inria.fr
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FmiUdUoZb3PX; Fri, 18 Mar 2022 13:00:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F100A49ED1;
	Fri, 18 Mar 2022 13:00:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C85F440BD6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 06:37:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J73SrzC22R3d for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 06:37:40 -0400 (EDT)
Received: from mail3-relais-sop.national.inria.fr
 (mail3-relais-sop.national.inria.fr [192.134.164.104])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F4E8404FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 06:37:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inria.fr; s=dc;
 h=from:to:cc:subject:date:message-id:mime-version:
 content-transfer-encoding;
 bh=pS7arhwdyxiLBpw5HAeNYXhsv7AvmLsCK+O6q1yQ9rU=;
 b=arTLc8bgqEq4N5GNK1xjAtfkwmA1fcqrxpmJFzdDw2xXcg02AhV3y4W2
 Wpdg8IclaiXlkcTdt0esWqiJ117uCJ6DCg0BuIjbuHu9HlaWSSPgL1GgT
 hkySdtY5Rmw8X8eLR/TZPNnhedTyd1mxzYLHgitAs37B2dPdof9v+8mrD M=;
Authentication-Results: mail3-relais-sop.national.inria.fr;
 dkim=none (message not signed) header.i=none;
 spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr;
 dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,192,1643670000"; 
   d="scan'208";a="8935660"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
 by mail3-relais-sop.national.inria.fr with
 ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 11:37:39 +0100
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm64: fix typos in comments
Date: Fri, 18 Mar 2022 11:37:19 +0100
Message-Id: <20220318103729.157574-24-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 18 Mar 2022 13:00:41 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 arch/arm64/kvm/arm.c                 |    2 +-
 arch/arm64/kvm/guest.c               |    2 +-
 arch/arm64/kvm/handle_exit.c         |    2 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c |    4 ++--
 arch/arm64/kvm/mmu.c                 |    2 +-
 arch/arm64/kvm/vgic/vgic.c           |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 01fa1838698c..edb00517a242 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1686,7 +1686,7 @@ static void init_cpu_logical_map(void)
 
 	/*
 	 * Copy the MPIDR <-> logical CPU ID mapping to hyp.
-	 * Only copy the set of online CPUs whose features have been chacked
+	 * Only copy the set of online CPUs whose features have been checked
 	 * against the finalized system capabilities. The hypervisor will not
 	 * allow any other CPUs from the `possible` set to boot.
 	 */
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index e116c7767730..7e15b03fbdf8 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -282,7 +282,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			break;
 
 		/*
-		 * Otherwide, this is a priviledged mode, and *all* the
+		 * Otherwise, this is a privileged mode, and *all* the
 		 * registers must be narrowed to 32bit.
 		 */
 		default:
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e3140abd2e2e..97fe14aab1a3 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -248,7 +248,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 	case ARM_EXCEPTION_HYP_GONE:
 		/*
 		 * EL2 has been reset to the hyp-stub. This happens when a guest
-		 * is pre-empted by kvm_reboot()'s shutdown call.
+		 * is pre-emptied by kvm_reboot()'s shutdown call.
 		 */
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		return 0;
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 543cad6c376a..d40f0b30b534 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -102,7 +102,7 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 	 * Only the first struct hyp_page of a high-order page (otherwise known
 	 * as the 'head') should have p->order set. The non-head pages should
 	 * have p->order = HYP_NO_ORDER. Here @p may no longer be the head
-	 * after coallescing, so make sure to mark it HYP_NO_ORDER proactively.
+	 * after coalescing, so make sure to mark it HYP_NO_ORDER proactively.
 	 */
 	p->order = HYP_NO_ORDER;
 	for (; (order + 1) < pool->max_order; order++) {
@@ -110,7 +110,7 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 		if (!buddy)
 			break;
 
-		/* Take the buddy out of its list, and coallesce with @p */
+		/* Take the buddy out of its list, and coalesce with @p */
 		page_remove_from_list(buddy);
 		buddy->order = HYP_NO_ORDER;
 		p = min(p, buddy);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1623abc56af2..0d19259454d8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -615,7 +615,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 };
 
 /**
- * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
+ * kvm_init_stage2_mmu - Initialise a S2 MMU structure
  * @kvm:	The pointer to the KVM structure
  * @mmu:	The pointer to the s2 MMU structure
  *
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 9b98876a8a93..d97e6080b421 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -37,7 +37,7 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  * If you need to take multiple locks, always take the upper lock first,
  * then the lower ones, e.g. first take the its_lock, then the irq_lock.
  * If you are already holding a lock and need to take a higher one, you
- * have to drop the lower ranking lock first and re-aquire it after having
+ * have to drop the lower ranking lock first and re-acquire it after having
  * taken the upper one.
  *
  * When taking more than one ap_list_lock at the same time, always take the

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3094C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 21:47:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 28E67216C4
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 21:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oepny0XT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28E67216C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92D724BA5A;
	Mon,  9 Nov 2020 16:47:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zjbloEuZbF70; Mon,  9 Nov 2020 16:47:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 985EF4BA3E;
	Mon,  9 Nov 2020 16:47:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 916534BA3B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 16:47:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KFqpmRzWmHNY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 16:47:48 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6C044BA28
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 16:47:47 -0500 (EST)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 91CA6216C4;
 Mon,  9 Nov 2020 21:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604958466;
 bh=lRQNbW/3TEq/gc9OB7C7afTvNC05/UUzhnkuH8AqnBs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=oepny0XTEv/mUJx9tC0L6X8BsPBqSx6gW9WWhJQHM0RZvLXaijIp093XDWji4bKwP
 lX0vQXP6SGcNFqxiH9b2e2xXhL/98FJshKbRp6GufaVI+D/dmOi+de5ZvYmUA+wBgR
 hcTIyYv8kW9rgTzH7Q06mf11D5JllX1W7+yzayzQ=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/9] KVM: arm64: Tidy up kvm_map_vector()
Date: Mon,  9 Nov 2020 21:47:19 +0000
Message-Id: <20201109214726.15276-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201109214726.15276-1-will@kernel.org>
References: <20201109214726.15276-1-will@kernel.org>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
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

The bulk of the work in kvm_map_vector() is conditional on the
ARM64_HARDEN_EL2_VECTORS capability, so return early if that is not set
and make the code a bit easier to read.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b43b637ded14..476bc613d0e6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1297,6 +1297,8 @@ static unsigned long nvhe_percpu_order(void)
 
 static int kvm_map_vectors(void)
 {
+	int slot;
+
 	/*
 	 * SV2  = ARM64_SPECTRE_V2
 	 * HEL2 = ARM64_HARDEN_EL2_VECTORS
@@ -1306,22 +1308,20 @@ static int kvm_map_vectors(void)
 	 * !SV2 +  HEL2 -> allocate one vector slot and use exec mapping
 	 *  SV2 +  HEL2 -> use hardened vectors and use exec mapping
 	 */
-	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
-		phys_addr_t vect_pa = __pa_symbol(__bp_harden_hyp_vecs);
-		unsigned long size = __BP_HARDEN_HYP_VECS_SZ;
+	if (!cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS))
+		return 0;
 
-		/*
-		 * Always allocate a spare vector slot, as we don't
-		 * know yet which CPUs have a BP hardening slot that
-		 * we can reuse.
-		 */
-		__kvm_harden_el2_vector_slot = atomic_inc_return(&arm64_el2_vector_last_slot);
-		BUG_ON(__kvm_harden_el2_vector_slot >= BP_HARDEN_EL2_SLOTS);
-		return create_hyp_exec_mappings(vect_pa, size,
-						&__kvm_bp_vect_base);
-	}
+	/*
+	 * Always allocate a spare vector slot, as we don't know yet which CPUs
+	 * have a BP hardening slot that we can reuse.
+	 */
+	slot = atomic_inc_return(&arm64_el2_vector_last_slot);
+	BUG_ON(slot >= BP_HARDEN_EL2_SLOTS);
+	__kvm_harden_el2_vector_slot = slot;
 
-	return 0;
+	return create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
+					__BP_HARDEN_HYP_VECS_SZ,
+					&__kvm_bp_vect_base);
 }
 
 static void cpu_init_hyp_mode(void)
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

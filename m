Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0B2C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:58:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DF3022450
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:58:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/wtJwoM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DF3022450
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AAFB4B515;
	Mon, 26 Oct 2020 11:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RSRbqUiwJgS9; Mon, 26 Oct 2020 11:58:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81E184B537;
	Mon, 26 Oct 2020 11:58:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0D614B4D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mDu4TOMhxA4t for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 11:58:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3B764B4DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:45 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EFC14217A0;
 Mon, 26 Oct 2020 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603727925;
 bh=7Ar8bClLUTasehTCKiVgnbzkRple2HbFLS9tdEKRAPw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=G/wtJwoMVcuW3TOvziz6koq2yFMTMW3L/limSDZH9FVe0kMTX7XgY8kjaGcwK7l39
 WacCR2EOVNaV0AKLgMnrT9/iAK9UtaLsdgm5UKImjY6I/87ZHvN4QH6UCOU/iTARij
 KARBs0KZu3Axz1Xlg271y8RXx7LWRmbPBqxmxNWo=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/9] KVM: arm64: Tidy up kvm_map_vector()
Date: Mon, 26 Oct 2020 15:58:26 +0000
Message-Id: <20201026155833.24847-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201026155833.24847-1-will@kernel.org>
References: <20201026155833.24847-1-will@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>
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
index 9353e0c09abe..322b0e5157cb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1278,6 +1278,8 @@ static unsigned long nvhe_percpu_order(void)
 
 static int kvm_map_vectors(void)
 {
+	int slot;
+
 	/*
 	 * SV2  = ARM64_SPECTRE_V2
 	 * HEL2 = ARM64_HARDEN_EL2_VECTORS
@@ -1287,22 +1289,20 @@ static int kvm_map_vectors(void)
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
2.29.0.rc2.309.g374f81d7ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

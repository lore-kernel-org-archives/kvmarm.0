Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0883C4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:58:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED1ED22404
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nnk3woyj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED1ED22404
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 950E64B51D;
	Mon, 26 Oct 2020 11:58:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jfd7k1n0jlfH; Mon, 26 Oct 2020 11:58:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50EC84B510;
	Mon, 26 Oct 2020 11:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CAA64B4DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MD87plGlKkZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 11:58:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6ED7A4B4FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:44 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 892DE22400;
 Mon, 26 Oct 2020 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603727923;
 bh=VfgM1+SvY643WbAQ6iDGI+O6TX857Y+GLhJWWzshUwI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Nnk3woyjNkWWaKbdaeUbz6fb9mt2TlZluUov/U++3nqaEoJqLDophI4XezFit/fhz
 r/vS8tTVMGfCGBbCnL2KoG8X4uq5RPIkKcSBqp0WeG5XHtUo3ucXkHWsy8YJKFwXmT
 Nr4lPhotksphYIlBlHC9W0GG6SF4108CONOfdgsE=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/9] KVM: arm64: Remove redundant Spectre-v2 code from
 kvm_map_vector()
Date: Mon, 26 Oct 2020 15:58:25 +0000
Message-Id: <20201026155833.24847-2-will@kernel.org>
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

'__kvm_bp_vect_base' is only used when dealing with the hardened vectors
so remove the redundant assignments in kvm_map_vectors().

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f56122eedffc..9353e0c09abe 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1287,11 +1287,6 @@ static int kvm_map_vectors(void)
 	 * !SV2 +  HEL2 -> allocate one vector slot and use exec mapping
 	 *  SV2 +  HEL2 -> use hardened vectors and use exec mapping
 	 */
-	if (cpus_have_const_cap(ARM64_SPECTRE_V2)) {
-		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs);
-		__kvm_bp_vect_base = kern_hyp_va(__kvm_bp_vect_base);
-	}
-
 	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
 		phys_addr_t vect_pa = __pa_symbol(__bp_harden_hyp_vecs);
 		unsigned long size = __BP_HARDEN_HYP_VECS_SZ;
-- 
2.29.0.rc2.309.g374f81d7ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42585C56202
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 11:39:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8D612137B
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 11:39:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEueT7cx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8D612137B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C724BCC2;
	Fri, 13 Nov 2020 06:39:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9M06EHRIRxI6; Fri, 13 Nov 2020 06:39:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5320D4BD71;
	Fri, 13 Nov 2020 06:39:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E6034BCB9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 06:39:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9WZLsXBNlt4a for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 06:39:05 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC33A4BCB6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 06:39:03 -0500 (EST)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 83A77207DE;
 Fri, 13 Nov 2020 11:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605267542;
 bh=CXFWhEYw7GtHb1221lOgY2A7PwohlC7DyjOHpoesNjo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=FEueT7cxKlddRtgml20SKmF8QGI/+cXB5YdE8S9wOUJpBncZBS8FuUcT2bHS5DDZ9
 Pgd0PG4swtzAtFDW0cWx/0Gi4Bkmu2bjMYGUZNR7GoRw2iQ6q88MGWQKbAzezb1ntH
 iYra12XbtOGiWp1XMS6lo1kVOS4Rbijqqj3tZfF8=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 06/10] KVM: arm64: Re-jig logic when patching hardened hyp
 vectors
Date: Fri, 13 Nov 2020 11:38:43 +0000
Message-Id: <20201113113847.21619-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201113113847.21619-1-will@kernel.org>
References: <20201113113847.21619-1-will@kernel.org>
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

The hardened hyp vectors are not used on systems running with VHE or CPUs
without the ARM64_HARDEN_EL2_VECTORS capability.

Re-jig the checking logic slightly in kvm_patch_vector_branch() so that
it's a bit clearer what we're looking for. This is purely cosmetic.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/va_layout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index d1195c288c9f..760db2c84b9b 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -139,8 +139,8 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 
 	BUG_ON(nr_inst != 5);
 
-	if (has_vhe() || !cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
-		WARN_ON_ONCE(cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS));
+	if (!cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS) ||
+	    WARN_ON_ONCE(has_vhe())) {
 		return;
 	}
 
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

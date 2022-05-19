Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13416C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B93A84B32E;
	Thu, 19 May 2022 09:44:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z7D-+3udpBAR; Thu, 19 May 2022 09:44:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F5D4B366;
	Thu, 19 May 2022 09:44:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87B2A4B28D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uuC5CU-N1emY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:44:30 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 700184B366
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:30 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9A906B82477;
 Thu, 19 May 2022 13:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51C4C34115;
 Thu, 19 May 2022 13:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967868;
 bh=NQ6SWFoOzjdMQ7IQILXMfWfCkw6f84MvjUSYfV0Aqic=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Jr1/kz7V4b+WFeZPm4n6SvvfBLnsn11vQHxdy4iMDYXZkSDLIYQCw/pbXgtRv1zDw
 YUUeyyySJ3IXi+5xgI7BRYzdFotNAm9UMO1tewYm3kNtNK/N3H5fdCJgurDNLLiVaO
 yw26aRCPz9hyn305tg+QacfMEfwRetntZ9hrZ1mSHel/OpfFh2GZ+vCits5vM0GfSM
 imoQRSSP42318gOm1DMDjzcmIjk4ZIHhk40naZpJkLjDKIgODsqTAUz5g9DQ/UTBwd
 7B99D763qW/FGQf5Y2oB6osRJC7aIvvtXHRW3cDutkDZ1Mq4cIf1ARJ1StG5pFrqrz
 PPbvi4EzP3IoA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 31/89] KVM: arm64: Disallow dirty logging and RO memslots with
 pKVM
Date: Thu, 19 May 2022 14:41:06 +0100
Message-Id: <20220519134204.5379-32-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

The current implementation of pKVM doesn't support dirty logging or
read-only memslots. Although support for these features is desirable,
this will require future work, so let's cleanly report the limitations
to userspace by failing the ioctls until then.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 67cac3340d49..df92b5f7ac63 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1679,11 +1679,17 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva, reg_end;
 	int ret = 0;
 
-	/* In protected mode, cannot modify memslots once a VM has run. */
-	if (is_protected_kvm_enabled() &&
-	    (change == KVM_MR_DELETE || change == KVM_MR_MOVE) &&
-	    kvm->arch.pkvm.shadow_handle) {
-		return -EPERM;
+	if (is_protected_kvm_enabled()) {
+		/* In protected mode, cannot modify memslots once a VM has run. */
+		if ((change == KVM_MR_DELETE || change == KVM_MR_MOVE) &&
+		    kvm->arch.pkvm.shadow_handle) {
+			return -EPERM;
+		}
+
+		if (new &&
+		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
+			return -EPERM;
+		}
 	}
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

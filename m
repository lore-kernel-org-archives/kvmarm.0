Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3060FC433DF
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC2C322D03
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VnyRY45e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC2C322D03
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 977B84B4CB;
	Wed,  5 Aug 2020 14:26:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j7+0EMjdMpZw; Wed,  5 Aug 2020 14:26:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C1ED4B5AF;
	Wed,  5 Aug 2020 14:26:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 317244B4C6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 02X+w8cx32Qm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 14:26:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E855B4B431
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:00 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0C13522CE3;
 Wed,  5 Aug 2020 18:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596651960;
 bh=3U7buSNUEjcQUVvkpA07ruuC7lkCwoCZadrKnYwdpp8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=VnyRY45eC5j8qt31RBEYZoTQY+Vdo/1lmkGcUbtHYRV4TQfXRQNnqI6JwYCL2VTkl
 RXJ8ggH10KOZUHKpXvfU49E4nMPr4KhoaDE1fimpHr6GQmkaEx7YSRP65/ijhHFcjq
 tGneUtJ6KdbCMR5i293Hh9HZksoA4EYoOY/CfBX4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3Ng5-0004w9-P0; Wed, 05 Aug 2020 18:58:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 56/56] KVM: arm64: Move S1PTW S2 fault logic out of
 io_mem_abort()
Date: Wed,  5 Aug 2020 18:57:00 +0100
Message-Id: <20200805175700.62775-57-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
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

From: Will Deacon <will@kernel.org>

To allow for re-injection of stage-2 faults on stage-1 page-table walks
due to either a missing or read-only memslot, move the triage logic out
of io_mem_abort() and into kvm_handle_guest_abort(), where these aborts
can be handled before anything else.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Link: https://lore.kernel.org/r/20200729102821.23392-5-will@kernel.org
---
 arch/arm64/kvm/mmio.c |  6 ------
 arch/arm64/kvm/mmu.c  | 13 ++++++++++++-
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 4e0366759726..58de2ae4f6bb 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -145,12 +145,6 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		return -ENOSYS;
 	}
 
-	/* Page table accesses IO mem: tell guest to fix its TTBR */
-	if (kvm_vcpu_dabt_iss1tw(vcpu)) {
-		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
-		return 1;
-	}
-
 	/*
 	 * Prepare MMIO operation. First decode the syndrome data we get
 	 * from the CPU. Then try if some in-kernel emulation feels
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 85b0ec9dd9ef..dc8464669efd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2105,12 +2105,23 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
+		/*
+		 * The guest has put either its instructions or its page-tables
+		 * somewhere it shouldn't have. Userspace won't be able to do
+		 * anything about this (there's no syndrome for a start), so
+		 * re-inject the abort back into the guest.
+		 */
 		if (is_iabt) {
-			/* Prefetch Abort on I/O address */
 			ret = -ENOEXEC;
 			goto out;
 		}
 
+		if (kvm_vcpu_dabt_iss1tw(vcpu)) {
+			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+			ret = 1;
+			goto out_unlock;
+		}
+
 		/*
 		 * Check for a cache maintenance operation. Since we
 		 * ended-up here, we know it is outside of any memory
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

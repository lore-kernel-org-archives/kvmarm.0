Return-Path: <SRS0=9qIm=BD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16C1C433F1
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jul 2020 14:35:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A91620836
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jul 2020 14:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCelo5hc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A91620836
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 457D64B418;
	Fri, 24 Jul 2020 10:35:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bGHygws97u+k; Fri, 24 Jul 2020 10:35:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4E54B45F;
	Fri, 24 Jul 2020 10:35:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCE294B43F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2020 10:35:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CjwHAX2j-DyL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2020 10:35:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC4994B38C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2020 10:35:22 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A56B420714;
 Fri, 24 Jul 2020 14:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595601322;
 bh=nRSup5oIqQmb2RxIWwmKIgwnUNAyLD5LZ4z565QIuW4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=KCelo5hchAth+oQZaQ/g7s+9X9saqctfN4NO81m3gcJa4w01EYmMebeQ5kwJTZbVb
 71w3pC5VFYzpYtLGbE5fIeEu4dM3CMv9h+458DpnGy3jZ1OZlxAvBLRMv2IoOzmFXq
 rqgxnA9BRTCWMsqhD94w96nTKoEOyl09P6RcsLX4=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 5/7] KVM: arm64: Move 'invalid syndrome' logic out of
 io_mem_abort()
Date: Fri, 24 Jul 2020 15:35:04 +0100
Message-Id: <20200724143506.17772-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200724143506.17772-1-will@kernel.org>
References: <20200724143506.17772-1-will@kernel.org>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

In preparation for handling stage-2 faults on stage-1 page-table walks
earlier, move the 'invalid syndrome' logic out of io_mem_abort() and
into its own function, which can be called from kvm_handle_guest_abort()
directly.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmio.c | 22 ----------------------
 arch/arm64/kvm/mmu.c  | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index b54ea5aa6c06..45a630e480e1 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -136,28 +136,6 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	int len;
 	u8 data_buf[8];
 
-	/*
-	 * No valid syndrome? Ask userspace for help if it has
-	 * volunteered to do so, and bail out otherwise.
-	 */
-	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
-		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
-			run->exit_reason = KVM_EXIT_ARM_NISV;
-			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
-			run->arm_nisv.fault_ipa = fault_ipa;
-			return 0;
-		}
-
-		kvm_pr_unimpl("Data abort outside memslots with no valid syndrome info\n");
-		return -ENOSYS;
-	}
-
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
index 73e62d360a36..adb933ecd177 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2046,6 +2046,20 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 		kvm_set_pfn_accessed(pfn);
 }
 
+static int handle_error_invalid_dabt(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				     phys_addr_t fault_ipa)
+{
+	if (!vcpu->kvm->arch.return_nisv_io_abort_to_user) {
+		kvm_pr_unimpl("Data abort outside memslots with no valid syndrome info\n");
+		return -ENOSYS;
+	}
+
+	run->exit_reason = KVM_EXIT_ARM_NISV;
+	run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
+	run->arm_nisv.fault_ipa = fault_ipa;
+	return 0;
+}
+
 /**
  * kvm_handle_guest_abort - handles all 2nd stage aborts
  * @vcpu:	the VCPU pointer
@@ -2133,6 +2147,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * of the page size.
 		 */
 		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
+
+		/*
+		 * No valid syndrome? Ask userspace for help if it has
+		 * volunteered to do so, and bail out otherwise.
+		 */
+		if (!kvm_vcpu_dabt_isvalid(vcpu)) {
+			ret = handle_error_invalid_dabt(vcpu, run, fault_ipa);
+			goto out_unlock;
+		}
+
+		if (kvm_vcpu_dabt_iss1tw(vcpu)) {
+			ret = -ENXIO;
+			goto out;
+		}
+
 		ret = io_mem_abort(vcpu, run, fault_ipa);
 		goto out_unlock;
 	}
@@ -2153,6 +2182,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	if (ret == -ENOEXEC) {
 		kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 		ret = 1;
+	} else if (ret == -ENXIO) {
+		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+		ret = 1;
 	}
 out_unlock:
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

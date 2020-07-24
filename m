Return-Path: <SRS0=9qIm=BD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E3FC433F7
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jul 2020 14:35:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E62DD206F0
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jul 2020 14:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qh8oWoBa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E62DD206F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A16344A524;
	Fri, 24 Jul 2020 10:35:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BHFrRZfNeKrx; Fri, 24 Jul 2020 10:35:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6134B4BD;
	Fri, 24 Jul 2020 10:35:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C0E14B448
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2020 10:35:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GlEcGiPYVC21 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2020 10:35:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 617CA4B3B2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2020 10:35:26 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4ECBB2065C;
 Fri, 24 Jul 2020 14:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595601325;
 bh=aH6+b9S0bxa9/SN+80CrqBVkxawU3zO7lLnHFqJKx/Q=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qh8oWoBa5d97kv/5Ec1xVKnU0c7jbVGRWvECJktcuh03XdNewjxMcBYP3kJZeQap5
 ze1Ac6uT4dw0xZJk4hqEQvVSlsoVcdUlBCG1E99K3NqUPXc8Umc+42BEThUIAKNZCd
 ewtLa8hzzMldYszFp+8yn/9Fcf8wbqkfer26IgrA=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 7/7] KVM: arm64: Separate write faults on read-only memslots
 from MMIO
Date: Fri, 24 Jul 2020 15:35:06 +0100
Message-Id: <20200724143506.17772-8-will@kernel.org>
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

Although taking a write-fault on a read-only memslot triggers an MMIO
exit back to userspace, lumping the handling together in
kvm_handle_guest_abort() causes some of the early triage to have weird
effects on userspace. For example, if a guest generates a stage-2 fault
on a stage-1 translation fault when trying to fetch an instruction from
a read-only memslot, it will be mistakenly treated as an attempt to
execute from MMIO and a prefetch abort will be re-injected into the
guest.

Separate the MMIO handling from the read-only memslot handling, so that
the latter is left entirely up to userspace. Note that this _will_
result in more exits than before for read-only memslots, since userspace
will now see some cache maintenance and instruction-side aborts.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 45 ++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9e72e7f4a2c2..2edc6f2412dc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2117,9 +2117,30 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
-	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
+
+	/*
+	 * The IPA is reported as [MAX:12], so we need to complement it with
+	 * the bottom 12 bits from the faulting VA. This is always 12 bits,
+	 * irrespective of the page size.
+	 */
+	fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
+
+	/*
+	 * We can perform some early fault triage based purely on the memslot
+	 * information:
+	 *
+	 * Faults on IPAs falling outside of any memslot are re-injected
+	 * into the guest as external aborts if they were either signalled as
+	 * instruction aborts or as a stage-2 fault on a translation table walk.
+	 * If the instruction was a cache maintenance instruction then it is
+	 * quietly skipped, otherwise we exit to userspace for MMIO emulation.
+	 *
+	 * Write faults on IPAs falling within a read-only memslot are reported
+	 * to userspace as MMIO exits. This includes cache maintenance and
+	 * stage-2 faults on translation table walks,
+	 */
+	if (kvm_is_error_hva(hva)) {
 		if (kvm_vcpu_trap_is_iabt(vcpu)) {
-			/* Prefetch Abort on I/O address */
 			ret = -ENOEXEC;
 			goto out;
 		}
@@ -2129,30 +2150,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			goto out;
 		}
 
-		/*
-		 * Check for a cache maintenance operation. Since we
-		 * ended-up here, we know it is outside of any memory
-		 * slot. But we can't find out if that is for a device,
-		 * or if the guest is just being stupid. The only thing
-		 * we know for sure is that this range cannot be cached.
-		 *
-		 * So let's assume that the guest is just being
-		 * cautious, and skip the instruction.
-		 */
 		if (kvm_vcpu_dabt_is_cm(vcpu)) {
 			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 			ret = 1;
 			goto out_unlock;
 		}
 
-		/*
-		 * The IPA is reported as [MAX:12], so we need to
-		 * complement it with the bottom 12 bits from the
-		 * faulting VA. This is always 12 bits, irrespective
-		 * of the page size.
-		 */
-		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
-
 		/*
 		 * No valid syndrome? Ask userspace for help if it has
 		 * volunteered to do so, and bail out otherwise.
@@ -2161,7 +2164,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			ret = handle_error_invalid_dabt(vcpu, run, fault_ipa);
 			goto out_unlock;
 		}
+	}
 
+	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
 		ret = io_mem_abort(vcpu, run, fault_ipa);
 		goto out_unlock;
 	}
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

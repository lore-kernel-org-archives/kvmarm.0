Return-Path: <SRS0=9qIm=BD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA7FC433F2
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jul 2020 14:35:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6278820767
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jul 2020 14:35:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yiXEFGt7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6278820767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CD114B081;
	Fri, 24 Jul 2020 10:35:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4ckkXlcwB+Xc; Fri, 24 Jul 2020 10:35:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CF74B442;
	Fri, 24 Jul 2020 10:35:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 092054B3B2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2020 10:35:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QmAnx5mQl2RM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2020 10:35:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7C144B4C3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2020 10:35:20 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D071C20674;
 Fri, 24 Jul 2020 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595601320;
 bh=ijOhZAWxzLhleVKNPuhFyU6KwAfe6z3uD2+snheMDy0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=yiXEFGt7N8Cojz24AFxW3Ck5sT84Iy0+U4Uh5quzcZp6eNEg35lqlyEfDLc+j2I7k
 IKFr5SitXOPBrxiF7SE9OD5pD9eqNk+b8NuLTyHpuExHtqDEYnECiSOw/2G12ZIfdC
 5H7DwJzFFyXVRQz2z8+VjsC13MS/P+EN04c1SaFc=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 4/7] KVM: arm64: Remove useless local variable
Date: Fri, 24 Jul 2020 15:35:03 +0100
Message-Id: <20200724143506.17772-5-will@kernel.org>
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

'is_iabt' is used exactly once in kvm_handle_guest_abort(). Remove it,
and inlined its definition instead.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ae17a99243e2..73e62d360a36 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2064,14 +2064,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	phys_addr_t fault_ipa;
 	struct kvm_memory_slot *memslot;
 	unsigned long hva;
-	bool is_iabt, write_fault, writable;
+	bool write_fault, writable;
 	gfn_t gfn;
 	int ret, idx;
 
 	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
 
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
-	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_is_extabt(vcpu)) {
@@ -2105,7 +2104,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
-		if (is_iabt) {
+		if (kvm_vcpu_trap_is_iabt(vcpu)) {
 			/* Prefetch Abort on I/O address */
 			ret = -ENOEXEC;
 			goto out;
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

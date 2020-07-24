Return-Path: <SRS0=9qIm=BD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D875EC433E5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jul 2020 14:35:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54D9C206D8
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jul 2020 14:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTwSG62o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54D9C206D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBD244B4AF;
	Fri, 24 Jul 2020 10:35:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jKCgW95Sm4-t; Fri, 24 Jul 2020 10:35:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 948E74B4BE;
	Fri, 24 Jul 2020 10:35:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C72E4B46F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2020 10:35:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LKFLqVTJiCpc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jul 2020 10:35:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64FA44B4AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jul 2020 10:35:15 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5157D20714;
 Fri, 24 Jul 2020 14:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595601314;
 bh=4LRg3VE6PVsumxNfed/x5MvUvbAKTRm7x3AQ3dM6Qg4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qTwSG62oN3ulpiaV7VULoi7GrB5vYx5E5xCY7JiMyiyzb30N5XwIu7vTD8ZMuAH0d
 366XqaLlIoadq6EhNgruHzbVUEdQ6YdC7fD2gWZrXXlZKOixKxhumcND6ubHwOE+N1
 srXcPf6RyLdsYDOgQKoPnGZ0L62tPtAjHt+vDjQs=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/7] KVM: arm64: Update comment when skipping guest MMIO
 access instruction
Date: Fri, 24 Jul 2020 15:35:00 +0100
Message-Id: <20200724143506.17772-2-will@kernel.org>
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

If a 32-bit guest accesses MMIO using a 16-bit Thumb-2 instruction that
is reported to the hypervisor without a valid syndrom (for example,
because of the addressing mode), then we may hand off the fault to
userspace. When resuming the guest, we unconditionally advance the PC
by 4 bytes, since ESR_EL2.IL is always 1 for data aborts generated without
a valid syndrome. This is a bit rubbish, but it's also difficult to see
how we can fix it without potentially introducing regressions in userspace
MMIO fault handling.

Update the comment when skipping a guest MMIO access instruction so that
this corner case is at least written down.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 4e0366759726..b54ea5aa6c06 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -113,6 +113,13 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	/*
 	 * The MMIO instruction is emulated and should not be re-executed
 	 * in the guest.
+	 *
+	 * Note: If user space handled the emulation because the abort
+	 * symdrome information was not valid (ISV set in the ESR), then
+	 * this will assume that the faulting instruction was 32-bit.
+	 * If the faulting instruction was a 16-bit Thumb instruction,
+	 * then userspace would need to rewind the PC by 2 bytes prior to
+	 * resuming the vCPU (yuck!).
 	 */
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

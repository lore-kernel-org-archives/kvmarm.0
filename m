Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61EDCC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jan 2022 15:58:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 091CC40E64;
	Mon, 24 Jan 2022 10:58:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nFw9Ayww9LRu; Mon, 24 Jan 2022 10:58:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAC664101F;
	Mon, 24 Jan 2022 10:58:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D029440D34
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 10:58:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XNobeunPowtN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 10:58:49 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9168540D2E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 10:58:49 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8B45F614AC;
 Mon, 24 Jan 2022 15:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C6CC340EA;
 Mon, 24 Jan 2022 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643039928;
 bh=j4A8S6gCxgRKrjZaLCTbNJa4YgVQ0srPkXhZXM2j6dQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=uecyQ9lnL/PbSDWA8DcqK4MP0Z4aSuwUB5rgzHflYmXXEiQZ67EQvgFthOwk0Pizp
 0sN1sS8/UNyrmxcLDUhJTR6uKsCS/FsHDrGq4y7tok2Blmd9yIlkmefuvDrhyAFq7S
 5mXwxGyGpjpNySJkZoEuahef+LvldEgKcFf66Ye1tNccYOOi+K89szZR0nQ+gnhpnY
 n/SeY8XdNFm736RDpQoFJdQwWo3+qPUuom2v2+zeRds2wRSv40axnJMAeEz0QiKPBF
 SjpN77/4+g1hctsNb+cw/3opOejgNrQJnI80EZzEAtpUufSHJAdPuK2V8zAKMKA8C9
 8+axyC1anwk0g==
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH v1 1/2] KVM: arm64: Add comments for context flush and sync
 callbacks
Date: Mon, 24 Jan 2022 15:57:19 +0000
Message-Id: <20220124155720.3943374-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220124155720.3943374-1-broonie@kernel.org>
References: <20220124155720.3943374-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1643; h=from:subject;
 bh=j4A8S6gCxgRKrjZaLCTbNJa4YgVQ0srPkXhZXM2j6dQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh7sxedfd8lQYm7wHY3VRv8g114oCsZe8Jae/lFPDU
 IKPTy4mJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe7MXgAKCRAk1otyXVSH0Hj3CA
 CFeqFcWTf1w/VTbgyi6hmjCLesbLAwf/wp+3r6ZDBambZXRtbwuQ+D1J1pxKV2D0gsXT0LDzAK0RUK
 u4qP4JXzJ554E1uTAajYHjmkrx42H8c1KLrNC5/k52gs828IQAGyCf+WgZ8qMXhHLsNymi22ir/jL1
 JCVnHgzJqNdsV6gpA3aIYlmA2bwS/pVC1gjYTTBFEJSeyas+iOlTkZxfL9WoiDnWvpYMh9R3pTNkUe
 Idg2t5DuQ8P/2OTE2rJXYDMAVDSdue/d2l072NQN6Rp9PBMxMt2qSV9z3XqLG2VRVnUmamAtmuCaRv
 Ttam1iX/1DIhfgPi8WM/RbqKCegvZY
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Add a little bit of information on where _ctxflush_fp() and _ctxsync_fp()
are called to help people unfamiliar with the code get up to speed.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 2f48fd362a8c..397fdac75cb1 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -84,6 +84,11 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
 }
 
+/*
+ * Called just before entering the guest once we are no longer
+ * preemptable. Syncs the host's TIF_FOREIGN_FPSTATE with the KVM
+ * mirror of the flag used by the hypervisor.
+ */
 void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
 {
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
@@ -93,10 +98,11 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
 }
 
 /*
- * If the guest FPSIMD state was loaded, update the host's context
- * tracking data mark the CPU FPSIMD regs as dirty and belonging to vcpu
- * so that they will be written back if the kernel clobbers them due to
- * kernel-mode NEON before re-entry into the guest.
+ * Called just after exiting the guest. If the guest FPSIMD state
+ * was loaded, update the host's context tracking data mark the CPU
+ * FPSIMD regs as dirty and belonging to vcpu so that they will be
+ * written back if the kernel clobbers them due to kernel-mode NEON
+ * before re-entry into the guest.
  */
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 {
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

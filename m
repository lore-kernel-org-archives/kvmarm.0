Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B17C43334
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 12:12:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7C904B3BC;
	Thu,  9 Jun 2022 08:12:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 44ozAkVw2uHD; Thu,  9 Jun 2022 08:12:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BA354B3BD;
	Thu,  9 Jun 2022 08:12:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 313574B36E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4wilMv+RdElI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 08:12:33 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20C5F4B374
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id ED65460C34;
 Thu,  9 Jun 2022 12:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203F1C3411B;
 Thu,  9 Jun 2022 12:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654776751;
 bh=ZP2LKc+PqJhpwgOwUSWwHxASOb1EzEUlXbWANnogBiw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=gbKa9PIgEEgAia+jihKaV+0Wfz476xjKqSwKu10ioqCXh4033dEaMFOO9Udwv9U1K
 XBDmdpj7g0S07SzgOLdxpWNRcLUlwrdLeKnXJnAT1c0SpYIvvHWPFvrBLOhSMzyhJU
 SsbVcwZ4KA5Dm2h4wi9m3ZFlBIWYRsNWVSwT05dJIM8epRXEz4gPgWLsdRZoIJn7km
 cEUvLaGIChB6yQTePYU1fLcmUZ6+qCLCdFh+sYTW2/C7WoZovmoveC+tRr8v4amwXH
 miKHD3YqwpPATxVi0DxURYMTWjDmAk0rQI6wYCPtT+rD62fdx716VidMFDC9lCR8/b
 1a61Fasj9wXug==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/6] KVM: arm64: Return error from kvm_arch_init_vm() on
 allocation failure
Date: Thu,  9 Jun 2022 13:12:18 +0100
Message-Id: <20220609121223.2551-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220609121223.2551-1-will@kernel.org>
References: <20220609121223.2551-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
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

If we fail to allocate the 'supported_cpus' cpumask in kvm_arch_init_vm()
then be sure to return -ENOMEM instead of success (0) on the failure
path.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 400bb0fe2745..0da0f06037db 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -150,8 +150,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_free_stage2_pgd;
 
-	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
+		ret = -ENOMEM;
 		goto out_free_stage2_pgd;
+	}
 	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
 
 	kvm_vgic_early_init(kvm);
-- 
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

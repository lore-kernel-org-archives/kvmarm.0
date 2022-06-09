Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD7BC43334
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 12:12:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 262DE4B35E;
	Thu,  9 Jun 2022 08:12:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ltfxYPAwWqlp; Thu,  9 Jun 2022 08:12:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B682B4B383;
	Thu,  9 Jun 2022 08:12:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 856AF4B383
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gRvJarCY8XzF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 08:12:37 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A8EA4B298
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:37 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6980FB82D52;
 Thu,  9 Jun 2022 12:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD85C341C0;
 Thu,  9 Jun 2022 12:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654776755;
 bh=Mbdzwq+/LSDhpTjAr+4Im28oBh5q/AlLTEBka/3LM4M=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=I8YFNZU5ljPunq4/7iQewiGaxXNSBDeb41QAi5HBCpirWUELTNHwjvbXczz4649DS
 eHoJ1HkGSm3LdzAGw3Tp0pi9pOQZvI/0PJ22ad7svKf5mj3ExNiZPdBFvWyUKpkn1J
 ZuqRZRputXWqDysLVTxjUEX32xIetduM61YV0dWFRtYtc6I1Sh3kF232U10BtE8ekc
 dKh22ImSklI7NekFN5ob/O1bb04RszCwPbGbhZoyWqCiGoA3VuKh6ZjBeeGyT9S7EJ
 DPnbaN5rC5Oc7P/fkgVKrz3L9quoeNcgBg4jdsq7XbXcXgvR9zIcWJP8lZFR56hGsg
 am0Zh8ff5aczw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/6] KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
Date: Thu,  9 Jun 2022 13:12:20 +0100
Message-Id: <20220609121223.2551-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220609121223.2551-1-will@kernel.org>
References: <20220609121223.2551-1-will@kernel.org>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

Ignore 'kvm-arm.mode=protected' when using VHE so that kvm_get_mode()
only returns KVM_MODE_PROTECTED on systems where the feature is available.

Cc: David Brazdil <dbrazdil@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  1 -
 arch/arm64/kernel/cpufeature.c                  | 10 +---------
 arch/arm64/kvm/arm.c                            |  6 +++++-
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 8090130b544b..97c16aa2f53f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2469,7 +2469,6 @@
 
 			protected: nVHE-based mode with support for guests whose
 				   state is kept private from the host.
-				   Not valid if the kernel is running in EL2.
 
 			Defaults to VHE/nVHE based on hardware support. Setting
 			mode to "protected" will disable kexec and hibernation
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 42ea2bd856c6..79fac13ab2ef 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1974,15 +1974,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 #ifdef CONFIG_KVM
 static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
 {
-	if (kvm_get_mode() != KVM_MODE_PROTECTED)
-		return false;
-
-	if (is_kernel_in_hyp_mode()) {
-		pr_warn("Protected KVM not available with VHE\n");
-		return false;
-	}
-
-	return true;
+	return kvm_get_mode() == KVM_MODE_PROTECTED;
 }
 #endif /* CONFIG_KVM */
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0da0f06037db..a0188144a122 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2273,7 +2273,11 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return -EINVAL;
 
 	if (strcmp(arg, "protected") == 0) {
-		kvm_mode = KVM_MODE_PROTECTED;
+		if (!is_kernel_in_hyp_mode())
+			kvm_mode = KVM_MODE_PROTECTED;
+		else
+			pr_warn_once("Protected KVM not available with VHE\n");
+
 		return 0;
 	}
 
-- 
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA73C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:42:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F54B4B33F;
	Thu, 19 May 2022 09:42:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3hDkmMGUomqv; Thu, 19 May 2022 09:42:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2F04B37F;
	Thu, 19 May 2022 09:42:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 790824B35D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8ivaDMl0oFb0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:42:42 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D36444B34B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:41 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 605766179A;
 Thu, 19 May 2022 13:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAEAC34119;
 Thu, 19 May 2022 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967760;
 bh=xcVvqsHLiKii5TVw7ayvStaj1DRy3KpRJuyB7N0Jz0A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ZG/eePp/PWXECZvdHDH7DKHdJxX3dQjXjqg9wbFIsCi3gNfOfwYko+EvXS0zCQ2Px
 tyAWzxciMD+HUEqtyJgqSRCncVZxfcqIWeZWjEJVVdbwsBXkczZs06nVKYJhDOLEzZ
 w6MLdfM48ntbGr+x1yAb+tYilIgmYy6F/mUz1f4qUF/MB2GfoS9OKuv9fRflr28jbF
 kBA1KXBpwM0k9fSsvXcFWOOjSYIr38SVym8glE98/4pAQ5/W/chDZryR2ss+sRw1Vd
 j1aKjA3DWMUNHUWCMsm0gsdJcjR+AU57RXUXO8W6bRzJPrQvEhxhNlqRxr8ZGPDSjD
 qbxLUJHBg7DMQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 04/89] KVM: arm64: Ignore 'kvm-arm.mode=protected' when using
 VHE
Date: Thu, 19 May 2022 14:40:39 +0100
Message-Id: <20220519134204.5379-5-will@kernel.org>
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
index 3f1cc5e317ed..63a764ec7fec 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2438,7 +2438,6 @@
 
 			protected: nVHE-based mode with support for guests whose
 				   state is kept private from the host.
-				   Not valid if the kernel is running in EL2.
 
 			Defaults to VHE/nVHE based on hardware support. Setting
 			mode to "protected" will disable kexec and hibernation
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d72c4b4d389c..1bbb7cfc76df 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1925,15 +1925,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
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
index 775b52871b51..7f8731306c2a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2167,7 +2167,11 @@ static int __init early_kvm_mode_cfg(char *arg)
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
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

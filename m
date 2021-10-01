Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE9EC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 17:06:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 218D761AEC
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 17:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 218D761AEC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B304B0BD;
	Fri,  1 Oct 2021 13:06:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PU537bRdIzo7; Fri,  1 Oct 2021 13:06:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD3434B090;
	Fri,  1 Oct 2021 13:06:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E91A14A4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 13:06:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pDLoVTDLCI2M for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 13:06:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEA794057F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 13:06:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9DC9561AD1;
 Fri,  1 Oct 2021 17:06:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mWLz7-00EF74-O9; Fri, 01 Oct 2021 18:06:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] KVM: arm64: Allow KVM to be disabled from the command line
Date: Fri,  1 Oct 2021 18:05:53 +0100
Message-Id: <20211001170553.3062988-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com,
 dbrazdil@google.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com
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

Although KVM can be compiled out of the kernel, it cannot be disabled
at runtime. Allow this possibility by introducing a new mode that
will prevent KVM from initialising.

This is useful in the (limited) circumstances where you don't want
KVM to be available (what is wrong with you?), or when you want
to install another hypervisor instead (good luck with that).

Reviewed-by: David Brazdil <dbrazdil@google.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---

Notes:
    v2: Dropped the id_aa64mmfr1_vh=0 setting so that KVM can be disabled
        and yet stay in VHE mode on platforms that require it.
        I kept the AB/RB's, but please shout if you disagree!

 Documentation/admin-guide/kernel-parameters.txt |  2 ++
 arch/arm64/include/asm/kvm_host.h               |  1 +
 arch/arm64/kvm/arm.c                            | 14 +++++++++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 91ba391f9b32..f268731a3d4d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2365,6 +2365,8 @@
 	kvm-arm.mode=
 			[KVM,ARM] Select one of KVM/arm64's modes of operation.
 
+			none: Forcefully disable KVM.
+
 			nvhe: Standard nVHE-based mode, without support for
 			      protected guests.
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..019490c67976 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -58,6 +58,7 @@
 enum kvm_mode {
 	KVM_MODE_DEFAULT,
 	KVM_MODE_PROTECTED,
+	KVM_MODE_NONE,
 };
 enum kvm_mode kvm_get_mode(void);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..658171231af9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2064,6 +2064,11 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	if (kvm_get_mode() == KVM_MODE_NONE) {
+		kvm_info("KVM disabled from command line\n");
+		return -ENODEV;
+	}
+
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
@@ -2137,8 +2142,15 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return 0;
 	}
 
-	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode()))
+	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
+		kvm_mode = KVM_MODE_DEFAULT;
 		return 0;
+	}
+
+	if (strcmp(arg, "none") == 0) {
+		kvm_mode = KVM_MODE_NONE;
+		return 0;
+	}
 
 	return -EINVAL;
 }
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

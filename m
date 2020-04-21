Return-Path: <SRS0=wisL=6F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04BAC54FCC
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 13:17:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 649E420775
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 13:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="hHZAcmXq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 649E420775
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10D3C4B125;
	Tue, 21 Apr 2020 09:17:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9b-Jp6BuLPvi; Tue, 21 Apr 2020 09:17:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EF6A4B141;
	Tue, 21 Apr 2020 09:17:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CBE54B0EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 09:17:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sml6EcwOdn5e for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2020 09:17:47 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7B484B111
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 09:17:46 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id s11so7470521wru.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 06:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GwRHSPqsMiYANU3XzWhMVwRsLLrwKOGSNFH91Tn39/g=;
 b=hHZAcmXq7Ij8FJ3ajPM9XfcgJL00swJN04wZamvSL8ARH0QemuD7c4lPMhRoyIj056
 y6YtA8kLHNQLFQf8RtfZL6jNJz9pkIOB4oPoSHyAUDWhpwsEGWVvLyXxjjh1EQdO2jYz
 pjD7tdLVQNiPgVWPOfLhRk5Sxk+3y7jsYsxAX5wi2PVXCcHzljGh6q83qsLr7XHv7YuO
 gfhrIJtVyft7zRz4gkOmhEcWhLtAST2TtjTlXz/t74wFPV0wiROOsnU2bsEmwR7tvyvK
 cus/gYQy5s0MF44S0mswfUUpU0Zy1CW1DsjZwHZ9QL6atg07P+UUWl6OAE/W/Zk26jWS
 gHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GwRHSPqsMiYANU3XzWhMVwRsLLrwKOGSNFH91Tn39/g=;
 b=NEjFYT+C05rYsLDlFWXtqaHCz/7xdrFUvFK1dBkf1G7mfW5rKc6YyOO5ltqFM3mCRb
 4zN0jtMKvgRPMbvjGMFBw1ShFixVZMbvAkcdoEXDchphTrBWXMWCeAj/3rkL1qruLlkR
 Q4qf4iYVfuHyxHbP75IQ4mjBABrRsMqtrXuT7dDH6W2LxYA/AT4UCZucwLl2xCMNJUzU
 Bicjfp+pTEQD6z2K71pe9wFC98XmQp84P7RX6xxsvNf/G7BbjMOhRAPSab/NQl/dJG9h
 PQNooL8Bab6HleqOP2ruEgSLhQYDWpUpkC5mOTKy+Nr6X/xjVLeUGlIXtWVfOkIjhxFD
 gtVA==
X-Gm-Message-State: AGi0Pub5ytCsKl6yJosVnuAfg23cOgOYP6pPhdKvSlfYJ3tTXfWCiiKM
 fHXn8DdggMQh7F4x3K/khMNUkj6Iyg==
X-Google-Smtp-Source: APiQypKEN+aAIJArZUo8HSEqZWcnZhhBAERPw0V9ftTNraNZBmucrqC24fj1OeSMtp8NrrnV66u5vA4cpg==
X-Received: by 2002:a5d:544f:: with SMTP id w15mr25884050wrv.77.1587475065906; 
 Tue, 21 Apr 2020 06:17:45 -0700 (PDT)
Date: Tue, 21 Apr 2020 14:17:33 +0100
In-Reply-To: <20200421131734.141766-1-tabba@google.com>
Message-Id: <20200421131734.141766-4-tabba@google.com>
Mime-Version: 1.0
References: <20200421131734.141766-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v4 3/4] KVM: arm64: Change CONFIG_KVM to a menuconfig entry
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, julien.thierry.kdev@gmail.com, 
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu
Cc: will@kernel.org
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

Changing CONFIG_KVM to be a 'menuconfig' entry in Kconfig mean that we
can straightforwardly enumerate optional features, such as the virtual
PMU device as dependent options.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Kconfig | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index d2cf4f099454..f1c1f981482c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -3,7 +3,6 @@
 # KVM configuration
 #
 
-source "virt/kvm/Kconfig"
 source "virt/lib/Kconfig"
 
 menuconfig VIRTUALIZATION
@@ -18,7 +17,7 @@ menuconfig VIRTUALIZATION
 
 if VIRTUALIZATION
 
-config KVM
+menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on OF
 	# for TASKSTATS/TASK_DELAY_ACCT:
@@ -33,7 +32,6 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
-	select KVM_ARM_PMU if HW_PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
@@ -47,13 +45,21 @@ config KVM
 
 	  If unsure, say N.
 
+if KVM
+
+source "virt/kvm/Kconfig"
+
 config KVM_ARM_PMU
-	bool
+	bool "Virtual Performance Monitoring Unit (PMU) support"
+	depends on HW_PERF_EVENTS
+	default y
 	---help---
 	  Adds support for a virtual Performance Monitoring Unit (PMU) in
 	  virtual machines.
 
 config KVM_INDIRECT_VECTORS
-       def_bool KVM && (HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS)
+	def_bool HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS
+
+endif # KVM
 
 endif # VIRTUALIZATION
-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

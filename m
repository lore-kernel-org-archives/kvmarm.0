Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A488FC352BE
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D4CD21D91
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="LvJdt4xd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D4CD21D91
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04F144B169;
	Fri, 17 Apr 2020 09:58:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 34JKW+pT4y5o; Fri, 17 Apr 2020 09:58:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFCC54B1AF;
	Fri, 17 Apr 2020 09:58:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93C034B28D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AqmlPk39X4DK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 09:58:14 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78A144B1AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:14 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id f81so851597wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 06:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tAH4dP3n0b960oSUROayMJLmuvt/xqsz9m5CG7jOidw=;
 b=LvJdt4xdRTGYNB177WOdvPO6dL0DHtKKyX9AnqcRnYN8dSlGa8oVXMVCVEEj6tMVpS
 +bHuwE1tr05+QDVHFjOhNfIGZnvqHiyhr65hQnOaGpQjNoTtErJDmzbNqjJzK3YdYzsU
 MqUFRgYJ/k3W9JACsmzJrQW1oCpXFXBpUdqmYYV8jrkmuevLTx9UCtATyVnG04y+TlzB
 lEVsJUgIqEbY5YXMyzzKpLnAItW2WzHJeET8YIePChObFF7e5aLdapwxDyodHyax7nTO
 M84F2yjMWGphZxof45HDw7SaOLgqAUY2v0kBx0JhG5W5HEnxmXNjkXIV1+HgAMEANDM4
 HZFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tAH4dP3n0b960oSUROayMJLmuvt/xqsz9m5CG7jOidw=;
 b=TEPlXpNe3qm8LptQyzzxC1bepDrmd6QZ4U9mwwp6JSf9bwJ8MPwNpes9LZgpF3ylFG
 xXubcDCG9X2sbV86LDslDhJ9D65Kvraf2rEauUcli2J9qabMN/a8CMZphIv13V8kYOqg
 NyOf1SiIUgLLaKDjhVQuqIdiau6W6VnVN+GfHUaXxUc6zhM1HieF+KKuIGA2K2EoOxfC
 1iycOPwz2L/+pxtOCpq7dzt2RvrfXuwBbQrs0M/OBWsrmD/iEV0UHk6NhoEBftSLYxIG
 dDv6212Cd5zYA67fgIVw/nXZ7KNCVHiFVzbyMZZzlIXC8Uiy/um2ikGn5pBvdCovNWP2
 V2tQ==
X-Gm-Message-State: AGi0Pub9Zb4v5ho0NXI07L/nM7eK77tvwBQtrXv0DQ2SQjBk5QVHp4/6
 6Ry0f+RFFho1sXO42qdLsDV3TkJJYg==
X-Google-Smtp-Source: APiQypKdV4DvptVz8Ul3c4iTqopqAYi8BWfI+hprtYn6dmiCtxTEaIb8AZAOiIK/y+9DpnFnqM8AWf2Sbw==
X-Received: by 2002:adf:f784:: with SMTP id q4mr4073517wrp.102.1587131893561; 
 Fri, 17 Apr 2020 06:58:13 -0700 (PDT)
Date: Fri, 17 Apr 2020 14:58:00 +0100
In-Reply-To: <20200417135801.82871-1-tabba@google.com>
Message-Id: <20200417135801.82871-4-tabba@google.com>
Mime-Version: 1.0
References: <20200417135801.82871-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v2 3/4] KVM: arm64: Change CONFIG_KVM to a menuconfig entry
From: Fuad Tabba <tabba@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, julien.thierry.kdev@gmail.com, 
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

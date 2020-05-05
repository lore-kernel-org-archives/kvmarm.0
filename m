Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF07FC47247
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 15:45:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 732752078C
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 15:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Y/fIOP13"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 732752078C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FD1A4B37A;
	Tue,  5 May 2020 11:45:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PEzQNICvJPjf; Tue,  5 May 2020 11:45:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 199594B381;
	Tue,  5 May 2020 11:45:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5E2F4B26D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 11:45:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yHUVTU6Fqck1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 11:45:29 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D67264B378
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 11:45:29 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id j4so2746003ybj.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2020 08:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dqE6IffYFU7pf+zIPGQezKCRF2s9URP+7zhNyawvk5k=;
 b=Y/fIOP136+X6HdsmuuN3bJcVaD2dOZrn4KGwGQAkStLCWl1hUKlLf0SLxNxsGSjgWP
 i7ZuPuifsHX2O/7J8gGQjU4/qiATPVBGepRwyYQTEr6+fc69FPJrFoyWKECDHRn9WPud
 DOPEzGaXoOak2nj3u3p5hq6EbBEcOmDvjGUBChPUnwvY9jKZfGkTzP7zuUGjbqYfR4tR
 v6iqRhjZZvKWkv8/EYGJgD1m5R6L8R7YTqsjPPAv7EM0eP5/ZTfhINBkUbyiWTzINCge
 DgRmBXD2s9ED8krLmdkSBj0rOKSOQhkQBrB2LSyOmCWL1tAjxQkyWRUd9Qr6QferKPdR
 RqPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dqE6IffYFU7pf+zIPGQezKCRF2s9URP+7zhNyawvk5k=;
 b=CrPsSh/xx3F++gcGDjfqNnIU03D0WtDkuMYqWfkZr8VEfk+3QfpSUPR7zzZPSgECfR
 /0/2e0cf6Xx5g7fYxD2qjXk58CUXJhUfYSVSw90BMtU0WvQMFd3VWE1zxeZ6DRJF1TvB
 qt/t/stkk+Xf+t38V4Cmmp+DRy2gM7XPRVOxlXRaz7KfH9tpEKWx35QazBKulD2Ks/k+
 SjbVAdplkU88vcUvZBXCWS8VgRvyzL8DeXO4/LFBVeRpvgwMGZ9FX4901WCGBsy/hD+U
 eFvj5lszq67iiECi3dJ9F0Bl+s5voHItUFEthByi7OW1FnN363BjH6ZwoyZfxh089xWI
 ANZw==
X-Gm-Message-State: AGi0PuZsIsYGJpZEZjQQyWfuyEpahS7RrGh2qGtlySeS3GsT83Efmxor
 YZk0eRRV6SJiic/r3iq8cHRtHoQx6w==
X-Google-Smtp-Source: APiQypK3QAy5q7kkYS2U/DXog8ppEVqfhrxBsdQrXpLQiNViagRXPdh/SULez/2C0UhZpleA08UeegYs4A==
X-Received: by 2002:a25:4409:: with SMTP id r9mr5642333yba.469.1588693529293; 
 Tue, 05 May 2020 08:45:29 -0700 (PDT)
Date: Tue,  5 May 2020 16:45:19 +0100
In-Reply-To: <20200505154520.194120-1-tabba@google.com>
Message-Id: <20200505154520.194120-4-tabba@google.com>
Mime-Version: 1.0
References: <20200505154520.194120-1-tabba@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH v5 3/4] KVM: arm64: Change CONFIG_KVM to a menuconfig entry
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
2.26.2.526.g744177e7f7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

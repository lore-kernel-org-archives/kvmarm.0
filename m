Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F1EC2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 14:08:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85BFC21744
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 14:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="LPWQuH3g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85BFC21744
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E1244B277;
	Fri, 17 Apr 2020 10:08:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DY81cdsOFY3C; Fri, 17 Apr 2020 10:08:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FA924B1FC;
	Fri, 17 Apr 2020 10:08:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F27754B211
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 10:08:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3FXrQc7eGt+m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 10:08:35 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A497B4B1FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 10:08:34 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id h6so1017242wmi.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 07:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GwRHSPqsMiYANU3XzWhMVwRsLLrwKOGSNFH91Tn39/g=;
 b=LPWQuH3g5ZxJNT2q8uWcFmMn8X9UUZip6F5NQH4nbbCoAUeWeuJd8k2YRucFAc+zD9
 r43hREJfC09Ju3xr+yEvg+IrPl18+QIp5EFJJx+5TdzsZP29fNOb2dDRa6jiFr3XCaW4
 /vPDaM+ASJ/nxPbA9bd1Kdn4Iaq3PGfnigorJ8ReOd0V30fFCnujca15/2OTHckghEZ5
 mlnBRVpjh4lmPX1X7rP1gKP8uO8U7r1/s1BTa3yjFuon1jSHazRhaLI18bsFukqOst8L
 XKTGbHCqwf/vKng/u/7dyYkYyvEwcwdNTdtwKoKXVFgwptfbfqIF85Zgyv2fVg+fIpna
 eREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GwRHSPqsMiYANU3XzWhMVwRsLLrwKOGSNFH91Tn39/g=;
 b=IbD5BFwy6k/TNwosm8yeVuF08gTcregiqLZvXmbr+tkXUDxI3hMI3naQZkf3y20Vov
 22izABj8Ds7YHftUrT4T/hcNwzEIfiF0pJQhCVLxlAcmoifliLA9V5wDJeohiDyxtUER
 mCrK36iJIZEmDYsS7U6Nq/lPwtKJjkmK34xZiRZW8v5coK99G1r4ox6OrOwyOpzAzM+S
 SLo5v4hZPxe2CdMAy8e8QgRl5T84mvp4ALG2burlpKGuBI1km4KQ5KaizGOmSW5eaTa7
 JJTM+0pJl7Z6rtR7YC+0Y3biBnWhFb9fboehMpQ+aHMNp6j4ItTHdahxkuyNBPr/iN9U
 suSw==
X-Gm-Message-State: AGi0Pua5X6zlxTBJD/nKBAXOHuBRRxVHZuimAfztwBG1/o993Gv4SH4K
 j5ZCZSsSk+sssHqlNJQL7vJCg26o2Q==
X-Google-Smtp-Source: APiQypKgT0aZhh3K68KR1HgJD08AKLllKmvBwywDz/ErsRqqZbF7iW4Wbk/x04uhJgWbPv9wFe+jbJdJnA==
X-Received: by 2002:a5d:42cf:: with SMTP id t15mr4048312wrr.354.1587132513519; 
 Fri, 17 Apr 2020 07:08:33 -0700 (PDT)
Date: Fri, 17 Apr 2020 15:08:20 +0100
In-Reply-To: <20200417140821.89974-1-tabba@google.com>
Message-Id: <20200417140821.89974-4-tabba@google.com>
Mime-Version: 1.0
References: <20200417140821.89974-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v3 3/4] KVM: arm64: Change CONFIG_KVM to a menuconfig entry
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

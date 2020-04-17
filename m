Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB090C2BB55
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 08:55:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D9FC221EA
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 08:55:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="bEqrSZsI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D9FC221EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4629C4B26F;
	Fri, 17 Apr 2020 04:55:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i-IaCo-+LvZT; Fri, 17 Apr 2020 04:55:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EDA14B1A5;
	Fri, 17 Apr 2020 04:55:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 334394B1CC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 04:55:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZTOYIqJqXszL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 04:55:38 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38B344B277
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 04:55:38 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id o5so678884wmo.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 01:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Lcugy0yoJuBW4xaoSJrd/CgV+5KGJ0+YdzmLt+q+rcI=;
 b=bEqrSZsI1ROv8XlKN8SQqStHzU9VkZRKZiEBEnlIgyDVmpyxM4WaXcR2ZvcidHezcY
 9hANhS+GPpNj+0LwjTD6R7ueTHwLsVvkaVIqlZO7zVm7cATf6WLaKAj+fAWnSmsvFX9o
 Y571JNO9M9VdzrjOyzUpvQqphgA3HSPxteVCCSYOKrV7bxpc7pdbGo+CaCuFyGr5crlO
 wAvTbQYJNY2X7JxaV580iriy5UhGiV7oklOLgokU/5k09MreawLpRmVsorId6ly4X/yQ
 G4TES8DgRHWUezAox191A2mOjL5jyjLMiUvukPGfPgS5wVi23fFosbdw7XoNu3sS8Nv/
 ID9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Lcugy0yoJuBW4xaoSJrd/CgV+5KGJ0+YdzmLt+q+rcI=;
 b=Y+415axil2sGUb9o7+3jXggEPjONzFcyqHPV+xIcYTKHud/8J7HvGLot6IMOr/Wo8a
 vZOfvtoM+kmwku/Q4f59sbAJJ/Owhouk8lhSEUdaPrOMSEs/caiWnUgvoalNAysmm62j
 adWCi9BSHVaBYarM269WRvaGpKLjLxNM9W93DA1adSGhdUuUX/maWZFDqUm5gPYTidpG
 E+lIHtzjNSu0BmDGZFOnysQGn1LRjJ8n5oCu2Zm1u7FvGvdQZj3/W5KdZuSOWRM/LQSJ
 VfZjI3G9Ok+4gUngOfvcmLQGNumpIupHGjzsIDID0tB6TDKd+kC8swgyLm8O3sid1H3B
 G8BA==
X-Gm-Message-State: AGi0PuYg0PcHOjQ4vX9zqD//KiV8rAApMr8dBbY846wsAjYOXiOHYKfX
 v+oMyKm+LjO4tI3yD78zRPSgMIT/fw==
X-Google-Smtp-Source: APiQypJmRahFdMJA9ZuKkNSc7LSl8T0zYIchYvgLwY1V1ZR603N9OUgbb11tWDJcQrR8mpKyjhVMRp+sjg==
X-Received: by 2002:adf:90c6:: with SMTP id i64mr2596383wri.88.1587113737254; 
 Fri, 17 Apr 2020 01:55:37 -0700 (PDT)
Date: Fri, 17 Apr 2020 09:55:21 +0100
In-Reply-To: <20200417085522.150701-1-tabba@google.com>
Message-Id: <20200417085522.150701-4-tabba@google.com>
Mime-Version: 1.0
References: <20200417085522.150701-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH 3/4] KVM: arm64: Change CONFIG_KVM to a menuconfig entry
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
2.26.0.110.g2183baf09c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

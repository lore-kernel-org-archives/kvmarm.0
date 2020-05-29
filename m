Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF89C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:01:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 723FF20C09
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AuiVCoa/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 723FF20C09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C8EA4B2BD;
	Fri, 29 May 2020 12:01:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iMOmPCGvxQ30; Fri, 29 May 2020 12:01:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FDDE4B2B3;
	Fri, 29 May 2020 12:01:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 573264B1F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:01:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6BIAGB5jBXa9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2020 12:01:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29FCE4B287
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:01:45 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5A0DC20897;
 Fri, 29 May 2020 16:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590768104;
 bh=3zbLS5pfeT524Z366MfRgPxFm3lGCKRMk/h96+hQyQk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=AuiVCoa/JCwDK4OTj6nj5AdD4sYjXgfoTlMp/jxJRG46GYpBqx9qtTgirmWkm3v8J
 YUJIJO8tMdmkqHL02EfD47MwDNRZmY3b5O6MH+N+N3UFxN3c3yN6kan3VWXdUQ3XSf
 LDLs7YnYvLHDRpq94bOM7MVVxjCU04j0hTleQe7M=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jehS2-00GJKc-OQ; Fri, 29 May 2020 17:01:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 04/24] KVM: arm64: Change CONFIG_KVM to a menuconfig entry
Date: Fri, 29 May 2020 17:01:01 +0100
Message-Id: <20200529160121.899083-5-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com,
 dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com,
 zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Jiang Yi <giangyi@amazon.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200505154520.194120-4-tabba@google.com
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
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

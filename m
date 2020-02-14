Return-Path: <SRS0=Bd71=4C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7CFC3B1BE
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 18:36:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 905E9222C2
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 18:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tdi7bz73"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 905E9222C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06FF34ACB7;
	Fri, 14 Feb 2020 13:36:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uG3--lSYlh3c; Fri, 14 Feb 2020 13:36:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BADE4AEAB;
	Fri, 14 Feb 2020 13:36:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F7374ACB7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 13:36:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qLp1s29lWQKL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Feb 2020 13:36:31 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64EE84AE9D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 13:36:31 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8BF3222314;
 Fri, 14 Feb 2020 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581705390;
 bh=5r08mBYS8Hs6Uwk0S9akLYX+TgV0QH11etUSJUNAJAg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tdi7bz73Nc2KbtvatmMJF6UVTvU1CDl+8gSh7qXOSUWOpcb1Xwwby3lsNEkIh3xaT
 goU3x/4YreWeMF6slHpFG57QGHydxBcLVF7Hw3teuPXowr+CtLZXcdIDYv2oFOmNAN
 FU45ndjeubj1JZCuasgIUUa1ylQRp59xiOIOsvVg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j2fpE-005J5c-Uf; Fri, 14 Feb 2020 18:36:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: Document PMU filtering API
Date: Fri, 14 Feb 2020 18:36:15 +0000
Message-Id: <20200214183615.25498-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214183615.25498-1-maz@kernel.org>
References: <20200214183615.25498-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

Add a small blurb describing how the event filtering API gets used.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/devices/vcpu.txt | 28 +++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.txt b/Documentation/virt/kvm/devices/vcpu.txt
index 6f3bd64a05b0..76902e6bbc05 100644
--- a/Documentation/virt/kvm/devices/vcpu.txt
+++ b/Documentation/virt/kvm/devices/vcpu.txt
@@ -36,6 +36,34 @@ Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
 virtual GIC implementation, this must be done after initializing the in-kernel
 irqchip.
 
+1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
+Parameters: in kvm_device_attr.addr the address for a PMU event filter is a
+            pointer to a struct kvm_pmu_event_filter
+Returns: -ENODEV: PMUv3 not supported or GIC not initialized
+         -ENXIO: PMUv3 not properly configured or in-kernel irqchip not
+                 configured as required prior to calling this attribute
+         -EBUSY: PMUv3 already initialized
+
+Request the installation of a PMU event filter describe as follows:
+
+struct kvm_pmu_event_filter {
+	__u16	base_event;
+	__u16	nevents;
+
+#define KVM_PMU_EVENT_ALLOW	0
+#define KVM_PMU_EVENT_DENY	1
+
+	__u8	action;
+	__u8	pad[3];
+};
+
+A filter range is defined as the range [base_event, base_event + nevents[,
+together with an action (KVM_PMU_EVENT_ALLOW or KVM_PMU_EVENT_DENY). The
+first registered range defines the global policy (global ALLOW if the first
+action is DENY, global DENY if the first action is ALLOW). Multiple ranges
+can be programmed, and but fit within the 16bit space defined by the ARMv8.1
+PMU architecture.
+
 
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 Architectures: ARM,ARM64
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

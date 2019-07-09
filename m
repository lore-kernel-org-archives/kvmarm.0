Return-Path: <SRS0=/6PO=VG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AB8C73C42
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jul 2019 12:25:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E258216FD
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jul 2019 12:25:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E258216FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 369264A569;
	Tue,  9 Jul 2019 08:25:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2si1FVakopNh; Tue,  9 Jul 2019 08:25:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E3134A555;
	Tue,  9 Jul 2019 08:25:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 270F84A561
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jul 2019 08:25:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZcihbVpixXlX for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jul 2019 08:25:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD1B34A519
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jul 2019 08:25:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AA0815AB;
 Tue,  9 Jul 2019 05:25:52 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (unknown [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 940AA3F59C;
 Tue,  9 Jul 2019 05:25:50 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 16/18] KVM: doc: Add API documentation on the
 KVM_REG_ARM_WORKAROUNDS register
Date: Tue,  9 Jul 2019 13:25:05 +0100
Message-Id: <20190709122507.214494-17-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709122507.214494-1-marc.zyngier@arm.com>
References: <20190709122507.214494-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>, Steven Price <steven.price@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel@lists.infradead.org
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

From: Andre Przywara <andre.przywara@arm.com>

Add documentation for the newly defined firmware registers to save and
restore any vulnerability mitigation status.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/arm/psci.txt | 31 ++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
index aafdab887b04..559586fc9d37 100644
--- a/Documentation/virtual/kvm/arm/psci.txt
+++ b/Documentation/virtual/kvm/arm/psci.txt
@@ -28,3 +28,34 @@ The following register is defined:
   - Allows any PSCI version implemented by KVM and compatible with
     v0.2 to be set with SET_ONE_REG
   - Affects the whole VM (even if the register view is per-vcpu)
+
+* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+  Holds the state of the firmware support to mitigate CVE-2017-5715, as
+  offered by KVM to the guest via a HVC call. The workaround is described
+  under SMCCC_ARCH_WORKAROUND_1 in [1].
+  Accepted values are:
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL: KVM does not offer
+      firmware support for the workaround. The mitigation status for the
+      guest is unknown.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: The workaround HVC call is
+      available to the guest and required for the mitigation.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED: The workaround HVC call
+      is available to the guest, but it is not needed on this VCPU.
+
+* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+  Holds the state of the firmware support to mitigate CVE-2018-3639, as
+  offered by KVM to the guest via a HVC call. The workaround is described
+  under SMCCC_ARCH_WORKAROUND_2 in [1].
+  Accepted values are:
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL: A workaround is not
+      available. KVM does not offer firmware support for the workaround.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN: The workaround state is
+      unknown. KVM does not offer firmware support for the workaround.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL: The workaround is available,
+      and can be disabled by a vCPU. If
+      KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED is set, it is active for
+      this vCPU.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED: The workaround is
+      always active on this vCPU or it is not needed.
+
+[1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

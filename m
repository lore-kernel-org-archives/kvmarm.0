Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290B5C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:48:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDAE14B4C1;
	Thu, 19 May 2022 09:48:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nf26tgq4hd+j; Thu, 19 May 2022 09:48:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C49C14B4C2;
	Thu, 19 May 2022 09:48:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6504D4B45F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:48:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mfpMDl8Q4fQe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:48:05 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC5A14B3AD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:48:04 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A45E4B8235B;
 Thu, 19 May 2022 13:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DACC36AE3;
 Thu, 19 May 2022 13:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968082;
 bh=/Mo4K/TZgcyHThL34GJtkzmcE7F2fxw8lRcqi2rTW/c=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=lZctvavEBzQ00kZTcii/cmXssJ+6ByUMt0ooYB9x1ORwmzX45NFefcdnDcrDq00F3
 8AUjJ3/5aQHqluBsoZAe2pb/lrKTqMGWEV1HGuQaUq2ta0BAlykMFyaBdVDuRcD4Oy
 UWTk3wBiKP9OguhQsQK1r3WxxQRCcQp7BDFBsDO4pxIhoI4cr0nF2xF67J0ne5r7Cl
 CVqHMqRNqN0zkRVfrQmTEojUH4MWxc6tBUzJ6EKZxn3pEUs8neqIjbPrywBgK2QNFf
 RsJKYFDUThn20OmDAG98aF1azY8/pjt5MOK3eJ6zQD7xU/u1I01BzedjWJU6qbOc1x
 Q6JDZvF3zpbhw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 85/89] KVM: arm64: Document the KVM/arm64-specific calls in
 hypercalls.rst
Date: Thu, 19 May 2022 14:42:00 +0100
Message-Id: <20220519134204.5379-86-will@kernel.org>
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

KVM/arm64 makes use of the SMCCC "Vendor Specific Hypervisor Service
Call Range" to expose KVM-specific hypercalls to guests in a
discoverable and extensible fashion.

Document the existence of this interface and the discovery hypercall.

Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/virt/kvm/arm/hypercalls.rst | 46 +++++++++++++++++++++++
 Documentation/virt/kvm/arm/index.rst      |  1 +
 2 files changed, 47 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
new file mode 100644
index 000000000000..17be111f493f
--- /dev/null
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -0,0 +1,46 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================================
+KVM/arm64-specific hypercalls exposed to guests
+===============================================
+
+This file documents the KVM/arm64-specific hypercalls which may be
+exposed by KVM/arm64 to guest operating systems. These hypercalls are
+issued using the HVC instruction according to version 1.1 of the Arm SMC
+Calling Convention (DEN0028/C):
+
+https://developer.arm.com/docs/den0028/c
+
+All KVM/arm64-specific hypercalls are allocated within the "Vendor
+Specific Hypervisor Service Call" range with a UID of
+``28b46fb6-2ec5-11e9-a9ca-4b564d003a74``. This UID should be queried by the
+guest using the standard "Call UID" function for the service range in
+order to determine that the KVM/arm64-specific hypercalls are available.
+
+``ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID``
+---------------------------------------------
+
+Provides a discovery mechanism for other KVM/arm64 hypercalls.
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Mandatory for the KVM/arm64 UID                             |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC32                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0x86000000                                       |
++---------------------+----------+--------------------------------------------------+
+| Arguments:          | None                                                        |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (uint32) | R0 | Bitmap of available function numbers 0-31   |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint32) | R1 | Bitmap of available function numbers 32-63  |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint32) | R2 | Bitmap of available function numbers 64-95  |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint32) | R3 | Bitmap of available function numbers 96-127 |
++---------------------+----------+----+---------------------------------------------+
+
+``ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID``
+----------------------------------------
+
+See ptp_kvm.rst
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index 78a9b670aafe..b4067da3fcb6 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -8,6 +8,7 @@ ARM
    :maxdepth: 2
 
    hyp-abi
+   hypercalls
    psci
    pvtime
    ptp_kvm
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

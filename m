Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1CDC4332F
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:57:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B67E61213
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B67E61213
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B49E44B2B2;
	Mon,  4 Oct 2021 13:57:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6pnisjenvurP; Mon,  4 Oct 2021 13:57:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BAB54B2AA;
	Mon,  4 Oct 2021 13:57:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 419C44B2A7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:57:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mCQHcQTB3pp2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 13:57:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85E8B4B268
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:57:10 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C6EDE61269;
 Mon,  4 Oct 2021 17:57:09 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mXS5G-00EhBv-MO; Mon, 04 Oct 2021 18:49:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
Date: Mon,  4 Oct 2021 18:48:43 +0100
Message-Id: <20211004174849.2831548-11-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com,
 dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com,
 tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org
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

Document the hypercalls user for the MMIO guard infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/arm/index.rst      |  1 +
 Documentation/virt/kvm/arm/mmio-guard.rst | 74 +++++++++++++++++++++++
 2 files changed, 75 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst

diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index 78a9b670aafe..e77a0ee2e2d4 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -11,3 +11,4 @@ ARM
    psci
    pvtime
    ptp_kvm
+   mmio-guard
diff --git a/Documentation/virt/kvm/arm/mmio-guard.rst b/Documentation/virt/kvm/arm/mmio-guard.rst
new file mode 100644
index 000000000000..8b3c852c5d92
--- /dev/null
+++ b/Documentation/virt/kvm/arm/mmio-guard.rst
@@ -0,0 +1,74 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+KVM MMIO guard
+==============
+
+KVM implements device emulation by handling translation faults to any
+IPA range that is not contained in a memory slot. Such a translation
+fault is in most cases passed on to userspace (or in rare cases to the
+host kernel) with the address, size and possibly data of the access
+for emulation.
+
+Should the guest exit with an address that is not one that corresponds
+to an emulatable device, userspace may take measures that are not the
+most graceful as far as the guest is concerned (such as terminating it
+or delivering a fatal exception).
+
+There is also an element of trust: by forwarding the request to
+userspace, the kernel assumes that the guest trusts userspace to do
+the right thing.
+
+The KVM MMIO guard offers a way to mitigate this last point: a guest
+can request that only certain regions of the IPA space are valid as
+MMIO. Only these regions will be handled as an MMIO, and any other
+will result in an exception being delivered to the guest.
+
+This relies on a set of hypercalls defined in the KVM-specific range,
+using the HVC64 calling convention.
+
+* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO
+
+    ==============    ========    ================================
+    Function ID:      (uint32)    0xC6000002
+    Arguments:        none
+    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
+                      (uint64)    Protection Granule (PG) size in
+                                  bytes (r0)
+    ==============    ========    ================================
+
+* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL
+
+    ==============    ========    ==============================
+    Function ID:      (uint32)    0xC6000003
+    Arguments:        none
+    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
+                                  RET_SUCCESS(0) (r0)
+    ==============    ========    ==============================
+
+* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP
+
+    ==============    ========    ====================================
+    Function ID:      (uint32)    0xC6000004
+    Arguments:        (uint64)    The base of the PG-sized IPA range
+                                  that is allowed to be accessed as
+                                  MMIO. Must be aligned to the PG size
+                                  (r1)
+                      (uint64)    Index in the MAIR_EL1 register
+		                  providing the memory attribute that
+				  is used by the guest (r2)
+    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
+                                  RET_SUCCESS(0) (r0)
+    ==============    ========    ====================================
+
+* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP
+
+    ==============    ========    ======================================
+    Function ID:      (uint32)    0xC6000005
+    Arguments:        (uint64)    PG-sized IPA range aligned to the PG
+                                  size which has been previously mapped.
+                                  Must be aligned to the PG size and
+                                  have been previously mapped (r1)
+    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
+                                  RET_SUCCESS(0) (r0)
+    ==============    ========    ======================================
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

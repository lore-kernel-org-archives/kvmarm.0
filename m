Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EABC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:15:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E76760551
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 16:15:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4E76760551
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7AE84B129;
	Fri, 15 Oct 2021 12:15:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UmoGtlcdOG2E; Fri, 15 Oct 2021 12:15:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79C5D4B15C;
	Fri, 15 Oct 2021 12:15:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6826C4B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:15:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UFPfQw+AmiEJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 12:14:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 574AA4B174
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 12:14:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0879311D4;
 Fri, 15 Oct 2021 09:14:58 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C93B3F66F;
 Fri, 15 Oct 2021 09:14:57 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 7/7] Documentation: arm64: Describe the support and
 expectations for PBHA
Date: Fri, 15 Oct 2021 16:14:16 +0000
Message-Id: <20211015161416.2196-8-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211015161416.2196-1-james.morse@arm.com>
References: <20211015161416.2196-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
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

PBHA isn't defined by the Arm CPU architecture, so may have surprising
side-effects.

Document what is, and what is not supported. List the arch code's
expectations regarding how PBHA behaves.

Signed-off-by: James Morse <james.morse@arm.com>
---
 Documentation/arm64/index.rst |  1 +
 Documentation/arm64/pbha.rst  | 86 +++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)
 create mode 100644 Documentation/arm64/pbha.rst

diff --git a/Documentation/arm64/index.rst b/Documentation/arm64/index.rst
index 4f840bac083e..88fdfda86632 100644
--- a/Documentation/arm64/index.rst
+++ b/Documentation/arm64/index.rst
@@ -18,6 +18,7 @@ ARM64 Architecture
     legacy_instructions
     memory
     memory-tagging-extension
+    pbha
     perf
     pointer-authentication
     silicon-errata
diff --git a/Documentation/arm64/pbha.rst b/Documentation/arm64/pbha.rst
new file mode 100644
index 000000000000..0ba50a0df05f
--- /dev/null
+++ b/Documentation/arm64/pbha.rst
@@ -0,0 +1,86 @@
+=======================================================
+Page Based Hardware Attribute support for AArch64 Linux
+=======================================================
+
+Page Based Hardware Attributes (PBHA) allow the OS to trigger IMPLEMENTATION
+DEFINED behaviour associated with a memory access. For example, this may be
+taken as a hint to a System Cache whether it should cache the location that
+has been accessed.
+
+PBHA consists of four bits in the leaf page table entries for a virtual
+address, that are sent with any memory access via that virtual address.
+
+IMPLEMENTATION DEFINED behaviour is not specified by the arm-arm, meaning
+it varies between SoCs. There may be unexpected side effects when PBHA
+bits are used or combined.
+For example, a PBHA bit may be taken as a hint to the Memory Controller that
+it should encrypt/decrypt the memory in DRAM. If the CPU has multiple virtual
+aliases of the address, accesses that are made without this PBHA bit set may
+cause corruption.
+
+
+Use by virtual machines using KVM
+---------------------------------
+
+KVM allows an OS in a virtual machine to configure its own page tables. A
+virtual machine can also configure PBHA bits in its page tables. To prevent
+side effects that could affect the hypervisor, KVM will only allow
+combinations of PBHA bits that only affect performance. Values that cause
+changes to the data are forbidden as the Hypervisor and VMM have aliases of
+the guest memory, and may swap it to/from disk.
+
+The list of bits to allow is built from the firmware list of PBHA bit
+combinations that only affect performance. Because the guest can choose
+not to set all the bits in a value, (e.g. allowing 5 implicitly allows 1
+and 4), the values supported may differ between a host and guest.
+
+PBHA is only supported for a guest if KVM supports the mechanism the CPU uses
+to combine the values from stage1 and stage2 translation. The mechanism is not
+advertised, so which mechanism each CPU uses must also be known by the kernel.
+
+
+Use by device drivers
+---------------------
+
+Device drivers should discover the PBHA value to use for a mapping from the
+device's firmware description as these will vary between SoCs. If the value
+is also listed by firmware as only affecting performance, it can be added to
+the pgprot with pgprot_pbha().
+
+Values that require all other aliases to be removed are not supported.
+
+
+Linux's expectations around PBHA
+--------------------------------
+
+'IMPLEMENTATION DEFINED' describes a huge range of possible behaviours.
+Linux expects PBHA to behave in the same way as the read/write allocate hints
+for a memory type. Below is an incomplete list of expectations:
+
+ * PBHA values have the same meaning for all CPUs in the SoC.
+ * Use of the PBHA value does not cause mismatched type, shareability or
+   cacheability, it does not take precedence over the stage2 attributes, or
+   HCR_EL2 controls.
+ * If a PBHA value requires all other aliases to be removed, higher exception
+   levels do not have a concurrent alias. (This includes Secure World).
+ * Break before make is sufficient when changing the PBHA value.
+ * PBHA values used by a page can be changed independently without further side
+   effects.
+ * Save/restoring the page contents via a PBHA=0 mapping does not corrupt the
+   values once a non-zero PBHA mapping is re-created.
+ * The hypervisor may clean+invalidate to the PoC via a PBHA=0 mapping prior to
+   save/restore to cleanup mismatched attributes. This does not corrupt the
+   values after save/restore once a non-zero PBHA mapping is re-created.
+ * Cache maintenance via a PBHA=0 mapping to prevent stale data being visible
+   when mismatched attributes occur is sufficient even if the subsequent
+   mapping has a non-zero PBHA value.
+ * The OS/hypervisor can clean-up a page by removing all non-zero PBHA mappings,
+   then writing new data via PBHA=0 mapping of the same type, shareability and
+   cacheability. After this, only the new data is visible for data accesses.
+ * For instruction-fetch, the same maintenance as would be performed against a
+   PBHA=0 page is sufficient. (which with DIC+IDC, may be none at all).
+ * The behaviour enabled by PBHA should not depend on the size of the access, or
+   whether other SoC hardware under the control of the OS is enabled and
+   configured.
+ * EL2 is able to at least force stage1 PBHA bits to zero.
+
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

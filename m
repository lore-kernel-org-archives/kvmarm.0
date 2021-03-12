Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A201C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:19:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CEBAC64FEE
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEBAC64FEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E8574B579;
	Fri, 12 Mar 2021 10:19:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZshjrUZqGan6; Fri, 12 Mar 2021 10:19:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41BAA4B544;
	Fri, 12 Mar 2021 10:19:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3F384B3BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:19:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PzLSJibMjKCM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 10:19:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 875EA4B53C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:19:30 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C1531FB;
 Fri, 12 Mar 2021 07:19:30 -0800 (PST)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56CCE3F7D7;
 Fri, 12 Mar 2021 07:19:27 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v10 6/6] KVM: arm64: Document MTE capability and ioctl
Date: Fri, 12 Mar 2021 15:19:02 +0000
Message-Id: <20210312151902.17853-7-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210312151902.17853-1-steven.price@arm.com>
References: <20210312151902.17853-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

A new capability (KVM_CAP_ARM_MTE) identifies that the kernel supports
granting a guest access to the tags, and provides a mechanism for the
VMM to enable it.

A new ioctl (KVM_ARM_MTE_COPY_TAGS) provides a simple way for a VMM to
access the tags of a guest without having to maintain a PROT_MTE mapping
in userspace. The above capability gates access to the ioctl.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 Documentation/virt/kvm/api.rst | 53 ++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1a2b5210cdbf..ccc84f21ba5e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4938,6 +4938,40 @@ see KVM_XEN_VCPU_SET_ATTR above.
 The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
 with the KVM_XEN_VCPU_GET_ATTR ioctl.
 
+4.131 KVM_ARM_MTE_COPY_TAGS
+---------------------------
+
+:Capability: KVM_CAP_ARM_MTE
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct kvm_arm_copy_mte_tags
+:Returns: 0 on success, < 0 on error
+
+::
+
+  struct kvm_arm_copy_mte_tags {
+	__u64 guest_ipa;
+	__u64 length;
+	union {
+		void __user *addr;
+		__u64 padding;
+	};
+	__u64 flags;
+	__u64 reserved[2];
+  };
+
+Copies Memory Tagging Extension (MTE) tags to/from guest tag memory. The
+``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned. The ``addr``
+fieldmust point to a buffer which the tags will be copied to or from.
+
+``flags`` specifies the direction of copy, either ``KVM_ARM_TAGS_TO_GUEST`` or
+``KVM_ARM_TAGS_FROM_GUEST``.
+
+The size of the buffer to store the tags is ``(length / MTE_GRANULE_SIZE)``
+bytes (i.e. 1/16th of the corresponding size). Each byte contains a single tag
+value. This matches the format of ``PTRACE_PEEKMTETAGS`` and
+``PTRACE_POKEMTETAGS``.
+
 5. The kvm_run structure
 ========================
 
@@ -6227,6 +6261,25 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
 This capability can be used to check / enable 2nd DAWR feature provided
 by POWER10 processor.
 
+7.23 KVM_CAP_ARM_MTE
+--------------------
+
+:Architectures: arm64
+:Parameters: none
+
+This capability indicates that KVM (and the hardware) supports exposing the
+Memory Tagging Extensions (MTE) to the guest. It must also be enabled by the
+VMM before the guest will be granted access.
+
+When enabled the guest is able to access tags associated with any memory given
+to the guest. KVM will ensure that the pages are flagged ``PG_mte_tagged`` so
+that the tags are maintained during swap or hibernation of the host; however
+the VMM needs to manually save/restore the tags as appropriate if the VM is
+migrated.
+
+When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
+perform a bulk copy of tags to/from the guest.
+
 8. Other capabilities.
 ======================
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=eGRX=V6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFF0C433FF
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 14:50:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50388216C8
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 14:50:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50388216C8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00ABC4A536;
	Fri,  2 Aug 2019 10:50:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V8fQQlPm4X8U; Fri,  2 Aug 2019 10:50:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7900E4A546;
	Fri,  2 Aug 2019 10:50:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF0D64A540
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 10:50:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rqx7XNyOTdWc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Aug 2019 10:50:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B5A74A4FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 10:50:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5E831597;
 Fri,  2 Aug 2019 07:50:31 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com
 [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B7773F575;
 Fri,  2 Aug 2019 07:50:29 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: 
Subject: [PATCH 1/9] KVM: arm64: Document PV-time interface
Date: Fri,  2 Aug 2019 15:50:09 +0100
Message-Id: <20190802145017.42543-2-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802145017.42543-1-steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Introduce a paravirtualization interface for KVM/arm64 based on the
"Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.

This only adds the details about "Stolen Time" as the details of "Live
Physical Time" have not been fully agreed.

User space can specify a reserved area of memory for the guest and
inform KVM to populate the memory with information on time that the host
kernel has stolen from the guest.

A hypercall interface is provided for the guest to interrogate the
hypervisor's support for this interface and the location of the shared
memory structures.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 Documentation/virtual/kvm/arm/pvtime.txt | 107 +++++++++++++++++++++++
 1 file changed, 107 insertions(+)
 create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt

diff --git a/Documentation/virtual/kvm/arm/pvtime.txt b/Documentation/virtual/kvm/arm/pvtime.txt
new file mode 100644
index 000000000000..e6ae9799e1d5
--- /dev/null
+++ b/Documentation/virtual/kvm/arm/pvtime.txt
@@ -0,0 +1,107 @@
+Paravirtualized time support for arm64
+======================================
+
+Arm specification DEN0057/A defined a standard for paravirtualised time
+support for Aarch64 guests:
+
+https://developer.arm.com/docs/den0057/a
+
+KVM/Arm64 implements the stolen time part of this specification by providing
+some hypervisor service calls to support a paravirtualized guest obtaining a
+view of the amount of time stolen from its execution.
+
+Two new SMCCC compatible hypercalls are defined:
+
+PV_FEATURES 0xC5000020
+PV_TIME_ST  0xC5000022
+
+These are only available in the SMC64/HVC64 calling convention as
+paravirtualized time is not available to 32 bit Arm guests.
+
+PV_FEATURES
+    Function ID:  (uint32)  : 0xC5000020
+    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
+    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
+                              PV-time feature is supported by the hypervisor.
+
+PV_TIME_ST
+    Function ID:  (uint32)  : 0xC5000022
+    Return value: (int64)   : IPA of the stolen time data structure for this
+                              (V)CPU. On failure:
+                              NOT_SUPPORTED (-1)
+
+Stolen Time
+-----------
+
+The structure pointed to by the PV_TIME_ST hypercall is as follows:
+
+  Field       | Byte Length | Byte Offset | Description
+  ----------- | ----------- | ----------- | --------------------------
+  Revision    |      4      |      0      | Must be 0 for version 0.1
+  Attributes  |      4      |      4      | Must be 0
+  Stolen time |      8      |      8      | Stolen time in unsigned
+              |             |             | nanoseconds indicating how
+              |             |             | much time this VCPU thread
+              |             |             | was involuntarily not
+              |             |             | running on a physical CPU.
+
+The structure will be updated by the hypervisor periodically as time is stolen
+from the VCPU. It will be present within a reserved region of the normal
+memory given to the guest. The guest should not attempt to write into this
+memory. There is a structure by VCPU of the guest.
+
+User space interface
+====================
+
+User space can request that KVM provide the paravirtualized time interface to
+a guest by creating a KVM_DEV_TYPE_ARM_PV_TIME device, for example:
+
+    struct kvm_create_device pvtime_device = {
+            .type = KVM_DEV_TYPE_ARM_PV_TIME,
+            .attr = 0,
+            .flags = 0,
+    };
+
+    pvtime_fd = ioctl(vm_fd, KVM_CREATE_DEVICE, &pvtime_device);
+
+The guest IPA of the structures must be given to KVM. This is the base address
+of an array of stolen time structures (one for each VCPU). For example:
+
+    struct kvm_device_attr st_base = {
+            .group = KVM_DEV_ARM_PV_TIME_PADDR,
+            .attr = KVM_DEV_ARM_PV_TIME_ST,
+            .addr = (u64)(unsigned long)&st_paddr
+    };
+
+    ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &st_base);
+
+For migration (or save/restore) of a guest it is necessary to save the contents
+of the shared page(s) and later restore them. KVM_DEV_ARM_PV_TIME_STATE_SIZE
+provides the size of this data and KVM_DEV_ARM_PV_TIME_STATE allows the state
+to be read/written.
+
+It is also necessary for the physical address to be set identically when
+restoring.
+
+    void *save_state(int fd, u64 attr, u32 *size) {
+        struct kvm_device_attr get_size = {
+                .group = KVM_DEV_ARM_PV_TIME_STATE_SIZE,
+                .attr = attr,
+                .addr = (u64)(unsigned long)size
+        };
+
+        ioctl(fd, KVM_GET_DEVICE_ATTR, get_size);
+
+        void *buffer = malloc(*size);
+
+        struct kvm_device_attr get_state = {
+                .group = KVM_DEV_ARM_PV_TIME_STATE,
+                .attr = attr,
+                .addr = (u64)(unsigned long)size
+        };
+
+        ioctl(fd, KVM_GET_DEVICE_ATTR, buffer);
+    }
+
+    void *st_state = save_state(pvtime_fd, KVM_DEV_ARM_PV_TIME_ST, &st_size);
+
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

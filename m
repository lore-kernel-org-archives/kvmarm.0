Return-Path: <SRS0=3oJT=2Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8944DC2D0DA
	for <kvmarm@archiver.kernel.org>; Thu, 26 Dec 2019 13:59:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 427D8222D9
	for <kvmarm@archiver.kernel.org>; Thu, 26 Dec 2019 13:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 427D8222D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC56B4AE95;
	Thu, 26 Dec 2019 08:59:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wn+pcRLtGk3H; Thu, 26 Dec 2019 08:59:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F4844ACC9;
	Thu, 26 Dec 2019 08:59:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A6FA4AC80
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Dec 2019 08:59:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id whyPSqqK5SNU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Dec 2019 08:59:06 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 764464AC84
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Dec 2019 08:59:05 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 6E72A2A2BBC19AC3737B;
 Thu, 26 Dec 2019 21:59:02 +0800 (CST)
Received: from DESKTOP-1NISPDV.china.huawei.com (10.173.221.248) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 26 Dec 2019 21:58:52 +0800
From: Zengruan Ye <yezengruan@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v2 1/6] KVM: arm64: Document PV-lock interface
Date: Thu, 26 Dec 2019 21:58:28 +0800
Message-ID: <20191226135833.1052-2-yezengruan@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20191226135833.1052-1-yezengruan@huawei.com>
References: <20191226135833.1052-1-yezengruan@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.221.248]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, daniel.lezcano@linaro.org, linux@armlinux.org.uk,
 steven.price@arm.com, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org
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

Introduce a paravirtualization interface for KVM/arm64 to obtain the VCPU
is currently running or not.

The PV lock structure of the guest is allocated by user space.

A hypercall interface is provided for the guest to interrogate the
hypervisor's support for this interface and the location of the shared
memory structures.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
---
 Documentation/virt/kvm/arm/pvlock.rst   | 63 +++++++++++++++++++++++++
 Documentation/virt/kvm/devices/vcpu.txt | 14 ++++++
 2 files changed, 77 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/pvlock.rst

diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
new file mode 100644
index 000000000000..58b3b8ee7537
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pvlock.rst
@@ -0,0 +1,63 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Paravirtualized lock support for arm64
+======================================
+
+KVM/arm64 provides some hypervisor service calls to support a paravirtualized
+guest obtaining the VCPU is currently running or not.
+
+Two new SMCCC compatible hypercalls are defined:
+
+* PV_LOCK_FEATURES:   0xC6000020
+* PV_LOCK_PREEMPTED:  0xC6000021
+
+The existence of the PV_LOCK hypercall should be probed using the SMCCC 1.1
+ARCH_FEATURES mechanism before calling it.
+
+PV_LOCK_FEATURES
+    ============= ========    ==========
+    Function ID:  (uint32)    0xC6000020
+    PV_call_id:   (uint32)    The function to query for support.
+    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
+                              PV-lock feature is supported by the hypervisor.
+    ============= ========    ==========
+
+PV_LOCK_PREEMPTED
+    ============= ========    ==========
+    Function ID:  (uint32)    0xC6000021
+    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the IPA of
+                              this VCPU's pv data structure is configured by
+                              the hypervisor.
+    ============= ========    ==========
+
+The IPA returned by PV_LOCK_PREEMPTED should be mapped by the guest as normal
+memory with inner and outer write back caching attributes, in the inner
+shareable domain.
+
+PV_LOCK_PREEMPTED returns the structure for the calling VCPU.
+
+PV lock state
+-------------
+
+The structure pointed to by the PV_LOCK_PREEMPTED hypercall is as follows:
+
++-----------+-------------+-------------+---------------------------------+
+| Field     | Byte Length | Byte Offset | Description                     |
++===========+=============+=============+=================================+
+| preempted |      8      |      0      | Indicate the VCPU who owns this |
+|           |             |             | struct is running or not.       |
+|           |             |             | Non-zero values mean the VCPU   |
+|           |             |             | has been preempted. Zero means  |
+|           |             |             | the VCPU is not preempted.      |
++-----------+-------------+-------------+---------------------------------+
+
+The preempted field will be updated to 1 by the hypervisor prior to scheduling
+a VCPU. When the VCPU is scheduled out, the preempted field will be updated
+to 0 by the hypervisor.
+
+The structure will be present within a reserved region of the normal memory
+given to the guest. The guest should not attempt to write into this memory.
+There is a structure per VCPU of the guest.
+
+For the user space interface see Documentation/virt/kvm/devices/vcpu.txt
+section "4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL".
diff --git a/Documentation/virt/kvm/devices/vcpu.txt b/Documentation/virt/kvm/devices/vcpu.txt
index 6f3bd64a05b0..c10a5945075b 100644
--- a/Documentation/virt/kvm/devices/vcpu.txt
+++ b/Documentation/virt/kvm/devices/vcpu.txt
@@ -74,3 +74,17 @@ Specifies the base address of the stolen time structure for this VCPU. The
 base address must be 64 byte aligned and exist within a valid guest memory
 region. See Documentation/virt/kvm/arm/pvtime.txt for more information
 including the layout of the stolen time structure.
+
+4. GROUP: KVM_ARM_VCPU_PVLOCK_CTRL
+Architectures: ARM64
+
+4.1 ATTRIBUTE: KVM_ARM_VCPU_PVLOCK_IPA
+Parameters: 64-bit base address
+Returns: -ENXIO:  PV lock not implemented
+         -EEXIST: Base address already set for this VCPU
+         -EINVAL: Base address not 64 byte aligned
+
+Specifies the base address of the PV lock structure for this VCPU. The
+base address must be 64 byte aligned and exist within a valid guest memory
+region. See Documentation/virt/kvm/arm/pvlock.rst for more information
+including the layout of the pv lock structure.
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

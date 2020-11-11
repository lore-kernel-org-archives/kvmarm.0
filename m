Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12879C56201
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 06:23:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9361020786
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 06:23:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9361020786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 343D14BA3C;
	Wed, 11 Nov 2020 01:23:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6bjWzYt0VL6E; Wed, 11 Nov 2020 01:23:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3F14BA02;
	Wed, 11 Nov 2020 01:23:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5728B4B63F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 01:23:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JqUWA4ROECrr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 01:23:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6AE4B447
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 01:23:31 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B76111480;
 Tue, 10 Nov 2020 22:23:30 -0800 (PST)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com
 [10.169.212.215])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 682B13F6CF;
 Tue, 10 Nov 2020 22:23:24 -0800 (PST)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com,
 steven.price@arm.com
Subject: [PATCH v15 8/9] doc: add ptp_kvm introduction for arm64 support
Date: Wed, 11 Nov 2020 14:22:10 +0800
Message-Id: <20201111062211.33144-9-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201111062211.33144-1-jianyong.wu@arm.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
Cc: justin.he@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

PTP_KVM implementation depends on hypercall using SMCCC. So we
introduce a new SMCCC service ID. This doc explains how does the
ID define and how does PTP_KVM works on arm/arm64.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 Documentation/virt/kvm/api.rst         |  9 +++++++
 Documentation/virt/kvm/arm/index.rst   |  1 +
 Documentation/virt/kvm/arm/ptp_kvm.rst | 29 +++++++++++++++++++++
 Documentation/virt/kvm/timekeeping.rst | 35 ++++++++++++++++++++++++++
 4 files changed, 74 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 36d5f1f3c6dd..9843dbcbf770 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6391,3 +6391,12 @@ When enabled, KVM will disable paravirtual features provided to the
 guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
+
+8.27 KVM_CAP_PTP_KVM
+--------------------
+
+:Architectures: arm64
+
+This capability indicates that KVM virtual PTP service is supported in host.
+It must company with the implementation of KVM virtual PTP service in host
+so VMM can probe if there is the service in host by checking this capability.
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index 3e2b2aba90fc..78a9b670aafe 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -10,3 +10,4 @@ ARM
    hyp-abi
    psci
    pvtime
+   ptp_kvm
diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst b/Documentation/virt/kvm/arm/ptp_kvm.rst
new file mode 100644
index 000000000000..bb1e6cfefe44
--- /dev/null
+++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
@@ -0,0 +1,29 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+PTP_KVM support for arm/arm64
+=============================
+
+PTP_KVM is used for time sync between guest and host in a high precision.
+It needs to get the wall time and counter value from the host and transfer these
+to guest via hypercall service. So one more hypercall service has been added.
+
+This new SMCCC hypercall is defined as:
+
+* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001
+
+As both 32 and 64-bits ptp_kvm client should be supported, we choose SMC32/HVC32
+calling convention.
+
+ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
+
+    =============    ==========    ==========
+    Function ID:     (uint32)      0x86000001
+    Arguments:	     (uint32)      ARM_PTP_PHY_COUNTER(1) or ARM_PTP_VIRT_COUNTER(0)
+                                   which indicate acquiring physical counter or
+                                   virtual counter respectively.
+    return value:    (uint32)      NOT_SUPPORTED(-1) or val0 and val1 represent
+                                   wall clock time and val2 and val3 represent
+                                   counter cycle.
+    =============    ==========    ==========
+
+More info see section 5 in Documentation/virt/kvm/timekeeping.rst.
diff --git a/Documentation/virt/kvm/timekeeping.rst b/Documentation/virt/kvm/timekeeping.rst
index 21ae7efa29ba..c81383e38372 100644
--- a/Documentation/virt/kvm/timekeeping.rst
+++ b/Documentation/virt/kvm/timekeeping.rst
@@ -13,6 +13,7 @@ Timekeeping Virtualization for X86-Based Architectures
    2) Timing Devices
    3) TSC Hardware
    4) Virtualization Problems
+   5) KVM virtual PTP clock
 
 1. Overview
 ===========
@@ -643,3 +644,37 @@ by using CPU utilization itself as a signalling channel.  Preventing such
 problems would require completely isolated virtual time which may not track
 real time any longer.  This may be useful in certain security or QA contexts,
 but in general isn't recommended for real-world deployment scenarios.
+
+5. KVM virtual PTP clock
+========================
+
+NTP (Network Time Protocol) is often used to sync time in a VM. Unfortunately,
+the precision of NTP is limited due to unknown delays in the network.
+
+KVM virtual PTP clock (PTP_KVM) offers another way to sync time in VM; use the
+host's clock rather than one from a remote machine. Having a synchronization
+mechanism for the virtualization environment allows us to keep all the guests
+running on the same host in sync.
+In general, the delay of communication between host and guest is quite
+small, so ptp_kvm can offer time sync precision up to in order of nanoseconds.
+Please keep in mind that ptp_kvm just limits itself to be a channel which
+transmits the remote clock from host to guest. An application, eg. chrony, is
+needed in usersapce of VM in order to set the guest time.
+
+After ptp_kvm is initialized, there will be a new device node under /dev called
+ptp%d. A guest userspace service, like chrony, can use this device to get host
+walltime, sometimes also counter cycle, which depends on the service it calls.
+Then this guest userspace service can use those data to do the time sync for
+the guest.
+The following is the work flow of ptp_kvm:
+
+a) time sync service in guest userspace call ioctl on ptp device /dev/ptp%d.
+b) ptp_kvm module in guest receives this request then invokes hypercall to
+   route into host kernel to request host's walltime/counter cycle.
+c) ptp_kvm hypercall service on the host responds to the request and sends data
+   back.
+d) ptp in guest copies the data to userspace.
+
+ptp_kvm consists of components running on the guest and host. Step 2 consists of
+a guest driver making a hypercall whilst step 3 involves the hypervisor responding
+with information.
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

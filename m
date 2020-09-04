Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6972C28E83
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 09:29:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F06420791
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 09:29:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F06420791
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 387E84B2A0;
	Fri,  4 Sep 2020 05:29:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 44R7PNzJHnf9; Fri,  4 Sep 2020 05:29:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9D3E4B17A;
	Fri,  4 Sep 2020 05:29:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 901EC4B37A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 05:29:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CG7n7LC6C19t for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 05:29:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 526AD4B36D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 05:29:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06945152D;
 Fri,  4 Sep 2020 02:29:54 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com
 [10.169.212.215])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 545743F66F;
 Fri,  4 Sep 2020 02:29:48 -0700 (PDT)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, steven.price@arm.com
Subject: [PATCH v14 09/10] doc: add ptp_kvm introduction for arm64 support
Date: Fri,  4 Sep 2020 17:27:43 +0800
Message-Id: <20200904092744.167655-10-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904092744.167655-1-jianyong.wu@arm.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
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

ptp_kvm implementation depends on hypercall using SMCCC. So we
introduce a new SMCCC service ID. This doc explain how we define
and use this new ID.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 Documentation/virt/kvm/arm/ptp_kvm.rst | 72 ++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst

diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst b/Documentation/virt/kvm/arm/ptp_kvm.rst
new file mode 100644
index 000000000000..455591e2587a
--- /dev/null
+++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
@@ -0,0 +1,72 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+PTP_KVM support for arm64
+=========================
+
+PTP_KVM is used for time sync between guest and host in a high precison.
+It needs get wall time and counter value from host and transfer these data
+to guest via hypercall service. So one more hypercall service should be
+added.
+
+This new SMCCC hypercall will be defined as:
+
+* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0xC6000001
+
+As we only support 64-bits ptp_kvm client, so we choose SMC64/HVC64
+calling convention.
+
+ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
+
+	============    ========    ==========
+	Function ID:    (uint32)    0xC6000001
+	Arguments:	(uint32)    ARM_PTP_PHY_COUNTER(1) or ARM_PTP_VIRT_COUNTER(0)
+				    which indicate acquiring physical counter or
+				    virtual counter respectively.
+	return value:   (uint64)    NOT_SUPPORTED (-1) or two values of wall clock
+				    time and counter cycle.
+	============    ========    ==========
+
+Why we need PTP_KVM?
+Currently, we offen use ntp (sync time with remote network clock) to sync time
+in VM. But the precision of ntp is subject to network delay so it's difficult
+to sync time in a high precision.
+
+kvm virtual ptp clock (ptp_kvm) offers another way to sync time in VM, in which
+the remote clock locates in the host instead of remote network clock. It
+targets to sync time between guest and host in virtualization environment and
+in this way, we can also keep the time of all the VMs running in the same host
+in sync. In general, the delay of communication between host and guest is quiet
+small, so ptp_kvm can offer time sync precision up to in order of nanosecond.
+Please keep in mind that ptp_kvm just limits itself to be a channel which
+transmit the remote clock from host to guest and leaves the time sync jobs to
+an application, eg. chrony, in usersapce of VM.
+
+How PTP_KVM works on arm64?
+After ptp_kvm initialized, there will be a new device node under /dev called
+ptp%d. A guest userspace service, like chrony, can use this device to get host
+walltime, sometimes also counter cycle, which depends on the service it calls.
+Then this guest userspace service can use those data to do the time sync for
+guest.
+Here is a rough sketch to show how kvm ptp clock works.
+
+|----------------------------|              |--------------------------|
+|       guest userspace      |              |          host            |
+|ioctl -> /dev/ptp%d         |              |                          |
+|       ^   |                |              |                          |
+|----------------------------|              |                          |
+|       |   | guest kernel   |              |                          |
+|       |   V      (get host walltime/counter cycle)                   |
+|      ptp_kvm -> hypercall - - - - - - - - - - ->hypercall service    |
+|                         <- - - - - - - - - - - -                     |
+|----------------------------|              |--------------------------|
+
+1. time sync service in guest userspace call ptp device through /dev/ptp%d.
+2. ptp_kvm module in guest recive this request then invoke hypercall to
+   route into host kernel to request host walltime/counter cycle.
+3. ptp_kvm hypercall service in host response to the request and send data
+   back.
+4. ptp (not ptp_kvm, ptp_kvm implemented on it and not shown above) in guest
+   copy the data to userspace.
+
+This ptp_kvm implementation focuses itself to step 2 and 3 and step 2 works
+in guest comparing step 3 works in host kernel.
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

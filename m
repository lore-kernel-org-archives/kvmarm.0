Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF01C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC85D64EB8
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC85D64EB8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 694E54B410;
	Tue,  9 Feb 2021 00:05:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EelqB6B4k+v4; Tue,  9 Feb 2021 00:05:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD40A4B6FF;
	Tue,  9 Feb 2021 00:05:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C5ED4B4A1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jVE7dyTvNPtk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2021 00:05:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4264B738
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612847130;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wKCfxtd4SsZJ+QdMrslrtSyhcO4MGdo1sCwQZ634q6Y=;
 b=fbDTTfkkV2LS4gCUhTjgtgkmYAgTODbEYvp58E45UNgx0gq3BeY5SafimkrFxI97KZ3qoH
 aH1HVOZdk2nYMtYHuqeiyinavBBr476Nt658g/cZ5qomTts09PE51mPUWcOqbxG77Y0ZW6
 Xofz6Q90ypSAiSPYMMsIvU0ySkJVKNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-miMwyxeoMTC75WWXuSPbqg-1; Tue, 09 Feb 2021 00:05:27 -0500
X-MC-Unique: miMwyxeoMTC75WWXuSPbqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF060801965;
 Tue,  9 Feb 2021 05:05:25 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-26.bne.redhat.com [10.64.54.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 5FD515D9CD;
 Tue,  9 Feb 2021 05:05:23 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 17/17] KVM: arm64: Add async PF document
Date: Tue,  9 Feb 2021 13:04:03 +0800
Message-Id: <20210209050403.103143-18-gshan@redhat.com>
In-Reply-To: <20210209050403.103143-1-gshan@redhat.com>
References: <20210209050403.103143-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
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

This adds document to explain the interface for asynchronous page
fault and how it works in general.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/arm/apf.rst   | 143 +++++++++++++++++++++++++++
 Documentation/virt/kvm/arm/index.rst |   1 +
 2 files changed, 144 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/apf.rst

diff --git a/Documentation/virt/kvm/arm/apf.rst b/Documentation/virt/kvm/arm/apf.rst
new file mode 100644
index 000000000000..4f5c01b6699f
--- /dev/null
+++ b/Documentation/virt/kvm/arm/apf.rst
@@ -0,0 +1,143 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Asynchronous Page Fault Support for arm64
+=========================================
+
+There are two stages of page faults when KVM module is enabled as accelerator
+to the guest. The guest is responsible for handling the stage-1 page faults,
+while the host handles the stage-2 page faults. During the period of handling
+the stage-2 page faults, the guest is suspended until the requested page is
+ready. It could take several milliseconds, even hundreds of milliseconds in
+extreme situations because I/O might be required to move the requested page
+from disk to DRAM. The guest does not do any work when it is suspended. The
+feature (Asynchronous Page Fault) is introduced to take advantage of the
+suspending period and to improve the overall performance.
+
+There are two paths in order to fulfil the asynchronous page fault, called
+as control path and data path. The control path allows the VMM or guest to
+configure the functionality, while the notifications are delivered in data
+path. The notifications are classified into page-not-present and page-ready
+notifications.
+
+Data Path
+---------
+
+There are two types of notifications delivered from host to guest in the
+data path: page-not-present and page-ready notification. They are delivered
+through SDEI event and (PPI) interrupt separately. Besides, there is a shared
+buffer between host and guest to indicate the reason and sequential token,
+which is used to identify the asynchronous page fault. The reason and token
+resident in the shared buffer is written by host, read and cleared by guest.
+An asynchronous page fault is delivered and completed as below.
+
+(1) When an asynchronous page fault starts, a (workqueue) worker is created
+    and queued to the vCPU's pending queue. The worker makes the requested
+    page ready and resident to DRAM in the background. The shared buffer is
+    updated with reason and sequential token. After that, SDEI event is sent
+    to guest as page-not-present notification.
+
+(2) When the SDEI event is received on guest, the current process is tagged
+    with TIF_ASYNC_PF and associated with a wait queue. The process is ready
+    to keep rescheduling itself on switching from kernel to user mode. After
+    that, a reschedule IPI is sent to current CPU and the received SDEI event
+    is acknowledged. Note that the IPI is delivered when the acknowledgment
+    on the SDEI event is received on host.
+
+(3) On the host, the worker is dequeued from the vCPU's pending queue and
+    enqueued to its completion queue when the requested page becomes ready.
+    In the mean while, KVM_REQ_ASYNC_PF request is sent the vCPU if the
+    worker is the first element enqueued to the completion queue.
+
+(4) With pending KVM_REQ_ASYNC_PF request, the first worker in the completion
+    queue is dequeued and destroyed. In the mean while, a (PPI) interrupt is
+    sent to guest with updated reason and token in the shared buffer.
+
+(5) When the (PPI) interrupt is received on guest, the affected process is
+    located using the token and waken up after its TIF_ASYNC_PF tag is cleared.
+    After that, the interrupt is acknowledged through SMCCC interface. The
+    workers in the completion queue is dequeued and destroyed if any workers
+    exist, and another (PPI) interrupt is sent to the guest.
+
+Control Path
+------------
+
+The configurations are passed through SMCCC or ioctl interface. The SDEI
+event and (PPI) interrupt are owned by VMM, so the SDEI event and interrupt
+numbers are configured through ioctl command on per-vCPU basis. Besides,
+the functionality might be enabled and configured through ioctl interface
+by VMM during migration:
+
+   * KVM_ARM_ASYNC_PF_CMD_GET_VERSION
+
+     Returns the current version of the feature, supported by the host. It is
+     made up of major, minor and revision fields. Each field is one byte in
+     length.
+
+   * KVM_ARM_ASYNC_PF_CMD_GET_SDEI:
+
+     Retrieve the SDEI event number, used for page-not-present notification,
+     so that it can be configured on destination VM in the scenario of
+     migration.
+
+   * KVM_ARM_ASYNC_PF_GET_IRQ:
+
+     Retrieve the IRQ (PPI) number, used for page-ready notification, so that
+     it can be configured on destination VM in the scenario of migration.
+
+   * KVM_ARM_ASYNC_PF_CMD_GET_CONTROL
+
+     Retrieve the address of control block, so that it can be configured on
+     destination VM in the scenario of migration.
+
+   * KVM_ARM_ASYNC_PF_CMD_SET_SDEI:
+
+     Used by VMM to configure number of SDEI event, which is used to deliver
+     page-not-present notification by host. This is used when VM is started
+     or migrated.
+
+   * KVM_ARM_ASYNC_PF_CMD_SET_IRQ
+
+     Used by VMM to configure number of (PPI) interrupt, which is used to
+     deliver page-ready notification by host. This is used when VM is started
+     or migrated.
+
+   * KVM_ARM_ASYNC_PF_CMD_SET_CONTROL
+
+     Set the control block on the destination VM in the scenario of migration.
+
+The other configurations are passed through SMCCC interface. The host exports
+the capability through KVM vendor specific service, which is identified by
+ARM_SMCCC_KVM_FUNC_ASYNC_PF_FUNC_ID. There are several functions defined for
+this:
+
+   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_VERSION
+
+     Returns the current version of the feature, supported by the host. It is
+     made up of major, minor and revision fields. Each field is one byte in
+     length.
+
+   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_SLOTS
+
+     Returns the size of the hashed GFN table. It is used by guest to set up
+     the capacity of waiting process table.
+
+   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_SDEI
+   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ
+
+     Used by the guest to retrieve the SDEI event and (PPI) interrupt number
+     that are configured by VMM.
+
+   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE
+
+     Used by the guest to enable or disable the feature on the specific vCPU.
+     The argument is made up of shared buffer and flags. The shared buffer
+     is written by host to indicate the reason about the delivered asynchronous
+     page fault and token (sequence number) to identify that. There are two
+     flags are supported: KVM_ASYNC_PF_ENABLED is used to enable or disable
+     the feature. KVM_ASYNC_PF_SEND_ALWAYS allows to deliver page-not-present
+     notification regardless of the guest's state. Otherwise, the notification
+     is delivered only when the guest is in user mode.
+
+   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ_ACK
+
+     Used by the guest to acknowledge the completion of page-ready notification.
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index 3e2b2aba90fc..c8e8f0929c6a 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -7,6 +7,7 @@ ARM
 .. toctree::
    :maxdepth: 2
 
+   apf
    hyp-abi
    psci
    pvtime
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

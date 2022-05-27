Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC07BC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:06:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A165E4B1E1;
	Fri, 27 May 2022 04:06:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s+Re22NHl+KU; Fri, 27 May 2022 04:06:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 648B74B2C0;
	Fri, 27 May 2022 04:06:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33BA949E20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6l3Nkf77AgzU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:06:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B6D4B186
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638795;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Au77dj9BaZM3OWaXsQH00UFj+i5VHc/ijY2zkDDcEiA=;
 b=PWqAC5U9qp4+DKRFLCrgMVnrQZcCsRFShu8PJXjXzmyxeRwLraF70YPl38ZWL/GezbcjkL
 FM7q+1vcuynkvLznnnhScqIIqhpSZDaRvbjG6ek3cMOOdeKo2oUDDL4bYpNieUL88riVpG
 YL/PaGmGFZZmh0SuiYrcdscfLgY6Rpo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-qa_RcJv4PtiKr0mqIkal9A-1; Fri, 27 May 2022 04:06:32 -0400
X-MC-Unique: qa_RcJv4PtiKr0mqIkal9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99C0A2949BB5;
 Fri, 27 May 2022 08:06:31 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 08B782026D64;
 Fri, 27 May 2022 08:06:21 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 20/22] KVM: arm64: Add SDEI document
Date: Fri, 27 May 2022 16:02:51 +0800
Message-Id: <20220527080253.1562538-21-gshan@redhat.com>
In-Reply-To: <20220527080253.1562538-1-gshan@redhat.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: maz@kernel.org, shijie@amperemail.onmicrosoft.com,
 linux-kernel@vger.kernel.org, eauger@redhat.com, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, vkuznets@redhat.com,
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

This adds SDEI document, to explain what has been missed from the
specification and the pesudo firmware registers used for migration.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/arm/sdei.rst | 64 +++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/sdei.rst

diff --git a/Documentation/virt/kvm/arm/sdei.rst b/Documentation/virt/kvm/arm/sdei.rst
new file mode 100644
index 000000000000..ba1539978b2c
--- /dev/null
+++ b/Documentation/virt/kvm/arm/sdei.rst
@@ -0,0 +1,64 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================================
+SDEI Virtualization Support for ARM64
+=====================================
+
+ARM specification DEN0054/C defines Software Delegated Exception Interface
+(SDEI). It provides a mechanism for registering and servicing system events
+from system firmware. The interface is offered by a higher exception level
+to a lower exception level, in other words by a secure platform firmware
+to hypervisor or hypervisor to OS or both.
+
+https://developer.arm.com/documentation/den0054/c
+
+KVM/arm64 implementation follows the specification to support the defined
+hypercalls so that the system events can be registered and serviced from
+KVM hypervisor to the guest OS. However, some of specified functionalities
+are missed by the implementation.
+
+  * The shared event is not supported. It means all supported events are
+    private. They need to be registered, enabled, disabled, unregistered
+    and reset from one particular PE (vCPU).
+
+  * The critical priority is not supported. It means all supported events
+    have normal priority. So there is no preemption between two events
+    in the critical and normal priorities. One event can be running at
+    once on one particular PE (vCPU).
+
+  * Interrupt binding event is not supported. It means all supported
+    events triggered by software.
+
+  * Relative mode for the event handler's address is not supported.
+    The event handler address is always an absolute address.
+
+The event handlers, states and context need to be migrated. Several pseudo
+firmware registers are added for this.
+
+  * KVM_REG_ARM_SDEI_EVENT_HANDLER_0
+    KVM_REG_ARM_SDEI_EVENT_HANDLER_1
+    KVM_REG_ARM_SDEI_EVENT_HANDLER_2
+    KVM_REG_ARM_SDEI_EVENT_HANDLER_3
+
+    The event handler's address and argument for events, whose number
+    are 0, 1, 2 and 3 respectively. Currently, there are only two
+    supported events, which are Software Signaled Event (0) and Async
+    PF Event (1). So the first two registers are only used. zeroes are
+    returned on reading KVM_REG_ARM_SDEI_EVENT_HANDLER_{2, 3}, and the
+    values written to them are ignored.
+
+  * KVM_REG_ARM_SDEI_EVENT_REGISTERED
+    KVM_REG_ARM_SDEI_EVENT_ENABLED
+    KVM_REG_ARM_SDEI_EVENT_RUNNING
+    KVM_REG_ARM_SDEI_EVENT_PENDING
+
+    They are mapped to the registered, enabled, running and pending
+    bitmap respectively.
+
+  * KVM_REG_ARM_SDEI_EVENT_CONTEXT
+
+    The interrupted context.
+
+  * KVM_REG_ARM_SDEI_PE_STATE
+
+    Relect the SDEI masked state on the PE (vCPU).
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95241C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 11:23:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7204B2F4;
	Fri, 20 May 2022 07:23:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IugriivGWUSw; Fri, 20 May 2022 07:23:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66C104B32F;
	Fri, 20 May 2022 07:23:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3040D4B30E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 07:23:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fAxFD3qHJJKU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 07:23:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDB64B2F4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 07:23:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653045795;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=DhPW5VXQyaapTMu/BLT7e8mRErIyIOLdoT3nKh9o7zE=;
 b=LCbWofT5+eGskbznsb+lujU8MM0/D97ssLWnaSl5vp2qR4Ya/HZkc5d8NfE5xsw8BpcyE0
 DKnpIVzCwCZHQ5/nQJK+NJ/C3kpBpvkBT+Y7j4nuSe3Rbrvy5lvhFF4OcpmKFVHLop631A
 LoIQSvgahHD7UC1ad6z7GLiPMLlCEgQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-WgBOqz6yNy-U-sPyUKpLaA-1; Fri, 20 May 2022 07:23:12 -0400
X-MC-Unique: WgBOqz6yNy-U-sPyUKpLaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CABEA29AA2FD;
 Fri, 20 May 2022 11:23:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com
 (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A206E1121314;
 Fri, 20 May 2022 11:23:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] Documentation: kvm: reorder ARM-specific section about
 KVM_SYSTEM_EVENT_SUSPEND
Date: Fri, 20 May 2022 07:23:11 -0400
Message-Id: <20220520112311.3307024-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 52 +++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3201933e52d9..6890c04ccde2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6170,32 +6170,6 @@ Valid values for 'type' are:
  - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested a suspension of
    the VM.
 
-For arm/arm64:
---------------
-
-   KVM_SYSTEM_EVENT_SUSPEND exits are enabled with the
-   KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest invokes the PSCI
-   SYSTEM_SUSPEND function, KVM will exit to userspace with this event
-   type.
-
-   It is the sole responsibility of userspace to implement the PSCI
-   SYSTEM_SUSPEND call according to ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
-   KVM does not change the vCPU's state before exiting to userspace, so
-   the call parameters are left in-place in the vCPU registers.
-
-   Userspace is _required_ to take action for such an exit. It must
-   either:
-
-    - Honor the guest request to suspend the VM. Userspace can request
-      in-kernel emulation of suspension by setting the calling vCPU's
-      state to KVM_MP_STATE_SUSPENDED. Userspace must configure the vCPU's
-      state according to the parameters passed to the PSCI function when
-      the calling vCPU is resumed. See ARM DEN0022D.b 5.19.1 "Intended use"
-      for details on the function parameters.
-
-    - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
-      "Caller responsibilities" for possible return values.
-
 If KVM_CAP_SYSTEM_EVENT_DATA is present, the 'data' field can contain
 architecture specific information for the system-level event.  Only
 the first `ndata` items (possibly zero) of the data array are valid.
@@ -6211,6 +6185,32 @@ Previous versions of Linux defined a `flags` member in this struct.  The
 field is now aliased to `data[0]`.  Userspace can assume that it is only
 written if ndata is greater than 0.
 
+For arm/arm64:
+--------------
+
+KVM_SYSTEM_EVENT_SUSPEND exits are enabled with the
+KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest invokes the PSCI
+SYSTEM_SUSPEND function, KVM will exit to userspace with this event
+type.
+
+It is the sole responsibility of userspace to implement the PSCI
+SYSTEM_SUSPEND call according to ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
+KVM does not change the vCPU's state before exiting to userspace, so
+the call parameters are left in-place in the vCPU registers.
+
+Userspace is _required_ to take action for such an exit. It must
+either:
+
+ - Honor the guest request to suspend the VM. Userspace can request
+   in-kernel emulation of suspension by setting the calling vCPU's
+   state to KVM_MP_STATE_SUSPENDED. Userspace must configure the vCPU's
+   state according to the parameters passed to the PSCI function when
+   the calling vCPU is resumed. See ARM DEN0022D.b 5.19.1 "Intended use"
+   for details on the function parameters.
+
+ - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
+   "Caller responsibilities" for possible return values.
+
 ::
 
 		/* KVM_EXIT_IOAPIC_EOI */
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

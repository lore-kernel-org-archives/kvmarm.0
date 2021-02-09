Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832DBC433E6
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:04:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19BB564EB8
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:04:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19BB564EB8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5ABD4B559;
	Tue,  9 Feb 2021 00:04:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FiyuUFYW+lWx; Tue,  9 Feb 2021 00:04:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DC854B69F;
	Tue,  9 Feb 2021 00:04:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 842744B68E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:04:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O3K3RVv2SvbJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2021 00:04:53 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25C574B559
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:04:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612847092;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=v6D2GLD5js6g58nNNfu2Yz/oGqZy4P8k9pLRln8bcoU=;
 b=OhmhLQfAsttWhih19STdFnAVWZZNgXD+w1EbtNqL5yvPzPnfjqMzy3HdNHaWZN6mxX82c5
 x0vBdVduPjoYCuR/iVJNps1+vb/IS4JZ2iusitmhSQEEvl+jsIL/cNIsxx6iCw0EVq5EMl
 MXEfXwtAMLuRfCWBdton1hxyrWVoJfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-juvzsWAeNoa-p2GzonrCeQ-1; Tue, 09 Feb 2021 00:04:50 -0500
X-MC-Unique: juvzsWAeNoa-p2GzonrCeQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1E06192CC40;
 Tue,  9 Feb 2021 05:04:48 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-26.bne.redhat.com [10.64.54.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 81E0E5D9C0;
 Tue,  9 Feb 2021 05:04:46 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 08/17] KVM: arm64: Add paravirtualization header files
Date: Tue,  9 Feb 2021 13:03:54 +0800
Message-Id: <20210209050403.103143-9-gshan@redhat.com>
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

We need put more stuff in the paravirtualization header files when
the asynchronous page fault is supported. The generic header files
can't meet the goal. This duplicate the generic header files to be
our platform specific header files. It's the preparatory work to
support the asynchronous page fault in subsequent patches:

   include/uapi/asm-generic/kvm_para.h
   include/asm-generic/kvm_para.h

   arch/arm64/include/uapi/asm/kvm_para.h
   arch/arm64/include/asm/kvm_para.h

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_para.h      | 27 ++++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/Kbuild     |  2 --
 arch/arm64/include/uapi/asm/kvm_para.h |  5 +++++
 3 files changed, 32 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_para.h
 create mode 100644 arch/arm64/include/uapi/asm/kvm_para.h

diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
new file mode 100644
index 000000000000..0ea481dd1c7a
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_para.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM_KVM_PARA_H
+#define _ASM_ARM_KVM_PARA_H
+
+#include <uapi/asm/kvm_para.h>
+
+static inline bool kvm_check_and_clear_guest_paused(void)
+{
+	return false;
+}
+
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return 0;
+}
+
+static inline unsigned int kvm_arch_para_hints(void)
+{
+	return 0;
+}
+
+static inline bool kvm_para_available(void)
+{
+	return false;
+}
+
+#endif /* _ASM_ARM_KVM_PARA_H */
diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
index 602d137932dc..f66554cd5c45 100644
--- a/arch/arm64/include/uapi/asm/Kbuild
+++ b/arch/arm64/include/uapi/asm/Kbuild
@@ -1,3 +1 @@
 # SPDX-License-Identifier: GPL-2.0
-
-generic-y += kvm_para.h
diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
new file mode 100644
index 000000000000..cd212282b90c
--- /dev/null
+++ b/arch/arm64/include/uapi/asm/kvm_para.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_ARM_KVM_PARA_H
+#define _UAPI_ASM_ARM_KVM_PARA_H
+
+#endif /* _UAPI_ASM_ARM_KVM_PARA_H */
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

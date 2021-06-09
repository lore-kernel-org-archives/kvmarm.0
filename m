Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C39C48BD1
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:37:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69F64613B1
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69F64613B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D0F649E72;
	Wed,  9 Jun 2021 10:37:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QyVIFi2cOKEk; Wed,  9 Jun 2021 10:37:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03AAB49E50;
	Wed,  9 Jun 2021 10:37:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBC2040895
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:37:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dUW9ntcyfhc9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 10:37:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FB59409DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:37:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623249452;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pckoH3+yQRv0sMag9hTgcQK97AOXiccI1lwisxbeoD8=;
 b=GsF3mXL7BlkVKIA+Ue1z2srh3H1DOi6BGmQTtt9ZmFkcDBDxfTHsZvRhxKKvtFB1XLv4w5
 EdjfFtcnkWrtgpsJ5ZJRdZKJs4tr3pbES7nHw32wMFblW3BkS7/20U7XGSEUHRA2yj5EqP
 5t9/z3lCMsViQfaHvsFI8AjQFKtl9HI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-GYpWbdp-OMSOIcEL4xxzug-1; Wed, 09 Jun 2021 10:37:30 -0400
X-MC-Unique: GYpWbdp-OMSOIcEL4xxzug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2840B8030A0;
 Wed,  9 Jun 2021 14:37:29 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-134.ams2.redhat.com
 [10.36.113.134])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C2E5119C46;
 Wed,  9 Jun 2021 14:37:26 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v2 3/7] asm-generic: unify header guards
Date: Wed,  9 Jun 2021 16:37:08 +0200
Message-Id: <20210609143712.60933-4-cohuck@redhat.com>
In-Reply-To: <20210609143712.60933-1-cohuck@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: Laurent Vivier <lvivier@redhat.com>, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 kvm-ppc@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
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

Standardize header guards to _ASM_GENERIC_HEADER_H_.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/asm-generic/atomic.h          | 4 ++--
 lib/asm-generic/barrier.h         | 6 +++---
 lib/asm-generic/memory_areas.h    | 4 ++--
 lib/asm-generic/pci-host-bridge.h | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/asm-generic/atomic.h b/lib/asm-generic/atomic.h
index 26b645a7cc18..b09ce95053e7 100644
--- a/lib/asm-generic/atomic.h
+++ b/lib/asm-generic/atomic.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_GENERIC_ATOMIC_H__
-#define __ASM_GENERIC_ATOMIC_H__
+#ifndef _ASM_GENERIC_ATOMIC_H_
+#define _ASM_GENERIC_ATOMIC_H_
 
 /* From QEMU include/qemu/atomic.h */
 #define atomic_fetch_inc(ptr)  __sync_fetch_and_add(ptr, 1)
diff --git a/lib/asm-generic/barrier.h b/lib/asm-generic/barrier.h
index 6a990ff8d5a5..5499a5664d4d 100644
--- a/lib/asm-generic/barrier.h
+++ b/lib/asm-generic/barrier.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_BARRIER_H_
-#define _ASM_BARRIER_H_
+#ifndef _ASM_GENERIC_BARRIER_H_
+#define _ASM_GENERIC_BARRIER_H_
 /*
  * asm-generic/barrier.h
  *
@@ -32,4 +32,4 @@
 #define cpu_relax()	asm volatile ("":::"memory")
 #endif
 
-#endif /* _ASM_BARRIER_H_ */
+#endif /* _ASM_GENERIC_BARRIER_H_ */
diff --git a/lib/asm-generic/memory_areas.h b/lib/asm-generic/memory_areas.h
index 3074afe23393..c86db255ecee 100644
--- a/lib/asm-generic/memory_areas.h
+++ b/lib/asm-generic/memory_areas.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_GENERIC_MEMORY_AREAS_H__
-#define __ASM_GENERIC_MEMORY_AREAS_H__
+#ifndef _ASM_GENERIC_MEMORY_AREAS_H_
+#define _ASM_GENERIC_MEMORY_AREAS_H_
 
 #define AREA_NORMAL_PFN 0
 #define AREA_NORMAL_NUMBER 0
diff --git a/lib/asm-generic/pci-host-bridge.h b/lib/asm-generic/pci-host-bridge.h
index 9e91499b9446..174ff341dd0d 100644
--- a/lib/asm-generic/pci-host-bridge.h
+++ b/lib/asm-generic/pci-host-bridge.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_PCI_HOST_BRIDGE_H_
-#define _ASM_PCI_HOST_BRIDGE_H_
+#ifndef _ASM_GENERIC_PCI_HOST_BRIDGE_H_
+#define _ASM_GENERIC_PCI_HOST_BRIDGE_H_
 /*
  * Copyright (C) 2016, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
  *
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BB8C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1092A64EB9
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1092A64EB9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0E074B410;
	Tue,  9 Feb 2021 00:05:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xxWX5BQNhKIi; Tue,  9 Feb 2021 00:05:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48D4C4B66D;
	Tue,  9 Feb 2021 00:05:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDF7E4B59B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dXfYqd-BXOP1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2021 00:05:19 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A255E4B525
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612847119;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iUu+lzwBSV+fLOITGUpcU5W0RbJdTJsAIGp714lX3hQ=;
 b=KudFj6KDHBQcsgufMkdwASOt1V7MqCVYyJaLQljJPybJbMxAQ9AiK2yjlX8M2BJ8iTBXkV
 CAu6Zh+gCOI6w7dwqe41PG9j/zRUUrKWZIsdu5x6SFDnfadWId0EA/wSBA1Qy8+jS4F/mF
 EdfgKcG80txFJbDrMXOWgLBMkzVPLiY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-Dr5KQhgwM0Gwv1MGTmGang-1; Tue, 09 Feb 2021 00:05:17 -0500
X-MC-Unique: Dr5KQhgwM0Gwv1MGTmGang-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C80AB803F48;
 Tue,  9 Feb 2021 05:05:15 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-26.bne.redhat.com [10.64.54.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id D11F95D9C0;
 Tue,  9 Feb 2021 05:05:07 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 14/17] arm64: Detect async PF para-virtualization feature
Date: Tue,  9 Feb 2021 13:04:00 +0800
Message-Id: <20210209050403.103143-15-gshan@redhat.com>
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

This implements kvm_para_available() to check if para-virtualization
features are available or not. Besides, kvm_para_has_feature() is
enhanced to detect the asynchronous page fault para-virtualization
feature. These two functions are going to be used by guest kernel
to enable the asynchronous page fault.

This also adds kernel option (CONFIG_KVM_GUEST), which is the umbrella
for the optimizations related to KVM para-virtualization.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/Kconfig                     | 11 +++++++++++
 arch/arm64/include/asm/kvm_para.h      | 12 +++++++++++-
 arch/arm64/include/uapi/asm/kvm_para.h |  2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f39568b28ec1..792ae09aa690 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1078,6 +1078,17 @@ config PARAVIRT_TIME_ACCOUNTING
 
 	  If in doubt, say N here.
 
+config KVM_GUEST
+	bool "KVM Guest Support"
+	depends on PARAVIRT
+	default y
+	help
+	  This option enables various optimizations for running under the KVM
+	  hypervisor. Overhead for the kernel when not running inside KVM should
+	  be minimal.
+
+	  In case of doubt, say Y
+
 config KEXEC
 	depends on PM_SLEEP_SMP
 	select KEXEC_CORE
diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
index 0ea481dd1c7a..8f39c60a6619 100644
--- a/arch/arm64/include/asm/kvm_para.h
+++ b/arch/arm64/include/asm/kvm_para.h
@@ -3,6 +3,8 @@
 #define _ASM_ARM_KVM_PARA_H
 
 #include <uapi/asm/kvm_para.h>
+#include <linux/of.h>
+#include <asm/hypervisor.h>
 
 static inline bool kvm_check_and_clear_guest_paused(void)
 {
@@ -11,7 +13,12 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 
 static inline unsigned int kvm_arch_para_features(void)
 {
-	return 0;
+	unsigned int features = 0;
+
+	if (kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_ASYNC_PF))
+		features |= (1 << KVM_FEATURE_ASYNC_PF);
+
+	return features;
 }
 
 static inline unsigned int kvm_arch_para_hints(void)
@@ -21,6 +28,9 @@ static inline unsigned int kvm_arch_para_hints(void)
 
 static inline bool kvm_para_available(void)
 {
+	if (IS_ENABLED(CONFIG_KVM_GUEST))
+		return true;
+
 	return false;
 }
 
diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
index 162325e2638f..70bbc7d1ec75 100644
--- a/arch/arm64/include/uapi/asm/kvm_para.h
+++ b/arch/arm64/include/uapi/asm/kvm_para.h
@@ -4,6 +4,8 @@
 
 #include <linux/types.h>
 
+#define KVM_FEATURE_ASYNC_PF		0
+
 /* Async PF */
 #define KVM_ASYNC_PF_ENABLED		(1 << 0)
 #define KVM_ASYNC_PF_SEND_ALWAYS	(1 << 1)
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

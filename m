Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD52C433ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5EF5360E09
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EF5360E09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0207C4B482;
	Fri,  7 May 2021 02:41:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0yoQq8rGHdB4; Fri,  7 May 2021 02:41:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 232214B592;
	Fri,  7 May 2021 02:41:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 893824B561
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k-mp7aqVLoIK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:41:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 587354B529
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369699;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PJbHgPjkDKA/tTI/lNvX6XYjnM1cBrY4DXE3J1ZsAi0=;
 b=HKubzHXQzaAuBsyxa5uYWLfL6j27e95sdLuAVDYuWfgwP8ThnwbKzmLkqXEmgpWxZyUvZx
 BG+HLmJ5BdeY1v9v+RaaNqTz6Z2f/yPfQLYUACRa132dJscuGoGas3RSGi4TKU9PG8+bjg
 EhRrDeDG7sWIFIzjHBITo4qsXflsPUM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-9Nb1SD1ZO8i4XN3Eio5Cog-1; Fri, 07 May 2021 02:41:37 -0400
X-MC-Unique: 9Nb1SD1ZO8i4XN3Eio5Cog-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F9388015F4;
 Fri,  7 May 2021 06:41:36 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E8A5E5C3E0;
 Fri,  7 May 2021 06:41:33 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 12/15] arm64: Detect async PF para-virtualization feature
Date: Fri,  7 May 2021 16:40:50 +0800
Message-Id: <20210507084053.44407-13-gshan@redhat.com>
In-Reply-To: <20210507084053.44407-1-gshan@redhat.com>
References: <20210507084053.44407-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 7f2a80091337..c03499c1acd6 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1104,6 +1104,17 @@ config PARAVIRT_TIME_ACCOUNTING
 
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

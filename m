Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D63C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 01:03:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4210461038
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 01:03:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4210461038
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9F404A500;
	Sat, 14 Aug 2021 21:03:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a6MGyVNqSs4Y; Sat, 14 Aug 2021 21:02:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43CD34B0CC;
	Sat, 14 Aug 2021 21:02:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80DB14AEE2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 21:02:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dg5YGN2RI8fa for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 21:02:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 732FB4B09A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 21:02:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628989374;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7CuxvVxDOmKp2g5Ri+ZH700zVAyxQXJLrLM9CSY/ZmU=;
 b=LRn8Bok2NAdI2lsWoKae3GD+rPqZuPn5do3t/W3T08tgf0K3UqirYy+cYxDCWr9NDb8CT6
 fxLMvsiiXP8/aW/whMVJt3JoxHaQNNzKWaKl0Z5CUCuokNu/ToU4CjOEqxkDPm8gAAC/s6
 9Gqy1lyCr+Er9pYpsZkwUPDGy2bc9ts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-wUj_VntAMqy6WUa9H6OnnQ-1; Sat, 14 Aug 2021 21:02:53 -0400
X-MC-Unique: wUj_VntAMqy6WUa9H6OnnQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F9F71853025;
 Sun, 15 Aug 2021 01:02:51 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 923896091B;
 Sun, 15 Aug 2021 01:02:45 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 12/15] arm64: Detect async PF para-virtualization feature
Date: Sun, 15 Aug 2021 08:59:44 +0800
Message-Id: <20210815005947.83699-13-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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
index fdcd54d39c1e..6dceae6ed7d3 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1081,6 +1081,17 @@ config PARAVIRT_TIME_ACCOUNTING
 
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

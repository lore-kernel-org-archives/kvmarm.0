Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76452C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0BAA464EB9
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BAA464EB9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98A5D4B70A;
	Tue,  9 Feb 2021 00:05:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s4oNNuxiCUhE; Tue,  9 Feb 2021 00:05:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4D24B734;
	Tue,  9 Feb 2021 00:05:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E2614B559
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SnEZydsq9IBi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2021 00:05:12 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07E314B72D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612847111;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lykTvxA53wjtht4Rhfogm7ARHCpnIyEDc9oLghHVR9E=;
 b=X7OpuUK4eD+OkloPGUfuN24V7YHusTGJHaMLxcNLk881AgZaj4s4OlhcCnZZP21vBE2eG2
 aOr3uqzFDeI0WihgwWjTWzs2TzwudYU3IQmo5orHLdR5TaWXOfqSZLx6sGMkRa9F06og2b
 woDQ+j+PPE4jvVyXnGO7vu8pVk+uw4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-xJ1Cy6XOMlW3VF7ygWMSNQ-1; Tue, 09 Feb 2021 00:05:09 -0500
X-MC-Unique: xJ1Cy6XOMlW3VF7ygWMSNQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7043A192CC43;
 Tue,  9 Feb 2021 05:05:07 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-26.bne.redhat.com [10.64.54.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 4A36B5D9C0;
 Tue,  9 Feb 2021 05:05:02 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 13/17] KVM: arm64: Export async PF capability
Date: Tue,  9 Feb 2021 13:03:59 +0800
Message-Id: <20210209050403.103143-14-gshan@redhat.com>
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

This exports the asynchronous page fault capability:

    * Identify capability KVM_CAP_ASYNC_{PF, PF_INT}.

    * Standardize SDEI event for asynchronous page fault.

    * Enable kernel config CONFIG_KVM_ASYNC_{PF, PF_SLOT}.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/uapi/asm/kvm_sdei.h | 1 +
 arch/arm64/kvm/Kconfig                 | 2 ++
 arch/arm64/kvm/arm.c                   | 4 ++++
 arch/arm64/kvm/sdei.c                  | 5 +++++
 4 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
index 232092de5e21..47d578abba1a 100644
--- a/arch/arm64/include/uapi/asm/kvm_sdei.h
+++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
@@ -13,6 +13,7 @@
 #define KVM_SDEI_MAX_VCPUS     512
 #define KVM_SDEI_INVALID_NUM   0
 #define KVM_SDEI_DEFAULT_NUM   0x40400000
+#define KVM_SDEI_ASYNC_PF_NUM  0x40400001
 
 struct kvm_sdei_event_state {
 	uint64_t	num;
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 3964acf5451e..dfb3ed0de2ca 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -31,6 +31,8 @@ menuconfig KVM
 	select SRCU
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
+	select KVM_ASYNC_PF
+	select KVM_ASYNC_PF_SLOT
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index be0e6c2db2a5..0940de3ebcff 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -269,6 +269,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SDEI:
 		r = 1;
 		break;
+	case KVM_CAP_ASYNC_PF:
+	case KVM_CAP_ASYNC_PF_INT:
+		r = IS_ENABLED(CONFIG_KVM_ASYNC_PF) ? 1 : 0;
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 4f5a582daa97..437303bfafba 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -19,6 +19,11 @@ static struct kvm_sdei_event_state defined_kse[] = {
 	  1,
 	  SDEI_EVENT_PRIORITY_CRITICAL
 	},
+	{ KVM_SDEI_ASYNC_PF_NUM,
+	  SDEI_EVENT_TYPE_PRIVATE,
+	  1,
+	  SDEI_EVENT_PRIORITY_CRITICAL
+	},
 };
 
 static struct kvm_sdei_event *kvm_sdei_find_event(struct kvm *kvm,
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

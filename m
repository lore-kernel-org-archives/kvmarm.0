Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98F7C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 01:02:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FEBB60FC1
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 01:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6FEBB60FC1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F3F94A524;
	Sat, 14 Aug 2021 21:02:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mAR6koe+vZ+T; Sat, 14 Aug 2021 21:02:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B00A4B0CA;
	Sat, 14 Aug 2021 21:02:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 634424A523
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 21:02:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CCBJiu7VMtpD for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 21:02:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD894B0D0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 21:02:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628989369;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JcWtDu7p2Qu/JKSPI/zS4AqjmMnxUQpnL7tRXt4otTk=;
 b=bA7+ndTNfqQIeoW92jPa5SA0StTp8/uLg24eaizATtLWxFrm6oIUGMoUJsPOqPvJOIXg61
 ZvRbXE7EoHiRsau0UZanRrsD+TsiR785/b/BPmEkXwgKMaeW0KRqkJQY9bPrV2XHz4Wndl
 E1nFIZ7eIsDNtfpjk13+OxvQfTAauFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-M4xytfevM7-OQVPAceXSWw-1; Sat, 14 Aug 2021 21:02:46 -0400
X-MC-Unique: M4xytfevM7-OQVPAceXSWw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F252D8799E0;
 Sun, 15 Aug 2021 01:02:44 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEB4E6091B;
 Sun, 15 Aug 2021 01:02:40 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 11/15] KVM: arm64: Export async PF capability
Date: Sun, 15 Aug 2021 08:59:43 +0800
Message-Id: <20210815005947.83699-12-gshan@redhat.com>
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
index f7a6b2b22b50..cbe8be3d0a25 100644
--- a/arch/arm64/include/uapi/asm/kvm_sdei.h
+++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
@@ -16,6 +16,7 @@
 #define KVM_SDEI_MAX_VCPUS	512
 #define KVM_SDEI_INVALID_NUM	0
 #define KVM_SDEI_DEFAULT_NUM	0x40400000
+#define KVM_SDEI_ASYNC_PF_NUM	0x40400001
 
 struct kvm_sdei_event_state {
 	__u64	num;
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a4eba0908bfa..3c6f89b4c9a0 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -29,6 +29,8 @@ menuconfig KVM
 	select SRCU
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
+	select KVM_ASYNC_PF
+	select KVM_ASYNC_PF_SLOT
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 74ca5ec51e53..2692bd24df86 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -281,6 +281,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

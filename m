Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326C2C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1C9863237
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C1C9863237
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 785094B187;
	Wed, 17 Nov 2021 01:53:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zcQiMgSbFs85; Wed, 17 Nov 2021 01:53:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E3474B16C;
	Wed, 17 Nov 2021 01:53:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D62B4B14D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L4rwQgpfsHJb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:36 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 027C74B13E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:36 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 134-20020a62198c000000b0047bf0981003so1129496pfz.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ngr4hW3OQO25yW6Z4QPAPb06Z9XdAyw5TZaaZf4PQgw=;
 b=d3k4dD7DeKSt+dZdlIRs7mm6LnVHJVt6MJBZO8D+xJd0gunFXbHBYuDqyARKCcDfGh
 lPKrp5Qqr21sujBqw3NCYXc3O43g3ZYZnFgqWmbcB4gG1evEu0MvTQuF7I/6Lzlf0clV
 TRzdRmPYVy9yUTIciVPd1fE3vQ+EA6smRJ9+4HS5nnIz6N4rpcGlS1yb6+kvIsR36f54
 uaj8JsNWz14aQ5SL8POTavCae1N9dzpidU/epMp9T9i+QrevGG54XO7wmqkbd1YGLTT5
 px1AJdtDdiH9/WKiDIhjGHBLJKS375Z4uLZVXZ85mhrHMhrAW3Gl+0Ukb1ZERUVRfoeJ
 CpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ngr4hW3OQO25yW6Z4QPAPb06Z9XdAyw5TZaaZf4PQgw=;
 b=LlO0aaClqdh9fL8w2/FSrH5/rSnHLG4h/a2kLV266V0Fhtb47she7daZk67gO+m6FL
 +RJbmWIY8IOAXcAyI+SHJabi6D3QdFAi5wtDCdKPGe964+6jmSryO8wj2nuB+opYBXS2
 N1o+oVMJZpMoQQMU1tPatiYr4B/snUHbmoAGHUslXf/JaLVHLXKSYQMLtJdzIpDQi5WE
 ZExbeeWPRNvLc9BIZdZVTHtMyoItVgwCXsRtZ05P/1IbSuO6Du9VjTZOT/iI0ET460XX
 agafn65qFFmzOiVYlLUAyswh5fMBub4ynr/ndtYtGJyZX6i8bN9yZfjOusKPkUTYITbo
 DHzQ==
X-Gm-Message-State: AOAM5301673EkRbJ9gY2niCIEmTlDKcAZvNlypl6Ik+g8Qb4mm6pCLEu
 BL7Q/IqOzEKMZwBnEG6+H8DVoUWey3w=
X-Google-Smtp-Source: ABdhPJzMTnMi5u59+kPQqdzefOhB/wBSglPLL+HhxruNL4kxrs/Un5EiZfa6yoeZ23QBUnLS38Laa1NvHts=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:22c4:b0:141:deda:a744 with SMTP id
 y4-20020a17090322c400b00141dedaa744mr53364712plg.25.1637132015299; Tue, 16
 Nov 2021 22:53:35 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:47 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-18-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 17/29] KVM: arm64: Introduce
 KVM_CAP_ARM_ID_REG_CONFIGURABLE capability
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Introduce a new capability KVM_CAP_ARM_ID_REG_CONFIGURABLE to indicate
that ID registers are writable by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 arch/arm64/kvm/arm.c           | 1 +
 include/uapi/linux/kvm.h       | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..022effa4454d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7484,3 +7484,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_ARM_ID_REG_CONFIGURABLE
+------------------------------------
+
+:Architectures: arm64
+
+This capability indicates that userspace can modify the ID registers
+via KVM_SET_ONE_REG ioctl.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 19c4a78f931d..a54579e7ac91 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -215,6 +215,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_ID_REG_CONFIGURABLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..9697c06a7f5b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_ARM_ID_REG_CONFIGURABLE 207
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

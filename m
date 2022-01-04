Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDEAC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 19:49:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6FA549F36;
	Tue,  4 Jan 2022 14:49:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gw8cjwu47TCD; Tue,  4 Jan 2022 14:49:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 755194B0E1;
	Tue,  4 Jan 2022 14:49:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E264649F12
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vngQZJYDx3z0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 14:49:35 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C72B449F5B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:35 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 u37-20020a632365000000b0033b4665d66cso20206092pgm.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jan 2022 11:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Z8f3pbOlFfhJc+MZxj7F3/2ZMbhtOsD2BP3YM7tyFSI=;
 b=OaSbR2gJ2IXGYHNG7buKj7VOZ4GeQdjTTsbGWOeIcUNX+UJFsEii0dDfyTGsoPxIKb
 wx8UL7lfUSB21kFvjQEyLl3E6BqGHYLI+Elic6yKmOAqNsqWrB2r+zSmPpF4uLaGQyZY
 vukjKlc6W07BGNSQgd0GvWKr3TjPRMlVohLF3oUb/hBfj87jwlubT++V0yjMwdC2JSxn
 ohSNZKVRuRxMUv7IpOQt7LgtleeUnSC40Ulh3+yelQU4udeIldttZVuQ4/lEB/Yz5nFP
 eZUjGHJTGiIafggw16v3rJ8NP92X239/cHs8ddu1jKMcMoA9KKCV7D4g7AdzGagdG9I6
 gtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Z8f3pbOlFfhJc+MZxj7F3/2ZMbhtOsD2BP3YM7tyFSI=;
 b=IHYZVxvk5idRcO18qZon5FiHT+me9OoQF5m6HzOZVtuRCN0g96xKMljmi/VoGOG1s5
 Hm4NVpsdDvp1gekJzZxNNjd4BkJFQqJEeegqz7hGPRMqTvWIVZtJV2gg4qwGCAjEsJ20
 sINnY+iS8dqwxd+NVeuOmZzhzFrgCoTkM9ofqGcu6WCFofmY3wZZNg/dOxopYd3tqPKw
 G2s2X8Iqch11shuXWnezuqCnbl9GM4IbtMdxX8lET7PhMD9tR9+9E/rkIDXU+3O4G581
 Y4BG24Wnkbpqd4+KEK6QGSX9YuzHLmzctzgj7X4EElVH0ntlS9xpLhKfiU9zMdGz9B6Z
 e1mg==
X-Gm-Message-State: AOAM5330qiWOtA5+dxEFZtik+arMIUyM7cwb23Ws/qu+e8T6NDARb66B
 IJ2jqXb5Uazxz/rhwyXDO3mBorqgtuek
X-Google-Smtp-Source: ABdhPJwRTLWTJz2U+utOgtiR1Vb8LCrr/pZS/a+ivsj8Sv6sdQTy02D1hR10crnPg22DzkZHlLaKsOHvhnxJ
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:81ce:0:b0:4bc:d8ec:9748 with SMTP id
 c14-20020aa781ce000000b004bcd8ec9748mr1389383pfn.29.1641325774964; Tue, 04
 Jan 2022 11:49:34 -0800 (PST)
Date: Tue,  4 Jan 2022 19:49:10 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-4-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 03/11] KVM: Introduce KVM_CAP_ARM_HVC_FW_REG_BMAP
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Introduce the KVM ARM64 capability, KVM_CAP_ARM_HVC_FW_REG_BMAP,
to indicate the support for psuedo-firmware bitmap extension.
Each of these registers holds a feature-set exposed to the guest
in the form of a bitmap. If supported, a simple 'read' of the
capability should return the number of psuedo-firmware registers
supported. User-space can utilize this to discover the registers.
It can further explore or modify the features using the classical
GET/SET_ONE_REG interface.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/api.rst | 21 +++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 2 files changed, 22 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..646176537f2c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6925,6 +6925,27 @@ indicated by the fd to the VM this is called on.
 This is intended to support intra-host migration of VMs between userspace VMMs,
 upgrading the VMM process without interrupting the guest.
 
+7.30 KVM_CAP_ARM_HVC_FW_REG_BMAP
+--------------------------------
+
+:Architectures: arm64
+:Parameters: None
+:Returns: Number of psuedo-firmware registers supported
+
+This capability indicates that KVM for arm64 supports the psuedo-firmware
+register bitmap extension. Each of these registers represent the features
+supported by a particular type in the form of a bitmap. By default, these
+registers are set with the upper limit of the features that are supported.
+
+The registers can be accessed via the standard SET_ONE_REG and KVM_GET_ONE_REG
+interfaces. The user-space is expected to read the number of these registers
+available by reading KVM_CAP_ARM_HVC_FW_REG_BMAP, read the current bitmap
+configuration via GET_ONE_REG for each register, and then write back the
+desired bitmap of features that it wishes the guest to see via SET_ONE_REG.
+
+Note that KVM doesn't allow the user-space to modify these registers after
+the VM (any of the vCPUs) has started running.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..209b43dbbc3c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_ARM_HVC_FW_REG_BMAP 207
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5D7C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:01:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2146640C23;
	Mon, 14 Feb 2022 02:01:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 91D9udA5JmJA; Mon, 14 Feb 2022 02:00:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE91F408A7;
	Mon, 14 Feb 2022 02:00:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B15C408A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pykAPmvL98vn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:00:56 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12D1F405C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:56 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 s10-20020a17090a948a00b001b96be201f6so6206067pjo.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LqqSQ+pfjPkcBMVZaT7DXOpSryezslmtHzw2gvxdUKE=;
 b=BXNGQJEPXj526bgkijx0svS6AKh+wH5vz+CbiZqi9LTPYrppZNqH1xhYeJcxPJ5KmD
 fLdIRkEuCi8EKF+K6RLiw0e7mv4Zn8WsF/aWGLoL/NQJP3thK4ZeeCZVnDZ5DiTkKtyh
 CB16pqTyBC0mYbZbgg7MY4vqc0YSPHcLL1B/pPU3SMrbo90o8frKVSPeqB1UR3/gCfdi
 6WeqIw7fNOXxjZ1N3MpkxxiG1jx9t7gSBJmh910trAu4csbKLiS9cO+nnv3tl70rPFgs
 ROEn0N+WhhmpRsZJLhuJEp0M7OD90CUJtgic/1vGeRE8MgxoOfAcDDAviTAS3aXiXn0s
 K9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LqqSQ+pfjPkcBMVZaT7DXOpSryezslmtHzw2gvxdUKE=;
 b=WUU08koIbQBpEODksJVDln1StPO0guPjkOZbIwRmyeUumZNpw6aE6ibNvypPE4WJOj
 m3apLAJogv3uhylgnzUszWUViTKX2eXuZVqDw/UQLXm0P60Ln8dUTvps31wP9JTFKCY5
 EniFTWJk6pJ1wdU+lY1+onrk7LeYv1W2punwFPoBgR+Ag6xHTyyrUmqwS7Ckcl5d5dXO
 xhp0rObdnISXkvlBRwykrMN1q/U2VtHOBRAnMbZhA1v2pjZHj8xizpOU9p8va0LXuwg3
 swc3r5jllY2PYsK4/YoMMlGoVK4dW7QRj28/83RMo6p5zOAEb9HXMlEGTUGx0g/78iF7
 sYYQ==
X-Gm-Message-State: AOAM532TmErwKjud66QSE5k3ChkME/FryzENONPfOLw/oWbsmby5x9CK
 rK+rfoam2RPAXcSA89GoBF7FywvnIsI=
X-Google-Smtp-Source: ABdhPJz6IFXa9hWbUTsAZTdoeoQlMhXZJjw8CsklsTYlXwId7cdlTGLWp5HcrUaCg10o3Cb+CSmqrI+AFz0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a63:a1f:: with SMTP id
 31mr4796173pgk.79.1644822055226; 
 Sun, 13 Feb 2022 23:00:55 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:35 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-17-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 16/27] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE
 capability
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
 Documentation/virt/kvm/api.rst | 12 ++++++++++++
 arch/arm64/kvm/arm.c           |  1 +
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 14 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..901ab8486189 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2607,6 +2607,10 @@ EINVAL.
 After the vcpu's SVE configuration is finalized, further attempts to
 write this register will fail with EPERM.
 
+The arm64 ID registers (where Op0=3, Op1=0, CRn=0, 0<=CRm<8, 0<=Op2<8)
+are allowed to set by userspace if KVM_CAP_ARM_ID_REG_CONFIGURABLE is
+available.  They become immutable after calling KVM_RUN on any of the
+vcpus in the guest (modifying values of those registers will fail).
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:
@@ -7561,3 +7565,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
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
index e7dcc7704302..68ffced5b09e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -210,6 +210,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_ID_REG_CONFIGURABLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..6e09f2c2c0c1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_ARM_ID_REG_CONFIGURABLE 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

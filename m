Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8B3C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:49:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A44B149EAC;
	Thu, 10 Mar 2022 23:49:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kH+adfbPOOWs; Thu, 10 Mar 2022 23:49:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7173E49EE6;
	Thu, 10 Mar 2022 23:48:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B893249EBA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ymOFruH-GgPQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:48:57 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FB8349F10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:55 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 h12-20020a63530c000000b0037c8f45bf1bso4152328pgb.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YvkdLZdpcr97EpSsUi5adIM71O6zx1+CVaghTM2lKQc=;
 b=WW9mUBlAXTHtpKEr3Ay7NmT20frRkus2LqacrMY+0B0b1ZhuU3tEvhK6b3wZU/ORFt
 sa55nV3ZrgY5MgtjlQVBpdtqyFbjZppWQCm2l0cVBWAqi1VDRVbjrjB/uu1VrUXHsT3v
 JTQv7fegNAfQHGW26cOwiExvl2UWjMKnpBMAexNgf8VDKqrGSfZLt3A33jk7p/97Cfn4
 9+3/YGnvvaatyDI8WqBeDbkRQt/2eHQO/TObdfaHNMTWEOnV/efpI33e3RpcIgKOFDFS
 ++uMr4ZigfVe97viZ9lx3iiQPIXSsluL57ZzBOGYES5FDwrFO0ILP8RZ5oAwpA43s2IW
 Abzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YvkdLZdpcr97EpSsUi5adIM71O6zx1+CVaghTM2lKQc=;
 b=IY6MxBUHUtgzd0re3Sanv9sNmvjtIgnpawvnSZz+3ARfWoU/CGG88b3+7CX8mFnsHv
 HhraqUzEm9Lj+kt4j8dqOQTuKuwbKunyAlNOrW9+A3+2Gv39wmrsrjyLa4D74HZV0vSz
 UNlHLtdqMSdPT7ji1uM/b/wlNlcEoIyvdwMvBbrFo4k2tiPagpHzYbmxFOr8qQFj89HW
 Eac1HBFhsrhk+F3+2IY/jbAazOM228Gso54hKkOhYZ54QdzPY0ITq/cRikSrPtcN6faF
 6EDzfx8eXw1znz8hE/NGnxyHWdxISgrUg1uU2n/RUsDRxg/7hqOVyUjFkNb+NAZonMiN
 cnjg==
X-Gm-Message-State: AOAM531BEH8kcO3/opDpyrMIIzQx/KcpmD6iRBueoHCW75HaSX9MhB42
 k2kLMC7BRe22XrD35x06x9q4tbG4Kfo=
X-Google-Smtp-Source: ABdhPJyXnNci0fOzvDdVKJf4gcHvVbtR1SLTxJuXYaGJpVy9F9SwRVGou9JVMngVfwiQy4DD8uTH1DNToK8=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:c96:b0:4f7:203a:e8de with SMTP id
 a22-20020a056a000c9600b004f7203ae8demr8180188pfv.32.1646974134582; Thu, 10
 Mar 2022 20:48:54 -0800 (PST)
Date: Thu, 10 Mar 2022 20:48:00 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-15-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 14/25] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE
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
index 9f3172376ec3..d2cd404d74c2 100644
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
@@ -7575,3 +7579,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
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
index 507ee1f2aa96..a9351727a7aa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1135,6 +1135,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
 #define KVM_CAP_PPC_AIL_MODE_3 210
+#define KVM_CAP_ARM_ID_REG_CONFIGURABLE 211
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

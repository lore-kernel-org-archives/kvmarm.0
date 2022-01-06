Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF50C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:29:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45C4949F2F;
	Wed,  5 Jan 2022 23:29:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YXOBNPPhY9mi; Wed,  5 Jan 2022 23:28:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C68E49E49;
	Wed,  5 Jan 2022 23:28:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C15049F19
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CqVUaHDkpvWe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:55 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7384640FAC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:54 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 n18-20020a056a00213200b004baa74aca72so917807pfj.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qsXbUWt4k61IeDMaJ9yBb2pGASPsSAD6bL2wC01t25c=;
 b=X3r9aCI3viml7Ve7M/vnUEWHj5rEsNNVR6sb7qQzcD8l+h1EFbuICdNFRrf6JnRz0D
 HhyUCXipJ72usL89WgDrd35ksSuWYF4UeGu6JX7EvzzJ2gbnkaUfxVvPrAcfnuQUR5CO
 BrXhEsgD4G5nKCZemrjqh8BnoYfw9EZcn2+XSGolSgF4YpW5Pyd3NMq4FC7rnxIpUGPO
 ptAYwJWAyXeEfXygvuj2jHN9J/6ZsLXnuh7reAuronSnzdQicn1PWyHNTmR62yJzghab
 iKAmQ95r2rug/zKKw1R6nEFh88SK98Ne0RgxUktyWbpS0m5TryJUKxgXFd0STRu3RD6k
 YFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qsXbUWt4k61IeDMaJ9yBb2pGASPsSAD6bL2wC01t25c=;
 b=mUCBJpBUOK/yHPkeN+jxOLeNCvQCmodIjloXKPNJz7rdlCw3u/X9ALNw5L2XNRAlMq
 nM9eLW8pr5u3PwCUzQEne+6PSvivCH/7Gkr57tCkjvOzIHKEbT51rOcp1tS2pnq0ANIq
 4Q4VHCQNqktR+X6LkuwNgBgZakgs/8TsKKBiXl528srLYvkf8bek56KX/Xu4kkDJRrUp
 m18Zp4p9VjdMkS8vSU6HzZXm1XYX1z+MyWDEUBG2cRAM+fqVaJhLn32wvWRUFPfRstoZ
 9gpNeqBzjpcIMR/Hgmbe30Bo61+rXJGSPNy6+kGXL5g2F+xS9nth8fZ5pIpkqbObbljf
 +Arg==
X-Gm-Message-State: AOAM531W85dNl80p4e8xXveEuf8BBFcRhpCUvBnmMU/dC6uzf/TLyCsJ
 xa6e7HHeSs7/bhNPHNgtXfzjxdqUYXA=
X-Google-Smtp-Source: ABdhPJw50t65HXqO3xQ2kp1MCKMxMqyY4SYSE/3YVObavipJJ7gE0Al1VQutdOv3vePKB24kL3IGH5TXOOk=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:350b:: with SMTP id
 ls11mr7818734pjb.97.1641443333689; Wed, 05 Jan 2022 20:28:53 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:57 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-16-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 15/26] KVM: arm64: Introduce
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
 Documentation/virt/kvm/api.rst | 12 ++++++++++++
 arch/arm64/kvm/arm.c           |  1 +
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 14 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..86099a9b0bae 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2574,6 +2574,10 @@ EINVAL.
 After the vcpu's SVE configuration is finalized, further attempts to
 write this register will fail with EPERM.
 
+The arm64 ID registers (where Op0=3, Op1=0, CRn=0, 0<=CRm<8, 0<=Op2<8)
+are allowed to set by userspace if KVM_CAP_ARM_ID_REG_CONFIGURABLE is
+available.  They become immutable after calling KVM_RUN on any of the
+vcpus in the guest (modifying values of those registers will fail).
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:
@@ -7484,3 +7488,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
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
index 16fc2ce32069..876f2777acf2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -216,6 +216,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F99C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9527C4B1F5;
	Tue, 19 Apr 2022 02:57:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id emAwefR4MZOm; Tue, 19 Apr 2022 02:57:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E26E4B262;
	Tue, 19 Apr 2022 02:57:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B18084B20C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 35l2JWJUfkHG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:43 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B691749EF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:42 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 n4-20020a170902f60400b00158d1f2d442so6108618plg.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=U4uOGGGNJJAvE+8qhBWKzG6xiqX6UboPrGG2sNPZOY8=;
 b=BewbNlPjPqMatcm5XCUJOCpQZV4IoUW4ifHD5JfI6GHGlRBqW2sLCDsPuTDMbF2jUH
 Wlv1w+R+Edq3e7b8T/1GKHqWp2fKfCDQosSdPRzW1wXYl688u7L0nZNPdsN1cV8hUJlj
 dA7dU+yyYorRaosHIs3zf7EDl5GaiYDINtqkhAEv928ecEPq4g9QENwKQkaqEVUO+EdU
 kLtR11yTTd7eAasAJcwfVzE8tSgBo/4cH2y9b/7wc9XFcuKMcMQ188Jx2nOlz6c8Pt6r
 4SpvFqlxMnxNrUpursSPLQOzcC+Kc38iLMoD9FEUJ9QWJjCdK6M8OTNlU4b8jYjVazsJ
 NFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=U4uOGGGNJJAvE+8qhBWKzG6xiqX6UboPrGG2sNPZOY8=;
 b=j620lvRWF1Chi8NA2lIpxvPNwKEw407Wmb/iaH8knxB9q3UZ4So3NTSZf5DkTztyvB
 N0XcP5rmA3OUOXutj1Iy2Tk72eiAh6W4o8NLYM677aCHzMkZCq0G1Ht4pPlSv8tdbmua
 6Ag/7aUhEaezar50xMKs6l5K3oqhN7eq8g0YgxqtZyY1fVkLKsnjFnfnEF8eZoGQ0mUr
 taEw2+d9HaZjZOVY1Ptn+DU1Q+4DuA02XPOODfs/Lt9vDCtz9XRezH4n699JXLpui3v+
 mbkrvMwwWEaLuhVLhqEGPH0Zy82mVofOoo68w2iDnLq2jpTyHfxeXDYV4Pl11z3qV+f4
 P4Zg==
X-Gm-Message-State: AOAM533NwfG5tq2Lx2C3QUL/Ni/4yKDVeAVElACyoU8RUiAmBNrwO7da
 lBzW5VTzjDRWKJOBKoKrIH5wSVz0AAs=
X-Google-Smtp-Source: ABdhPJwNvsMFXxj/P4c/uyL22/CuuuumZEIUldC8yuu2qFzsobmd9UhZjjZnKg5gGPfNpCl6SSEUeTinmLA=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:cc0b:b0:1cb:8351:a47e with SMTP id
 b11-20020a17090acc0b00b001cb8351a47emr17191716pju.67.1650351461844; Mon, 18
 Apr 2022 23:57:41 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:28 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-23-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 22/38] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE
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
 Documentation/virt/kvm/api.rst | 16 ++++++++++++++++
 arch/arm64/kvm/arm.c           |  1 +
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 18 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85c7abc51af5..e2e7b08e64c1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2601,6 +2601,14 @@ EINVAL.
 After the vcpu's SVE configuration is finalized, further attempts to
 write this register will fail with EPERM.
 
+The arm64 ID registers with encoding Op0=3, Op1=0, CRn=0, 1<=CRm<8, 0<=Op2<8
+are allowed to modified by userspace only for AArch64 EL1 vCPUs if
+KVM_CAP_ARM_ID_REG_CONFIGURABLE is available.
+They become immutable after calling KVM_RUN on any of the
+vcpus in the guest (modifying values of those registers will fail).
+Those ID registers are always immutable for AArch32 EL1 vCPUs, which
+KVM_ARM_VCPU_EL1_32BIT is configured for, even when
+KVM_CAP_ARM_ID_REG_CONFIGURABLE is available.
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:
@@ -7724,6 +7732,14 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
 this capability will disable PMU virtualization for that VM.  Usermode
 should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 
+8.35 KVM_CAP_ARM_ID_REG_CONFIGURABLE
+------------------------------------
+
+:Architectures: arm64
+
+This capability indicates that userspace can modify the ID registers
+via KVM_SET_ONE_REG ioctl.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5c1cee04aa95..b4db368948cc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -211,6 +211,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_ID_REG_CONFIGURABLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 91a6fe4e02c0..171f1d0ea1e1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1144,6 +1144,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
+#define KVM_CAP_ARM_ID_REG_CONFIGURABLE 214
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

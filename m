Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D81EC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 23:39:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB91A4B1FA;
	Mon,  2 May 2022 19:39:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VSbkUHL21Jv7; Mon,  2 May 2022 19:39:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AED8F4B260;
	Mon,  2 May 2022 19:39:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B50A84B298
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 19:39:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f951JF4jwWiU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 19:39:09 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2100E4B1F4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 19:39:09 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 j8-20020aa78d08000000b0050ade744b37so8682490pfe.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 16:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iAnIEZoxFvZcpUiI2JvanBeFHfSeSOkvmHvqJfm/zII=;
 b=letkbXX6ibxsOx6SG6cpYtGpVqlihTPUapx3VMOK3tKO5nMAIBqLmP1R+G/H79hn6z
 D3dMy9lOsmUparnWVrS/zBQGNU1jPkdufkUlSlviUeK8cCW8y1BUri6EcEsO3QUL1Kin
 VIfhpnmPpDR3HCldG9pOtTuNJYHbY8Yq2OeikN5FPLkimtJ4eAwI2sEFzielefJ+nTff
 wyLlslbL/YsXyh3mkmpb7mnhXDyQj+rv2EEduT2zFyTaWWvTG3Lm9nRibnhGRm0PBVkq
 gK6MBN3z7/19iXoFZoZkkCjCbAHHr4D49VJlbJ2A19at1ljCx7dIN3SdOswdbkJlmulr
 s3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iAnIEZoxFvZcpUiI2JvanBeFHfSeSOkvmHvqJfm/zII=;
 b=yFX6Conikzlg5vRvQmIuEgyxxd8u/tGeK2tMdOVk47lejcGWJK723iMhmPH23V1o5v
 b/oFxFmvetbQN+6/2byr964Z3tdFIyEvOe6/zk93O6gffMomk5d5GG9Pu/UZx5dL32SB
 OJ9miqf2foEqACBJpvpvmGv4x5T4lA8iLdBmpZIVGvpxtKHDzv9wV53OGMXQyGHlh/QE
 dr17mRpszIoYi4bwoORf4J4vZTQ/fV2I65jYeeL5EzosHPkneG7iq+K2xkwsevQcsSNd
 RQ1yuK4mYd3LkUJFrlJHH0etRQpbHjz8j5umZGQLOK7aYbs4IIfJs4w6b2vc9LYmnqFg
 DDrg==
X-Gm-Message-State: AOAM533wq6plcqC7tmmwQC/HY01T24hG1q+5PtN+Ax+fkho8QHmHBpOE
 qyx9WWwEtvPWB2jn1L4pGeB0UIlzLdMk
X-Google-Smtp-Source: ABdhPJyXQR7muVhKAlvZ3f9QrEFalM+VA9iIEkI1MvgTnwrFA4Swlm7HbQmeqI8TiVM1t3D3hWJMl7T+c3MZ
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:2e0d:b0:1c9:b839:af02 with SMTP id
 q13-20020a17090a2e0d00b001c9b839af02mr1691249pjd.122.1651534748316; Mon, 02
 May 2022 16:39:08 -0700 (PDT)
Date: Mon,  2 May 2022 23:38:50 +0000
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
Message-Id: <20220502233853.1233742-7-rananta@google.com>
Mime-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 6/9] Docs: KVM: Add doc for the bitmap firmware registers
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

Add the documentation for the bitmap firmware registers in
hypercalls.rst and api.rst. This includes the details for
KVM_REG_ARM_STD_BMAP, KVM_REG_ARM_STD_HYP_BMAP, and
KVM_REG_ARM_VENDOR_HYP_BMAP registers.

Since the document is growing to carry other hypercall related
information, make necessary adjustments to present the document
in a generic sense, rather than being PSCI focused.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst            | 16 ++++
 Documentation/virt/kvm/arm/hypercalls.rst | 94 ++++++++++++++++++-----
 2 files changed, 92 insertions(+), 18 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4a900cdbc62e..8ae638be79fd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2542,6 +2542,22 @@ arm64 firmware pseudo-registers have the following bit pattern::
 
   0x6030 0000 0014 <regno:16>
 
+arm64 bitmap feature firmware pseudo-registers have the following bit pattern::
+
+  0x6030 0000 0016 <regno:16>
+
+The bitmap feature firmware registers exposes the hypercall services that are
+available for userspace to configure. The set bits corresponds to the services
+that are available for the guests to access. By default, KVM sets all the
+supported bits during VM initialization. The userspace can discover the
+available services via KVM_GET_ONE_REG, and write back the bitmap corresponding
+to the features that it wishes guests to see via KVM_SET_ONE_REG.
+
+Note: These registers are immutable once any of the vCPUs of the VM has run at
+least once. A KVM_SET_ONE_REG in such a scenario will return a -EBUSY to userspace.
+
+(See Documentation/virt/kvm/arm/hypercalls.rst for more details.)
+
 arm64 SVE registers have the following bit patterns::
 
   0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index d52c2e83b5b8..383ca766cf36 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -1,32 +1,32 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=========================================
-Power State Coordination Interface (PSCI)
-=========================================
+=======================
+ARM Hypercall Interface
+=======================
 
-KVM implements the PSCI (Power State Coordination Interface)
-specification in order to provide services such as CPU on/off, reset
-and power-off to the guest.
+KVM handles the hypercall services as requested by the guests. New hypercall
+services are regularly made available by the ARM specification or by KVM (as
+vendor services) if they make sense from a virtualization point of view.
 
-The PSCI specification is regularly updated to provide new features,
-and KVM implements these updates if they make sense from a virtualization
-point of view.
-
-This means that a guest booted on two different versions of KVM can
-observe two different "firmware" revisions. This could cause issues if
-a given guest is tied to a particular PSCI revision (unlikely), or if
-a migration causes a different PSCI version to be exposed out of the
-blue to an unsuspecting guest.
+This means that a guest booted on two different versions of KVM can observe
+two different "firmware" revisions. This could cause issues if a given guest
+is tied to a particular version of a hypercall service, or if a migration
+causes a different version to be exposed out of the blue to an unsuspecting
+guest.
 
 In order to remedy this situation, KVM exposes a set of "firmware
 pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
 interface. These registers can be saved/restored by userspace, and set
-to a convenient value if required.
+to a convenient value as required.
 
-The following register is defined:
+The following registers are defined:
 
 * KVM_REG_ARM_PSCI_VERSION:
 
+  KVM implements the PSCI (Power State Coordination Interface)
+  specification in order to provide services such as CPU on/off, reset
+  and power-off to the guest.
+
   - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
     (and thus has already been initialized)
   - Returns the current PSCI version on GET_ONE_REG (defaulting to the
@@ -74,4 +74,62 @@ The following register is defined:
     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
       The workaround is always active on this vCPU or it is not needed.
 
-.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
+
+Bitmap Feature Firmware Registers
+---------------------------------
+
+Contrary to the above registers, the following registers exposes the hypercall
+services in the form of a feature-bitmap to the userspace. This bitmap is
+translated to the services that are available to the guest. There is a register
+defined per service call owner and can be accessed via GET/SET_ONE_REG interface.
+
+By default, these registers are set with the upper limit of the features that
+are supported. This way userspace can discover all the electable hypercall services
+via GET_ONE_REG. The user-space can write-back the desired bitmap back via
+SET_ONE_REG. The features for the registers that are untouched, probably because
+userspace isn't aware of them, will be exposed as is to the guest.
+
+Note that KVM would't allow the userspace to configure the registers anymore once
+any of the vCPUs has run at least once. Instead, it will return a -EBUSY.
+
+The psuedo-firmware bitmap register are as follows:
+
+* KVM_REG_ARM_STD_BMAP:
+    Controls the bitmap of the ARM Standard Secure Service Calls.
+
+  The following bits are accepted:
+
+    Bit-0: KVM_REG_ARM_STD_BIT_TRNG_V1_0:
+      The bit represents the services offered under v1.0 of ARM True Random
+      Number Generator (TRNG) specification, ARM DEN0098.
+
+* KVM_REG_ARM_STD_HYP_BMAP:
+    Controls the bitmap of the ARM Standard Hypervisor Service Calls.
+
+  The following bits are accepted:
+
+    Bit-0: KVM_REG_ARM_STD_HYP_BIT_PV_TIME:
+      The bit represents the Paravirtualized Time service as represented by
+      ARM DEN0057A.
+
+* KVM_REG_ARM_VENDOR_HYP_BMAP:
+    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
+
+  The following bits are accepted:
+
+    Bit-0: KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT
+      The bit represents the ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID
+      and ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID function-ids.
+
+    Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
+      The bit represents the Precision Time Protocol KVM service.
+
+Errors:
+
+    =======  =============================================================
+    -ENOENT   Unknown register accessed.
+    -EBUSY    Attempt a 'write' to the register after the VM has started.
+    -EINVAL   Invalid bitmap written to the register.
+    =======  =============================================================
+
+.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
\ No newline at end of file
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

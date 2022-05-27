Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B882C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:06:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2134F4B284;
	Fri, 27 May 2022 04:06:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gw7D+oA0csLO; Fri, 27 May 2022 04:06:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2B774B2D8;
	Fri, 27 May 2022 04:06:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2E4249E5F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kthWjRXdLFIo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:06:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA70149E20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638769;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=twZ0Ps5QlQoExjMaYnRuFi/0acFN9mberGquMbJnVlw=;
 b=LIjuEPCLzfgy4vIZjY7+slNQ4w4c7ziV/MgmKH1d+jzyD/MUJPQhXW+ehFYxuWC2SmdrHX
 3mdKUOnXcvMEaiN+6BlY4tOAWxr8NW56q65UyY5tE81sqGSxehqdjMp1av3YfBA9xZZWqY
 uIsQqSP82KpUSPfqEoPZxwsPKanFyV8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-dHQJq2LSP2WXZWUR_i_Jmw-1; Fri, 27 May 2022 04:06:05 -0400
X-MC-Unique: dHQJq2LSP2WXZWUR_i_Jmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACF59858EEE;
 Fri, 27 May 2022 08:06:04 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 279CC2026D64;
 Fri, 27 May 2022 08:05:57 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 17/22] KVM: arm64: Expose SDEI capbility and service
Date: Fri, 27 May 2022 16:02:48 +0800
Message-Id: <20220527080253.1562538-18-gshan@redhat.com>
In-Reply-To: <20220527080253.1562538-1-gshan@redhat.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: maz@kernel.org, shijie@amperemail.onmicrosoft.com,
 linux-kernel@vger.kernel.org, eauger@redhat.com, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, vkuznets@redhat.com,
 will@kernel.org
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

The SDEI functionality is ready and lets exposes the capability
and service.

  * KVM_CAP_ARM_SDEI

  * KVM_REG_ARM_STD_BIT_SDEI in pseudo-firmware bitmap register
    KVM_REG_ARM_STD_BMAP

  * The events for software signaled one (0x0) and Async PF (0x1)
    are exposed.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst            | 11 +++++++++++
 Documentation/virt/kvm/arm/hypercalls.rst |  4 ++++
 arch/arm64/include/asm/kvm_sdei.h         |  2 ++
 arch/arm64/include/uapi/asm/kvm.h         |  1 +
 arch/arm64/kvm/arm.c                      |  1 +
 arch/arm64/kvm/hypercalls.c               |  4 ++++
 include/uapi/linux/kvm.h                  |  1 +
 7 files changed, 24 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..011ec0987d71 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7956,6 +7956,17 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
+8.37 KVM_CAP_ARM_SDEI
+---------------------
+
+:Capability: KVM_CAP_ARM_SDEI
+:Architectures: arm64
+:Type: vm
+
+This capability indicates that the SDEI virtual service is supported
+in the host. A VMM can check whether the service is available to enable
+it.
+
 9. Known KVM API problems
 =========================
 
diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index 3e23084644ba..8b8159988934 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -106,6 +106,10 @@ The pseudo-firmware bitmap register are as follows:
       The bit represents the services offered under v1.0 of ARM True Random
       Number Generator (TRNG) specification, ARM DEN0098.
 
+    Bit-1: KVM_REG_ARM_STD_BIT_SDEI:
+      The bit represents the services offered under v1.1 of ARM Software
+      Delegated Exception Interface (SDEI) specification, ARM DEN0054C.
+
 * KVM_REG_ARM_STD_HYP_BMAP:
     Controls the bitmap of the ARM Standard Hypervisor Service Calls.
 
diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index a1e960943515..a68d40137a88 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -15,6 +15,8 @@
 #include <linux/bits.h>
 
 enum {
+	KVM_SDEI_EVENT_SW_SIGNALED = 0,
+	KVM_SDEI_EVENT_ASYNC_PF,
 	KVM_NR_SDEI_EVENTS,
 };
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 3bb134355874..cc3251381960 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -344,6 +344,7 @@ struct kvm_arm_copy_mte_tags {
 
 enum {
 	KVM_REG_ARM_STD_BIT_TRNG_V1_0	= 0,
+	KVM_REG_ARM_STD_BIT_SDEI,
 #ifdef __KERNEL__
 	KVM_REG_ARM_STD_BMAP_BIT_COUNT,
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 06cb5e38634e..15ead92ad26d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -217,6 +217,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_ARM_SDEI:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 88561ac47301..aaa5197ffe83 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -99,6 +99,10 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func)
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 
 	switch (func) {
+	case SDEI_1_0_FN(ARM_SMCCC_STANDARD_SDEI_START - 0x20) ...
+	     SDEI_1_0_FN(ARM_SMCCC_STANDARD_SDEI_END - 0x20):
+		return test_bit(KVM_REG_ARM_STD_BIT_SDEI,
+				&smccc_feat->std_bmap);
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5088bd9f1922..65622bcaeec3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1157,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
+#define KVM_CAP_ARM_SDEI 217
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

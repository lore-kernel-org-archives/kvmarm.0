Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23666C433E1
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:06:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DCBE92086A
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aUf2HULJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCBE92086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D9AA4B57A;
	Tue,  4 Aug 2020 13:06:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tYStRxQfY6UY; Tue,  4 Aug 2020 13:06:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 380FC4B795;
	Tue,  4 Aug 2020 13:06:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A0644B584
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:06:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4yS+KlSkKf9o for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 13:06:25 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ECF84B72C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:06:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596560785;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=sAkg/Iwx4xnjg6Rnu+uqLzEQ6JwtFTxMfaav6AgT7dU=;
 b=aUf2HULJrvi4X0c6DuuzV1T4Hjs5kfHoo76GSnOa8LGAUNqnfw9nlNuT+WtgggggrrAU6H
 ouS8BiBMQ6Arr1hQ9uSXMoyjW01n8jYxOxx/YyWul3XE0Co7E0+cutjPPXdsrdimPtEXX+
 2dlIwkJspsePptmD+9eUbClJsJnY11k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-HN4gs_NwNji8AcnAAw6L6A-1; Tue, 04 Aug 2020 13:06:21 -0400
X-MC-Unique: HN4gs_NwNji8AcnAAw6L6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E15E2800475;
 Tue,  4 Aug 2020 17:06:19 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3F97272E48;
 Tue,  4 Aug 2020 17:06:18 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 6/6] arm64/x86: KVM: Introduce steal-time cap
Date: Tue,  4 Aug 2020 19:06:04 +0200
Message-Id: <20200804170604.42662-7-drjones@redhat.com>
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
References: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: maz@kernel.org, pbonzini@redhat.com, steven.price@arm.com
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

arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
support for steal-time. However this is unnecessary, as only a KVM
fd is required, and it complicates userspace (userspace may prefer
delaying vcpu creation until after feature probing). Introduce a cap
that can be checked instead. While x86 can already probe steal-time
support with a kvm fd (KVM_GET_SUPPORTED_CPUID), we add the cap there
too for consistency.

Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virt/kvm/api.rst    | 13 +++++++++++++
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/pvtime.c           |  2 +-
 arch/x86/kvm/x86.c                |  3 +++
 include/uapi/linux/kvm.h          |  1 +
 6 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3bd96c1a3962..51208c5d6ac2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6152,3 +6152,16 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+8.24 KVM_CAP_STEAL_TIME
+-----------------------
+
+:Architectures: arm64, x86
+
+This capability indicates that KVM supports steal time accounting.
+When steal time accounting is supported it may be enabled with
+architecture-specific interfaces.  This capability and the architecture-
+specific interfaces must be consistent, i.e. if one says the feature
+is supported, than the other should as well and vice versa.  For arm64
+see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
+For x86 see Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1b65dfeb6fed..57c44bc56087 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -505,6 +505,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
 
+bool kvm_arm_pvtime_supported(void);
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90cb90561446..0f7f8cd2f341 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -222,6 +222,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 */
 		r = 1;
 		break;
+	case KVM_CAP_STEAL_TIME:
+		r = kvm_arm_pvtime_supported();
+		break;
 	default:
 		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
 		break;
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 75234321d896..920ac43077ad 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -71,7 +71,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	return base;
 }
 
-static bool kvm_arm_pvtime_supported(void)
+bool kvm_arm_pvtime_supported(void)
 {
 	return !!sched_info_on();
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..27fc86bb28c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3538,6 +3538,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
 		break;
+	case KVM_CAP_STEAL_TIME:
+		r = sched_info_on();
+		break;
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4fdf30316582..121fb29ac004 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_STEAL_TIME 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

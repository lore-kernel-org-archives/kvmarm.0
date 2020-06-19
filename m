Return-Path: <SRS0=kKHV=AA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5720C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 18:46:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E33121548
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 18:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MUTG6v4R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E33121548
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 443404B194;
	Fri, 19 Jun 2020 14:46:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H3XaDz-oX7-i; Fri, 19 Jun 2020 14:46:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2389E4B182;
	Fri, 19 Jun 2020 14:46:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D63314B183
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 14:46:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YJtHottSWWrE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2020 14:46:42 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F10834B18E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 14:46:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1592592401;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KZqmlt0cscWcvzj/LLoHL14wMYtqNDfhj+O9I3CpYAU=;
 b=MUTG6v4RtNfOE38kjy5epFmhHyo4GHEiy/+RdX3s0vCD+Tscx7Gq+xAONIPxOVMsEIG+Kh
 aBX0ydFawI2sq48ymKgro+NGKo77BAidWR+1gjODPZjMdByaWRgDaMUi/8QMugojaSerGP
 4NJxymJKvIftgo7NLtFbV/0ovBAmhk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-fs4gCf6zOFW40J-s9UoXcA-1; Fri, 19 Jun 2020 14:46:37 -0400
X-MC-Unique: fs4gCf6zOFW40J-s9UoXcA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9450464;
 Fri, 19 Jun 2020 18:46:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.110])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 166EB60BF4;
 Fri, 19 Jun 2020 18:46:34 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/4] arm64/x86: KVM: Introduce steal time cap
Date: Fri, 19 Jun 2020 20:46:27 +0200
Message-Id: <20200619184629.58653-3-drjones@redhat.com>
In-Reply-To: <20200619184629.58653-1-drjones@redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: pbonzini@redhat.com, steven.price@arm.com, maz@kernel.org
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
support for steal time. However this is unnecessary and complicates
userspace (userspace may prefer delaying vcpu creation until after
feature probing). Since probing steal time only requires a KVM fd,
we introduce a cap that can be checked. Additionally, when probing
steal time we should check delayacct_on, because even though
CONFIG_KVM selects TASK_DELAY_ACCT, it's possible for the host
kernel to have delay accounting disabled with the 'nodelayacct'
command line option. x86 already determines support for steal time
by checking delayacct_on and can already probe steal time support
with a kvm fd (KVM_GET_SUPPORTED_CPUID), but we add the cap there
too for consistency.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virt/kvm/api.rst | 11 +++++++++++
 arch/arm64/kvm/arm.c           |  3 +++
 arch/x86/kvm/x86.c             |  3 +++
 include/uapi/linux/kvm.h       |  1 +
 4 files changed, 18 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9a12ea498dbb..05b1fdb88383 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6151,3 +6151,14 @@ KVM can therefore start protected VMs.
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
+architecture-specific interfaces.  For x86 see
+Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".  For arm64 see
+Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL"
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90cb90561446..f6dca6d09952 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -222,6 +222,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 */
 		r = 1;
 		break;
+	case KVM_CAP_STEAL_TIME:
+		r = sched_info_on();
+		break;
 	default:
 		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..ced6335e403e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3533,6 +3533,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

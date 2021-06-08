Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF92C48BCD
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 15:54:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACF6061359
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 15:54:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACF6061359
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51A9540CF8;
	Tue,  8 Jun 2021 11:54:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HiAPT8RBSHXi; Tue,  8 Jun 2021 11:54:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3B049E72;
	Tue,  8 Jun 2021 11:54:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93B434029F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 11:54:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EipJz4FhzYnF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 11:54:04 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B0BD4079A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 11:54:04 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id o3so3749224wri.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 08:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=6VUTi6r0zGjvD+ox5LbEVdcu7SOJ3CxYqosX/6quRvc=;
 b=iZxQMnxOlNisd6FMWcutFJg9ihWBRrP18+4KoCR7isLbBgJRjV2h9bm7ro5tM0SuA5
 MKA963p2Fjmaerhs0VLNc3mXjmVJbt4LXKOds3/hhLBfPZTNhM4ALrICmh9wRHLm3mDj
 9X0bwod0yko2OzqVbHqT6E91S1tWi3hL1+YyfpA/AefIXhN0izWgnv2m4AsrQM4gTRFb
 XPGRIVmgyNb6TPkqf5zH5+OpFuMLdvJItw67EM2UPkwxqiE40pkNyBxiSgrBs7QNMC1Q
 UqgLxRznUGNuKj9K/rYCy6GTXUiiCElOBKA3oqupM1W8sLyaqix9NLGflqG3lQaM8Z05
 rHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=6VUTi6r0zGjvD+ox5LbEVdcu7SOJ3CxYqosX/6quRvc=;
 b=C9MTHrziqUBsVJKZpCcCbL9O3AiX1s04kXBsjV/ezAxWMJfqPhqVFe+tV34vBIFHZW
 eUBv2IRpdNuZBnhzp1tHyTOMDz9VDR7x3aLONXziIlZNrFfeZO4iZGOot31K5E70Jgzk
 TWxGlNke+VLX4rO7Xp1jSX21CuETMYx72X59eYh0Bi789o3BfxfW3M7ejlYdkoIMSHJt
 oZW/GnxiNJFyHtEG51FM9rtyABqTf7EZtkn02oJ8Z4/KewJ6ZKFDrlXxN7k2uuaJKn5p
 4VZL8Tv/wBlG3JO9yz9W0wDV/JQf/lBWUsFtPO4kHSw/ojdkra7rPcn7tsUwZPECiBzp
 nvjw==
X-Gm-Message-State: AOAM530MaSQS4SnzofTBlHWaepl4rKB20RoQSQ6fntNTUU62bptuHruP
 /+m5Vh0rua1u74mp35oLrLGubw==
X-Google-Smtp-Source: ABdhPJy61JSG9YYU4eU/zql91JN1YArLPTW12IIWCRmtkz+g9RAUJUbtnqHF/W7eyUKs8LNMBHfbCw==
X-Received: by 2002:adf:e50b:: with SMTP id j11mr22681729wrm.377.1623167643627; 
 Tue, 08 Jun 2021 08:54:03 -0700 (PDT)
Received: from localhost.localdomain (adsl-84-226-111-173.adslplus.ch.
 [84.226.111.173])
 by smtp.gmail.com with ESMTPSA id l31sm3314180wms.16.2021.06.08.08.54.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Jun 2021 08:54:03 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org
Subject: [RFC PATCH 3/5] KVM: arm64: Allow userspace to request WFI
Date: Tue,  8 Jun 2021 17:48:04 +0200
Message-Id: <20210608154805.216869-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608154805.216869-1-jean-philippe@linaro.org>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, salil.mehta@huawei.com,
 lorenzo.pieralisi@arm.com, kvm@vger.kernel.org, corbet@lwn.net,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org, will@kernel.org,
 jonathan.cameron@huawei.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

To help userspace implement PSCI CPU_SUSPEND, allow setting the "HALTED"
MP state to request a WFI before returning to the guest.

Userspace won't obtain a HALTED mp_state from a KVM_GET_MP_STATE call
unless they set it themselves. When set by KVM, to handle wfi or
CPU_SUSPEND, it is consumed before returning to userspace.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 Documentation/virt/kvm/api.rst | 15 +++++++++------
 include/uapi/linux/kvm.h       |  1 +
 arch/arm64/kvm/arm.c           | 11 ++++++++++-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7fcb2fd38f42..e4fe7fb60d5d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1416,8 +1416,8 @@ Possible values are:
                                  which has not yet received an INIT signal [x86]
    KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
                                  now ready for a SIPI [x86]
-   KVM_MP_STATE_HALTED           the vcpu has executed a HLT instruction and
-                                 is waiting for an interrupt [x86]
+   KVM_MP_STATE_HALTED           the vcpu has executed a HLT/WFI instruction
+                                 and is waiting for an interrupt [x86,arm64]
    KVM_MP_STATE_SIPI_RECEIVED    the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
    KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64]
@@ -1435,8 +1435,9 @@ these architectures.
 For arm/arm64:
 ^^^^^^^^^^^^^^
 
-The only states that are valid are KVM_MP_STATE_STOPPED and
-KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
+Valid states are KVM_MP_STATE_STOPPED and KVM_MP_STATE_RUNNABLE which reflect
+if the vcpu is paused or not. If KVM_CAP_ARM_MP_HALTED is present, state
+KVM_MP_STATE_HALTED is also valid.
 
 4.39 KVM_SET_MP_STATE
 ---------------------
@@ -1457,8 +1458,10 @@ these architectures.
 For arm/arm64:
 ^^^^^^^^^^^^^^
 
-The only states that are valid are KVM_MP_STATE_STOPPED and
-KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
+Valid states are KVM_MP_STATE_STOPPED and KVM_MP_STATE_RUNNABLE which reflect
+if the vcpu should be paused or not. If KVM_CAP_ARM_MP_HALTED is present,
+KVM_MP_STATE_HALTED can be set, to wait for interrupts targeted at the vcpu
+before running it.
 
 4.40 KVM_SET_IDENTITY_MAP_ADDR
 ------------------------------
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 79d9c44d1ad7..06ba64c49737 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1083,6 +1083,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SGX_ATTRIBUTE 196
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
 #define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_ARM_MP_HALTED 199
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d8cbaa0373c7..d6ad977fea5f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -207,6 +207,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_MP_HALTED:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -469,6 +470,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	case KVM_MP_STATE_RUNNABLE:
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		break;
+	case KVM_MP_STATE_HALTED:
+		kvm_arm_vcpu_suspend(vcpu);
+		break;
 	case KVM_MP_STATE_STOPPED:
 		kvm_arm_vcpu_power_off(vcpu);
 		break;
@@ -699,7 +703,12 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			preempt_enable();
 		}
 
-		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu)) {
+		/*
+		 * Check mp_state again in case userspace changed their mind
+		 * after requesting suspend.
+		 */
+		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu) &&
+		    vcpu->arch.mp_state == KVM_MP_STATE_HALTED) {
 			if (!irq_pending) {
 				kvm_vcpu_block(vcpu);
 				kvm_clear_request(KVM_REQ_UNHALT, vcpu);
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

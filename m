Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC82C07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85353610D2
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85353610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 364C84B0CB;
	Mon, 19 Jul 2021 14:50:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mpa8f7eDHkJD; Mon, 19 Jul 2021 14:50:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE8684B0DE;
	Mon, 19 Jul 2021 14:50:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 200274B0EA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LhqVOAGH1Hso for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 14:50:10 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AF094B0E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:09 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 v21-20020a5d90550000b0290439ea50822eso13324341ioq.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=92yThg6uO5wYmeILOZOePwh93S5XAe0V6zbbybcWJO0=;
 b=i8aV3pLEUHpV8nXWQejniH7FEzLP8jg949SwENv5zTVoiJGTZd5TwY/1w91ERZrox0
 dlN3HwtTO31IwGn6e/B3TuSCOQQm7dKyNiUV40v7hxEjbFWEcyRcZxC168KOP6k1/OfS
 jxKYpIBm3d2p9W8ifhUVEwp1lD83DfArX3ITyaWijicrxxCBJMTO7Fi5HTNoxzRWdCeb
 EE+WfmCQTV60LLuIRSFP9gaxAN7buL4cIwzvgC6gcZfzZ3hKUE+R4RsZmIWW/axj9le0
 HQjD41G7SS0PeezOqVyGly61uUTLoGTrnjv0d+tQNKIRhIkJ8oBIss8deXzS95QsbtGr
 sc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=92yThg6uO5wYmeILOZOePwh93S5XAe0V6zbbybcWJO0=;
 b=AGaC8LFknhGc2MiCRFDthGdM17fM+mEcTfEiw6gPFxjb0eb/pVFQPe79W1u5DHtxQc
 RN7ZzQmQweJpEeKmnyiMotRYsti8HrIpTvmTg8o/2mYHUWVkOzJpo3iMVzQOkM6JiV0O
 oPgeMGh4lcJduIg68a+5yYkIBtYXktF8xXCgczGuoUZbBDeKiytD298cCXzRbFoMil5p
 mXpIz8StYXcSJryb2bpFxUbqaWzOBY8ujodPjlUrGTo6Dq7WlS+usywRob3islMR6ZDI
 9Om/a5FzMWeD95tLmEwdnqDmzsADMSMREv7R0aF8D9b79SkX1NFFfi/ghCdG/5wCgPEa
 Hfnw==
X-Gm-Message-State: AOAM533eutTDU4ZHPmXcLMQw8bUrjH5hCBnMoX+4JkgU7YyIzV9TPNZb
 QtsUDXZfJnvPti/5kbiCfpv/RMoe+9w=
X-Google-Smtp-Source: ABdhPJyUcgnGwNxKx/wbpDMOBmF7XheuCQzfCiRREH/w9XfYAuChqvaYmfRLxURgaVhKUn8EYU62XV0YxJ8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:ab0a:: with SMTP id
 v10mr3181975ilh.17.1626720608785; 
 Mon, 19 Jul 2021 11:50:08 -0700 (PDT)
Date: Mon, 19 Jul 2021 18:49:45 +0000
In-Reply-To: <20210719184949.1385910-1-oupton@google.com>
Message-Id: <20210719184949.1385910-9-oupton@google.com>
Mime-Version: 1.0
References: <20210719184949.1385910-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 08/12] KVM: arm64: Allow userspace to configure a vCPU's
 virtual offset
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Add a new vCPU attribute that allows userspace to directly manipulate
the virtual counter-timer offset. Exposing such an interface allows for
the precise migration of guest virtual counter-timers, as it is an
indepotent interface.

Uphold the existing behavior of writes to CNTVOFF_EL2 for this new
interface, wherein a write to a single vCPU is broadcasted to all vCPUs
within a VM.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 22 ++++++++
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arch_timer.c             | 68 ++++++++++++++++++++++++-
 3 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index b46d5f742e69..7b57cba3416a 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -139,6 +139,28 @@ configured values on other VCPUs.  Userspace should configure the interrupt
 numbers on at least one VCPU after creating all VCPUs and before running any
 VCPUs.
 
+2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
+------------------------------------------------
+
+:Parameters: Pointer to a 64-bit unsigned counter-timer offset.
+
+Returns:
+
+	 ======= ======================================
+	 -EFAULT Error reading/writing the provided
+	 	 parameter address
+	 -ENXIO  Attribute not supported
+	 ======= ======================================
+
+Specifies the guest's virtual counter-timer offset from the host's
+virtual counter. The guest's virtual counter is then derived by
+the following equation:
+
+  guest_cntvct = host_cntvct - KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
+
+KVM does not allow the use of varying offset values for different vCPUs;
+the last written offset value will be broadcasted to all vCPUs in a VM.
+
 3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
 ==================================
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..008d0518d2b1 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -365,6 +365,7 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER	2
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3df67c127489..d2b1b13af658 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1305,7 +1305,7 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
 	}
 }
 
-int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+int kvm_arm_timer_set_attr_irq(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	int __user *uaddr = (int __user *)(long)attr->addr;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
@@ -1338,7 +1338,39 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	return 0;
 }
 
-int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	u64 offset;
+
+	if (get_user(offset, uaddr))
+		return -EFAULT;
+
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+		update_vtimer_cntvoff(vcpu, offset);
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
+	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
+		return kvm_arm_timer_set_attr_irq(vcpu, attr);
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+		return kvm_arm_timer_set_attr_offset(vcpu, attr);
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_timer_get_attr_irq(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	int __user *uaddr = (int __user *)(long)attr->addr;
 	struct arch_timer_context *timer;
@@ -1359,11 +1391,43 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	return put_user(irq, uaddr);
 }
 
+int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	struct arch_timer_context *timer;
+	u64 offset;
+
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+		timer = vcpu_vtimer(vcpu);
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	offset = timer_get_offset(timer);
+	return put_user(offset, uaddr);
+}
+
+int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
+	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
+		return kvm_arm_timer_get_attr_irq(vcpu, attr);
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+		return kvm_arm_timer_get_attr_offset(vcpu, attr);
+	}
+
+	return -ENXIO;
+}
+
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
+	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
 		return 0;
 	}
 
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

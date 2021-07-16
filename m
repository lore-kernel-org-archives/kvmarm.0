Return-Path: <SRS0=U254=MI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90120C6377C
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 21:26:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44970613F6
	for <kvmarm@archiver.kernel.org>; Fri, 16 Jul 2021 21:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44970613F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6594B0D3;
	Fri, 16 Jul 2021 17:26:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yt7gwdMJGN1B; Fri, 16 Jul 2021 17:26:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAE864B0E4;
	Fri, 16 Jul 2021 17:26:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8842549E5F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 17:26:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ED4X5YgJRA0O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Jul 2021 17:26:43 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E1524B0C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 17:26:43 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 m14-20020a5d898e0000b02904f7957d92b5so6842417iol.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jul 2021 14:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=G0sqE4QE+QI2i1u4g2AfnJStaFM+KwHtrxz1AZ/h5tg=;
 b=ZfMXy9DyS4/A0gZDb255CmZRdDffflLwCBKvyMhX5wqVLKSEtBrEQS746xvb2oBHA0
 cj4XharNtW/izBp1TJS3/+CC6TAT4/V0WXqLKxwmJom0yakyq6D0o89WRGS2hvSH6KDw
 k9cv0YLSEDhgajibvef99woxkH+ubblAUBiaW2pWCA/zjqwkBwvoqxgVv+nxUcyXWiX+
 LbtjYBL6tcSu8ORVKYU6eOwOYvwzBi8QV7HFPtunJSOI3UEwqGsL7x2RNBMXb1vUrqKR
 5hacA6UlMd5NF7c7XTlAGO8kQ9BUed5j6XHciSfpe+/aAk1VoSi7pScEmbqNT6co6Kkf
 rQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=G0sqE4QE+QI2i1u4g2AfnJStaFM+KwHtrxz1AZ/h5tg=;
 b=ersg1QbG3fKicNcSiJXX22zcZEwlwSmXJdw3rb1iHhppl9Wc6mUfswpCpTKtiKI/Dh
 n1HjAKbXwZgpND0wtvcMG5DSdwwuJSaCs9tUreTK+MymCeEQQV84r/uUqoQ8qgeT/O3S
 hI1BVS9Sla38lCtqZQKIbfvqv7112W59izUigrXuhohGyatThCFfVFwzx0wuwSAUHws5
 OTNzTD3jTNwUR7XByFYAlr+c0u/5XOKBDr2DwQnvjkpVzWsd/FfpfaT8LJamoCV958iX
 zDvMKz47rgBmfI4biSNZSJgYQSUy0xaduLRnDwAGpVQu8D28TrDFPhKZCTCnbrtPL5E+
 /PQA==
X-Gm-Message-State: AOAM531lqBWElq71ckGZ6MqLHK1Ad2isEU8mBicTd+dC3fyJmWuZZReF
 DTW7ykp1amolm4+J1QoIPspB59i59EQ=
X-Google-Smtp-Source: ABdhPJw3bhsyCdmbrH4NHhe5U+Lu64+JtIDd5EYWnLBhLx6mU/J+kMPc2hK7380eFiQyTV58W5AUnj2kS9U=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:87d0:: with SMTP id
 q16mr8960110ios.109.1626470802830; 
 Fri, 16 Jul 2021 14:26:42 -0700 (PDT)
Date: Fri, 16 Jul 2021 21:26:20 +0000
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Message-Id: <20210716212629.2232756-4-oupton@google.com>
Mime-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 03/12] KVM: x86: Expose TSC offset controls to userspace
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Oliver Upton <oupton@gooogle.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

To date, VMM-directed TSC synchronization and migration has been a bit
messy. KVM has some baked-in heuristics around TSC writes to infer if
the VMM is attempting to synchronize. This is problematic, as it depends
on host userspace writing to the guest's TSC within 1 second of the last
write.

A much cleaner approach to configuring the guest's views of the TSC is to
simply migrate the TSC offset for every vCPU. Offsets are idempotent,
and thus not subject to change depending on when the VMM actually
reads/writes values from/to KVM. The VMM can then read the TSC once with
KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
the guest is paused.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Oliver Upton <oupton@gooogle.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/include/uapi/asm/kvm.h |   4 +
 arch/x86/kvm/x86.c              | 166 ++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e527d7259415..45134b7b14d6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1070,6 +1070,7 @@ struct kvm_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
 	u32 last_tsc_khz;
+	u64 last_tsc_offset;
 	u64 cur_tsc_nsec;
 	u64 cur_tsc_write;
 	u64 cur_tsc_offset;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a6c327f8ad9e..0b22e1e84e78 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -503,4 +503,8 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+/* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
+#define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
+#define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e1b7c8b67428..d22de0a1988a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2411,6 +2411,11 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
 	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
 }
 
+static u64 kvm_vcpu_read_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.l1_tsc_offset;
+}
+
 static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier)
 {
 	vcpu->arch.l1_tsc_scaling_ratio = l1_multiplier;
@@ -2467,6 +2472,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = tsc;
 	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
+	kvm->arch.last_tsc_offset = offset;
 
 	vcpu->arch.last_guest_tsc = tsc;
 
@@ -4914,6 +4920,136 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	int r;
+
+	switch (attr->attr) {
+	case KVM_VCPU_TSC_OFFSET:
+		r = 0;
+		break;
+	default:
+		r = -ENXIO;
+	}
+
+	return r;
+}
+
+static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	void __user *uaddr = (void __user *)attr->addr;
+	int r;
+
+	switch (attr->attr) {
+	case KVM_VCPU_TSC_OFFSET: {
+		u64 offset;
+
+		offset = kvm_vcpu_read_tsc_offset(vcpu);
+		r = -EFAULT;
+		if (copy_to_user(uaddr, &offset, sizeof(offset)))
+			break;
+
+		r = 0;
+	}
+	default:
+		r = -ENXIO;
+	}
+
+	return r;
+}
+
+static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	void __user *uaddr = (void __user *)attr->addr;
+	struct kvm *kvm = vcpu->kvm;
+	int r;
+
+	switch (attr->attr) {
+	case KVM_VCPU_TSC_OFFSET: {
+		u64 offset, tsc, ns;
+		unsigned long flags;
+		bool matched;
+
+		r = -EFAULT;
+		if (copy_from_user(&offset, uaddr, sizeof(offset)))
+			break;
+
+		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+
+		matched = (vcpu->arch.virtual_tsc_khz &&
+			   kvm->arch.last_tsc_khz == vcpu->arch.virtual_tsc_khz &&
+			   kvm->arch.last_tsc_offset == offset);
+
+		tsc = kvm_scale_tsc(vcpu, rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
+		ns = get_kvmclock_base_ns();
+
+		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
+		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
+
+		r = 0;
+		break;
+	}
+	default:
+		r = -ENXIO;
+	}
+
+	return r;
+}
+
+static int kvm_vcpu_ioctl_has_device_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	int r;
+
+	switch (attr->group) {
+	case KVM_VCPU_TSC_CTRL:
+		r = kvm_arch_tsc_has_attr(vcpu, attr);
+		break;
+	default:
+		r = -ENXIO;
+		break;
+	}
+
+	return r;
+}
+
+static int kvm_vcpu_ioctl_get_device_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	int r;
+
+	switch (attr->group) {
+	case KVM_VCPU_TSC_CTRL:
+		r = kvm_arch_tsc_get_attr(vcpu, attr);
+		break;
+	default:
+		r = -ENXIO;
+		break;
+	}
+
+	return r;
+}
+
+static int kvm_vcpu_ioctl_set_device_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	int r;
+
+	switch (attr->group) {
+	case KVM_VCPU_TSC_CTRL:
+		r = kvm_arch_tsc_set_attr(vcpu, attr);
+		break;
+	default:
+		r = -ENXIO;
+		break;
+	}
+
+	return r;
+}
+
 static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				     struct kvm_enable_cap *cap)
 {
@@ -5368,6 +5504,36 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = __set_sregs2(vcpu, u.sregs2);
 		break;
 	}
+	case KVM_HAS_DEVICE_ATTR: {
+		struct kvm_device_attr attr;
+
+		r = -EFAULT;
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			goto out;
+
+		r = kvm_vcpu_ioctl_has_device_attr(vcpu, &attr);
+		break;
+	}
+	case KVM_GET_DEVICE_ATTR: {
+		struct kvm_device_attr attr;
+
+		r = -EFAULT;
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			goto out;
+
+		r = kvm_vcpu_ioctl_get_device_attr(vcpu, &attr);
+		break;
+	}
+	case KVM_SET_DEVICE_ATTR: {
+		struct kvm_device_attr attr;
+
+		r = -EFAULT;
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			goto out;
+
+		r = kvm_vcpu_ioctl_set_device_attr(vcpu, &attr);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

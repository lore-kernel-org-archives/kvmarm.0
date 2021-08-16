Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA58C432BE
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:11:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5AC46613A2
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:11:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5AC46613A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ED6A4B0E6;
	Sun, 15 Aug 2021 20:11:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0wnqw2cbMbIX; Sun, 15 Aug 2021 20:11:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1284B0ED;
	Sun, 15 Aug 2021 20:11:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E15894B0CC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:11:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Eeo3x5rb2zk for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:11:35 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB9B04B0B6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:11:35 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 c16-20020a92cf500000b02902243aec7e27so5601551ilr.22
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=J0lJJJkW+NmZlpb6fpFofwzCF2N0YPn/fE7VW8sEN0E=;
 b=onMRm+c0TmbvvH91s8krImCv1CKEk4b274WYjrqgKk7gKLOUw9VrXJClkZ1DmSna/8
 3tepivV3mzLKvagWxhpO+/WQdfkPceIPNKfBb2bGq51hsXJu/WQCIkjs874UB7dk0W9W
 oXAUvi79qPx6l8QqPRpDusbWhyXuCw7E1AogPxUA0fgJz83AKxK+/O+IR3aKYsxFeqZM
 JjNSmzkGS23X+RekEHj1AacWn1arDI/RxjwhBttOKfWKf9+zoiG8nYGaSZvEuGaZs74t
 Vs8UyftyhM2f38KfhifByPOjskfYoVIv781b+80yLp+3M+udeuw+Zi4uFZAtu/XHAmkx
 u6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=J0lJJJkW+NmZlpb6fpFofwzCF2N0YPn/fE7VW8sEN0E=;
 b=XPeIZgZUdBXqZZMg8Ly+dxbObwsWiF9UcW1kT2XcCV+DRX4IgZPran1BCayHcmXPEm
 M4CZPmWOu6JffaakVoZX/MBfg4xOM0SLDXqCMGgrk1R2R/O6LXJ/pvQxcSmttx3LlHwU
 +uI1weSIslYh206G4Wdlz2+JYzLfwwAj1DCFbCuzFqswHer9LHyUUk/4O59q/sErIkhy
 HQhFhZjQWYpVohl8Cn4qpC3Kv0t8OPF2Mf8MwLVE64PI+dOdW8e0hEz9QgOaADnbG1xk
 Z1OeS3Pl42/jZ9pQYzzfr+ytqmrF28IgKr31F8oeEd5yjJYMgEzJv2it2X5KouYCYXxZ
 owmQ==
X-Gm-Message-State: AOAM531IMSHEbB1wm5O/Ik+ZnbGE6x0twfS/nLj5OopbHcIncu4gMv7h
 E1gAZo76kM5z54w0oKMQM3CVYHLNDDs=
X-Google-Smtp-Source: ABdhPJw09eGgNy3EXbjdqGFxxJgFJV5YrUuGjNKkF5zMC9eqOSxrLDgPkbJpMCJxluIG+Ci2XveMUkYVc70=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:cd09:: with SMTP id
 g9mr12684753jaq.87.1629072695306; 
 Sun, 15 Aug 2021 17:11:35 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:11:25 +0000
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Message-Id: <20210816001130.3059564-2-oupton@google.com>
Mime-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 1/6] KVM: x86: Fix potential race in KVM_GET_CLOCK
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
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

Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
outside of the pvclock sync lock. This is problematic, as the clock
value written to the user may or may not actually correspond to a stable
TSC.

Fix the race by populating the entire kvm_clock_data structure behind
the pvclock_gtod_sync_lock.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fdc0c18339fb..2f3929bd5f58 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2787,19 +2787,20 @@ static void kvm_update_masterclock(struct kvm *kvm)
 	kvm_end_pvclock_update(kvm);
 }
 
-u64 get_kvmclock_ns(struct kvm *kvm)
+static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 {
 	struct kvm_arch *ka = &kvm->arch;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned long flags;
-	u64 ret;
 
 	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	if (!ka->use_master_clock) {
 		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-		return get_kvmclock_base_ns() + ka->kvmclock_offset;
+		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
+		return;
 	}
 
+	data->flags |= KVM_CLOCK_TSC_STABLE;
 	hv_clock.tsc_timestamp = ka->master_cycle_now;
 	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
 	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
@@ -2811,13 +2812,26 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
 				   &hv_clock.tsc_shift,
 				   &hv_clock.tsc_to_system_mul);
-		ret = __pvclock_read_cycles(&hv_clock, rdtsc());
-	} else
-		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
+		data->clock = __pvclock_read_cycles(&hv_clock, rdtsc());
+	} else {
+		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
+	}
 
 	put_cpu();
+}
 
-	return ret;
+u64 get_kvmclock_ns(struct kvm *kvm)
+{
+	struct kvm_clock_data data;
+
+	/*
+	 * Zero flags as it's accessed RMW, leave everything else uninitialized
+	 * as clock is always written and no other fields are consumed.
+	 */
+	data.flags = 0;
+
+	get_kvmclock(kvm, &data);
+	return data.clock;
 }
 
 static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
@@ -6098,11 +6112,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 	case KVM_GET_CLOCK: {
 		struct kvm_clock_data user_ns;
-		u64 now_ns;
 
-		now_ns = get_kvmclock_ns(kvm);
-		user_ns.clock = now_ns;
-		user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
+		/*
+		 * Zero flags as it is accessed RMW, leave everything else
+		 * uninitialized as clock is always written and no other fields
+		 * are consumed.
+		 */
+		user_ns.flags = 0;
+		get_kvmclock(kvm, &user_ns);
 		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
 
 		r = -EFAULT;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

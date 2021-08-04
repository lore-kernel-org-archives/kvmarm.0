Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F50C43216
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56C6161029
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 56C6161029
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE4084A193;
	Wed,  4 Aug 2021 04:58:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BiM+rdbF1ejL; Wed,  4 Aug 2021 04:58:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FD484A2E5;
	Wed,  4 Aug 2021 04:58:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BE914086C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gHCs30A2JqrS for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:36 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F76040856
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:36 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 v16-20020a0562140510b029032511e85975so1258117qvw.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9z0ILel/nmHkGUMptTPmpCG4j9f031MAvczP47Mkt78=;
 b=AGG526CClu6IqHFTOxS7+h3HvPWXLqKYwyxWDqhy8O1Cl7kRhpnrrXFTY0kzLPlJzo
 NTLuHbzcLYaYfAWrM32xY1DL6EHrQH4/2lErBCn8/ZGON8Be4/Pp9eWnRrHfI5ABkk+e
 cUAX5/1tP6hG7xgE0KZ69uOsXKCWECXSJndhcqwqutNTyGslSd/lvGhdMfdY1YZV67+W
 DWELveZd0WTMUmICxJLUctfDxryaN/y9+D66dBcuvb4CitoE5kvYTWemb+5QNRxgHI0j
 rWPx8EeySutkqhAJYHR/vC6ZOVzwZ3vF7onQk6tkqzA+Opb0I7MhtY7K0lwaz97Zb10g
 jtsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9z0ILel/nmHkGUMptTPmpCG4j9f031MAvczP47Mkt78=;
 b=YUno83JjnODcBAzKKtyb2UoG/jIwHPTrg+VQLHxgeV6jOnCYf/rmx8h8A2j8BHSKo2
 ZEmCwyDXzKZnit++9vMtpTx0Ip3+zdJpNQFZ+sJ+wWgmOns91dYFOhn85QWYmp5WuQKg
 fohx55iT00C3sgCDDwlv0M7hQe659B83weKQO6+yWFf9KHKy+M9NbJYEXgv3ZAY0hD9s
 kakzE8DJ7jrwr5hQr0C17JESzRAtjMnlm4sfhNGL2iv3q0gcr9KKg4dd4G0CJDbqlYWR
 6QVDT5B6Ttjy91MVVJ7E9AohUkEOYOM55Z6F/0fo5lf/2QCdX9k0c3qCyEeYWQsqgG57
 xeJg==
X-Gm-Message-State: AOAM5335rW/zjYaSEXexRdnQpV4LwsrlPz2UmZkxry6L9Vi5ljxAek9T
 Fan3469icJLw99rcfa72nN8cIYPkkRc=
X-Google-Smtp-Source: ABdhPJzxzqd5PN7eP88ZrBpXcJ5Qw54s+lcbwp2wfv6KXhmpgwkZOP22ITfr7gZ3p1xKgG6E9IZ8pxMUSks=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:332:: with SMTP id
 j18mr25863430qvu.21.1628067515916; Wed, 04 Aug 2021 01:58:35 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:57:59 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-2-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 01/21] KVM: x86: Fix potential race in KVM_GET_CLOCK
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
index 8cdf4ac6990b..34287c522f4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2782,19 +2782,20 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 #endif
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
@@ -2806,13 +2807,26 @@ u64 get_kvmclock_ns(struct kvm *kvm)
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
@@ -6104,11 +6118,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

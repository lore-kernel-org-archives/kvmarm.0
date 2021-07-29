Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEE9C43216
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 17:33:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C00A60E9B
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 17:33:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C00A60E9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3D6E4B0FB;
	Thu, 29 Jul 2021 13:33:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8QD8n3QYxefp; Thu, 29 Jul 2021 13:33:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1B084B0FC;
	Thu, 29 Jul 2021 13:33:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 141C14031F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:33:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r+kuz74EiWTg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 13:33:05 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B5E840569
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:33:05 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 u22-20020a5d9f560000b02905058dc6c376so4245918iot.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 10:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=weNf/XPBmVJrtvgRhD9BQ73yTxcNYXlLA/pyskKzHLk=;
 b=I3N/L1H7Zv/MCP4Lsn+UfvH142+iPABwy82HpjfDVuALxhYBoLLNX9H3aGk+Vs93HU
 BmgrzdDQcdqvB2JeJfygZAyQDjYwQmce0RDl7ZWlSs6L9oDkwx4z+ACNSwLb9k6dHU85
 LOVRQPBGuLfX+AwCzlq8H11s/IgHVypOk5GDlRX4S4b5vsPOvR16GUhL7PsGlx6fUBfb
 nQ/budrTy42num29uf4V0N9FROsMqBNZvXYw/kBDfyh9jum/rS2+ZVHJZnkfoymFNkxf
 7Utmx8w0M6Xtco9x0DchhUnUqSeNiW+MwIybwELdCiH6Aoc8/afHcWNXRQH74A6UozKk
 MJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=weNf/XPBmVJrtvgRhD9BQ73yTxcNYXlLA/pyskKzHLk=;
 b=j3OZX+6iF3rqULiCu/Btv7jCDUwe7eu6M5z7K1NixPErh/igGp8KtAI2EyhR7RiH9g
 ESTSXbu2KyxtL1dsc8fPEvUGKqK3HE3CvPTqMlRXOSZ/Md9YMozJx1wF7UTqOKxEdydz
 YYF9B2ryiwpEjT4TmAloVAOXPfqWnx3NHJdgt3qFkPbjYVmMeX6+4zMKd6g+JBN5HMoc
 eEQszVrSnbV0O/XvbqtNMWBtLiF9yf1SMcGrPjrswgx3Av8P1ZdwEfjE4waAeEzNSzo6
 GngJOp5Zk/JfQNKe83hRYk2bKx9US6GM3hsg14LdRE70LKoXhm+0ORa7ZlmJMOzk34ot
 WWKA==
X-Gm-Message-State: AOAM530VDBEI5s0YxMoy015sW/ZuPMn4oee7YGDFu28mP9nTW6W6QpLw
 RsgQyaYkUU2ewQYEdNLoodyPUMDhyNo=
X-Google-Smtp-Source: ABdhPJzhpnf+X5tcLvNFVqG+t9Eau8TItNNh5G7nN1k1y3UZ50vZT16T2VWIaQ1hPRIT7mKl+NLSRFy8vGA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:8484:: with SMTP id
 t4mr2743929iom.126.1627579984938; 
 Thu, 29 Jul 2021 10:33:04 -0700 (PDT)
Date: Thu, 29 Jul 2021 17:32:48 +0000
In-Reply-To: <20210729173300.181775-1-oupton@google.com>
Message-Id: <20210729173300.181775-2-oupton@google.com>
Mime-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v5 01/13] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
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

Handling the migration of TSCs correctly is difficult, in part because
Linux does not provide userspace with the ability to retrieve a (TSC,
realtime) clock pair for a single instant in time. In lieu of a more
convenient facility, KVM can report similar information in the kvm_clock
structure.

Provide userspace with a host TSC & realtime pair iff the realtime clock
is based on the TSC. If userspace provides KVM_SET_CLOCK with a valid
realtime value, advance the KVM clock by the amount of elapsed time. Do
not step the KVM clock backwards, though, as it is a monotonic
oscillator.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst  |  42 +++++++--
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/x86.c              | 149 ++++++++++++++++++++------------
 include/uapi/linux/kvm.h        |   7 +-
 4 files changed, 137 insertions(+), 64 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index dae68e68ca23..8d4a3471ad9e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -993,20 +993,34 @@ such as migration.
 When KVM_CAP_ADJUST_CLOCK is passed to KVM_CHECK_EXTENSION, it returns the
 set of bits that KVM can return in struct kvm_clock_data's flag member.
 
-The only flag defined now is KVM_CLOCK_TSC_STABLE.  If set, the returned
-value is the exact kvmclock value seen by all VCPUs at the instant
-when KVM_GET_CLOCK was called.  If clear, the returned value is simply
-CLOCK_MONOTONIC plus a constant offset; the offset can be modified
-with KVM_SET_CLOCK.  KVM will try to make all VCPUs follow this clock,
-but the exact value read by each VCPU could differ, because the host
-TSC is not stable.
+FLAGS:
+
+KVM_CLOCK_TSC_STABLE.  If set, the returned value is the exact kvmclock
+value seen by all VCPUs at the instant when KVM_GET_CLOCK was called.
+If clear, the returned value is simply CLOCK_MONOTONIC plus a constant
+offset; the offset can be modified with KVM_SET_CLOCK.  KVM will try
+to make all VCPUs follow this clock, but the exact value read by each
+VCPU could differ, because the host TSC is not stable.
+
+KVM_CLOCK_REALTIME.  If set, the `realtime` field in the kvm_clock_data
+structure is populated with the value of the host's real time
+clocksource at the instant when KVM_GET_CLOCK was called. If clear,
+the `realtime` field does not contain a value.
+
+KVM_CLOCK_HOST_TSC.  If set, the `host_tsc` field in the kvm_clock_data
+structure is populated with the value of the host's timestamp counter (TSC)
+at the instant when KVM_GET_CLOCK was called. If clear, the `host_tsc` field
+does not contain a value.
 
 ::
 
   struct kvm_clock_data {
 	__u64 clock;  /* kvmclock current value */
 	__u32 flags;
-	__u32 pad[9];
+	__u32 pad0;
+	__u64 realtime;
+	__u64 host_tsc;
+	__u32 pad[4];
   };
 
 
@@ -1023,12 +1037,22 @@ Sets the current timestamp of kvmclock to the value specified in its parameter.
 In conjunction with KVM_GET_CLOCK, it is used to ensure monotonicity on scenarios
 such as migration.
 
+FLAGS:
+
+KVM_CLOCK_REALTIME.  If set, KVM will compare the value of the `realtime` field
+with the value of the host's real time clocksource at the instant when
+KVM_SET_CLOCK was called. The difference in elapsed time is added to the final
+kvmclock value that will be provided to guests.
+
 ::
 
   struct kvm_clock_data {
 	__u64 clock;  /* kvmclock current value */
 	__u32 flags;
-	__u32 pad[9];
+	__u32 pad0;
+	__u64 realtime;
+	__u64 host_tsc;
+	__u32 pad[4];
   };
 
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 99f37781a6fc..65a20c64f959 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1932,4 +1932,7 @@ int kvm_cpu_dirty_log_size(void);
 
 int alloc_all_memslots_rmaps(struct kvm *kvm);
 
+#define KVM_CLOCK_VALID_FLAGS						\
+	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 916c976e99ab..e052c7afaac4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2782,17 +2782,24 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 #endif
 }
 
-u64 get_kvmclock_ns(struct kvm *kvm)
+/*
+ * Returns true if realtime and TSC values were written back to the caller.
+ * Returns false if a clock triplet cannot be obtained, such as if the host's
+ * realtime clock is not based on the TSC.
+ */
+static bool get_kvmclock_and_realtime(struct kvm *kvm, u64 *kvmclock_ns,
+				      u64 *realtime_ns, u64 *tsc)
 {
 	struct kvm_arch *ka = &kvm->arch;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned long flags;
-	u64 ret;
+	bool ret = false;
 
 	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	if (!ka->use_master_clock) {
 		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-		return get_kvmclock_base_ns() + ka->kvmclock_offset;
+		*kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
+		return false;
 	}
 
 	hv_clock.tsc_timestamp = ka->master_cycle_now;
@@ -2803,18 +2810,36 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	get_cpu();
 
 	if (__this_cpu_read(cpu_tsc_khz)) {
+		struct timespec64 ts;
+		u64 tsc_val;
+
 		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
 				   &hv_clock.tsc_shift,
 				   &hv_clock.tsc_to_system_mul);
-		ret = __pvclock_read_cycles(&hv_clock, rdtsc());
+
+		if (kvm_get_walltime_and_clockread(&ts, &tsc_val)) {
+			*realtime_ns = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
+			*tsc = tsc_val;
+			ret = true;
+		}
+
+		*kvmclock_ns = __pvclock_read_cycles(&hv_clock, tsc_val);
 	} else
-		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
+		*kvmclock_ns = get_kvmclock_base_ns() + ka->kvmclock_offset;
 
 	put_cpu();
 
 	return ret;
 }
 
+u64 get_kvmclock_ns(struct kvm *kvm)
+{
+	u64 kvmclock_ns, realtime_ns, tsc;
+
+	get_kvmclock_and_realtime(kvm, &kvmclock_ns, &realtime_ns, &tsc);
+	return kvmclock_ns;
+}
+
 static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
 				   struct gfn_to_hva_cache *cache,
 				   unsigned int offset)
@@ -4033,7 +4058,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_SYNC_X86_VALID_FIELDS;
 		break;
 	case KVM_CAP_ADJUST_CLOCK:
-		r = KVM_CLOCK_TSC_STABLE;
+		r = KVM_CLOCK_VALID_FLAGS;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
 		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
@@ -5820,6 +5845,68 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 }
 #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
 
+static int kvm_vm_ioctl_get_clock(struct kvm *kvm,
+				  void __user *argp)
+{
+	struct kvm_clock_data data;
+
+	memset(&data, 0, sizeof(data));
+
+	if (get_kvmclock_and_realtime(kvm, &data.clock, &data.realtime,
+				      &data.host_tsc))
+		data.flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
+
+	if (kvm->arch.use_master_clock)
+		data.flags |= KVM_CLOCK_TSC_STABLE;
+
+	if (copy_to_user(argp, &data, sizeof(data)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_vm_ioctl_set_clock(struct kvm *kvm,
+				  void __user *argp)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	struct kvm_clock_data data;
+	u64 now_raw_ns;
+
+	if (copy_from_user(&data, argp, sizeof(data)))
+		return -EFAULT;
+
+	if (data.flags & ~KVM_CLOCK_REALTIME)
+		return -EINVAL;
+
+	/*
+	 * TODO: userspace has to take care of races with VCPU_RUN, so
+	 * kvm_gen_update_masterclock() can be cut down to locked
+	 * pvclock_update_vm_gtod_copy().
+	 */
+	kvm_gen_update_masterclock(kvm);
+
+	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+	if (data.flags & KVM_CLOCK_REALTIME) {
+		u64 now_real_ns = ktime_get_real_ns();
+
+		/*
+		 * Avoid stepping the kvmclock backwards.
+		 */
+		if (now_real_ns > data.realtime)
+			data.clock += now_real_ns - data.realtime;
+	}
+
+	if (ka->use_master_clock)
+		now_raw_ns = ka->master_kernel_ns;
+	else
+		now_raw_ns = get_kvmclock_base_ns();
+	ka->kvmclock_offset = data.clock - now_raw_ns;
+	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
+	return 0;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -6064,57 +6151,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 #endif
 	case KVM_SET_CLOCK: {
-		struct kvm_arch *ka = &kvm->arch;
-		struct kvm_clock_data user_ns;
-		u64 now_ns;
-
-		r = -EFAULT;
-		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
-			goto out;
-
-		r = -EINVAL;
-		if (user_ns.flags)
-			goto out;
-
-		r = 0;
-		/*
-		 * TODO: userspace has to take care of races with VCPU_RUN, so
-		 * kvm_gen_update_masterclock() can be cut down to locked
-		 * pvclock_update_vm_gtod_copy().
-		 */
-		kvm_gen_update_masterclock(kvm);
-
-		/*
-		 * This pairs with kvm_guest_time_update(): when masterclock is
-		 * in use, we use master_kernel_ns + kvmclock_offset to set
-		 * unsigned 'system_time' so if we use get_kvmclock_ns() (which
-		 * is slightly ahead) here we risk going negative on unsigned
-		 * 'system_time' when 'user_ns.clock' is very small.
-		 */
-		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
-		if (kvm->arch.use_master_clock)
-			now_ns = ka->master_kernel_ns;
-		else
-			now_ns = get_kvmclock_base_ns();
-		ka->kvmclock_offset = user_ns.clock - now_ns;
-		spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
-
-		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
+		r = kvm_vm_ioctl_set_clock(kvm, argp);
 		break;
 	}
 	case KVM_GET_CLOCK: {
-		struct kvm_clock_data user_ns;
-		u64 now_ns;
-
-		now_ns = get_kvmclock_ns(kvm);
-		user_ns.clock = now_ns;
-		user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
-		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
-
-		r = -EFAULT;
-		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
-			goto out;
-		r = 0;
+		r = kvm_vm_ioctl_get_clock(kvm, argp);
 		break;
 	}
 	case KVM_MEMORY_ENCRYPT_OP: {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..53a49cb8616a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1223,11 +1223,16 @@ struct kvm_irqfd {
 
 /* Do not use 1, KVM_CHECK_EXTENSION returned it before we had flags.  */
 #define KVM_CLOCK_TSC_STABLE		2
+#define KVM_CLOCK_REALTIME		(1 << 2)
+#define KVM_CLOCK_HOST_TSC		(1 << 3)
 
 struct kvm_clock_data {
 	__u64 clock;
 	__u32 flags;
-	__u32 pad[9];
+	__u32 pad0;
+	__u64 realtime;
+	__u64 host_tsc;
+	__u32 pad[4];
 };
 
 /* For KVM_CAP_SW_TLB */
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D10F111B1
	for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710866657; cv=none; b=aYS4MiUyx8Td0YpmRDrFpZJY/6Nd2IdLm+fb65QEAvuToV/pt6LOzN4XyqEcE0+unuPaEdEOZLl/ylO65U2/bh4NJy7CNtMGZnZ2DQkxzmPIR/F1PBbGSk7EABIyWsMPglE5Jg2F/B8V580tzQhIc4nnQ5n/AiMRgXmXZv2o10I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710866657; c=relaxed/simple;
	bh=+n/b8fA9MMXRAFLGykf1jkNKxKU7ByBWxVaJX4iqWpY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uzymfsXTnE7P7Qn+gy63cw/MJCyRgy8AsinZzph0FPpJpn4y/V5HfO2YJtxV3ocRN1F80L4hUs98wxmD+qqQ2lGg1aU7phrtgBTuUo937SXwjwYNSqghON0f1M/XXDBLGiGqndkPkMuquGlayfwTiKdBVybztysZB6tl3Dyy708=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t4VVRCU7; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t4VVRCU7"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7c75dee76c0so2378239f.1
        for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 09:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710866655; x=1711471455; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=55tADTKr/fKtx+P9Mx3gQHhaNaSTbLjPsk1QuvUf7uI=;
        b=t4VVRCU7sugskQGsh2qE9nLL5JgR5s/9T4evr7LV5eawzKUVzvo3EqERo+PjrT6pTt
         lt+gpwHvZ+slnYQzybo39HnQMVimdzlMgbdifFgPwQkLDb2TgOUkkso+VNEXm6wGgspv
         iO7PjnOs3fXyXN7P30Q4W+do/Fd8uXS/TV4uZzNO7xkGJWoVEcXdNJAMuJHrEIcmQ7JU
         psUled0k/8RNvY5Vye3Q9ofbpFntHiAE0z/Cae/fhELZzOGRql0oGprhwaPM5KfCOtz5
         0bzLU+V1PZagFsJLSsr5C4b+7xEPoUKb+pLDy6q4dxtSQgK1ccLy4UPeCMEMTdTem9Ea
         vzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710866655; x=1711471455;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=55tADTKr/fKtx+P9Mx3gQHhaNaSTbLjPsk1QuvUf7uI=;
        b=XM8mat0++v4dq+GhFp/PLarKoKzhSVbjCiZyxAzYfnkTa7t4RjKNpRQYXd1O+rmZaC
         Jgz+mxytS9uDREHwtj+ogNpea0R4p2HVifwTVWQquO0KrK16yFuCTzd6SXpZV5RKyit5
         RYqXoncJ2TMLVK6nqtoCS73sQEl6OB+whgEO0Pn2/AtJ1JfcowPZ/b9qs7UHIDh4F2aZ
         423IKgTkrpQNYyaqgO+Hfh80mXJi1un8xsaNDCR74iJMfWPWu2MnaauVBo8HKnyVBXzc
         Q20okn5xipCB7o4Ol+0os6V07gdEhI08JqC5GE+HDtVbJow2PtGwISjBpvhPQ2y51zvT
         5M7g==
X-Forwarded-Encrypted: i=1; AJvYcCWZl1sp3AzNc2B9x0lSfWL4XW2u0wNULlNvNhUum5mzHtd9OZhZGRIKJcNgXTK7rgFPcCcxEAvI/PVHbD/xm7zlCgE4b1gp
X-Gm-Message-State: AOJu0YzXVyVltVUfpA6Gmx8gktBee5aK6Mr5YgdFOW4OzS52Oep0su6B
	z8YErUEC6WNE0Ywi56UCgDMR39aO1ULqJS8Y96A9O1at6UBGJ0Zdc3Q/AQ/sD1Mgo/BIeBWvodA
	HIwVoHItogR3n5RbktvL1bQ==
X-Google-Smtp-Source: AGHT+IFRbk7J0ciLHbLLk9I3qhSS1omT3Bl07k9k3e57ZQB+uGmYZ+eVWm/uRTh6ZDfo3t25XVq4gku22P4yF8IxNA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:1491:b0:7c8:264d:5e98 with
 SMTP id a17-20020a056602149100b007c8264d5e98mr145907iow.0.1710866655492; Tue,
 19 Mar 2024 09:44:15 -0700 (PDT)
Date: Tue, 19 Mar 2024 16:43:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240319164341.1674863-1-coltonlewis@google.com>
Subject: [PATCH v2] KVM: arm64: Add KVM_CAP to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a KVM_CAP to control WFx (WFI or WFE) trapping based on scheduler
runqueue depth. This is so they can be passed through if the runqueue
is shallow or the CPU has support for direct interrupt injection. They
may be always trapped by setting this value to 0. Technically this
means traps will be cleared when the runqueue depth is 0, but that
implies nothing is running anyway so there is no reason to care. The
default value is 1 to preserve previous behavior before adding this
option.

Think about his option as a threshold. The instruction will be trapped
if the runqueue depth is higher than the threshold.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

v2:
The last version was exclusively a flag to enable unconditional wfx
passthrough but there was feedback to make passthrough/trapping depend
on runqueue depth. I asked the last thread if there were any
preferences for the interface to accomplish this but I figured it's
easier to show code than wait for people telling me what to do.

v1:
https://lore.kernel.org/kvmarm/20240129213918.3124494-1-coltonlewis@google.com/

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  7 ++++++-
 include/linux/sched/stat.h        |  1 +
 include/uapi/linux/kvm.h          |  2 +-
 kernel/sched/core.c               | 15 +++++++++++++--
 5 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..79f461efaa6c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -317,6 +317,7 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+	u64 wfx_trap_runqueue_depth;
 };

 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..419eed6e1814 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -116,6 +116,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_ARM_WFX_TRAP_RUNQUEUE_DEPTH:
+		kvm->arch.wfx_trap_runqueue_depth = cap->args[0];
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -176,6 +179,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)

 	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);

+	kvm->arch.wfx_trap_runqueue_depth = 1;
 	return 0;

 err_free_cpumask:
@@ -240,6 +244,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_ARM_WFX_TRAP_RUNQUEUE_DEPTH:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -456,7 +461,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);

-	if (single_task_running())
+	if (nr_running_this_cpu() <= vcpu->kvm->arch.wfx_trap_runqueue_depth)
 		vcpu_clear_wfx_traps(vcpu);
 	else
 		vcpu_set_wfx_traps(vcpu);
diff --git a/include/linux/sched/stat.h b/include/linux/sched/stat.h
index 0108a38bb64d..dc1541fcec56 100644
--- a/include/linux/sched/stat.h
+++ b/include/linux/sched/stat.h
@@ -18,6 +18,7 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned int nr_running(void);
+extern unsigned int nr_running_this_cpu(void);
 extern bool single_task_running(void);
 extern unsigned int nr_iowait(void);
 extern unsigned int nr_iowait_cpu(int cpu);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c3308536482b..4c0ebf514c03 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1155,6 +1155,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_ARM_WFX_TRAP_RUNQUEUE_DEPTH 236

 #ifdef KVM_CAP_IRQ_ROUTING

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9116bcc90346..b18f29964648 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5420,7 +5420,7 @@ unsigned int nr_running(void)
 }

 /*
- * Check if only the current task is running on the CPU.
+ * Return number of tasks running on this CPU.
  *
  * Caution: this function does not check that the caller has disabled
  * preemption, thus the result might have a time-of-check-to-time-of-use
@@ -5432,9 +5432,20 @@ unsigned int nr_running(void)
  *
  * - in a loop with very short iterations (e.g. a polling loop)
  */
+unsigned int nr_running_this_cpu(void)
+{
+	return raw_rq()->nr_running;
+}
+EXPORT_SYMBOL(nr_running_this_cpu);
+
+/*
+ * Check if only the current task is running on the CPU.
+ *
+ * Caution: see warning for nr_running_this_cpu
+ */
 bool single_task_running(void)
 {
-	return raw_rq()->nr_running == 1;
+	return nr_running_this_cpu() == 1;
 }
 EXPORT_SYMBOL(single_task_running);

--
2.44.0.291.gc1ea87d7ee-goog

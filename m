Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C8F24F28
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 23:20:22 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-368994f4bc0so737387b3.14
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 16:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+sxIRPFhQ/bRU1EUsINusyHUfwnJnra57CB3HRbIrGQ=;
        b=jv6dI7qGHV2gUZ3Nk9vOoHe84FBP9TkOY9A9eVQMhtjmGk9u0jlVKDO6SkkJVrwt12
         m0CdSNNgCHma9W4plIHPNP31YE0isW6rHxg8SLzN06JNj7B4eH/JVFDKLvwVk+pTrSfc
         cd1f3arotAsI9PLIVZ+gM5iOHqG0gkQonoBeG+igtzlakyKPUg7bVk8HEG4Qt0gpuy/J
         SANWh5EPPIcvcI1b1i5q00zNbhYEA45rs8BxPx1RbxWAx78g+tAqKNfe3EdC5ZhIPY91
         Xb4J0zHYKnAPUlNccijsQBbbLfGEdn+GfBR6MlkOjmTN4KzH5w39TKzZQ1G6FhxzCFCP
         aqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sxIRPFhQ/bRU1EUsINusyHUfwnJnra57CB3HRbIrGQ=;
        b=kzXRABTkuOWAuLhR4EfbrHGsDUjiy8nN04ClbDy1zdYo/rkr52FTB3IzcImXCqMoZc
         8kxKBIJETsi0s7B6ppE9xW6il9jIRbMJRr/qV/Qos17dWhQqgPzimEJvbvXsFdfSYWYl
         xVWP1Xr9UiN8HjtJ+Tb5Z2w3vI6LgtylUDomtq7LPOMrB2OYRwOXiwmG0a+YLoZpXo7v
         MLm1HDU36VS2N6EsKJAon6wdKNXxrTsWKcnZBVTjMY0UPGcOtRFVeOqbucptMOHFQoDD
         qdXr/EuC4A/lTOAukOF/I24L++rmqXDUtYvgrktMKOS+Z4EJl+FtPJiUXIIr47LvosOW
         DRWQ==
X-Gm-Message-State: ACrzQf3IJvt7akhkNG+JlM8MFdPyF7lkQ2VjLZAfABiEyGVCsDR5noFq
	cnujBLNGK5KeXqQG4MabHppRDgoZ92M=
X-Google-Smtp-Source: AMsMyM7Mckg8vSF26OBPsgSvPOkzyFaltg8pOaKtjrHcZ6qZe4t+swUi+9nV+tBPsQQEDVrcX89hWVA+EhE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:80a:b0:36b:6ff3:ee05 with SMTP id
 bx10-20020a05690c080a00b0036b6ff3ee05mr183596ywb.495.1667431220753; Wed, 02
 Nov 2022 16:20:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Nov 2022 23:19:06 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-40-seanjc@google.com>
Subject: [PATCH 39/44] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221102231906.v6WScblHosX4ASPY13I9Uv8PW18yFqOeFCVwCYX-4nY@z>

From: Isaku Yamahata <isaku.yamahata@intel.com>

Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock now
that KVM hooks CPU hotplug during the ONLINE phase, which can sleep.
Previously, KVM hooked the STARTING phase, which is not allowed to sleep
and thus could not take kvm_lock (a mutex).

Explicitly disable preemptions/IRQs in the CPU hotplug paths as needed to
keep arch code happy, e.g. x86 expects IRQs to be disabled during hardware
enabling, and expects preemption to be disabled during hardware disabling.
There are no preemption/interrupt concerns in the hotplug path, i.e. the
extra disabling is done purely to allow x86 to keep its sanity checks,
which are targeted primiarily at the "enable/disable all" paths.

Opportunistically update KVM's locking documentation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst | 18 ++++++------
 virt/kvm/kvm_main.c                | 44 +++++++++++++++++++++---------
 2 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 845a561629f1..4feaf527575b 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -9,6 +9,8 @@ KVM Lock Overview
 
 The acquisition orders for mutexes are as follows:
 
+- cpus_read_lock() is taken outside kvm_lock
+
 - kvm->lock is taken outside vcpu->mutex
 
 - kvm->lock is taken outside kvm->slots_lock and kvm->irq_lock
@@ -29,6 +31,8 @@ The acquisition orders for mutexes are as follows:
 
 On x86:
 
+- kvm_lock is taken outside kvm->mmu_lock
+
 - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
 
 - kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock and
@@ -216,15 +220,11 @@ time it will be set using the Dirty tracking mechanism described above.
 :Type:		mutex
 :Arch:		any
 :Protects:	- vm_list
-
-``kvm_count_lock``
-^^^^^^^^^^^^^^^^^^
-
-:Type:		raw_spinlock_t
-:Arch:		any
-:Protects:	- hardware virtualization enable/disable
-:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
-		migration.
+		- kvm_usage_count
+		- hardware virtualization enable/disable
+		- module probing (x86 only)
+:Comment:	KVM also disables CPU hotplug via cpus_read_lock() during
+		enable/disable.
 
 ``kvm->mn_invalidate_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4e765ef9f4bd..c8d92e6c3922 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -100,7 +100,6 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
  */
 
 DEFINE_MUTEX(kvm_lock);
-static DEFINE_RAW_SPINLOCK(kvm_count_lock);
 LIST_HEAD(vm_list);
 
 static cpumask_var_t cpus_hardware_enabled;
@@ -5028,9 +5027,10 @@ static void hardware_enable_nolock(void *junk)
 
 static int kvm_online_cpu(unsigned int cpu)
 {
+	unsigned long flags;
 	int ret = 0;
 
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 	/*
 	 * Abort the CPU online process if hardware virtualization cannot
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
@@ -5039,13 +5039,16 @@ static int kvm_online_cpu(unsigned int cpu)
 	if (kvm_usage_count) {
 		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
 
+		local_irq_save(flags);
 		hardware_enable_nolock(NULL);
+		local_irq_restore(flags);
+
 		if (atomic_read(&hardware_enable_failed)) {
 			atomic_set(&hardware_enable_failed, 0);
 			ret = -EIO;
 		}
 	}
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	return ret;
 }
 
@@ -5061,10 +5064,13 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	raw_spin_lock(&kvm_count_lock);
-	if (kvm_usage_count)
+	mutex_lock(&kvm_lock);
+	if (kvm_usage_count) {
+		preempt_disable();
 		hardware_disable_nolock(NULL);
-	raw_spin_unlock(&kvm_count_lock);
+		preempt_enable();
+	}
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
@@ -5079,9 +5085,11 @@ static void hardware_disable_all_nolock(void)
 
 static void hardware_disable_all(void)
 {
-	raw_spin_lock(&kvm_count_lock);
+	cpus_read_lock();
+	mutex_lock(&kvm_lock);
 	hardware_disable_all_nolock();
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
 }
 
 static int hardware_enable_all(void)
@@ -5097,7 +5105,7 @@ static int hardware_enable_all(void)
 	 * Disable CPU hotplug to prevent scenarios where KVM sees
 	 */
 	cpus_read_lock();
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
@@ -5110,7 +5118,7 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	cpus_read_unlock();
 
 	return r;
@@ -5716,6 +5724,15 @@ static void kvm_init_debug(void)
 
 static int kvm_suspend(void)
 {
+	/*
+	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
+	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
+	 * is stable.  Assert that kvm_lock is not held as a paranoid sanity
+	 * check that the system isn't suspended when KVM is enabling hardware.
+	 */
+	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_irqs_disabled();
+
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
 	return 0;
@@ -5723,10 +5740,11 @@ static int kvm_suspend(void)
 
 static void kvm_resume(void)
 {
-	if (kvm_usage_count) {
-		lockdep_assert_not_held(&kvm_count_lock);
+	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_irqs_disabled();
+
+	if (kvm_usage_count)
 		hardware_enable_nolock(NULL);
-	}
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.38.1.431.g37b22c650d-goog


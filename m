Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1FFC4332F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:20:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 866564B6CF;
	Wed,  2 Nov 2022 19:20:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hWnkKRE0VcsH; Wed,  2 Nov 2022 19:20:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 009E640B65;
	Wed,  2 Nov 2022 19:20:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 888644B815
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dolsa08O6Aw4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:20:26 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3C9F4B886
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:21 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 k7-20020a256f07000000b006cbcc030bc8so333181ybc.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=YK+gJEmDf0/HaW0Zj8IcEMViymPmstq7gfZNHffU6WwjhC9VE9MYlAm/eiw+aht0it
 xKW/Mg+AI5d58mWkqjFcEMKb4CPbLEKYYZDVuRs/sIVGFkcPMkTf/PJoOj/P1ltdDR9Z
 2eHYTiGyPlZH707jYOTZuj8GjHG7DLRB0GqSWoYc0xBdzLv0++iHZW2l6aQGXZ5ziQCy
 125McekJzL+u9Nc8Et2XowIh2UcA5NiIZrp6Lh8gta9Iftt7DN2M7GLPP/R1u9aq2Qpe
 8QIKlLVEHVFMUXg6KsKt/PPAUy2bkO5KKQdkJiT+V0LwmPsMB8woGEyZSxihHB87KvmF
 YNLw==
X-Gm-Message-State: ACrzQf0W4uvPwlrbrcyLWMlJUg1adauSZBK1zvrujQ6HdW7DQlWnb0n8
 QIsCNgwE3TKvhhrqHIAiWkfUw+yI3/o=
X-Google-Smtp-Source: AMsMyM7Mckg8vSF26OBPsgSvPOkzyFaltg8pOaKtjrHcZ6qZe4t+swUi+9nV+tBPsQQEDVrcX89hWVA+EhE=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:80a:b0:36b:6ff3:ee05 with SMTP id
 bx10-20020a05690c080a00b0036b6ff3ee05mr183596ywb.495.1667431220753; Wed, 02
 Nov 2022 16:20:20 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:19:06 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-40-seanjc@google.com>
Subject: [PATCH 39/44] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

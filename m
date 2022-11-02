Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE8AC43217
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:20:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A9064B889;
	Wed,  2 Nov 2022 19:20:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MhvKNL3y0U0i; Wed,  2 Nov 2022 19:20:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ECCF4B89A;
	Wed,  2 Nov 2022 19:20:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A7C14B875
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y7mLGPU7SRDQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:20:27 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6F774B85F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:24 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 o2-20020a5b0502000000b006cade5e7c07so373014ybp.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=OIMXqLasKb2O7+CMjQgfYLOt6T5DmXDJujGgVXhHqFI=;
 b=a1O/5J/wwBHL5DdZlnXyBx3ad/wWPMoFwu33ObN+0h9wckbMWe8lEdCsf3vv9dBpgd
 Og1tkQtFVeN8Yaq0826BqmvMwQ236D77oay2sYYYSosRusWw8ffouoxC4D4VSugKPkv6
 eFSXHeIkk4rxzIyC2jBSOKzzG944O7R7WfzIzWLb9f4+zjzqLEX7pMuEWnereIkmHCla
 z9Wi0z30aLvdj67Gj18fnOk19FrwVJlssI8qaBiE05oy40Xc5I9xoCB6VMFe6e9n0+Qe
 iXYDA9B6ROLH1CUwVEa9sH8tNUrl6u56cDEtM0Lb6ytwc6hrZDZzuAPDLoXNIWglaaUo
 bPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=OIMXqLasKb2O7+CMjQgfYLOt6T5DmXDJujGgVXhHqFI=;
 b=PsZVevlWmnc2nbZQrMdoCh38wFL1gvMwOTi0A8MqGfwRGvtcv9V+kfebNagjfn435M
 COT1hERSOJRPH7NskLi7Tta6kVd9NKqos58KETVR11Whritroi48qgGRGelJiJCAKYbN
 Jge3Tiii+oG2VZBu5xI/kEh4+s3qzaHMzdn8nq7b4iosnDcOwsbtlY835tIJ8BnO3nif
 t2grc5T0YrSP6RuWkwpFv7nwTpVeURWdbcCz3mnFgzEP3dW0X4gbRQpNNDcapJDb66Nq
 q9WqTQpEUe9nqIN/w5n5UWzmBPbeN9fzlR5AW91FuyaFtE079U3yUF49lI24iGbzV5z+
 qkvw==
X-Gm-Message-State: ACrzQf1MgcfxjRxCGrGkTrm2nkLOf48V9N0QYuKUt2f/3X/mqt9GOt+z
 ei7c7MyCN6ICtllHPHpjL7qxtFyCF+g=
X-Google-Smtp-Source: AMsMyM6yCCCYKkQ3PoeOADSfJNFYsKEgxfAWyhUa6qA376xUH3n8/ExaQ+otuspws7tagrIY8b2ugf0DdfA=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:1713:0:b0:36b:3a6b:4b49 with SMTP id
 19-20020a811713000000b0036b3a6b4b49mr26413129ywx.500.1667431224514; Wed, 02
 Nov 2022 16:20:24 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:19:08 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-42-seanjc@google.com>
Subject: [PATCH 41/44] KVM: Use a per-CPU variable to track which CPUs have
 enabled virtualization
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

Use a per-CPU variable instead of a shared bitmap to track which CPUs
have successfully enabled virtualization hardware.  Using a per-CPU bool
avoids the need for an additional allocation, and arguably yields easier
to read code.  Using a bitmap would be advantageous if KVM used it to
avoid generating IPIs to CPUs that failed to enable hardware, but that's
an extreme edge case and not worth optimizing, and the low level helpers
would still want to keep their individual checks as attempting to enable
virtualization hardware when it's already enabled can be problematic,
e.g. Intel's VMXON will fault.

Opportunistically change the order in hardware_enable_nolock() to set
the flag if and only if hardware enabling is successful, instead of
speculatively setting the flag and then clearing it on failure.

Add a comment explaining that the check in hardware_disable_nolock()
isn't simply paranoia.  Waaay back when, commit 1b6c016818a5 ("KVM: Keep
track of which cpus have virtualization enabled"), added the logic as a
guards against CPU hotplug racing with hardware enable/disable.  Now that
KVM has eliminated the race by taking cpu_hotplug_lock for read (via
cpus_read_lock()) when enabling or disabling hardware, at first glance it
appears that the check is now superfluous, i.e. it's tempting to remove
the per-CPU flag entirely...

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4a42b78bfb0e..31949a89fe25 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,7 +102,7 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 DEFINE_MUTEX(kvm_lock);
 LIST_HEAD(vm_list);
 
-static cpumask_var_t cpus_hardware_enabled;
+static DEFINE_PER_CPU(bool, hardware_enabled);
 static int kvm_usage_count;
 static atomic_t hardware_enable_failed;
 
@@ -5008,21 +5008,17 @@ static struct miscdevice kvm_dev = {
 
 static void hardware_enable_nolock(void *junk)
 {
-	int cpu = raw_smp_processor_id();
-	int r;
-
-	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
+	if (__this_cpu_read(hardware_enabled))
 		return;
 
-	cpumask_set_cpu(cpu, cpus_hardware_enabled);
-
-	r = kvm_arch_hardware_enable();
-
-	if (r) {
-		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
+	if (kvm_arch_hardware_enable()) {
 		atomic_inc(&hardware_enable_failed);
-		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
+		pr_info("kvm: enabling virtualization on CPU%d failed\n",
+			raw_smp_processor_id());
+		return;
 	}
+
+	__this_cpu_write(hardware_enabled, true);
 }
 
 static int kvm_online_cpu(unsigned int cpu)
@@ -5054,12 +5050,16 @@ static int kvm_online_cpu(unsigned int cpu)
 
 static void hardware_disable_nolock(void *junk)
 {
-	int cpu = raw_smp_processor_id();
-
-	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
+	/*
+	 * Note, hardware_disable_all_nolock() tells all online CPUs to disable
+	 * hardware, not just CPUs that successfully enabled hardware!
+	 */
+	if (!__this_cpu_read(hardware_enabled))
 		return;
-	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
+
 	kvm_arch_hardware_disable();
+
+	__this_cpu_write(hardware_enabled, false);
 }
 
 static int kvm_offline_cpu(unsigned int cpu)
@@ -5861,13 +5861,11 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	int r;
 	int cpu;
 
-	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL))
-		return -ENOMEM;
-
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
 				      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
-		goto out_free_2;
+		return r;
+
 	register_reboot_notifier(&kvm_reboot_notifier);
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
@@ -5940,8 +5938,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
-out_free_2:
-	free_cpumask_var(cpus_hardware_enabled);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
@@ -5967,7 +5963,6 @@ void kvm_exit(void)
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 	kvm_irqfd_exit();
-	free_cpumask_var(cpus_hardware_enabled);
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
 
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FE1C4167B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:20:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7CC54B861;
	Wed,  2 Nov 2022 19:20:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OQyi4IWLX+Yz; Wed,  2 Nov 2022 19:20:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E44E4B87D;
	Wed,  2 Nov 2022 19:20:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 448E94B886
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O6O+RBkayKFm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:20:28 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B8BF14B83A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:27 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 k9-20020a170902c40900b0018734e872a9so206285plk.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=eBGnpAB5YEmL+9R2z3ic0MP89PNczg3hngnKElf7iFc=;
 b=ojul5zX3wpuJJe7cqIIhk1dAIJjsIWSoVFD34OlEtsaEsfSCNKjjiF+HwG5lmnrY2I
 KreCXy41v7/9TFioIC3+xGBWkD7fmUCdz1gMvsLxqHHsu6RBAiMKgNs/d2SdW+bbhMRg
 NBqdiN1JSTgrtFjDcdWlEa2/xdW6ehlPIuAUy2mR2+Yl/4TziBYRxDfQKdxIrFQqWvPp
 0/D2KuiVfrvvfUsbgj/0BRs0z+I4snaV4Q8GQFYIGo/sG1wBZ4xUsO/CGVPbjBOgOZYg
 fVops+u1SYWw0XvvKmWhiG2a3pG2wZukc8aY+SxBVuiKXvQTkpr9CwptXPVgpDgkq3Oo
 0d2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=eBGnpAB5YEmL+9R2z3ic0MP89PNczg3hngnKElf7iFc=;
 b=UYgopxtDHOl9iPM9hzqx5WpqaIFPBgy8zrEnqFM3DaxJ+rgpGkcg++/1N9UpBMXn/9
 e0q6IE/uN8zthsWh+nwvoj6bguyzXIAqMI+FsZeuykwI4tczVZNxNi1RgI1kpgAkQKPo
 OgXczhVZ6XSG+zBDxCsaq03TDPXzoVAlS+J5yUutan2NXq2zHc3KZdb7SJpGFWXoajdq
 DANJIuXZkiRnYD9lRKu46PVA2aJ6atRnfsra+kyUEdOJcVgGMeog0RSpOwxxQBMnxeDs
 r3/Z6qzz1IpyCtkZCs5AbIRwpFx9PPfBDO57xfJJMAPSO42Q8io2Uyr9222gHjxpyeg5
 fDcw==
X-Gm-Message-State: ACrzQf2/jcD3Mn9bhY3cZJi1BJnEmc++IpYwDIhE9P7JLflrj+4L1U40
 dxJ1xfJyRxxols93HhCIIC5ZPgt+US8=
X-Google-Smtp-Source: AMsMyM6vXnUWEsRLX9fWIPNNelljS9Dalpkeg6q32F9Z4GJq3yxe6Bn6qth+fDauwaH6t2Cx5e1igxhHCN8=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7348:b0:213:2708:8dc3 with SMTP id
 j8-20020a17090a734800b0021327088dc3mr248527pjs.2.1667431226181; Wed, 02 Nov
 2022 16:20:26 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:19:09 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-43-seanjc@google.com>
Subject: [PATCH 42/44] KVM: Make hardware_enable_failed a local variable in
 the "enable all" path
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

Rework detecting hardware enabling errors to use a local variable in the
"enable all" path to track whether or not enabling was successful across
all CPUs.  Using a global variable complicates paths that enable hardware
only on the current CPU, e.g. kvm_resume() and kvm_online_cpu().

Opportunistically add a WARN if hardware enabling fails during
kvm_resume(), KVM is all kinds of hosed if CPU0 fails to enable hardware.
The WARN is largely futile in the current code, as KVM BUG()s on spurious
faults on VMX instructions, e.g. attempting to run a vCPU on CPU if
hardware enabling fails will explode.

  ------------[ cut here ]------------
  kernel BUG at arch/x86/kvm/x86.c:508!
  invalid opcode: 0000 [#1] SMP
  CPU: 3 PID: 1009 Comm: CPU 4/KVM Not tainted 6.1.0-rc1+ #11
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_spurious_fault+0xa/0x10
  Call Trace:
   vmx_vcpu_load_vmcs+0x192/0x230 [kvm_intel]
   vmx_vcpu_load+0x16/0x60 [kvm_intel]
   kvm_arch_vcpu_load+0x32/0x1f0
   vcpu_load+0x2f/0x40
   kvm_arch_vcpu_ioctl_run+0x19/0x9d0
   kvm_vcpu_ioctl+0x271/0x660
   __x64_sys_ioctl+0x80/0xb0
   do_syscall_64+0x2b/0x50
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

But, the WARN may provide a breadcrumb to understand what went awry, and
someday KVM may fix one or both of those bugs, e.g. by finding a way to
eat spurious faults no matter the context (easier said than done due to
side effects of certain operations, e.g. Intel's VMCLEAR).

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[sean: rebase, WARN on failure in kvm_resume()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 31949a89fe25..a18296ee731b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -104,7 +104,6 @@ LIST_HEAD(vm_list);
 
 static DEFINE_PER_CPU(bool, hardware_enabled);
 static int kvm_usage_count;
-static atomic_t hardware_enable_failed;
 
 static struct kmem_cache *kvm_vcpu_cache;
 
@@ -5006,19 +5005,25 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-static void hardware_enable_nolock(void *junk)
+static int __hardware_enable_nolock(void)
 {
 	if (__this_cpu_read(hardware_enabled))
-		return;
+		return 0;
 
 	if (kvm_arch_hardware_enable()) {
-		atomic_inc(&hardware_enable_failed);
 		pr_info("kvm: enabling virtualization on CPU%d failed\n",
 			raw_smp_processor_id());
-		return;
+		return -EIO;
 	}
 
 	__this_cpu_write(hardware_enabled, true);
+	return 0;
+}
+
+static void hardware_enable_nolock(void *failed)
+{
+	if (__hardware_enable_nolock())
+		atomic_inc(failed);
 }
 
 static int kvm_online_cpu(unsigned int cpu)
@@ -5033,16 +5038,9 @@ static int kvm_online_cpu(unsigned int cpu)
 	 * errors when scheduled to this CPU.
 	 */
 	if (kvm_usage_count) {
-		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
-
 		local_irq_save(flags);
-		hardware_enable_nolock(NULL);
+		ret = __hardware_enable_nolock();
 		local_irq_restore(flags);
-
-		if (atomic_read(&hardware_enable_failed)) {
-			atomic_set(&hardware_enable_failed, 0);
-			ret = -EIO;
-		}
 	}
 	mutex_unlock(&kvm_lock);
 	return ret;
@@ -5094,6 +5092,7 @@ static void hardware_disable_all(void)
 
 static int hardware_enable_all(void)
 {
+	atomic_t failed = ATOMIC_INIT(0);
 	int r = 0;
 
 	/*
@@ -5109,10 +5108,9 @@ static int hardware_enable_all(void)
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
-		atomic_set(&hardware_enable_failed, 0);
-		on_each_cpu(hardware_enable_nolock, NULL, 1);
+		on_each_cpu(hardware_enable_nolock, &failed, 1);
 
-		if (atomic_read(&hardware_enable_failed)) {
+		if (atomic_read(&failed)) {
 			hardware_disable_all_nolock();
 			r = -EBUSY;
 		}
@@ -5744,7 +5742,7 @@ static void kvm_resume(void)
 	lockdep_assert_irqs_disabled();
 
 	if (kvm_usage_count)
-		hardware_enable_nolock(NULL);
+		WARN_ON_ONCE(__hardware_enable_nolock());
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

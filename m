Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877E6C636F9
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:09:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12AE5407BA;
	Wed, 30 Nov 2022 18:09:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kPsK2gKwmEAK; Wed, 30 Nov 2022 18:09:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C10F4B2C9;
	Wed, 30 Nov 2022 18:09:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7991407BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:09:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 10rX+EkPheVY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:09:41 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0F3A403A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:09:41 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 l4-20020a170903244400b00188c393fff1so18980693pls.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=lSEuQC4fsPjkdtnYDeQfd/vZVTy0qc8mLVWrI2CwrIE=;
 b=LMXa1KavlLIPKm1O338OzmSfdiHcECfTdj20rMtDEH+lfDJSFJhQMyyiEeUk04KyjS
 THAs8aeulvKYPo7lA32gfVqJl/QX3PY7ib8sgaj4Pvo4cfNxQJm28NxV50VxtM37FuZv
 u7SNAeiI+m8cgjrUiBg7wJxoPwHMZLyx4z5zzJVAdYB5b5TVKiOE8DQmTOE93UnjR0x6
 v7KwZrdqHiBTUALLLRFcXHQn6LhnWmgLoZpbAdwuKZKQCHk46qBwUS9Afdts0dNnMgCD
 yr/YhWMvzdjaadccrilOoEPdqxhs6lMrLM/VgTXUhLW1qaCXkx2eJvsLyG4zepJOJSSK
 eycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=lSEuQC4fsPjkdtnYDeQfd/vZVTy0qc8mLVWrI2CwrIE=;
 b=FEwEVYM4ppkh8uuaJapOWjaWOOUJ+sVLEdaJrUlEUhvQeJwGJ+2hcXBnSJ6wYA3WRm
 DGT4Ow42AZGclrA7fRco3AfNAX5RWo4YGk2rDqlW3gkEgfICZukelfg327U67eS/vCes
 SwavMK/EP9BEdoFCzRcjHZaN3u6pc07WXmBxeHRXr6N8HFz2y9RpjpTp/p+ecsF65yZ9
 ImfU7a86AR4gKokqi3EjQa9KJvqh6ymrz1Ymsako2YobahzUAXbk4csHJYDyQoINt73C
 Ue0Xtj+cIZ9sOUJ6yd067s9mRQI4x5T5lRj/9L0mRw2x8sw9iyJqno+wnk2XUPWpYXu7
 Vy6Q==
X-Gm-Message-State: ANoB5plb2CMjEqwgIXv6tT/BTH5EusmDcNXG42i3n4UKct/9M4HkAkNu
 yj1nVeYx49G/ZsmldWhw+CvQoMHpnNA=
X-Google-Smtp-Source: AA0mqf5/wgDP/8zZO17OyVNcvbHpUQjMB4GbOO0uy/0pkoSTXNKOuo3YYJAOzIWIiFtrZoAfFu+zlI3eWn8=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:1586:0:b0:575:f08b:7a9f with SMTP id
 128-20020a621586000000b00575f08b7a9fmr3765310pfv.60.1669849780652; Wed, 30
 Nov 2022 15:09:40 -0800 (PST)
Date: Wed, 30 Nov 2022 23:08:46 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-3-seanjc@google.com>
Subject: [PATCH v2 02/50] KVM: Initialize IRQ FD after arch hardware setup
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
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org
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

Move initialization of KVM's IRQ FD workqueue below arch hardware setup
as a step towards consolidating arch "init" and "hardware setup", and
eventually towards dropping the hooks entirely.  There is no dependency
on the workqueue being created before hardware setup, the workqueue is
used only when destroying VMs, i.e. only needs to be created before
/dev/kvm is exposed to userspace.

Move the destruction of the workqueue before the arch hooks to maintain
symmetry, and so that arch code can move away from the hooks without
having to worry about ordering changes.

Reword the comment about kvm_irqfd_init() needing to come after
kvm_arch_init() to call out that kvm_arch_init() must come before common
KVM does _anything_, as x86 very subtly relies on that behavior to deal
with multiple calls to kvm_init(), e.g. if userspace attempts to load
kvm_amd.ko and kvm_intel.ko.  Tag the code with a FIXME, as x86's subtle
requirement is gross, and invoking an arch callback as the very first
action in a helper that is called only from arch code is silly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b60abb03606b..43e2e4f38151 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5852,24 +5852,19 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	int r;
 	int cpu;
 
+	/*
+	 * FIXME: Get rid of kvm_arch_init(), vendor code should call arch code
+	 * directly.  Note, kvm_arch_init() _must_ be called before anything
+	 * else as x86 relies on checks buried in kvm_arch_init() to guard
+	 * against multiple calls to kvm_init().
+	 */
 	r = kvm_arch_init(opaque);
 	if (r)
-		goto out_fail;
-
-	/*
-	 * kvm_arch_init makes sure there's at most one caller
-	 * for architectures that support multiple implementations,
-	 * like intel and amd on x86.
-	 * kvm_arch_init must be called before kvm_irqfd_init to avoid creating
-	 * conflicts in case kvm is already setup for another implementation.
-	 */
-	r = kvm_irqfd_init();
-	if (r)
-		goto out_irqfd;
+		return r;
 
 	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
 		r = -ENOMEM;
-		goto out_free_0;
+		goto err_hw_enabled;
 	}
 
 	r = kvm_arch_hardware_setup(opaque);
@@ -5913,9 +5908,13 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		}
 	}
 
+	r = kvm_irqfd_init();
+	if (r)
+		goto err_irqfd;
+
 	r = kvm_async_pf_init();
 	if (r)
-		goto out_free_4;
+		goto err_async_pf;
 
 	kvm_chardev_ops.owner = module;
 
@@ -5946,6 +5945,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
+err_async_pf:
+	kvm_irqfd_exit();
+err_irqfd:
 out_free_4:
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
@@ -5957,11 +5959,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_arch_hardware_unsetup();
 out_free_1:
 	free_cpumask_var(cpus_hardware_enabled);
-out_free_0:
-	kvm_irqfd_exit();
-out_irqfd:
+err_hw_enabled:
 	kvm_arch_exit();
-out_fail:
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
@@ -5986,9 +5985,9 @@ void kvm_exit(void)
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	kvm_irqfd_exit();
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
-	kvm_irqfd_exit();
 	free_cpumask_var(cpus_hardware_enabled);
 	kvm_vfio_ops_exit();
 }
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

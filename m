Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB231C4321E
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:19:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3857B4B6CF;
	Wed,  2 Nov 2022 19:19:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tM5uRzRPZ+Wm; Wed,  2 Nov 2022 19:19:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF5384B797;
	Wed,  2 Nov 2022 19:19:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E77104B6CF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K62CAlmScBUx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:19:18 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9622F40B65
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:18 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 m4-20020a258004000000b006cbf32f7ed8so366303ybk.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=7+eEYWgdfK2f235NQouH0yOVJiIE3XUzS6aBBcpH2Xg=;
 b=GJuDT4qIFRmN0zrEcesKp5eZ38WFJtAk7eJLI6MT/Ki4scur3JzxZHizyJ8pIsBMLg
 TZsxQflrMw0vV6/LQ4eLuVGkeHataXwJMbFJYWT60aCHjdYTQzerfB15KOU/infpl1Yg
 Dq7XMjNzBlwZlnSc61H5gBHFkm3TEEd35yWHpJa13qtav7MsW7uSfcNWliarLL2r1uQq
 n4Uyhy3npcssGJRIlfdRDpGm7iF4EKYzBOtaYqDiDMZ0E2gBBrutJfjyLCbotmATUg5n
 cvQzCJ4G8GbG22iIRvx4lfqlDB2hxbUTz17cEFGPuQiDi1PGB1ilnB2TMVHOT/GiMblc
 mfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=7+eEYWgdfK2f235NQouH0yOVJiIE3XUzS6aBBcpH2Xg=;
 b=8Kp5z4Kshz7vi0tDlaw8aX4d5ms/CzxWIcvKFW1Us0+RiESZOOotDknv9erauiq2nF
 2s+o5z/Ht0X7eFxaNeWWYnFz1sl38qxv2CFmsniT/XaMIHqeh4GrI5Sj9ENRzX/OiyJo
 m7CbMcolNtWxDtWAG6aKiiGqP3c9XgTnByI1U88rMpdB+tPlZbzEW/VUCPTDjyv9W6si
 dhuYBK8157IvjbNpJibkSkWZQyc8Ec5m7KCKPmGTOMKQPZFVRi/aXpQXXkTsd5ZaCBlK
 FJu1MhozexfuCYcN89JvBNBva0+JcPYYHunAKe7Gghnbrlwbtm7ZRP+K3AypLYttQ+AC
 zJBg==
X-Gm-Message-State: ACrzQf10aoPsKy/9/8EMBjIKZ6lUh7EeHd7jD+BND4D7ql81WN6eM3Ry
 K9WbQDYNOYTGYWzh3ljRm0rZFv0zSqo=
X-Google-Smtp-Source: AMsMyM70haTx/XR5G28CKoYVC6XM4t6KIj6EhKrnhdUb7b9djmPG/60PGXPcAfFKa85v8fvZQusLb10dmQQ=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:afc2:0:b0:6cd:3a43:a395 with SMTP id
 d2-20020a25afc2000000b006cd3a43a395mr12532811ybj.220.1667431158134; Wed, 02
 Nov 2022 16:19:18 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:18:29 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-3-seanjc@google.com>
Subject: [PATCH 02/44] KVM: Initialize IRQ FD after arch hardware setup
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
index a188d27f78af..e0424af52acc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5833,24 +5833,19 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
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
@@ -5894,9 +5889,13 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
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
 
@@ -5927,6 +5926,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
+err_async_pf:
+	kvm_irqfd_exit();
+err_irqfd:
 out_free_4:
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
@@ -5938,11 +5940,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
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
@@ -5967,9 +5966,9 @@ void kvm_exit(void)
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
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

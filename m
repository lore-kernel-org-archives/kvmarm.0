Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338ECD50F
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:11:02 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id n16-20020a25da10000000b006f2b5bc99f9so15914598ybf.11
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f1ges7v12pOnWRvBGxVUQ1iVkaen+bCiwnszqRspz5I=;
        b=gLeoYszhyNvT3b/sb5uYSwOA01VKPMWAXDjqkZYRdtKGfM6Ek/arh5xQWkT5U5yzoB
         5CD5ESLZv4WU1n/4uB06OdwXMxCseYp9IaQQLNVjv3WwPdnRofjslDSFaOM0xGYsKK+C
         tKX3chEelyUD8sc6Y74rDxDyt3aY3CP6z+j1KZWlrcIRv9diHP2iozhFk/Mchi+TTVgv
         fEeeQaF+pMBa6yom6DRZvH7p+HjJ0Tg0Rdf0l2eI9+N1rfc39tpiDCp65RGs1ugAXHHv
         MGoQYmmnBoVyTjRNQhOEvAGKhAuRN2t7CBn2+Bl7DY/FSOnm9dbPq0iYKWwQsZDGX6rY
         /NUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f1ges7v12pOnWRvBGxVUQ1iVkaen+bCiwnszqRspz5I=;
        b=yEBBTbLzwUeH4iNFVfwns48r6ZRy4cDxO/FYf3EDOgX4AIOa9xCRh8laZarHUHhdsR
         h+QWwxdOjIWSwv88Ch1qPVwWpJqvdAuZ3od9LfxqOiE42/M1Cy4fNJN8kd4Y7agbJHwq
         d2E0edWjB0KJOxssiTshAPWSdPd/p5WLhqDMHBPCytqi19p9hOV2GN2rvWSKFglkoXr6
         5Z1jDsKhB5Fg/lKVQu85TOAGcrp0C4RApiaMlvdwlq/jYB03PgvIr6whAUlODhRQu5/z
         uFGdMtf+smsWVfibYB7HWxZOIg9NW7rHS8mqLk63hTixJuQQ9j8ePGamUmDb9kWlB8wR
         E8ww==
X-Gm-Message-State: ANoB5pkwqJhjQ9FJmxAZniy+0voz5HG+/ts8svur2ixAgAt3F/5p/yZi
	Hd6VjTNBpURO+h5NUnc0D6bP3XJ8z+A=
X-Google-Smtp-Source: AA0mqf63ZlaX4G2YNi86TQbzic6Ybrn3ErpM5Fv6RATCbhjBaKzM7IKwyP6eEXyUhb9VuIg8OaKUkjA30b8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a0cc:0:b0:6f7:4be9:89f8 with SMTP id
 i12-20020a25a0cc000000b006f74be989f8mr14935825ybm.345.1669849861304; Wed, 30
 Nov 2022 15:11:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:09:32 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-49-seanjc@google.com>
Subject: [PATCH v2 48/50] KVM: Register syscore (suspend/resume) ops early in kvm_init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>, 
	Cornelia Huck <cohuck@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Fabiano Rosas <farosas@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221130230932.VQmcXCZdqnsoDKlLXdobxFSCQEUKXgdyxC5JkPytkOg@z>

Register the suspend/resume notifier hooks at the same time KVM registers
its reboot notifier so that all the code in kvm_init() that deals with
enabling/disabling hardware is bundled together.  Opportunstically move
KVM's implementations to reside near the reboot notifier code for the
same reason.

Bunching the code together will allow architectures to opt out of KVM's
generic hardware enable/disable logic with minimal #ifdeffery.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 68 ++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 674a9dab5411..c12db3839114 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5154,6 +5154,38 @@ static struct notifier_block kvm_reboot_notifier = {
 	.priority = 0,
 };
 
+static int kvm_suspend(void)
+{
+	/*
+	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
+	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
+	 * is stable.  Assert that kvm_lock is not held to ensure the system
+	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
+	 * can be preempted, but the task cannot be frozen until it has dropped
+	 * all locks (userspace tasks are frozen via a fake signal).
+	 */
+	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_irqs_disabled();
+
+	if (kvm_usage_count)
+		hardware_disable_nolock(NULL);
+	return 0;
+}
+
+static void kvm_resume(void)
+{
+	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_irqs_disabled();
+
+	if (kvm_usage_count)
+		WARN_ON_ONCE(__hardware_enable_nolock());
+}
+
+static struct syscore_ops kvm_syscore_ops = {
+	.suspend = kvm_suspend,
+	.resume = kvm_resume,
+};
+
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 {
 	int i;
@@ -5732,38 +5764,6 @@ static void kvm_init_debug(void)
 	}
 }
 
-static int kvm_suspend(void)
-{
-	/*
-	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
-	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
-	 * is stable.  Assert that kvm_lock is not held to ensure the system
-	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
-	 * can be preempted, but the task cannot be frozen until it has dropped
-	 * all locks (userspace tasks are frozen via a fake signal).
-	 */
-	lockdep_assert_not_held(&kvm_lock);
-	lockdep_assert_irqs_disabled();
-
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
-	return 0;
-}
-
-static void kvm_resume(void)
-{
-	lockdep_assert_not_held(&kvm_lock);
-	lockdep_assert_irqs_disabled();
-
-	if (kvm_usage_count)
-		WARN_ON_ONCE(__hardware_enable_nolock());
-}
-
-static struct syscore_ops kvm_syscore_ops = {
-	.suspend = kvm_suspend,
-	.resume = kvm_resume,
-};
-
 static inline
 struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
 {
@@ -5879,6 +5879,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 		return r;
 
 	register_reboot_notifier(&kvm_reboot_notifier);
+	register_syscore_ops(&kvm_syscore_ops);
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
@@ -5913,8 +5914,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 
 	kvm_chardev_ops.owner = module;
 
-	register_syscore_ops(&kvm_syscore_ops);
-
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
@@ -5948,6 +5947,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
+	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 	return r;
-- 
2.38.1.584.g0f3c55d4c2-goog


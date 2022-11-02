Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C182B2C9C
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 23:19:17 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-368e6c449f2so1001507b3.5
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 16:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J4baT2gCaqaG+hAt/mJp+w8Lapt4XhULv2rUZ1lbod8=;
        b=Y/LgcbOSvwbnzJXRGal3Ep3KB7/0yCP9cU65YkQert5+3hLyHHSjjMao2/UuV8Y1pm
         rxtzoLchmx+Mfw2uDAT2cc7aUI/oVviLkjgjK/axQ+ux0UramBaUfpMh7qr3oHRIrkbM
         g29/HkiYkyDP9zLb6T5zYBFWjCRhk7uodXh+YwW0fknC8LCiXKsmBrjDcUEU31+Wr1aB
         IkpbU9xq9Vh5sCGgS87jUUdeWGvPSndSpQtpQaJwtmMAXoArYlfZq/YuY0lzlwpeE7m/
         iktR7kaNiirOlR+WEM+Xzua+uL8FsQlW7DYdB778CLiAWY7J4Sab6pQ6XIRdRfFvya7C
         dqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J4baT2gCaqaG+hAt/mJp+w8Lapt4XhULv2rUZ1lbod8=;
        b=2nGzpfRdWri3mr7nfrkFLz8Gd/nPK9YGTCeloJN1mwLg9EgsCfSsM9fOv9bEHjj9w+
         pVstm8UaeVyugdY7/LRvCRmAZFoHXbqeQIMV8mOVlUD6uNUy/2CD+mqKYbylyEVu43AU
         OvQ4k8mKAf5aBGaHg3sP+Nqcr2ZptPg0A3CRLpE4MnNnryggMzhTqEH9Bt2zX0QCQHFj
         6FPNWv9TdOOpdsG1d4yP6T0yAcIiaOLb2qnKB7iDCeAkSPJvAGFL1eqPq5FQBAQ9cX6C
         2Rj3w8C9Z0cdR47HTBwqeX7iQqo8axkHrvycmiHinJPbzeaoIyBYnJKG2gvy7cgBJLfE
         CTnw==
X-Gm-Message-State: ACrzQf30VzLuubA45HQ7aVL9PMUeH2EAFTBFL4AVlyYlVkKgglYKYgk5
	UjrFv8+VS+VXMDBv37lQsa+ovMUNYlg=
X-Google-Smtp-Source: AMsMyM5o6mEhEhiYREiqHX2O6l5zHbOoOJ5LkmkQQCrMnpzWAr9BhETh9np1j3huSYRmzTw5GjJ2jYjKldE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:f451:0:b0:6cc:aeeb:8fed with SMTP id
 p17-20020a25f451000000b006ccaeeb8fedmr15718187ybe.11.1667431156834; Wed, 02
 Nov 2022 16:19:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Nov 2022 23:18:28 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-2-seanjc@google.com>
Subject: [PATCH 01/44] KVM: Register /dev/kvm as the _very_ last thing during initialization
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
Message-ID: <20221102231828.kzunu5d_gyIBHAk8o21QAiu3U7LOm9YDXqDWLhKTWU0@z>

Register /dev/kvm, i.e. expose KVM to userspace, only after all other
setup has completed.  Once /dev/kvm is exposed, userspace can start
invoking KVM ioctls, creating VMs, etc...  If userspace creates a VM
before KVM is done with its configuration, bad things may happen, e.g.
KVM will fail to properly migrate vCPU state if a VM is created before
KVM has registered preemption notifiers.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f1df24c2bc84..a188d27f78af 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5900,12 +5900,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 	kvm_chardev_ops.owner = module;
 
-	r = misc_register(&kvm_dev);
-	if (r) {
-		pr_err("kvm: misc device register failed\n");
-		goto out_unreg;
-	}
-
 	register_syscore_ops(&kvm_syscore_ops);
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
@@ -5914,11 +5908,24 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();
-	WARN_ON(r);
+	if (WARN_ON_ONCE(r))
+		goto err_vfio;
+
+	/*
+	 * Registration _must_ be the very last thing done, as this exposes
+	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
+	 */
+	r = misc_register(&kvm_dev);
+	if (r) {
+		pr_err("kvm: misc device register failed\n");
+		goto err_register;
+	}
 
 	return 0;
 
-out_unreg:
+err_register:
+	kvm_vfio_ops_exit();
+err_vfio:
 	kvm_async_pf_deinit();
 out_free_4:
 	for_each_possible_cpu(cpu)
@@ -5944,8 +5951,14 @@ void kvm_exit(void)
 {
 	int cpu;
 
-	debugfs_remove_recursive(kvm_debugfs_dir);
+	/*
+	 * Note, unregistering /dev/kvm doesn't strictly need to come first,
+	 * fops_get(), a.k.a. try_module_get(), prevents acquiring references
+	 * to KVM while the module is being stopped.
+	 */
 	misc_deregister(&kvm_dev);
+
+	debugfs_remove_recursive(kvm_debugfs_dir);
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
-- 
2.38.1.431.g37b22c650d-goog


Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA30BC47088
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:11:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DD744B652;
	Wed, 30 Nov 2022 18:11:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dvNji2vS7Mh9; Wed, 30 Nov 2022 18:11:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 699524B6BF;
	Wed, 30 Nov 2022 18:11:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0D6C4B3D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:11:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yYAoBkbX3Wsr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:11:09 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 543324B636
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:11:05 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3b5da1b3130so68567b3.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=8x0ZXn3EDc/IXE10wWIHQ6grwXVgVE97mHwl4hbdeQk=;
 b=svX1/fceR089wUbhSQhk/jDIM6Hb1O6OQ2qpyY/bxODwo2l21O/+lF2M/oWYVFopBL
 9iVSjpUD4ByvxHNMTLm2+Aqi3jkHju8zeyRE0QQ4MXEVtGJlbaZInZtfd0vZlRTxGrzq
 JsifAxPm+HxofD/VWF9T5VpkTs3QrcfDSrRCCx24sbFpCjTOTpcatd79jNfZI53OekTV
 PFymG/ZoNTP1yqeAIkXfkfQrmLz6NqML76C7vkqujoT5hbToc0RUrI+jh/dGR+3upHWw
 Pv5WHPynR7w4dPeVQ7wg5KdVd27yXGQS19WxO6GBAvU3VTI/56EGnkKmcDKvptaKWmKb
 82JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=8x0ZXn3EDc/IXE10wWIHQ6grwXVgVE97mHwl4hbdeQk=;
 b=LzT4dvPBOfEcz22VVMtdTgK5qaKxeGmsrl4dhowHGsLyDRr5TsRpbL/5Opqb2luxiz
 OoSstgR9OIHiM5aSKL/5S72hXoAXIbSNc3tAx1DZZk67WbpWROZicqlGUFu5z4o+JTqv
 4Nmxf27Hn4imwz/D6DOgqtiD/UQmSRsxM9aGUrJwwDg6Kfiw6EpKa6Dd2VCiuHXA6pyT
 09HYAJZtXjSFTQDoYesmzmryPGXlItvYbrKE+7A0cW1GrkkHfK03uK8o4E1ZZB4sLahx
 eDdbuVFIf/fwGRrTbImFo/c91PrJ8s/pEjHiplkyjOQn/aFDsh3kaIA1NQGPPAuOixAH
 a5Tg==
X-Gm-Message-State: ANoB5pnqjkcy4EOnf624eijyGaNeX7bGEsqLsnl7ZE2BD3Mz3D/oQ68k
 CF/CF7XrJ2DbI5IXw6d/isezoEeIXaM=
X-Google-Smtp-Source: AA0mqf52TAnX1cWAQ96XDuvwPCxCy8n4wLWV5o+6wUepr4pO9rnWPI1F+BmGpVuyqa0Tukjf36JFuFHSLuw=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d40f:0:b0:6fb:a7f8:8b62 with SMTP id
 m15-20020a25d40f000000b006fba7f88b62mr1103250ybf.313.1669849864582; Wed, 30
 Nov 2022 15:11:04 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:34 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-51-seanjc@google.com>
Subject: [PATCH v2 50/50] KVM: Clean up error labels in kvm_init()
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

Convert the last two "out" lables to "err" labels now that the dust has
settled, i.e. now that there are no more planned changes to the order
of things in kvm_init().

Use "err" instead of "out" as it's easier to describe what failed than it
is to describe what needs to be unwound, e.g. if allocating a per-CPU kick
mask fails, KVM needs to free any masks that were allocated, and of course
needs to unwind previous operations.

Reported-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a2be96557c2..b8c6bfb46066 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5907,14 +5907,14 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 					   NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
-		goto out_free_3;
+		goto err_vcpu_cache;
 	}
 
 	for_each_possible_cpu(cpu) {
 		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
 					    GFP_KERNEL, cpu_to_node(cpu))) {
 			r = -ENOMEM;
-			goto out_free_4;
+			goto err_cpu_kick_mask;
 		}
 	}
 
@@ -5956,11 +5956,11 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_async_pf:
 	kvm_irqfd_exit();
 err_irqfd:
-out_free_4:
+err_cpu_kick_mask:
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
-out_free_3:
+err_vcpu_cache:
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

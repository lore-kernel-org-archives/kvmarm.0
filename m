Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9EA1C47089
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:11:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 663014B736;
	Wed, 30 Nov 2022 18:11:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GbpQn78ztN7s; Wed, 30 Nov 2022 18:11:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6358C4B6EE;
	Wed, 30 Nov 2022 18:10:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77EA04B492
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EZQ4+-uBEmFh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:56 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E0384B63E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:51 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 s16-20020a632c10000000b0047084b16f23so93235pgs.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=/jaxWTFPxmj21+X8Hbtmuwlu7GhNr4CXW1v8XgKCn2o=;
 b=jQgxp+u6SHc5NMy81OYePF88zDxKuqUxtOVxluvPTQI3MEuiQG2uqtD9RQG6VmOJ8F
 kk/Pbv5hy6CTAGXGAAE4oRsWW1h1FNSdzY+gt8AUeNr14OcCE+UIvjb6UQ7TpiTMFIF0
 izlNrD0kV5SMk0eBnY4nR4B5h0mn3eoylpGXZ25XCA4WeenN75ctGGp49AtZXHGvUS+T
 qZhLro5p9fp3cB2diacdo0hy8LHABjsSmVzRqwSHAFnoRTmJG580sa0oMGIlwLbpLirz
 qqtAn0DlcrzmZfTLixcwk1Q4OO5vUHO9P7L17dYxokTmYYn2YF9q+ofLTjNmrrQIy8bI
 XJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=/jaxWTFPxmj21+X8Hbtmuwlu7GhNr4CXW1v8XgKCn2o=;
 b=aIQqyj5j40CSu5SALt7llANDk6Gibw/2sI5zqdXlYZP/3UYC8RGUq/XaVkJnAXdQ1z
 8rxwuTrvYMyvNN7JWbQ5Plr4iy50ZyHvIxnrLJGl6sdZqglHGqXW0jJUdZ+oiJleurWY
 2aBIgNQu4Gxo1G2yn/MlySdVLjtQlhtH2V9VoSkXVBNIV9CPAtrptpFzW6m4iErxh2O1
 btHpOJVvexJRHjjUAJ60ANdcX08VgdWqjbMRH6S7xANqOq9ClqL4dXXNcNE23KqtPdC6
 cJuQkFIrXy9EmDFwcDA3/+jNF2BBwveYUnhjFVhNQ7zL5gLJgsDAuCsoNqWlko7/KXWc
 fSKA==
X-Gm-Message-State: ANoB5pnsbG222kYhwm63TG95/z+rgYCZaU8q6/g5FpS76ldKTnb4tgjs
 9Ftjx6rKPuYBDRr0gB2RKg6FcJeLBDQ=
X-Google-Smtp-Source: AA0mqf6+Bap4v8ExdEec6znsKgSVG1g77x3d69DLe55WoTiV/xIM01OoU5c9uuVoqdfTkLa+0jZkKz1t3dk=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6904:b0:185:3f7a:50cc with SMTP id
 j4-20020a170902690400b001853f7a50ccmr43659852plk.99.1669849850498; Wed, 30
 Nov 2022 15:10:50 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:26 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-43-seanjc@google.com>
Subject: [PATCH v2 42/50] KVM: Disable CPU hotplug during hardware
 enabling/disabling
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

From: Chao Gao <chao.gao@intel.com>

Disable CPU hotplug when enabling/disabling hardware to prevent the
corner case where if the following sequence occurs:

  1. A hotplugged CPU marks itself online in cpu_online_mask
  2. The hotplugged CPU enables interrupt before invoking KVM's ONLINE
     callback
  3  hardware_{en,dis}able_all() is invoked on another CPU

the hotplugged CPU will be included in on_each_cpu() and thus get sent
through hardware_{en,dis}able_nolock() before kvm_online_cpu() is called.

        start_secondary { ...
                set_cpu_online(smp_processor_id(), true); <- 1
                ...
                local_irq_enable();  <- 2
                ...
                cpu_startup_entry(CPUHP_AP_ONLINE_IDLE); <- 3
        }

KVM currently fudges around this race by keeping track of which CPUs have
done hardware enabling (see commit 1b6c016818a5 "KVM: Keep track of which
cpus have virtualization enabled"), but that's an inefficient, convoluted,
and hacky solution.

Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c  | 11 ++++++++++-
 virt/kvm/kvm_main.c | 12 ++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dad30097f0c3..d2ad383da998 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9281,7 +9281,16 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 
 static int kvm_x86_check_processor_compatibility(void)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	int cpu = smp_processor_id();
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	/*
+	 * Compatibility checks are done when loading KVM and when enabling
+	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
+	 * compatible, i.e. KVM should never perform a compatibility check on
+	 * an offline CPU.
+	 */
+	WARN_ON(!cpu_online(cpu));
 
 	if (__cr4_reserved_bits(cpu_has, c) !=
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f26ea779710a..d985b24c423b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5098,15 +5098,26 @@ static void hardware_disable_all_nolock(void)
 
 static void hardware_disable_all(void)
 {
+	cpus_read_lock();
 	raw_spin_lock(&kvm_count_lock);
 	hardware_disable_all_nolock();
 	raw_spin_unlock(&kvm_count_lock);
+	cpus_read_unlock();
 }
 
 static int hardware_enable_all(void)
 {
 	int r = 0;
 
+	/*
+	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
+	 * is called, and so on_each_cpu() between them includes the CPU that
+	 * is being onlined.  As a result, hardware_enable_nolock() may get
+	 * invoked before kvm_online_cpu(), which also enables hardware if the
+	 * usage count is non-zero.  Disable CPU hotplug to avoid attempting to
+	 * enable hardware multiple times.
+	 */
+	cpus_read_lock();
 	raw_spin_lock(&kvm_count_lock);
 
 	kvm_usage_count++;
@@ -5121,6 +5132,7 @@ static int hardware_enable_all(void)
 	}
 
 	raw_spin_unlock(&kvm_count_lock);
+	cpus_read_unlock();
 
 	return r;
 }
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

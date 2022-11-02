Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8668A24F28
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 23:20:19 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id bq6-20020a056a000e0600b0056bcbc6720fso6553pfb.22
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 16:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hGyIy/c9x7gid81AWLPwZ0ljJlv+xEg20udWYHo0hbA=;
        b=QqNc2gbel1jInPNqFUgamY9IlriDQkvmhLgs/+APWLQZ26DgF8ww5iLxK5OkUpbYy3
         HBY25YJUg8bQglW+8pK0XdmoWu5kp0V1X30MP4hvDgUq/lXrr/IjN5eYBpw2Cpmbjanr
         TqynEnzd9faNEz99LeseMmE1IXDN+BI4xwg7V9Sy2Mz5r4CleSP/B+U7AVSrFavYJ1Fj
         pLJTmPuFLhW67P7oNt/wLRQeJzFX3YhDs7A5R02nLIxeyDaFpeIL7acpvdeYKRt0I/5K
         OaH2yRJI3oUK/4Z+nQ16STa2tY+sAGIiXMgaJn/xhTNa56oRdIbBfXfqmK+HDZY/Eb8W
         RwKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hGyIy/c9x7gid81AWLPwZ0ljJlv+xEg20udWYHo0hbA=;
        b=zjdE2LqhB6lc/4IdUbvnisFvHbdRDWCu9Ho7e7/9xfx1o19JCqx3Gcxj4iGUJlNr6E
         WzroG1CibAG+IUoTNkOZsaCPc5lrk/drYyyo4rdg54z8P7rktBoFI7g07US7S6MCJAXd
         SdFAXBa+87OwNtxFToGI8QjGqSAd2z8Vu0rCcLe7FbWyJqsUfFLqfnN1zQxJpqmGIifL
         vutDD82PJMW5q+39gcOKBbrMqcdPaC8aUruJyts9OFP67k0N/Lam5bbC6IMTYHCED0Sx
         TXfNO1ipRejOV98dE/9y4NgYMvthJ8nHSEN/kEWSm91lZb+xI1RvScWyhjsJ2hvyCqF6
         jOkA==
X-Gm-Message-State: ACrzQf2qlNqm4vHhBnaRfq9VQhKWbW5bhNyp1h94UnKFmBnYlGtK6ChI
	D9LVACvqWtBWjGCXnAgjZCgWxAvAoHM=
X-Google-Smtp-Source: AMsMyM4ko2OsoLvqzFyYKz9/I+3Jr5HBRqjQ9HRHF35ITIEOD8mTj17ITtdRiAaAjWe/b+jAZlUVnVQHbNk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:9308:b0:182:b2ba:755 with SMTP id
 bc8-20020a170902930800b00182b2ba0755mr27515720plb.107.1667431219005; Wed, 02
 Nov 2022 16:20:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Nov 2022 23:19:05 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-39-seanjc@google.com>
Subject: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
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
Message-ID: <20221102231905.Om83Ke7BzaUbBCLhYXgAxiDjzOwK_oe5ngvq7suLOBQ@z>

From: Chao Gao <chao.gao@intel.com>

Disable CPU hotplug during hardware_enable_all() to prevent the corner
case where if the following sequence occurs:

  1. A hotplugged CPU marks itself online in cpu_online_mask
  2. The hotplugged CPU enables interrupt before invoking KVM's ONLINE
     callback
  3  hardware_enable_all() is invoked on another CPU right

the hotplugged CPU will be included in on_each_cpu() and thus get sent
through hardware_enable_nolock() before kvm_online_cpu() is called.

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
 arch/x86/kvm/x86.c  |  8 +++++++-
 virt/kvm/kvm_main.c | 10 ++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a7b1d916ecb2..a15e54ba0471 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9283,7 +9283,13 @@ static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
 	int cpu = smp_processor_id();
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	WARN_ON(!irqs_disabled());
+	/*
+	 * Compatibility checks are done when loading KVM and when enabling
+	 * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
+	 * compatible, i.e. KVM should never perform a compatibility check on
+	 * an offline CPU.
+	 */
+	WARN_ON(!irqs_disabled() && cpu_active(cpu));
 
 	if (__cr4_reserved_bits(cpu_has, c) !=
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd9e39c85549..4e765ef9f4bd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5088,6 +5088,15 @@ static int hardware_enable_all(void)
 {
 	int r = 0;
 
+	/*
+	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
+	 * is called, and so on_each_cpu() between them includes the CPU that
+	 * is being onlined.  As a result, hardware_enable_nolock() may get
+	 * invoked before kvm_online_cpu().
+	 *
+	 * Disable CPU hotplug to prevent scenarios where KVM sees
+	 */
+	cpus_read_lock();
 	raw_spin_lock(&kvm_count_lock);
 
 	kvm_usage_count++;
@@ -5102,6 +5111,7 @@ static int hardware_enable_all(void)
 	}
 
 	raw_spin_unlock(&kvm_count_lock);
+	cpus_read_unlock();
 
 	return r;
 }
-- 
2.38.1.431.g37b22c650d-goog


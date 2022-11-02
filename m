Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6034C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:20:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6205A4B875;
	Wed,  2 Nov 2022 19:20:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2RTDbVIFeWbK; Wed,  2 Nov 2022 19:20:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7BD34B87B;
	Wed,  2 Nov 2022 19:20:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4750D4B6C8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BjcjUxWzlRxJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:20:25 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEAF24B86A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:19 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 s15-20020a170902ea0f00b00187050232fcso241866plg.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=RJYG47SbmWc7Bhr2Bg0izCrL0J1XUmYBvqnXi74FfCuJ7/dZAQhtoc4yVw16+QNS+N
 7U9Zfi5US2dgm3HJw06oUsMzj7Bo81o+xF8oHyXdss0hb6202H1uV9nq5fAuk8/giWgm
 yw0AkcleUaiQBkd1gnrLoYxKVZlMcovW+RMuTy8HkD/2P57OGDoKMK8dFm2XH31VVx+7
 lRr7Tg+YU828ArbPrmrFfqcRMtyr4s18NaTs7qiGuDeNRn72jfjhJTD6Y9/obMXui8RK
 oEAM8Xp8K0U8RY0pn93sijoOEKjF9CfTaniihsATK5vMHare4u7rPkU8uF/ETGz01gjB
 v4kw==
X-Gm-Message-State: ACrzQf3S7CPMgWdxkuen0WNLyUjqYxcT10XJx0eYuM2Mv3Zes2fTth4h
 fPRAqUf0ByHZH+2MqwAu/Xa1o4hPRWo=
X-Google-Smtp-Source: AMsMyM4ko2OsoLvqzFyYKz9/I+3Jr5HBRqjQ9HRHF35ITIEOD8mTj17ITtdRiAaAjWe/b+jAZlUVnVQHbNk=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:9308:b0:182:b2ba:755 with SMTP id
 bc8-20020a170902930800b00182b2ba0755mr27515720plb.107.1667431219005; Wed, 02
 Nov 2022 16:20:19 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:19:05 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-39-seanjc@google.com>
Subject: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792792330;
	b=Q2Y1SkAxGTxb3jXuMhhwtGYC+JRGPpw0uJx9VS89aLKAV/GC/gLe4UBnuGJIpEzMMJLF
	 T8TbhgLwAoQkrHdne5pZZ4oiPH581nNRj8vPDIi2he49yZFqT4NO1YTKfEgOJCVXUtE6B
	 hm0wt5BGWfdY/hw9PaTnysi+MbzkKcgZjW6tWmejUt2XuGgz5EcSTK+cAFw2gJ8E59ykh
	 GbqtTWeUA8njCT9gudVJqWE58koCclKCjLeKOpkzPpfg09xoN1mjudyuyTrF7hQp24sAe
	 oJLP4FhKoLvQfDhocpxq1/Sk3HFuwAaXkP4wk9IgdWLiU9rRr+u98g/gM7VD08JQv6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792792330;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=powphZXLhH8S0DAbGwSawM8KqytfbP1cF9uHOkKWMWI=;
	b=iaRfRIbPoTPEFbr54jH78E2Iy0C91uCASFG0GZCeTLG/CWfLDMs+etn9OrPdL7uIE8yZ
	 Qaw9dKfB7SkVUjXUcY6QIBlw66eji+6uWCWEq7X8NiMJKywMFmS4RmWRjXaM4cUADoLpr
	 kT57Wqpbf3FAXIWwcAzw/7Aq5KnuHDMWo7Et5+yAEQVhDObrqhohBRm1/v6ix0+t8w0qz
	 lMPvKC916oCsby05+iv/iC1AuhRLCDDhRyHdYtEDMyXgl860ygB7etrfAQhTOuwveG0ph
	 Ru12v3ZNZ13wQvTGB/ZPL9+0y47PB3AP0RW2wZvveLHlmIfIzJ9aY5HvLSHejTvCYwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HUSBEIWy;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C01606A31E
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 21:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0C01606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HUSBEIWy
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c307941971so1656844b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 14:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792792328; x=1793397128; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=powphZXLhH8S0DAbGwSawM8KqytfbP1cF9uHOkKWMWI=;
        b=HUSBEIWy8xatgBO3Inn4xIFCRZLh0WfGeLthi4oo9ABHuAaxwqYiinXvCwiB5CN64d
         hm3jD8bcSYGt3x4RxcyYQ1pQq/BrpS8cMiWRYILZmstvkgA9mcSYam1+Iwk/M8D6WSBC
         CX2kDSgSUAxUZ3Z4AzpaEVV9a+S/ReIwoO8BPhruQ24av0W3Q2D9MkwE3miBCpj4Kgpt
         rkXzFmYbqGOqMsTnqgQyjAFGEUt4vNW7yTZT/b1KjJLRNuaKZYJGjF2zvxegiP56eHF0
         XmxC0BghjmqmNJEPO2xLK6U/vGBJ0VCD/nvLULp0o2I+6NiGQeC8hUES6heMp10x7GDg
         hDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792792328; x=1793397128;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=powphZXLhH8S0DAbGwSawM8KqytfbP1cF9uHOkKWMWI=;
        b=ss47AQXySyaUh2YtVE5EqoIjqrj/76Nwq/dPtcYB6oueheYUv/hYWe4RPAhP6gz25R
         KvV6JYlkJXWroEY+MfTT64ji58uE20pUBg+soOwjBIOHsm88JtBF5zbacoxSphFuYcZ0
         i4qkJxIgwL8Y/4Fi7Gb7thHB63i9XpR2UWGJJy+ETFlNMclmao0kKWsVsHUgQsBfw6FP
         X2S2dbHeowFB2BjBNbhsPDhQ89R0iLNoTCiQyEdThJj3ORuc3QAF/iCS0J97LuIvuams
         wfuG4J7lAxfQbghwqMvV3Mmjg5gHgmcKZPO9O/vadvgGb69LThU+quRlYUYT4GlL6FYn
         QufQ==
X-Forwarded-Encrypted: i=1; AKwUvBzNz6YzFaAFbO6VTEJKS0tCzSj05u8HFQ/N29moX2HDWymtOpGCoqqvNJSX7zwQ3kRW69ldqp0=@lists.linux.dev
X-Gm-Message-State: AFq9FYLJ8ls5AeqHGKG5JL5Fj2U7C4PiruSI8p35a6qRAJsBOHZxAR6R
	VawgX6ZV8tIArVavdEAj7IfBD4J+R5Zh6RUJs+ySMk1xRSLRlCvwPXa8BIDmjY2e9QCl1FpZ/Jo
	BlvyY470e02FMiiJQEOpi9dQgCQ==
X-Received: from iocou10-n1.prod.google.com ([2002:a05:6602:c30a:10b0:9c4:1f4b:e117])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:11c8:b0:4f7:d324:bc36 with SMTP id 5614622812f47-55c002fc6a9mr386149b6e.43.1792792328262;
 Fri, 23 Oct 2026 14:52:08 -0700 (PDT)
Date: Fri, 23 Oct 2026 21:52:07 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261023215207.1465369-1-coltonlewis@google.com>
Subject: [PATCH] irqchip/gic-v4: Use a separate lockdep class for vPE doorbell IRQs
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: Radu Rendec <radu@rendec.net>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

By default, init_desc() assigns the shared irq_desc_lock_class lockdep
key to desc->lock for every struct irq_desc. Device drivers that
register an IRQ affinity notifier establish a lock dependency chain of
&irq_desc_lock_class --> &pool->lock --> &p->pi_lock --> &rq->__lock
when irq_set_affinity_locked() calls schedule_work() while holding
desc->lock.

On GICv4 systems, scheduling out a KVM vCPU calls kvm_sched_out() ->
kvm_arch_vcpu_put() -> vgic_v3_put() -> vgic_v4_put() ->
its_make_vpe_non_resident() -> irq_set_vcpu_affinity() while holding the
scheduler runqueue lock (&rq->__lock). Acquiring the vPE doorbell IRQ's
desc->lock establishes &rq->__lock --> &irq_desc_lock_class, triggering
a lockdep circular locking splat:

  WARNING: possible circular locking dependency detected
  ------------------------------------------------------
  VCPU-0/109705 is trying to acquire lock:
  ffff0001e41e4cc8 (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x5c/0xb0

  but task is already holding lock:
  ffff00dad15fd260 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x23c/0x1850

  which lock already depends on the new lock.

  Chain exists of:
    &irq_desc_lock_class --> &p->pi_lock --> &rq->__lock

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(&rq->__lock);
                                 lock(&p->pi_lock);
                                 lock(&rq->__lock);
    lock(&irq_desc_lock_class);

GICv4 vPE doorbell IRQs are internal to KVM and GICv4, set
IRQ_NO_BALANCING, and never register an affinity notifier or queue work
under desc->lock. Assign a dedicated lockdep class to vPE doorbell IRQs
in its_alloc_vcpu_irqs() via irq_set_lockdep_class() to prevent this
false positive.

Fixes: 8e01d9a396e6 ("KVM: arm64: vgic-v4: Move the GICv4 residency flow to be driven by vcpu_load/put")
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

Notes:
    An LLM-based coding assistant was used to help analyze the lockdep
    report and draft this patch. I reviewed the analysis and the change.
    
    Tested with this patch applied to a 6.18-based kernel (the affected
    code is identical) on a GICv4.1 host with an idpf NIC and
    CONFIG_PROVE_LOCKING=y: bring an idpf interface up, then run the KVM
    vgic_lpi_stress selftest pinned to a CPU shared with a busy loop so
    the vCPU is preempted while its vPE is resident. Without this patch
    the splat fires on the first run. With it, five runs are clean and
    lockdep records rq->__lock -> the new vPE doorbell class instead of
    irq_desc_lock_class.

 drivers/irqchip/irq-gic-v4.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 8455b4a5fbb0d..68ee288f6a076 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -157,6 +157,8 @@ static int its_alloc_vcpu_sgis(struct its_vpe *vpe, int idx)
 
 int its_alloc_vcpu_irqs(struct its_vm *vm)
 {
+	static struct lock_class_key vpe_irq_lock_class;
+	static struct lock_class_key vpe_irq_request_class;
 	int vpe_base_irq, i;
 
 	vm->fwnode = irq_domain_alloc_named_id_fwnode("GICv4-vpe",
@@ -183,6 +185,8 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
 	for (i = 0; i < vm->nr_vpes; i++) {
 		int ret;
 		vm->vpes[i]->irq = vpe_base_irq + i;
+		irq_set_lockdep_class(vm->vpes[i]->irq, &vpe_irq_lock_class,
+				      &vpe_irq_request_class);
 		ret = its_alloc_vcpu_sgis(vm->vpes[i], i);
 		if (ret)
 			goto err;
-- 
2.56.0.257.gf7497c7d27-goog


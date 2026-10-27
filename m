Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124372;
	b=tdzR/7maj1I6ph4s8SLMBV8FHXVmZOTZSCF1YrdCyetB4tAzCSh78+XeePo6+Bu2hy7o
	 uk/2PGaNB5C/kQtW/U+S8VoCqNDWGh3Z5UJj5IUBZ2X/Qo11KlIwDm0k+qaiC0QNigT6O
	 IDkMsxtv5N5PbWmAN/S1NEhCv23v/1Hzc5GR8UWMlPi07t3c9a12QwZXRof3d3mCvq3DF
	 usrKjcPWwHg3/HVDcpctnBTwBudKQaUCyMYdgk2uwjPB8GlJ/EkPygE2ddT919tpxW1h4
	 SdVtnbDyAXbyp5eWK5YcvGGpMqv0KS6geOS5reXpPAnW1qlxoOz2ViGKnRpSXsiAM4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124372;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=TxYi1TQ/n9gm4Dyl6a+4Ba89b3B/1LYi/mstI8Zdh48=;
	b=qhpYRRsn/CTjWF7MQ3V8hbtg8FzK0wGD4sgdsI9w2TPlMQETPSehg0hTqhIuGYFD7LZv
	 9HrQKkvUev4lAThf6PsFYgqEl0DgYDw0UlH2MzqH7yYmRnXGCqeBIueX/xpZnoh9NcT9V
	 ofj5cSq+ed3AStcwoC1uCzuiZBpswc/TjxQTiqFOu19rh3ovOK1aoBWctgpmEajBMGLOR
	 2S1ql4Dqb+gLyuzg4hOu0XW/TcmSLWY5AP+jPj0phlycBYtL0diGTq7tLMsxu4fZwZ8GM
	 0tQ6AtM8ewc5qVQINePRtVKITNbo2hykvEhWb+8VErJsNH63ICJ8Syc7j/F+QzJr9GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cTgkSpDg;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC00606A320
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 18:06:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EC00606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cTgkSpDg
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-5587351d419so157390b6e.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 11:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793124371; x=1793729171; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TxYi1TQ/n9gm4Dyl6a+4Ba89b3B/1LYi/mstI8Zdh48=;
        b=cTgkSpDgAwcvyApe51MpjHOme2ZM/xqNsNZFywBtlD/ELcpv083YWV1VR9Mnr+lhI3
         IKdU20ATFImssL5MqcUXnYRO+ZVpIJPKcfRh+P4bL8n8y6yEtLkqtmAlZuQjiuZC+YMt
         K6+N0BaYP+h0H84+thaIFlZxuDZUYJQpUF8EBih//qCKcGj/50bQNu+JMBjFiRw32OUE
         jEnv9FVec6iFz8FKTm8PAHdMISshvO8nPu+ssn+PKOIKS8w4zmaq1onTuq64MIGoNOeC
         Ugvpk14pj/acJhQ8WbJDA5eUcLrbMFdunz8ua3g/XE0ACe2glGiepemzq3W9aR0jMsHI
         E3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793124371; x=1793729171;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TxYi1TQ/n9gm4Dyl6a+4Ba89b3B/1LYi/mstI8Zdh48=;
        b=MTq4vBxjKyFDiiwN6tniFIXKYdhwKcWC1LpDFaWpQwjldLgJc3yhUC9BXoZe+WQdHK
         CaMTwuKntTUsYkU0sc1Or6q/95D/pAHYRmo6T7DEEBOmgbuVy9o9FisQO6fvlVyd0Qpa
         kD3w2j9AmbQ/KUWeCNwd+x4o1OE0bTc7UK65H3ChBbE1TWnWCLL1nxMlzXMkAK2NpHxm
         tLgkY0MqRYMI7jb3iM1ul1nXJN+S0/sHyq9eiP9sQA8K4w3jTkjH5u4IVUqcsY3v743A
         J0/5OCgKV0ZkKzLjDZxQ+2niVoIGONpWWUbJY5YaZNq0vsn4YoQPRP9a9BjfaF9IOoOp
         BbXw==
X-Forwarded-Encrypted: i=1; AKwUvBwKN6ejC1GANmJayfQDa0ugZRh8/HUfes8HQl5xgedq2K7Xo0TQzTPw3qrZOT0OpII6tLvgHPs=@lists.linux.dev
X-Gm-Message-State: AFq9FYKjGddHuemmX7VlbK3coIgSNl/F7nRfPvDzATmFqsxmzJ963EqR
	G+TLHa7ReVqUnj9m/MpZ6ha4Cj0EMcocG6OEh1orxdWMbLGJiyaHsGtjmwIaqo6guFY+hN31zvB
	ympRw1mzM+NLa/Y7oDFDUXLKMtA==
X-Received: from ilei7-n2.prod.google.com ([2002:a05:6e02:61c7:20b0:516:a6c6:8fa3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1694:b0:53a:8c5:d7d7 with SMTP id 5614622812f47-55c003426cbmr6749991b6e.58.1793124370805;
 Tue, 27 Oct 2026 11:06:10 -0700 (PDT)
Date: Tue, 27 Oct 2026 18:06:09 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027180610.2840837-1-coltonlewis@google.com>
Subject: [PATCH v2] irqchip/gic-v4: Use a separate lockdep class for vPE
 doorbell IRQs
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
under desc->lock. However, under forced IRQ threading (threadirqs or
CONFIG_PREEMPT_RT), request_irq() creates an IRQ thread for the doorbell
handler, causing irq_set_affinity() -> irq_set_thread_affinity() in
vgic_v4_load() to call wake_up_process() under desc->lock and establish
a real desc->lock --> &p->pi_lock --> &rq->__lock dependency on the vPE
doorbell IRQ itself.

Mark vPE doorbell IRQs with irq_set_nothread() so they are never
force-threaded, and assign them a dedicated lockdep class in
its_alloc_vcpu_irqs() via irq_set_lockdep_class().

Fixes: 8e01d9a396e6 ("KVM: arm64: vgic-v4: Move the GICv4 residency flow to be driven by vcpu_load/put")
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

Notes:
    Changes in v2:
    - Call irq_set_nothread() on vPE doorbell IRQs in
      its_alloc_vcpu_irqs() so forced IRQ threading cannot create a
      desc->lock -> rq->__lock inversion via irq_set_thread_affinity()
      (Sashiko, Marc Zyngier).
    - Link to v1: https://lore.kernel.org/r/20261023215207.1465369-1-coltonlewis@google.com
    
    An LLM-based coding assistant was used to help analyze the lockdep
    report and draft this patch. I reviewed the analysis and the change.
    
    Tested v2 with threadirqs and CONFIG_PROVE_LOCKING=y on a GICv4.1 host
    with an idpf NIC: confirmed vPE doorbell IRQs remain non-threaded while
    normal IRQs are threaded, and co-pinned vgic_lpi_stress runs after
    bouncing an idpf interface pass with no lockdep warnings. Also
    compile-tested for arm64 against v7.3.

 drivers/irqchip/irq-gic-v4.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 8455b4a5fbb0d..e1e20aeb8fe2a 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -157,6 +157,8 @@ static int its_alloc_vcpu_sgis(struct its_vpe *vpe, int idx)
 
 int its_alloc_vcpu_irqs(struct its_vm *vm)
 {
+	static struct lock_class_key vpe_irq_lock_class;
+	static struct lock_class_key vpe_irq_request_class;
 	int vpe_base_irq, i;
 
 	vm->fwnode = irq_domain_alloc_named_id_fwnode("GICv4-vpe",
@@ -183,6 +185,9 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
 	for (i = 0; i < vm->nr_vpes; i++) {
 		int ret;
 		vm->vpes[i]->irq = vpe_base_irq + i;
+		irq_set_lockdep_class(vm->vpes[i]->irq, &vpe_irq_lock_class,
+				      &vpe_irq_request_class);
+		irq_set_nothread(vm->vpes[i]->irq);
 		ret = its_alloc_vcpu_sgis(vm->vpes[i], i);
 		if (ret)
 			goto err;
-- 
2.56.0.307.g5fe7bd680c-goog


Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D373321A45D
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 18:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680933; cv=none; b=tlFaWkxslZk4wWUFM74Ud2PPZx4ehas/C2jppDC+TCGlJ15qKwR0ZvDm4ypSIwiJTY+nBwT5yH6AaN1ao085zVBMln4LzBDGTI9jomAiMdOBuo2Sbt1yvwXYUUQGD27eE5EmwJSYqEsmBjZ19O7fes9n0MYTs96HSaRIcaAe7tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680933; c=relaxed/simple;
	bh=PVxAs9rpAxsfjcWBD9TZ2qf4+mcelQdBBqGnvo71euw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hnTj3cTrBrOTLGfFLsKR2wBOTnw/xJMWgBMv0j6NhNoaT0Hos5sq7t3wIGB1W0owuJXSW0wnlc9kwyXRcrmiDz6ci3NDl1g2lmOjbeYy2Ejr1MgesQDRIpVnO+4vKPuG0+obzSS4aut2KvaoIG9pT07cMWIPxsCUcNlb18vy+gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=10tR2ZfF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="10tR2ZfF"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e0fee541so2728092a12.1
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 11:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680931; x=1748285731; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=z3P69QZyor5mPxi6VRLU63qMkHWb4fsadpuY2Dn6pwA=;
        b=10tR2ZfFTPxjsZjj2NSPcQ9QsI5NkF1vZIxuZSETHVvFeRdKnpJhL8/lmHUugKzAA1
         e+eZ8rlkVhaN3O48KiXEQSCLsDwYDhyVau0dRmT5of0sd83SpdwhhVRzv2yVZHBqK0q1
         Mr9mhklWaDoKZAcSZQfj61BaJjGVGQSmS8AoCEOQ23b4vFhJn9nY/BjVjADY3nwZpT2I
         /tdR7Yj9cdP5U38ykXlae9Oo1ru2cp8sTtOZT511GK8kz+tnoZiXy9ouLKrXHP6T4C1q
         KROetKAI9i04xDxoxtYjaAxmJOltB9sQmoO2xqe4vY7iCRia6zzN0RPiXzFLLmtvPIjw
         qPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680931; x=1748285731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z3P69QZyor5mPxi6VRLU63qMkHWb4fsadpuY2Dn6pwA=;
        b=iDxMGUYCWSiLFwd8cmSrEnPvZi3oy7AgC3HAbbETlLCc8TvVKwExJn0EL38CjPZLR2
         sfj+Hg4Lz0D2JpXFuT5cX8Qia8kR2S94ezn/x23OsF8lIflIll80iI7lQPdYRtSCflKO
         HnCcd6oqV+Qin2kFeC74DXbMiNVwkcVEY3UQI/uBiBgzmZ7O5GD5StMmZ724JFgUpwgU
         yg13M7RMSJZ3OKUDQHOJJyy5TtymgS1oqd4rTK/98dKpP1t75uiwcPs7gOK9IhEhmGPK
         +qyBxN7i9NBhTUKYY/4Bo7/BLHcLvzZDz+MMiXo6AJ17Q13nhosa8xsvYx1blqbpaXUF
         1Zag==
X-Forwarded-Encrypted: i=1; AJvYcCUc86kSP0ntwYSEBt3F/qxC+F/IhJyFmUYhlJdm35qoH7HCXLNN3IfRZpaElvbbefogJAxIpWk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKy8nfhqxOJMM6ovb8SnCekRM1b3nYkYhDj7hkS2DV2GfACeLV
	PcAgZTkquiGBO6tL18uUMiutda1+oZ9I+QEteIeMFwiGqnbjXE9vPtM3jHSDZBUEct89a6/1KJf
	BnjoKDQ==
X-Google-Smtp-Source: AGHT+IFA9j9P60jaD9boVYX8hbXZAkB3Zgs45T+xHk3Xso4t9vp7uJB4CdjShK0beY0cstYrv/15W251W2g=
X-Received: from pjyp3.prod.google.com ([2002:a17:90a:e703:b0:2fa:a101:755])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c883:b0:2ee:e518:c1cb
 with SMTP id 98e67ed59e1d1-30e830c797dmr22228101a91.7.1747680931219; Mon, 19
 May 2025 11:55:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:09 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-8-seanjc@google.com>
Subject: [PATCH v2 07/12] KVM: Disallow binding multiple irqfds to an eventfd
 with a priority waiter
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Disallow binding an irqfd to an eventfd that already has a priority waiter,
i.e. to an eventfd that already has an attached irqfd.  KVM always
operates in exclusive mode for EPOLL_IN (unconditionally returns '1'),
i.e. only the first waiter will be notified.

KVM already disallows binding multiple irqfds to an eventfd in a single
VM, but doesn't guard against multiple VMs binding to an eventfd.  Adding
the extra protection reduces the pain of a userspace VMM bug, e.g. if
userspace fails to de-assign before re-assigning when transferring state
for intra-host migration, then the migration will explicitly fail as
opposed to dropping IRQs on the destination VM.

Temporarily keep KVM's manual check on irqfds.items, but add a WARN, e.g.
to allow sanity checking the waitqueue enforcement.

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 54 +++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 04877b297267..7b2e1f858f6d 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -291,37 +291,57 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	struct kvm_kernel_irqfd *tmp;
 	struct kvm *kvm = p->kvm;
 
+	/*
+	 * Note, irqfds.lock protects the irqfd's irq_entry, i.e. its routing,
+	 * and irqfds.items.  It does NOT protect registering with the eventfd.
+	 */
 	spin_lock_irq(&kvm->irqfds.lock);
 
-	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd != tmp->eventfd)
-			continue;
-		/* This fd is used for another irq already. */
-		p->ret = -EBUSY;
-		spin_unlock_irq(&kvm->irqfds.lock);
-		return;
-	}
-
+	/*
+	 * Initialize the routing information prior to adding the irqfd to the
+	 * eventfd's waitqueue, as irqfd_wakeup() can be invoked as soon as the
+	 * irqfd is registered.
+	 */
 	irqfd_update(kvm, irqfd);
 
-	list_add_tail(&irqfd->list, &kvm->irqfds.items);
-
 	/*
 	 * Add the irqfd as a priority waiter on the eventfd, with a custom
 	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
-	 * underlying eventfd is signaled.  Temporarily lie to lockdep about
-	 * holding irqfds.lock to avoid a false positive regarding potential
-	 * deadlock with irqfd_wakeup() (see irqfd_wakeup() for details).
+	 * underlying eventfd is signaled.
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
+	/*
+	 * Temporarily lie to lockdep about holding irqfds.lock to avoid a
+	 * false positive regarding potential deadlock with irqfd_wakeup()
+	 * (see irqfd_wakeup() for details).
+	 *
+	 * Adding to the wait queue will fail if there is already a priority
+	 * waiter, i.e. if the eventfd is associated with another irqfd (in any
+	 * VM).  Note, kvm_irqfd_deassign() waits for all in-flight shutdown
+	 * jobs to complete, i.e. ensures the irqfd has been removed from the
+	 * eventfd's waitqueue before returning to userspace.
+	 */
 	spin_release(&kvm->irqfds.lock.dep_map, _RET_IP_);
-	add_wait_queue_priority(wqh, &irqfd->wait);
+	p->ret = add_wait_queue_priority_exclusive(wqh, &irqfd->wait);
 	spin_acquire(&kvm->irqfds.lock.dep_map, 0, 0, _RET_IP_);
+	if (p->ret)
+		goto out;
 
+	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
+		if (irqfd->eventfd != tmp->eventfd)
+			continue;
+
+		WARN_ON_ONCE(1);
+		/* This fd is used for another irq already. */
+		p->ret = -EBUSY;
+		goto out;
+	}
+
+	list_add_tail(&irqfd->list, &kvm->irqfds.items);
+
+out:
 	spin_unlock_irq(&kvm->irqfds.lock);
-
-	p->ret = 0;
 }
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
-- 
2.49.0.1101.gccaa498523-goog


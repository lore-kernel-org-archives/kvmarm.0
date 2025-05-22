Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ACD2D4B6D
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 23:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957971; cv=none; b=YdsV6503AjJdjM9I9dT8zScP+lV88nLfiwHtFA+657u6IqXDconWUEvoLWJC5cANLgBmQSCy021xcZRElUBWqRz/9sxRiKA9BD5KLDoBDYUa/Hw+nTCCEfZjRem6c/Vt1GxkAviHW3WRxqDD/QFaqiM/mOtevc8JWkG3ZTEbHB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957971; c=relaxed/simple;
	bh=Ob2er87zWf/jP9Pn9aYWe5PdITMURa6xwa9Ym10iWu4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MGmJdjR1dMmDd5bg3XATIDbkSphF2Y+PWsrS02jaBygJ6M/MMPRLUeA/nymFpbtfAgWlGtevIDqSPWFrAowZ03sjQ38r3wFmk5iQb8ktmLpDHQHspQ1bz+lfsyXKdlgyxDesLcnzASMgjIqCTlXRY/F/l/iYG3WBQ4YC3Dedlp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lnLMVXU3; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lnLMVXU3"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73c09e99069so10208638b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957969; x=1748562769; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m999gU/AqGpWG+L7ciDbK5wL4BJk8SCse59imt7h3LE=;
        b=lnLMVXU3atb2JrY9++ld7CY3NpQC1iPKYswG7yJbHHGYx1N4K2gXgJx1tn9l+PMtuu
         gvDeZ4oWgbPfT2qBDLgO/i/JxTxIoaHR5WFeMt5+LTWw8SNOJwsLOSGtE+XjoFfouuA2
         nNnAscwwdwN7JbNsMeXGdMWf5by7rKneG24fl7M8LhN6Iy04TuVF1V0BfsMLCWVZGTIo
         2F9hTAnW4qN4mjHDVULuQMd1z75IOlhGcjNkn3frqqXr2oUDO5G0zMx2S57Ft9aj3ovd
         7WrXbBNoiQj3zIy2YEjVS7MQUcNTomYLEzzDBdneGYqX5kXs92MfApT7n3P6rFf8XNkt
         GFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957969; x=1748562769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m999gU/AqGpWG+L7ciDbK5wL4BJk8SCse59imt7h3LE=;
        b=JKRYZ0V0yPhAzz8ceWS5cC9cQcNmUGYICirt5TjyMAf7093C5htFdqykPts5MhlUGQ
         Qc1Sz7gzBO2piVE8sKvsjiqNIm677/a/GjzjE/0D9JeYGNMWkV2NWTT+iyiLtyq2OXRG
         SO60ggYZ0UAOzNrxu5Elj8yykoFG1Cm/3g/c61MNYQzjlHFEuEZ01ftYmZo4idoe3gvU
         /Dg+QmHhGd3ES6EAaJNcED4CxEC7pxgU8i50TN1YXABEmVuWZT6jgOfh2LTEFatuf8o1
         NHNacaNqdx+QYsLl3TVKe5nXAvdZbxVXQLz3oISy/4dIZMYCu7qeMrRD9WnBA6PuWLWe
         akyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDV6iqlXRmKiLLs6JV4V7cOXsZEgQ6bQ7JhK4njGGERoUKLFqAqlutJ+uHf0Ag+OkhchIExTk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjZwI06Zyyb0B5EEpxlb7Sxqz1YQZL1DTm332HG1OcJRMl1umo
	bwLVf/UM9Z2D9+wlRZFSkgJPy+YbjrmEi05l2shnmRbKpJuE/IjCccHS3PhTB+1vSQQDYiGVdZ+
	XZxE69A==
X-Google-Smtp-Source: AGHT+IGGw5zwjY0zFLgdg4fHQ7nOB9U/xbrTeYpuWgtfAceUKGlpNANWH4gnTKB5jligEj9ALMrYFDn6jAg=
X-Received: from pfjd1.prod.google.com ([2002:a05:6a00:2441:b0:730:743a:f2b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3c82:b0:742:b3a6:db16
 with SMTP id d2e1a72fcca58-745ed90b8e2mr1286378b3a.20.1747957969447; Thu, 22
 May 2025 16:52:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:19 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-10-seanjc@google.com>
Subject: [PATCH v3 09/13] KVM: Disallow binding multiple irqfds to an eventfd
 with a priority waiter
From: Sean Christopherson <seanjc@google.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>
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
 virt/kvm/eventfd.c | 55 +++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index c7969904637a..7b2e1f858f6d 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -291,38 +291,57 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
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
-	irqfd->wait.flags |= WQ_FLAG_EXCLUSIVE;
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
2.49.0.1151.ga128411c76-goog


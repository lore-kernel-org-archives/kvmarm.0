Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC23C2D3A78
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 23:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957966; cv=none; b=IjNOdeowjTZsbYeu70TeNDlpzqIFvJboGECeu8MJJuM5RLvKdq+uz8Nc08vrU98TndvjOgUZ2BQtYg0F7zX2hb4cGEQbvd0giulVR0+IBbZPWGDYnrKB0yuJNoATyUNc6Aax9A1NWCOdbP+B9tHgvuhsDI0yQ/mN2HrZwXlKac8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957966; c=relaxed/simple;
	bh=Q+vc4pb6WDvcUQF3b0USVqnlp5sa+HZsP4+IXWQxYWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lE+ha63X9wpqkagaEJ3yKEFUPjW9TZi+/vtwi5DvWHKwT4KL0f20zx7aJrNPrjHzfh+st9ImRfDa9zBjWV9CDViE1ovLDxNy2mO2+/uk/0Xk9kUV5gnljkOwKCk8zpVw+A+V7M2ybfkN4VQSzGxEcoL9JjRb05yCJgn3CJt/FJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RXDa/Fzu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RXDa/Fzu"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ebd48a3c7so5673947a91.1
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957964; x=1748562764; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MSc6nvEfNa3Mk9v70O2GwrdpOydgfEuVH7IGLa1xnl8=;
        b=RXDa/Fzu6C1pxCxiisGCF9BEhxhL7HUTv9aH0bevJP+6XC0YqIKqAOl9WzyQThVMVh
         vrpLM+R+7X5kEiSO7Kj7hoiJ0xQH8mRkMT4a+8VdvizXu+zhPz7wXcjuUj5ZIuS/YqNE
         9UqtVqaZUGAby0Yy3UaFvNNg3qrmKUQkr/IvHuOGjE5/F0hpynUykG//J/MUJC6tf8x+
         gGSZ4JVZS0mSvHB/cLXqFf4wj5Xyq9gcE6kRoZ+o43Hg0VS+o0acrUi5W1Jw+MjHxAXH
         pW0DMAQRlrSQXCOltAAjy0fZ99vtT5E5YKfdSowBvcqLLTWSb2ip44SC4DXlyzS7098j
         getA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957964; x=1748562764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MSc6nvEfNa3Mk9v70O2GwrdpOydgfEuVH7IGLa1xnl8=;
        b=pNuDDd/l2NmhtLOtJePgxVlscfsAzp2D0CXiFbF+f7lSWYPKxowp7h4X2z+gKV4vdm
         UoXAjS43sV0EOpR0zlGKIw4MyiQ2VEfihNi6Lk8Dcc/INP/Hhxvjufzk1mNl5e6JftO7
         gdf4CrmFgGt2uJeSwNEeY1tSUsr+jRYyTZoDmooRrLK+SmkmxfEilROryS1oCmL5wLu5
         ZleCrF5ZApaH3iEsRRMFwGg+JZgJs23wjOs6Bdr5ZKXx9qLCmSj+OVpG+ooTgLt9+iBJ
         xH7H/YovQNgeuAEmU9T9PnUaElnvHNLDk5w5d8CMPJElbWzlQY8hPW/Q9AWhjxtFlflt
         uQuw==
X-Forwarded-Encrypted: i=1; AJvYcCVImSpBtiowI0PoR+JY4DWWO3+JvG1b3wkEaXOAI+eriZBT0w3tl84PFzFMTUkfCayWBJsTK0k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSXnmLrFRj36/47dFIq7nvCHjdaDxktJWj2q7oiQ8Rb8eKep3u
	gR8+wiMxEGa95DRUVAHaE5xPmHvlu7IlQVQmouwFQmfPpvri04XqMee6oYHXowOqpZw3bYfZT/M
	UB5yJFw==
X-Google-Smtp-Source: AGHT+IFtihXA1ixlkcjuYPXGi/3nyMcTJqsYkMUIphzCaA6DcRFEslloczpIHH8OqTcj441vz3MgX+UAWJI=
X-Received: from pjb7.prod.google.com ([2002:a17:90b:2f07:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c02:b0:2fe:80cb:ac05
 with SMTP id 98e67ed59e1d1-310e96c946emr1657552a91.9.1747957964380; Thu, 22
 May 2025 16:52:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:16 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-7-seanjc@google.com>
Subject: [PATCH v3 06/13] sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
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

Drop the setting of WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() and
instead have callers manually add the flag prior to adding their structure
to the queue.  Blindly setting WQ_FLAG_EXCLUSIVE is flawed, as the nature
of exclusive, priority waiters means that only the first waiter added will
ever receive notifications.

Pushing the flawed behavior to callers will allow fixing the problem one
hypervisor at a time (KVM added the flawed API, and then KVM's code was
copy+pasted nearly verbatim by Xen and Hyper-V), and will also allow for
adding an API that provides true exclusivity, i.e. that guarantees at most
one priority waiter is in the queue.

Opportunistically add a comment in Hyper-V to call out the mess.  Xen
privcmd's irqfd_wakefup() doesn't actually operate in exclusive mode, i.e.
can be "fixed" simply by dropping WQ_FLAG_EXCLUSIVE.  And KVM is primed to
switch to the aforementioned fully exclusive API, i.e. won't be carrying
the flawed code for long.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/hv/mshv_eventfd.c | 8 ++++++++
 drivers/xen/privcmd.c     | 1 +
 kernel/sched/wait.c       | 4 ++--
 virt/kvm/eventfd.c        | 1 +
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index 8dd22be2ca0b..b348928871c2 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -368,6 +368,14 @@ static void mshv_irqfd_queue_proc(struct file *file, wait_queue_head_t *wqh,
 			container_of(polltbl, struct mshv_irqfd, irqfd_polltbl);
 
 	irqfd->irqfd_wqh = wqh;
+
+	/*
+	 * TODO: Ensure there isn't already an exclusive, priority waiter, e.g.
+	 * that the irqfd isn't already bound to another partition.  Only the
+	 * first exclusive waiter encountered will be notified, and
+	 * add_wait_queue_priority() doesn't enforce exclusivity.
+	 */
+	irqfd->irqfd_wait.flags |= WQ_FLAG_EXCLUSIVE;
 	add_wait_queue_priority(wqh, &irqfd->irqfd_wait);
 }
 
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 13a10f3294a8..c08ec8a7d27c 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -957,6 +957,7 @@ irqfd_poll_func(struct file *file, wait_queue_head_t *wqh, poll_table *pt)
 	struct privcmd_kernel_irqfd *kirqfd =
 		container_of(pt, struct privcmd_kernel_irqfd, pt);
 
+	kirqfd->wait.flags |= WQ_FLAG_EXCLUSIVE;
 	add_wait_queue_priority(wqh, &kirqfd->wait);
 }
 
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 51e38f5f4701..4ab3ab195277 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -40,7 +40,7 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
 {
 	unsigned long flags;
 
-	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
+	wq_entry->flags |= WQ_FLAG_PRIORITY;
 	spin_lock_irqsave(&wq_head->lock, flags);
 	__add_wait_queue(wq_head, wq_entry);
 	spin_unlock_irqrestore(&wq_head->lock, flags);
@@ -64,7 +64,7 @@ EXPORT_SYMBOL(remove_wait_queue);
  * the non-exclusive tasks. Normally, exclusive tasks will be at the end of
  * the list and any non-exclusive tasks will be woken first. A priority task
  * may be at the head of the list, and can consume the event without any other
- * tasks being woken.
+ * tasks being woken if it's also an exclusive task.
  *
  * There are circumstances in which we can try to wake a task which has already
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 04877b297267..c7969904637a 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -316,6 +316,7 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
 	spin_release(&kvm->irqfds.lock.dep_map, _RET_IP_);
+	irqfd->wait.flags |= WQ_FLAG_EXCLUSIVE;
 	add_wait_queue_priority(wqh, &irqfd->wait);
 	spin_acquire(&kvm->irqfds.lock.dep_map, 0, 0, _RET_IP_);
 
-- 
2.49.0.1151.ga128411c76-goog


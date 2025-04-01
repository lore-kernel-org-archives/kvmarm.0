Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4789D1EB182
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 20:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540411; cv=none; b=RX9xMPPDzCi8V0/Ea5+MBMYP0Ilu97tB56WYHAtob9YEHMDmdQBk6/R0XBKxazFNE4aQLGz+mHmgsprGyDGQKxc0KFBbrk+bv7EZdBQjmCAS/DlwZVLawiQUSCIMbRPyJ2m3FkJM+0nS8cEMfNzm3mMPM7JjCnC0nRKahGpO5n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540411; c=relaxed/simple;
	bh=4JC9vDgpuY3Y2FxwMbdW8RzZ4m05ZUKUwd4bktvUCtE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ny2w2dES6uYNDbgAmGONb+x6Fspww0guivdBbYQ7CL+E+oTKbxgYMIyVaYRYivWl3GSXeeK0dkOOtEJ5WW7Jfn/i25DIVyzoTvrdqiIVL+V8jC3WD8gBYbZgHeQrULaScMPxZeumZzZ1+/dgnkTtNnLcF0vsgpu5DUwlh9o7JTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YlQKmTSn; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YlQKmTSn"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2264e5b2b7cso108632695ad.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 13:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540409; x=1744145209; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=amBezYkVNcZuyH4EZC510WvPXbGr3Dq+FrBRP4RH3+k=;
        b=YlQKmTSnsWnNqoOZYY/aMlM7unz6EMczVF7vapMV6iICgF/HpzQstXUrX74zHtagVR
         u1wHSqP6Nx9ihqoODgJG0rcLMFSitEq7KtRJjX9QIIX8YyM7na+MGxQc1LkOCWffPaXH
         Ogm2pQebX7btgJuVyU5f/WiqFZSxc5rTcBfq88/6tr/QrKUUfikDh/9z3pUzD3NWdk6V
         Plf3tm6XbbK+NnjIraiYTXKztvVhywc73Lwj93rnx/wwPkEsuA5yxjVQ9A99A3kPtxMV
         2FxIbew8laYbqsYF/lHoZ7nOKiMVU/QLtHkaVw7eoYNzsEqjWFLFfgCytLy0vaf913YB
         xXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540409; x=1744145209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=amBezYkVNcZuyH4EZC510WvPXbGr3Dq+FrBRP4RH3+k=;
        b=OirdB/3+ehhaz/z41TXPp5S+uavfGgDw3gMeJO2kIOQvaKZFHXGrSYSoLN4GusA/JR
         Kh3fAKOR321I2eFH6aM/xLxwt/q5liQy43DA5rKJQFp1IK2yyw+vNmEKPe+NwlMuQlrw
         u9DCgdlQIDalCi35vG7hzeZBaYjVU6QmJ4oI8JnPobUhmHRJbT80VLTwT8P24rKbBqCd
         2uD++N/yDQAIhTGjXLPAodrxFxte5c0ai2QeD14VKxKp8Rpk6dBMYBjEn/e7kesOHB4o
         A3+UC8WlN8R1YWAdBEP4aAYpjCq2hT8YE8YfnTC9KeA/CDRrJc1rg3DBmK9RInQupDP4
         VCrw==
X-Forwarded-Encrypted: i=1; AJvYcCVtOCa+kT6sPbFUTbYctZ3n9hUWC0qCCDTCnDqvuLE2sja7RysUP8OTGsF+XYn0Y5h2IuylncY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8n/vmLGdYy12B87wOaSOUmCsiNWJHqI+KlOX5ioB3uBf64rGc
	/8l872SvKH3tintRTAW1TWTmc2MsrPGTg6VTJfvhLr0w3gg6s6/cdByq+U8ed6Sm9Kj4N1jf/UA
	tfw==
X-Google-Smtp-Source: AGHT+IEa5pU5FztleJgZ0CTC7h18PjwGLO8G4GBjaSUUoGrBKG+0/CQ77Eky5VEgolWpGWv0RRLt0hcHxXQ=
X-Received: from pfblb18.prod.google.com ([2002:a05:6a00:4f12:b0:736:b315:f15e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:174b:b0:736:4d44:8b77
 with SMTP id d2e1a72fcca58-7398035e5a0mr24221681b3a.8.1743540409565; Tue, 01
 Apr 2025 13:46:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:13 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-2-seanjc@google.com>
Subject: [PATCH 01/12] KVM: Use a local struct to do the initial vfs_poll() on
 an irqfd
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Use a function-local struct for the poll_table passted to vfs_poll(), as
nothing in the vfs_poll() callchain grabs a long-term reference to the
structure, i.e. its lifetime doesn't need to be tied to the irqfd.  Using
a local structure will also allow propagating failures out of the polling
callback without further polluting kvm_kernel_irqfd.

Opportunstically rename irqfd_ptable_queue_proc() to kvm_irqfd_register()
to capture what it actually does.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_irqfd.h |  1 -
 virt/kvm/eventfd.c        | 26 +++++++++++++++++---------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
index 8ad43692e3bb..44fd2a20b09e 100644
--- a/include/linux/kvm_irqfd.h
+++ b/include/linux/kvm_irqfd.h
@@ -55,7 +55,6 @@ struct kvm_kernel_irqfd {
 	/* Used for setup/shutdown */
 	struct eventfd_ctx *eventfd;
 	struct list_head list;
-	poll_table pt;
 	struct work_struct shutdown;
 	struct irq_bypass_consumer consumer;
 	struct irq_bypass_producer *producer;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 249ba5b72e9b..01c6eb4dceb8 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -245,12 +245,17 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 	return ret;
 }
 
-static void
-irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
-			poll_table *pt)
+struct kvm_irqfd_pt {
+	struct kvm_kernel_irqfd *irqfd;
+	poll_table pt;
+};
+
+static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
+			       poll_table *pt)
 {
-	struct kvm_kernel_irqfd *irqfd =
-		container_of(pt, struct kvm_kernel_irqfd, pt);
+	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
+	struct kvm_kernel_irqfd *irqfd = p->irqfd;
+
 	add_wait_queue_priority(wqh, &irqfd->wait);
 }
 
@@ -305,6 +310,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	struct kvm_kernel_irqfd *irqfd, *tmp;
 	struct eventfd_ctx *eventfd = NULL, *resamplefd = NULL;
+	struct kvm_irqfd_pt irqfd_pt;
 	int ret;
 	__poll_t events;
 	int idx;
@@ -394,7 +400,6 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 * a callback whenever someone signals the underlying eventfd
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
-	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
 
 	spin_lock_irq(&kvm->irqfds.lock);
 
@@ -416,11 +421,14 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	spin_unlock_irq(&kvm->irqfds.lock);
 
 	/*
-	 * Check if there was an event already pending on the eventfd
-	 * before we registered, and trigger it as if we didn't miss it.
+	 * Register the irqfd with the eventfd by polling on the eventfd.  If
+	 * there was en event pending on the eventfd prior to registering,
+	 * manually trigger IRQ injection.
 	 */
-	events = vfs_poll(fd_file(f), &irqfd->pt);
+	irqfd_pt.irqfd = irqfd;
+	init_poll_funcptr(&irqfd_pt.pt, kvm_irqfd_register);
 
+	events = vfs_poll(fd_file(f), &irqfd_pt.pt);
 	if (events & EPOLLIN)
 		schedule_work(&irqfd->inject);
 
-- 
2.49.0.504.g3bcea36a83-goog


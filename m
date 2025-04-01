Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19F6211A1E
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 20:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540423; cv=none; b=N+hIWVzV1tDTZmrYRMEbEgifm3QHynXtb4trs0ToDREJt7iX4war219VpwYKgDM5Dh4zBcV9GgeGTYI2fJlTE/QechtlM7OaQ96mMsnhlBYc+Y8Ti+Kfq5EpJ7uP9zpd2Iqm55398uXgfEDq6BFLJNOxB8YmS4tx3WEny+VHXh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540423; c=relaxed/simple;
	bh=V7OL3Q/3J2xWKwnmIlSC3LoKokZ3iR0JrDzpSaKTdhE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DSMWFzpGEMIoIurUgdQoG85KnqSt1HVYxID2LfoiVCZSJyTIzvw4/a2PKAnwYSzBG4/zo/PeuYisoqAYVOp9LLqKXn7k+Zi/K8iTMehkbWzo6iaaPKVX3u0hET1cCxY9Q3kF65fqdfJNtE4xqoinsnwUd7ljc+dyU7XAVZ8SRm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A4i/p9QS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A4i/p9QS"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff68033070so10121999a91.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 13:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540421; x=1744145221; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hAOHDZe9hVA1LcrHBl8ILklpk5SqTyz1Lg9oNtA6EC8=;
        b=A4i/p9QS822m4sOmVgLsaIutgPMH1RBMo97JbDnS9qh2mTY3kVivdZlzxgqcBfTsIy
         63j8pvTI51URGw+epVI0+gRZXGzd3vlEjRyXri6lqznvGnH0xczdhpnHzw03sO94o6W7
         lF34c2u0usVo3scwx3NuFiIXzAATeO02zraEbWs9LLbENZdwnCqxG3HvtQxw6A6u5mNS
         FbRMzB1a8B0488C2i5O3W8esJkuUYyUmLANXNiodiQK+OmP/iBNl2ivS59Sb2JtordaS
         0okpSZXVh5EucPXt8hPZKvVQ+tUKIa52WZjTRDEJTu0iAa1gHNZqEUTA742/MFuH7gcR
         N5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540421; x=1744145221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hAOHDZe9hVA1LcrHBl8ILklpk5SqTyz1Lg9oNtA6EC8=;
        b=Bd0irbHHcSP/NM1Rm+R8WIcFitaP02Yii338fDbRu5w/Xs/hR2dZLvC/U+z+Md2h/j
         J3mQVAPb37QR1PiJzv+fVYcWIt/V9K+RE4qM2C9rlD8mAgKvI2CyYJ10S7HKV54TWKTq
         RktXrYrvYH0Y2PE8QF2lHDd4j300J8fdhkJoLt0WoA2UpxyZ3l7NZ+7NpJe6xbwvawsl
         FYcLEJzJbhsPnR1LUhOxnnMwa9Q/kVOrsrsBUj5nP1S2cXn6qWfYKlBbwKHoYXRkQpTj
         Nx/y6tQRN4c650998azlRfZz5dPSrfsVe3uarHGrtDlEO41zLsI5Gh04HP3fMkB1RKbG
         va8A==
X-Forwarded-Encrypted: i=1; AJvYcCVsZ0YpZZA5W7NgkQFpav0Wp1IvA2N23lomMpBShR9kK5LbYCoJjNeU3iLada+wvzCNp92nFwI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpoX+3TveHy+DDlXsYs3OsL0tqPy9QZu29173JVP86mqS8Wt3G
	Hzr4feEo4rWPdbD0aGbHIfdFXS1mY1LIhMG1sEq/7/ja7BnZoSRPDvWJele30Bib18Xhcy9F29w
	Pew==
X-Google-Smtp-Source: AGHT+IHU4ej+9xtm5sDkWeeRPmRGXEXSjICfBn2mdGglMLGC+glAIOtURcbT/pNs0Pm5Q7kEH8DQAnKQF70=
X-Received: from pjbqb11.prod.google.com ([2002:a17:90b:280b:b0:2fe:d556:ec6e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1344:b0:2ff:6788:cc67
 with SMTP id 98e67ed59e1d1-3056096950cmr5544504a91.34.1743540421162; Tue, 01
 Apr 2025 13:47:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:20 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-9-seanjc@google.com>
Subject: [PATCH 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
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

Drop the setting of WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() to
differentiate it from add_wait_queue_priority_exclusive().  The one and
only user add_wait_queue_priority(), Xen privcmd's irqfd_wakeup(),
unconditionally returns '0', i.e. doesn't actually operate in exclusive
mode.

Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 kernel/sched/wait.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 80d90d1dc24d..2af0fc92e5d3 100644
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
@@ -84,7 +84,7 @@ EXPORT_SYMBOL(remove_wait_queue);
  * the non-exclusive tasks. Normally, exclusive tasks will be at the end of
  * the list and any non-exclusive tasks will be woken first. A priority task
  * may be at the head of the list, and can consume the event without any other
- * tasks being woken.
+ * tasks being woken if it's also an exclusive task.
  *
  * There are circumstances in which we can try to wake a task which has already
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
-- 
2.49.0.504.g3bcea36a83-goog


Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0052D3234
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 23:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957965; cv=none; b=c37STI1fUGZHvjUilHm3Fwvz3mGZ6eh3CobFqs5JJ/WIzyE0ZuS0128EA6CX/6aLvVov/GmpL10HabCMVgQx2+p2gztP7wFuGJ98yCrxbVBZqwAINXKCFaAVUMk7uU0KuUXbTEuK04w4l4SK1L8avi9FSYqFGi4oiQXcWVGVyL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957965; c=relaxed/simple;
	bh=JpleTdHHK7C1xQPDlVA5bM4aXnpZtQxgRshM++nWF7s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NtzSvLXLRskL58wcgEVt0UPhTtU2fvYysC/YnYUiMOXfMh37pWI3FvmlhuGStE4unr4lfHQFYuNxF/MNRfxtAlX8uwm0Rx3nmo69awwnF+x7TqkPuv19kxUeGr3hymFCapiuOxcDQMzrCpTTDqef6KmdQdHDFVunEc9FsahlvFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K+zD8RAl; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K+zD8RAl"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2321207ff20so85330365ad.0
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957963; x=1748562763; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LLDErP7lwjTldw1/pS35D8l5zAYowrsUowCS37TMy6E=;
        b=K+zD8RAlifySMvaUaHSQFjsUpXhDql8X7N4gvCqacxfjUhvZLbNWsJ2E4RnaE0INnn
         7VgSsNCSP62grpns6hFnGieHblOO9Vm2SX6ZZj4YhwZreBOF7wH+qcs5nm5Av036pjwF
         wCfM+GCaL73DpQINFReY/4A/6WHAu9lNQyTNUUblRpzufJ0aqZn+2oPDJUhsZiLm8J02
         w3nzyGNf4F3SPNcxegKpwC7kyY9d4okKoCCHuOrNkvUEk49Q2pa6rnQ/zqRtjAmDUes2
         MAjq2XFSuvreJsT1XXYeHJ4Gv3JlleTp4X1bpDspJpx53du9ujrDZ7V2plOlpws63rLY
         xM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957963; x=1748562763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LLDErP7lwjTldw1/pS35D8l5zAYowrsUowCS37TMy6E=;
        b=oOVUTDK/ldMqFa8TUGBhn6l6dM7TCdMph7EemekOSMrOV+eZgA2hLtjx3vlrFXXMiJ
         8alWhL/zP2/1EPwbVPzqPJbQ5cOmvunkVdNZ91BOn+h5qfZmFNyyHA5R3ianz2rl/CRE
         M7WvnzSYCt7sa8rQg5tlJHrdzX1ui/p+MW2akfPrsLKln85CyClRyOghxBQackr+LP2N
         nUX7bSDRDN3mbwTM4Lyvuta6DbsHB+VBpNfrG2bl5qqJQrk27wcXw3qx16EFP3d3vbQ8
         v9UUv+DUcLb/IGraLHpRcLj3thhsT6yMO/EQ862ABH3azUiD18gT0vjtU7eNmGJVjw/M
         33Ww==
X-Forwarded-Encrypted: i=1; AJvYcCX1RWhyYECtCgtfsY27+9IUuETMIBfDZQ1Ph+KKjC/ZvHXLK5ECA1H+Mw7OQe9JPP0Zmaq/J2c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7wZ2Pzhi/qUHIZaDUN3PnlpFjh67eSAxIAceCos+ia0Vyqj5L
	xVAg/0aiJhtK9jeEaTK4w8J2ii7I3rCCBeImbq0BbR/BqOxsH/9h7fd+4kNS5VYWqPByeie9dgp
	ElQn2lg==
X-Google-Smtp-Source: AGHT+IHOq6Cu35CTphJBsObc11lhP6kmwx8FMCg+YC2dNqr/wE8KG8ou9486KEEIS+EkPDFQhABlYWoiNSA=
X-Received: from plhi16.prod.google.com ([2002:a17:903:2ed0:b0:22e:4a61:5545])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e808:b0:22e:3c2:d477
 with SMTP id d9443c01a7336-233f21ae905mr11694945ad.25.1747957962830; Thu, 22
 May 2025 16:52:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:15 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-6-seanjc@google.com>
Subject: [PATCH v3 05/13] KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
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

Add an irqfd to its target eventfd's waitqueue while holding irqfds.lock,
which is mildly terrifying but functionally safe.  irqfds.lock is taken
inside the waitqueue's lock, but if and only if the eventfd is being
released, i.e. that path is mutually exclusive with registration as KVM
holds a reference to the eventfd (and obviously must do so to avoid UAF).

This will allow using the eventfd's waitqueue to enforce KVM's requirement
that eventfd is assigned to at most one irqfd, without introducing races.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 99274d60335d..04877b297267 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -204,6 +204,11 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 	int ret = 0;
 
 	if (flags & EPOLLIN) {
+		/*
+		 * WARNING: Do NOT take irqfds.lock in any path except EPOLLHUP,
+		 * as KVM holds irqfds.lock when registering the irqfd with the
+		 * eventfd.
+		 */
 		u64 cnt;
 		eventfd_ctx_do_read(irqfd->eventfd, &cnt);
 
@@ -225,6 +230,11 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 		/* The eventfd is closing, detach from KVM */
 		unsigned long iflags;
 
+		/*
+		 * Taking irqfds.lock is safe here, as KVM holds a reference to
+		 * the eventfd when registering the irqfd, i.e. this path can't
+		 * be reached while kvm_irqfd_add() is running.
+		 */
 		spin_lock_irqsave(&kvm->irqfds.lock, iflags);
 
 		/*
@@ -296,16 +306,21 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
 
-	spin_unlock_irq(&kvm->irqfds.lock);
-
 	/*
 	 * Add the irqfd as a priority waiter on the eventfd, with a custom
 	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
-	 * underlying eventfd is signaled.
+	 * underlying eventfd is signaled.  Temporarily lie to lockdep about
+	 * holding irqfds.lock to avoid a false positive regarding potential
+	 * deadlock with irqfd_wakeup() (see irqfd_wakeup() for details).
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
+	spin_release(&kvm->irqfds.lock.dep_map, _RET_IP_);
 	add_wait_queue_priority(wqh, &irqfd->wait);
+	spin_acquire(&kvm->irqfds.lock.dep_map, 0, 0, _RET_IP_);
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+
 	p->ret = 0;
 }
 
-- 
2.49.0.1151.ga128411c76-goog


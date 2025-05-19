Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB8A20F065
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680930; cv=none; b=aV0dcQ2VLl30Yzv5vpjAQ9Fono3m5jxGm5Wp2r5lzQlPEFiC60oFmVbED8rYmtcNmJBqTK+PPt8QKnqvswoo7tGGU7JJw2iSi3GRIw14h2bg00+tGsPjq6Jh1gPCgD/TCRRVOV3NNWRKbGSA2ikvnMX28Rn3asmpHL57N4GZ5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680930; c=relaxed/simple;
	bh=WahQq1TbuZObX7S0cHAq9wgsYhpFJZsXmk63oXnHArs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PP0hOSY2MuZYpra92wqT3x7WYFyfFl1bEgA2oYbxA/pUGBqxkkopTxGPW8RnFhCzL/tjwc3xUG5cJMhCdcVrABUlPtS3DgbBBv+uo/ad9BiKwqHFR2v0pNHL8StmwztyhDH9dIcya+Va0LuZ3SlBgdiv+0FiTHVHAdfdrWGIfnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YDo5zxGM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YDo5zxGM"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ebfc28a1eso3065185a91.2
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 11:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680928; x=1748285728; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yzOWtWZ17B97iG5Cps4S6OXY8vgm63oceMRcqA1Kf10=;
        b=YDo5zxGMdBYqs904GyyME/0Hz1KG9lOtFytnBji6AaIqCiCDFkt+Kdpsn+VO+EOhau
         ncDCXaAsWJrQWVOX7lBpllInspiTcINlpVjnuUUdbZlLUog91ju/3p1kICIHcGTjSzBf
         KJVXec82CMT9sYWXPxQOm1OdCMwAIKbsDnSQUHudBdheJ270+eCOp8KRyVrmvakeC/oj
         4h9WopzvesBuM4mZO/0qzVBtuk/bhFTrYEPpG69oUsz9syQyrYR14mW7pVe9t+buUlli
         /3Wr2Up6B/oxMll0cP3zYirCnUMFfq9MDC8scGMOSnrE+ZHQMgk6P8Dug1gAm/M+kXXI
         N3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680928; x=1748285728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yzOWtWZ17B97iG5Cps4S6OXY8vgm63oceMRcqA1Kf10=;
        b=FKon/mShh2zbrP5AFi/33s+CPcqtlxQ91EfYeozbnXMAADuAZNPdRAwAUo7D+HXosI
         7GdDXHHP/FnZ2a78U+2oOtdAjWLDAEvQGXWCKx66UKxJL85tNHfVyKspcOp58d8/ghN4
         rZxEig4ZGegysgHTVaX+hqiMNQNRbJF9GSsRPD4/twkIEO6v/nxebbTfY5o7kCC2neYs
         halsubtCg5VGkUBQrW2G8bbiZgpKxssbnMKF7dx9zQOR3EMle51hZj2bB50h+X50G+Sh
         HlF972AHdhQ+gptLXqC0eb06uN3efYoucaVGEHtdHqG5xpP1bdmZfQxh0ktYpoZHBIyw
         q3hg==
X-Forwarded-Encrypted: i=1; AJvYcCXbGAqkALHxJROCrmdmd7EQRbSrkyKTnP4RPec8HM143tPtAyDvCkOvxTXPdIuPdyDgxBryz7A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyuPsVFHU4AB/Tkt9UzmZHdHG07B5mcSRp8axIE2WA3C9b69Ra8
	yP6V9lMtVDY2pFQvRWpE4fIocVsHcun0ss2gLbrRyv/lB8Gsahqt1+boMTE9U7DW20xev8rgSgT
	8E42Bsw==
X-Google-Smtp-Source: AGHT+IF4CHreF9GYhizgGap1CjiBCuQFeZKtOe+ZDk0WbGkBJzfweABFcsSXBbTResROqvG8ccbJeQWMTR0=
X-Received: from pjbso6.prod.google.com ([2002:a17:90b:1f86:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd1:b0:2ff:6167:e92d
 with SMTP id 98e67ed59e1d1-30e8323ee6emr17930934a91.32.1747680928036; Mon, 19
 May 2025 11:55:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:07 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-6-seanjc@google.com>
Subject: [PATCH v2 05/12] KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
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
2.49.0.1101.gccaa498523-goog


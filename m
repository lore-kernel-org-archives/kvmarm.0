Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F7A215F49
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 20:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540415; cv=none; b=a0NgejT20yGfFVX1beuQGjjIEQFb34Z07YRdsnyJD5DJQja7/1iFvJCBw+J+eY4E+NC+AVplqqRmSQoavCJsdYxxueVHWSRYJ6WLBqAJls+grbkdHV58PS9lcMzvJHTm7fGnM2kNfLlyf/erGhvI7uTLzRM2O7x9AB/mbNxq4eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540415; c=relaxed/simple;
	bh=n5kNCwE5Iky7W7cF5KbIIZcTecdXBfhV99PPLi3pmUQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pkSnVGKskZhJijsJnV5bXOynDc6hj/osJyA94oRZjYt4sF9FI3KSvJ5phSFwJ1EHrXg6nLuapf+7oGL1PtZKLks3NLL/fhMT9S0gvoQHftRlIt+icoRFPI2njGSk2B2U2yRNk0/8qacwmIdyeiEY9WTl5BfXOKusr6MwbB25WL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uivi/sgH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uivi/sgH"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30566e34290so1442955a91.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 13:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540413; x=1744145213; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HjN0v0W9m0IvqgYola2hOx5XLKml5O0udJOiHGE/eik=;
        b=uivi/sgHZdyqxPmvZYnVQ3q+pDJcqWf2lMd7BHVYv3/But7PxfLpG5n3MGl0/9/qpY
         rKqPXXgUBfM7iOvSACCe+t7poGLKfSEO0rlXkpbTWGEz3D6QrMCEymuws7y6H0j+3IhT
         3i911FjuRRJPJGNgsKYUo9HtrTK0aO7gWU4k6gvUxz4SL0RMFEsuTsy56eVr7dS+mSbe
         n0HIoLp28p1Y17wOXi5tm0S9Ht9FKISpboqKJ1G316ix3U8zWQuGqJNDCuXBNNaaOldN
         PPOMnYI0oRvnSlqjfGCMPShbpZJkdebt/XSNKqoMo8P+E2FdRxTUxDvdR3IeL2pvHCSL
         ObWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540413; x=1744145213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjN0v0W9m0IvqgYola2hOx5XLKml5O0udJOiHGE/eik=;
        b=MAqcL1gArAwUqNXXCcbd3jrPLodKR3NL61guRrCSruGhFu0xO3Hm8/CwqBD2hzDzcX
         aq2G8P+8l98OLxmm1VKWnKxlq3rnYOXWwuwJeDqkboY0RqKYhQNbZuKBHQFZyDbDzJWl
         0ARLzWBDxzqWA+WH7wHKwCG2X1tLpTwRJ5iAJ79q4LnuDNjVPkEgLWDhhiC7B0OxCj6j
         pZn8eYjM9bnkrVYcjR5gfnWchGDDh79cJhvY/9yw6h75/Ow94NLqqfEKnuCyPrb+nv53
         STXVSRM8xZsZFeIvR1wSjSTyAsz9tjTuTXL34f+eUHRaoyXNN/Ty5XL+FaJzUgu2YM1h
         T/Dg==
X-Forwarded-Encrypted: i=1; AJvYcCVTMZbOodtiZVSWPB3rQhtrCQxsR3IlCpAgNdbHwOU0nSPPVmd57iNv1V1JFfFX6NhT1E0dIFs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNzhyMfOOSdF7skarAbwOItp8GDIsI9qAKLeWpguqBnaLhCsUW
	KX48yWGVb3AzWxeb5l4Em/JWtY024arWIvRA5DgvpqnL/Y2zNa6/wO5TlX8of2SgF//Nsn7jIL7
	l1Q==
X-Google-Smtp-Source: AGHT+IHcYPdS+ntkX0QFkx6mSIlTj1AO51n1TbjklGmZnx1XnyN+enbKGYXER1TOaq4aVQk11+wCSyWBHf8=
X-Received: from pjbsw3.prod.google.com ([2002:a17:90b:2c83:b0:2f9:c349:2f84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dcc:b0:2fa:157e:c790
 with SMTP id 98e67ed59e1d1-3056ee181a6mr177513a91.5.1743540413076; Tue, 01
 Apr 2025 13:46:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:15 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-4-seanjc@google.com>
Subject: [PATCH 03/12] KVM: Initialize irqfd waitqueue callback when adding to
 the queue
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

Initialize the irqfd waitqueue callback immediately prior to inserting the
irqfd into the eventfd's waitqueue.  Pre-initializing the state in a
completely different context is all kinds of confusing, and incorrectly
suggests that the waitqueue function needs to be initialize prior to
vfs_poll().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index e47b7b6df94f..69bf2881635e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -256,6 +256,13 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
 	struct kvm_kernel_irqfd *irqfd = p->irqfd;
 
+	/*
+	 * Add the irqfd as a priority waiter on the eventfd, with a custom
+	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
+	 * underlying eventfd is signaled.
+	 */
+	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
+
 	add_wait_queue_priority(wqh, &irqfd->wait);
 }
 
@@ -395,12 +402,6 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		mutex_unlock(&kvm->irqfds.resampler_lock);
 	}
 
-	/*
-	 * Install our own custom wake-up handling so we are notified via
-	 * a callback whenever someone signals the underlying eventfd
-	 */
-	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
-
 	/*
 	 * Set the irqfd routing and add it to KVM's list before registering
 	 * the irqfd with the eventfd, so that the routing information is valid
-- 
2.49.0.504.g3bcea36a83-goog


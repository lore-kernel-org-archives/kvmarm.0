Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA9220FAB6
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 18:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680926; cv=none; b=j4CBXZt9rEk0Pxe28pfF25seEI1fu5h/G5Eq6TZgIb5mCXvNUvTnDcf/SI1mqb//C2iUE96mB2WOFozBqmeyHO54QhMM5kcsm2bonYeOChQJ1PYRvAix3eeAePb35nDZtloMenQwCJF16HSUhCmVqA4OCXBek8CWO/aLOIPbkfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680926; c=relaxed/simple;
	bh=0kgGSVpa4vF1VM/Tm68ip0ARKg16qtEPfsv+8/D7xvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uIgBuqCdx7vmZ+OcbDbskyY/yK5hzgK7YtgOumuolf1P7bL5mMXXjqlUvXjN3fKlyGti6SEaenQsU8sporPXTPnjUnmSRmsUZhOK0WptYJK7tOwKY2rZcFB7ZZKMTtPfOYxb+2lnQVsygM185DgtdUi/83Pck0H0eDcm3CnRE/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cG06mfSN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cG06mfSN"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so7235011a91.3
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 11:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680924; x=1748285724; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+VBvSn0/1OEly0dhJhpJ5/xbewUf32J5agAZ9eTZnMo=;
        b=cG06mfSNimZF38WCJUwrjbzu6Nd+0NjO3wKoaIiBAKmuoVVuY5zgeGkrNEc+HSCnWm
         ndTWaGYQzKcKOSYdOU2QXW2JHk9fTMzAWtrAJtxZOYtIW/LmSz/H3RTnh4AVzcfKJsMs
         KzZLpLQISJHbf8Qge6VPh+AOKyQYhPBLhjXFZMJsVVgeMqxVeJak7MnA7d+QivdwILOs
         LPeXJCiK8fJUd4F4BDdeKA66msnndSVQyiag89zvrbgwlZ8x9ferGrzZBr4wS9xaqxEi
         RdmEzPP4D7/CKlDlFO1uUbAWSCGihgZETt/UmokJH65Bwik0qbjWAiQC7m/TqFgfTCTp
         yZkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680924; x=1748285724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VBvSn0/1OEly0dhJhpJ5/xbewUf32J5agAZ9eTZnMo=;
        b=VNRkR+8r+CFyNpt+xbQ9gJxnuU5335FAq58Y/VsiRuaqaBpyCokWcBtWPouBqHYDaD
         bnmM/v5eYNsKv4s8/JQF5nK1D3mDVhCFGiFKJWafmNT1B2HOxqO4cLpkhWdVbcPlNPn+
         tQS2zqBQXaELVYImmb7AkElUNQ99H+KVBr4ZACpyAjytIRmMjmDRm9v4NbO9nMAD1wvT
         OMyOwAnAu+fXwiOMi3y/W0jobcWg2+rDhRNuL477/XxuC+Eb6IMR+lh6MZT0tUsrLYij
         6MBiamdWXPfdNp22L7g4dVg4txG9XoNfT+KSDS0plN9E4BiXKO8CNIQCb5SbPPnWTSUN
         UoNw==
X-Forwarded-Encrypted: i=1; AJvYcCU+Z7G8WPPQmksshtSoBVkKJibF1CMzb3SMKjqv54Hr78g8ouxWkd5MShqgKetqtHtXqBWlXN4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4jPeDIgggSppKlccs1gKdWRXQWhRUxC3i55qxN1gGg1PAIk+i
	dTnBrXLyCeS7Mse1T2zpCfQZfypf3YEOHw6hA11WVYKN2ZnUWyhtT20HSTTVfdabm3mI7V3ScMw
	j5is2nA==
X-Google-Smtp-Source: AGHT+IGXg/F9gxTP1pqaycZUwOUHp+ak6N7UkX/Xq88IlBNICngR1I/Ww9ctAKD/SX/RDw3McfSZyBJElK0=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c08:b0:30e:6a10:bb41
 with SMTP id 98e67ed59e1d1-30e7d5a85c1mr21315362a91.27.1747680923944; Mon, 19
 May 2025 11:55:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:05 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-4-seanjc@google.com>
Subject: [PATCH v2 03/12] KVM: Initialize irqfd waitqueue callback when adding
 to the queue
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
index 42c02c35e542..8b9a87daa2bb 100644
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
2.49.0.1101.gccaa498523-goog


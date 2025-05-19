Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCF321C9F2
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 18:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680936; cv=none; b=hKbeG3pQJzmSik/x6q+xiDlv0yDLGcYWimEpCNNv7Pl4EVu2oBR7TM95il8sHA5CRImliXMZjgX+s+nyEfqMQB522J7oIh+YjB4OqmmWb+JlyMJ8qNt8BxedvNbPQjLWz8hu/ZQpuqNgmFksf50xxdNGnv75g/lHq7KSxPKa0Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680936; c=relaxed/simple;
	bh=0X1petZgCpulFuo/nX3sHHh4xfNSuUzsnQprwr9yRsM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lNvH5nw3GTbkJrhWu+EWDcsgs/REAO2pQq1Ow+gUD564NtPzdOI07DmmJWjHgEupec8e89F+nXCyKfMryKNK8LYnBlBN62lxbP38QRAMHMR/wiIRjmxwkOJ6jdrdKKXkaLndUQPqySp6O5vxIoQHWpgJabx4GnUAfwC0DKWO5o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UHacuwu4; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UHacuwu4"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26f30486f0so3893864a12.2
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 11:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680935; x=1748285735; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ABmmeW4kIHS5pR1wBXW3o3AUaaWLHITX4FAWMNC72BE=;
        b=UHacuwu4Vy6NCUvnUWNVPsqpSTPxOIEe3oO82U56b0C79Ilm5kVH+BQ5jJgKE4YcZQ
         4Vc2MB4U/p11f+A5lQila7E2AD0e8O3NGEriHeRnMJA4E9yyN1b118d7n1dDkD4Sgqle
         Vyq3cjtvUSBfvzkKo71/mObXdxj5UirmRglmvoLSOHNnY4vVTvDg3ptVhJSlqM+Nm5cP
         eGZcJwPA1Xiup4ILTQatzrNd2jMg40G4akHtcW1iUvg2hefT4HDc0XfBt+xVE812VCj5
         jrEFgt3qIZQZtHkO2Crd6uzabMccch+9QEc8/QkOGAAHR/mBAHEuNIk8rMBdx/w4w7YE
         /bew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680935; x=1748285735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABmmeW4kIHS5pR1wBXW3o3AUaaWLHITX4FAWMNC72BE=;
        b=qcclB6NnvyXU2Ppj8bVuj0qZ+lIuOWSKFD28PbJOT+G67iQWKwpTbbgaiu5Zsl/jBz
         yfke+HgBmyek30Zw/ORBRd42uuukr2ruWRdKGE1xFNTr4NehEreNCrjyANFsyutQpFRF
         KpRM5hzrcj/kIAVbwO7bSG1DcpEKaBHimdXX+bIgX1B20w4Vz+u8zO/g25zWMguPZGMP
         CFzSfaN6IVocrc3N4f+lcA7ujPZ2iKd3Mu4kv/pn7VSbZ/C1sWstIKUCiaIPNirt+8Xm
         +TvLTaYh5CdgjYc+rue9i4heqVec8RXC+DDAV9WWkxsG2/6MXVtSpcqlQX3eGFzCYZG9
         hNOg==
X-Forwarded-Encrypted: i=1; AJvYcCVeyeJICmjio+qv9zDZcwN/OAh4ND6q9SJ3dT1/l1AKJS07SeO1gD2SH9D/wNh/mNi1zksq324=@lists.linux.dev
X-Gm-Message-State: AOJu0YxST0M42GecWoxFRaGdYtwmJUh1o9INdv86RqKNxhWlu4M9Ef2N
	aMDbB0viBj6/MlUAKoM73NQVSSv6QERqkZo0BNVBnkvcK9tnStVMgiF3ZNlSUvrE1v3sYZYs0uh
	ejRzFRQ==
X-Google-Smtp-Source: AGHT+IGEDc8FYs1ZWMzAv83wv6CIh5ESvR5WonpbBxgCgbPhV7/dILR6EKy6bxcesw6aCw28e8kHIpmzU9Y=
X-Received: from pjbsn4.prod.google.com ([2002:a17:90b:2e84:b0:2fc:11a0:c549])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a50:b0:301:98fc:9b5a
 with SMTP id 98e67ed59e1d1-30e7d500953mr20784074a91.6.1747680934698; Mon, 19
 May 2025 11:55:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:11 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-10-seanjc@google.com>
Subject: [PATCH v2 09/12] KVM: Drop sanity check that per-VM list of irqfds is unique
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

Now that the eventfd's waitqueue ensures it has at most one priority
waiter, i.e. prevents KVM from binding multiple irqfds to one eventfd,
drop KVM's sanity check that eventfds are unique for a single VM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 7b2e1f858f6d..d5258fd16033 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -288,7 +288,6 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 {
 	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
 	struct kvm_kernel_irqfd *irqfd = p->irqfd;
-	struct kvm_kernel_irqfd *tmp;
 	struct kvm *kvm = p->kvm;
 
 	/*
@@ -328,16 +327,6 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	if (p->ret)
 		goto out;
 
-	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd != tmp->eventfd)
-			continue;
-
-		WARN_ON_ONCE(1);
-		/* This fd is used for another irq already. */
-		p->ret = -EBUSY;
-		goto out;
-	}
-
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
 
 out:
-- 
2.49.0.1101.gccaa498523-goog


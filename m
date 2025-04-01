Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0762144BB
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 20:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540413; cv=none; b=gPTZ1tTjCrPyy47xOqA8FYQM/wNj/Bv8tiVVq+3egcreHc6exmLFmSxx2H174Jr1mgpgQyt/9xf6aitBl1yW+PG4P3LRnWa6Z9LEQ3eBSmTl4QkM9bzz2kE+YRhAZyzMxtoYXMw6hn+BC5JuPoEfFHColjbR9dHy73rkjvybYF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540413; c=relaxed/simple;
	bh=NEcVsWkrtlEatK+Y5SErb33iB70xl7AybVaIH/Yq9FU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mq4UuTKbcHv2/LOtlTpJEyBZ6/Qnz+9IHL8ITas8d7AQFxxDD3V9jOPUonnEKzvobdsY/nVeBbc2EyMWe5FE81nWZVxwnEmyCa8VROJuVLN8I/h2sqKe1k6bVL+AiQDiSL2KNPx2qJbqP24MmAUWTnhdpti9Mcyk1BUab8NEXwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ttW70Rr+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ttW70Rr+"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2254e500a73so79998065ad.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 13:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540411; x=1744145211; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j8aM8OQNKmiMYC4fpWY1Tcz4TDYVMXdrg7MtQvLe+/k=;
        b=ttW70Rr+Kdz/qDxftpz7yj4TSd7MCtyd26h24UKprReBVFTjwsf0lXyMH5Z8p8+bNA
         xAbrI8+VZIusO24K4Mfj0wq2BbvKB54IoDdt1kEarRtuKCGQKws5N+RKr7iWU+8lMHsn
         k31X1ZhCJkGSF8nRtJHLpwvBM0z3ftXUyCiqIrh03Z7toOZeD48ja1l9Ty8HIM44zpTM
         IuQ6A6lH+L+8Mu9GHmqDwh9IDjsMwjvVfGFVD5HCcsNSHl0vjBWuRCIy4/9zH0Hc+kjN
         RSK3EbXus6Z8M8aYEbPlV6TVQktaYF2z2b5gfjjDPoiAiVcB+ATE1ODf2j7XbJc+6R5H
         hidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540411; x=1744145211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j8aM8OQNKmiMYC4fpWY1Tcz4TDYVMXdrg7MtQvLe+/k=;
        b=fobXvhLJT/qHw3astAGha/aU8pFA6IXP8iBtVHI4RI+6L0CVNkYQExSVGP+AXY4381
         LnMKsC15E0wW9Q4fGuYzk5/zQ1lq08zW2eTuU0MPSp22FEoBFCSS/aJwc94fE5CfRoGR
         Mu1VWQX88l7dMhFJK+O+5uzqwONjrHTiEkxavUSDHVgwFOysmWuVIHPbAvnZh2L84EWd
         BdLguUvjrh9s5/jhy23iAkSOEp3fwIl6/Dhhb8qe+A5Vj2WYBTnL+dclH2/9og93g9O5
         PISm+R3M04CpNwZLOhcFK4z+gO21XXwU5DGapobDb7RLohhn+3Rtxy7WHJTF9FYR7oqn
         wZMw==
X-Forwarded-Encrypted: i=1; AJvYcCUcqBFEOF70Wttbzw1WXsdxQW8AIixzHlHEupbe2aHMlES1Exp0hwsh6sIAawJMo5Wr0stenI4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxk0uFMV0Gg5XBG42LqlYjr1ZRPr+UB7sgay7R4TJinE9shNIdk
	YvnnSoryrbEsGSHiH3Q7QCHs+m4cic2WVBpQRIElmM9XNFQBnwX3a5f/ZwRVLrfb3OzPrRUsDYQ
	uoQ==
X-Google-Smtp-Source: AGHT+IHk4c/1IjO1MwiDzaYInvb39GIpeBXBReykLE1mG0z4QyNEUAZvNPkX1TcPikaWCjInx7JyJFujPu0=
X-Received: from pfbcw10.prod.google.com ([2002:a05:6a00:450a:b0:736:3a40:5df5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c411:b0:220:f7bb:842
 with SMTP id d9443c01a7336-2295c0ed243mr67188835ad.42.1743540411361; Tue, 01
 Apr 2025 13:46:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:14 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-3-seanjc@google.com>
Subject: [PATCH 02/12] KVM: Acquire SCRU lock outside of irqfds.lock during assignment
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

Acquire SRCU outside of irqfds.lock so that the locking is symmetrical,
and add a comment explaining why on earth KVM holds SRCU for so long.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 01c6eb4dceb8..e47b7b6df94f 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -401,6 +401,18 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
+	/*
+	 * Set the irqfd routing and add it to KVM's list before registering
+	 * the irqfd with the eventfd, so that the routing information is valid
+	 * and stays valid, e.g. if there are GSI routing changes, prior to
+	 * making the irqfd visible, i.e. before it might be signaled.
+	 *
+	 * Note, holding SRCU ensures a stable read of routing information, and
+	 * also prevents irqfd_shutdown() from freeing the irqfd before it's
+	 * fully initialized.
+	 */
+	idx = srcu_read_lock(&kvm->irq_srcu);
+
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	ret = 0;
@@ -409,11 +421,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 			continue;
 		/* This fd is used for another irq already. */
 		ret = -EBUSY;
-		spin_unlock_irq(&kvm->irqfds.lock);
-		goto fail;
+		goto fail_duplicate;
 	}
 
-	idx = srcu_read_lock(&kvm->irq_srcu);
 	irqfd_update(kvm, irqfd);
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
@@ -449,6 +459,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return 0;
 
+fail_duplicate:
+	spin_unlock_irq(&kvm->irqfds.lock);
+	srcu_read_unlock(&kvm->irq_srcu, idx);
 fail:
 	if (irqfd->resampler)
 		irqfd_resampler_shutdown(irqfd);
-- 
2.49.0.504.g3bcea36a83-goog


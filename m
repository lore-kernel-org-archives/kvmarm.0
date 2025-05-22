Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914492D29CE
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 23:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957973; cv=none; b=BWC5PLhOtEM8xq/UzZmcxQxIB7slOLwXaA65esWHlXQ8ZGxlvUDbCdyekmxEQeaxaNv4XcVLNGUYY6X+7rfKWakAi2hfeMemNrCELs5xX75XTrIw+G+WodJp+OIrdeukJPPNUsclqY89WBojapm/Z7GB5ahYp8iwEyXNPJChRb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957973; c=relaxed/simple;
	bh=P37+G4c2/Xetu+3X+HtrukOmywQ+BBmCzZW3DWLRSak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uPuKHxPaPvt6ai2Y3jN4RlP5gP9s8DnZCNVOlvUckzdxcD0QWSmhI0844cUzp/Y0+LJDz3TPFTyB/0duymndqKpFBmbhzGcTGU1ycAzX7TwrqvDu5du0v4t9V+T/s3eQGi4ltt61C8Vws9JHohK9jVlrvtHKBsvMK+dbLuKFvtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FhsXay1k; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FhsXay1k"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-310a0668968so2203655a91.0
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957971; x=1748562771; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pJUovYaxFJgcXRp1TDFKS/NrFefgEp1AkGzEV1OM9Zc=;
        b=FhsXay1kY7VjxgES6mKWPMQPb7cHKsAQO1RB+GWru3rB/OTIH6JO7mv8q11A/3l+jV
         z8OA3SENjK7gDWXfzwUP5XjVEANtw2lcpv9qyNr2lFIoenUO+GZiJha8mFW2nXtzA5Ai
         hQZubkbi6g193q5oSfRwWkYcCnYxAv/NckPCRnnTurWbeX9jmwTrZ7C/EAusUoWMkilK
         XW5NhTx9NszlPttNpm9qiz84/fo+Ernew9/iTCfH+/CQ+K318UBEXThOMMi8PazRMVqf
         l5u0DlpLicdeRgcVOH2jn5ziUCzkNpnmt0m463oA6hKGFCcN5eX++ekKHFc3Ka9Pch7l
         wzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957971; x=1748562771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pJUovYaxFJgcXRp1TDFKS/NrFefgEp1AkGzEV1OM9Zc=;
        b=OPdLi4Is+xphB19uxkmN7li7Y0XSyG2cz7Fc8yCtfeJMJh0GBAASlgP+XemVA4/KJY
         JcK1iT1un07nSYao4UN6h97R/k5LbPFdMNeqzUv+UhHgJUm4J0DdzEyLXqHSt5oHTDC1
         t9+vU6c54V63S+hp4Bgfq1mEiVyiLsG2EdALa5E9QHhQp+Mr16c9gjJXqU5B5ljxJXYO
         8ShSsEoyQ/7OB1hmjJ3synYTUsQqTdAAm/BQikeTs2LG+cQ9eOkbU8Vyp6o4fS5RNYgm
         XCSXecqAD3Dr/lkxe4Lyu8DzIaJozrKsL9YpLOgVEmOkvFUXX8Ec7t64F0d9jlj7T2Yr
         Wnuw==
X-Forwarded-Encrypted: i=1; AJvYcCV1MbnvCuNhxSoAElENepkgA75/bopBemI8NEp9Zn9JHwy8rcHLchwe215bfQJD1AiOrDW0bZQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZVMBQUziZpegfG42Q1iiKErfbRO6qBy2R9j6QrvsoRmPl/ebJ
	e0iGZmEGOM3iVrXtjBUSWhUTAsKFs2Uc/E59LQle76XqGCA5kW9gY/O196DVTxtVGQ0C+2oGpnn
	OoAiCwA==
X-Google-Smtp-Source: AGHT+IEDndqxTWcCtq5oGwy52YECfaW+Ize1PqvGwCK7FSF7/oiShVYNO6fCIsKX/sBpVCvd/V18cyz4IiY=
X-Received: from pjx8.prod.google.com ([2002:a17:90b:5688:b0:30a:31eb:ec8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33c2:b0:2ee:edae:780
 with SMTP id 98e67ed59e1d1-30e7d548c90mr43873310a91.15.1747957970976; Thu, 22
 May 2025 16:52:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:20 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-11-seanjc@google.com>
Subject: [PATCH v3 10/13] KVM: Drop sanity check that per-VM list of irqfds is unique
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
2.49.0.1151.ga128411c76-goog


Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D720C221566
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 20:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540425; cv=none; b=aSBZuGbDKpBPvx+MHhWTwLEgV5uZfeg6EoHCJLFchTZEW55LxrQSLy4nBMwfcNtt3ypk/LTh1VQ+6ZOxrSDEPM5zTIxfr9hilgkd/BqFBuxgx97Ru9cYmc2Cf01TghnhOcNBKVplMrh2jFlsfO4v+OqLPJsYppZAL6I8HDfoqTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540425; c=relaxed/simple;
	bh=p6FosNapp0YaaT9fRT5YA+80ZKTNpXl7IVghKZMWIQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QBooQS/ZbxLDTQMRHf1wyer7Ieuw8iQ8ApYxqQSxi1Zuc/DSZh0hwi3nUB+TEoSfPhkGjpOUVzwwAIsSHyKDG/vEyoU6Rjw6XmWPjKPOUKHBXxQaqvnHSmomPg1PyQS62cRX5n6JoxC4wJvoGgUp5sl8PEL06LIVTdBLf0kg7Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NaZpj8DZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NaZpj8DZ"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff854a2541so9883692a91.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 13:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540423; x=1744145223; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A5N7R+jpPDsp4box9tDn3nxVfOu1tizhXrLdonpwfcQ=;
        b=NaZpj8DZjwYJ/0u8125j5R2nXsy7FZ9dc93Gjd1yLs5kMmWekHM/j+Nf2RpjrMxTJB
         Q3kaNwCjd1+GFS9EBgBHtgstw38imRvSqZys6qZkcU5iamQ6chTtkH2ytxdBuR9QTnBp
         VnZl5c//Noa+Z22YTsAJavSepv3VAIBnNRdiBKKryInSJ2pTJ8VMq0luAzoAhQrVK5Fy
         GShbalOzYsmhhCzRVrW/4KpKQIkV2iTEp0KpEMIwaJtQohV6uu3ciFs5437K8ch2BesW
         7EmHr1jXvGTbCIHDGjoMg2LmrWpywgssIyoy3WYiUEg0BUVKjHwsPrKP3VgJVV8lcSWj
         op+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540423; x=1744145223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A5N7R+jpPDsp4box9tDn3nxVfOu1tizhXrLdonpwfcQ=;
        b=Kll2emY0Ed0Cb5WxIu8KXbWNTy1vIZGSLnNbjTm5K8ZYocmaWzb5XzUNmigWHy73iu
         wrr6qBzAfm968NSvmauJIgt+yE2R5z/Fxk8AHlGIAZHmIDRl9R9F5yOCaTlWL3gUcbcc
         9q7GxbLylmtngYercFW9FM5/9l3kCykYp1BO5Z7NsXrzSb/I9BzhcQsspP+F+o/YTSAF
         PQx888d3eBPk4Ffpw1pdIg97H8uwOdI7nxz3TDPdax83DngiKh/vg2EyiEhMYrVo/mKQ
         mbMMhcQqWgoALjqKlU3/Z2MyVH8yHls/JrDiCglZmBMS+JFkE9tkbRi4b+RmIvUM1CSo
         mY1w==
X-Forwarded-Encrypted: i=1; AJvYcCWRblV0GbX841xdFvsSFRW/waV3uKTDr4ecH1nNCKutY2Xj4y25dpJ5CvrSC7l2tB5kjl/FvBs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yys7LYFXSya6EoXYTWCbLBEoebZIGqcWGGtn/qEn09ClbSktdg/
	Oen5ZG+BFXQIJ9ZHENp04a5MBg2mNKRowSqK7Er+6alYLTSkcAHJ+d3OBMQOKLgMfpgz2DvBK5T
	bmw==
X-Google-Smtp-Source: AGHT+IFKHrxOrTZORfx3j1Hq3t+F6SZMnVAetLumeoCsiYBPEvhoueJg73+pHzxlFtD9cACElqMRzKov8iQ=
X-Received: from pjbsg16.prod.google.com ([2002:a17:90b:5210:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a4b:b0:2f5:747:cbd
 with SMTP id 98e67ed59e1d1-305320af2bfmr23155973a91.18.1743540423264; Tue, 01
 Apr 2025 13:47:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:21 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-10-seanjc@google.com>
Subject: [PATCH 09/12] KVM: Drop sanity check that per-VM list of irqfds is unique
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

Now that the eventfd's waitqueue ensures it has at most one priority
waiter, i.e. prevents KVM from binding multiple irqfds to one eventfd,
drop KVM's sanity check that eventfds are unique for a single VM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 25c360ed2e1e..d21b956e7daa 100644
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
2.49.0.504.g3bcea36a83-goog


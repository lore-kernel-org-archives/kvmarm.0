Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D155421CC5D
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 20:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540420; cv=none; b=h50cTxcfsGvMCJdeF1mo9BAOpRX0KNaipOXXXaWdDWoI3p0syew5FufyDrfYm+FseKPQZasYd55RleOqxsSnxb3FzNozwnzQrHWPy92Lll8OpOj062suimDUjJy00+baUZGYkV3WS0goMLq4neGQzVjN9g4abqig1Kip1+OFML0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540420; c=relaxed/simple;
	bh=9Y4jQuNr81blf0kL+x4SZ577lsTpKSVZZgUjgP8+H94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E1IILmiQxPhyWep/icPUkMch8kESeMW0CG9YBRybMkpdpxW8RY93RsfNadJxN0okyFIt6uH/weXord9wK6sswTwlottt0DEeztvPAemFWoCkwKHdhAdUVSbS3Ypi391FOWPE7zY/haRqwLfwjp9zSGX6p4HBaBFY2udtUvqQp1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jfUTHi+0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jfUTHi+0"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3032f4eca83so10215693a91.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 13:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540418; x=1744145218; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XAZ6HcZyPVHZNs/NiQeU2YPtsx7wIdUpIqdNXxdK3gA=;
        b=jfUTHi+0dspbAE8MXWluavTPYcWQqP6tXa2WMV9Q3XJP6HGV2+Z45Y/6tucMJpAXb+
         v+Z4yKtf1zvepXYdOgdURHtlBSBOUPdxYp8uAd5QlJRAy27Ppcbzd+aBgc8le7RmLt2D
         zvglDYanDtERtE/dO00+X40EsBmb2HNga2GBHB6853uj8XX/EI6tESi3Uo82paEpLbyn
         WgRYw7KG3GST9zp42QdEbyfxn+PfTML8fVgDf/iQ8+ze5E8kd6uNQZinAmBuiqDDZDVG
         XPczFZlf5qvj0dkadhNkAgK26iFwUkmW124W+PKSsUNonYQAE3sTnJr5zALanbeGWkvH
         z9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540418; x=1744145218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XAZ6HcZyPVHZNs/NiQeU2YPtsx7wIdUpIqdNXxdK3gA=;
        b=DVXAlVlDSvJ9/2hEFLYRCHQ8E1hd4JAU9EexhhKjT7NzaqQiHIv7NMKyE5tv7I4H9S
         TicdJMoZl5fVekvH4NJyAP2MBcTEAl41vz5mnOeJ5ha8R5owir0MpP/DrGR2lPT7v3oj
         PYcIYJQJ2M1LRhh8DVHT5dDnvwAJB+e/XIH6GPLLZVpUqlZvb0d/yKr5sAhjZRxK5Vd6
         8HmRWTk2E2D6fzvT9a3bAnSD4sndq8/y7AoYXTJ5ZK9UKZfEbL3D8kBsBgJgzUGB6ZO8
         m7Fa1zJAdWKP3lD0Rryl6S9jXTudPwBmQDOaXUt++UHThh2qVJyaiYstKNTY+KdOdbyG
         AQNA==
X-Forwarded-Encrypted: i=1; AJvYcCWBmKqshZWAU/bZDR8V+d+mHkYvItwsFrxT2WUIau86NwjwgUWP9ekBOFUVUGqByAYmn5dVv0M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzzYRFzA+8683yGZRPZ9hKCAfCVxUUJHAzBIbKsp31s1HZ7suAE
	xfFjmmEMfzJd7eBvIuwvDChqgOQfCXzJr4wA75hg1BNDEQxr8dRepi3+9LT8jjhEdXNbA91TeP3
	gig==
X-Google-Smtp-Source: AGHT+IFdQSCduwNTHLV/nec9/i/BvW+thtXD97niBCIJ/k+4mEqw+xFFVLw5YdqLnoDpAq+BRV3lhigqiIM=
X-Received: from pjk16.prod.google.com ([2002:a17:90b:5590:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:574b:b0:2ee:9b09:7d3d
 with SMTP id 98e67ed59e1d1-305320af3e0mr18907665a91.19.1743540418245; Tue, 01
 Apr 2025 13:46:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:18 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-7-seanjc@google.com>
Subject: [PATCH 06/12] sched/wait: Add a waitqueue helper for fully exclusive
 priority waiters
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

Add a waitqueue helper to add a priority waiter that requires exclusive
wakeups, i.e. that requires that it be the _only_ priority waiter.  The
API will be used by KVM to ensure that at most one of KVM's irqfds is
bound to a single eventfd (across the entire kernel).

Open code the helper instead of using __add_wait_queue() so that the
common path doesn't need to "handle" impossible failures.

Note, the priority_exclusive() name is obviously confusing as the plain
priority() API also sets WQ_FLAG_EXCLUSIVE.  This will be remedied once
KVM switches to add_wait_queue_priority_exclusive(), as the only other
user of add_wait_queue_priority(), Xen's privcmd, doesn't actually operate
in exclusive mode (more than likely, the detail was overlooked when privcmd
copy-pasted (sorry, "was inspired by") KVM's implementation).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/wait.h |  2 ++
 kernel/sched/wait.c  | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6d90ad974408..5fe082c9e52b 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -164,6 +164,8 @@ static inline bool wq_has_sleeper(struct wait_queue_head *wq_head)
 extern void add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 extern void add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 extern void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
+extern int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
+					     struct wait_queue_entry *wq_entry);
 extern void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 
 static inline void __add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 51e38f5f4701..80d90d1dc24d 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -47,6 +47,26 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
 }
 EXPORT_SYMBOL_GPL(add_wait_queue_priority);
 
+int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
+				      struct wait_queue_entry *wq_entry)
+{
+	struct list_head *head = &wq_head->head;
+	unsigned long flags;
+	int r = 0;
+
+	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
+	spin_lock_irqsave(&wq_head->lock, flags);
+	if (!list_empty(head) &&
+	    (list_first_entry(head, typeof(*wq_entry), entry)->flags & WQ_FLAG_PRIORITY))
+		r = -EBUSY;
+	else
+		list_add(&wq_entry->entry, head);
+	spin_unlock_irqrestore(&wq_head->lock, flags);
+
+	return r;
+}
+EXPORT_SYMBOL(add_wait_queue_priority_exclusive);
+
 void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
 {
 	unsigned long flags;
-- 
2.49.0.504.g3bcea36a83-goog


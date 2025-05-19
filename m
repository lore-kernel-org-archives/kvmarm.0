Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3D3218EBE
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680932; cv=none; b=oTFeuNTMVI8z4T3ORdUfIXkNN5qytDQ7x295+hn7jP/fTsLatQriKhN1d8PCXtswr/gU2EP/j/14PS8ynuvKwjIiczi1wJhMthNhdxpUXqfkJY+HDx756/USrhvnMwOacrBfhwRUOGN4Aata4bCqnyfRYMpsUdgLprwS5OeYL1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680932; c=relaxed/simple;
	bh=Wnq3AEkwwCRKZdw0URszudHGV3cHf51uRQG8VfDhld0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G9BaA0Wp944xf6YvfkEmS8W3g1noMI1xp31WmoAdLyUVlGVIAjt/dcYbrAgoa9Ut5PbmGBhDwjBCmiv9fcAc5uKY8RYgvPeP9JM/UH2eYa1N7EO7MTfoqYmrhxWkv/PbDkfjGEAw5ngXmWcyUCk6wEOMUvvvueTm+WYyGnI2xTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ib2pnTT5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ib2pnTT5"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30eac9886ffso1734574a91.1
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 11:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680929; x=1748285729; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WPHkK6AJb2aIuP4Pg4NSQD55GV+jm/GYycppUOoBB24=;
        b=Ib2pnTT5mJ7c/gIDuRs4SGJD9TF33sjal/v9hi6hla0xIRSQuBqAiTNnARZccpTrCN
         Lz0CNz+rmtsn/qwaYjO7j6vlzvXwS6dSJX4YesGwmpNe74TGPvolfjKP9i88+qjgzjZs
         3sQ4aszz7AAyWWxmZx8wzEuW8kqjvY+VVHgCT34b4hDm4+kkFZkLemioK42A1RuRaNV+
         cB2RBUe6YLhy/2CYoJxmmknD8XdlpHOuFfTEr0Crv/PXa/+JHzMlbtyAEiYeGy0d31xV
         vnjIjpAc3eq8nDDIMymj1KyOtVrU4Sc8FRBxkb6i1ojie0EsA0NF6hnCn7xv6ROx9tWP
         otjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680929; x=1748285729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPHkK6AJb2aIuP4Pg4NSQD55GV+jm/GYycppUOoBB24=;
        b=pZuIOH4zMCMvlSvmOsz+vtfCF7nxXELVHtwnN/0d7QuhxTpiy6XG9zL3dPv2t27wm0
         qaIbupCEp3crCY1c1JlEgD4SAc12NyJey7spnhmHtKMkCEoSChw7h5z0ZDx+8o9Np6tI
         hWTFDXlRWEjUDUMTrdRK6/M7s9g+ZtortBoiRckgo6Ad5EvmwDcVc8O6OAjuFDB0JJa8
         U4Q0UT19lvVQJKNOm8IIwy6MwsAj3dxTupnUkpgsHQZWU20LQWU71jLX1R9th0Gt8SaW
         nZUkwAxpeu+oT3RqxErBDwfuYR1K6syXZT6bdIQd3IQd87ry0SkUz32kInp+fFGNfG6n
         5LKA==
X-Forwarded-Encrypted: i=1; AJvYcCXi/kaeJqkhIgfExwu1/gDhhFMC7duWLNgXfmUN4w+jr8DDLzYo98Iv2/AgCwjwLm3n7131/x4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxiaUrjHXzZPWLEirF8VacXGNlAvUGA+CTuwQu26HRmmI2gJM/t
	E6zMJ4YZAsXjkWJKEr1qcCR3Iyr8UD8HDZIZTCoiKMOgMqYNj7Knd4JsNo6nAr2e3amuUxNxBBY
	jWRYc8w==
X-Google-Smtp-Source: AGHT+IHK1Zr4h0D2c9hfvihT1HBAYjdqDVsYafOfJ/1g69C6YEZd33VFtqEq4B23tLL0mdweYF147yQWVb0=
X-Received: from pjbpv10.prod.google.com ([2002:a17:90b:3c8a:b0:30e:5bd5:880d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d445:b0:30e:a1ec:68dd
 with SMTP id 98e67ed59e1d1-30ea1ec68e8mr16388245a91.8.1747680929524; Mon, 19
 May 2025 11:55:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:08 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-7-seanjc@google.com>
Subject: [PATCH v2 06/12] sched/wait: Add a waitqueue helper for fully
 exclusive priority waiters
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

Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/wait.h |  2 ++
 kernel/sched/wait.c  | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 965a19809c7e..09855d819418 100644
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
index 51e38f5f4701..03252badb8e8 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -47,6 +47,24 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
 }
 EXPORT_SYMBOL_GPL(add_wait_queue_priority);
 
+int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
+				      struct wait_queue_entry *wq_entry)
+{
+	struct list_head *head = &wq_head->head;
+
+	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
+
+	guard(spinlock_irqsave)(&wq_head->lock);
+
+	if (!list_empty(head) &&
+	    (list_first_entry(head, typeof(*wq_entry), entry)->flags & WQ_FLAG_PRIORITY))
+		return -EBUSY;
+
+	list_add(&wq_entry->entry, head);
+	return 0;
+}
+EXPORT_SYMBOL(add_wait_queue_priority_exclusive);
+
 void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
 {
 	unsigned long flags;
-- 
2.49.0.1101.gccaa498523-goog


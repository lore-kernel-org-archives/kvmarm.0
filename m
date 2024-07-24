Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10311AACB
	for <kvmarm@lists.linux.dev>; Wed, 24 Jul 2024 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783481; cv=none; b=BRfs7qDxlwtcaZaTizolsMaSRK5JMEMthnCoL8r0Zobpdhu73ABMNWu9rmH8YNc/FEMNWb+254IUMy9vLhjZX7BJdHskZKrMDHWWPxo0zm/Nxy6042FRWv2yki1eYSAdrtR7LBjZGAF4YbRJvSJnXoL/3TrrGQ8BOe3dcF1Bebo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783481; c=relaxed/simple;
	bh=m1fa3ZDpVnv4zEi0VZF20BrwMEl3RMOGRGSa81uq+1c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EF2YKEu9jSHs8HkeJ6Eg82CHM764741dppdkS/n9q6ZiX4efODLaR1/iRygDeUMviaB5TTWRGA1KzhayUFwwZ86GOXseSpBYR7ah27gmfgP/VuUXY8CAP4/1k0jaBjyWVdePs967EFsyLcq6U7nwTSvVFQ1ZXsQOOxQ6XKIaMRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K2safc1a; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K2safc1a"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e08bc29c584so2142307276.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 18:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721783479; x=1722388279; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RjwIFwaGyFm0pqYoSJRPlexY59ZZdKZ6ixfPL8P7AvM=;
        b=K2safc1ahs5pgwYj2NN/KcbOxdIvmXfz0Or+OgYJn6jbh/hT2jv7gNecNmxd42m/U5
         1zi6jJbroymjMX2yddychKVf0DKV+hBfG1Y7gmXrXqtABy6pyHHYgndTyLjAj+JRxTEU
         1p+0eJh5rXOqMdQOJ+hXNz+0dKbtMZogiBvsH61jVCYeajvCEIGI16kBFSqgoR04GOa6
         umzk7WfY/DxapUaSsUMacPWwGU5zCvqjcoG0FwPT6Aj50h865cM/03ve+rd/47JkThd5
         wo/4AXN9hoPbZwRj53XpMaBI1yvfPvMUhA04GqlfsWgxYoGHPJrXZHNUqIO1O3qVz9D4
         AOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721783479; x=1722388279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RjwIFwaGyFm0pqYoSJRPlexY59ZZdKZ6ixfPL8P7AvM=;
        b=Pan/cMcEHlNgRAtSh30ilPIgTXiULChOUZouCTFFRqC7e9JI7qLrW7Dd/7WjTKUnQp
         2nSEVasDgtNDBBP8RjN5JzlQFi516kpVzCDHXRRFX6jqHH83qhbh/I++YuQ/OnS2A5P4
         NS96zKnS1EiRYCxT42+XijXmPmqL0Ofz4/8q2a6+H+3clSHeltQlzzqM/kAhjBcVuG3g
         Z1Hm0UbjmAT6q892DCgHmH1NoIiPnXNNd60VGx8josfI7tUYLQ4qbbNQaVVSNuUmniIR
         aqHoFh3/+DjFsF96M1dY43IZeL6WxTqVH2s68ag+K3Qku8P5YFhvJEKIH35bYhwfxNo4
         HbFw==
X-Forwarded-Encrypted: i=1; AJvYcCWyfPnRdN6YVeZzquqz3JbuwwJDjAaiVN/6EZFDVeaEXZPQT7+GSMrzfA8PYnjqIrI+1p/sJLhNWmnJKdAgPRA9O5IBWG6O
X-Gm-Message-State: AOJu0Yxp/cUVFQk3cuFvtuKZf+1D9fx80DG/4ITLFTINCDHrYXcQsHns
	Jh//+y6FhRlgYahHo5u4u010OBqNKI3Y2qGj3tXDIRunKIM9Xcg/W4GVA8BwtB44OKi98j3mePg
	OXN5XKSeFXxTDavtFZg==
X-Google-Smtp-Source: AGHT+IEf8LhPu+J2AQj8JKbpYxC+Q+/7UmZG6e+vLGbTXrpNe4bcC8God4ZSRUYFG8d6cpp91FbqTUc9FhMyYUjh
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:20ca:b0:e08:5554:b2be with
 SMTP id 3f1490d57ef6-e0b0e60b370mr1189276.9.1721783478588; Tue, 23 Jul 2024
 18:11:18 -0700 (PDT)
Date: Wed, 24 Jul 2024 01:10:31 +0000
In-Reply-To: <20240724011037.3671523-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240724011037.3671523-7-jthoughton@google.com>
Subject: [PATCH v6 06/11] mm: Add has_fast_aging to struct mmu_notifier
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

has_fast_aging should be set by subscribers that non-trivially implement
fast_only versions of both test_young() and clear_young().

Fast aging must be opt-in. For a subscriber that has not been
enlightened with "fast aging", the test/clear_young() will behave
identically whether or not fast_only is given.

Given that KVM is the only test/clear_young() implementer, we could
instead add an equivalent check in KVM, but doing so would incur an
indirect function call every time, even if the notifier ends up being a
no-op.

Add mm_has_fast_young_notifiers() in case a caller wants to know if it
should skip many calls to the mmu notifiers that may not be necessary
(like MGLRU look-around).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/mmu_notifier.h | 14 ++++++++++++++
 mm/mmu_notifier.c            | 26 ++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 45c5995ebd84..e23fc10f864b 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -233,6 +233,7 @@ struct mmu_notifier {
 	struct mm_struct *mm;
 	struct rcu_head rcu;
 	unsigned int users;
+	bool has_fast_aging;
 };
 
 /**
@@ -387,6 +388,7 @@ extern int __mmu_notifier_clear_young(struct mm_struct *mm,
 extern int __mmu_notifier_test_young(struct mm_struct *mm,
 				     unsigned long address,
 				     bool fast_only);
+extern bool __mm_has_fast_young_notifiers(struct mm_struct *mm);
 extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
 extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r);
 extern void __mmu_notifier_arch_invalidate_secondary_tlbs(struct mm_struct *mm,
@@ -449,6 +451,13 @@ static inline int mmu_notifier_test_young_fast_only(struct mm_struct *mm,
 	return 0;
 }
 
+static inline bool mm_has_fast_young_notifiers(struct mm_struct *mm)
+{
+	if (mm_has_notifiers(mm))
+		return __mm_has_fast_young_notifiers(mm);
+	return 0;
+}
+
 static inline void
 mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
@@ -653,6 +662,11 @@ static inline int mmu_notifier_test_young_fast_only(struct mm_struct *mm,
 	return 0;
 }
 
+static inline bool mm_has_fast_young_notifiers(struct mm_struct *mm)
+{
+	return 0;
+}
+
 static inline void
 mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index f9a0ca6ffe65..f9ec810c8a1b 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -382,6 +382,26 @@ int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 	return young;
 }
 
+bool __mm_has_fast_young_notifiers(struct mm_struct *mm)
+{
+	struct mmu_notifier *subscription;
+	bool has_fast_aging = false;
+	int id;
+
+	id = srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(subscription,
+				 &mm->notifier_subscriptions->list, hlist,
+				 srcu_read_lock_held(&srcu)) {
+		if (subscription->has_fast_aging) {
+			has_fast_aging = true;
+			break;
+		}
+	}
+	srcu_read_unlock(&srcu, id);
+
+	return has_fast_aging;
+}
+
 int __mmu_notifier_clear_young(struct mm_struct *mm,
 			       unsigned long start,
 			       unsigned long end,
@@ -394,6 +414,9 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
 	hlist_for_each_entry_rcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
+		if (fast_only && !subscription->has_fast_aging)
+			continue;
+
 		if (subscription->ops->clear_young)
 			young |= subscription->ops->clear_young(subscription,
 								mm, start, end,
@@ -415,6 +438,9 @@ int __mmu_notifier_test_young(struct mm_struct *mm,
 	hlist_for_each_entry_rcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
+		if (fast_only && !subscription->has_fast_aging)
+			continue;
+
 		if (subscription->ops->test_young) {
 			young = subscription->ops->test_young(subscription, mm,
 							      address,
-- 
2.46.0.rc1.232.g9752f9e123-goog


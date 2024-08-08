Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A229E1917D3
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723138996; cv=none; b=eYIDLg6xzexDlzL1GeckyEh6J5SwFH8UFuW6hZtoubm8KjtqeuCBMvFxHqj+tAgMMQGj0i7GT8GbN6hQDzdqFhaWEYeovF9mn+ZRKaBXVFUnpMwXbxmu4GQJj6nZlO43T3it2a7fYhiGbETpX7V8kmIm54w6hEk9F+g//6XY/FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723138996; c=relaxed/simple;
	bh=86H8Hq/QrVp+2XHWtnQLOHjNx6b6/aA0SVYTRipkXQo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YfKrMTxfC8aoVkh2imlNS/f/fUMm9iVFOyhS3znmLau3r8yfN7I7Jno8vOIRCBgAA+RYuxU/SqwaTj5KYatytiUhOijz6ufr8fXQiAUIRuN/knceDhSL9jj+I6mG8vSmFHNVk+IpMif8TB+r+qWLLbtvJp/oIwF1kGLbxJpl1ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1rWHMoWT; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1rWHMoWT"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-68f95e37bbfso28637967b3.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Aug 2024 10:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723138994; x=1723743794; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4+1jkb/kSvflaKrQy8nLqEfji7x/G0gMXefyaO4Ttzs=;
        b=1rWHMoWTMK8iChi3iGJzPxUpMWqYS9kEr7d++skz/HPr0LJQPt2f1rR69+NQoCin7+
         IyYBnJIBKiw2HdJX045bmEYDfjRyahmUDXl69bi1gsBwU/LPgA1kuc2oM017+/XX4WaP
         9T4TIbYWGhHjlEUkwN149gOOYbNLILY0rsmJkWpxDqLCLsVrQN50Nlc8r3UdPqcyvx/4
         DhbWFepfT6yLe0rYHJ9xUhriXP323TBk7nYiROrjvQfF4c3L8qJgljGA+EH89i5oe0Zv
         5RoPlPoS4PRk5b+CKRRw0c8nHlUTPouZCa2JaYjhK8EhNFKAVmdqdiaprLoHC3uBiNE0
         I6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723138994; x=1723743794;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4+1jkb/kSvflaKrQy8nLqEfji7x/G0gMXefyaO4Ttzs=;
        b=ZRJbfHIarzZnvjGD41L5XMucJ/7XVUw5oSj2Vyq57ebARfWFwKY2jzN+J5ufx4Bp0E
         ClhmWXWYN9IwBdkFrMoN5clrder2xQpDRbAN8DGvUab+R+xmGBUIii0YoSkE2oezzSF4
         wBh3ETgBx3SIsuD4iJH9FTTAd9BZjgjc9w0ilHiA3fckh7Mk5rIZPIO0vb6KX+xZcRe8
         otiDaME8k22GvMXBySfn71pjdBEVu7jREv4pFVNUWt7vRq/g8mT/djvlRCEnDiUsNBDa
         ttEl8eey/SDOBCJ8dlkEt0AmAyy8R5LqJutnELnBxDwNB2KZ75B4BFwYDFIrG89xHQeT
         Il+w==
X-Forwarded-Encrypted: i=1; AJvYcCX2ZcZ63WD0y3o15zqZO1ZD66AUoeP0EBeyekLpQErdQFTzrxdXuY3ODXdqZ1amJe45lS6iIMGXBMtjSUt86gl9tj0iWkEF
X-Gm-Message-State: AOJu0YzbIanIBKgJjVvR0P63TlaD2WnXqumGw4IFgC+izJxADsyRn8Lm
	9SDDEv6g8q1yDBlQl93EzPPIG/yMpzII+KwsX35VEt+vFOiRZNo/SwoAuymveIqTruxO5+DFY2k
	ysdd7xLp//DUcUwLlkrsTKg==
X-Google-Smtp-Source: AGHT+IFI0rnzef7ISFTxPTkBDSrqwcN8rzvq+R6/y07Cu867kKIpT/4oVZnVFq4JrZ5GCRkcJ1KbtYBJHpkWdkmDpA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:961:b0:62f:1f63:ae4f with
 SMTP id 00721157ae682-69bf6f7ec1fmr200267b3.1.1723138993566; Thu, 08 Aug 2024
 10:43:13 -0700 (PDT)
Date: Thu,  8 Aug 2024 17:42:43 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240808174243.2836363-1-coltonlewis@google.com>
Subject: [PATCH v2] KVM: arm64: Move data barrier to end of split walk
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This DSB guarantees page table updates have been made visible to the
hardware table walker. Moving the DSB from stage2_split_walker() to
after the walk is finished in kvm_pgtable_stage2_split() results in a
roughly 70% reduction in Clear Dirty Log Time in
dirty_log_perf_test (modified to use eager page splitting) when using
huge pages. This gain holds steady through a range of vcpus
used (tested 1-64) and memory used (tested 1-64GB).

This is safe to do because nothing else is using the page tables while
they are still being mapped and this is how other page table walkers
already function. None of them have a data barrier in the walker
itself because relative ordering of table PTEs to table contents comes
from the release semantics of stage2_make_pte().

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

v2:
  * Added more information about purpose of DSB to commit message
  * Rebased to v6.11-rc2

v1:
https://lore.kernel.org/kvmarm/20240718223519.1673835-1-coltonlewis@google.com/

 arch/arm64/kvm/hyp/pgtable.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9e2bbee77491..9788af2ca8c0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1547,7 +1547,6 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
 	stage2_make_pte(ctx, new);
-	dsb(ishst);
 	return 0;
 }

@@ -1559,8 +1558,11 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 		.arg	= mc,
 	};
+	int ret;

-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	dsb(ishst);
+	return ret;
 }

 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
--
2.46.0.76.ge559c4bf1a-goog

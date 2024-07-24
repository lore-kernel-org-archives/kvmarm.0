Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57FDF4FB
	for <kvmarm@lists.linux.dev>; Wed, 24 Jul 2024 01:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783479; cv=none; b=KIbbmdOixGW9pJzy2CfBRJ0OGB9cDf6fr8kdgDV/TNltr9LEm1p+MVik1umnLTVM2tVp63snPhTEjX1OzV1oCI1Ce0SV2HKEHvyFpe8o7QpY/rpyYvHzFOfV6CbwXrj1vPNdt5mY2ojPeXZDTcuffXcqYMXI4cyRz4mHRPdeYBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783479; c=relaxed/simple;
	bh=9epNWMu0nT72OSlYY2Zz+fVtDIgBskl4k6najJMpllA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T0P3RB53GWfrrgDZc1pR/1xePjRU9ocjj684LYh2YM6WDE/mb96G3sxw9mEqpVAff8jR1TIGTWaUa3eTjWheBjCvW6JsxI2yNDaDaFclopGWkawaQSuhG5HHDvgja2fLzhil0esY7oH89w/GyeIl6rKC18UIzg4wacMFuMg0Vso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2GETebpY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2GETebpY"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e05eae12defso732499276.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 18:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721783477; x=1722388277; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yD4XBA3wulmfL9cZplrhNjvZpnpcy308OK8qykR4vJ4=;
        b=2GETebpYEfQ3hINbGVvAdtSpXqc/2slwdx3NVFTuOV+dPDc0ZzJTXzHqqpci3Y8GBl
         h9sU/eDSABiPVgwBHQj5Nl8QbZT9M46JVrcuY72q4LjC2A4R1PYAmGc8HZ7S6OSYn6bk
         hKiLGY2f/7hkToM4YJrvvlRc2rAOSMf6uAJBTEKIu90nQeeqEusorBhwx++9b83HrNT5
         3S3MPS5048QorM8pBxHRWcTtUzU9cKJd1EB8zpwntzPkpjZkXg8+U0FRv/j2LNtTeA9Z
         W1CObfxn9IDjQu3as9mDM/VGP7Ivz0BXRVr8aKs+Ey0ooNZDxQDLN7Q78ACZik64oJvR
         +zqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721783477; x=1722388277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yD4XBA3wulmfL9cZplrhNjvZpnpcy308OK8qykR4vJ4=;
        b=ac1U/EWWDp8ifW2+HQrJmQagXafZBdwzGVfPX5DMGIl9dM0khhGEe+pK3iN1LAGLCr
         vCqEuXmhkMjIS035NilHxJhyyuGmK5w5Q09sjruUeku2KP+M8jQlcz7ouSgU7aYw9GBF
         Qhi7IDFKKqCMU3zA0WR6EacX4z786kd2NFdpW+sLLqXeJ8bqB+QOdG1AWueSrFuV/iEo
         TnIA+d2WYAbZUtMbC/7qlvpn6n1r0hQLpCAUv8XlcrlxRAi7dauoNNQ14C7GFff95ujI
         prU2sx2f2AdThJYCBuvGycaQzb23fan+bwVoRJoyn881W28LiRsg7JD6L50tqXoAfYrG
         1YNw==
X-Forwarded-Encrypted: i=1; AJvYcCWVWRPeAkqyyq4S1iSu4ih/dls9r2qDcsGjaYdT3UyozChvN/ylN6PcDj0923B1LMhLbm61cwbcqavi7HYZuMg3FiIwGhmK
X-Gm-Message-State: AOJu0Yy8CM9thNPKffJXRV3yZc9iIJ3EgbQs9toXC5STQZmFt1Ut9RPF
	n8XPS3ZUmq7c4x2GRVXvB+ZPBkI1+7VEvxJAuVm6CQHYk87b+qwKyio7MmnpcO3oxTYL6v84QDo
	AM98jOHZTbQdH9a08UA==
X-Google-Smtp-Source: AGHT+IGa8qCTH1LNH/hmEAmVML0lM3qLC3vgS4lo0iysyChD5iecelBKp5Dde0rCv2FIne41yj4Q4w4VDl3wLvaY
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:72b:b0:e05:a1df:5644 with SMTP
 id 3f1490d57ef6-e0b115446e0mr18142276.2.1721783476871; Tue, 23 Jul 2024
 18:11:16 -0700 (PDT)
Date: Wed, 24 Jul 2024 01:10:29 +0000
In-Reply-To: <20240724011037.3671523-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240724011037.3671523-5-jthoughton@google.com>
Subject: [PATCH v6 04/11] mm: Add missing mmu_notifier_clear_young for !MMU_NOTIFIER
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

Remove the now unnecessary ifdef in mm/damon/vaddr.c as well.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/mmu_notifier.h | 7 +++++++
 mm/damon/vaddr.c             | 2 --
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d39ebb10caeb..e2dd57ca368b 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -606,6 +606,13 @@ static inline int mmu_notifier_clear_flush_young(struct mm_struct *mm,
 	return 0;
 }
 
+static inline int mmu_notifier_clear_young(struct mm_struct *mm,
+					   unsigned long start,
+					   unsigned long end)
+{
+	return 0;
+}
+
 static inline int mmu_notifier_test_young(struct mm_struct *mm,
 					  unsigned long address)
 {
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 381559e4a1fa..a453d77565e6 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -351,11 +351,9 @@ static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
 		set_huge_pte_at(mm, addr, pte, entry, psize);
 	}
 
-#ifdef CONFIG_MMU_NOTIFIER
 	if (mmu_notifier_clear_young(mm, addr,
 				     addr + huge_page_size(hstate_vma(vma))))
 		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
 
 	if (referenced)
 		folio_set_young(folio);
-- 
2.46.0.rc1.232.g9752f9e123-goog


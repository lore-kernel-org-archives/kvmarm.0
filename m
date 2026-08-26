Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167483C2BBA
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785530; cv=none; b=jSvuvajp4T6uWljQQ6VEKRraNUqy3us6xmJJOHHxs3unrwFObaaPCgh2q3lkMvMQjwY9e1Tlql+rym0+gYE6iNQ2aem4wXPZoKp5snGuMVJI9ti8LZAFdsEzVdRSi2nGArAMdKxZfwp5W4ET8FWzKu14Bleu4zcGlKvN/eUTpI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785530; c=relaxed/simple;
	bh=lDyYEYe/N4mhHSMmROmNTfj8SUYUweA+PUQNctk1vn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uYyC1iQ/KWxBs1xM9NI0eVkDzDcJvTdpm1jKoEyQ+mLjWcwhAgrSjHEAcPdTUDj7XqA4t9owcuunq2Y9NZtOlhbbtWFjsPlCOlj+xvvoIccq8n0EBe3bhz21mH9hVSKA9jhSWs9FabYJikMF9c0EdZFvt9S2e9a3PqECSoQd8gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZLJpGjeP; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZLJpGjeP"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d7367b7b35so1204395ad.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785526; x=1788390326; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nkGDVNWv+E37i1qgZxGANcWGk8EcR4uX9VZBG0WIwSA=;
        b=ZLJpGjePG4xWyISXo0e3vsPDyCvjoQmU3phAA5DqN2UmBTjOwksxXqcl/4rHFNQznN
         xCOar2QhwFyMOQhvXbGlHolQEDUwZrok6wz9+x15JvzG2yD7Vd/pHybcQDpBxiIgSYk6
         5Z04GTpYQMowo+uYYTu+inlVMs8Eblf+Vjkh4F8Ua/8tt6OrMWNc2tLZZksS6/ZK70hK
         jOXkGXFn0yUOEVpUAEyfBUMFdkmLuS7DmYTwrf0MRcyu7BYI0Q+La6KdzyWCKiLC3+QP
         h9QkLblngi8JzdAfqNd9ccsZVLZwctfcgFRU75DawSLWtL9nRhEbyOGCoHLW5LmTI6Cm
         njlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785526; x=1788390326;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nkGDVNWv+E37i1qgZxGANcWGk8EcR4uX9VZBG0WIwSA=;
        b=UFB865ELw3d+7dzMSPL5hWAAf5iE3HBaf2AD8c+1GtXO+0EoGf0MAyk4V6ALEBYird
         BVbVIhP8l3b+As+fCoitNbAwQNWz+FFmRckFkjCFqTHDSU26dmZ6vuSfaKpIg5NcKYuZ
         TKqUK2kH5AMW3JUgDo83WIjO2YR/P4mLEVx9b03sGNmKL6SUex1fQGgIHvesPJg5VHoZ
         aXDlDk+QP9WYBbUBIvzbA8uT3WUt9B7O2zBQMDOMAF7yyRGqH3Afx6L3YhbTOc/POyV5
         ZRyqGG5mn0jz3TS+9lSHbDkJMiwmk+h6gMu+iARH2iuP/uiIrTYjH9lu69v2Q+6IbzSx
         QSDQ==
X-Forwarded-Encrypted: i=1; AHgh+RoGrgk9DgHK8eiH0+5dKCOeXVQLwuzwvs22+4FgaAjHsA2e3cxRuYbB6w6jpa8yN680aEB8Lj4=@lists.linux.dev
X-Gm-Message-State: AFuF++mLaQH6JFGY21ZpoW/BK1HzqZHuDMmxKD+A7hFUqaJMsaixP6xe
	gTr2TDOvsJmcBkX0tN8gB5RyO0diXv3CF1Cc+m1EC5ubkWmyW3qki9urcwuVMKeSTchFIEfELMe
	95h0XQA==
X-Received: from plblc14.prod.google.com ([2002:a17:902:fa8e:b0:2d5:62cd:db79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19ed:b0:2d7:107c:917b
 with SMTP id d9443c01a7336-2d7107c934fmr164734915ad.0.1787785525359; Wed, 26
 Aug 2026 16:05:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:04:59 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-9-seanjc@google.com>
Subject: [PATCH 08/20] KVM: selftests: Use the innermost page allocator API in
 the memslot perf test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Use the quad-underscores physical page allocator API in the memslot perf
test in anticipation of converting the outer versions to take the memory
region type instead of the raw memslot.  Stating the obvious, the memslot
perf test creates and allocates from multiple memslots, and so can't use
MEM_REGION_TEST_DATA to communicate which region/slot to allocate from.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e1299611be32..844ea9b7bb41 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -339,7 +339,8 @@ static bool prepare_vm(struct vm_data *data, int nslots, u64 *maxslots,
 		if (slot == data->nslots)
 			npages += rempages;
 
-		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr, slot);
+		gpa = ____vm_phy_pages_alloc(data->vm, npages, guest_addr, slot,
+					     false, false);
 		TEST_ASSERT(gpa == guest_addr,
 			    "vm_phy_pages_alloc() failed");
 
-- 
2.55.0.887.g758fc8c411-goog


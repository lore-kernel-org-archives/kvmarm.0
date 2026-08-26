Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65183BBFAC
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785529; cv=none; b=cS+L4p5A1VRPr+c4s5TLOUuCJTT3FUI5Vz/iwxFtmu5rv2yiWliZHQByX8qfZxnp+/5UKMkk+dZiV/P0aJkud/5UEuq2rgIvVPY6ds/+XVh+nNd7rsklpp97wqT3xEeCwXfiusLD5SpfuIr4oORM8uvKoasW4j3+M/Wdg/RCVwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785529; c=relaxed/simple;
	bh=y4hPkYfBvuqhrsyV+0h1s9zlONbWKUfklZ+Vnp9FsNw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pjz7N+5XJXUY6d3ugmGY04ksi53qHkRUzLKnHmKr3wVRW0r5S8BLDi9Rc2oOGH39gtN9N1IxaVQk96bWQNOUGPqNkYKgONaLmBKLE4FiMpPILy6eLnsrhOhF69AzoJh2AfU8Z+Tat+OyXUt75B4LaOTIKhlPiGAgjTcxLdJJR+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s52boCOg; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s52boCOg"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-855315ccb64so26762b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785522; x=1788390322; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YWeAmxR3HdkD+eL/iYkERMpi9Iin+GwZMkGAjZk8hSk=;
        b=s52boCOgLxf3kJGgpyQ2JRTXlxiDYB0UklxCL698Ih7JQOYr9qUFElI3+TwyxLXofA
         AD3CiaPV22dJxKprjHictPFfLyuXmxdTm6Zr3IEbHeBYKsrYB42oe4iWWJ4eHIwseHWJ
         S3/2t4jW6crrmArKZsxYdJrz7i0mjsLpixUdmy4GyKR965eqVqQhC4k7K9xronSWTwgr
         UVHUGtBYqkc7FkdczN/e2HFErHvWPPaR5GT1dErQ/DfWfzBCrR9TVkn0V6biQwv9G0Mm
         wXBjVqkZdHsq+b7/qdkKEKuTNQMobvFcbaMupuYlnOFQ3BSr53w1sahsQxORH+Pp8W08
         QUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785522; x=1788390322;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YWeAmxR3HdkD+eL/iYkERMpi9Iin+GwZMkGAjZk8hSk=;
        b=T4wPq5bACwjMk69+YGzdD7hJcQUEpUie4ZVHY4aTObdI1jgyrnd0K2UuCP55NR3AVf
         BNsmIh8q7TouB9BbOXyF4nnU7nCjahIhp3gjmQ4m9fTcKRC62uhXBwNJLtSqAPKHjOS6
         tRrC+yQInGx676bE1ikEdfJWjSl4xJDWMo5sroOP5XQ3ThXf9Pdxyzp93vHdXsqxqdL0
         /U1S/pzCuBwH1qnZmLS3pIJL9A1J7whq+BjXRNKvtStB5zHsB2sSPPkwpqWpta4W/3+I
         dzPDEwwra2WflARndMHq5vY7phe9iJwe7kU5VWSvjszY+TCiwltwTv9uLLRd5sB5mTK1
         XwNw==
X-Forwarded-Encrypted: i=1; AHgh+Ro9PATH6eOiG4bgW8G2n+ZHm3MhVFiRIKV3f/F6vI7yistj3serihPnHhYAm1cnq7sWHEKUkWI=@lists.linux.dev
X-Gm-Message-State: AFuF++mbW1jjFh0oD7v+IrbZllr6ZZuuMsRZ4NIb0iJ3dxkbc9qn3QmX
	pOIBTod8SfsD91nxlSukd3r05vMB3aOBGbybsLnvX5WIiZ3DwE4UjOTBFyzZTLqzhfCDH24r+65
	4VXY92Q==
X-Received: from pgbaz9.prod.google.com ([2002:a05:6a02:49:b0:c85:a528:228f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c916:b0:3c8:d3a4:7b40
 with SMTP id adf61e73a8af0-3cf7576da18mr22519138637.2.1787785521893; Wed, 26
 Aug 2026 16:05:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:04:56 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-6-seanjc@google.com>
Subject: [PATCH 05/20] KVM: selftests: Use goto instead of do-while to retry
 finding unused physical pages
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

From: Nicholas Piggin <npiggin@gmail.com>

Rework the core loop of the physical page allocator to use a goto instead
of do-while loop when retrying with a new base address.  The do-while loop
obviously works, but it obfuscates the success vs. failure paths, and in
general is convoluted.

For all intents and purposes, no functional change intended.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[Rebased to latest mainline tree]
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
[sean: separate from alignment change, use enomem label, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 32 +++++++++++-----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b071d77dd301..bbf6d7684c0c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2049,23 +2049,15 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 	TEST_ASSERT(!protected || region->protected_phy_pages,
 		    "Region doesn't support protected memory");
 
-	base = pg = min_gpa >> vm->page_shift;
-	do {
-		for (; pg < base + nr_pages; ++pg) {
-			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
-				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
-				break;
-			}
+	base = min_gpa >> vm->page_shift;
+again:
+	for (pg = base; pg < base + nr_pages; ++pg) {
+		if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
+			base = sparsebit_next_set(region->unused_phy_pages, pg);
+			if (!base)
+				goto enomem;
+			goto again;
 		}
-	} while (pg && pg != base + nr_pages);
-
-	if (pg == 0) {
-		fprintf(stderr, "No guest physical page available, "
-			"min_gpa: 0x%lx page_size: 0x%x memslot: %u\n",
-			min_gpa, vm->page_size, memslot);
-		fputs("---- vm dump ----\n", stderr);
-		vm_dump(stderr, vm, 2);
-		abort();
 	}
 
 	for (pg = base; pg < base + nr_pages; ++pg) {
@@ -2075,6 +2067,14 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 	}
 
 	return base * vm->page_size;
+
+enomem:
+	fprintf(stderr, "No guest physical page available, min_gpa: 0x%lx page_size: 0x%x memslot: %u\n",
+		min_gpa, vm->page_size, memslot);
+	fputs("---- vm dump ----\n", stderr);
+	vm_dump(stderr, vm, 2);
+	abort();
+	__builtin_unreachable();
 }
 
 gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa, u32 memslot)
-- 
2.55.0.887.g758fc8c411-goog


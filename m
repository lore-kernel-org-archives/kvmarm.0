Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D7376463
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785516; cv=none; b=MnoKkCL/z5BUCCYDGEzJiQC0jvCJ+5oejcySZlsrZ5ZZz0cQNsytuJHpPdinhNpguS9jXQkYgdafZb8hTQn0HwRrnHurPYynlNbtNlS/wE4SIPDDG+rYVMe8AfdAOHi/FnrqKeIytYxf4lULn3Bc4qBsvoC+vYhrd/XhIsi8ajs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785516; c=relaxed/simple;
	bh=09nufcNEnQr4iHnEimrLNPRNUWNVw6IP6eINZA721YY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pytU/jBYuYT+Kjpo5T2xdKGOn2hBHIftVPbmf4qMJDfWoy2vt0iCWu0dwekuVYzC04NJYa35Ju3/ub7uxk9htyv2LV0HOLXX/WGbMcgcwFOu4O+ZH04zSZbYAHqlMW0OFJubV9NaIt/WlYwpA6cWS5GUbQfBJtTbvPsjDWvkOBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GdwRWUHk; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GdwRWUHk"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cec4226c70so1578715ad.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785514; x=1788390314; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gRDzIvJTa0HXgdmAJ1iBjSEqSYXJcGrZt7XM2C/1134=;
        b=GdwRWUHkhdmWTzaPNdmE4nlC9Aec98+F9ndp6FYJ1lhUw9be08A4sGHXpwuRonpWbO
         TT7Bt4X9cxWAYxlhQzvWZN9bc1iFRZzJpihbmOOnMBFepC46605KCaVPFv+o+fSSz3Jy
         vt7SBH+MIhuacl/3By5LNmInCigmNuDXhG75KC7ymuxlK1Mi/QGcFK4orHY3iTu0AZP7
         dXEQ1zn0vH0r0tthASoG2qd/nRmV82l1Y7cR2iyGAHaAkk7dEox/q4l1JinNiHMF7Apk
         fvQjUrhGKw6SQ2OCvS2zzpNJ//yhQNEf//KY49rCg4sPICB23orL5o29wdmpTJ31EVmG
         1UPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785514; x=1788390314;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gRDzIvJTa0HXgdmAJ1iBjSEqSYXJcGrZt7XM2C/1134=;
        b=rEE8jf7UojRuLd1WFVu/WxqRkGP75kZVYmiwvrIjdgMPkhSEXdhb0RkhysSFtp9Jxu
         wJ5GpwcMuZJMVsLxuCaC9QqQk55U0Am0enz+kslEZ3q/6plnm05bFRTHX0VbCtLGYDY2
         XAxBn2Ga7JyYbzdxA3Jc5mOGl9dISddc2EVqIXdzm4V05EdVGLIK7eiwx+/1fD86iZmU
         CKk03U3cB92oqlVriMvcYLyIR9miGnx9cbtnlsxemzoDmsEm2UgjGn2NxdkIYu6gnL8E
         Nj3fpzW4Z+9q0ThtHfwFhzlpjROwbqTbkswy19EE/ifkh8yYgjYD1Dq5j4OLkko47i7q
         8q8w==
X-Forwarded-Encrypted: i=1; AHgh+RoAPPcjJJYEkgOk190E5vIGhZB7qKT1r+cIP6vP4yVHNbPGzPqYueQ5cSsBKla+TsZ4A0xtpUY=@lists.linux.dev
X-Gm-Message-State: AFuF++lMDV9NQKe9k/uejXgUlLCdW1C5RRF3MNM2MehutSz5qGCkRfrP
	owvnE/woXWJoACf845IxVymq3EL5A0hpPvfodPem2OS+T8Vx69sKZU9vbDlZ/Q5Ny6u/RJ/gyJh
	x7cN79w==
X-Received: from plxl5.prod.google.com ([2002:a17:902:db45:b0:2d6:f794:4e76])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b24:b0:2c9:9a2e:dab0
 with SMTP id d9443c01a7336-2d707954e7amr191786295ad.3.1787785513509; Wed, 26
 Aug 2026 16:05:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:04:51 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-1-seanjc@google.com>
Subject: [PATCH 00/20] KVM: selftests: PPC pre-enabling
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

This is a big pile of cleanups and refactoring to prepare for PPC support in
KVM selftests.  PPC has paging modes that require multi-page page tables, and
those page tables need to be naturally aligned.  The original proposal was to
plumb in an @align param to the page allocators[*], but I didn't love the idea
of adding another rarely used param to the allocators.

Reworking the APIs to take a region type requires a fair bit of churn, and was
more painful than expected as I didn't realize just how many one-off tests did
weird things, but overall I think it's worth it?  If only to keep cutting down
on the use of magic memslot numbers in tests.

This needs explicit testing on s390.  I tested on arm64 and x86, and given the
number of failures I had to wade through, I wouldn't be at all suprised if I
broke something subtle on s390 as well.

I'm less concerned about RISC-V and LoongArch as they don't have any custom
tests that are affected (which is where I got burned).

[*] https://lore.kernel.org/all/df86b5ccdbdafc3509d9538bd5e6796737bab2db.1781093720.git.ritesh.list@gmail.com

Nicholas Piggin (1):
  KVM: selftests: Use goto instead of do-while to retry finding unused
    physical pages

Sean Christopherson (19):
  KVM: selftests: Use MEM_REGION_PT memslot instead of '0' for s390
    regions/segments
  KVM: selftests: Bump the minimum GPA for page tables to 0x200000
  KVM: selftests: Use vm_alloc_page_table() to allocate LoongArch page
    tables
  KVM: selftests: Rename "num" param to "nr_pages" for physical page
    allocators
  KVM: selftests: Extend page allocator to support naturally aligned
    allocations
  KVM: selftests: Make the single-page allocator APIs static inline
  KVM: selftests: Use the innermost page allocator API in the memslot
    perf test
  KVM: selftests: Use the innermost page allocator API in s390's IRQ
    routing test
  KVM: selftests: Add a wrapper API to allocate multiple page table
    pages
  KVM: selftests: Initialize vm->memslots[] with invalid memslots during
    creation
  KVM: selftests: Add APIs to override memory region types with custom
    memslots
  KVM: selftests: Add TEST_EXTRA memory region type for "special"
    memslots
  KVM: selftests: Use TEST_EXTRA region in arm64's vGIC LPI stress test
  KVM: selftests: Use TEST_EXTRA region in x86's smaller MAXPHYADDR test
  KVM: selftests: Use TEST_EXTRA region in set memory region test
  KVM: selftests: Take the memory region type, not memslot, in page
    allocators
  KVM: selftests: Use TEST_ASSERT(), not assert(), in
    vm_get_mem_region()
  KVM: selftests: Automatically pick min_gpa for allocations based on
    region type
  KVM: selftests: Add arch hook to force page tables to be naturally
    aligned

 .../selftests/kvm/arm64/page_fault_test.c     |  18 ++-
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |  19 ++-
 .../testing/selftests/kvm/include/kvm_util.h  | 106 +++++++++++++--
 tools/testing/selftests/kvm/include/x86/smm.h |   2 +-
 .../selftests/kvm/lib/arm64/processor.c       |   4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 127 +++++++++++-------
 .../selftests/kvm/lib/loongarch/processor.c   |   5 +-
 .../selftests/kvm/lib/riscv/processor.c       |   4 +-
 .../selftests/kvm/lib/s390/processor.c        |   7 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  15 ++-
 .../testing/selftests/kvm/memslot_perf_test.c |   3 +-
 tools/testing/selftests/kvm/s390/cmma_test.c  |  19 +--
 .../testing/selftests/kvm/s390/irq_routing.c  |   2 +-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 .../x86/smaller_maxphyaddr_emulation_test.c   |   9 +-
 15 files changed, 219 insertions(+), 129 deletions(-)


base-commit: 76671054f9a1ff6abb976583cd8da37650acdc97
-- 
2.55.0.887.g758fc8c411-goog


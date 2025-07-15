Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FDD2DE719
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572079; cv=none; b=WlraE+XD5mKrajc8VtWuDyWDNsJtMMNAzOvAvBWk15OQGVzrNQkPt3s8qX131JZy0kgigpVJi+HXLQbU6gyFEK+G8NeUSZz8c/yrFbCizfvSQL+/SC71Io5n/Cv0XWA62yIIVsT/BYtiizEaEVdy91n7fEjm44S90DSgpjh7wgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572079; c=relaxed/simple;
	bh=sFAWxHye44w1R+mM5V+LDiCzTr6ROyPDzwVyA8ugqX0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lKNkDGml1X/sEDvLyZSoiXdSxICCbAwXPCBTAy8tElyXEfhNgqQFcy0GjX3gXlWyrtWUGafw3OOcmIbnFBAL6IKbOk2mRhOcTJN9Xyiv4rbeZKidcLFtS45WHKJQIQnEqTBbqTUbgeRYUEg2TK3SIwQfXl8owWPknDpHOhFuCAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SPRf/PuB; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SPRf/PuB"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-611a6509b1dso4696579a12.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572076; x=1753176876; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AOxTG6i7FEjwgO78cp+SZydc4yJ2EnAl5OEX1LUXtxU=;
        b=SPRf/PuBFkkLLZdnpHVowwgr3fdKDknJee4YdSzWNrR9xJZfxC4n+HSpHKCOtFE9//
         gWIjdwYisPXcgph3pHILHDkRg9wBrEf587nNTzZHs7JYzQP/wiVteANHvMW9HPTxnIZ4
         mliOaj4fl3WF4UkbnSCTZUg1VzR9zX17soqhnLvFMs6ZKH2Y7OfT8+/xMeB4PGs9j6Nt
         DUjmTpiIROUp+2Q/QhqfjNMMZ9atfHhhg2Iey9yzCwfVj54WQCCjzV/bTPrlHGf5Fe/7
         +QB83h+kKnG5vtBEx294oQdIF3bn0Be4BtgrJmbkB7cfkJz5rOiMTqVtlBzNrLxARTb2
         4OUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572076; x=1753176876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOxTG6i7FEjwgO78cp+SZydc4yJ2EnAl5OEX1LUXtxU=;
        b=v3/fyBW6zJ3R3dsOsiP+4bQZCaeUwmJqdijOB8F1vvSk9vIAmRWg1C1hDDc23ckCrm
         +KAnguZNbra8OvcFoAHbFXOdGdaFV7BzsJBrPtTRdnVNBF3yMIAtf/+jnkHHENttF0PQ
         86MGDPutjWtVVNFmQHgOFpy5EvEOWa/nWGRMKbUZVAsiiNxj5oT1a2rFVlydFY4OQcYA
         kaA7XvIKKYEOqLhn9vbs1+/Q1/zhXEwXxPJEdemOmPWvKYKCJb3l5saD1Xddw6301jWq
         2mjVrVbtWD/wX7t6NnD6B+r+sXQQRqJsr64bnhu8XtZ/qKcneSe46vAP2cwMEjwc5VfP
         ADEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOSOax8G6LVoMjNTxxoJKJYaE59NhPJzMFBeHaiQE3gYyU5TXy3MHwlxDAzEF4vpW7GNRYFt0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWSbw55zHa3HLXRljZSpHXZwzg8GEkYFuT/32yienO0ZcY83vz
	aBgFni+dbQSQhlgnb117Lvl3YsUEum58lUAk5QcCdf72CqtPlW+REvVKK5atLXu1CAFVw2ixfdn
	OkA==
X-Google-Smtp-Source: AGHT+IGI610lCZHGfon3SNZZY/SVw9WaoOiFuKCCBX2T0KCJ+afRtNdmxFp5hhQEFR82WUfFrBduY0Ajzg==
X-Received: from edt19.prod.google.com ([2002:a05:6402:4553:b0:609:36ed:3901])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:378d:b0:5fb:c126:12c9
 with SMTP id 4fb4d7f45d1cf-611e84c2334mr13524470a12.25.1752572076080; Tue, 15
 Jul 2025 02:34:36 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:49 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-21-tabba@google.com>
Subject: [PATCH v14 20/21] KVM: selftests: Do not use hardcoded page sizes in
 guest_memfd test
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Update the guest_memfd_test selftest to use getpagesize() instead of
hardcoded 4KB page size values.

Using hardcoded page sizes can cause test failures on architectures or
systems configured with larger page sizes, such as arm64 with 64KB
pages. By dynamically querying the system's page size, the test becomes
more portable and robust across different environments.

Additionally, build the guest_memfd_test selftest for arm64.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Suggested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm       |  1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 38b95998e1e6..e11ed9e59ab5 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -172,6 +172,7 @@ TEST_GEN_PROGS_arm64 += arch_timer
 TEST_GEN_PROGS_arm64 += coalesced_io_test
 TEST_GEN_PROGS_arm64 += dirty_log_perf_test
 TEST_GEN_PROGS_arm64 += get-reg-list
+TEST_GEN_PROGS_arm64 += guest_memfd_test
 TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
 TEST_GEN_PROGS_arm64 += memslot_perf_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ce687f8d248f..341ba616cf55 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -146,24 +146,25 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 {
 	int fd1, fd2, ret;
 	struct stat st1, st2;
+	size_t page_size = getpagesize();
 
-	fd1 = __vm_create_guest_memfd(vm, 4096, 0);
+	fd1 = __vm_create_guest_memfd(vm, page_size, 0);
 	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
 
 	ret = fstat(fd1, &st1);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st1.st_size == 4096, "memfd st_size should match requested size");
+	TEST_ASSERT(st1.st_size == page_size, "memfd st_size should match requested size");
 
-	fd2 = __vm_create_guest_memfd(vm, 8192, 0);
+	fd2 = __vm_create_guest_memfd(vm, page_size * 2, 0);
 	TEST_ASSERT(fd2 != -1, "memfd creation should succeed");
 
 	ret = fstat(fd2, &st2);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st2.st_size == 8192, "second memfd st_size should match requested size");
+	TEST_ASSERT(st2.st_size == page_size * 2, "second memfd st_size should match requested size");
 
 	ret = fstat(fd1, &st1);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st1.st_size == 4096, "first memfd st_size should still match requested size");
+	TEST_ASSERT(st1.st_size == page_size, "first memfd st_size should still match requested size");
 	TEST_ASSERT(st1.st_ino != st2.st_ino, "different memfd should have different inode numbers");
 
 	close(fd2);
-- 
2.50.0.727.gbf7dc18ff4-goog


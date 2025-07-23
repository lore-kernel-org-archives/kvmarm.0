Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A872E49A3
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267661; cv=none; b=QBmGzSFapiDgU5qSnJNfkL7f/FY5At27LhB8S0I3CO08JvlB02QgcY8WBL5Zbx67WuQuSOwQlTdOwTCFeiJzWWMVWdxM9p4xSvffcbqFHrCV3fYCSzhk2w7AsaDKZ2pF84PuavP+dd0GpidmGmuHstTPDNqtPr4yke1g8ORY2uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267661; c=relaxed/simple;
	bh=igtuia6aVFYH1d+MVoOHpwnK93zbhXi6LJc16zRc8dk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i3nZ91vRh41OKkA+9Wd3YO6jZADJxPNuHgxxx1Z7j/VqHz5xqQa187PrUqf4HtgGQCvPTcj8m6GvH2KCcczuNuaQdTXKgbYrVmjceRi8VN/MxfkD6oiirHeyOrxzd2QgJLs7JqEtFWfkjWuvQXQPg4nUBnmmYU6mJXBMx+MnGZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yoRTbp1k; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yoRTbp1k"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4eeed54c2so4174291f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267658; x=1753872458; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HOSoWQ4+/yGEs/NqGALv7XevomaPnLrGHC8IlSxBAg8=;
        b=yoRTbp1kDezCXhJNnAuJqeIz2Js03JB0+xLc6k+WuopjvggZ5ptegv6JDWDuY1xKvR
         caggP6hofNh538FKIYg/EYZAIh/+TRgItf/6a7schHr7/dXREzYS0C/gt46WDb5fT3rx
         oW5dOLTtJQOM6vO5/3df6zVdSi250gLWHoe8vQPggSTSHNyOjn2rCPAssR7kXJD3bUnR
         9RjjT3YUjQinm48/ZKmqvwpvGqPVUZsyx+HjeHavkrmgJPBJ8l+xoNj5DsfQfIz1lInw
         lttKQ3FhMU0emP7dtGsPTtrSpVvwlV2wGmYIxbB43AoV/Ig1ApMqnq9Ywb7Relm2SvRU
         0iIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267658; x=1753872458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HOSoWQ4+/yGEs/NqGALv7XevomaPnLrGHC8IlSxBAg8=;
        b=Ybng8CDa/B1au+x7xkMVyoI22ysvMVB2ymh0eF/4agfGSzry+nXTt5gtZ26NhxetuI
         yqC+2ix82xui1+6oFrQMytrf/wXrjcOhGDqaNBooVPnbJdWZqDkn0bujQFgxt2N+5sS7
         LMU8Xh8Vg/LdQoz5to5L//2cDbGFOKefQSAvTIk0pag/thXPTPsZ5FH/hma9JANrLdVu
         DaV2rUiFUir9VTXxYVxlH1wHtNb6hBnEbpPp2nWcAC8qvAujEH6eBC6JwiQN8TTfI52e
         gvZIj/pHy6AOwZ0+N9XXHVK4Alb+p8AC2c5eT8f2V/Yk0c8IrbF1nHu4l9lIvAhWgGmJ
         CczA==
X-Forwarded-Encrypted: i=1; AJvYcCVZxYPea5h4NdJ7k+GFAyQHfYBT28pauJwoit5HDsgQ6BpUxVKrjqrV0SQA5NlLYp8dCWhOwG0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWkCQs04HfwJ+RlZ8XgpjHNYCmt9SVtIL0kAPzV/8Ls6IdyTGT
	BY4nuUIfP3/ADpezM0NLr/en1f9Z9WVJmaxG3RIZNA1yD1/p3QeN8lglPlaft20ao6P5y2ruvbD
	tGA==
X-Google-Smtp-Source: AGHT+IFYDyBWPe2+6tP7KCxBAfbDw8azEGmzllmCBYSUMT9NPuE3ieg8wuyvATEHSgUhh0Dh5p9i1h8xlg==
X-Received: from wmrn36.prod.google.com ([2002:a05:600c:5024:b0:456:26d1:4451])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2dca:b0:3b5:f7a3:3960
 with SMTP id ffacd0b85a97d-3b768ef9510mr2077699f8f.33.1753267657792; Wed, 23
 Jul 2025 03:47:37 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:13 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-22-tabba@google.com>
Subject: [PATCH v16 21/22] KVM: selftests: Do not use hardcoded page sizes in
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
Suggested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm       |  1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 40920445bfbe..963687892bcb 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -174,6 +174,7 @@ TEST_GEN_PROGS_arm64 += arch_timer
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
2.50.1.470.g6ba607880d-goog


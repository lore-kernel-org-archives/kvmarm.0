Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F036D2BE7B5
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648850; cv=none; b=XP3ppW0s1P+nN8jSQ2yNkphub+x59MZWE3L3V6+imVOWBO7eObnDrYiUeyTjCyOOClrN9ZNQfrA8RhjtdrMy59suYRvUrXtZbty7I1+4XX83u9GjxqG2g7+uH7Ao3itlVDvKVtFxiMVFY+Yzhj6Lr2Ubl/4mHDn2VWLY/mkWuAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648850; c=relaxed/simple;
	bh=m1FXF0Pr/WuTL57w9QC810/IuAAA62qhWISWmGtCWp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VytBjnn6oOJesGKDBnSx55VBB0iOlsF/VHXro4omfO/tjmQXVEQMT51EkkAp1eGbVAMmbJ6knlAuIEyNwnsAhOJbK35eY+hJ3RO8UL6vA5Llxn4S46/xjYOcriOnzn2abru0ZRnteshPffC+MoQXrJgdEoKpzD6vSdFyJD/Vn3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A07ZdK8U; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A07ZdK8U"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-450db029f2aso30452765e9.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648847; x=1750253647; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HhMMHPCLGACkcKVf5+6mUDlWv9E5h4gdh0oW2i6XcGE=;
        b=A07ZdK8UsGCT5IodRKiwc5EhkZISjdIyQwjEh9i51SOTzEUKj7nCsoO7/RJNgcrKaP
         htwD3QifjHIqaRFSlJBfQirbAQ4dvBrda83lj6WIrENazvQAx0QB2bOHgbk4Fz6CgY64
         oCcYAcyai62pj5XfflvR/BvcbiaJC0z9aPxh8yAR/jyRzqCPSmOtEktwQ9kYsKkjQdMo
         vW9mxqKfH+uPauOAhcZK1LooauIxBE+JpUkPE+W9at1oRhTZ3FQpWFaoJIIQHVkwBtis
         HxWZ6B0ww3rmUFVT61FXxuBSP05PasybQMkZYmC/3jeo0nuyKL/1uytJs94u6Shb7++c
         2SYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648847; x=1750253647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhMMHPCLGACkcKVf5+6mUDlWv9E5h4gdh0oW2i6XcGE=;
        b=VzaD9YW3mcxlkGwV3Qv+txPTZWRqzQe0gfh9iJSCd6z8G4eU9EmdMRgM6aUoOZ/mqB
         8jL3RltMm2KMHPRENE6VihcmgNDIrdjEDkeStX+HYHcemVVTBO/QVV4pCIQHgmgKNpFG
         zyQvzpMnBvOcAtwGgI4RXaulSvWAEgYZYbib1dFncfowMjZu+MF6MWHm6qqHWWujnFan
         dl/bfuE2iNgHbGvZna4oIU5nztX12KDQXj+gxYzk/PKsyIAF7sVk6hsL401/o9xm3+Ky
         XMxTkfw5Qsgj/EBQ1sc//dZqGe9KpiwhPU8s6Ogm4IXraoUPRLzw7hRFmCBO29Kz34Vl
         KkRA==
X-Forwarded-Encrypted: i=1; AJvYcCUeXNgvX6kEY8Tn4Y+3o2MNcQI1GpkTLEv0hggnSOnrxZx7enElY2YLYZIkMTbmhWXD2TceDws=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFMkBAVnpg3nze6a4UbD/PrOf1j3KCn4QhFxtmdE26Z+2NDKG+
	af/7tt/MP6QsxF6eF9zxXXKbXEo/aNsshk64hoDy8qrNbIcOavW+aReOS11ofXk19wl8w91h2Ro
	rJQ==
X-Google-Smtp-Source: AGHT+IFl2rGDbEyyq3Z/x9draA1KG6JcfdmJL5N0xgRsAf7iQvJmF31fca8I9HdR2qtrE21yQqMSi290GA==
X-Received: from wmth23.prod.google.com ([2002:a05:600c:8b77:b0:451:d768:b11d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d92:b0:450:cd50:3c66
 with SMTP id 5b1f17b1804b1-45324f4017dmr26302775e9.29.1749648847434; Wed, 11
 Jun 2025 06:34:07 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:29 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-18-tabba@google.com>
Subject: [PATCH v12 17/18] KVM: selftests: Don't use hardcoded page sizes in
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

Using hardcoded page size values could cause the test to fail on systems
that have larger pages, e.g., arm64 with 64kB pages. Use getpagesize()
instead.

Also, build the guest_memfd selftest for arm64.

Reviewed-by: David Hildenbrand <david@redhat.com>
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
2.50.0.rc0.642.g800a2b2222-goog


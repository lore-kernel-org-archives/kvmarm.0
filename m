Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E361A2D4B62
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829772; cv=none; b=dWcwzAD7Rskc8NN/GDAbiPLPznlVoL6jj8JcmRARofPV8/BhxaWCMS+SMuE/Kb2OQ8w7/dliiS5yDS2lmwp4nRHM5nOB+fvCOD2mpU5t8IQUoFOsuWgVCvSCdMIWyoAdz39nw7Ij1eA2FX8wrJ+zWKbwfMouFHwx57t0Zvfx+YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829772; c=relaxed/simple;
	bh=OHF0d3xJE+lvk3i6OCBD5mRif8KdjhliFuoV3VGobDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eEAAHDMrkbMq+UoJv7CeF5KihuUtoE/87uTMpKxhxHNefUcY8GHHLj3DmW7LSiId3BzirpLHXmzUy8pIIsQWbM86vjNyhgI3hL5Ub5kqQzj0T1CPtL+H5gUR/5hRlfqZ+T1V8pyWsZXeXZX7g164UKlO6GFXgWhJco+fklpRDuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qk6F/qwC; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qk6F/qwC"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31df10dfadso4285394a12.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829769; x=1754434569; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+ESC0itWrrYha2Tf9gSEwP/cvcMjKDVsb022arfffBY=;
        b=qk6F/qwCzw4la3ujU3Fl7fTPnJl3wSDLcEp8bB/hoxzj+a2hy3QXTRhUvLdM3FKfNW
         QOJkfX6yC2cYhue8r/g8vxeSykX6dLIV05x4i8acFtbZmir6h5IyyBxdcrDRyRm8v4Iv
         5RXuxmUKIoZTXO0MChLs+tW2LetKql42q4ulIY0GQ2golyho0kCYYvj7CokP4QdfVNl6
         Qu6fQKscVP9/hyXz/pQ57IqFfNycrJr1B8jTa8W02QfhLqiODr/vX72u4iCN1+T/Mpmg
         sDK1wuf/Y2z53GSIfN2+k+g03iPH+xgNiTVKybT7a3RQXmogsvdE7Yip+iJNyV5BHEkz
         i//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829769; x=1754434569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ESC0itWrrYha2Tf9gSEwP/cvcMjKDVsb022arfffBY=;
        b=BKEbX0wMzp7tnSFwEj1TLfJs3kZ9bydcJIIq82s2YDrxkFJtORosbb+c/HReMmwqPG
         HTsXD2ISMTVGQWUSJ++YDar4Sqy9CKoDoxNmmI8yeCqKAQdG0lHy6sHaPZZ3Ib9vuViP
         biE2aIvN7oLS863FJ140LLK+ELlKrDPbvs2qkmd/WapF94M3i0W5HW7likgLEHo/h8Iv
         lf9P6Hr4+GQVelL3A0+uDtzeDddFQjgezrZLsslFlQJS40NzF29n5/uNbAp8WKLPyHRw
         0KDRHcU/lKxDSfGxBQMWHR1X/b+oIZjjmAaMc4cNPHxyjt857gO9JZbvOes5cLMV9tdQ
         LQrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3MINHcFvJD7lV5wYyjPn5Kc9LaEZbegdgTi5iI1DlVTzLPbmt0htakaUl3c10H5YkE6+m0cY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yymmy3mw1kEXjD5euWwgeMQYvVokNh/KGW17KnZ+3REF4FhKULN
	qjoZJMwf+RAAe28WjJFIziDji/iLe2DC+m5khfFh7xnHVoWKFzbgDXVK1yrMgl1NgRUff1qpKxT
	mfjYNgQ==
X-Google-Smtp-Source: AGHT+IEP72ZXZaJ48/ldlCnpX6zM87VMY86dQ66SFrkWz5+rNp24L8qvClHiEDb9z5cTOvOVU6+mQmJCcYQ=
X-Received: from pjbst4.prod.google.com ([2002:a17:90b:1fc4:b0:311:f309:e314])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2683:b0:312:1dc9:9f67
 with SMTP id 98e67ed59e1d1-31f5dd6b52fmr1710635a91.2.1753829769155; Tue, 29
 Jul 2025 15:56:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:53 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-23-seanjc@google.com>
Subject: [PATCH v17 22/24] KVM: selftests: Do not use hardcoded page sizes in
 guest_memfd test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

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
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.50.1.552.g942d659e1b-goog


Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA1E294A17
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058832; cv=none; b=LIqRGfeAJNx6xQsqrG0X5QW86FlUoQ6LXOXeuWi4bMUZaZE2SB0OmbuzJB8bnhxfZAc7OekB4rDBN6bFa3BFSnEccq151zzDUIG5CT6E55OA6bz7DxIL7T4rZCMKEPeduecU+TKQ7zmIUz0tb7n44B2+SEyjQgBOX7UKuJ1CH2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058832; c=relaxed/simple;
	bh=sFAWxHye44w1R+mM5V+LDiCzTr6ROyPDzwVyA8ugqX0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tJ72BMgnfRaJ3IvsihQ/HlTo3tKtSlYo6dqi+3mWCc+l0Wk/gef0MN7ZpfwE7qmkpCwearBYcXKgDIDN5HoOG5ejJ3L0+wQBEYNwumRqQJTv+RTtoSrUTLDiZVcYNyG/L9n5ogGLUsm2uDI59991tMAZxNC4Lxvzye11QZb7IAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O5WW2P7c; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O5WW2P7c"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso4453385e9.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058829; x=1752663629; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AOxTG6i7FEjwgO78cp+SZydc4yJ2EnAl5OEX1LUXtxU=;
        b=O5WW2P7c96LKnh21Iu1nuh7PiKVuU8YFDSuIfpLkunlZamrWtSx0hwGTi3qHwFS4+x
         AsRwODKgLw59Vdf+uVjEz3Kxacn+vVj4lbHqNDDRKic+/cAMlvZMr0QKlUD3uV+nzJIj
         dw8Av7N7LtUcVEaQewlg+suiWikioM97fnzmkk9vdruMuVc+Ws+iu+quW2zBfHtpqVQr
         3uPlHrnkEUl+vALJ9kC1R7ndPbqzizo9UuokGuKhjaJlj7JrKkSsCAYJnCLjgRg4obrR
         gZ3Y4byFmiVp3H9q/2H+hYqSrZZ79P53v9hpwA+y1F5D6SVvh0b1KJKKTnW3wI3rI7Nu
         K0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058829; x=1752663629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOxTG6i7FEjwgO78cp+SZydc4yJ2EnAl5OEX1LUXtxU=;
        b=oDKYc2E8+iCxPCL+uYJRkQEsRdYS0PkuJj3D6I2M45hS0NLgqwnCqfd3n/L/iDXZSF
         l+8iKDFMrZWXTT7tdHCx4P7k84AOBxFqYbpSy90MmVEoLcaoGIh5ZESvr2pmz03wbo5Z
         yTSS8eVZjn+WDyG1N2jD7eMqoMxlM1KlAlSnE2M+jzT0gnSaJBn26XrDGB48V06zxPmu
         7ZAkP4zq34nHaM0zm3s1R3D2zBbeKHPowj7u9dCF9JMDwyXFxjV29276VJ4zus2LtQi+
         ENtns/N1W2AzBwf3zxk2lt122Lk6LwRKS69BTnBC3/4EVhjG7arxAfCQsAMxlGHFDjvV
         wvyQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4cZz7DQ/5v5F+bFkPCUsnfT9+VTHJlffF/lnv8ylzinO+ICxvfD+tshaPAEq7ekoKZqN2fKs=@lists.linux.dev
X-Gm-Message-State: AOJu0YytO3mdHtahAh2EQG6AX2LmYSlP+sxfYuC/anJ8htEwVIyVyClM
	9YefZIxqi+gWF58s3tAqebiQ4hIUgKCEjnEJdLs+i65uts+hru4o8wRmaQOYmn14MonM7xU95EU
	Bug==
X-Google-Smtp-Source: AGHT+IFdSwxkFLAEN6CNFwVXxFriwP42Gm3qhGkZfCyvKknZ+QLqzKDU3WwX4X8QMks3hlpMifs1nostZg==
X-Received: from wmbjh11.prod.google.com ([2002:a05:600c:a08b:b0:454:ab4e:3223])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:580a:b0:43d:5264:3cf0
 with SMTP id 5b1f17b1804b1-454cd680a76mr46079365e9.11.1752058829176; Wed, 09
 Jul 2025 04:00:29 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:45 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-20-tabba@google.com>
Subject: [PATCH v13 19/20] KVM: selftests: Do not use hardcoded page sizes in
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


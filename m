Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3811B41760
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 21:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753911287; cv=none; b=XIJNZG2CJsmk9QPszS94YVzTYfAAzdAfy0B+gqqi4ySdc8oo33dg84X5pMm9c95DfgtxEtb76d1f0Y+B0ai3PUe4gdgA4Etv6CsW4tdBhpcr0jUCWKEv2WcdQzmpmY/ZqPaV0pjKxdGZMmlA6u4d6OAScb78LLYwkVUbs4y3cWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753911287; c=relaxed/simple;
	bh=sDR2G1172uhe25DxV0gYE63aiNpaRb4ud1zD/6bxAk0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=alT+cZyB+JFvHeUQYfh+Od2Dy9842QwfW/N7Yg5KxNX+k9o+HUc055364JGaqhf7ddFQPMzOnszVImNNTwPd5lU/e456DhZ3f1uukDE8xpm91ykGk8Ys8psSvjfcfFKlY244EZts9oS3w5+CoG3GIsibRPn/4U6LU2p9VZfs0vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pn1YiT3g; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pn1YiT3g"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b321087b1cdso287283a12.2
        for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 14:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753911285; x=1754516085; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AZoCrmESLbLCViBEraaeQvy8SUfzt9/XLBDROzjvgL4=;
        b=Pn1YiT3g8UhM5dbXnkBrUJbz6dkyJ6goEBGSe9vfSw0+A3RN35BBcreKZagoBfgkTc
         RfUUBLzcI1+0G7gx/IO7MCRLYpxDUxzHHOISaMW7OZ5R7JaU9mLuxfB+Lr4GLpVBzI9H
         iVcrX7Beb88KZwc49oYNagUnFtIGik/xT9/or7A4A9+G1PfxIFaChl8MsLLvyljxZaeD
         PYd5rxYVBh+jCbGMc9xcu6vETwJhHZuHwOaGTAeNj4e4B6riEUe6pqoClf552m/ygAta
         8dvnisDtJFKr30ZjJKzVSsdulUFCBpK4mXRvcQcAoCwLygQ6OpS9S1bu+V7c/8VBrNkq
         4uqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753911285; x=1754516085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AZoCrmESLbLCViBEraaeQvy8SUfzt9/XLBDROzjvgL4=;
        b=LpuqLPNlRCj4Opj/p92gnhWfeL3S+G9yjZIAa5J7NNGjRtMpAXSnKXdM+Tmu9iVDCX
         cW6z0yYJrxVmtPqvswoxd0vXaIBjQxhFprx7fbziIzI5zTBkoHuDsk/eylgQt0hwCsdf
         /7JaRXh1LSJKQ4Bv42wuLUAP0ZeF95teHzFoFOOk3uOc4US20c9yIqn/CXU44szAUekF
         1nllABa4L6olZpAjn1U45Hr5n8Cn5ppcgSgWhyCp/VcvfwfXL3Gt78MYF0feMbUHc5Bz
         UaYFpBXER1MiljhEHAKnIZzQ+Vv9BCKzz00HsCMfntmB22dnMZRB4h+rkpT8KWzDWueS
         XzEg==
X-Forwarded-Encrypted: i=1; AJvYcCX1p4djwXb0GPNAWUUTaAFXXOQwyBWesiAoJoKmuIlWkqx882kAo8k2U5kHuDhWZk3l3N5VJLQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2+bgRAYF7G+7cB1OiHukuANuEqK5zbl2H18uU/+H6+ZitHHAX
	forZly1ROzRkwasT7CQfI4hiXnUdbsV10rk66SlXRylQKk/jUI3NCxUO5AHJDknJzqIxbhcFow8
	4jI1xTr3F5egHxcZd+S7uBtDiHQ==
X-Google-Smtp-Source: AGHT+IE166c54Arspc6vUihH1B2IIMOPFqYhg0hEsHJt45VP/+caD/xvYgvBnOUC4GXLoFyR6oHwfyE2Q105ihyuUQ==
X-Received: from pgar7.prod.google.com ([2002:a05:6a02:2e87:b0:b2c:4548:13d0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7283:b0:23d:bdb7:d9f9 with SMTP id adf61e73a8af0-23dc0ec1d54mr8719397637.31.1753911285429;
 Wed, 30 Jul 2025 14:34:45 -0700 (PDT)
Date: Wed, 30 Jul 2025 14:34:44 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
Message-ID: <diqzwm7pjrbf.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v17 00/24] KVM: Enable mmap() for guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>, Jiaqi Yan <jiaqiyan@google.com>, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Paolo,
>
> The arm64 patches have been Reviewed-by Marc, and AFAICT the x86 side of
> things is a go.  Barring a screwup on my end, this just needs your approval.
>
> Assuming everything looks good, it'd be helpful to get this into kvm/next
> shortly after rc1.  The x86 Kconfig changes in particular create semantic
> conflicts with in-flight series.
>
>
> Add support for host userspace mapping of guest_memfd-backed memory for VM
> types that do NOT use support KVM_MEMORY_ATTRIBUTE_PRIVATE (which isn't
> precisely the same thing as CoCo VMs, since x86's SEV-MEM and SEV-ES have
> no way to detect private vs. shared).
>
> mmap() support paves the way for several evolving KVM use cases:
>
>  * Allows VMMs like Firecracker to run guests entirely backed by
>    guest_memfd [1]. This provides a unified memory management model for
>    both confidential and non-confidential guests, simplifying VMM design.
>
>  * Enhanced Security via direct map removal: When combined with Patrick's
>    series for direct map removal [2], this provides additional hardening
>    against Spectre-like transient execution attacks by eliminating the
>    need for host kernel direct maps of guest memory.
>
>  * Lays the groundwork for *restricted* mmap() support for guest_memfd-backed
>    memory on CoCo platforms [3] that permit in-place
>    sharing of guest memory with the host.
>
> Based on kvm/queue.
>
> [1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
> [2] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk
> [3] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com
>
> [...snip...]

With this version, when guest_memfd memory is mmap-ed() and faulted to
userspace, when there's a memory failure, the process does not get a
SIGBUS. Specifically, this selftest fails with "MADV_HWPOISON should
have triggered SIGBUS."

diff --git i/tools/testing/selftests/kvm/guest_memfd_test.c w/tools/testing/selftests/kvm/guest_memfd_test.c
index b86bf89a71e04..70ef75a23bb60 100644
--- i/tools/testing/selftests/kvm/guest_memfd_test.c
+++ w/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -70,6 +70,10 @@ static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
 
 	ret = munmap(mem, total_size);
 	TEST_ASSERT(!ret, "munmap() should succeed.");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			total_size);
+	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
 }
 
 static sigjmp_buf jmpbuf;
@@ -104,6 +108,47 @@ static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
 
 	ret = munmap(mem, map_size);
 	TEST_ASSERT(!ret, "munmap() should succeed.");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			total_size);
+	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
+}
+
+static void test_memory_failure(int fd, size_t page_size, size_t total_size)
+{
+	struct sigaction sa_old, sa_new = {
+		.sa_handler = fault_sigbus_handler,
+	};
+	void *memory_failure_addr;
+	char *mem;
+	int ret;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+
+	memset(mem, 0xaa, page_size);
+
+	memory_failure_addr = mem + page_size;
+	sigaction(SIGBUS, &sa_new, &sa_old);
+	if (sigsetjmp(jmpbuf, 1) == 0) {
+		madvise(memory_failure_addr, page_size, MADV_HWPOISON);
+		TEST_ASSERT(false, "MADV_HWPOISON should have triggered SIGBUS.");
+	}
+	sigaction(SIGBUS, &sa_old, NULL);
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap() should succeed.");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			total_size);
+	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
 }
 
 static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
@@ -286,6 +331,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
 		test_mmap_supported(fd, page_size, total_size);
 		test_fault_overflow(fd, page_size, total_size);
+		test_memory_failure(fd, page_size, total_size);
 	} else {
 		test_mmap_not_supported(fd, page_size, total_size);
 	}

Is this by design or should some new memory_failure handling be added?

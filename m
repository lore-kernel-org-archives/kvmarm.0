Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F97221F24
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 22:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753915487; cv=none; b=to/BzWaUoXjwTG3eoAtJaw8NUm9muKMAonYLq6S7/amOm41Od/CSA+qD9VFJERz7kIsbEmJWasRjz2gsCJGh+gyNo3O4aPOCHdu86KjeulfZuUCbyhOzth0FhUje70dJg3rIjdtXSRJxes0NyYwCVMXcMTtxxr889Upv5jcvMxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753915487; c=relaxed/simple;
	bh=plnA5GPYRADuDvOFCrwy5MjhmaBZB11lrvEEaNu+2hE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GMAE5nROHmEqeSKxoidyjSdXxDv5G8RVn6bninB3MeS7IylwwWVks90NIpYxU3DJeycGeivfNsLAyerKGLTa+Hud3ObDhnbxwiFyX3kUrr06UapontZi7EumlsugZomU8NK84+WfV7cBprMHpcLU3tHAmv7cc6fcZGlmtJiDZjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0KZOhxci; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0KZOhxci"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748e6457567so1071353b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 15:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753915485; x=1754520285; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ECWzv5e2xsuSDiY8UbhBmnQ0CYKWUYp4TIAX7WJgUDc=;
        b=0KZOhxci72IQpNSORwnMLFlj9QQseYdcjTfwhA0WG2w2J8xpQZH2HoJ5G2cAHlvyqH
         NfZseulRFpDMJndHom6ZZLf2Xe5uX/X7AhgMFzZvIZatO7Ug7KBVrjtPOwLrh7kLJn+m
         tcwepOL0WNcyO/RGjJ9V8QPUZUDTFNh49pFN/41HYPhZpcKaUXuefInK74FrKvUt+Nzp
         +mvJBAZ+HwEX8Io/M+4PJf8ZOt09J/G9WVCs5uIlsli/2K+UAhIp6d8S8qQIl67bLYcV
         7tsXBwH0nDiT17WsetB+TQCrDEIDBLgpSqxASftXm0EtiaKXWtcSyaEsAaXLsM3TaOyX
         9q4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753915485; x=1754520285;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECWzv5e2xsuSDiY8UbhBmnQ0CYKWUYp4TIAX7WJgUDc=;
        b=KsDRXBDpotMN+Cq1Skzw8sMq3r7wJ3vY8L1WxkItCR9+VrOQy5N/G5RpSILokIKvOO
         elRlbxRDPGeqrEyoLMDhZajd/B5XxWs88jGJIYijyF8m4FSWWeZ+nJbjDJ9KBdv0uaWl
         FRDTs3RPxwfARd6KzOpmaZDnbRy/oiRKET+9YM8X4gvtb5DIY0eqSCKUVKkPN2eMmxd5
         x84w8Vb0ShmyzX+zTtxFu7k8sszac/Fk1RtiCdfzhR9gpZly1bH+bqkkFt5AxyGvc4aI
         yCZH5HzhyDUFYCx+2078LygE/EWnYqMVhcFWAJsX8l9pz1jL+Bc5CDeKR/w8YE8v+tOy
         Wh5w==
X-Forwarded-Encrypted: i=1; AJvYcCUp0g55rLYN3DLEymlnIllyJ/D8vJ3iOR80ETaPy0pYHuwEWIrK+YRCxuS6fypqwLmsswmqDz0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/OBut70HFLoncIQbKvLCObObteO9TH4Pn+EtVvsbYRbOzWVzF
	0tRt4WNz4gRIW+hyZORr70HHgAjpqv49+Bu++jahCp9zzvo/9lZjFie+TFlc6TRDyybD+LIqr2B
	5UQP2rLR26VNgpKMgRFX8rcDdzg==
X-Google-Smtp-Source: AGHT+IG2jrN7LcvgIWrJ4pHg8D4X2boCwV7dmSEgcVYsZ4qFvdN8Q5fmxfreX5UVqZROCmx2pQYYvC5DyR2A5cxeKg==
X-Received: from pfoo1.prod.google.com ([2002:a05:6a00:1a01:b0:746:21fd:3f7a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:47c7:b0:23d:c7aa:a6f0 with SMTP id adf61e73a8af0-23dc7aaa79dmr5184186637.22.1753915485016;
 Wed, 30 Jul 2025 15:44:45 -0700 (PDT)
Date: Wed, 30 Jul 2025 15:44:43 -0700
In-Reply-To: <diqzwm7pjrbf.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <diqzwm7pjrbf.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <diqztt2tjo2s.fsf@ackerleytng-ctop.c.googlers.com>
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

Ackerley Tng <ackerleytng@google.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>> Paolo,
>>
>> The arm64 patches have been Reviewed-by Marc, and AFAICT the x86 side of
>> things is a go.  Barring a screwup on my end, this just needs your approval.
>>
>> Assuming everything looks good, it'd be helpful to get this into kvm/next
>> shortly after rc1.  The x86 Kconfig changes in particular create semantic
>> conflicts with in-flight series.
>>
>>
>> Add support for host userspace mapping of guest_memfd-backed memory for VM
>> types that do NOT use support KVM_MEMORY_ATTRIBUTE_PRIVATE (which isn't
>> precisely the same thing as CoCo VMs, since x86's SEV-MEM and SEV-ES have
>> no way to detect private vs. shared).
>>
>> mmap() support paves the way for several evolving KVM use cases:
>>
>>  * Allows VMMs like Firecracker to run guests entirely backed by
>>    guest_memfd [1]. This provides a unified memory management model for
>>    both confidential and non-confidential guests, simplifying VMM design.
>>
>>  * Enhanced Security via direct map removal: When combined with Patrick's
>>    series for direct map removal [2], this provides additional hardening
>>    against Spectre-like transient execution attacks by eliminating the
>>    need for host kernel direct maps of guest memory.
>>
>>  * Lays the groundwork for *restricted* mmap() support for guest_memfd-backed
>>    memory on CoCo platforms [3] that permit in-place
>>    sharing of guest memory with the host.
>>
>> Based on kvm/queue.
>>
>> [1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
>> [2] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk
>> [3] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com
>>
>> [...snip...]
>
> With this version, when guest_memfd memory is mmap-ed() and faulted to
> userspace, when there's a memory failure, the process does not get a
> SIGBUS. Specifically, this selftest fails with "MADV_HWPOISON should
> have triggered SIGBUS."
>
> diff --git i/tools/testing/selftests/kvm/guest_memfd_test.c w/tools/testing/selftests/kvm/guest_memfd_test.c
> index b86bf89a71e04..70ef75a23bb60 100644
> --- i/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ w/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -70,6 +70,10 @@ static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
>  
>  	ret = munmap(mem, total_size);
>  	TEST_ASSERT(!ret, "munmap() should succeed.");
> +
> +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +			total_size);
> +	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
>  }
>  
>  static sigjmp_buf jmpbuf;
> @@ -104,6 +108,47 @@ static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
>  
>  	ret = munmap(mem, map_size);
>  	TEST_ASSERT(!ret, "munmap() should succeed.");
> +
> +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +			total_size);
> +	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
> +}
> +
> +static void test_memory_failure(int fd, size_t page_size, size_t total_size)
> +{
> +	struct sigaction sa_old, sa_new = {
> +		.sa_handler = fault_sigbus_handler,
> +	};
> +	void *memory_failure_addr;
> +	char *mem;
> +	int ret;
> +
> +	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
> +
> +	memset(mem, 0xaa, page_size);
> +

My bad. If the above was changed from page_size to total_size, the page
would have been faulted in, and then we get a SIGBUS.

> +	memory_failure_addr = mem + page_size;
> +	sigaction(SIGBUS, &sa_new, &sa_old);
> +	if (sigsetjmp(jmpbuf, 1) == 0) {
> +		madvise(memory_failure_addr, page_size, MADV_HWPOISON);
> +		TEST_ASSERT(false, "MADV_HWPOISON should have triggered SIGBUS.");
> +	}
> +	sigaction(SIGBUS, &sa_old, NULL);
> +
> +	ret = munmap(mem, total_size);
> +	TEST_ASSERT(!ret, "munmap() should succeed.");
> +
> +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +			total_size);
> +	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
>  }
>  
>  static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
> @@ -286,6 +331,7 @@ static void test_guest_memfd(unsigned long vm_type)
>  	if (flags & GUEST_MEMFD_FLAG_MMAP) {
>  		test_mmap_supported(fd, page_size, total_size);
>  		test_fault_overflow(fd, page_size, total_size);
> +		test_memory_failure(fd, page_size, total_size);
>  	} else {
>  		test_mmap_not_supported(fd, page_size, total_size);
>  	}
>
> Is this by design or should some new memory_failure handling be added?

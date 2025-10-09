Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F592257448
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 23:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760051328; cv=none; b=UgJzyu3Kc5odm0VoAMnxdzv/pk5GGH/m52TKkBdOALZRwAc8vSS+FDKDDEMOrE3sI5E9x5MFccuNoTyWcE//4N6lvLbSVdtEmdGGtVXutQI3H2WTkJaz/0KF2ovzwe0hv/OeJIoZ6Tao9ja77JK6Mk6ePYRKD8yzmJPfB9XQ7mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760051328; c=relaxed/simple;
	bh=mO3BfBl7Y/2I52TbjPHtPsUEdKOX2+l8+hnFuUeuyKo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GnbBzDXSYlw0KTjjgiYpIh1MFelKZA33byiZh5kpNBQu+arDYM8BFqq8hL6efox6fQbYM8XFMmxQTuUqwQR2rc96M/bM+aocTqh5NrcMHys0/DymOWA7XB7i8LauVDQRboYFJ6jw+glNWV2ZQ0hPdmmTOuOXVQC03ZbqyypasSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZkW1snM+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZkW1snM+"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-334b0876195so3632618a91.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 16:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760051326; x=1760656126; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rDpIaffmoR6Qy88AeMwNPxO5iOtC8dDi++B0iTvo01A=;
        b=ZkW1snM+0JVBPCynnbVWd8HDVLzIta5LPFQy8B1sM1ZDXUBFK1QsasnFBSkM55rHYr
         Xnys91ykovkVN+bR4nNU5TDvBfLzltHvCq7E7aquNFROFSPH3Z8QQiuoLb1gllFJmrBh
         /TkobwdfghCS9SJhFoCEifkJZkdzavQqsMipFaTTIzVIwtUxub+yTsShXDLRU9GN30aY
         pIy1CL4S+di6g3jeoKXKlS+0G99ORVAlBGFT8ix8W2RDyEU1ET0hHm9flr0t2Fb9TRxU
         0fEuyNThm8PyOxZc5t7dv/riu8XuuDvCPrZ69ZHUl7QWO0cwCuV9PUZyLWqL0GCdLv+o
         jIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760051326; x=1760656126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rDpIaffmoR6Qy88AeMwNPxO5iOtC8dDi++B0iTvo01A=;
        b=aO9lQCJ9AcMTTK/t6+GcjzC8tofCmsf4X5BUOSytZBF51Fs3gBljyYaIkPyegDEQjq
         2S04CmDDKVTcqWA5BanLMuMTeemeWm15ttiHJT/4aPyo5rbK8F+1Bqno84CvckRd7xmW
         PoBhrC2EThvAzJyailp0TeCebqvminYS32Oc9AvK2E1UtN/b/cKn3tD0IRWUE9140svI
         29HMtIOC2Hs3GqpCFoUWoxhoPvqyHBsyI/0ZYJj0HJsceadY4731JxENie9AePr7+oqh
         Aq19Z836dzO42H3YINqdYPXgsBHwR9GvG1CoQOzdgzYSKLKvzV20SnMPp7UZQyETa2v5
         +8nA==
X-Forwarded-Encrypted: i=1; AJvYcCWGA0FLO9xlEusBwgo7VxbGGNSb0zjaXZdTJL+S1Blfa/gX9zG2mb6msOO3fKFB5JSv6e/aqXA=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywr9DWpKmHCqMd/z+Q4t6RLofHGnBpYhT9R7iCdNwufTJ6zoX6i
	XR5JIksVKj6UjqxtCVCjvg0XtJrzaW2dBqhY0UfFZTOeE5DcLSSiY4mKIjoo5bSfb6P73LDlZ9Q
	vXYdXNW9Z4Jrvdj0+XoUYMy1oLQ==
X-Google-Smtp-Source: AGHT+IEKbmOpgQyGpF8iZG/gJeSzfxpKObXTtqbwqaHzaJgPnDoFIt/+KkqyzPgCgGNzWKTNkqyAjVnIwO8aJ2WY7Q==
X-Received: from pjca12.prod.google.com ([2002:a17:90b:5b8c:b0:32b:35fb:187f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d8b:b0:329:e703:d00b with SMTP id 98e67ed59e1d1-33b51386449mr12422922a91.19.1760051326203;
 Thu, 09 Oct 2025 16:08:46 -0700 (PDT)
Date: Thu, 09 Oct 2025 16:08:44 -0700
In-Reply-To: <20251007221420.344669-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-12-seanjc@google.com>
Message-ID: <diqzcy6vhdvn.fsf@google.com>
Subject: Re: [PATCH v12 11/12] KVM: selftests: Add guest_memfd tests for mmap
 and NUMA policy support
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> From: Shivank Garg <shivankg@amd.com>
>
> Add tests for NUMA memory policy binding and NUMA aware allocation in
> guest_memfd. This extends the existing selftests by adding proper
> validation for:
>   - KVM GMEM set_policy and get_policy() vm_ops functionality using
>     mbind() and get_mempolicy()
>   - NUMA policy application before and after memory allocation
>
> Run the NUMA mbind() test with and without INIT_SHARED, as KVM should allow
> doing mbind(), madvise(), etc. on guest-private memory, e.g. so that
> userspace can set NUMA policy for CoCo VMs.
>
> Run the NUMA allocation test only for INIT_SHARED, i.e. if the host can't
> fault-in memory (via direct access, madvise(), etc.) as move_pages()
> returns -ENOENT if the page hasn't been faulted in (walks the host page
> tables to find the associated folio)
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> [sean: don't skip entire test when running on non-NUMA system, test mbind()
>        with private memory, provide more info in assert messages]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 98 +++++++++++++++++++
>  1 file changed, 98 insertions(+)
>
> 
> [...snip...]
> 
> +static void test_numa_allocation(int fd, size_t total_size)
> +{
> +	unsigned long node0_mask = 1;  /* Node 0 */
> +	unsigned long node1_mask = 2;  /* Node 1 */
> +	unsigned long maxnode = 8;
> +	void *pages[4];
> +	int status[4];
> +	char *mem;
> +	int i;
> +
> +	if (!is_multi_numa_node_system())
> +		return;
> +
> +	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +
> +	for (i = 0; i < 4; i++)
> +		pages[i] = (char *)mem + page_size * i;
> +
> +	/* Set NUMA policy after allocation */
> +	memset(mem, 0xaa, page_size);
> +	kvm_mbind(pages[0], page_size, MPOL_BIND, &node0_mask, maxnode, 0);
> +	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, page_size);
> +
> +	/* Set NUMA policy before allocation */
> +	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
> +	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
> +	memset(mem, 0xaa, total_size);
> +
> +	/* Validate if pages are allocated on specified NUMA nodes */
> +	kvm_move_pages(0, 4, pages, NULL, status, 0);
> +	TEST_ASSERT(status[0] == 1, "Expected page 0 on node 1, got it on node %d", status[0]);
> +	TEST_ASSERT(status[1] == 1, "Expected page 1 on node 1, got it on node %d", status[1]);
> +	TEST_ASSERT(status[2] == 0, "Expected page 2 on node 0, got it on node %d", status[2]);
> +	TEST_ASSERT(status[3] == 0, "Expected page 3 on node 0, got it on node %d", status[3]);
> +
> +	/* Punch hole for all pages */
> +	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, total_size);
> +
> +	/* Change NUMA policy nodes and reallocate */
> +	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
> +	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
> +	memset(mem, 0xaa, total_size);
> +
> +	kvm_move_pages(0, 4, pages, NULL, status, 0);
> +	TEST_ASSERT(status[0] == 0, "Expected page 0 on node 0, got it on node %d", status[0]);
> +	TEST_ASSERT(status[1] == 0, "Expected page 1 on node 0, got it on node %d", status[1]);
> +	TEST_ASSERT(status[2] == 1, "Expected page 2 on node 1, got it on node %d", status[2]);
> +	TEST_ASSERT(status[3] == 1, "Expected page 3 on node 1, got it on node %d", status[3]);
> +

Related to my comment on patch 5: might a test for guest_memfd with
regard to the memory spread page cache feature provided by the cpuset
subsystem be missing?

Perhaps we need tests for

1. Test that the allocation matches current's mempolicy, with no
   mempolicy defined for specific indices.
2. Test that during allocation, current's mempolicy can be overridden with
   a mempolicy defined for specific indices.
3. Test that during allocation, current's mempolicy and the effect of
   cpuset config can be overridden with a mempolicy defined for specific
   indices.
4. Test that during allocation, without defining a mempolicy for given
   index, current's mempolicy is overridden by the effect of cpuset
   config

I believe test 4, before patch 5, will show that guest_memfd respects
cpuset config, but after patch 5, will show that guest_memfd no longer
allows cpuset config to override current's mempolicy.

> +	kvm_munmap(mem, total_size);
> +}
> +
>  static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
>  {
>  	const char val = 0xaa;
> @@ -273,11 +369,13 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>  		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
>  			gmem_test(mmap_supported, vm, flags);
>  			gmem_test(fault_overflow, vm, flags);
> +			gmem_test(numa_allocation, vm, flags);
>  		} else {
>  			gmem_test(fault_private, vm, flags);
>  		}
>  
>  		gmem_test(mmap_cow, vm, flags);
> +		gmem_test(mbind, vm, flags);
>  	} else {
>  		gmem_test(mmap_not_supported, vm, flags);
>  	}
> -- 
> 2.51.0.710.ga91ca5db03-goog

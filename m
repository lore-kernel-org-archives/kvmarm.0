Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD034A64D4
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999675; cv=none; b=g6+wDVxzzn+uOvzJYwba/X6G+qaGV1/FoN0oYi4kPSv08KK1uWU9T2bwQ3L9tCb2iXG5fyiUYNj7iwFjyFiVJvmLT/fyzRNa7mzd1dfvBS0xy2P1h5WaReA4HfZ/IN935igWyfS7a74B1NSpD3Iu2wRvYVoK1G8BOYGgvB+V57E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999675; c=relaxed/simple;
	bh=xL9CGxkzYt/J3kJ3zE8BdkE7Ib5J15yIahjNrznpznE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hf/pj99xgdcXz6Wl2tvtcuS7vm1TaFAQ+KlJH2WY6jFoxGBk3cj/ZMHWZJsSS0ulAv+osWMZNzCsCncMt06NXDpecyS5jdUg7DLhvpee7fBijnpV30LuNNgK0YCqyQLxWXkcp/3WvoVh8s7tP4NkdTY7bOEHPrwkR+DkwC/+efU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u0nvTSfu; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u0nvTSfu"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4922b7c31so3007934a12.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789999673; x=1790604473; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GOYAH6R+ATW22r2VK1upIBbGsmi1bjog4cG/z3wfeFY=;
        b=u0nvTSfuSo/gLtA/0o0CHo2lJAOslV70OP7SnGJgf5XxbfTPGKRzRSxu+5hKstif+d
         A4h75P1o6014OW+SwvlOBVDQY4Y2s79p4DpOck/qQxqTLzUp0BOT/ZEeFXaNjvQk/s4L
         p4pmHxjGrhwfb8lS1PlBut+cWphppjvnf/CU8NdvnBgxQ/OUKvkmgpsbTt7LxXpdKryQ
         3qMKyMhzuygj/ntYdNDEvOtm2nalAe8rT4xPQ5WTEYc9eZ0E8DcBdJGDvXkLzsKI4AmY
         5ckSU65E+A/Igy+k3rHP1iRb3IAQ4Hfi0niVB51LR9m0BJgvnGOy1QCRCre3eRDRuzBE
         mDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789999673; x=1790604473;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GOYAH6R+ATW22r2VK1upIBbGsmi1bjog4cG/z3wfeFY=;
        b=KXd1XoBBzE4/bEl+7mTULNbfYACflgUhJ3dWfF6DSWmoRewfc2LvzstS9Ae7bbFBgn
         rn1H018wCQpcrT03YP6z4fZB7H1PoJXv9SZ3dA99Aj98xfGPprwwOJQerX4D6Zlskuxw
         CttFtt3WqTdTHSxhIGStsnD719F2DfCKJEaCxPmoQYrYUwBgWMKnEuSw+VXzawfxicU7
         tHwfAiPIAMqGp+5fkvHrt6MgwEsmPBUDudq1qZ6gCLjbKJfsPQlR14Rv0D6pNCXwtG/C
         LJ9SGUPpR67MJaqDkdDQuMcvqDfqfepZV8bdpgHmB3RV+39A0AeIna1WINPI/UpbNR5K
         Kxjw==
X-Forwarded-Encrypted: i=1; AKwUvBx9g+i7yPnmdU8+KD5j5oyZM5Lk9Zb9Tu5M8DMlLNF3izrpQHHhNowJxmpml8xuKbhGwW8U5oI=@lists.linux.dev
X-Gm-Message-State: AFuF++mtXcJ+D26oU6npUC+6oi+/ge3FDVVdYr00GoLdWsCG7+DA7qwf
	HVKrdr5pw53hkFRRj2jVY1Ho7KK+JRdP11wUhbLkvdWGCDJnCAepRI83rUNF9Vtus6L9W+aweus
	319zblw==
X-Received: from pgbfu4.prod.google.com ([2002:a05:6a02:4a84:b0:cc5:1d94:8e5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4688:b0:3dd:a196:3094
 with SMTP id adf61e73a8af0-3dda1963396mr11496717637.68.1789999672947; Mon, 21
 Sep 2026 07:07:52 -0700 (PDT)
Date: Mon, 21 Sep 2026 07:05:44 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <178999944766.761024.7401957242293009313.b4-ty@google.com>
Subject: Re: [PATCH v2 00/20] KVM: selftests: PPC pre-enabling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 02 Sep 2026 09:41:03 -0700, Sean Christopherson wrote:
> This is a big pile of cleanups and refactoring to prepare for PPC support in
> KVM selftests.  PPC has paging modes that require multi-page page tables, and
> those page tables need to be naturally aligned.  The original proposal was to
> plumb in an @align param to the page allocators[*], but I didn't love the idea
> of adding another rarely used param to the allocators.
> 
> v2:
>  - Collect tags. [Itaru, Bibo]
>  - Use 0x180000 as the min GPA for page table pages on LoongArch, instead of
>    changing every other arch to use 0x200000. [Sashiko, Bibo]
>  - Opportunistically move the vGIC LPI stress test's global "gpa_base" variable
>    into setup_memslot(). [Sashiko]
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[01/20] KVM: selftests: Use MEM_REGION_PT memslot instead of '0' for s390 regions/segments
        https://github.com/kvm-x86/linux/commit/73ac07325851
[02/20] KVM: selftests: Use the common minimum GPA for page tables on LoongArch
        https://github.com/kvm-x86/linux/commit/9886413e0466
[03/20] KVM: selftests: Use vm_alloc_page_table() to allocate LoongArch page tables
        https://github.com/kvm-x86/linux/commit/befd94805906
[04/20] KVM: selftests: Rename "num" param to "nr_pages" for physical page allocators
        https://github.com/kvm-x86/linux/commit/d220e33516fa
[05/20] KVM: selftests: Use goto instead of do-while to retry finding unused physical pages
        https://github.com/kvm-x86/linux/commit/2c0555c51e7c
[06/20] KVM: selftests: Extend page allocator to support naturally aligned allocations
        https://github.com/kvm-x86/linux/commit/2429ecf7ccd5
[07/20] KVM: selftests: Make the single-page allocator APIs static inline
        https://github.com/kvm-x86/linux/commit/54e83f729385
[08/20] KVM: selftests: Use the innermost page allocator API in the memslot perf test
        https://github.com/kvm-x86/linux/commit/b8d9e6ec747a
[09/20] KVM: selftests: Use the innermost page allocator API in s390's IRQ routing test
        https://github.com/kvm-x86/linux/commit/9c0061d2e7cd
[10/20] KVM: selftests: Add a wrapper API to allocate multiple page table pages
        https://github.com/kvm-x86/linux/commit/7f477ba0878e
[11/20] KVM: selftests: Initialize vm->memslots[] with invalid memslots during creation
        https://github.com/kvm-x86/linux/commit/9e4e2281df12
[12/20] KVM: selftests: Add APIs to override memory region types with custom memslots
        https://github.com/kvm-x86/linux/commit/d69b3e714265
[13/20] KVM: selftests: Add TEST_EXTRA memory region type for "special" memslots
        https://github.com/kvm-x86/linux/commit/9f035aca8765
[14/20] KVM: selftests: Use TEST_EXTRA region in arm64's vGIC LPI stress test
        https://github.com/kvm-x86/linux/commit/5d81014d3868
[15/20] KVM: selftests: Use TEST_EXTRA region in x86's smaller MAXPHYADDR test
        https://github.com/kvm-x86/linux/commit/00c37bfc5b4e
[16/20] KVM: selftests: Use TEST_EXTRA region in set memory region test
        https://github.com/kvm-x86/linux/commit/5ed16822bc45
[17/20] KVM: selftests: Take the memory region type, not memslot, in page allocators
        https://github.com/kvm-x86/linux/commit/36a062568ea8
[18/20] KVM: selftests: Use TEST_ASSERT(), not assert(), in vm_get_mem_region()
        https://github.com/kvm-x86/linux/commit/1856064afc9d
[19/20] KVM: selftests: Automatically pick min_gpa for allocations based on region type
        https://github.com/kvm-x86/linux/commit/6c28a0d7cf12
[20/20] KVM: selftests: Add arch hook to force page tables to be naturally aligned
        https://github.com/kvm-x86/linux/commit/1e59e5a3bdbe

--
https://github.com/kvm-x86/linux/tree/next

Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DED97F7F9
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 15:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707320803; cv=none; b=FZeaj/7lsvNFvaQRy2srCcfBIOtVXe5UC7WOSCbpEr05RbQLjgTxO0U9e6EPLfTtpV9ykrFxGcTk0sbXqXZf7IBeiNxUJvaXY3xJcl3ZkWtS46ROp5Jfq0pSuF9P7WmsWlvWcAQ4DY0KtnWUb13Sj9gMQnw2K5VUcL/P4eWOOd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707320803; c=relaxed/simple;
	bh=K53ZZvCsrolT8X395l++Yn5v68FJcDCJp22aYenng28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A/IeJKg1Sy7Bq4ng+KdN8/kAoTkyqynWIR/K7fw4ug6cb+iWYcNzBFqa/U8wBLmZL/ftaMvXXudY/xV1/aGexE7YV1YX8FNa4AYfQZqX3c1Ioy95vpRBu8k7f0JzAkwmj0oQPXac9Gj7t8bJ+A5xZ2lhy4hZL+jtvu/fFJig4PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cVMMqpPn; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cVMMqpPn"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5ce63e72bc3so642264a12.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 07:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707320801; x=1707925601; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K1vUU5GtV/HreAMSegqNxbtSuUlLZ3yEj2TqAzmQFAQ=;
        b=cVMMqpPnZOjaQz4wpk76dmeu0MIZPPxzjEIYRMMv6uAWDvV9PCY0uOVMiJgZBLoXCM
         4JPuocJbPyeJH7H23JpXbIPOKj1tQ0AnFOBUu4UERHpnG/hy4JGrqBmWJWsJacliZ74B
         Ge34OznD/Rc7IESr7zLFemdCwG9TUdGkFWXOuVjSRzki0nZpqmgsIyS2zydXD4hThPvk
         nJGTPh8Ly8013wB0W+F5dHoc3k8K2nc8ZKky6bPg2xJP93FeYpVIQ/GjJjczPFqUSMT1
         pg9wqml2LJjwyPxA3+7465gnZyJFWX/ap1PtqCZLgUuipcxw4dAskp6Dej4kav6O5GdW
         E8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707320801; x=1707925601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K1vUU5GtV/HreAMSegqNxbtSuUlLZ3yEj2TqAzmQFAQ=;
        b=neQVF0xmQt1FM9raSfddPK1/0qdNoabreHnUH2R6DKrcVUQnL+5tFqqfmn5PVczVur
         e7+1JvFNa6bHAU6o9Ps0BymKaEdfsEgJ8bRBXDhLnBZJ3FfyN93NJJCffDppywv+tjn3
         D5IZn8rRbvUVo/nYPVkI+y6RDF80P5LzNcgl3VAQvCJA49846f3hj3OSfZt9NE0WWwC7
         70VfsHA9bUlvzUNM+0d223QANA1cg5wIYtVWBQdwXvTGUFFY0KMUYnYqGYSnAXUEwZDL
         kjpHzznklxscKW0oTnZWmZKs1KaqCWWWppIQirxGu6Wg24D+qzgFmEZ8ZKHB8pD1AXGj
         PLtw==
X-Gm-Message-State: AOJu0Yx7JRbZ8HW4pK1+9gsIn8MDeh1/x7z0nPchmBCxrmSjHs2pB/RP
	FXrsu+UeBwO3gqBn2mGfFTDkWwKmud1IWXaAjLtn61ovuuV2XqaEONtzFu6LFdK+ehUBoidsDL5
	68w==
X-Google-Smtp-Source: AGHT+IG7frfAntHd6YSunGAL3Hn4axWdZ7/qTDuWTl4579rwZ2kTb+Iw2ltwdxLQXj5I7ZHZyi9fLGwQvM8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2b4f:b0:296:3a3a:92ae with SMTP id
 rr15-20020a17090b2b4f00b002963a3a92aemr8912pjb.4.1707320801606; Wed, 07 Feb
 2024 07:46:41 -0800 (PST)
Date: Wed, 7 Feb 2024 07:46:40 -0800
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
Message-ID: <ZcOl4PTbobZTsuNW@google.com>
Subject: Re: [PATCH v6 00/14] Improve KVM + userfaultfd performance via
 KVM_MEMORY_FAULT_EXITs on stage-2 faults
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 09, 2023, Anish Moorthy wrote:
> Base Commit
> ~~~~~~~~~~~
> This series is based off of kvm/next (45b890f7689e) with v14 of the
> guest_memfd series applied, with some fixes on top [3].

Please use `--base`.  I have gotten spoiled by git appending the object ID at the
bottom, and get annoyed every time I have to go spelunking for the base :-)

Also, in the future, when posting a series that has multiple dependencies, it is
*very* helpful to reviewers and maintainers to provide a full branch somewhere,
e.g. on github, gitlab, etc.  That way someone that wants to actually test things
doesn't need to hunt down and splice together a bunch of different assets.

From Documentation/process/maintainer-kvm-x86.rst:

Git Base
~~~~~~~~
If you are using git version 2.9.0 or later (Googlers, this is all of you!),
use ``git format-patch`` with the ``--base`` flag to automatically include the
base tree information in the generated patches.

Note, ``--base=auto`` works as expected if and only if a branch's upstream is
set to the base topic branch, e.g. it will do the wrong thing if your upstream
is set to your personal repository for backup purposes.  An alternative "auto"
solution is to derive the names of your development branches based on their
KVM x86 topic, and feed that into ``--base``.  E.g. ``x86/pmu/my_branch_name``,
and then write a small wrapper to extract ``pmu`` from the current branch name
to yield ``--base=x/pmu``, where ``x`` is whatever name your repository uses to
track the KVM x86 remote.

> Anish Moorthy (14):
>   KVM: Documentation: Clarify meaning of hva_to_pfn()'s 'atomic'
>     parameter
>   KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
>   KVM: Simplify error handling in __gfn_to_pfn_memslot()
>   KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to
>     userspace
>   KVM: Try using fast GUP to resolve read faults
>   KVM: Add memslot flag to let userspace force an exit on missing hva
>     mappings
>   KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and annotate EFAULTs from
>     stage-2 fault handler
>   KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
>   KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and annotate an EFAULT from
>     stage-2 fault-handler
>   KVM: selftests: Report per-vcpu demand paging rate from demand paging
>     test
>   KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
>     paging test
>   KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
>     signal errors via TEST_ASSERT
>   KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
>   KVM: selftests: Handle memory fault exits in demand_paging_test
> 
>  Documentation/virt/kvm/api.rst                |  33 +-
>  arch/arm64/kvm/Kconfig                        |   1 +
>  arch/arm64/kvm/arm.c                          |   1 +
>  arch/arm64/kvm/mmu.c                          |   7 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c           |   2 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c        |   2 +-
>  arch/x86/kvm/Kconfig                          |   1 +
>  arch/x86/kvm/mmu/mmu.c                        |   8 +-
>  include/linux/kvm_host.h                      |  21 +-
>  include/uapi/linux/kvm.h                      |   5 +
>  .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
>  .../selftests/kvm/access_tracking_perf_test.c |   2 +-
>  .../selftests/kvm/demand_paging_test.c        | 295 ++++++++++++++----
>  .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
>  .../testing/selftests/kvm/include/memstress.h |   2 +-
>  .../selftests/kvm/include/userfaultfd_util.h  |  17 +-
>  tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
>  .../selftests/kvm/lib/userfaultfd_util.c      | 159 ++++++----
>  .../kvm/memslot_modification_stress_test.c    |   2 +-
>  .../x86_64/dirty_log_page_splitting_test.c    |   2 +-
>  virt/kvm/Kconfig                              |   3 +
>  virt/kvm/kvm_main.c                           |  46 ++-
>  22 files changed, 444 insertions(+), 175 deletions(-)

A few nits throughout, but this is looking good for 6.9.

Oliver / Marc,

Any objection to taking this through kvm-x86? (when you feel it's ready, obviously)
My plan is to put it in a dedicated topic branch, with a massaged cover letter as
the tag used for the pull request so that we can capture the motivation/benefits.

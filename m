Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CC413D503
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654960; cv=none; b=IVcuFLMMimcnapk/NvEsbzwiHP4icOaEOguTYAD0BegvflF5OcLdewiX3tX9/s0kpXMjgfaUyMy10cJwXejUjuj3QD0eSXlb2uARCeRKtJNBEsaOowD6URejmh1+CiMMaILe1p7BFRdzt1RYLXYGUd0U52UYquuar+A54VPqsl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654960; c=relaxed/simple;
	bh=+d7MHnXvG9ckN0TU9hoPWKFT9fXHe0SQp2A+udSuB7E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tJSODwn00J9g6gzZ44JzLq/H3YPhcwaxOZKEg8PA5LdvWqzCpPsA+NKHmGvX7fDz/DhyA23F0EW+MlWUfc8kC8Qv6RkMYgC2woMaYksd/PN9mUy2mnPirpYKuxlTEO7ljebfP1YA57sBdgE5bZ1mBFw+y9JqSIbrSD7HoWLGJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BvCCPa93; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BvCCPa93"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-64b9800b377so17459017b3.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654958; x=1721259758; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i4DifozVZ/fDrEjgZQtvTFkudk1JzJtOjKWrKpGAYuU=;
        b=BvCCPa93mDhpnkVSPkMhHgM9VwL6pR4KuQ0U2MLHyxlVQLkiNDxHWKfEqcHmb11L0A
         AsAvobXLAkCxkN1dEjhklVTl3sOzIt8NhcdKVp+njFi9vCG//fCZCOJ6CJM7ZdBJFf09
         3Bcc3XQE4oiyRqK0kFmtusdCMtp59jYB8PigjurGxT6ZY1iXJwANCOhFPzC318YZXeGo
         gyrsWUDCakMdm/5HahArB/oQ/4aUEi+Q5ybRNvgRXDtoVUW5Q2ti3ehLoxJ6IkDzGXqr
         f3FuoPoTwXyDouNzmrY7leq1AMj/ZWS10tHqCq1IsnjzGIhqzQokAX25rCA2zqa0z3aT
         M0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654958; x=1721259758;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i4DifozVZ/fDrEjgZQtvTFkudk1JzJtOjKWrKpGAYuU=;
        b=L3Z3qnfc/k7TRZzsAo8oKIbugY83NT0ADyRG2L2wW0KliU+9bFtkiq0wWYm1hn+//x
         2kkUvMIM70Vbvx0neK+8SfF9KJAciLJlVKtfJv/ebWrTb7WHVwHTzL0GK2mmaqN40X3z
         gKVQ0HbdQzvX0xxfIdZ7q0nhxDb/xh7wWnNm9U6RuNz9WWaSI0yoOoPXMtby7kaWjNEh
         WAExmWNioyWFoSIvx842WNbSzChzQW0Mtrv69q8pyD2oNe570Jh/7fab7hJ6bKfLS4Ar
         0/BULmQYqGjuT2tUZmQNiN+ESHSnO+Lh7kkVpdjNiEOJ7z3gJ9xk9beCijKrE7dttr5r
         0ClA==
X-Forwarded-Encrypted: i=1; AJvYcCXwBhYpTzrMt1i0r52eJ0ZK77PidnF444Y8qoSzbtyMg1RIp0H524KOaXr1jFwjVNeu3KGQeRstVYRBlmBYY5le8/kPZUG9
X-Gm-Message-State: AOJu0Yygedr+poN9QscqWVk5YjANnXecq8dQWwAH1R5TdfJPuk35y4Do
	nnJDv7sNPs1pVLmR1TF8r3+7tR7JNiEJXJacPeGjrFFH7f5yQc61axsUWoOF9XnNbtHJe5QJJ+u
	JQKIDVTKLCsZS5Ceuxw==
X-Google-Smtp-Source: AGHT+IGleZxYUt4mvQCru8lvqfwiOY5k61Gmu5l5Nxb9Gfvqk177LFIz9ZNpte5dLHg976OYyY0/0Rk5LPFmcxhb
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:32a6:b0:e03:61bb:6032 with
 SMTP id 3f1490d57ef6-e0577fa164amr19023276.1.1720654957517; Wed, 10 Jul 2024
 16:42:37 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:04 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-1-jthoughton@google.com>
Subject: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This patch series implements the KVM-based demand paging system that was
first introduced back in November[1] by David Matlack.

The working name for this new system is KVM Userfault, but that name is
very confusing so it will not be the final name.

Problem: post-copy with guest_memfd
===================================

Post-copy live migration makes it possible to migrate VMs from one host
to another no matter how fast they are writing to memory while keeping
the VM paused for a minimal amount of time. For post-copy to work, we
need:
 1. to be able to prevent KVM from being able to access particular pages
    of guest memory until we have populated it
 2. for userspace to know when KVM is trying to access a particular
    page.
 3. a way to allow the access to proceed.

Traditionally, post-copy live migration is implemented using
userfaultfd, which hooks into the main mm fault path. KVM hits this path
when it is doing HVA -> PFN translations (with GUP) or when it itself
attempts to access guest memory. Userfaultfd sends a page fault
notification to userspace, and KVM goes to sleep.

Userfaultfd works well, as it is not specific to KVM; everyone who
attempts to access guest memory will block the same way.

However, with guest_memfd, we do not use GUP to translate from GFN to
HPA (nor is there an intermediate HVA).

So userfaultfd in its current form cannot be used to support post-copy
live migration with guest_memfd-backed VMs.

Solution: hook into the gfn -> pfn translation
==============================================

The only way to implement post-copy with a non-KVM-specific
userfaultfd-like system would be to introduce the concept of a
file-userfault[2] to intercept faults on a guest_memfd.

Instead, we take the simpler approach of adding a KVM-specific API, and
we hook into the GFN -> HVA or GFN -> PFN translation steps (for
traditional memslots and for guest_memfd respectively).

I have intentionally added support for traditional memslots, as the
complexity that it adds is minimal, and it is useful for some VMMs, as
it can be used to fully implement post-copy live migration.

Implementation Details
======================

Let's break down how KVM implements each of the three core requirements
for implementing post-copy as laid out above:

--- Preventing access: KVM_MEMORY_ATTRIBUTE_USERFAULT ---

The most straightforward way to inform KVM of userfault-enabled pages is
to use a new memory attribute, say KVM_MEMORY_ATTRIBUTE_USERFAULT.

There is already infrastructure in place for modifying and checking
memory attributes. Using this interface is slightly challenging, as there
is no UAPI for setting/clearing particular attributes; we must set the
exact attributes we want.

The synchronization that is in place for updating memory attributes is
not suitable for post-copy live migration either, which will require
updating memory attributes (from userfault to no-userfault) very
frequently.

Another potential interface could be to use something akin to a dirty
bitmap, where a bitmap describes which pages within a memslot (or VM)
should trigger userfaults. This way, it is straightforward to make
updates to the userfault status of a page cheap.

When KVM Userfault is enabled, we need to be careful not to map a
userfault page in response to a fault on a non-userfault page. In this
RFC, I've taken the simplest approach: force new PTEs to be PAGE_SIZE.

--- Page fault notifications ---

For page faults generated by vCPUs running in guest mode, if the page
the vCPU is trying to access is a userfault-enabled page, we use
KVM_EXIT_MEMORY_FAULT with a new flag: KVM_MEMORY_EXIT_FLAG_USERFAULT.

For arm64, I believe this is actually all we need, provided we handle
steal_time properly.

For x86, where returning from deep within the instruction emulator (or
other non-trivial execution paths) is infeasible, being able to pause
execution while userspace fetches the page, just as userfaultfd would
do, is necessary. Let's call these "asynchronous userfaults."

A new ioctl, KVM_READ_USERFAULT, has been added to read asynchronous
userfaults, and an eventfd is used to signal that new faults are
available for reading.

Today, we busy-wait for a gfn to have userfault disabled. This will
change in the future.

--- Fault resolution ---

Resolving userfaults today is as simple as removing the USERFAULT memory
attribute on the faulting gfn. This will change if we do not end up
using memory attributes for KVM Userfault. Having a range-based wake-up
like userfaultfd (see UFFDIO_WAKE) might also be helpful for
performance.

Problems with this series
=========================
- This cannot be named KVM Userfault! Perhaps "KVM missing pages"?
- Memory attribute modification doesn't scale well.
- We busy-wait for pages to not be userfault-enabled.
- gfn_to_hva and gfn_to_pfn caches are not invalidated.
- Page tables are not collapsed when KVM Userfault is disabled.
- There is no self-test for asynchronous userfaults.
- Asynchronous page faults can be dropped if KVM_READ_USERFAULT fails.
- Supports only x86 and arm64.
- Probably many more!

Thanks!

[1]: https://lore.kernel.org/kvm/CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com/
[2]: https://lore.kernel.org/kvm/CADrL8HVwBjLpWDM9i9Co1puFWmJshZOKVu727fMPJUAbD+XX5g@mail.gmail.com/

James Houghton (18):
  KVM: Add KVM_USERFAULT build option
  KVM: Add KVM_CAP_USERFAULT and KVM_MEMORY_ATTRIBUTE_USERFAULT
  KVM: Put struct kvm pointer in memslot
  KVM: Fail __gfn_to_hva_many for userfault gfns.
  KVM: Add KVM_PFN_ERR_USERFAULT
  KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
  KVM: Provide attributes to kvm_arch_pre_set_memory_attributes
  KVM: x86: Add KVM Userfault support
  KVM: x86: Add vCPU fault fast-path for Userfault
  KVM: arm64: Add KVM Userfault support
  KVM: arm64: Add vCPU memory fault fast-path for Userfault
  KVM: arm64: Add userfault support for steal-time
  KVM: Add atomic parameter to __gfn_to_hva_many
  KVM: Add asynchronous userfaults, KVM_READ_USERFAULT
  KVM: guest_memfd: Add KVM Userfault support
  KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
  KVM: selftests: Add KVM Userfault mode to demand_paging_test
  KVM: selftests: Remove restriction in vm_set_memory_attributes

 Documentation/virt/kvm/api.rst                |  23 ++
 arch/arm64/include/asm/kvm_host.h             |   2 +-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   8 +-
 arch/arm64/kvm/mmu.c                          |  45 +++-
 arch/arm64/kvm/pvtime.c                       |  11 +-
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  67 +++++-
 arch/x86/kvm/mmu/mmu_internal.h               |   3 +-
 include/linux/kvm_host.h                      |  41 +++-
 include/uapi/linux/kvm.h                      |  13 ++
 .../selftests/kvm/demand_paging_test.c        |  46 +++-
 .../testing/selftests/kvm/include/kvm_util.h  |   7 -
 virt/kvm/Kconfig                              |   4 +
 virt/kvm/guest_memfd.c                        |  16 +-
 virt/kvm/kvm_main.c                           | 213 +++++++++++++++++-
 16 files changed, 457 insertions(+), 44 deletions(-)


base-commit: 02b0d3b9d4dd1ef76b3e8c63175f1ae9ff392313
-- 
2.45.2.993.g49e7a77208-goog


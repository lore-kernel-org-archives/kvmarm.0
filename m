Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE014699
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 19:58:37 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-355bdeba45bso119538767b3.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 12:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FAHgYJpfzcDpPf7VxOwSA+t+TQ+UPimMjnTVk0O2biE=;
        b=HggWik6kgJlAa6w/37YJ/TjcLVIvNxknEMP2tIvLgxhoi8cwLLSppPlybtsswRpWOi
         ncl+ngRMWra8+9qo3xYZyAvQVgItQSl85IqPjo/HZ5Wv9dV1ujiufVBQqxfyaI4Qwrrs
         te67M1xmQ+R54PXDfA0NbusOPUg7Yjff92cQ+1g6ZB3FERIjF3bW4nK9nBoMS8cenTU/
         FzmFWVXf8WfHEG1OECXmYl98+nkOT2YW7A8cTkBi1IU+B4NfbTDSrxKDd4J5R3suFsDs
         fc4kcrasjwMiHQvOUGSTVVdGr++M6uZICC8h/615I4ck6lkEkGiU33isWLReBomi7tZu
         jSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FAHgYJpfzcDpPf7VxOwSA+t+TQ+UPimMjnTVk0O2biE=;
        b=pvEaVjFY9tdKQqU+5wOKY9PJlqKbQ2e1iFP/dMnWyD7nHP4HC8ZAzn2F9Rvm4hOYGA
         zoCjehd256jIA1rs1dqz9n/Xpslk8Eb7G1EL01qDLfHcXIkWiOV6oMu0NE1v4xDRYfYJ
         tVrNWbV5s2GvU6FK1sLYa0tnSSUu6SoE67ExGwVeFEUjBK/semwzTtvDFplsTGjWy9O2
         dI0yAomLc1tH+s5go3oyPtcc1ARj7rUZoKIajZ/GSRTfPlvsB0gzBZj3GnJJPJrGmMfF
         oORLMdSNEuC9FiLtNwtB2UUz0qB04ayqLXbZ7wsZG/CotRi6covkYXr1YK+36DXa50U3
         4j3w==
X-Gm-Message-State: ACrzQf0EMEMY9boppJnT2FgreEnLNNVsrzNPyvDb5BfmUw5nAnhUI10U
	8ZucPyasYE652QHAP7VnspAkVdDZxHvqag==
X-Google-Smtp-Source: AMsMyM6epjx47gI8sy+GTFaC/SdmxDJEvB0L05XsJ31+lfOICN3GkPjRPNwQiCHsq2GvfuTDW6fhAqyG2OlApQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:9e0d:0:b0:355:85e8:d975 with SMTP id
 m13-20020a819e0d000000b0035585e8d975mr10534264ywj.61.1666036717029; Mon, 17
 Oct 2022 12:58:37 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-1-ricarkol@google.com>
Subject: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, seanjc@google.com, 
	alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221017195820.C9RYmGo7RMHx40lCmh35NwO6zEX8Mbm9panBHNyUNV4@z>

This series adds a new aarch64 selftest for testing stage 2 fault handling
for various combinations of guest accesses (e.g., write, S1PTW), backing
sources (e.g., anon), and types of faults (e.g., read on hugetlbfs with a
hole, write on a readonly memslot). Each test tries a different combination
and then checks that the access results in the right behavior (e.g., uffd
faults with the right address and write/read flag). Some interesting
combinations are:

- loading an instruction leads to a stage 1 page-table-walk that misses on
  stage 2 because the backing memslot for the page table it not in host
  memory (a hole was punched right there) and the fault is handled using
  userfaultfd.  The expected behavior is that this leads to a userfaultfd
  fault marked as a write. See commit c4ad98e4b72c ("KVM: arm64: Assume
  write fault on S1PTW permission fault on instruction fetch") for why
  that's a write.
- a cas (compare-and-swap) on a readonly memslot leads to a failed vcpu
  run.
- write-faulting on a memslot that's marked for userfaultfd handling and
  dirty logging should result in a uffd fault and having the respective bit
  set in the dirty log.

The first 8 commits of this series add library support. The first one adds
a new userfaultfd library. Commits 2-5 add some misc library changes that
will be used by the new test, like a library function to get the GPA of a
PTE.  Commits 6-8 breaks the implicit assumption that code and page tables
live in memslot memslots should allocators use. This is then used by the
new test to place the page tables in a specific memslot.  The last 5
commits add the new selftest, one type of test at a time. It first adds
core tests, then uffd, then dirty logging, then readonly memslots tests,
and finally combinations of the previous ones (like uffd and dirty logging
at the same time).

v9 -> v10: https://lore.kernel.org/kvmarm/20221011010628.1734342-1-ricarkol@google.com/
- collected r-b's from Andrew
- fixed indentation in several places (mainly alignment of params) [Sean]
- renamed args in uffd_setup [Sean]

v8 -> v9: https://lore.kernel.org/kvmarm/20220922031857.2588688-1-ricarkol@google.com/
- removed check before trying madvise(MADV_DONTNEED) on anon hugetlb. [Sean]
- renamed punch_hole_in_memslot() [Sean]
- changed the comment describing the accesses on "holes" [Sean]
- collectd r-b's from Sean

v7 -> v8: https://lore.kernel.org/kvmarm/20220920042551.3154283-1-ricarkol@google.com/
- applied Sean's suggestion of adding a fourth region: DATA, and renamed
  the old DATA one to DATA_TEST. [Sean]
- removed some unneeded code in page_fault_test.c. [Andrew]
- removed r-b's from Andrew and Oliver in commit "KVM: selftests: Use the
  right memslot for code, page-tables, and data allocations", as the commit
  changed quite a bit (again). Thanks for the reviews! would it have been OK
  to keep it? not sure how strict we all are about collecting r-b's on a
  commit that changed.

Ricardo Koller (14):
  KVM: selftests: Add a userfaultfd library
  KVM: selftests: aarch64: Add virt_get_pte_hva() library function
  KVM: selftests: Add missing close and munmap in
    __vm_mem_region_delete()
  KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
    macros
  tools: Copy bitfield.h from the kernel sources
  KVM: selftests: Stash backing_src_type in struct userspace_mem_region
  KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
  KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and
    vm_vaddr_alloc()
  KVM: selftests: Use the right memslot for code, page-tables, and data
    allocations
  KVM: selftests: aarch64: Add aarch64/page_fault_test
  KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
  KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
  KVM: selftests: aarch64: Add readonly memslot tests into
    page_fault_test
  KVM: selftests: aarch64: Add mix of tests into page_fault_test

 tools/include/linux/bitfield.h                |  176 +++
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    2 +
 .../selftests/kvm/aarch64/page_fault_test.c   | 1112 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  228 +---
 .../selftests/kvm/include/aarch64/processor.h |   35 +-
 .../selftests/kvm/include/kvm_util_base.h     |   31 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   45 +
 .../selftests/kvm/lib/aarch64/processor.c     |   48 +-
 tools/testing/selftests/kvm/lib/elf.c         |    3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   82 +-
 .../selftests/kvm/lib/riscv/processor.c       |   29 +-
 .../selftests/kvm/lib/s390x/processor.c       |    8 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  186 +++
 .../selftests/kvm/lib/x86_64/processor.c      |   13 +-
 15 files changed, 1723 insertions(+), 276 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.38.0.413.g74048e4d9e-goog


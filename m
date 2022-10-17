Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751D3C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 19:58:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBC424B7A9;
	Mon, 17 Oct 2022 15:58:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nDchcU-NekxV; Mon, 17 Oct 2022 15:58:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B38024B6DF;
	Mon, 17 Oct 2022 15:58:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1104B6DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2eksmlvMH0x3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 15:58:37 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ECEB4B6CF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:37 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 a2-20020a5b0002000000b006b48689da76so11412910ybp.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 12:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=nxz6ujZl6J0lLdvFmDD1+ymMkl0X6Jx/QVt4Dg3igeO1KC/AKLQ4f3/F+XPojixCf9
 2TfN2s8q8DeKPwjpbKPqDeNsVq10egp2Yq5MKHVH+bnhP3rmbwkoRmhVnVpO4rPiPFnq
 xTgZDcoalpvSAjYO3PfqPox7R+Tf/726wa3lPBosbX+OzNMxiWAiLoMsrOCYgvfL3iY9
 /nfHEmM7OVECaWYm2BKUXNKAATF13oGqlYvFBYdtnWS9bkk6jOy7FFFx17231SNUxfK4
 zb0jBF/BhlmNn1gwkQudBag3qB3sShq1xJ4Kr2f/iYC6T6lmde+7C7jXyGkWsJnS/kdm
 JLuQ==
X-Gm-Message-State: ACrzQf0T/wxBDyqB3rnt6ONLHeYpY9o6Q66cOR9jsR5kQkkGyZDxj3SU
 /d1nJ8MML6hRedr+DF+dCd5HiqLr88LlcA==
X-Google-Smtp-Source: AMsMyM6epjx47gI8sy+GTFaC/SdmxDJEvB0L05XsJ31+lfOICN3GkPjRPNwQiCHsq2GvfuTDW6fhAqyG2OlApQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:9e0d:0:b0:355:85e8:d975 with SMTP id
 m13-20020a819e0d000000b0035585e8d975mr10534264ywj.61.1666036717029; Mon, 17
 Oct 2022 12:58:37 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-1-ricarkol@google.com>
Subject: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 andrew.jones@linux.dev
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, dmatlack@google.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

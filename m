Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09FAC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 01:06:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57BB84B632;
	Mon, 10 Oct 2022 21:06:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b3NuryRqGxdk; Mon, 10 Oct 2022 21:06:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C8264B3C0;
	Mon, 10 Oct 2022 21:06:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D8FA403FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q84ENRBg4opv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 21:06:32 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0256402A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:32 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-355bdeba45bso119014247b3.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 18:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=FNBTg3BpPEb0OgrkQKPKL1pOsmjvOVCnCRK1VPggMUU=;
 b=pIc9IBbL09VEE88pBhXk95Bc+jQL/pOcQu9j+3FWJwfmwpjeuKP6gi26wSbmQ2aoxW
 PN+BSGxhfHVGTO5/JcTXkhferlBjvpzLZWUVnrU68grC2+ayjYZWWVni1+m/i+aqQAf6
 3qC00DtyN3Kdcl2p/XNNS9aPJNAjeZgu4SQaCKmv5RZjmza6UcLXuEFW0CVKIUVvwJJ5
 hmBEXlD9jdr6pT4YOtRyg1LzGGiYAPRqq0Qfl+mijrf/Q56kehckp9CrmO0TF1qJRLTB
 xaLuii0yw2bgx3cWMDbHOOKiIkXAgB3PW+izSPFhchyhPIdGmQHg3Mj3bSAkHhqy1HdC
 VB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=FNBTg3BpPEb0OgrkQKPKL1pOsmjvOVCnCRK1VPggMUU=;
 b=mzwSW/b2vdUeA16g6SIXe54G7k802BmykaOyv1WhGxh+ufLXNCxbnkCm4ObiB+qDOm
 UMPSBfi5/1IsZWPE1/Zgq+vyl3JBs+qbmg2tNZmDvxR69WM/Sp8JIGvIwO0rlwhtvW91
 MYCUmzRT2yzCzcWw/wNRvCqMlm3MbIzyHO/Vnq7N7ZamkOjv5YhwHoKQkkKCkYwVJ2X7
 e5pHF8v6LYYPQRF5pvmhZTqtGdvfiaaCltdFtE7cYzkYv6ITI/OEBlCFnqqbbKtvGdcQ
 u3HFB9Xv2chO5Vlv02D1L1u91s/fqXW1EmsjauMwOO1KupqUweLGEyAdFGUmUfDNj5lQ
 fqIg==
X-Gm-Message-State: ACrzQf0k5gsGStgto/+oAjSGuh6PjP1vAoFJSo8jMPay/gzYgv0YSC1e
 X9hoShEi3XNbAMt8geaBtjuVXlgZcFdSyg==
X-Google-Smtp-Source: AMsMyM6mol4ixOaGufGagkDKS4eeWNPMt8ucYchUQKAqct86h6zznF1MLBU2o6E6/ljWxccFasZKQl/YotSzFg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:124e:b0:668:222c:e8da with SMTP
 id t14-20020a056902124e00b00668222ce8damr19975091ybu.383.1665450392200; Mon,
 10 Oct 2022 18:06:32 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:14 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-1-ricarkol@google.com>
Subject: [PATCH v9 00/14] KVM: selftests: Add aarch64/page_fault_test
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
 .../selftests/kvm/aarch64/page_fault_test.c   | 1113 +++++++++++++++++
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
 15 files changed, 1724 insertions(+), 276 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

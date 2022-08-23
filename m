Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091D4C3F6B0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 23:47:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C2F14C5C9;
	Tue, 23 Aug 2022 19:47:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YiDq1wP9VFvH; Tue, 23 Aug 2022 19:47:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D7674C5D1;
	Tue, 23 Aug 2022 19:47:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 991D24C5C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n-cwVU45-7bI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 19:47:31 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 351C04C5C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:31 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-33d9f6f4656so18109037b3.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 16:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
 bh=lI8RVWeGiy/V5ixpWNIycXsB5AxR7O8H8gTuNCP1X3Y=;
 b=Z/MYPuRIYLWOvU+H5Y/4TJkXS3p4QothM/xmo7VtKPYYs4Ah+erSdsyShoPZlJyfJN
 toHS+uotvqskkWRJ2OcNF2p/gkUx79zmGf1LZ+1E7RVLE061+4NJmCDVFLHmZix4j6t4
 /7odh6OD7df9R4lo355CzWgtijXfaNiX9b8/EO16by1LXTYbR936gkJPsqaI+40t/qM8
 oVfIOHdf0JLU9K1PZaH8IwxVHlYG6+emhRIjOjHTYKZQ04WfVquri/v+JoJGzDl7j5MJ
 xZPUDO+afV1cFOB6z6DHOTm/p77wBkzXQPW+8kK5Hlotqi1/RKXoMzxV2g+10tQUoYxS
 dJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
 :from:to:cc;
 bh=lI8RVWeGiy/V5ixpWNIycXsB5AxR7O8H8gTuNCP1X3Y=;
 b=BAWvAgZyfEwbuojsf4SwojCw20cmI9tbZVb/x5WYFAQ5S2VxlhiAYud2PGVaHEagGz
 yywCURZ7J+bFQOj9WChPmYosPGRrx6r3P2Tz1nHgdgcTZTJ5mBQqheE6PbeM1/6ywN0v
 YLQUKGJ7msUafUPj5wtD/ddPab7HHtM0SNYYHHLVpRR9HBumkgT5iRA9UPIkS7g6bqiB
 /znGfmi4mQufIhYdvCnhEWr5LWnLpflPVMFJN+nMKadInEAXEhZXOTQSgauJlYHgLxaB
 uYFiPpBHa/lsYs/1MdyCyzX8BvLLfvt8FlZj6Cx6SH4bfazv09nIzC81u6acdinVaGRu
 mL4g==
X-Gm-Message-State: ACgBeo2l3X8Y4BiAVbA0y6d6l4xOG/gYiGBXFfoLZJfQhV9SoELt6I1N
 MH1Tq8Eg87wTOSQAQIPT87Ny5y7iqv+aWQ==
X-Google-Smtp-Source: AA6agR7FEUM+UiCqKmbZaKSVuJLapiaSgSGc2xyg1kI5PP9P/z6BPcYx3aCDwK5KuIg5SonqG5GdhaofPEYMIg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:7183:0:b0:31f:63f4:1743 with SMTP id
 m125-20020a817183000000b0031f63f41743mr28768685ywc.176.1661298450536; Tue, 23
 Aug 2022 16:47:30 -0700 (PDT)
Date: Tue, 23 Aug 2022 23:47:14 +0000
Message-Id: <20220823234727.621535-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 00/13] KVM: selftests: Add aarch64/page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: dmatclack@google.com, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com
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

This series adds a new aarch64 selftest for testing stage 2 fault handling for
various combinations of guest accesses (e.g., write, S1PTW), backing sources
(e.g., anon), and types of faults (e.g., read on hugetlbfs with a hole, write
on a readonly memslot). Each test tries a different combination and then checks
that the access results in the right behavior (e.g., uffd faults with the right
address and write/read flag). Some interesting combinations are:

- loading an instruction leads to a stage 1 page-table-walk that misses on
  stage 2 because the backing memslot for the page table it not in host memory
  (a hole was punched right there) and the fault is handled using userfaultfd.
  The expected behavior is that this leads to a userfaultfd fault marked as a
  write. See commit c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW
  permission fault on instruction fetch") for why that's a write.
- a cas (compare-and-swap) on a readonly memslot leads to a failed vcpu run.
- write-faulting on a memslot that's marked for userfaultfd handling and dirty
  logging should result in a uffd fault and having the respective bit set in
  the dirty log.

The first 8 commits of this series add library support. The first one adds a
new userfaultfd library (out of demand_paging_test.c). The next 3 add some
library functions to get the GPA of a PTE, and to get the fd of a backing
source. Commit 6 fixes a leaked fd when using shared backing stores. The last 5
commits add the new selftest, one type of test at a time. It first adds core
tests, then uffd, then dirty logging, then readonly memslots tests, and finally
combinations of the previous ones (like uffd and dirty logging at the same
time).

v4 -> v5: https://lore.kernel.org/kvmarm/20220624213257.1504783-1-ricarkol@google.com/
- biggest change: followed suggestion from Sean and Andrew regarding a new
  arg for vm_create() to specify the guest memory layout. That's taken care
  of with these two new commits:
	KVM: selftests: Use the right memslot for code, page-tables, and data allocations
	KVM: selftests: Change ____vm_create() to take struct kvm_vm_mem_params
  plus the respective changes in the page_fault_test itself (mostly code reduction).
- dropped some commits that are not needed after the above change:
	KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
	KVM: selftests: Add vm_alloc_page_table_in_memslot library function
	KVM: selftests: Add vm_mem_region_get_src_fd library function
- addressed Oliver comments in commit "KVM: selftests: aarch64: Add
  aarch64/page_fault_test"
- collect r-b's from Andrew

v3 -> v4: https://lore.kernel.org/kvmarm/20220408004120.1969099-1-ricarkol@google.com/
- rebased on top of latest kvm/queue.
- addressed Oliver comments: vm_get_pte_gpa rename, page_fault_test and
  other nits.
- adding MAIR entry for MT_DEVICE_nGnRnE. The value and indices are both
  0, so the change is really esthetic.
- allocating less memory for the test (smaller memslots).
- better comments, including an ascii diagram about how memory is laid out
  for the test.

v2 -> v3:
Thank you very much Oliver and Ben
- collected r-b's from Ben. [Ben]
- moved some defitions (like TCR_EL1_HA) to common headers. [Oliver]
- use FIELD_GET and ARM64_FEATURE_MASK. [Oliver]
- put test data in a macro. [Oliver]
- check for DCZID_EL1.DZP=0b0 before using "dc zva". [Oliver]
- various new comments. [Oliver]
- use 'asm' instead of hand assembly. [Oliver]
- don't copy test descriptors into the guest. [Oliver]
- rename large_page_size into backing_page_size. [Oliver]
- add enumeration for memory types (4 is MT_NORMAL). [Oliver]
- refactored the test macro definitions.

v1 -> v2: https://lore.kernel.org/kvmarm/20220323225405.267155-1-ricarkol@google.com/
- collect r-b from Ben for the memslot lib commit. [Ben]
- move userfaultfd desc struct to header. [Ben]
- move commit "KVM: selftests: Add vm_mem_region_get_src_fd library function"
  to right before it's used. [Ben]
- nit: wrong indentation in patch 6. [Ben]

Ricardo Koller (13):
  KVM: selftests: Add a userfaultfd library
  KVM: selftests: aarch64: Add virt_get_pte_hva() library function
  KVM: selftests: Add missing close and munmap in
    __vm_mem_region_delete()
  KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
    macros
  tools: Copy bitfield.h from the kernel sources
  KVM: selftests: Stash backing_src_type in struct userspace_mem_region
  KVM: selftests: Change ____vm_create() to take struct
    kvm_vm_mem_params
  KVM: selftests: Use the right memslot for code, page-tables, and data
    allocations
  KVM: selftests: aarch64: Add aarch64/page_fault_test
  KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
  KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
  KVM: selftests: aarch64: Add readonly memslot tests into
    page_fault_test
  KVM: selftests: aarch64: Add mix of tests into page_fault_test

 tools/include/linux/bitfield.h                |  176 +++
 tools/testing/selftests/kvm/Makefile          |    2 +
 .../selftests/kvm/aarch64/page_fault_test.c   | 1132 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  228 +---
 .../selftests/kvm/include/aarch64/processor.h |   35 +-
 .../selftests/kvm/include/kvm_util_base.h     |   65 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   46 +
 .../selftests/kvm/lib/aarch64/processor.c     |   29 +-
 tools/testing/selftests/kvm/lib/elf.c         |    3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  129 +-
 .../selftests/kvm/lib/riscv/processor.c       |    7 +-
 .../selftests/kvm/lib/s390x/processor.c       |    7 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  187 +++
 .../selftests/kvm/lib/x86_64/processor.c      |   13 +-
 14 files changed, 1801 insertions(+), 258 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1CAC43334
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jun 2022 21:33:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0843741294;
	Fri, 24 Jun 2022 17:33:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J0eYxuPKSv6M; Fri, 24 Jun 2022 17:33:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC94D49E2B;
	Fri, 24 Jun 2022 17:33:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8616541019
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XuYX3GE2zWl7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 17:33:02 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E997340FD3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:01 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 h6-20020a17090a580600b001eab5988770so1712533pji.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 14:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=tJvhNLrzuWADZ1eGl77JQrRhgY8OXv2/wb8UJyMC+i8=;
 b=Ml233OLsEw5OJtIEGoIbr9eVSLtNH9A/V5UQu4jrfgqwMscL6kpAtigzZoeErCaxpd
 OeMfaMKp2kFSbI4Pz2IxyC7QbLEkdzNYOoLBWJUl0g3mXM0EgnIelHbc6ZpwPVVbE8g1
 NMvNtfXGtJyP0ZJ4M5WumIoElmoDOwM/GuqHyRoP4c8+43o2GIErXbeK3Oh/+acCw4Pn
 JwMFlYY9IxibqBwy+9QPsJLyegNo5NP2SF6DrINkEdDQZ+lI4KpFPKvkTQgcsiuoEPF6
 /Z5sXlR2Y1jg4yTB4V49kjM2mf8gwzjRgsy2YiCAXsADY9y0ijKrvfXCzKPSZmpv7zgV
 wqrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=tJvhNLrzuWADZ1eGl77JQrRhgY8OXv2/wb8UJyMC+i8=;
 b=1FuoWnGrH2mrYxSxzdjSSCBpQ3MBbmHC46tK+OC0SNp3qX8otmTqXWnyiCNmoGSJOq
 VNhH6Z3oec/UzDywf6Q0KJ+X6z0ETKAdLt3JjD1s1CiFJofAsoxQHmjYXTR2Wmohr8TW
 oUhnqV3e0TDooNWFeR4Zp9n7g9ItbBcftbjHzg/z8Cp4RwO4kRRmi3yxfoCOhmpFSpJ8
 Hm4pfGS+RggY1aonkXor7CPnYslcfLYzXydjLZXXCsrkLmP1uvQWMqr+utpcqQAIhXZd
 3TFJEZDamv2B/T3DVnTxaDKWy8AyTZwRtB2EcjgPeKKsZsw8a6+eSG46JY/0h1DBFos4
 4riw==
X-Gm-Message-State: AJIora/QeVUe7U5Hp67vy/TJj9KtwSOzy8VUuIlXRwSFmpweQJK/FjYS
 V6zlU5XQ8nFfxaLm2NdMPcIIr6SSawzoAw==
X-Google-Smtp-Source: AGRyM1thVt68XukVWh6bQ5LdOcSyGNDJhuQrfdi3tNxZ+poC8AAm4tZI6LfrtTfWa0ku0trGGv3LACtGENmTZw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr388629pje.0.1656106380377; Fri, 24 Jun
 2022 14:33:00 -0700 (PDT)
Date: Fri, 24 Jun 2022 14:32:44 -0700
Message-Id: <20220624213257.1504783-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 00/13] KVM: selftests: Add aarch64/page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, dmatlack@google.com,
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
  KVM: selftests: aarch64: Add virt_get_pte_hva library function
  KVM: selftests: Add vm_alloc_page_table_in_memslot library function
  KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
  KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
  KVM: selftests: Add vm_mem_region_get_src_fd library function
  KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
    macros
  tools: Copy bitfield.h from the kernel sources
  KVM: selftests: aarch64: Add aarch64/page_fault_test
  KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
  KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
  KVM: selftests: aarch64: Add readonly memslot tests into
    page_fault_test
  KVM: selftests: aarch64: Add mix of tests into page_fault_test

 tools/include/linux/bitfield.h                |  176 +++
 tools/testing/selftests/kvm/Makefile          |    2 +
 .../selftests/kvm/aarch64/page_fault_test.c   | 1236 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  228 +--
 .../selftests/kvm/include/aarch64/processor.h |   36 +-
 .../selftests/kvm/include/kvm_util_base.h     |    2 +
 .../selftests/kvm/include/userfaultfd_util.h  |   46 +
 .../selftests/kvm/lib/aarch64/processor.c     |   27 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   37 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  187 +++
 10 files changed, 1762 insertions(+), 215 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

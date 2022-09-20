Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829D8C6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:15:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFC764B712;
	Tue, 20 Sep 2022 00:15:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zwbsA2hzCPl5; Tue, 20 Sep 2022 00:15:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DBC44B615;
	Tue, 20 Sep 2022 00:15:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F5404B600
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qkk0J7c6AJZ2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:15:13 -0400 (EDT)
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com
 [209.85.210.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDFAE4B492
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:12 -0400 (EDT)
Received: by mail-ot1-f73.google.com with SMTP id
 t11-20020a9d590b000000b00655fad88dacso749812oth.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date; bh=itG2ao8v2MUUEvmstjr2ZRfqvTnaq3pX8oeHEmsTjAo=;
 b=oJMNmizlMb9dXq5sfbm5XybkUnFtI8QKl84PAofRSqTx5gvMY0SBJunZOTxC3DxO2a
 A06HpGM9tFuU4XjRL+snw93Rqz1Ldij8mcS772hMKtxZxr/YZ8ky8W2MfVJg8RK94Ukv
 ZGOQ3sxDzSZfvqBAD+xQFxTZKpdJDmZszvJn3m+Nyh1JWexfdwGTQCYXD5ElezTwaqGr
 jprS5zmz2RKwvTxpyosiWlO6mRnynDVWDDfKcsSqjHfYas7myKL0eWC7+VtDWaJreZLB
 w3LMQg64gyjly0CGDnEuZxuGeJWn2Hjlagju1k8ZcljOg3LNfMIl2TN8bi4pMcMmgjlw
 f3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date;
 bh=itG2ao8v2MUUEvmstjr2ZRfqvTnaq3pX8oeHEmsTjAo=;
 b=sqcDEQBHxuLoSKRipjYgsGIF4M0w/psdQhqlYwD+E92Ujq2IO814LaDpk7ucfJkiB6
 m4qwMKdr8ckQ5LmkVzJYhAkocaJQq44vv5ky+I0G1op9mz6tC/qrbvP3MRKagS/BHhz7
 wdP/qtRu5DaEgJSjHiQCETPvXHfyF33WGobIhe1uazEd42SFJJ2yyar0xXQGYpHFMVOg
 73spzt/2cBI1vZaL6ettTSxp+hFXNvofwfds1LJfNlstAcr20bq/aLq0tEMfZ5aVf29L
 x5J1SUwyaiu0m5l0txVpwNL9XvrrmSi/tSg1kl/M0yWHGDECTk8U0nQRPhNf+eqFeIy0
 T4Ww==
X-Gm-Message-State: ACrzQf2jREs37URP1DPBWxcy1jWtGVYprjnUt3hw4xHXIUUG1p0yfVXB
 6zikFZCBwEP0p8DLvRBWPDlKTZrPZkDvRg==
X-Google-Smtp-Source: AMsMyM60KtkEA5MqpgAZQDxEJswe2HfSJnm1WdFK7LHIPBazH9xDDTzYW8aMsFGIdkFQCbCmOqSsoIwMhm8YvA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aca:5f03:0:b0:343:8774:d67 with SMTP id
 t3-20020aca5f03000000b0034387740d67mr682339oib.9.1663647312272; Mon, 19 Sep
 2022 21:15:12 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:14:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-1-ricarkol@google.com>
Subject: [PATCH v6 00/13] KVM: selftests: Add aarch64/page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
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
new userfaultfd library. Commits 2-5 add some misc library changes that will be
used by the new test, like a library function to get the GPA of a PTE. Commits
6-8 breaks the implicit assumption that code and page tables live in memslot
memslots should allocators use. This is then used by the new test to place the
page tables in a specific memslot.  The last 5 commits add the new selftest,
one type of test at a time. It first adds core tests, then uffd, then dirty
logging, then readonly memslots tests, and finally combinations of the previous
ones (like uffd and dirty logging at the same time).

v6 -> v7: https://lore.kernel.org/kvmarm/Yyi03sX5hx36M%2FZr@google.com/
- removed struct kvm_vm_mem_params. Changed page_fault_test.c accordingly. [Sean]
- applied Oliver's patch to fix page_fault_test compilation warnings. [Oliver]
- added R-b's from Oliver and Andrew. Didn't Andrew's R-b on 6/13 as the commit
  changed afterwards.

v5 -> v6: https://lore.kernel.org/kvmarm/20220823234727.621535-1-ricarkol@google.com/
- added "enum memslot_type" and all the related cleanups due to it [Andrew]
- default kvm_vm_mem_default with size=0 [Andrew,Sean]
- __vm_vaddr_alloc() taking "enum memslot_type" and all the related cleanups
  due to this change [Andrew]

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

Ricardo Koller (13):
  KVM: selftests: Add a userfaultfd library
  KVM: selftests: aarch64: Add virt_get_pte_hva() library function
  KVM: selftests: Add missing close and munmap in
    __vm_mem_region_delete()
  KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
    macros
  tools: Copy bitfield.h from the kernel sources
  KVM: selftests: Stash backing_src_type in struct userspace_mem_region
  KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
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
 .../selftests/kvm/aarch64/page_fault_test.c   | 1116 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  228 +---
 .../selftests/kvm/include/aarch64/processor.h |   35 +-
 .../selftests/kvm/include/kvm_util_base.h     |   29 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   45 +
 .../selftests/kvm/lib/aarch64/processor.c     |   26 +-
 tools/testing/selftests/kvm/lib/elf.c         |    3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   82 +-
 .../selftests/kvm/lib/riscv/processor.c       |    7 +-
 .../selftests/kvm/lib/s390x/processor.c       |    7 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  186 +++
 .../selftests/kvm/lib/x86_64/processor.c      |   13 +-
 15 files changed, 1698 insertions(+), 258 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

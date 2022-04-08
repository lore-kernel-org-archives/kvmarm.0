Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 783C8C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DABD949F35;
	Thu,  7 Apr 2022 20:41:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O+nJH8OiGwbn; Thu,  7 Apr 2022 20:41:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F45F4A0FE;
	Thu,  7 Apr 2022 20:41:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80C8849F35
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qq6aBp4PJQQv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:24 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DC8049ED2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:23 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 oj16-20020a17090b4d9000b001c7552b7546so6707416pjb.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=E6xF7BRmUXfmciuEZaesrs494yfp8aq+3UzXCgkaDGg=;
 b=eA/KbHhnaC2JgbW/IRh9sTbQJ9whQYQpJxPZuP+GG43bo4xQFfCzjaMHN6RMZidDE0
 19HiC3vHvubzv0C4BtXxIibUeQ+9Z1in7BaYiRACc6oCuCT2hmlKboWSYZotkelmLKIz
 EsKDGE3//xlkWUfKwg6rziwQrmMiFwAR9yF43Q671xGzCIBRS3dnBHJ2NLF7JSTnQB8O
 YvwJMkTS8qwyy/4htcZRNIDRNubMAoR2yYxSSuu3eXEx/NSILgEoy+UwGJKpHmIXUiLV
 kUTXw5t5VNs21yoJPiDoSK/wyL6bDwDp2i4qd120iTW6kL2cv/OT6BXiqLXYfEDcBbE1
 nEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=E6xF7BRmUXfmciuEZaesrs494yfp8aq+3UzXCgkaDGg=;
 b=nT2KsNZxGvXWnTjGFwyrqz8zOne0/Wq+T9c009oIL+a4qwyb8V3wCsw9vifaRZ6nyx
 ///H6oZEb8oF3H7Vay9wo6wMJLatpOkZC9FZQ1KxUqCAzK7w/ynwVtM9yhwYIuRU5ByC
 fZEwoeswYOo7QESw+41tLNvzgYXRdg5NU3suMH+5C1C7DAgnNj7xoq5L46KM1OJDzzty
 tRfLR7Z9d6QzeZmxE3hA1rXnqg+YMImx7i4FRa2gkrLmfQ+qSwqSgCcbpoZHulKS6SPF
 K4E5zgE6rWzlTO1usgpbPoc7PJ4uv+u6WDUUiBsJVMydFwO1ji1eRFytuRCKS3STunYT
 1exQ==
X-Gm-Message-State: AOAM53037mfnDVAXJak5e6Grx/vMEam/zCgcmBK+nGcGdMWp1RgaD06U
 qeHfHqEendDrQSnoZfpfH+K59F711YMnWg==
X-Google-Smtp-Source: ABdhPJwWcruWcjxHeX/1C8HwzP9BtdmvN7zU4n1HoFXjhRxc3q5cTBsOGvgA1laxGF7esXseCoeg0vlHvhRwrA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:3b4c:b0:1c6:d9f0:77b8 with SMTP
 id ot12-20020a17090b3b4c00b001c6d9f077b8mr18664455pjb.124.1649378483039; Thu,
 07 Apr 2022 17:41:23 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:07 -0700
Message-Id: <20220408004120.1969099-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 00/13] KVM: selftests: Add aarch64/page_fault_test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com
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
  KVM: selftests: aarch64: Add vm_get_pte_gpa library function
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
 tools/testing/selftests/kvm/Makefile          |    3 +-
 .../selftests/kvm/aarch64/page_fault_test.c   | 1255 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  227 +--
 .../selftests/kvm/include/aarch64/processor.h |   35 +-
 .../selftests/kvm/include/kvm_util_base.h     |    2 +
 .../selftests/kvm/include/userfaultfd_util.h  |   47 +
 .../selftests/kvm/lib/aarch64/processor.c     |   38 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   37 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  187 +++
 10 files changed, 1792 insertions(+), 215 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

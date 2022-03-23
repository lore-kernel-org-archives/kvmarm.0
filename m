Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CEEC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 22:54:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA75F49ED7;
	Wed, 23 Mar 2022 18:54:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E1NJ+0f5VqPF; Wed, 23 Mar 2022 18:54:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E28B249ED8;
	Wed, 23 Mar 2022 18:54:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B1740A84
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UmYfWj1aRe6A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 18:54:11 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D733040C02
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:10 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 b19-20020a621b13000000b004fa68b3677bso1644383pfb.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=KKW1/KO/KoM4PtUUxqCzptnpYmhmZGLDr0xVnYILraY=;
 b=IdFLGLKLY8qNT/p7FGx+35du5zw9U/0pX9eKVxHvcxYuslZuqj41h/F0kGx1w0G50u
 7Qb3YH9QIAs2TQ2uUnKwzjB16pjnMqu1QEn7oqYgzoEkoBms9XFZAO0tr3nDY0kRBRJw
 IjUtXASDbrfJNywu0SZQHk4aBT/QHKGuwkwBwQ5KuhsbKeko7yAgQwJTEiSG3ZCV/ecp
 S6rdGOhy/wfVOQrQPlqNtve6n5eMdnaS+826195i/QZIq7UQFA5seYzVfEoHLTMi4Rup
 JuWBOai8jtLJSiIZm++MUHT4PKGWToXoWOpI6PNhbuVkuC93AWzNpGg1CZuY6YlKOcDz
 /6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=KKW1/KO/KoM4PtUUxqCzptnpYmhmZGLDr0xVnYILraY=;
 b=ppqkcrgRs6NDsIiilyM1YZdm7EwfqNvMnEoG4nLS6ufH25mbmqx3a4bGRQf3m3M7C9
 sxeO+1s3bEFKo6FvSAiWjqTE6c/XJzPe+pkihTVhsCKkBeHg00Aomwdh6pwr7yMtDrVR
 F0kvifH37zevlYr/c4+V5KfqWSdddAXC9/Inc7CQT80CHqpxm2h0qNyruEm61Sim4cts
 CX6uzBF+/W243hCQDlHRW9rib+aoP8VLzzG9IvGy5LvnR0AOcFcgzN6SWVNZXiitpDnY
 f2hF8ReKTSwR7Sj2OJCRgOZA3YKbS1ufuvUTww+7FtfT8riVhHast2sR7bwiu4EX8NrA
 YSjQ==
X-Gm-Message-State: AOAM531l3WpHi+kE9czxbuettnN1TfNfiEyyaRXLd6EffTj6Ylqg9Grn
 Pt60RWU/YzYpSPxVID1YJbSK0yt0kjrA4Q==
X-Google-Smtp-Source: ABdhPJw0puhfZM7YFERrVtz+tjl4IY23os+HiHwDbvyJbBsLATrJtxRy9PtAqa8RE6V1i7F9y0VAMpujlQEoTA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:2311:b0:4e1:52bf:e466 with SMTP
 id h17-20020a056a00231100b004e152bfe466mr2180170pfh.77.1648076049708; Wed, 23
 Mar 2022 15:54:09 -0700 (PDT)
Date: Wed, 23 Mar 2022 15:53:54 -0700
Message-Id: <20220323225405.267155-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 00/11] KVM: selftests: Add aarch64/page_fault_test
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

The first 6 commits of this series add library support. The first one adds a
new userfaultfd library (out of demand_paging_test.c). The next 3 add some
library functions to get the GPA of a PTE, and to get the fd of a backing
source. Commit 6 fixes a leaked fd when using shared backing stores. The last 5
commits add the new selftest, one type of test at a time. It first adds core
tests, then uffd, then dirty logging, then readonly memslots tests, and finally
combinations of the previous ones (like uffd and dirty logging at the same
time).

v1 -> v2:
- collect r-b from Ben for the memslot lib commit. [Ben]
- move userfaultfd desc struct to header. [Ben]
- move commit "KVM: selftests: Add vm_mem_region_get_src_fd library function"
  to right before it's used. [Ben]
- nit: wrong indentation in patch 6. [Ben]

Ricardo Koller (11):
  KVM: selftests: Add a userfaultfd library
  KVM: selftests: aarch64: Add vm_get_pte_gpa library function
  KVM: selftests: Add vm_alloc_page_table_in_memslot library function
  KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
  KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
  KVM: selftests: Add vm_mem_region_get_src_fd library function
  KVM: selftests: aarch64: Add aarch64/page_fault_test
  KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
  KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
  KVM: selftests: aarch64: Add readonly memslot tests into
    page_fault_test
  KVM: selftests: aarch64: Add mix of tests into page_fault_test

 tools/testing/selftests/kvm/Makefile          |    3 +-
 .../selftests/kvm/aarch64/page_fault_test.c   | 1461 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  227 +--
 .../selftests/kvm/include/aarch64/processor.h |    5 +
 .../selftests/kvm/include/kvm_util_base.h     |    2 +
 .../selftests/kvm/include/userfaultfd_util.h  |   47 +
 .../selftests/kvm/lib/aarch64/processor.c     |   36 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   37 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  187 +++
 9 files changed, 1797 insertions(+), 208 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

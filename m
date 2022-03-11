Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233A0C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 06:02:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 934A340BF0;
	Fri, 11 Mar 2022 01:02:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bs0bsODkO5AF; Fri, 11 Mar 2022 01:02:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4873340C10;
	Fri, 11 Mar 2022 01:02:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4AF40BF0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qVbz5qv-yDpv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 01:02:11 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8113740BE7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:11 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 16-20020a621910000000b004f783aad863so1601452pfz.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 22:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=2nOoHi6NjbjuTQS8aSeXk0qlUOIjsUXdfh7SYmb/M0g=;
 b=f/LPydLCAcr3oCfm7JZZL52CYv82tocPbn/zue3zOZ9rml9Qw33idaDfWuvHzdNIOg
 RIS7LPw/oaoIhGA1kdb65ss2M0kZDJu8x26ogOvd0983oc7YnHwhCWcrOGl3ndkGCdv7
 EHnZfwuAuVfxepeIzBS3F2Bq2xusqpd71joAxrlU9lCeEzQyjt6A3lCJ8Jlw1WkRb/ZA
 nSJbLXRoxAUctYoxRRjTV+wOqQZqUNemOFzeQp4N6lPD566NeIPZNTk7UzCjY8sntWqr
 mSNi2Wtll6aW2jX3ewSdT877BCB1VchxWfmgUJpHdRXaWF9tGIfvm9FtFlbSvY274mlK
 G3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=2nOoHi6NjbjuTQS8aSeXk0qlUOIjsUXdfh7SYmb/M0g=;
 b=XHzfSMCeEiMtd/ybEPVPLaV8WWS64DFdfjgGMACAZTkSGzvWMOYiTuRDnCCdPg/VpQ
 TKe0oh9WL15XhB9zIhHvrfUlWJulXdnEF4wXBuey4jfXaY0eyTYMSI/q96vSd9JUhnFV
 QjvRTbYIB50fwZBFWLQ/9mskK1LJKWwRSLkbAI4ExySlKEPHGMiaLm4rfYyrzKSxqCoj
 fjDmFm9kSSCejDE+xe7k6ZlAgs/PVMpy6nsVsxFC68Uiy1YEDxkTHLD7MYQXJ3ZCr62W
 qm7UzcpDbBuO1XUUXfxL7vjFScZu7kMz5YDAb4glbzm6PVjbsu7eaqHpzPg6SBHlU7D2
 4TlA==
X-Gm-Message-State: AOAM531VZeTO3VgT6HnOBXHud5KGuwp7M3GyWpeu09Is59ZIfs19KQb4
 FlrmiCobkczlqRp1gn0hf59bp7FaE2KCcQ==
X-Google-Smtp-Source: ABdhPJxS2t8wUzNs13Sbj1BYmvoToi5oHMNJ32R4vwSmgV52aS6W1eu6JS97Ic3xpD+4p2l7tczs2iXDjoXdOA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:da89:b0:153:349c:d240 with SMTP
 id j9-20020a170902da8900b00153349cd240mr1999318plx.73.1646978530438; Thu, 10
 Mar 2022 22:02:10 -0800 (PST)
Date: Thu, 10 Mar 2022 22:01:56 -0800
Message-Id: <20220311060207.2438667-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 00/11] KVM: selftests: Add aarch64/page_fault_test
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

Ricardo Koller (11):
  KVM: selftests: Add a userfaultfd library
  KVM: selftests: Add vm_mem_region_get_src_fd library function
  KVM: selftests: aarch64: Add vm_get_pte_gpa library function
  KVM: selftests: Add vm_alloc_page_table_in_memslot library function
  KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
  KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
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
 .../selftests/kvm/include/userfaultfd_util.h  |   46 +
 .../selftests/kvm/lib/aarch64/processor.c     |   36 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   37 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  196 +++
 9 files changed, 1805 insertions(+), 208 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

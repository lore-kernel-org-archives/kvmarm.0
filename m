Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196FBA935
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:16 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id u188-20020a2560c5000000b00b8f15f2111dso8230594ybb.4
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335315; x=1683927315;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MEHMIaN+CjvT3NOB98sOvS+cCj2L9OMIJTblslenw6o=;
        b=OW68UtvL6QVecVpXo8gdhAakChrF4onyj5YaYg8Dbd9jaRuc8F10sw4k/ziHUIm4fr
         orQJ7SA8dC4Ki+r7H4TX5eVlQNPEdTjpiwdEwA1lUEum8NWexm3C/6bim7XFF9+5GO1T
         L0RhSSunc4Wpg1WbTnR/cZ25ZxUsB4svJc94LGGGtaER5vXiU+gg9QVWPIWxaltCegcM
         LfjfaJZJMVzfh8yBbZK8+dEq/ew1BA66F9iLC0A+/JO20051ZQ4Zn379u2DxvKil3bkC
         qpePjiQfd01G8jTdxGmKKI4VC/Pxza1C/D68Uz0rOrRsktTtNImgFb4FuGCFNRv7P1gf
         YwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335315; x=1683927315;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MEHMIaN+CjvT3NOB98sOvS+cCj2L9OMIJTblslenw6o=;
        b=HDpA1U9Fr8HbZIYBaubv732klovlNx1FeMssirK2HHGKC0ib3fl2BVGbpquoVVEIDZ
         Fu3p4gOBWkLFQy/fG5jPxEshd4FPDyeWqUN5Odm0nYn8vXh3e4BTM/+Ze1X26R5iuV2r
         0rfkZbPa2FLJV2kwDI+9Iur/ivGbrzz5Ahsko7IWV20zpcrkUyVaa6rnjS5QdspjoBg1
         qTwNFIOXqJQ/yWZU1kUBX9ugEiPncl/DxBTezR9LA30+hoS4EkqDlfS37R5A+v/oewgF
         4Iz8fHWkZDAMr6k6V6nt0kj8N8vmagZdC/zZDctgxlOAL95C9/69yoIsvSW1RaUbx3Fd
         htBQ==
X-Gm-Message-State: AAQBX9ejj3LcYHVeJALMbPdYPilXW6kCCcKhAZgI80y65t0P1gU05PH9
	Rk6VporC5Wd79Q+h7zd2thuQWXHv8Z+gcQ==
X-Google-Smtp-Source: AKy350bkWlSXqypOsDQuqrGi0hmoin7r8Nd8gxJNleXJBXC/gmDI513qyLrz86YoD4pvFUuQ3Zg9plOmvxUBsw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:d7d3:0:b0:b68:7a4a:5258 with SMTP id
 o202-20020a25d7d3000000b00b687a4a5258mr21996ybg.3.1681335315074; Wed, 12 Apr
 2023 14:35:15 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:34:48 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-1-amoorthy@google.com>
Subject: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Due to serialization on internal wait queues, userfaultfd can be quite
slow at delivering faults to userspace when many vCPUs fault on the same
VMA/uffd: this problem only worsens as the number of vCPUs increases.
This series allows page faults encountered in KVM_RUN to bypass
userfaultfd (KVM_CAP_ABSENT_MAPPING_FAULT) and be delivered directly via
VM exit to the faulting vCPU (KVM_CAP_MEMORY_FAULT_INFO), allowing much
higher page-in rates during uffd-based postcopy.

As a first step, KVM_CAP_MEMORY_FAULT_INFO is introduced. This
capability is meant to deliver useful information to userspace (i.e. the
problematic range of guest physical memory) when a vCPU fails a guest
memory access. KVM_RUN currently just returns -1 and sets errno=EFAULT
in response to these failed accesses: the new capability will cause it
to also fill the kvm_run struct with an exit reason of
KVM_EXIT_MEMORY_FAULT and populate the memory_fault field with the
faulting range.

Upon receiving an annotated EFAULT, userspace may take appropriate
action to resolve the failed access. For instance, this might involve a
UFFDIO_CONTINUE or MADV_POPULATE_WRITE in the context of uffd-based live
migration postcopy.

KVM_CAP_MEMORY_FAULT_INFO comes with two important caveats, one public
and another internal.

1. Its implementation is incomplete: userspace may still receive
   un-annotated EFAULTs (exit reason != KVM_EXIT_MEMORY_FAULT) and must
   be able to handle these, although these cases are to be fixed as the
   maintainers learn of/identify them.

2. The implementation strategy given in this series, which is basically
   to fill the kvm_run.memory_fault field whenever a vCPU fails a guest
   memory access (even if the resulting EFAULT might not have been
   returned to userspace from KVM_RUN) is not without risk: some safety
   measures are taken, but they will not ensure total correctness.

   For example, if there are any existing paths in KVM_RUN which cause
   a vCPU to (1) populate the kvm_run struct in preparation for an
   exit to userspace then (2) try and fail to access guest memory for
   some reason, but ignore the result of the access and then (3)
   complete the exit to userspace, then the contents of the kvm_run
   struct written in (1) could be lost.

   Another example: if KVM_RUN fails a guest memory access for which the
   EFAULT is annotated but does not return the EFAULT to userspace,
   then later encounters another *un*annotated EFAULT which *is*
   returned to userspace, then the kvm_run.memory_fault field read by
   userspace will correspond to the first EFAULT, not the second.

   The discussion on this topic and of the alternative (filling the
   efault info only for those cases where KVM_RUN immediately returns to
   userspace) occurs in [3].

KVM_CAP_ABSENT_MAPPING_FAULT is introduced next (and is, I should note,
an idea proposed by James Houghton in [1] :). This capability causes
KVM_RUN to error with errno=EFAULT when it encounters a page fault for
which the userspace page tables do not contain present mappings. When
combined with KVM_CAP_MEMORY_FAULT_INFO, this capability allows KVM to
deliver information on page faults directly to the involved vCPU thread,
thus bypassing the userfaultfd wait queue and its related contention.

As a side note, KVM_CAP_ABSENT_MAPPING_FAULT prevents KVM from
generating async page faults. For this reason, hypervisors using it to
improve postcopy performance will likely want to disable it at the end
of postcopy.

KVM's demand paging self test is extended to demonstrate the performance
benefits of using the two new capabilities to bypass the userfaultfd
wait queue. The performance samples below (rates in thousands of
pages/s, n = 5), were generated using [2] on an x86 machine with 256
cores.

vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new caps)
1       150     340
2       191     477
4       210     809
8       155     1239
16      130     1595
32      108     2299
64      86      3482
128     62      4134
256     36      4012

[1] https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
[2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
    A quick rundown of the new flags (also detailed in later commits)
        -a registers all of guest memory to a single uffd.
        -r species the number of reader threads for polling the uffd.
        -w is what actually enables the new capabilities.
    All data was collected after applying both the entire series and
    the following bugfix:
    https://lore.kernel.org/kvm/20230223001805.2971237-1-amoorthy@google.com/#r
[3] https://lore.kernel.org/kvm/ZBTgnjXJvR8jtc4i@google.com/

---

v3
  - Rework the implementation to be based on two orthogonal
    capabilities (KVM_CAP_MEMORY_FAULT_INFO and
    KVM_CAP_ABSENT_MAPPING_FAULT) [Sean, Oliver]
  - Change return code of kvm_populate_efault_info [Isaku]
  - Use kvm_populate_efault_info from arm code [Oliver]

v2: https://lore.kernel.org/kvm/20230315021738.1151386-1-amoorthy@google.com/

    This was a bit of a misfire, as I sent my WIP series on the mailing
    list but was just targeting Sean for some feedback. Oliver Upton and
    Isaku Yamahata ended up discovering the series and giving me some
    feedback anyways, so thanks to them :) In the end, there was enough
    discussion to justify retroactively labeling it as v2, even with the
    limited cc list.

  - Introduce KVM_CAP_X86_MEMORY_FAULT_EXIT.
  - API changes:
        - Gate KVM_CAP_MEMORY_FAULT_NOWAIT behind
          KVM_CAP_x86_MEMORY_FAULT_EXIT (on x86 only: arm has no such
          requirement).
        - Switched to memslot flag
  - Take Oliver's simplification to the "allow fast gup for readable
    faults" logic.
  - Slightly redefine the return code of user_mem_abort.
  - Fix documentation errors brought up by Marc
  - Reword commit messages in imperative mood

v1: https://lore.kernel.org/kvm/20230215011614.725983-1-amoorthy@google.com/

Anish Moorthy (22):
  KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
    paging test
  KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
    signal errors via TEST_ASSERT
  KVM: Allow hva_pfn_fast() to resolve read-only faults.
  KVM: x86: Set vCPU exit reason to KVM_EXIT_UNKNOWN  at the start of
    KVM_RUN
  KVM: Add KVM_CAP_MEMORY_FAULT_INFO
  KVM: Add docstrings to __kvm_write_guest_page() and
    __kvm_read_guest_page()
  KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
  KVM: Annotate -EFAULTs from kvm_vcpu_read_guest_page()
  KVM: Annotate -EFAULTs from kvm_vcpu_map()
  KVM: x86: Annotate -EFAULTs from kvm_mmu_page_fault()
  KVM: x86: Annotate -EFAULTs from setup_vmgexit_scratch()
  KVM: x86: Annotate -EFAULTs from kvm_handle_page_fault()
  KVM: x86: Annotate -EFAULTs from kvm_hv_get_assist_page()
  KVM: x86: Annotate -EFAULTs from kvm_pv_clock_pairing()
  KVM: x86: Annotate -EFAULTs from direct_map()
  KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
  KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT without implementation
  KVM: x86: Implement KVM_CAP_ABSENT_MAPPING_FAULT
  KVM: arm64: Annotate (some) -EFAULTs from user_mem_abort()
  KVM: arm64: Implement KVM_CAP_ABSENT_MAPPING_FAULT
  KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
  KVM: selftests: Handle memory fault exits in demand_paging_test

 Documentation/virt/kvm/api.rst                |  66 ++++-
 arch/arm64/kvm/arm.c                          |   2 +
 arch/arm64/kvm/mmu.c                          |  18 +-
 arch/x86/kvm/hyperv.c                         |  14 +-
 arch/x86/kvm/mmu/mmu.c                        |  39 ++-
 arch/x86/kvm/svm/sev.c                        |   1 +
 arch/x86/kvm/x86.c                            |   7 +-
 include/linux/kvm_host.h                      |  19 ++
 include/uapi/linux/kvm.h                      |  18 ++
 tools/include/uapi/linux/kvm.h                |  12 +
 .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
 .../selftests/kvm/access_tracking_perf_test.c |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 242 ++++++++++++++----
 .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
 .../testing/selftests/kvm/include/memstress.h |   2 +-
 .../selftests/kvm/include/userfaultfd_util.h  |  18 +-
 tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
 .../selftests/kvm/lib/userfaultfd_util.c      | 158 +++++++-----
 .../kvm/memslot_modification_stress_test.c    |   2 +-
 virt/kvm/kvm_main.c                           |  75 +++++-
 20 files changed, 551 insertions(+), 154 deletions(-)


base-commit: d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7
-- 
2.40.0.577.gac1e443424-goog


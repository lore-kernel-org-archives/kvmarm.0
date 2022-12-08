Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED20C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B37634BA1F;
	Thu,  8 Dec 2022 14:39:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mycLlFbZSSUZ; Thu,  8 Dec 2022 14:39:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48F214BA0E;
	Thu,  8 Dec 2022 14:39:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B81DF4B99B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bWlBnSy0mev5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:09 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1FCD4B975
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:08 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 oj5-20020a17090b4d8500b00219e1abad17so4672236pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=ujLJi7i8azU+eMc6VTcefpCoupmEeGtA9YqNEcSBses=;
 b=cuzmQGCEldboJ2SHxjhYx+JlxduEJQcra1UJYiUT5ADduRS09xHWw7K4TJw1Q5jPem
 KcWULiMtAf8RENHwaDz48Nz4wc0mOadnuYaM+NOwk+AV1c8kwUmctYnQ1GnTujQjYANW
 UoERo9J18Ky3VKEwjcmPruTKMisazad9CVywJ25nL03PajUQw2Wf2MDEk0IdfkLBeD3J
 G9AegsGcNrXObaDNrAuD1hyo4QJk9gcGNZ+ZlJPS+Q1U4EWY0km2jMLYRnIMLWiuNk9v
 XjNoj3Jn+65wwAb2AkKPDDUs6bFJD/MvpR3zoNtTlr/HOQWjVuK/lQxa9oM9gzRO/VDs
 xAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=ujLJi7i8azU+eMc6VTcefpCoupmEeGtA9YqNEcSBses=;
 b=CiB8qMn8joMPCqm6YugpRTMhKUnFrFXsr30P+pQGwkrKZ8W2422lFSfecMn3IryePw
 R4FzWuwtc9/G3QC26g0lcUUUBQ38jr9A/UbEBCA8i5RGawTe2+vlsjkTzpnAlibWmVs4
 sxHu3qC8pW0ZbKMPxH7KC9NeqQFrSlN7LeuWh93cDudomeajyBbPoFl387YjBDLmT9Hf
 nfKfEg7fLHNXX6QPbqynBOwYEqSb8Q69AmWQVm8F6RyS+TD6irhozAWycnFLQ61AIzWF
 tEIf4PWY/1vtjL0dSkWVmqoc6PLvByPumDV7VnInH57sP3cqw+Gn7529CTsya5C6m8jh
 vZEQ==
X-Gm-Message-State: ANoB5pnCtUCcMMpmcdyzx7Gh46YltBKM/a72vlkLvd+0ZOu/E2rif3my
 y7tSNJFN/zcYQZ7ycUtpIIZWthwteLyHdw==
X-Google-Smtp-Source: AA0mqf7+VfQEHkQMkf8id2SowUe4yQgqt5tzohe0c2eiYcS+MDqzUzJHDLrfnnlooA+chsGoATzx5vrJ+8ydUg==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:f89:b0:219:5b3b:2b9f with SMTP id
 ft9-20020a17090b0f8900b002195b3b2b9fmr4096840pjb.2.1670528346939; Thu, 08 Dec
 2022 11:39:06 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:20 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-1-dmatlack@google.com>
Subject: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common code
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
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

[ mm folks: You are being cc'd since this series includes a mm patch
  ("mm: Introduce architecture-neutral PG_LEVEL macros"), but general
  feedback is also welcome. I imagine there are a lot of lessons KVM can
  learn from mm about sharing page table code across architectures. ]

Hello,

This series refactors the KVM/x86 "TDP MMU" into common code. This is
the first step toward sharing TDP (aka Stage-2) page table management
code across architectures that support KVM. For more background on this
effort please see my talk from KVM Forum 2022 "Exploring an
architecture-neutral MMU":

  https://youtu.be/IBhW34fCFi0

By the end of this series, 90% of the TDP MMU code is in common directories
(virt/kvm/mmu/ and include/kvm/). The only pieces that remaing in
arch/x86 are code that deals with constructing/inspecting/modifying PTEs
and arch hooks to implement NX Huge Pages (a mitigation for an
Intel-specific vulnerability).

Before:

  180 arch/x86/kvm/mmu/tdp_iter.c
  118 arch/x86/kvm/mmu/tdp_iter.h
 1917 arch/x86/kvm/mmu/tdp_mmu.c
   98 arch/x86/kvm/mmu/tdp_mmu.h
 ----
 2313 total

After:

  178 virt/kvm/mmu/tdp_iter.c
 1867 virt/kvm/mmu/tdp_mmu.c
  117 include/kvm/tdp_iter.h
   78 include/kvm/tdp_mmu.h
   39 include/kvm/tdp_pgtable.h
 ----
  184 arch/x86/kvm/mmu/tdp_pgtable.c
   76 arch/x86/include/asm/kvm/tdp_pgtable.h
 ----
 2539 total

This series is very much an RFC, but it does build (I tested x86_64 and
ARM64) and pass basic testing (KVM selftests and kvm-unit-tests on
x86_64), so it is entirely functional aside from any bugs.

The main areas I would like feedback are:

 - NX Huge Pages support in the TDP MMU requires 5 arch hooks in
   the common code, which IMO makes the NX Huge Pages implementation
   harder to read. The alternative is to move the NX Huge Pages
   implementation into common code, including the fields in struct
   kvm_mmu_page and kvm_page_fault, which would increase memory usage
   a tiny bit (for non-x86 architectures) and pollute the common code
   with an x86-specific security mitigation. Ideas on better ways to
   handle this would be appreciated.

 - struct kvm_mmu_page increased by 64 bytes because the separation of
   arch and common state eliminated the ability to use unions to
   optimize the size of the struct. There's two things we can do to
   reduce the size of the struct back down: (1) dynamically allocated
   root-specific fields only for root page tables and (2) dynamically
   allocate Shadow MMU state in kvm_mmu_page_arch only for Shadow MMU
   pages. This should actually be a net *reduction* the size of
   kvm_mmu_page relative today for most pages, but I have not
   implemented it.

   Note that an alternative approach I implemented avoided this problem
   by creating an entirely separate struct for the common TDP MMU (e.g.
   struct tdp_mmu_page). This however had a lot of downsides that I
   don't think make it a good solution. Notably, it complicated a ton of
   existing code in arch/x86/kvm/mmu/mmu.c (e.g. anything that touches
   vcpu->arch.mmu->root and kvm_recover_nx_huge_pages()) and created a
   new runtime failure mode in to_shadow_page().

 - Naming. This series does not change the names of any existing code.
   So all the KVM/x86 Shadow MMU-style terminology like
   "shadow_page"/"sp"/"spte" persists. Should we keep that style in
   common code or move toward something less shadow-paging-specific?
   e.g. "page_table"/"pt"/"pte". Also do we want to keep "TDP" or switch
   to something more familiar across architectures (e.g. ARM and RISC-V
   both use "Stage-2")?

Additionally, there are some warts to be aware of. For these I think
they can be addressed in future series, since they only really matter
once we are ready to enable the common TDP MMU on a non-x86
architecture.

 - Tracepoints. For now the common MMU continues to use the x86
   tracepoints code and they are just stubbed (no-ops) for other
   architectures.

 - tdp_mmu_max_mapping_level() and tdp_mmu_max_gfn_exclusive() are
   currently arch hooks but they can probably be made common code at
   some point.

Lastly, I still need to verify that there are no negative performance
impacts of the changes in this series. My main concern is the new
tdp_pte_*() functions adds overhead from not being able to be inlined.

This series applies on top of kvm/queue commit 89b239585965 ("KVM:
x86/mmu: Pivot on "TDP MMU enabled" when handling direct page faults"),
since there are several recent series in kvm/queue that affect this
refactor. A revert of 0c2a04128f50 ("KVM: x86: remove unnecessary
exports") is also needed since it breaks the build on x86 (unrelated to
this refactor).

Thanks.

P.S. Looking to the future... This is just the first step toward
building a common TDP MMU for KVM. After this, We are looking at adding
KUnit testing to the common TDP MMU as a way to offset the risk of
sharing more code across architectures, and then targeting RISC-V as the
first non-x86 architecture to use the common TDP MMU. If any RISC-V
developer is interested in working on the port, please reach out.

David Matlack (36):
  KVM: x86/mmu: Store the address space ID directly in kvm_mmu_page_role
  KVM: MMU: Move struct kvm_mmu_page_role into common code
  KVM: MMU: Move tdp_ptep_t into common code
  KVM: x86/mmu: Invert sp->tdp_mmu_page to sp->shadow_mmu_page
  KVM: x86/mmu: Unify TDP MMU and Shadow MMU root refcounts
  KVM: MMU: Move struct kvm_mmu_page to common code
  mm: Introduce architecture-neutral PG_LEVEL macros
  KVM: Move page size stats into common code
  KVM: MMU: Move struct kvm_page_fault to common code
  KVM: MMU: Move RET_PF_* into common code
  KVM: x86/mmu: Use PG_LEVEL_{PTE,PMD,PUD} in the TDP MMU
  KVM: MMU: Move sptep_to_sp() to common code
  KVM: MMU: Introduce common macros for TDP page tables
  KVM: x86/mmu: Add a common API for inspecting/modifying TDP PTEs
  KVM: x86/mmu: Abstract away TDP MMU root lookup
  KVM: Move struct kvm_gfn_range to kvm_types.h
  KVM: x86/mmu: Add common API for creating TDP PTEs
  KVM: x86/mmu: Add arch hooks for NX Huge Pages
  KVM: x86/mmu: Abstract away computing the max mapping level
  KVM: Introduce CONFIG_HAVE_TDP_MMU
  KVM: x86: Select HAVE_TDP_MMU if X86_64
  KVM: MMU: Move VM-level TDP MMU state to struct kvm
  KVM: x86/mmu: Move kvm_mmu_hugepage_adjust() up to fault handler
  KVM: x86/mmu: Pass root role to kvm_tdp_mmu_get_vcpu_root_hpa()
  KVM: Move page table cache to struct kvm_vcpu
  KVM: MMU: Move mmu_page_header_cache to common code
  KVM: MMU: Stub out tracepoints on non-x86 architectures
  KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}()
    together
  KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
  KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
  KVM: Allow range-based TLB invalidation from common code
  KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common code
  KVM: MMU: Move the TDP iterator to common code
  KVM: x86/mmu: Move tdp_mmu_max_gfn_exclusive() to tdp_pgtable.c
  KVM: x86/mmu: Move is_tdp_mmu_page() to mmu_internal.h
  KVM: MMU: Move the TDP MMU to common code

Jing Zhang (1):
  KVM: selftests: Stop assuming stats are contiguous in
    kvm_binary_stats_test

 MAINTAINERS                                   |   6 +-
 arch/arm64/include/asm/kvm_host.h             |   3 -
 arch/arm64/kvm/arm.c                          |  10 +-
 arch/arm64/kvm/mmu.c                          |   2 +-
 arch/mips/include/asm/kvm_host.h              |   3 -
 arch/mips/kvm/mips.c                          |  10 +-
 arch/mips/kvm/mmu.c                           |   4 +-
 arch/riscv/include/asm/kvm_host.h             |   3 -
 arch/riscv/kvm/mmu.c                          |   8 +-
 arch/riscv/kvm/vcpu.c                         |   4 +-
 arch/x86/include/asm/kvm/mmu_types.h          | 138 ++++++
 arch/x86/include/asm/kvm/tdp_pgtable.h        |  73 ++++
 arch/x86/include/asm/kvm_host.h               | 122 +-----
 arch/x86/include/asm/pgtable_types.h          |  12 +-
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/mmu.h                            |   5 -
 arch/x86/kvm/mmu/mmu.c                        | 409 +++++++++--------
 arch/x86/kvm/mmu/mmu_internal.h               | 221 ++--------
 arch/x86/kvm/mmu/mmutrace.h                   |  20 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  48 +-
 arch/x86/kvm/mmu/spte.c                       |   7 +-
 arch/x86/kvm/mmu/spte.h                       |  38 +-
 arch/x86/kvm/mmu/tdp_pgtable.c                | 183 ++++++++
 arch/x86/kvm/x86.c                            |  16 +-
 include/kvm/mmu.h                             |  21 +
 include/kvm/mmu_types.h                       | 179 ++++++++
 include/kvm/mmutrace.h                        |  17 +
 {arch/x86/kvm/mmu => include/kvm}/tdp_iter.h  |  19 +-
 {arch/x86/kvm/mmu => include/kvm}/tdp_mmu.h   |  17 +-
 include/kvm/tdp_pgtable.h                     |  39 ++
 include/linux/kvm_host.h                      |  36 +-
 include/linux/kvm_types.h                     |  17 +
 include/linux/mm_types.h                      |   9 +
 .../selftests/kvm/kvm_binary_stats_test.c     |  11 +-
 virt/kvm/Kconfig                              |   3 +
 virt/kvm/Makefile.kvm                         |   3 +
 virt/kvm/kvm_main.c                           |  27 +-
 {arch/x86 => virt}/kvm/mmu/tdp_iter.c         |  24 +-
 {arch/x86 => virt}/kvm/mmu/tdp_mmu.c          | 412 ++++++++----------
 40 files changed, 1245 insertions(+), 937 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm/mmu_types.h
 create mode 100644 arch/x86/include/asm/kvm/tdp_pgtable.h
 create mode 100644 arch/x86/kvm/mmu/tdp_pgtable.c
 create mode 100644 include/kvm/mmu.h
 create mode 100644 include/kvm/mmu_types.h
 create mode 100644 include/kvm/mmutrace.h
 rename {arch/x86/kvm/mmu => include/kvm}/tdp_iter.h (90%)
 rename {arch/x86/kvm/mmu => include/kvm}/tdp_mmu.h (87%)
 create mode 100644 include/kvm/tdp_pgtable.h
 rename {arch/x86 => virt}/kvm/mmu/tdp_iter.c (89%)
 rename {arch/x86 => virt}/kvm/mmu/tdp_mmu.c (84%)


base-commit: 89b2395859651113375101bb07cd6340b1ba3637
prerequisite-patch-id: 19dc9f47392d43a9a86c0e4f3ce1f13b62004eeb
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

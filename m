Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41669C63777
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E9B22222C
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="H73ISXjM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E9B22222C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7594B5D6;
	Tue, 17 Nov 2020 13:16:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zlTuALwkdScx; Tue, 17 Nov 2020 13:16:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D7DD4B601;
	Tue, 17 Nov 2020 13:16:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C77964B5DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uzbNqmDE-ulb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:20 -0500 (EST)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B5D64B5D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:20 -0500 (EST)
Received: by mail-qk1-f201.google.com with SMTP id t64so14722487qkd.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=4x2LPs+SVLChp+56gdHoWBr1y6qmTjYGgcctnhFKsXo=;
 b=H73ISXjMOGVV1w3bN1jGOFUiUY1yRfJ7AOCQXuOoODvokljw2HLFEN5+G9rTeK4xVQ
 VXDPG0olr7xSsDBmpit1p1vTjkFCBj36EsT2dRlNaWtGF5FcY85I4gkFpRu7u08zuVud
 5wOsR+OmSbpw5Rd9N2yadrUm7yKlp4dzBvrlC706Z2UssEbMifZzzTvFNPT8ull40jm/
 Mp2OrAkvIn5KnQqV7wpr6uhGzhKZUdifsJbQlrLaXfcmhVmbpQCnY2GFqI7DeuVvIJ0a
 ik6fE1aZ/Rgj7Wn0TXAg2fK49UYC7cq5nkUANKEJ+eVYpDDjlqtV65E67i/HISd7jeEd
 1Ccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=4x2LPs+SVLChp+56gdHoWBr1y6qmTjYGgcctnhFKsXo=;
 b=hLHcwlCHM9sovSM8DQoqqRFtxYPsA2sglc0vABa+tokisQibyq0lcrXoctvqPVFJ9/
 m6fQ9GKNtayZW15AEAMREyItefxbH5FaSDyeRs3gNqvNuJjpc1ouUt5X4NQldkvgXF/J
 t2qyNBNNN7JUq/r3LPojaWtD8nfIGoRdEmfFVzQiWysOqYhQW2A8iNJ5RmKNH1i2Gp12
 sZiub6qxbNliH4VpD3ZTCGJmSDnoxb9ieaW7Wfd1fWpv5uLUnZWYw1kAoSlIh8xm9EVe
 8GJOScSHYmEoo4KgLDooB2QDLPzr4Ea/S7eDAM85A26B2LDnOx50z+FHzQHzr+U4LDFD
 +ibw==
X-Gm-Message-State: AOAM531AJqjuCPcG7L+EhE7S02xDKLrw3/8XG2prsrYlxn+P9kdH+iNt
 yfbw5HeMWwXn1DA7fxTBNx65cTWVm8/+
X-Google-Smtp-Source: ABdhPJx8GBSOh7X/x/f3+0D0vrCA1gVP067PW6ywKbFjbKrFdmO63xQSY+G4mk1iJInpYT3Z/CtEUZb0Pssr
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:ad4:4a8a:: with SMTP id
 h10mr884248qvx.55.1605636979378; Tue, 17 Nov 2020 10:16:19 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:40 +0000
Message-Id: <20201117181607.1761516-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 00/27] KVM/arm64: A stage 2 for the host
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

Hi all,

This RFC series provides the infrastructure enabling to wrap the host
kernel with a stage 2 when running KVM in nVHE. This can be useful for
several use-cases, but the primary motivation is to (eventually) be able
to protect guest memory from the host kernel. More details about the
overall idea, design, and motivations can be found in Will's talk at KVM
Forum 2020 [1], or the pKVM talk at the Android uconf during LPC 2020
[2].

This series essentially gets us to a point where the 'VM' bit is set
in the host's HCR_EL2 when running in nVHE and if 'kvm-arm.protected'
is set on the kernel command line. The EL2 object directly handles
memory aborts from the host and manages entirely its stage 2 page table.

However, this series does _not_ provide any real user for this (yet)
and simply idmaps everything into the host stage 2 as RWX cacheable.
This is all about the infrastructure for now, so clearly not ready for
inclusion upstream yet (hence the RFC tag), but the bases are there and
I thought it'd be useful to start a discussion with the community early
as this is a rather intrusive change. So, here goes.

One of the interesting requirements that comes with the series is that
managing page-tables requires some sort of memory allocator at EL2 to
allocate, refcount and free memory pages. Clearly, none of that is
currently possible in nVHE, so a significant chunk of the series is
dedicated to solving that problem. The proposed EL2 memory allocator
mimics Linux' buddy system in principles, and re-uses some of the arm64
mm design choices. Specifically, it uses a vmemmap at EL2 which contains
a set of struct hyp_page entries to hold pages metadata. To support
this, I extended the EL2 object to make it manage its own stage 1
page-table in addition to host stage 2. This simplifies the hyp_vmemmap
creation and was going to be required anyway for the protected VM
use-case -- the threat model implies the host cannot be trusted after
boot, and it will thus be crucial to ensure it cannot map arbitrary code
at EL2.

The pool of memory pages used by the EL2 allocator are reserved by the
host early during boot (while it is still trusted) using the memblock
API, and are donated to EL2 during KVM init. The current assumption is
that the host reserves enough pages to allow the EL2 object to map all
of memory at page granularity for both hyp stage 1 and host stage 2,
plus some extra pages for device mappings.

On top of that the series introduces a few smaller features that are
needed along the way, but hopefully all of those are detailed properly
in the relevant commit messages.

And as a last note, I'd like to point out that there are at this point
trivial ways for the host to circumvent its stage 2 protection. It still
owns the guests stage 2 for example, meaning that nothing would prevent
a malicious host from using a guest as a proxy to access protected
memory, _yet_. This series lays the ground for future work to address
these things, which will clearly require a stage 2 over the host at some
point, so I just wanted to set the expectations right.

With all that in mind, the series is organized as follows:

 - patches 01-03 provide EL2 with some utility libraries needed for
   memory management and synchronization;

 - patches 04-09 mostly refactor smalls portions of the code to ease the
   EL2 memory management;

 - patches 10-17 add the actual EL2 memory management code, as well as
   the setup/bootstrap code on the KVM init path;

 - patches 18-24 refactor the existing stage 2 management code to make
   it re-usable from the EL2 object;

 - and finally patches 25-27 introduce the host stage 2 and the trap
   handling logic at EL2.

This work is based on the latest kvmarm/queue (which includes Marc's
host EL2 entry rework [3], as well as Will's guest vector refactoring
[4]) + David's PSCI proxying series [5].

And if you'd like a branch that has all the bits and pieces:

    https://android-kvm.googlesource.com/linux qperret/host-stage2

Boot-tested (host and guest) using qemu in VHE and nVHE, and on real
hardware on a AML-S905X-CC (Le Potato).

Thanks,
Quentin

[1] https://kvmforum2020.sched.com/event/eE24/virtualization-for-the-masses-exposing-kvm-on-android-will-deacon-google
[2] https://youtu.be/54q6RzS9BpQ?t=10859
[3] https://lore.kernel.org/kvmarm/20201109175923.445945-1-maz@kernel.org/
[4] https://lore.kernel.org/kvmarm/20201113113847.21619-1-will@kernel.org/
[5] https://lore.kernel.org/kvmarm/20201116204318.63987-1-dbrazdil@google.com/


Quentin Perret (24):
  KVM: arm64: Initialize kvm_nvhe_init_params early
  KVM: arm64: Avoid free_page() in page-table allocator
  KVM: arm64: Factor memory allocation out of pgtable.c
  KVM: arm64: Introduce a BSS section for use at Hyp
  KVM: arm64: Make kvm_call_hyp() a function call at Hyp
  KVM: arm64: Allow using kvm_nvhe_sym() in hyp code
  KVM: arm64: Introduce an early Hyp page allocator
  KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
  KVM: arm64: Introduce a Hyp buddy page allocator
  KVM: arm64: Enable access to sanitized CPU features at EL2
  KVM: arm64: Factor out vector address calculation
  of/fdt: Introduce early_init_dt_add_memory_hyp()
  KVM: arm64: Prepare Hyp memory protection
  KVM: arm64: Elevate Hyp mappings creation at EL2
  KVM: arm64: Use kvm_arch for stage 2 pgtable
  KVM: arm64: Use kvm_arch in kvm_s2_mmu
  KVM: arm64: Set host stage 2 using kvm_nvhe_init_params
  KVM: arm64: Refactor kvm_arm_setup_stage2()
  KVM: arm64: Refactor __load_guest_stage2()
  KVM: arm64: Refactor __populate_fault_info()
  KVM: arm64: Make memcache anonymous in pgtable allocator
  KVM: arm64: Reserve memory for host stage 2
  KVM: arm64: Sort the memblock regions list
  KVM: arm64: Wrap the host with a stage 2

Will Deacon (3):
  arm64: lib: Annotate {clear,copy}_page() as position-independent
  KVM: arm64: Link position-independent string routines into .hyp.text
  KVM: arm64: Add standalone ticket spinlock implementation for use at
    hyp

 arch/arm64/include/asm/cpufeature.h           |   1 +
 arch/arm64/include/asm/hyp_image.h            |   4 +
 arch/arm64/include/asm/kvm_asm.h              |  13 +-
 arch/arm64/include/asm/kvm_cpufeature.h       |  19 ++
 arch/arm64/include/asm/kvm_host.h             |  17 +-
 arch/arm64/include/asm/kvm_hyp.h              |   8 +
 arch/arm64/include/asm/kvm_mmu.h              |  69 +++++-
 arch/arm64/include/asm/kvm_pgtable.h          |  41 +++-
 arch/arm64/include/asm/sections.h             |   1 +
 arch/arm64/kernel/asm-offsets.c               |   3 +
 arch/arm64/kernel/cpufeature.c                |  14 +-
 arch/arm64/kernel/image-vars.h                |  35 +++
 arch/arm64/kernel/vmlinux.lds.S               |   7 +
 arch/arm64/kvm/arm.c                          | 136 +++++++++--
 arch/arm64/kvm/hyp/Makefile                   |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  36 +--
 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h |  14 ++
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |  32 +++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  33 +++
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  55 +++++
 arch/arm64/kvm/hyp/include/nvhe/mm.h          | 107 +++++++++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  95 ++++++++
 arch/arm64/kvm/hyp/include/nvhe/util.h        |  25 ++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   9 +-
 arch/arm64/kvm/hyp/nvhe/cache.S               |  13 ++
 arch/arm64/kvm/hyp/nvhe/cpufeature.c          |   8 +
 arch/arm64/kvm/hyp/nvhe/early_alloc.c         |  60 +++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |  39 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  50 ++++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S             |   1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 191 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 175 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 185 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          |   7 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 214 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/stub.c                |  22 ++
 arch/arm64/kvm/hyp/nvhe/switch.c              |  12 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  98 ++++----
 arch/arm64/kvm/hyp/reserved_mem.c             |  95 ++++++++
 arch/arm64/kvm/mmu.c                          | 114 +++++++++-
 arch/arm64/kvm/reset.c                        |  42 +---
 arch/arm64/lib/clear_page.S                   |   4 +-
 arch/arm64/lib/copy_page.S                    |   4 +-
 arch/arm64/mm/init.c                          |   3 +
 drivers/of/fdt.c                              |   5 +
 46 files changed, 1971 insertions(+), 151 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_cpufeature.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/gfp.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/memory.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mm.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/util.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/cpufeature.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/early_alloc.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/mem_protect.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/mm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/page_alloc.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/setup.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/stub.c
 create mode 100644 arch/arm64/kvm/hyp/reserved_mem.c

-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

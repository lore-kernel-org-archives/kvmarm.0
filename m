Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECC8C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74F6C64F39
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74F6C64F39
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA3404B632;
	Tue,  2 Mar 2021 10:00:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yt+vl-jmmzha; Tue,  2 Mar 2021 10:00:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79DBE4B646;
	Tue,  2 Mar 2021 10:00:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E7774B63C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jon2Sr9LM2+E for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:07 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86F414B62B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:07 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id z6so2518030wrh.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=8cdx2cy8bS1Yk1hOvoxJoIxgvMKS4vuWA9cIA1RP624=;
 b=YjzVe3TPmAvkQCDj/HWux0EV0FszWglzZrY/X7sQ4PP1pehQ7BRIGiVyN3MLlMr3li
 huvMmx5Y3nArbKhf91/o25rYsgIu4x+kp2oJMolgK94RuxqGkONc30xK6IKkPeKdw+az
 7Vctx4VxHYaXaENho0mlZ7QiMu85gh+Sh420ulaF3seaMGn2jIvBd8X8e+MqGmxTd2M6
 1X5vt1fRx59Pb9zdTuS+WO8mkN0JUh4Cwzw9IM1gJ8xOhx9fWpOVEMqhRoA6KH8bDNf6
 983WHMNuHeka5//hhYLYRrnsFZTkhhkGTnt5avmFO0K6/pTikDHYzM+l7KGykdTBPC8e
 FkSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=8cdx2cy8bS1Yk1hOvoxJoIxgvMKS4vuWA9cIA1RP624=;
 b=HR9ZeKZ/kNPBkorfpdER2aBGskeij5yvBbBM2jiGDrgauQXBpjLh2OVzAQJ5ajHnqn
 pHzbORgQIYLKQbp8Ikeh42Uyzz6JC8zPDfac5Rq5A44y1TtIand1vlP8gjQxgYLdf8J2
 RSBtw4poxuirXxSw1iQ0/vKjnQEVbG8wDkph1XERNUkh6hO7SYt75MqzngtWvW6bKlov
 8mZZiCOvOhWZm+U03zBuuz+Ig9P/4wVeqhTD6PufEhw6LBxY8c1Ke2DM4yooN8IujEgj
 bvF1Nl0WuyFsVAhUGleX7MOaxO+VD1Yf7EcmUSYVuQmCg9DTzUdQileGh1hUn/ZvwNDU
 Yd0A==
X-Gm-Message-State: AOAM533VQTBFTVSTamWg5Rtf51hIlk3sWC/cy9ac4dWgB1U2WZ2ipxCF
 hGiomyW7tjJ6m2JK5da4UrPoJJvVyiJa
X-Google-Smtp-Source: ABdhPJwDCkMLeCoT4sUtiPOZrUAgJEKZ4OzzcKOcwzE3U3mmOILtARNPs12yHIt3Rzw7l59VN19/YF8Gf5Xv
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:f006:: with SMTP id
 a6mr4583157wmb.166.1614697206272; Tue, 02 Mar 2021 07:00:06 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:30 +0000
Message-Id: <20210302150002.3685113-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 00/32] KVM: arm64: A stage 2 for the host
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

This is the v3 of the series previously posted here:

  https://lore.kernel.org/kvmarm/20201117181607.1761516-1-qperret@google.com/

This basically allows us to wrap the host with a stage 2 when running in
nVHE, hence paving the way for protecting guest memory from the host in
the future (among other use-cases). For more details about the
motivation and the design angle taken here, I would recommend to have a
look at the cover letter of v1, and/or to watch these presentations at
LPC [1] and KVM forum 2020 [2].

V3 includes a bunch of clean-ups and small refactorings all over the
place as well as a few new features. Specifically, this now allows us to
remove memory pages from the host stage 2 cleanly, and this series does
so for all the .hyp memory sections (which has uncovered existing bugs
upstream and in v2 of this series -- see [3] and [4]). This also now
makes good use of block mappings whenever that is possible, and has
gotten a bit more testing on real hardware (which helped uncover other
bugs [5]).

The other changes to v3 include:

 - clean-ups, refactoring and extra comments all over the place (Will);

 - dropped fdt hook in favor of memblock API now that the relevant
   patches ([6]) are merged (Rob);

 - moved the CPU feature copy stuff to __init/__initdata (Marc);

 - fixed FWB support (Mate);

 - rebased on v5.12-rc1.

This series depends on Will's vCPU context fix ([5]) and Marc's PMU
fixes ([7]). And here's a branch with all the goodies applied:

  https://android-kvm.googlesource.com/linux qperret/host-stage2-v3

Thanks,
Quentin

[1] https://youtu.be/54q6RzS9BpQ?t=10859
[2] https://youtu.be/wY-u6n75iXc
[3] https://lore.kernel.org/kvmarm/20210203141931.615898-1-qperret@google.com/
[4] https://lore.kernel.org/kvmarm/20210128173850.2478161-1-qperret@google.com/
[5] https://lore.kernel.org/kvmarm/20210226181211.14542-1-will@kernel.org/
[6] https://lore.kernel.org/lkml/20210115114544.1830068-1-qperret@google.com/
[7] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-undef-NV


Quentin Perret (29):
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
  KVM: arm64: Prepare the creation of s1 mappings at EL2
  KVM: arm64: Elevate hypervisor mappings creation at EL2
  KVM: arm64: Use kvm_arch for stage 2 pgtable
  KVM: arm64: Use kvm_arch in kvm_s2_mmu
  KVM: arm64: Set host stage 2 using kvm_nvhe_init_params
  KVM: arm64: Refactor kvm_arm_setup_stage2()
  KVM: arm64: Refactor __load_guest_stage2()
  KVM: arm64: Refactor __populate_fault_info()
  KVM: arm64: Make memcache anonymous in pgtable allocator
  KVM: arm64: Reserve memory for host stage 2
  KVM: arm64: Sort the hypervisor memblocks
  KVM: arm64: Introduce PROT_NONE mappings for stage 2
  KVM: arm64: Refactor stage2_map_set_prot_attr()
  KVM: arm64: Add kvm_pgtable_stage2_idmap_greedy()
  KVM: arm64: Wrap the host with a stage 2
  KVM: arm64: Page-align the .hyp sections
  KVM: arm64: Disable PMU support in protected mode
  KVM: arm64: Protect the .hyp sections from the host

Will Deacon (3):
  arm64: lib: Annotate {clear,copy}_page() as position-independent
  KVM: arm64: Link position-independent string routines into .hyp.text
  arm64: kvm: Add standalone ticket spinlock implementation for use at
    hyp

 arch/arm64/include/asm/cpufeature.h           |   1 +
 arch/arm64/include/asm/hyp_image.h            |   7 +
 arch/arm64/include/asm/kvm_asm.h              |   9 +
 arch/arm64/include/asm/kvm_cpufeature.h       |  19 ++
 arch/arm64/include/asm/kvm_host.h             |  19 +-
 arch/arm64/include/asm/kvm_hyp.h              |   8 +
 arch/arm64/include/asm/kvm_mmu.h              |  23 +-
 arch/arm64/include/asm/kvm_pgtable.h          | 117 ++++++-
 arch/arm64/include/asm/sections.h             |   1 +
 arch/arm64/kernel/asm-offsets.c               |   3 +
 arch/arm64/kernel/cpufeature.c                |  13 +
 arch/arm64/kernel/image-vars.h                |  30 ++
 arch/arm64/kernel/vmlinux.lds.S               |  74 +++--
 arch/arm64/kvm/arm.c                          | 199 ++++++++++--
 arch/arm64/kvm/hyp/Makefile                   |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  37 ++-
 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h |  14 +
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |  55 ++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  36 +++
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  52 +++
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  92 ++++++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  92 ++++++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   9 +-
 arch/arm64/kvm/hyp/nvhe/cache.S               |  13 +
 arch/arm64/kvm/hyp/nvhe/cpufeature.c          |   8 +
 arch/arm64/kvm/hyp/nvhe/early_alloc.c         |  54 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |  46 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  69 ++++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S             |   1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 235 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 173 ++++++++++
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 195 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          |   4 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 212 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/stub.c                |  22 ++
 arch/arm64/kvm/hyp/nvhe/switch.c              |  12 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                  | 298 ++++++++++++++----
 arch/arm64/kvm/hyp/reserved_mem.c             | 113 +++++++
 arch/arm64/kvm/mmu.c                          | 115 ++++++-
 arch/arm64/kvm/perf.c                         |   3 +-
 arch/arm64/kvm/pmu.c                          |   8 +-
 arch/arm64/kvm/reset.c                        |  42 +--
 arch/arm64/kvm/sys_regs.c                     |  21 ++
 arch/arm64/lib/clear_page.S                   |   4 +-
 arch/arm64/lib/copy_page.S                    |   4 +-
 arch/arm64/mm/init.c                          |   3 +
 47 files changed, 2356 insertions(+), 215 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_cpufeature.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/gfp.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/memory.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mm.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

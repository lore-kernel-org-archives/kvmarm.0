Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51926C4727E
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95E572376F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="K83wTisr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95E572376F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C329B4B319;
	Tue, 22 Sep 2020 16:49:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yELZ-PFBEgF6; Tue, 22 Sep 2020 16:49:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93B7F4B2F4;
	Tue, 22 Sep 2020 16:49:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 829694B226
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oYJxTg3T4YUN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:15 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BD4B4B168
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:15 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id a9so4759798wmm.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Ih3O4/69tbNzYNtuvvMQexZCyfb110eF4LQYqz6A1a8=;
 b=K83wTisrAwlvmXTXomdfwfYdR+KKAheFXSQTxKIbaWO6fOX4sYgYKapzMoywaaExyq
 dC8tlcfiLPZLpkLyIblwjbkrnEIc1wFb0FkMdzWZfiIFeeAOp54t+KpGAf82sTmDmlsd
 QjuOwQ2R6W5pm/EN+1c/yu8dVdvZjYV+GCgQYVqyBcikz21Fub3hwgYhYSOvggWN6EMb
 1Wmm4/oFqPQyyxn+fLfSBJ0TnzGXN5UfNimIYp8kAzjMm09iBdavlR0occ4iMOZJzbGY
 4UerOmaCAvVJIusPngbCOfuUyLIj4Q/Nvxos9mgojwGSF28QsBG2PbxePqjmuuryLygG
 duOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Ih3O4/69tbNzYNtuvvMQexZCyfb110eF4LQYqz6A1a8=;
 b=sEmoTAOajbGkgi1Pl03aCJkMBybNP10T159dqpNDGc9M5aLacnhc5iBXN4W62b0p2P
 H8Ni/O9wBv5/g22JVkBxywGY4ERyx+3lzhvQWMlhILgTrcAuJ2MndxsuZk4R62jR4fyV
 1ElXjmXtGgfrPFZCn7hL3/H84WQwKIXBj/MwEqk56QWSebc7AHPqX1prL4BgvY/Aje7u
 ts35npra22fC87HsaHxf8/TRK632wcwzO3Zb2OfFB0kGoKXD+0eZhM9+d+SjPxdl9i3F
 TV/Sjxz6FrZ2Skl5tiTdqV3qlL1sgXyomLufQpka4+mNYLY/nZsPuT+Loy9cJIHiAXWI
 sOwA==
X-Gm-Message-State: AOAM530OURfKTPT3UtxcJ9c16gEEptjLmr+DfxiN5ikaAmlo8yuu4JiW
 KPYLnk8VczbDerXZaxIjD0PUlpd4wIoNQNqq
X-Google-Smtp-Source: ABdhPJzF5MdHkN30rMxhM08Dll+pFjuoVo1hfpDDj1pyl+exwrIuUkJQyF/Ca4oAKOpWlwnK0WAGXA==
X-Received: by 2002:a7b:c749:: with SMTP id w9mr2705330wmk.29.1600807753779;
 Tue, 22 Sep 2020 13:49:13 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id y1sm5745394wma.36.2020.09.22.13.49.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:13 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 00/10] Independent per-CPU data section for nVHE
Date: Tue, 22 Sep 2020 21:49:00 +0100
Message-Id: <20200922204910.7265-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Introduce '.hyp.data..percpu' as part of ongoing effort to make nVHE
hyp code self-contained and independent of the rest of the kernel.

Main benefits:
 * independent nVHE per-CPU data section that can be unmapped from host,
 * more robust linking of nVHE hyp code,
 * no need for hyp-specific macros to access per-CPU variables.

The series is structured as follows:

 - patch 1: Improve existing hyp build rules. This could be sent and merged
    independently of per-CPU but this series builds on it.

 - patches 2-3: Minor cleanups.

 - patches 4-5: Replace hyp helpers for accessing per-CPU variables
     with common helpers modified to work correctly in hyp. Per-CPU
     variables can now be accessed with one API anywhere.

 - patches 6-8: Where VHE and nVHE use per-CPU variables defined in
     kernel proper, move their definitions to hyp/ where they are
     duplicated and owned by VHE/nVHE, respectively. Non-VHE hyp code
     now refers only to per-CPU variables defined in its source files.
     Helpers are added so that kernel proper can continue to access
     nVHE hyp variables, same way as it does with other nVHE symbols.

 - patches 9-10: Introduce '.hyp.data..percpu' ELF section and allocate
     memory for every CPU core during KVM init. All nVHE per-CPU state
     is now grouped together in ELF and in memory. Introducing a new
     per-CPU variable does not require adding new memory mappings any
     more. nVHE hyp code cannot accidentally refer to kernel-proper
     per-CPU data as it only has the pointer to its own per-CPU memory.

Patches are rebased on v5.9-rc6 and available in branch 'topic/percpu-v4' at:
    https://android-kvm.googlesource.com/linux

For maintainers: In case of interest, there are patches that remove the need
for redefining macros under DEBUG_PREEMPT available at the same repo, branch
'topic/percpu-v3-debug-preempt'. Since they are non-trivial, I am not going
to post them here so late in the 5.10 window. I plan to post them for 5.11
when they will also be useful for other patches.

Changes v3 -> v4:
 * Drop patch that marked pages allocated for hyp reserved
 * Copy arm64_ssbd_callback_required at cpu_init_hyp_mode
 * Use read_sysreg in __hyp_my_cpu_offset
 * Simplify per-CPU region allocation code
 * Use same subsection name regex as other kernel linker scripts
 * Rename helper per-CPU macros
 * Add .gitignore for hyp linker script

Changes v2 -> v3:
 * Use PERCPU_INPUT in hyp.ld instead of modifying PERCPU_SECTION
 * Only pass linker script once to LD (fix error message)
 * Renamed '.hyp.o' to '.nvhe.o'
 * Use __KVM_VHE_HYPERVISOR__ to select TPIDR_EL2 instead of alternatives
 * Move all prefixing-related macros to hyp_image.h

Changes v1 -> v2:
 * partially link hyp code, add linker script

David Brazdil (10):
  kvm: arm64: Partially link nVHE hyp code, simplify HYPCOPY
  kvm: arm64: Move nVHE hyp namespace macros to hyp_image.h
  kvm: arm64: Only define __kvm_ex_table for CONFIG_KVM
  kvm: arm64: Remove __hyp_this_cpu_read
  kvm: arm64: Remove hyp_adr/ldr_this_cpu
  kvm: arm64: Add helpers for accessing nVHE hyp per-cpu vars
  kvm: arm64: Duplicate arm64_ssbd_callback_required for nVHE hyp
  kvm: arm64: Create separate instances of kvm_host_data for VHE/nVHE
  kvm: arm64: Set up hyp percpu data for nVHE
  kvm: arm64: Remove unnecessary hyp mappings

 arch/arm64/include/asm/assembler.h        | 29 +++++---
 arch/arm64/include/asm/hyp_image.h        | 36 ++++++++++
 arch/arm64/include/asm/kvm_asm.h          | 82 +++++++++++------------
 arch/arm64/include/asm/kvm_host.h         |  2 +-
 arch/arm64/include/asm/kvm_mmu.h          | 22 ++----
 arch/arm64/include/asm/percpu.h           | 28 +++++++-
 arch/arm64/kernel/image-vars.h            |  4 --
 arch/arm64/kernel/vmlinux.lds.S           | 13 ++++
 arch/arm64/kvm/arm.c                      | 61 +++++++++++++----
 arch/arm64/kvm/hyp/hyp-entry.S            |  2 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   |  8 +--
 arch/arm64/kvm/hyp/nvhe/.gitignore        |  2 +
 arch/arm64/kvm/hyp/nvhe/Makefile          | 60 +++++++++--------
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S         | 19 ++++++
 arch/arm64/kvm/hyp/nvhe/switch.c          |  8 ++-
 arch/arm64/kvm/hyp/vhe/switch.c           |  5 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |  4 +-
 arch/arm64/kvm/pmu.c                      | 13 ++--
 19 files changed, 272 insertions(+), 130 deletions(-)
 create mode 100644 arch/arm64/include/asm/hyp_image.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/.gitignore
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp.lds.S

--
2.28.0.681.g6f77f65b4e-goog
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A10C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 09:17:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94CDF206C0
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 09:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="APLmMrE9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94CDF206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF1AE4B212;
	Thu,  3 Sep 2020 05:17:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pH+oaUejy+fn; Thu,  3 Sep 2020 05:17:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA09A4B210;
	Thu,  3 Sep 2020 05:17:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEE5D4B20B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 05:17:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4XRR70soOJzX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 05:17:35 -0400 (EDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com
 [209.85.218.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA46A4B200
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 05:17:35 -0400 (EDT)
Received: by mail-ej1-f53.google.com with SMTP id i22so2831436eja.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 02:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=ybBiP+e417RFA7nMR4Bu7V33eb9o8gA61OetpUfftkQ=;
 b=APLmMrE9eEbfLFqGCI1U6UkzQSGgJVYT4fP69U8vY4IlnhXbOnr9RQuoxMki8HmaZ2
 hKKQGLreepg4yFdemEkt4tTzSK31vCuqaa+W9k2u/u9b4F7KVEas6PBuxUVrrIHd7zV/
 83k8qYFhmmAueuH8UbIKhI4d0y51jhHFNYF7MZibLhrowrX7RKs0qA4jpeEV+fLRSHa3
 LAkXEcSV6ctzyXlOPMd8Fc3wo9JJkJ6bwRk4wjYBhBa2pCVPkGdRYlRATOUWBEXYu1ud
 il6iZjUzLeM46Wwbgu3Qmmqltj3yRYqjHzSmkJyqufbPD/tdNc6KSK7+lqX0f2abBSob
 J2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=ybBiP+e417RFA7nMR4Bu7V33eb9o8gA61OetpUfftkQ=;
 b=uKPHCHCCLXk/+4yTDOmutWESwUG3z9s7CnoUFal5woSJtg6RbVhLja+L4acQ7xFgK6
 gdT6nwl7VcXczjFiiIzOs25iIP3mDMsLTrbiJFlyYaGteZl4FSHhbXTW6oSqOxAOEtY1
 uSC7jxDqiLIXKMZjTqwmq04ukh/6/GyIrL2aPMe/y8LSC5Aogzvk1/UdCaEnEXWQuVRx
 R+5qeBBeYOYZlVFeZtO/ZDwixer/jXer8urSDCHTSg4HKxPr3R4O8nlMT4n0NLgUxVDX
 ONgo0KDS45Y3Bl6mtLoaaXOwQI83Kr17bg74J0yBkznBd6JSdtwtLuAQnyJPURKGlwwH
 y83Q==
X-Gm-Message-State: AOAM532zcpVlxyqzOS25cgydXmnwP7oBH/Tem6S7YJWCTOEd9BFOIPhx
 83W8k1HQb9hrjE26GhIANmkq6w==
X-Google-Smtp-Source: ABdhPJys1SWvJYPNpq0WObC+uy+nfuWZtybUHYnPbVexD1i1iV/lX+1rXLt1ldV/IBiG+6LOepfP3w==
X-Received: by 2002:a17:906:a116:: with SMTP id
 t22mr1160350ejy.353.1599124654241; 
 Thu, 03 Sep 2020 02:17:34 -0700 (PDT)
Received: from localhost
 (dynamic-2a00-1028-919a-a06e-64ac-0036-822c-68d3.ipv6.broadband.iol.cz.
 [2a00:1028:919a:a06e:64ac:36:822c:68d3])
 by smtp.gmail.com with ESMTPSA id x10sm2414585eds.21.2020.09.03.02.17.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Sep 2020 02:17:33 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 00/10] Independent per-CPU data section for nVHE
Date: Thu,  3 Sep 2020 11:17:02 +0200
Message-Id: <20200903091712.46456-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

The series builds on top of the "Split off nVHE hyp code" series which
used objcopy to rename '.text' to '.hyp.text' and prefix all ELF
symbols with '__kvm_nvhe' for all object files under kvm/hyp/nvhe.

The series is structured as follows:

 - patch 1: Modify generic PERCPU_* linker script macros to make it
     possible to define multiple per-CPU ELF sections with prefixed
     section and symbol names.

 - patch 2: Improve existing hyp build rules. This could be sent and merged
    independently of per-CPU but this series builds on it.

 - patches 3-4: Replace hyp helpers for accessing per-CPU variables
     with common helpers modified to work correctly in hyp. Per-CPU
     variables can now be accessed with one API anywhere.

 - patches 5-7: Where VHE and nVHE use per-CPU variables defined in
     kernel proper, move their definitions to hyp/ where they are
     duplicated and owned by VHE/nVHE, respectively. Non-VHE hyp code
     now refers only to per-CPU variables defined in its source files.
     Helpers are added so that kernel proper can continue to access
     nVHE hyp variables, same way as it does with other nVHE symbols.

 - patches 8-10: Introduce '.hyp.data..percpu' ELF section and allocate
     memory for every CPU core during KVM init. All nVHE per-CPU state
     is now grouped together in ELF and in memory. Introducing a new
     per-CPU variable does not require adding new memory mappings any
     more. nVHE hyp code cannot accidentally refer to kernel-proper
     per-CPU data as it only has the pointer to its own per-CPU memory.

Patches are rebased on v5.9-rc3 and available in branch 'topic/percpu-v2' at:
    https://android-kvm.googlesource.com/linux

Changes v1 -> v2:
  * 5.9-rc3 base
  * partially link hyp code, add linker script

David Brazdil (10):
  Macros to override naming of percpu symbols and sections
  kvm: arm64: Partially link nVHE hyp code, simplify HYPCOPY
  kvm: arm64: Remove __hyp_this_cpu_read
  kvm: arm64: Remove hyp_adr/ldr_this_cpu
  kvm: arm64: Add helpers for accessing nVHE hyp per-cpu vars
  kvm: arm64: Duplicate arm64_ssbd_callback_required for nVHE hyp
  kvm: arm64: Create separate instances of kvm_host_data for VHE/nVHE
  kvm: arm64: Mark hyp stack pages reserved
  kvm: arm64: Set up hyp percpu data for nVHE
  kvm: arm64: Remove unnecessary hyp mappings

 arch/arm64/include/asm/assembler.h        |  27 ++++--
 arch/arm64/include/asm/kvm_asm.h          |  74 ++++++++-------
 arch/arm64/include/asm/kvm_host.h         |   2 +-
 arch/arm64/include/asm/kvm_mmu.h          |  23 ++---
 arch/arm64/include/asm/percpu.h           |  33 ++++++-
 arch/arm64/include/asm/sections.h         |   1 +
 arch/arm64/kernel/image-vars.h            |   2 -
 arch/arm64/kernel/vmlinux.lds.S           |  10 ++
 arch/arm64/kvm/arm.c                      | 110 ++++++++++++++++++----
 arch/arm64/kvm/hyp/hyp-entry.S            |   2 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   |   8 +-
 arch/arm64/kvm/hyp/nvhe/Makefile          |  56 +++++------
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S         |  19 ++++
 arch/arm64/kvm/hyp/nvhe/switch.c          |   8 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |   5 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |   4 +-
 arch/arm64/kvm/pmu.c                      |  13 ++-
 include/asm-generic/vmlinux.lds.h         |  40 +++++---
 19 files changed, 304 insertions(+), 137 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp.lds.S

--
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

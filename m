Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B6BC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:17:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5A2423B45
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:17:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5A2423B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 170FC4B2F6;
	Wed,  9 Dec 2020 08:17:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xWVLL75y7Um7; Wed,  9 Dec 2020 08:17:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 121F44B2EF;
	Wed,  9 Dec 2020 08:17:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E91A4B2D1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:17:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T0ZsPrZYIBlM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:17:51 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C362C4B228
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:17:51 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id a12so1701430wrv.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=QypmxVIIHfEpkRMXwz8jV9VsRXxLaN9Gc9MoWcFoJN0=;
 b=kn2qu9K6MOj2MXP522yIjJX7A97Hyx0Phr4xxfxonQ/CMS6ng7WChR5TEVRC/jU2Su
 QLDFFAMueBgyOZhIR07ndwQHRYzcAX4yJrUz2OCRVGpilBOzkQhlaLAaABKKbaOo2VEF
 vm89uw1HvqgH3laEQB7NJVxW/XObdLyra7NrslCf0vlFxqx2u7jdJNb7iV0jOZQSbq2Y
 d0vs+Dms5KmvwpkpRnRmDFhmF3eaZc7BPFquhJnN6ii8hgGK1fH3IELu7Upqef2nN15l
 lc04nXOiIITjkqdBMmjhqITcQracKHbhw499CO72Uc3kCIH/DtWhayfxko85ipVEYdo/
 ehqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=QypmxVIIHfEpkRMXwz8jV9VsRXxLaN9Gc9MoWcFoJN0=;
 b=Oip+wfvUC5xbPN0U7w9rJygW6hH1qsfWsvnjH3BY+ycnoWxpa3JTIg2xbuu1pBeE8C
 5i9btHeXf/XSoKjU6dVg30hphQ0/Yx6avB4sK+Ej0EKz7EXbL2XB/oN3/U7UvfH84CJ3
 1Pp1yj40CnqOXGpi4Tc195iRdHJ9JaivAmG3VgSZwpnPjRmEeHGy2ZytrgDIQvypwH+1
 SHivBqtBy0QCfUvib0xTA/K4QfZBNI3++khYKEwvVvWXiArQ0X/Y47uEVb36/GZNx3E9
 UHoOicwOR7DXL1rlxnHXdSaRmoMkSonRJpDTmmE3vb8x4pkSVPmoQuAGrRfoHRYrurI0
 DgWw==
X-Gm-Message-State: AOAM533EntSAnpfMDKwr5gAZdl+ndOuGjZqMezmSNamMzgX9IJKfhcdv
 pU7Uo1DJ5Mv5EUwCiZpubyDBUrABC3XpQg==
X-Google-Smtp-Source: ABdhPJxePgQkSVZVEUA4FZYzEF3UdagWSgDgT9hXezo4LvnwaZ1NClGbAw10690t+P/fIDVPZfv+0Q==
X-Received: by 2002:adf:97db:: with SMTP id t27mr2599398wrb.375.1607519870252; 
 Wed, 09 Dec 2020 05:17:50 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id d187sm3644642wmd.8.2020.12.09.05.17.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 05:17:48 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/9] KVM: arm64: Relocate absolute hyp VAs
Date: Wed,  9 Dec 2020 13:17:37 +0000
Message-Id: <20201209131746.85622-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

nVHE hyp code is linked into the same kernel binary but executes under
different memory mappings. If the compiler of hyp code chooses absolute
addressing for accessing a symbol, the kernel linker will relocate that
address to a kernel image virtual address, causing a runtime exception.

So far the strategy has been to force PC-relative addressing by wrapping
all symbol references with the hyp_symbol_addr macro. This is error
prone and developer unfriendly.

The series adds a new build-time step for nVHE hyp object file where
positions targeted by R_AARCH64_ABS64 relocations are enumerated and
the information stored in a separate ELF section in the kernel image.
At runtime, the kernel first relocates all absolute addresses to their
actual virtual offset (eg. for KASLR), and then addresses listed in this
section are converted to hyp VAs.

The RFC of this series did not have a build-time step and instead relied
on filtering dynamic relocations at runtime. That approach does not work
if the kernel is built with !CONFIG_RELOCATABLE, hence an always-present
set of relocation positions was added.

The series is based on the current kvmarm/next (commit 3a514592b6) and
structured as follows:
  * patch 1 is Jamie's fix of .hyp.data..percpu alignment; already in
    master, not yet in kvmarm/next; included to avoid merge conflicts
  * patches 2-3 make sure that all sections referred to by hyp code are
    handled by the hyp linker script and prefixed with .hyp so they can
    be identified by the build-time tool
  * patches 4-6 contain the actual changes to identify and relocate VAs
  * patches 7-8 fix existing code that assumes kernel VAs
  * patch 9 removes the (now redundant) hyp_symbol_addr

The series is also available at:
  https://android-kvm.googlesource.com/linux topic/hyp-reloc_v1

-David

David Brazdil (8):
  KVM: arm64: Rename .idmap.text in hyp linker script
  KVM: arm64: Set up .hyp.rodata ELF section
  KVM: arm64: Add symbol at the beginning of each hyp section
  KVM: arm64: Generate hyp relocation data
  KVM: arm64: Apply hyp relocations at runtime
  KVM: arm64: Fix constant-pool users in hyp
  KVM: arm64: Remove patching of fn pointers in hyp
  KVM: arm64: Remove hyp_symbol_addr

Jamie Iles (1):
  KVM: arm64: Correctly align nVHE percpu data

 arch/arm64/configs/defconfig             |   1 +
 arch/arm64/include/asm/hyp_image.h       |  29 +-
 arch/arm64/include/asm/kvm_asm.h         |  20 --
 arch/arm64/include/asm/kvm_mmu.h         |  61 ++---
 arch/arm64/include/asm/sections.h        |   3 +-
 arch/arm64/kernel/image-vars.h           |   1 -
 arch/arm64/kernel/smp.c                  |   4 +-
 arch/arm64/kernel/vmlinux.lds.S          |  18 +-
 arch/arm64/kvm/arm.c                     |   7 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h  |   4 +-
 arch/arm64/kvm/hyp/nvhe/Makefile         |  28 +-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c     | 326 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/host.S           |  29 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S       |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       |  11 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c        |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S        |  14 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     |  24 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |   2 +-
 arch/arm64/kvm/va_layout.c               |  34 ++-
 20 files changed, 495 insertions(+), 129 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c

--
2.29.2.576.ga3fc446d84-goog
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH roundup 0/4] extend VA range of ID map for core kernel and KVM
Date: Fri,  6 Mar 2015 15:34:38 +0100
Message-ID: <1425652482-31411-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 212FA47BB8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:29:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hKv6nG9LDIwo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 09:28:56 -0500 (EST)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08E7E47A40
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:28:55 -0500 (EST)
Received: by wiwl15 with SMTP id l15so3834394wiw.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Mar 2015 06:35:02 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, arnd@arndb.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

These are the VA range patches presented as a coherent set. The bounce page
and 'HYP init code too big' error are probably not prerequisites anymore now
that I switched from merging the HYP runtime map with the HYP id map rather
than the kernel ID map, but I would strongly prefer to keep it as a single
series.

Ard Biesheuvel (3):
  arm64: mm: increase VA range of identity map
  ARM, arm64: kvm: get rid of the bounce page
  arm64: KVM: use ID map with increased VA range if required

Arnd Bergmann (1):
  ARM: KVM: avoid "HYP init code too big" error

 arch/arm/include/asm/kvm_mmu.h         | 10 +++++
 arch/arm/kernel/vmlinux.lds.S          | 35 ++++++++++++++---
 arch/arm/kvm/init.S                    |  3 ++
 arch/arm/kvm/mmu.c                     | 69 +++++++++++++++-------------------
 arch/arm64/include/asm/kvm_mmu.h       | 33 ++++++++++++++++
 arch/arm64/include/asm/mmu_context.h   | 43 +++++++++++++++++++++
 arch/arm64/include/asm/page.h          |  6 ++-
 arch/arm64/include/asm/pgtable-hwdef.h |  7 +++-
 arch/arm64/kernel/head.S               | 38 +++++++++++++++++++
 arch/arm64/kernel/smp.c                |  1 +
 arch/arm64/kernel/vmlinux.lds.S        | 18 ++++++---
 arch/arm64/kvm/hyp-init.S              | 26 +++++++++++++
 arch/arm64/mm/mmu.c                    |  7 +++-
 arch/arm64/mm/proc-macros.S            | 11 ++++++
 arch/arm64/mm/proc.S                   |  3 ++
 15 files changed, 256 insertions(+), 54 deletions(-)

-- 
1.8.3.2

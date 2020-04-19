Return-Path: <SRS0=Mx9U=6D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D3AC54F70
	for <kvmarm@archiver.kernel.org>; Sun, 19 Apr 2020 09:38:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7F3A21D82
	for <kvmarm@archiver.kernel.org>; Sun, 19 Apr 2020 09:38:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7F3A21D82
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 711A24B23F;
	Sun, 19 Apr 2020 05:38:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nd4MbsZoKhzc; Sun, 19 Apr 2020 05:38:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73E794B11D;
	Sun, 19 Apr 2020 05:38:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CAE84B192
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Apr 2020 03:51:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lWpr2gK234IW for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Apr 2020 03:51:14 -0400 (EDT)
Received: from out30-44.freemail.mail.aliyun.com
 (out30-44.freemail.mail.aliyun.com [115.124.30.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1C7C4B18B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Apr 2020 03:51:13 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=37; SR=0;
 TI=SMTPD_---0Tvyj7uz_1587282667; 
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0Tvyj7uz_1587282667) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 19 Apr 2020 15:51:07 +0800
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To: pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
 mpe@ellerman.id.au, benh@kernel.crashing.org, borntraeger@de.ibm.com,
 frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
 heiko.carstens@de.ibm.com, gor@linux.ibm.com,
 sean.j.christopherson@intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
Subject: [PATCH 0/7] clean up redundant 'kvm_run' parameters
Date: Sun, 19 Apr 2020 15:50:59 +0800
Message-Id: <20200419075106.16248-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
X-Mailman-Approved-At: Sun, 19 Apr 2020 05:38:13 -0400
Cc: linux-s390@vger.kernel.org, tianjia.zhang@linux.alibaba.com,
 kvm@vger.kernel.org, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
structure. Earlier than historical reasons, many kvm-related function
parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
This patch does a unified cleanup of these remaining redundant parameters.

This series of patches has completely cleaned the architecture of
arm64, mips, ppc, and s390 (no such redundant code on x86). Due to
the large number of modified codes, a separate patch is made for each
platform. On the ppc platform, there is also a redundant structure
pointer of 'kvm_run' in 'vcpu_arch', which has also been cleaned
separately.

Thanks and best.

Tianjia Zhang (7):
  KVM: s390: clean up redundant 'kvm_run' parameters
  KVM: arm64: clean up redundant 'kvm_run' parameters
  KVM: PPC: Remove redundant kvm_run from vcpu_arch
  KVM: PPC: clean up redundant 'kvm_run' parameters
  KVM: PPC: clean up redundant kvm_run parameters in assembly
  KVM: MIPS: clean up redundant 'kvm_run' parameters
  KVM: MIPS: clean up redundant kvm_run parameters in assembly

 arch/arm64/include/asm/kvm_coproc.h      |  12 +--
 arch/arm64/include/asm/kvm_host.h        |  11 +-
 arch/arm64/include/asm/kvm_mmu.h         |   2 +-
 arch/arm64/kvm/handle_exit.c             |  36 +++----
 arch/arm64/kvm/sys_regs.c                |  13 ++-
 arch/mips/include/asm/kvm_host.h         |  32 +-----
 arch/mips/kvm/emulate.c                  |  59 ++++-------
 arch/mips/kvm/entry.c                    |  15 +--
 arch/mips/kvm/mips.c                     |  14 +--
 arch/mips/kvm/trap_emul.c                | 114 +++++++++-----------
 arch/mips/kvm/vz.c                       |  26 ++---
 arch/powerpc/include/asm/kvm_book3s.h    |  16 ++-
 arch/powerpc/include/asm/kvm_host.h      |   1 -
 arch/powerpc/include/asm/kvm_ppc.h       |  27 +++--
 arch/powerpc/kvm/book3s.c                |   4 +-
 arch/powerpc/kvm/book3s.h                |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |  12 +--
 arch/powerpc/kvm/book3s_64_mmu_radix.c   |   4 +-
 arch/powerpc/kvm/book3s_emulate.c        |  10 +-
 arch/powerpc/kvm/book3s_hv.c             |  64 ++++++------
 arch/powerpc/kvm/book3s_hv_nested.c      |  12 +--
 arch/powerpc/kvm/book3s_interrupts.S     |  17 ++-
 arch/powerpc/kvm/book3s_paired_singles.c |  72 ++++++-------
 arch/powerpc/kvm/book3s_pr.c             |  33 +++---
 arch/powerpc/kvm/booke.c                 |  39 +++----
 arch/powerpc/kvm/booke.h                 |   8 +-
 arch/powerpc/kvm/booke_emulate.c         |   2 +-
 arch/powerpc/kvm/booke_interrupts.S      |   9 +-
 arch/powerpc/kvm/bookehv_interrupts.S    |  10 +-
 arch/powerpc/kvm/e500_emulate.c          |  15 ++-
 arch/powerpc/kvm/emulate.c               |  10 +-
 arch/powerpc/kvm/emulate_loadstore.c     |  32 +++---
 arch/powerpc/kvm/powerpc.c               |  72 ++++++-------
 arch/powerpc/kvm/trace_hv.h              |   6 +-
 arch/s390/kvm/kvm-s390.c                 | 127 ++++++++++++-----------
 virt/kvm/arm/arm.c                       |   6 +-
 virt/kvm/arm/mmio.c                      |  11 +-
 virt/kvm/arm/mmu.c                       |   5 +-
 38 files changed, 441 insertions(+), 519 deletions(-)

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

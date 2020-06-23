Return-Path: <SRS0=SY/6=AE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16691C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jun 2020 17:33:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35321206EB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jun 2020 17:33:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35321206EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C18DD4B186;
	Tue, 23 Jun 2020 13:33:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oqRlKRuePB51; Tue, 23 Jun 2020 13:33:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFD064B163;
	Tue, 23 Jun 2020 13:33:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DE254B0DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2020 09:14:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HGCw1fAmz9TX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jun 2020 09:14:24 -0400 (EDT)
Received: from out30-54.freemail.mail.aliyun.com
 (out30-54.freemail.mail.aliyun.com [115.124.30.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C59E94B08F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jun 2020 09:14:23 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01f04397;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=38; SR=0;
 TI=SMTPD_---0U0WFKzW_1592918058; 
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0U0WFKzW_1592918058) by smtp.aliyun-inc.com(127.0.0.1);
 Tue, 23 Jun 2020 21:14:18 +0800
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
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
 chenhuacai@gmail.com
Subject: [PATCH v6 0/5] clean up redundant 'kvm_run' parameters
Date: Tue, 23 Jun 2020 21:14:13 +0800
Message-Id: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
X-Mailman-Approved-At: Tue, 23 Jun 2020 13:33:11 -0400
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
structure. For historical reasons, many kvm-related function parameters
retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
patch does a unified cleanup of these remaining redundant parameters.

This series of patches has completely cleaned the architecture of
arm64, mips, ppc, and s390 (no such redundant code on x86). Due to
the large number of modified codes, a separate patch is made for each
platform. On the ppc platform, there is also a redundant structure
pointer of 'kvm_run' in 'vcpu_arch', which has also been cleaned
separately.

---
v6 changes:
  Rearrange patch sets, only keep the unmerged patch.
  rebase on mainline.

v5 change:
  ppc: fix for review.

v4 change:
  mips: fixes two errors in entry.c.

v3 change:
  Keep the existing `vcpu->run` in the function body unchanged.

v2 change:
  s390 retains the original variable name and minimizes modification.

Tianjia Zhang (5):
  KVM: s390: clean up redundant 'kvm_run' parameters
  KVM: arm64: clean up redundant 'kvm_run' parameters
  KVM: PPC: clean up redundant kvm_run parameters in assembly
  KVM: MIPS: clean up redundant 'kvm_run' parameters
  KVM: MIPS: clean up redundant kvm_run parameters in assembly

 arch/arm64/include/asm/kvm_coproc.h   |  12 +--
 arch/arm64/include/asm/kvm_host.h     |  11 +--
 arch/arm64/include/asm/kvm_mmu.h      |   2 +-
 arch/arm64/kvm/arm.c                  |   6 +-
 arch/arm64/kvm/handle_exit.c          |  36 ++++----
 arch/arm64/kvm/mmio.c                 |  11 +--
 arch/arm64/kvm/mmu.c                  |   5 +-
 arch/arm64/kvm/sys_regs.c             |  13 ++-
 arch/mips/include/asm/kvm_host.h      |  32 ++------
 arch/mips/kvm/emulate.c               |  59 +++++--------
 arch/mips/kvm/entry.c                 |  21 ++---
 arch/mips/kvm/mips.c                  |  14 ++--
 arch/mips/kvm/trap_emul.c             | 114 +++++++++++---------------
 arch/mips/kvm/vz.c                    |  26 +++---
 arch/powerpc/include/asm/kvm_ppc.h    |   2 +-
 arch/powerpc/kvm/book3s_interrupts.S  |  22 +++--
 arch/powerpc/kvm/book3s_pr.c          |   9 +-
 arch/powerpc/kvm/booke.c              |   9 +-
 arch/powerpc/kvm/booke_interrupts.S   |   9 +-
 arch/powerpc/kvm/bookehv_interrupts.S |  10 +--
 arch/s390/kvm/kvm-s390.c              |  23 ++++--
 21 files changed, 188 insertions(+), 258 deletions(-)

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

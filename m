From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL v2 0/3] KVM/ARM Fixes for v4.15 - Round 3
Date: Tue, 16 Jan 2018 18:02:30 +0100
Message-ID: <20180116170233.7085-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A9949DFC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 11:57:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A-NT2VYrXjeB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 11:57:37 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D577B49DDC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 11:57:36 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id v123so10075240wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 09:02:38 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

This is v2 of the third round of fixes for KVM/ARM for v4.15, which now
consists of three more fixes for v4.15 fixing incorrect huge page mappings on
systems using the contigious hint for hugetlbfs; supporting an alternative
GICv4 init sequence; and correctly implementing the ARM SMCC for HVC and SMC
handling.

The following changes since commit 0eb7c33cadf6b2f1a94e58ded8b0eb89b4eba382:

  KVM: arm/arm64: Fix timer enable flow (2017-12-18 10:53:24 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-fixes-for-v4.15-3-v2

for you to fetch changes up to acfb3b883f6d6a4b5d27ad7fdded11f6a09ae6dd:

  arm64: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls (2018-01-16 17:58:51 +0100)

Christoffer Dall (1):
      KVM: arm64: Fix GICv4 init when called from vgic_its_create

Marc Zyngier (1):
      arm64: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls

Punit Agrawal (1):
      KVM: arm/arm64: Check pagesize when allocating a hugepage at Stage 2

 arch/arm64/kvm/handle_exit.c  | 4 ++--
 virt/kvm/arm/mmu.c            | 2 +-
 virt/kvm/arm/vgic/vgic-init.c | 8 +++++---
 virt/kvm/arm/vgic/vgic-v4.c   | 2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

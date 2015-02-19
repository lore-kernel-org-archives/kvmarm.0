From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with uncached
 guest mappings
Date: Thu, 19 Feb 2015 10:54:43 +0000
Message-ID: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D74345FBB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 05:49:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vvHtgJLg-pJU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Feb 2015 05:49:33 -0500 (EST)
Received: from mail-wg0-f42.google.com (mail-wg0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8101845FAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 05:49:33 -0500 (EST)
Received: by mail-wg0-f42.google.com with SMTP id n12so6500921wgh.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 02:55:01 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lersek@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This is a 0th order approximation of how we could potentially force the guest
to avoid uncached mappings, at least from the moment the MMU is on. (Before
that, all of memory is implicitly classified as Device-nGnRnE)

The idea (patch #2) is to trap writes to MAIR_EL1, and replace uncached mappings
with cached ones. This way, there is no need to mangle any guest page tables.

The downside is that, to do this correctly, we need to always trap writes to
the VM sysreg group, which includes registers that the guest may write to very
often. To reduce the associated performance hit, patch #1 introduces a fast path
for EL2 to perform trivial sysreg writes on behalf of the guest, without the
need for a full world switch to the host and back.

The main purpose of these patches is to quantify the performance hit, and
verify whether the MAIR_EL1 handling works correctly. 

Ard Biesheuvel (3):
  arm64: KVM: handle some sysreg writes in EL2
  arm64: KVM: mangle MAIR register to prevent uncached guest mappings
  arm64: KVM: keep trapping of VM sysreg writes enabled

 arch/arm/kvm/mmu.c               |   2 +-
 arch/arm64/include/asm/kvm_arm.h |   2 +-
 arch/arm64/kvm/hyp.S             | 101 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c        |  63 ++++++++++++++++++++----
 4 files changed, 156 insertions(+), 12 deletions(-)

-- 
1.8.3.2

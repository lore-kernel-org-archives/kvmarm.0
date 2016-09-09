From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 0/2] KVM/ARM Fixes for v4.8 - round #2
Date: Fri,  9 Sep 2016 12:54:54 +0200
Message-ID: <20160909105456.8585-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here are a couple of fixes for KVM/ARM for v4.8-rc6 or -rc7, as soon as
they can make it.

They fix an idmap issue on 32-bit KVM on ARM, and fixes a memory
unmapping issue that we've had forever on both arm and arm64.

The following changes since commit 20218b86ad8adb4bf71db9425bb59680f345eafd:

  Merge tag 'kvm-s390-master-4.8-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master (2016-09-05 16:15:22 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-fixes-for-v4.8-round2

for you to fetch changes up to 293f293637b55db4f9f522a5a72514e98a541076:

  kvm-arm: Unmap shadow pagetables properly (2016-09-09 12:40:30 +0200)

Thanks!
-Christoffer

---
Marc Zyngier (1):
      arm: KVM: Fix idmap overlap detection when the kernel is idmap'ed

Suzuki K Poulose (1):
      kvm-arm: Unmap shadow pagetables properly

 arch/arm/kvm/arm.c | 2 --
 arch/arm/kvm/mmu.c | 4 +++-
 2 files changed, 3 insertions(+), 3 deletions(-)

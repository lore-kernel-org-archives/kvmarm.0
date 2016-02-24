From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM fixes for 4.5-rc6
Date: Wed, 24 Feb 2016 17:33:41 +0000
Message-ID: <1456335224-20603-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2D8440FA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 12:27:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2ww+z+eyGoTH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 12:27:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72D2D40F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 12:27:21 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

This is hopefully the last batch of fixes for 4.5. One case of bitmap
going overboard, another case of uninitialized memory, and a fix for
an unpredictable behaviour.

Please pull!

Thanks,

	M.

The following changes since commit 3c5b1d92b3b02be07873d611a27950addff544d3:

  arm64: KVM: Configure TCR_EL2.PS at runtime (2016-02-11 13:16:47 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.5-rc6

for you to fetch changes up to fd451b90e78c4178bcfc5072f2b2b637500c109a:

  arm64: KVM: vgic-v3: Restore ICH_APR0Rn_EL2 before ICH_APR1Rn_EL2 (2016-02-24 17:25:58 +0000)

----------------------------------------------------------------
KVM/ARM fixes for 4.5-rc6

- Fix per-vcpu vgic bitmap allocation
- Do not give copy random memory on MMIO read
- Fix GICv3 APR register restore order

----------------------------------------------------------------
Marc Zyngier (2):
      arm/arm64: KVM: Feed initialized memory to MMIO accesses
      arm64: KVM: vgic-v3: Restore ICH_APR0Rn_EL2 before ICH_APR1Rn_EL2

Mark Rutland (1):
      KVM: arm/arm64: vgic: Ensure bitmaps are long enough

 arch/arm/kvm/mmio.c             |  3 ++-
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 20 ++++++++++----------
 virt/kvm/arm/vgic.c             |  4 ++--
 3 files changed, 14 insertions(+), 13 deletions(-)

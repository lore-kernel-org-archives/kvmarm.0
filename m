From: Will Deacon <will.deacon@arm.com>
Subject: [GIT PULL] Late arm64 KVM fix for 4.2
Date: Thu, 27 Aug 2015 19:02:44 +0100
Message-ID: <20150827180244.GE23520@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, marc.zyngier@arm.com, linux@arm.linux.org.uk, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Linus,

I appreciate that it's extremely late in the cycle, but we've uncovered
a nasty bug in the arm64 KVM code which allows a badly behaved 32-bit
guest to bring down the host. The fix is simple (it's what I believe we
call a "brown paper bag" bug) and I don't think it makes sense to sit on
this, particularly as Russell ended up triggering this rather than just
somebody noticing a potential problem by inspection.

Usually arm64 KVM changes would go via Paolo's tree, but he's on holiday
at the moment and the deal is that anything urgent gets shuffled via
the arch trees, so here it is. Please pull.

Cheers,

Will

--->8

The following changes since commit c13dcf9f2d6f5f06ef1bf79ec456df614c5e058b:

  Linux 4.2-rc8 (2015-08-23 20:52:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to 126c69a0bd0e441bf6766a5d9bf20de011be9f68:

  arm64: KVM: Fix host crash when injecting a fault into a 32bit guest (2015-08-27 16:16:55 +0100)

----------------------------------------------------------------
Urgent arm64 KVM fix for 4.2:

Fix arm64 KVM issue when injecting an abort into a 32-bit guest, which
would lead to an illegal exception return at EL2 and a subsequent host
crash.

----------------------------------------------------------------
Marc Zyngier (1):
      arm64: KVM: Fix host crash when injecting a fault into a 32bit guest

 arch/arm64/kvm/inject_fault.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

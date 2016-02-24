From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 0/4] kvmtool: add PRE_INIT support for ARM/ARM64
Date: Wed, 24 Feb 2016 15:33:04 +0000
Message-ID: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

the new PRE_INIT feature of kvmtool tries to get rid of the static
linking requirement (for ARM, at least) kvmtool currently comes with:
To be able to use the sandbox feature, kvmtool comes with an init
replacement, which is a statically linked binary injected into the
guest. It initializes the Linux environment and launches the command
provided on the kvmtool command line.
Now this results in a rather big binary blob (around 750K) sitting
in the kvmtool binary.
A recent commit provides another implementation for x86-64:
A tiny assembly stub mounts the host filesystem via 9pfs and calls
the now dynamically linked init binary. This removes the need for
statically linking the guest_init binary and is also much smaller
(find the numbers in patch 4/4).

This series provides implementations for ARM and ARM64. Since I needed
to wrap my mind around the original x86_64 asm code anyway, I also
added an i386 implementation.

Cheers,
Andre.

Andre Przywara (4):
  pre_init: rename x86/init.S to x86/init64.S
  pre_init: x86/init64.S: use defines for syscall numbers
  pre_init: add support for i386 also
  pre_init: add ARM implementations

 Makefile                 |  5 ++++-
 arm/aarch32/init.S       | 44 ++++++++++++++++++++++++++++++++++++++++++
 arm/aarch64/init.S       | 44 ++++++++++++++++++++++++++++++++++++++++++
 x86/init32.S             | 50 ++++++++++++++++++++++++++++++++++++++++++++++++
 x86/{init.S => init64.S} | 14 +++++++++++---
 5 files changed, 153 insertions(+), 4 deletions(-)
 create mode 100644 arm/aarch32/init.S
 create mode 100644 arm/aarch64/init.S
 create mode 100644 x86/init32.S
 rename x86/{init.S => init64.S} (71%)

-- 
2.6.4


From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 0/3] KVM: arm/arm64: trivial header path sanitization
Date: Fri, 25 Jan 2019 16:57:27 +0900
Message-ID: <1548403050-6585-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Masahiro Yamada <yamada.masahiro@socionext.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

My main motivation is to get rid of crappy header search path manipulation
from Kbuild core.

Before that, I want to finish as many cleanup works as possible.

If you are interested in the big picture of this work,
the full patch set is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git build-test



Masahiro Yamada (3):
  KVM: arm/arm64: fix TRACE_INCLUDE_PATH
  KVM: arm/arm64: remove -I. header search paths
  KVM: arm/arm64: prefix header search paths with $(srctree)/

 arch/arm/kvm/Makefile   | 5 ++---
 arch/arm64/kvm/Makefile | 4 +---
 virt/kvm/arm/trace.h    | 2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

-- 
2.7.4

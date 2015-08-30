From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/2] Improve and add tracepoints for KVM on arm/arm64
Date: Sun, 30 Aug 2015 15:55:20 +0200
Message-ID: <1440942922-23955-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The timer and vgic code didn't have tracepoints for quite a while and
we've been adding those ad-hoc when doing development a lot of times.
Add some simple tracepoints for those parts of KVM to get the
infrastructure in place.

Also improve the kvm_exit tracepoint on arm/arm64 to print something
meaningful and be much less misleading compared to what we have now.

This series depends on the "Rework architected timer and fix UEFI reset=
"
series sent earlier.  It is also available here:

https://git.linaro.org/people/christoffer.dall/linux-kvm-arm.git tracin=
g-fixup

I borrowed some of this code from Alex Benn=C3=A9e, thanks!

Christoffer Dall (2):
  arm/arm64: KVM: Add tracepoints for vgic and timer
  arm/arm64: KVM: Improve kvm_exit tracepoint

 arch/arm/include/asm/kvm_arm.h   | 20 +++++++++
 arch/arm/kvm/arm.c               |  2 +-
 arch/arm/kvm/trace.h             | 10 +++--
 arch/arm64/include/asm/kvm_arm.h | 16 +++++++
 virt/kvm/arm/arch_timer.c        |  4 ++
 virt/kvm/arm/trace.h             | 97 ++++++++++++++++++++++++++++++++=
++++++++
 virt/kvm/arm/vgic.c              |  9 ++++
 7 files changed, 154 insertions(+), 4 deletions(-)
 create mode 100644 virt/kvm/arm/trace.h

--=20
2.1.2.330.g565301e.dirty


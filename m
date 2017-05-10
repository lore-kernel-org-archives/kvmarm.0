From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v1 0/2] Plug ARMv7 KVM Debug Exploit
Date: Wed, 10 May 2017 18:01:57 +0100
Message-ID: <20170510170200.13285-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

These two patches where the start a longer series Zhichao had started
to support hardware debugging in KVM. They plug a fairly serious bug
which meant a guest could mess with the debug state and affect the
host.

With these patches applied the guest can still do normal debugging
using software breakpoints but attempts to use the hardware registers
are ignored.

The only real changes I've made have been converting to the new C
based world switch and the subsequent testing. The remaining patches
in the series will take a bit more work and I guess depends on how
many KVM guests actually need to use HW breakpoints and watchpoints.
The code is a little more hairy on ARMv7 compared to ARMv8 due to
complications accessing things like DBGDSCR.

Cheers,

Alex.

Zhichao Huang (2):
  KVM: arm: plug guest debug exploit
  KVM: arm: rename pm_fake handler to trap_raz_wi

 arch/arm/include/asm/kvm_coproc.h |   3 +-
 arch/arm/kvm/coproc.c             | 110 ++++++++++++++++++++++++++------------
 arch/arm/kvm/handle_exit.c        |   4 +-
 arch/arm/kvm/hyp/switch.c         |   4 +-
 4 files changed, 83 insertions(+), 38 deletions(-)

-- 
2.11.0

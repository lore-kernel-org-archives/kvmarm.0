From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/5] KVM/ARM: Fixes for 4.12-rc1
Date: Tue,  2 May 2017 14:30:36 +0100
Message-ID: <20170502133041.10980-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Here's a handful of random fixes I've queued locally that didn't have
a chance to make it in 4.11.

The first two patches avoid stack-protector messing with the HYP code,
as this ends up being a complete disaster.

The following two patches fix a bug introduced in the new vgic, where
we may queue HW interrupts with the Pending+Active state, which is
illegal.

The final patch fixes a misinterpretation of the spec, where we
compute the number of APxRn register based on the number of priorities
instead of using the number of preemption levels.

I've tagged the first 4 patches for stable, given that we're doing
something potentially harmful. The last patch is more of a theoretical
issue at this stage, so probably need for a backport.

Marc Zyngier (5):
  arm64: KVM: Do not use stack-protector to compile EL2 code
  arm: KVM: Do not use stack-protector to compile HYP code
  KVM: arm/arm64: vgic-v2: Do not use Active+Pending state for a HW
    interrupt
  KVM: arm/arm64: vgic-v3: Do not use Active+Pending state for a HW
    interrupt
  KVM: arm/arm64: vgic-v3: Use PREbits to infer the number of
    ICH_APxRn_EL2 registers

 arch/arm/kvm/hyp/Makefile     |  2 ++
 arch/arm64/kvm/hyp/Makefile   |  2 ++
 virt/kvm/arm/hyp/vgic-v3-sr.c | 18 +++++++++---------
 virt/kvm/arm/vgic/vgic-v2.c   |  7 +++++++
 virt/kvm/arm/vgic/vgic-v3.c   |  7 +++++++
 5 files changed, 27 insertions(+), 9 deletions(-)

-- 
2.11.0

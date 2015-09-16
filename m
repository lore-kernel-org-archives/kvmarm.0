From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/3] arm/arm64: KVM: Fix !irqchip_in_kernel() handling
Date: Wed, 16 Sep 2015 16:58:04 +0100
Message-ID: <1442419087-24648-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Pavel Fedin <p.fedin@samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

It is quite obvious that the non kernel-irqchip has been bitrotting
for a while now. Pavel has been doing some work to address this, but
it turns out that there is more fun to be had...

This series picks up one of Pavel's series (which is an obvious fix),
and adds another fix for both arm and arm64.

With these two patches applied, I get a working system as long as I
don't need timers - which is expected.

Tested on X-Gene.

Marc Zyngier (2):
  arm64: KVM: Disable virtual timer even if the guest is not using it
  arm: KVM: Disable virtual timer even if the guest is not using it

Pavel Fedin (1):
  arm/arm64: KVM: vgic: Check for !irqchip_in_kernel() when mapping
    resources

 arch/arm/kvm/arm.c             | 2 +-
 arch/arm/kvm/interrupts_head.S | 6 ++++--
 arch/arm64/kvm/hyp.S           | 4 ++--
 3 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.1.4


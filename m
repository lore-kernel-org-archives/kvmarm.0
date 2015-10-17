From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/3] arm/arm64: KVM: arch timer boot fixes
Date: Sat, 17 Oct 2015 22:30:19 +0200
Message-ID: <1445113822-7831-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This small series fixes a number of issues relating to the arch timer
switching to using the active state instead of the masking hack in v4.3.

The first patch fixes an issue where the guest doesn't proceed after
PSCI reboots, because the arch timer is screaming at the physical GIC.
The second patch fixes an issue where the guest gets stuck after calling
WFI during boot, because the timer never fires.  The third patch fixes
an issue that occasionally causes warnings when queueing interrupts
because the distributor and CPU interface state gets inconsistent.

I stole some of the code for patch 2 from Marc's initial patch looking
to solve the problem solved in patch 1 here.

This is going to conflict horribly with some of the stuff we have in
next at the moment, so assumning there are no objections to these
patches, I'll rework the stuff in next after adding these to our current
list of fixes.

Christoffer Dall (3):
  arm/arm64: KVM: Fix arch timer behavior for disabled interrupts
  arm/arm64: KVM: Clear map->active on pend/active clear
  arm/arm64: KVM: Fix disabled distributor operation

 virt/kvm/arm/arch_timer.c | 19 +++++++++++
 virt/kvm/arm/vgic.c       | 86 ++++++++++++++++++++++++++---------------------
 2 files changed, 67 insertions(+), 38 deletions(-)

-- 
2.1.2.330.g565301e.dirty


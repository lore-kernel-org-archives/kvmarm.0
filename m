From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 00/10] KVM/ARM fixes for 4.11-rc2
Date: Thu, 9 Mar 2017 16:16:52 +0100
Message-ID: <20170309151652.GA3210@potion>
References: <20170309095539.14512-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170309095539.14512-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <cdall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>, Linu Cherian <linu.cherian@cavium.com>, Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

2017-03-09 09:55+0000, Marc Zyngier:
> Paolo, Radim,
> 
> Here's the KVM/ARM updates for 4.11-rc2. The usual bag of vgic
> updates, making the memslot array large enough to handle guests with
> tons of devices assigned to them, a tidying up of exception handling,
> and a rather annoying TLB handling issue on VHE systems.

Pulled, but what made you change the GPG key into a revoked one?

  # gpg: Signature made Thu 09 Mar 2017 10:36:07 AM CET
  # gpg:                using RSA key AB309C74B93B1EA1
  # gpg: Good signature from "Marc Zyngier <marc.zyngier@arm.com>"
  # gpg: WARNING: This key has been revoked by its owner!
  # gpg:          This could mean that the signature is forged.
  # gpg: reason for revocation: Key has been compromised
  # gpg: revocation comment: Revoked after kernel.org hacking
  # Primary key fingerprint: 6958 C9F2 233C 5E9D 6CCA  818A AB30 9C74 B93B 1EA1

Thanks.

> Please pull,
> 
> Thanks,
> 
> 	M.
> 
> The following changes since commit c1ae3cfa0e89fa1a7ecc4c99031f5e9ae99d9201:
> 
>   Linux 4.11-rc1 (2017-03-05 12:59:56 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.11-rc2
> 
> for you to fetch changes up to 955a3fc6d2a1c11d6d00bce4f3816100ce0530cf:
> 
>   KVM: arm64: Increase number of user memslots to 512 (2017-03-09 09:13:50 +0000)
> 
> ----------------------------------------------------------------
> KVM/ARM updates for v4.11-rc2
> 
> vgic updates:
> - Honour disabling the ITS
> - Don't deadlock when deactivating own interrupts via MMIO
> - Correctly expose the lact of IRQ/FIQ bypass on GICv3
> 
> I/O virtualization:
> - Make KVM_CAP_NR_MEMSLOTS big enough for large guests with
>   many PCIe devices
> 
> General bug fixes:
> - Gracefully handle exception generated with syndroms that
>   the host doesn't understand
> - Properly invalidate TLBs on VHE systems
> 
> ----------------------------------------------------------------
> Andre Przywara (1):
>       KVM: arm/arm64: VGIC: Fix command handling while ITS being disabled
> 
> Jintack Lim (1):
>       KVM: arm/arm64: Let vcpu thread modify its own active state
> 
> Linu Cherian (4):
>       KVM: Add documentation for KVM_CAP_NR_MEMSLOTS
>       KVM: arm/arm64: Enable KVM_CAP_NR_MEMSLOTS on arm/arm64
>       KVM: arm/arm64: Remove KVM_PRIVATE_MEM_SLOTS definition that are unused
>       KVM: arm64: Increase number of user memslots to 512
> 
> Marc Zyngier (2):
>       arm64: KVM: VHE: Clear HCR_TGE when invalidating guest TLBs
>       KVM: arm/arm64: vgic-v3: Don't pretend to support IRQ/FIQ bypass
> 
> Mark Rutland (2):
>       arm: KVM: Survive unknown traps from guests
>       arm64: KVM: Survive unknown traps from guests
> 
>  Documentation/virtual/kvm/api.txt  |   4 ++
>  arch/arm/include/asm/kvm_arm.h     |   1 +
>  arch/arm/include/asm/kvm_host.h    |   1 -
>  arch/arm/kvm/arm.c                 |   3 +
>  arch/arm/kvm/handle_exit.c         |  19 ++++---
>  arch/arm64/include/asm/kvm_host.h  |   3 +-
>  arch/arm64/kvm/handle_exit.c       |  19 ++++---
>  arch/arm64/kvm/hyp/tlb.c           |  64 +++++++++++++++++++---
>  include/linux/irqchip/arm-gic-v3.h |   2 +
>  virt/kvm/arm/vgic/vgic-its.c       | 109 ++++++++++++++++++++++---------------
>  virt/kvm/arm/vgic/vgic-mmio.c      |  32 ++++++++---
>  virt/kvm/arm/vgic/vgic-v3.c        |   5 +-
>  12 files changed, 183 insertions(+), 79 deletions(-)

From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL 0/5] arm/arm64: KVM: Fixes for KVM for 4.0-rc5
Date: Tue, 07 Apr 2015 18:14:50 +0200
Message-ID: <5524027A.3090507@redhat.com>
References: <1426510503-27995-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1426510503-27995-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 16/03/2015 13:54, Christoffer Dall wrote:
> Hi Marcelo and Paolo,
> 
> Please pull the following fixes for KVM/ARM for 4.0-rc5.
> 
> They fix page refcounting issues in our Stage-2 page table management code, a
> missing unlock in a gicv3 error path, and a race that can cause lost interrupts
> if signals are pending just prior to entering the guest.
> 
> The following changes since commit bfb8fb4775d3397908ae3a7ff65807097d81d713:
> 
>   Merge tag 'kvm-s390-master-20150303' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux (2015-03-05 14:42:48 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-fixes-4.0-rc5
> 
> for you to fetch changes up to ae705930fca6322600690df9dc1c7d0516145a93:
> 
>   arm/arm64: KVM: Keep elrsr/aisr in sync with software model (2015-03-14 13:42:07 +0100)
> 
> 
> Thanks,
> -Christoffer
> 
> ---
> 
> Christoffer Dall (1):
>   arm/arm64: KVM: Keep elrsr/aisr in sync with software model
> 
> Marc Zyngier (3):
>   arm64: KVM: Fix stage-2 PGD allocation to have per-page refcounting
>   arm64: KVM: Do not use pgd_index to index stage-2 pgd
>   arm64: KVM: Fix outdated comment about VTCR_EL2.PS
> 
> Wei Yongjun (1):
>   arm/arm64: KVM: fix missing unlock on error in kvm_vgic_create()
> 
>  arch/arm/include/asm/kvm_mmu.h   | 13 ++++---
>  arch/arm/kvm/mmu.c               | 75 ++++++++++++++++++++++++++++------------
>  arch/arm64/include/asm/kvm_arm.h |  5 +--
>  arch/arm64/include/asm/kvm_mmu.h | 48 ++++---------------------
>  include/kvm/arm_vgic.h           |  1 +
>  virt/kvm/arm/vgic-v2.c           |  8 +++++
>  virt/kvm/arm/vgic-v3.c           |  8 +++++
>  virt/kvm/arm/vgic.c              | 22 ++++++++++--
>  8 files changed, 105 insertions(+), 75 deletions(-)
> 

I pulled this into kvm/next now.  The conflict in virt/kvm/arm/vgic-v3.c
is internal to the KVM tree, so I'll take care of the resolution myself.

Paolo

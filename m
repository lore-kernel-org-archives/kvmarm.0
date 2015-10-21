From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL 0/6] A handful of fixes for KVM/ARM for v4.3-rc7
Date: Wed, 21 Oct 2015 17:47:35 +0200
Message-ID: <5627B397.9060001@redhat.com>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 20/10/2015 18:19, Christoffer Dall wrote:
> Hi Paolo,
> 
> The following changes since commit 920552b213e3dc832a874b4e7ba29ecddbab31bc:
> 
>   KVM: disable halt_poll_ns as default for s390x (2015-09-25 10:31:30 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.3-rc7
> 
> for you to fetch changes up to 0d997491f814c87310a6ad7be30a9049c7150489:
> 
>   arm/arm64: KVM: Fix disabled distributor operation (2015-10-20 18:09:13 +0200)
> 
> Sorry for sending these relatively late, but we had a situation where we
> found one breakage in the timer implementation changes merged for 4.3,
> then fixing that issue revealed another bug, and then that happened
> again, and now we have something that looks stable.
> 
> Description of the fixes is in the tag and quoted below.
> 
> Thanks,
> -Christoffer
> 
> ----------------------------------------------------------------
> A late round of KVM/ARM fixes for v4.3-rc7, fixing:
>  - A bug where level-triggered interrupts lowered from userspace
>    are still routed to the guest
>  - A memory leak an a failed initialization path
>  - A build error under certain configurations
>  - Several timer bugs introduced with moving the timer to the active
>    state handling instead of the masking trick.
> 
> ----------------------------------------------------------------
> Arnd Bergmann (1):
>       KVM: arm: use GIC support unconditionally
> 
> Christoffer Dall (3):
>       arm/arm64: KVM: Fix arch timer behavior for disabled interrupts
>       arm/arm64: KVM: Clear map->active on pend/active clear
>       arm/arm64: KVM: Fix disabled distributor operation
> 
> Pavel Fedin (2):
>       KVM: arm/arm64: Do not inject spurious interrupts
>       KVM: arm/arm64: Fix memory leak if timer initialization fails
> 
>  arch/arm/kvm/Kconfig      |  1 +
>  arch/arm/kvm/arm.c        |  2 +-
>  virt/kvm/arm/arch_timer.c | 19 ++++++++++
>  virt/kvm/arm/vgic.c       | 95 +++++++++++++++++++++++++++--------------------
>  4 files changed, 76 insertions(+), 41 deletions(-)
> 

Pulled, thanks.  I'll send the fixes to Linus tomorrow.

Paolo

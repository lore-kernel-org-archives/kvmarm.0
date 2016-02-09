From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 0/5] arm/arm64: Making HYP vgic/timer save/restore
 common
Date: Tue, 9 Feb 2016 20:06:16 +0100
Message-ID: <20160209190616.GC5171@cbox>
References: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453996565-19666-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 28, 2016 at 03:56:00PM +0000, Marc Zyngier wrote:
> With the current state of the C conversion of arm and arm64 world
> switches, we are still unable to share some of the most obvious
> candidates (GIC and timer save/restore). In order to reduce the bloat,
> let's move these files to a common location (virt/kvm/arm/hyp).
> 
> The changes are extremely mechanical, with a small hack to deal with
> system register names on the 32bit side (I've decided to align on the
> 64bit names).
> 
> I'd like to know what people think of the common location. Does it
> makes sense to have a "hyp" subdirectory to indicate that this is not
> "normal" kernel code?

I think so, it means to me typically executing in "hyp/el2" or just
low-level hypervisor logic, in the case of VHE.


> 
> These patches are on top of 4.5-rc1, plus the VHE and 32bit WS rewrite
> patches, and I've pushed out a branch at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/mov-hyp
> 
> Marc Zyngier (5):
>   arm64: KVM: Move kvm/hyp/hyp.h to include/asm/kvm_hyp.h
>   arm64: KVM: Move vgic-v2 and timer save/restore to virt/kvm/arm/hyp
>   ARM: KVM: Move kvm/hyp/hyp.h to include/asm/kvm_hyp.h
>   ARM: KVM: Use common version of vgic-v2-sr.c
>   ARM: KVM: Use common version of timer-sr.c
> 
>  arch/arm/{kvm/hyp/hyp.h => include/asm/kvm_hyp.h}  |  9 +++
>  arch/arm/kvm/hyp/Makefile                          |  7 +-
>  arch/arm/kvm/hyp/banked-sr.c                       |  2 +-
>  arch/arm/kvm/hyp/cp15-sr.c                         |  2 +-
>  arch/arm/kvm/hyp/switch.c                          |  2 +-
>  arch/arm/kvm/hyp/timer-sr.c                        | 71 ------------------
>  arch/arm/kvm/hyp/tlb.c                             |  2 +-
>  arch/arm/kvm/hyp/vgic-v2-sr.c                      | 84 ----------------------
>  .../arm64/{kvm/hyp/hyp.h => include/asm/kvm_hyp.h} |  0
>  arch/arm64/kvm/hyp/Makefile                        |  7 +-
>  arch/arm64/kvm/hyp/debug-sr.c                      |  4 +-
>  arch/arm64/kvm/hyp/switch.c                        |  3 +-
>  arch/arm64/kvm/hyp/sysreg-sr.c                     |  4 +-
>  arch/arm64/kvm/hyp/tlb.c                           |  2 +-
>  arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  4 +-
>  {arch/arm64/kvm => virt/kvm/arm}/hyp/timer-sr.c    |  4 +-
>  {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v2-sr.c  |  4 +-
>  17 files changed, 30 insertions(+), 181 deletions(-)
>  rename arch/arm/{kvm/hyp/hyp.h => include/asm/kvm_hyp.h} (93%)
>  delete mode 100644 arch/arm/kvm/hyp/timer-sr.c
>  delete mode 100644 arch/arm/kvm/hyp/vgic-v2-sr.c
>  rename arch/arm64/{kvm/hyp/hyp.h => include/asm/kvm_hyp.h} (100%)
>  rename {arch/arm64/kvm => virt/kvm/arm}/hyp/timer-sr.c (97%)
>  rename {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v2-sr.c (98%)
> 
> -- 
> 2.1.4
> 

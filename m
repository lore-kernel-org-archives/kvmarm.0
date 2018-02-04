From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] ARM: kvm: fix building with gcc-8
Date: Sun, 4 Feb 2018 19:45:17 +0100
Message-ID: <20180204184517.GQ21802@cbox>
References: <20180202150756.420422-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180202150756.420422-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Russell King <linux@armlinux.org.uk>, Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Richard Earnshaw <rearnsha@gcc.gnu.org>, Tamar Christina <tnfchris@gcc.gnu.org>, stable@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,

On Fri, Feb 02, 2018 at 04:07:34PM +0100, Arnd Bergmann wrote:
> In banked-sr.c, we use a top-level '__asm__(".arch_extension virt")'
> statement to allow compilation of a multi-CPU kernel for ARMv6
> and older ARMv7-A that don't normally support access to the banked
> registers.
> 
> This is considered to be a programming error by the gcc developers
> and will no longer work in gcc-8, where we now get a build error:
> 
> /tmp/cc4Qy7GR.s:34: Error: Banked registers are not available with this architecture. -- `mrs r3,SP_usr'
> /tmp/cc4Qy7GR.s:41: Error: Banked registers are not available with this architecture. -- `mrs r3,ELR_hyp'
> /tmp/cc4Qy7GR.s:55: Error: Banked registers are not available with this architecture. -- `mrs r3,SP_svc'
> /tmp/cc4Qy7GR.s:62: Error: Banked registers are not available with this architecture. -- `mrs r3,LR_svc'
> /tmp/cc4Qy7GR.s:69: Error: Banked registers are not available with this architecture. -- `mrs r3,SPSR_svc'
> /tmp/cc4Qy7GR.s:76: Error: Banked registers are not available with this architecture. -- `mrs r3,SP_abt'
> 
> Passign the '-march-armv7ve' flag to gcc works, and is ok here, because
> we know the functions won't ever be called on pre-ARMv7VE machines.
> Unfortunately, older compiler versions (4.8 and earlier) do not understand
> that flag, so we still need to keep the asm around.

Does "not understand" mean "ignores" or do we get an error?

> 
> Backporting to stable kernels (4.6+) is needed to allow those to be built
> with future compilers as well.

This builds on the toolchains I have on my machine, so:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Are you applying this via a tree with other fixes or would you like me
to carry it in the kvmarm tree?

Thanks,
-Christoffer

> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=84129
> Fixes: 33280b4cd1dc ("ARM: KVM: Add banked registers save/restore")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/kvm/hyp/Makefile    | 5 +++++
>  arch/arm/kvm/hyp/banked-sr.c | 4 ++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
> index 5638ce0c9524..63d6b404d88e 100644
> --- a/arch/arm/kvm/hyp/Makefile
> +++ b/arch/arm/kvm/hyp/Makefile
> @@ -7,6 +7,8 @@ ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING
>  
>  KVM=../../../../virt/kvm
>  
> +CFLAGS_ARMV7VE		   :=$(call cc-option, -march=armv7ve)
> +
>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
> @@ -15,7 +17,10 @@ obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
>  obj-$(CONFIG_KVM_ARM_HOST) += cp15-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
>  obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
> +CFLAGS_banked-sr.o	   += $(CFLAGS_ARMV7VE)
> +
>  obj-$(CONFIG_KVM_ARM_HOST) += entry.o
>  obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
>  obj-$(CONFIG_KVM_ARM_HOST) += switch.o
> +CFLAGS_switch.o		   += $(CFLAGS_ARMV7VE)
>  obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
> diff --git a/arch/arm/kvm/hyp/banked-sr.c b/arch/arm/kvm/hyp/banked-sr.c
> index 111bda8cdebd..be4b8b0a40ad 100644
> --- a/arch/arm/kvm/hyp/banked-sr.c
> +++ b/arch/arm/kvm/hyp/banked-sr.c
> @@ -20,6 +20,10 @@
>  
>  #include <asm/kvm_hyp.h>
>  
> +/*
> + * gcc before 4.9 doesn't understand -march=armv7ve, so we have to
> + * trick the assembler.
> + */
>  __asm__(".arch_extension     virt");
>  
>  void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt)
> -- 
> 2.9.0
> 

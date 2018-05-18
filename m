From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: kvm: use -fno-jump-tables with clang
Date: Fri, 18 May 2018 18:30:41 +0100
Message-ID: <05d14ac7-0feb-63a3-e7ef-b8ca1ae2fd1d@arm.com>
References: <20180518170202.11458-1-samitolvanen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518170202.11458-1-samitolvanen@google.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Nick Desaulniers <ndesaulniers@google.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 18/05/18 18:02, Sami Tolvanen wrote:
> Starting with LLVM r308050, clang generates a jump table with EL1
> virtual addresses in __init_stage2_translation, which results in a
> kernel panic when booting at EL2:
> 
>   Kernel panic - not syncing: HYP panic:
>   PS:800003c9 PC:ffff0000089e6fd8 ESR:86000004
>   FAR:ffff0000089e6fd8 HPFAR:0000000009825000 PAR:0000000000000000
>   VCPU:000804fc20001221
> 
>   CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.0-rc7-dirty #3
>   Hardware name: ARM Juno development board (r1) (DT)
>   Call trace:
>   [<ffff000008088ea4>] dump_backtrace+0x0/0x34c
>   [<ffff000008089208>] show_stack+0x18/0x20
>   [<ffff0000089c73ec>] dump_stack+0xc4/0xfc
>   [<ffff0000080c8e1c>] panic+0x138/0x2b4
>   [<ffff0000080c8ce4>] panic+0x0/0x2b4
>   SMP: stopping secondary CPUs
>   SMP: failed to stop secondary CPUs 0-3,5
>   Kernel Offset: disabled
>   CPU features: 0x002086
>   Memory Limit: none
>   ---[ end Kernel panic - not syncing: HYP panic:
>   PS:800003c9 PC:ffff0000089e6fd8 ESR:86000004
>   FAR:ffff0000089e6fd8 HPFAR:0000000009825000 PAR:0000000000000000
>   VCPU:000804fc20001221
> 
> This change adds -fno-jump-tables to arm64/hyp to work around the
> bug.
> 
> Suggested-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/kvm/hyp/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index 4313f74753332..745b3255e7832 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -5,6 +5,10 @@
>  
>  ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING
>  
> +ifeq ($(cc-name),clang)
> +ccflags-y += -fno-jump-tables
> +endif
> +
>  KVM=../../../../virt/kvm
>  
>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
> 

I'm going to ask the question I've asked before when this patch cropped
up (must be the 4th time now):

Is it guaranteed that this is the only case where LLVM/clang is going to
generate absolute addresses instead of using relative addressing?

So far, nobody has answered that question. If you assure me that this is
the case, I'll take that patch. Otherwise, we're just playing
whack-a-mole, as with the profiling stuff.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

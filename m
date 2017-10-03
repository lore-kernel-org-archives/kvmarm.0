From: James Morse <james.morse@arm.com>
Subject: Re: [RFC PATCH v2 19/31] KVM: arm64: Describe AT instruction emulation
 design
Date: Tue, 03 Oct 2017 18:37:54 +0100
Message-ID: <59D3CAF2.2030704@arm.com>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org> <1507000273-3735-17-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507000273-3735-17-git-send-email-jintack.lim@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jintack Lim <jintack.lim@linaro.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jintack,

On 03/10/17 04:11, Jintack Lim wrote:
> This design overview will help to digest the subsequent patches that
> implement AT instruction emulation.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 8d04926..d8728cc 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1621,6 +1621,72 @@ static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
>  	{ SYS_DESC(SYS_SP_EL2), NULL, reset_special, SP_EL2, 0},
>  };
>  
> +/*
> + * AT instruction emulation
> + *
> + * We emulate AT instructions executed in the virtual EL2.

> + * Basic strategy for the stage-1 translation emulation is to load proper
> + * context, which depends on the trapped instruction and the virtual HCR_EL2,
> + * to the EL1 virtual memory control registers and execute S1E[01] instructions
> + * in EL2. See below for more detail.

What happens if the guest memory containing some stage1-page-table has been
unmapped from stage2? (e.g. its swapped to disk).

(there is some background to this: I tried to implement the kvm_translate
ioctl() using this approach, running 'at s1e1*' from EL2. I ran into problems
when parts of the guest's stage1 page tables had been unmapped from stage2.)

>From memory, I found that the AT instructions would fault-in those pages when
run from EL1, but when executing the same instruction at EL2 they just failed
without any hint of which IPA needed mapping in.

I can try digging for any left over code if we want to setup a test case for this...


Thanks,

James

From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: linux-next-20180601: build error in
 arch/arm64/kvm/hyp/hyp-entry.S
Date: Fri, 1 Jun 2018 22:26:19 +0100
Message-ID: <20180601212619.6trmvqrgmbczekkt@armageddon.cambridge.arm.com>
References: <457305318.78169.1527883507093@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <457305318.78169.1527883507093@email.1und1.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.or, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Stefan,

On Fri, Jun 01, 2018 at 10:05:07PM +0200, Stefan Wahren wrote:
> i can't build todays linux-next-20180601 and get the following error message:
> 
> arch/arm64/kvm/hyp/hyp-entry.S: Assembler messages:
> arch/arm64/kvm/hyp/hyp-entry.S:128: Error: constant expression required at operand 3 -- `bfi x0,x1,#VCPU_WORKAROUND_2_FLAG_SHIFT,#1'
> 
> Related commit:
> arm64: KVM: Handle guest's ARCH_WORKAROUND_2 requests
> 
> Toolchain: gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu
> Kernel config: arm64/defconfig

Thanks for reporting this.

I can hit this as well. It looks like an #ifndef __ASSEMBLY__ in the
wrong place in arch/arm64/include/asm/kvm_asm.h. I can't tell whether it
was caused by a merge conflict resolution or just some unfortunate
interaction between the security fixes going via the arm64 tree and the
other arm64 KVM patches.

I'll have a proper look tomorrow.

-- 
Catalin

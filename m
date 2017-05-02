From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/5] arm64: KVM: Do not use stack-protector to compile
 EL2 code
Date: Tue, 2 May 2017 15:40:29 +0100
Message-ID: <20170502144029.GB29224@e104818-lin.cambridge.arm.com>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
 <20170502133041.10980-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170502133041.10980-2-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 02, 2017 at 02:30:37PM +0100, Marc Zyngier wrote:
> We like living dangerously. Nothing explicitely forbids stack-protector
> to be used in the EL2 code, while distributions routinely compile their
> kernel with it. We're just lucky that no code actually triggers the
> instrumentation.
> 
> Let's not try our luck for much longer, and disable stack-protector
> for code living at EL2.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index aaf42ae8d8c3..14c4e3b14bcb 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -2,6 +2,8 @@
>  # Makefile for Kernel-based Virtual Machine module, HYP part
>  #
>  
> +ccflags-y += -fno-stack-protector
> +

While you are at it, should we have a -fpic here as well? The hyp code
runs at a different location than the rest of the kernel.

-- 
Catalin

From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 28/28] arm/arm64: Add hyp-stub API documentation
Date: Fri, 24 Mar 2017 15:33:16 +0100
Message-ID: <20170324143316.GA25903@cbox>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170321192058.9300-29-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA09B40187
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 10:31:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dXR0OshtNhJa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Mar 2017 10:31:27 -0400 (EDT)
Received: from mail-wr0-f180.google.com (mail-wr0-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DC0F400E9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 10:31:26 -0400 (EDT)
Received: by mail-wr0-f180.google.com with SMTP id y90so2997250wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 07:33:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170321192058.9300-29-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 21, 2017 at 07:20:58PM +0000, Marc Zyngier wrote:
> In order to help people understanding the hyp-stub API that exists
> between the host kernel and the hypervisor mode (whether a hypervisor
> has been installed or not), let's document said API.
> 
> As with any form of documentation, I expect it to become obsolete
> and completely misleading within 20 minutes after having being merged.

I don't think this last sentence belongs in the commit message.

> 
> Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  Documentation/virtual/kvm/arm/hyp-abi.txt | 45 +++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/virtual/kvm/arm/hyp-abi.txt
> 
> diff --git a/Documentation/virtual/kvm/arm/hyp-abi.txt b/Documentation/virtual/kvm/arm/hyp-abi.txt
> new file mode 100644
> index 000000000000..a1e0314d2249
> --- /dev/null
> +++ b/Documentation/virtual/kvm/arm/hyp-abi.txt
> @@ -0,0 +1,45 @@
> +* Internal ABI between the kernel and HYP
> +
> +This file documents the interaction between the Linux kernel and the
> +hypervisor layer when running Linux as a hypervisor (for example
> +KVM). It doesn't cover the interaction of the kernel with the
> +hypervisor when running as a guest (under Xen, KVM or any other
> +hypervisor), or any hypervisor-specific interaction when the kernel is
> +used as a host.
> +
> +On arm and arm64 (without VHE), the kernel doesn't run in hypervisor
> +mode, but still needs to interact with it, allowing a built-in
> +hypervisor to be either installed or torn down.
> +
> +In order to achieve this, the kernel must be booted at HYP (arm) or
> +EL2 (arm64), allowing it to install a set of stubs before dropping to
> +SVC/EL1. These stubs are accessible by using a 'hvc #0' instruction,
> +and only act on individual CPUs.
> +
> +Unless specified otherwise, any built-in hypervisor must implement
> +these functions (see arch/arm{,64}/include/asm/virt.h):
> +
> +* r0/x0 = HVC_SET_VECTORS
> +  r1/x1 = vectors
> +
> +  Set HVBAR/VBAR_EL2 to 'vectors' to enable a hypervisor. 'vectors'
> +  must be a physical address, and respect the alignment requirements
> +  of the architecture. Only implemented by the initial stubs.

Does this last sentence mean that KVM doesn't implement this function?


> +
> +* r0/x0 = HVC_RESET_VECTORS
> +
> +  Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the default
> +  value. This effectively disables an existing hypervisor.

What's the 'default value' ?  Could we say to the physical address of
the hypervisor stub's exception vector?

> +
> +* r0/x0 = HVC_SOFT_RESTART
> +  r1/x1 = restart address
> +  x2 = x0's value when entering the next payload (arm64)
> +  x3 = x1's value when entering the next payload (arm64)
> +  x4 = x2's value when entering the next payload (arm64)
> +
> +  Mask all exceptions, disable the MMU, move the arguments into place
> +  (arm64 only), and jump to the restart address while at HYP/EL2. This
> +  hypercall is not expected to return to its caller.
> +
> +Any other value of r0/x0 triggers a hypervisor-specific handling,
> +which is not documented here.
> -- 
> 2.11.0
> 

Thanks,
-Christoffer

From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH 2/7] lib: arm: Remove warning about
 uart0_base mismatch
Date: Thu, 24 Jan 2019 11:59:43 +0000
Message-ID: <20190124115943.12296810@donnerap.cambridge.arm.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-3-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42AC24A3A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 06:59:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5fX7veIKHCGo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 06:59:48 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1986B4A3A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 06:59:48 -0500 (EST)
In-Reply-To: <20190124111634.4727-3-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 24 Jan 2019 11:16:29 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> A warning is displayed if uart0_base is different from what the code
> expects qemu to generate for the pl011 UART in the device tree.
> However, now we support the ns16550a UART emulated by kvmtool, which
> has a different address. This leads to the  warning being displayed
> even though the UART is configured and working as expected.
> 
> Now that we support multiple UARTs, the warning serves no purpose, so
> remove it.

Mmh, but we use that address before, right? So for anything not
emulating an UART at this QEMU specific address we write to some random
(device) memory?

Drew, how important is this early print feature for kvm-unit-tests?

Cheers,
Andre.

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/io.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 35fc05aeb4db..87435150f73e 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -61,12 +61,6 @@ static void uart0_init(void)
>  	}
>  
>  	uart0_base = ioremap(base.addr, base.size);
> -
> -	if (uart0_base != (u8 *)UART_EARLY_BASE) {
> -		printf("WARNING: early print support may not work. "
> -		       "Found uart at %p, but early base is %p.\n",
> -			uart0_base, (u8 *)UART_EARLY_BASE);
> -	}
>  }
>  
>  void io_init(void)

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM/arm: kernel low level debug suport for ARM32 virtual
 platforms
Date: Sun, 18 Oct 2015 21:57:06 +0200
Message-ID: <20151018195706.GB7531@cbox>
References: <1445051999-24360-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B5C41049
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 15:54:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZVy8WgMzxgxO for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Oct 2015 15:54:10 -0400 (EDT)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A95C541022
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 15:54:10 -0400 (EDT)
Received: by lffv3 with SMTP id v3so98439922lff.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 12:56:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1445051999-24360-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: linux@arm.linux.org.uk, kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, will.deacon@arm.com, grant.likely@secretlab.ca, robherring2@gmail.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 16, 2015 at 08:19:59PM -0700, Mario Smarduch wrote:
> When booting a VM using QEMU or Kvmtool there are no clear ways to 
> enable low level debugging for these virtual platforms. some menu port 
> choices are not supported by the virtual platforms at all. And there is no
> help on the location of physical and virtual addresses for the ports.
> This may lead to wrong debug port and a frozen VM with a blank screen.
> 
> This patch adds menu selections for QEMU and Kvmtool virtual platforms for low 
> level kernel print debugging. Help section displays port physical and
> virutal addresses.
> 
> ARM reference models use the MIDR register to run-time select UART port address 
> (for ARCH_VEXPRESS) based on A9 or A15 part numbers. Looked for a same approach
> but couldn't find a way to differentiate between virtual platforms, something
> like a platform register.
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---

I can't think of any better way to do this and I would be happy to see
this functionality in Linux, so:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

>  arch/arm/Kconfig.debug | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index a2e16f9..d126bd4 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -1155,6 +1155,28 @@ choice
>  		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
>  		  devices, including VT8500, WM8505, WM8650 and WM8850.
>  
> +	config DEBUG_VIRT_UART_QEMU
> +		bool "Kernel low-level debugging on QEMU Virtual Platform"
> +		depends on ARCH_VIRT
> +		select DEBUG_UART_PL01X
> +		help
> +		  Say Y here if you want the debug print routines to direct
> +		  their output to PL011 UART port on QEMU Virtual Platform.
> +		  Appropriate address values are:
> +			PHYS		VIRT
> +			0x9000000	0xf8090000
> +
> +	config DEBUG_VIRT_UART_KVMTOOL
> +		bool "Kernel low-level debugging on Kvmtool Virtual Platform"
> +		depends on ARCH_VIRT
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want the debug print routines to direct
> +		  their output to 8250 UART port on Kvmtool Virtual
> +		  Platform. Appropriate address values are:
> +			PHYS		VIRT
> +			0x3f8		0xf80903f8
> +
>  	config DEBUG_ICEDCC
>  		bool "Kernel low-level debugging via EmbeddedICE DCC channel"
>  		help
> -- 
> 1.9.1
> 

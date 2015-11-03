From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH] KVM/arm: kernel low level debug support for ARM32
 virtual platforms
Date: Tue, 03 Nov 2015 11:33:17 -0500
Message-ID: <5638E1CD.8090006@codeaurora.org>
References: <1446508313-24404-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446508313-24404-1-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux@arm.linux.org.uk, will.deacon@arm.com, andre.przywara@arm.com, grant.likely@secretlab.ca, robherring2@gmail.com, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: catalin.marinas@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mario,

On 11/02/2015 06:51 PM, Mario Smarduch wrote:
> Hello,
>    this is a re-post from couple weeks ago, please take time to review this 
> simple patch which simplifies DEBUG_LL and prevents kernel crash on virtual 
> platforms.
> 
> Before this patch DEBUG_LL for 'dummy virtual machine':
> 
> ( ) Kernel low-level debugging via EmbeddedICE DCC channel
> ( ) Kernel low-level debug output via semihosting I/O
> ( ) Kernel low-level debugging via 8250 UART
> ( ) Kernel low-level debugging via ARM Ltd PL01x Primecell
> 
> In summary if debug uart is not emulated kernel crashes.
> And once you pass that hurdle, uart physical/virtual addresses are unknown.
> DEBUG_LL comes in handy on many occasions and should be somewhat 
> intuitive to use like it is for physical platforms. For virtual platforms
> user may start daubting the host and get into a bigger mess.
> 
> After this patch is applied user gets:
> 
> (X) Kernel low-level debugging on QEMU Virtual Platform
> ( ) Kernel low-level debugging on Kvmtool Virtual Platform
> 	..... above repeated ....
> 
> The virtual addresses selected follow arm reference models, high in vmalloc 
> section with high mem enabled and guest running with >= 1GB of memory. The 
> offset is leftover from arm reference models.

Which model? It doesn't appear to match the vexpress AEM/RTSM/FVP/whatever
which used 0x1c090000 for UART0.

> The patch is against 4.2.0-rc2 commit 43297dda0a51
> 
> Original Description
> --------------------
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
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
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

I thought the only guarantee the virt machine had about the memory map was
that it would be described in the device tree.

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
> 

Regards,
Christopher Covington

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

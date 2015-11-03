From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH] KVM/arm: kernel low level debug support for ARM32 virtual
 platforms
Date: Tue, 03 Nov 2015 09:44:52 -0800
Message-ID: <5638F294.4060409@samsung.com>
References: <1446508313-24404-1-git-send-email-m.smarduch@samsung.com>
 <5638E1CD.8090006@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 123D149790
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 12:41:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YCl994dcLniM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 12:41:43 -0500 (EST)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED8534904D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 12:41:43 -0500 (EST)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NX900EA92MUROA0@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 03 Nov 2015 12:44:54 -0500 (EST)
In-reply-to: <5638E1CD.8090006@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux@arm.linux.org.uk, will.deacon@arm.com, andre.przywara@arm.com, grant.likely@secretlab.ca, robherring2@gmail.com, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: catalin.marinas@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 11/3/2015 8:33 AM, Christopher Covington wrote:
> Hi Mario,
> 
> On 11/02/2015 06:51 PM, Mario Smarduch wrote:
>> Hello,
>>    this is a re-post from couple weeks ago, please take time to review this 
>> simple patch which simplifies DEBUG_LL and prevents kernel crash on virtual 
>> platforms.
>>
>> Before this patch DEBUG_LL for 'dummy virtual machine':
>>
>> ( ) Kernel low-level debugging via EmbeddedICE DCC channel
>> ( ) Kernel low-level debug output via semihosting I/O
>> ( ) Kernel low-level debugging via 8250 UART
>> ( ) Kernel low-level debugging via ARM Ltd PL01x Primecell
>>
>> In summary if debug uart is not emulated kernel crashes.
>> And once you pass that hurdle, uart physical/virtual addresses are unknown.
>> DEBUG_LL comes in handy on many occasions and should be somewhat 
>> intuitive to use like it is for physical platforms. For virtual platforms
>> user may start daubting the host and get into a bigger mess.
>>
>> After this patch is applied user gets:
>>
>> (X) Kernel low-level debugging on QEMU Virtual Platform
>> ( ) Kernel low-level debugging on Kvmtool Virtual Platform
>> 	..... above repeated ....
>>
>> The virtual addresses selected follow arm reference models, high in vmalloc 
>> section with high mem enabled and guest running with >= 1GB of memory. The 
>> offset is leftover from arm reference models.
> 
> Which model? It doesn't appear to match the vexpress AEM/RTSM/FVP/whatever
> which used 0x1c090000 for UART0.

I recall QEMU virt model had it's own physical address map, for sure I saw the
virtio-mmio regions assigned in some ARM document. Peter would you know?

As far as kvmtool I'm not sure, currently PC1 COM1 port is used? Andre will that
stay fixed?

> 
>> The patch is against 4.2.0-rc2 commit 43297dda0a51
>>
>> Original Description
>> --------------------
>> When booting a VM using QEMU or Kvmtool there are no clear ways to 
>> enable low level debugging for these virtual platforms. some menu port 
>> choices are not supported by the virtual platforms at all. And there is no
>> help on the location of physical and virtual addresses for the ports.
>> This may lead to wrong debug port and a frozen VM with a blank screen.
>>
>> This patch adds menu selections for QEMU and Kvmtool virtual platforms for low 
>> level kernel print debugging. Help section displays port physical and
>> virutal addresses.
>>
>> ARM reference models use the MIDR register to run-time select UART port address 
>> (for ARCH_VEXPRESS) based on A9 or A15 part numbers. Looked for a same approach
>> but couldn't find a way to differentiate between virtual platforms, something
>> like a platform register.
>>
>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm/Kconfig.debug | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index a2e16f9..d126bd4 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -1155,6 +1155,28 @@ choice
>>  		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
>>  		  devices, including VT8500, WM8505, WM8650 and WM8850.
>>  
>> +	config DEBUG_VIRT_UART_QEMU
>> +		bool "Kernel low-level debugging on QEMU Virtual Platform"
>> +		depends on ARCH_VIRT
>> +		select DEBUG_UART_PL01X
>> +		help
>> +		  Say Y here if you want the debug print routines to direct
>> +		  their output to PL011 UART port on QEMU Virtual Platform.
>> +		  Appropriate address values are:
>> +			PHYS		VIRT
>> +			0x9000000	0xf8090000
> 
> I thought the only guarantee the virt machine had about the memory map was
> that it would be described in the device tree.
> 
>> +	config DEBUG_VIRT_UART_KVMTOOL
>> +		bool "Kernel low-level debugging on Kvmtool Virtual Platform"
>> +		depends on ARCH_VIRT
>> +		select DEBUG_UART_8250
>> +		help
>> +		  Say Y here if you want the debug print routines to direct
>> +		  their output to 8250 UART port on Kvmtool Virtual
>> +		  Platform. Appropriate address values are:
>> +			PHYS		VIRT
>> +			0x3f8		0xf80903f8
>> +
>>  	config DEBUG_ICEDCC
>>  		bool "Kernel low-level debugging via EmbeddedICE DCC channel"
>>  		help
>>
> 
> Regards,
> Christopher Covington
> 

Return-Path: <SRS0=5K0R=HU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17738C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 12:18:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4731364E2F
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 12:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4731364E2F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76BA94B2E0;
	Thu, 18 Feb 2021 07:18:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id stn-Wk1ZMk05; Thu, 18 Feb 2021 07:18:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F35F54B326;
	Thu, 18 Feb 2021 07:18:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8768B4B2AE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 07:18:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kbzQQiaJuLxO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Feb 2021 07:18:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BC644B2A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 07:18:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 985861FB;
 Thu, 18 Feb 2021 04:18:23 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B7123F73D;
 Thu, 18 Feb 2021 04:18:22 -0800 (PST)
Subject: Re: [PATCH kvmtool 20/21] hw/serial: ARM/arm64: Use MMIO at higher
 addresses
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-21-andre.przywara@arm.com>
 <bce317a9-2c8e-2254-57c3-e0bea9a13760@arm.com>
Message-ID: <f16f89dc-78fd-1046-eefc-1dccd468fba8@arm.com>
Date: Thu, 18 Feb 2021 12:18:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <bce317a9-2c8e-2254-57c3-e0bea9a13760@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Andre,

On 2/17/21 4:48 PM, Alexandru Elisei wrote:
> Hi Andre,
>
> On 12/10/20 2:29 PM, Andre Przywara wrote:
>> Using the UART devices at their legacy I/O addresses as set by IBM in
>> 1981 was a kludge we used for simplicity on ARM platforms as well.
>> However this imposes problems due to their missing alignment and overlap
>> with the PCI I/O address space.
>>
>> Now that we can switch a device easily between using ioports and MMIO,
>> let's move the UARTs out of the first 4K of memory on ARM platforms.
>>
>> That should be transparent for well behaved guests, since the change is
>> naturally reflected in the device tree. Even "earlycon" keeps working,
>> as the stdout-path property is adjusted automatically.
>>
>> People providing direct earlycon parameters via the command line need to
>> adjust it to: "earlycon=uart,mmio,0x1000000".
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  hw/serial.c | 52 ++++++++++++++++++++++++++++++++++++----------------
>>  1 file changed, 36 insertions(+), 16 deletions(-)
>>
>> diff --git a/hw/serial.c b/hw/serial.c
>> index d840eebc..00fb3aa8 100644
>> --- a/hw/serial.c
>> +++ b/hw/serial.c
>> @@ -13,6 +13,24 @@
>>  
>>  #include <pthread.h>
>>  
>> +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
>> +#define serial_iobase(nr)	(0x1000000 + (nr) * 0x1000)
>> +#define serial_irq(nr)		(32 + (nr))
>> +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
>> +#else
>> +#define serial_iobase_0		0x3f8
>> +#define serial_iobase_1		0x2f8
>> +#define serial_iobase_2		0x3e8
>> +#define serial_iobase_3		0x2e8
>> +#define serial_irq_0		4
>> +#define serial_irq_1		3
>> +#define serial_irq_2		4
>> +#define serial_irq_3		3
> Nitpick: serial_iobase_* and serial_irq_* could be changed to have two leading
> underscores, to stress the fact that they are helpers for serial_iobase() and
> serial_irq() and are not meant to be used by themselves. But that's just personal
> preference, otherwise the patch looks really nice and clean:
>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

I gave it more thought and I think I spoke too soon. I think it would be good to
document in the commit message how you came to the base MMIO address and size
(even if it was just a nice looking number). Also, the CFI flash device has its
memory range described in the memory layout for the architecture, in
arm/include/arm-common/kvm-arch.h. I think it would be a good idea to put the
serial region there, to prevent regressions in the future.

I did the math to make sure there's no overlap with the ioport region (16M >> 16K)
or the flash region (16M + 0x4000 < 32M). I also tested the changes with a kernel
with 4K and 64K pages (I can't access any hardware with 16K pages at the moment),
and everything worked as expected.

Thanks,

Alex

> Thanks,
>
> Alex
>
>> +#define serial_iobase(nr)	serial_iobase_##nr
>> +#define serial_irq(nr)		serial_irq_##nr
>> +#define SERIAL8250_BUS_TYPE	DEVICE_BUS_IOPORT
>> +#endif
>> +
>>  /*
>>   * This fakes a U6_16550A. The fifo len needs to be 64 as the kernel
>>   * expects that for autodetection.
>> @@ -27,7 +45,7 @@ struct serial8250_device {
>>  	struct mutex		mutex;
>>  	u8			id;
>>  
>> -	u16			iobase;
>> +	u32			iobase;
>>  	u8			irq;
>>  	u8			irq_state;
>>  	int			txcnt;
>> @@ -65,56 +83,56 @@ static struct serial8250_device devices[] = {
>>  	/* ttyS0 */
>>  	[0]	= {
>>  		.dev_hdr = {
>> -			.bus_type	= DEVICE_BUS_IOPORT,
>> +			.bus_type	= SERIAL8250_BUS_TYPE,
>>  			.data		= serial8250_generate_fdt_node,
>>  		},
>>  		.mutex			= MUTEX_INITIALIZER,
>>  
>>  		.id			= 0,
>> -		.iobase			= 0x3f8,
>> -		.irq			= 4,
>> +		.iobase			= serial_iobase(0),
>> +		.irq			= serial_irq(0),
>>  
>>  		SERIAL_REGS_SETTING
>>  	},
>>  	/* ttyS1 */
>>  	[1]	= {
>>  		.dev_hdr = {
>> -			.bus_type	= DEVICE_BUS_IOPORT,
>> +			.bus_type	= SERIAL8250_BUS_TYPE,
>>  			.data		= serial8250_generate_fdt_node,
>>  		},
>>  		.mutex			= MUTEX_INITIALIZER,
>>  
>>  		.id			= 1,
>> -		.iobase			= 0x2f8,
>> -		.irq			= 3,
>> +		.iobase			= serial_iobase(1),
>> +		.irq			= serial_irq(1),
>>  
>>  		SERIAL_REGS_SETTING
>>  	},
>>  	/* ttyS2 */
>>  	[2]	= {
>>  		.dev_hdr = {
>> -			.bus_type	= DEVICE_BUS_IOPORT,
>> +			.bus_type	= SERIAL8250_BUS_TYPE,
>>  			.data		= serial8250_generate_fdt_node,
>>  		},
>>  		.mutex			= MUTEX_INITIALIZER,
>>  
>>  		.id			= 2,
>> -		.iobase			= 0x3e8,
>> -		.irq			= 4,
>> +		.iobase			= serial_iobase(2),
>> +		.irq			= serial_irq(2),
>>  
>>  		SERIAL_REGS_SETTING
>>  	},
>>  	/* ttyS3 */
>>  	[3]	= {
>>  		.dev_hdr = {
>> -			.bus_type	= DEVICE_BUS_IOPORT,
>> +			.bus_type	= SERIAL8250_BUS_TYPE,
>>  			.data		= serial8250_generate_fdt_node,
>>  		},
>>  		.mutex			= MUTEX_INITIALIZER,
>>  
>>  		.id			= 3,
>> -		.iobase			= 0x2e8,
>> -		.irq			= 3,
>> +		.iobase			= serial_iobase(3),
>> +		.irq			= serial_irq(3),
>>  
>>  		SERIAL_REGS_SETTING
>>  	},
>> @@ -444,7 +462,8 @@ static int serial8250__device_init(struct kvm *kvm,
>>  		return r;
>>  
>>  	ioport__map_irq(&dev->irq);
>> -	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
>> +	r = kvm__register_iotrap(kvm, dev->iobase, 8, serial8250_mmio, dev,
>> +				 SERIAL8250_BUS_TYPE);
>>  
>>  	return r;
>>  }
>> @@ -467,7 +486,7 @@ cleanup:
>>  	for (j = 0; j <= i; j++) {
>>  		struct serial8250_device *dev = &devices[j];
>>  
>> -		kvm__deregister_pio(kvm, dev->iobase);
>> +		kvm__deregister_iotrap(kvm, dev->iobase, SERIAL8250_BUS_TYPE);
>>  		device__unregister(&dev->dev_hdr);
>>  	}
>>  
>> @@ -483,7 +502,8 @@ int serial8250__exit(struct kvm *kvm)
>>  	for (i = 0; i < ARRAY_SIZE(devices); i++) {
>>  		struct serial8250_device *dev = &devices[i];
>>  
>> -		r = kvm__deregister_pio(kvm, dev->iobase);
>> +		r = kvm__deregister_iotrap(kvm, dev->iobase,
>> +					   SERIAL8250_BUS_TYPE);
>>  		if (r < 0)
>>  			return r;
>>  		device__unregister(&dev->dev_hdr);
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

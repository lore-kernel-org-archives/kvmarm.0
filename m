Return-Path: <SRS0=MYlw=64=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397D0C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 May 2020 13:12:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC32A206DA
	for <kvmarm@archiver.kernel.org>; Thu, 14 May 2020 13:12:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC32A206DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25A7C4B345;
	Thu, 14 May 2020 09:12:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q8Wkt8uQjn7o; Thu, 14 May 2020 09:12:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2B174B340;
	Thu, 14 May 2020 09:12:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61DD24B333
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2020 09:12:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sdf1f7gfVHxZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2020 09:12:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDA4B4B253
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2020 09:12:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77D4F1042;
 Thu, 14 May 2020 06:12:20 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B0B43F305;
 Thu, 14 May 2020 06:12:19 -0700 (PDT)
Subject: Re: [PATCH kvmtool] rtc: Generate fdt node for the real-time clock
To: Mark Rutland <mark.rutland@arm.com>
References: <20200514094553.135663-1-andre.przywara@arm.com>
 <20200514121817.GA55448@C02TD0UTHF1T.local>
From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <ab172c76-3b68-39aa-ddfd-e78b766403a3@arm.com>
Date: Thu, 14 May 2020 14:11:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514121817.GA55448@C02TD0UTHF1T.local>
Content-Language: en-US
Cc: Sami Mujawar <sami.mujawar@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On 14/05/2020 13:20, Mark Rutland wrote:

Hi,

> 
> On Thu, May 14, 2020 at 10:45:53AM +0100, Andre Przywara wrote:
>> On arm and arm64 we expose the Motorola RTC emulation to the guest,
>> but never advertised this in the device tree.
>>
>> EDK-2 seems to rely on this device, but on its hardcoded address. To
>> make this more future-proof, add a DT node with the address in it.
>> EDK-2 can then read the proper address from there, and we can change
>> this address later (with the flexible memory layout).
>>
>> Please note that an arm64 Linux kernel is not ready to use this device,
>> there are some include files missing under arch/arm64 to compile the
>> driver. I hacked this up in the kernel, just to verify this DT snippet
>> is correct, but don't see much value in enabling this properly in
>> Linux.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> With EFI at least, the expectation is that the RTC is accesses via the
> runtime EFI services. So as long as EFI knows about the RTC and the
> kernel knows about EFI, the kernel can use the RTC that way.

Yes, this is how it works at the moment.

> It would be
> problematic were the kernel to mess with the RTC behind the back of EFI
> or vice-versa, so it doesn't make sense to expose voth view to the
> kernel simultaneously.

Agreed.

> I don't think it makes sense to expose this in the DT unless EFI were
> also clearing this from the DT before handing that on to Linux. If we
> have that, I think it'd be fine, but on its own this patch introduces a
> potnetial problem that I think we should avoid.

Yes, removing or at least disabling the node was the plan, but first we
need to convince EDK-2 to actually use it first ;-)

At the moment the addresses are hardcoded, and things look fine, but we
want (and need to) become more flexible with the memory map, so just
relying on 0x70/0x71 doesn't have a future. Especially this low memory
areas already has problems.

From a kvmtool's perspective this "two users problem" shouldn't matter,
though, that's a problem that EDK-2 needs to solve, if it chooses to use
the RTC in its runtime.

And as mentioned: right now Linux can't use the Motorola RTC driver on
arm64, so there is no danger atm that the kernel picks the device up and
uses it.

But I would rather sooner than later let EDK-2 use the DT address,
before this hardcoded address usage becomes to widespread to be ignored.
And yes, I will push for disabling the DT node then in EDK-2.

Cheers,
Andre.

>> ---
>>  hw/rtc.c | 44 ++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 38 insertions(+), 6 deletions(-)
>>
>> diff --git a/hw/rtc.c b/hw/rtc.c
>> index c1fa72f2..5483879f 100644
>> --- a/hw/rtc.c
>> +++ b/hw/rtc.c
>> @@ -130,24 +130,56 @@ static struct ioport_operations cmos_ram_index_ioport_ops = {
>>  	.io_out		= cmos_ram_index_out,
>>  };
>>  
>> +#ifdef CONFIG_HAS_LIBFDT
>> +static void generate_rtc_fdt_node(void *fdt,
>> +				  struct device_header *dev_hdr,
>> +				  void (*generate_irq_prop)(void *fdt,
>> +							    u8 irq,
>> +							    enum irq_type))
>> +{
>> +	u64 reg_prop[2] = { cpu_to_fdt64(0x70), cpu_to_fdt64(2) };
>> +
>> +	_FDT(fdt_begin_node(fdt, "rtc"));
>> +	_FDT(fdt_property_string(fdt, "compatible", "motorola,mc146818"));
>> +	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
>> +	_FDT(fdt_end_node(fdt));
>> +}
>> +#else
>> +#define generate_rtc_fdt_node NULL
>> +#endif
>> +
>> +struct device_header rtc_dev_hdr = {
>> +	.bus_type = DEVICE_BUS_IOPORT,
>> +	.data = generate_rtc_fdt_node,
>> +};
>> +
>>  int rtc__init(struct kvm *kvm)
>>  {
>> -	int r = 0;
>> +	int r;
>> +
>> +	r = device__register(&rtc_dev_hdr);
>> +	if (r < 0)
>> +		return r;
>>  
>>  	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
>>  	r = ioport__register(kvm, 0x0070, &cmos_ram_index_ioport_ops, 1, NULL);
>>  	if (r < 0)
>> -		return r;
>> +		goto out_device;
>>  
>>  	r = ioport__register(kvm, 0x0071, &cmos_ram_data_ioport_ops, 1, NULL);
>> -	if (r < 0) {
>> -		ioport__unregister(kvm, 0x0071);
>> -		return r;
>> -	}
>> +	if (r < 0)
>> +		goto out_ioport;
>>  
>>  	/* Set the VRT bit in Register D to indicate valid RAM and time */
>>  	rtc.cmos_data[RTC_REG_D] = RTC_REG_D_VRT;
>>  
>> +	return r;
>> +
>> +out_ioport:
>> +	ioport__unregister(kvm, 0x0070);
>> +out_device:
>> +	device__unregister(&rtc_dev_hdr);
>> +
>>  	return r;
>>  }
>>  dev_init(rtc__init);
>> -- 
>> 2.17.1
>>
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

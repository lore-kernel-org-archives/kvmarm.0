Return-Path: <SRS0=MYlw=64=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9447C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 May 2020 12:21:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 772E520734
	for <kvmarm@archiver.kernel.org>; Thu, 14 May 2020 12:21:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 772E520734
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA8A24B34F;
	Thu, 14 May 2020 08:21:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 80U9kWl9xVjA; Thu, 14 May 2020 08:21:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E3934B34E;
	Thu, 14 May 2020 08:21:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE6514B34E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2020 08:21:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KiTEP6LtVKFW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2020 08:21:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 450304B218
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2020 08:21:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CCB211042;
 Thu, 14 May 2020 05:21:00 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.44.165])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7255B3F305;
 Thu, 14 May 2020 05:20:59 -0700 (PDT)
Date: Thu, 14 May 2020 13:20:53 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool] rtc: Generate fdt node for the real-time clock
Message-ID: <20200514121817.GA55448@C02TD0UTHF1T.local>
References: <20200514094553.135663-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200514094553.135663-1-andre.przywara@arm.com>
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

Hi Andre,

On Thu, May 14, 2020 at 10:45:53AM +0100, Andre Przywara wrote:
> On arm and arm64 we expose the Motorola RTC emulation to the guest,
> but never advertised this in the device tree.
> 
> EDK-2 seems to rely on this device, but on its hardcoded address. To
> make this more future-proof, add a DT node with the address in it.
> EDK-2 can then read the proper address from there, and we can change
> this address later (with the flexible memory layout).
> 
> Please note that an arm64 Linux kernel is not ready to use this device,
> there are some include files missing under arch/arm64 to compile the
> driver. I hacked this up in the kernel, just to verify this DT snippet
> is correct, but don't see much value in enabling this properly in
> Linux.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

With EFI at least, the expectation is that the RTC is accesses via the
runtime EFI services. So as long as EFI knows about the RTC and the
kernel knows about EFI, the kernel can use the RTC that way. It would be
problematic were the kernel to mess with the RTC behind the back of EFI
or vice-versa, so it doesn't make sense to expose voth view to the
kernel simultaneously.

I don't think it makes sense to expose this in the DT unless EFI were
also clearing this from the DT before handing that on to Linux. If we
have that, I think it'd be fine, but on its own this patch introduces a
potnetial problem that I think we should avoid.

Thanks,
Mark.

> ---
>  hw/rtc.c | 44 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/hw/rtc.c b/hw/rtc.c
> index c1fa72f2..5483879f 100644
> --- a/hw/rtc.c
> +++ b/hw/rtc.c
> @@ -130,24 +130,56 @@ static struct ioport_operations cmos_ram_index_ioport_ops = {
>  	.io_out		= cmos_ram_index_out,
>  };
>  
> +#ifdef CONFIG_HAS_LIBFDT
> +static void generate_rtc_fdt_node(void *fdt,
> +				  struct device_header *dev_hdr,
> +				  void (*generate_irq_prop)(void *fdt,
> +							    u8 irq,
> +							    enum irq_type))
> +{
> +	u64 reg_prop[2] = { cpu_to_fdt64(0x70), cpu_to_fdt64(2) };
> +
> +	_FDT(fdt_begin_node(fdt, "rtc"));
> +	_FDT(fdt_property_string(fdt, "compatible", "motorola,mc146818"));
> +	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
> +	_FDT(fdt_end_node(fdt));
> +}
> +#else
> +#define generate_rtc_fdt_node NULL
> +#endif
> +
> +struct device_header rtc_dev_hdr = {
> +	.bus_type = DEVICE_BUS_IOPORT,
> +	.data = generate_rtc_fdt_node,
> +};
> +
>  int rtc__init(struct kvm *kvm)
>  {
> -	int r = 0;
> +	int r;
> +
> +	r = device__register(&rtc_dev_hdr);
> +	if (r < 0)
> +		return r;
>  
>  	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
>  	r = ioport__register(kvm, 0x0070, &cmos_ram_index_ioport_ops, 1, NULL);
>  	if (r < 0)
> -		return r;
> +		goto out_device;
>  
>  	r = ioport__register(kvm, 0x0071, &cmos_ram_data_ioport_ops, 1, NULL);
> -	if (r < 0) {
> -		ioport__unregister(kvm, 0x0071);
> -		return r;
> -	}
> +	if (r < 0)
> +		goto out_ioport;
>  
>  	/* Set the VRT bit in Register D to indicate valid RAM and time */
>  	rtc.cmos_data[RTC_REG_D] = RTC_REG_D_VRT;
>  
> +	return r;
> +
> +out_ioport:
> +	ioport__unregister(kvm, 0x0070);
> +out_device:
> +	device__unregister(&rtc_dev_hdr);
> +
>  	return r;
>  }
>  dev_init(rtc__init);
> -- 
> 2.17.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

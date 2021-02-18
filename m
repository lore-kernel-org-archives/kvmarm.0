Return-Path: <SRS0=5K0R=HU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0071DC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 16:42:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46E6B64EAF
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 16:42:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46E6B64EAF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98FF44B28E;
	Thu, 18 Feb 2021 11:42:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1LHSUoDJh0NV; Thu, 18 Feb 2021 11:42:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AB7E4B388;
	Thu, 18 Feb 2021 11:42:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E628C4B28E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 11:42:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bSsEoUQHXYKf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Feb 2021 11:42:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F164B279
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 11:42:17 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A57F9106F;
 Thu, 18 Feb 2021 08:42:16 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F3893F73D;
 Thu, 18 Feb 2021 08:42:14 -0800 (PST)
Date: Thu, 18 Feb 2021 16:41:17 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool 21/21] hw/rtc: ARM/arm64: Use MMIO at higher
 addresses
Message-ID: <20210218164117.15fbd67a@slackpad.fritz.box>
In-Reply-To: <102807a0-812f-d4bf-b8b4-560f999c6e6c@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-22-andre.przywara@arm.com>
 <102807a0-812f-d4bf-b8b4-560f999c6e6c@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, 18 Feb 2021 13:33:15 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi Andre,
> 
> On 12/10/20 2:29 PM, Andre Przywara wrote:
> > Using the RTC device at its legacy I/O address as set by IBM in 1981
> > was a kludge we used for simplicity on ARM platforms as well.
> > However this imposes problems due to their missing alignment and overlap
> > with the PCI I/O address space.
> >
> > Now that we can switch a device easily between using ioports and
> > MMIO, let's move the RTC out of the first 4K of memory on ARM platforms.
> >
> > That should be transparent for well behaved guests, since the change is
> > naturally reflected in the device tree.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  hw/rtc.c | 24 ++++++++++++++++--------
> >  1 file changed, 16 insertions(+), 8 deletions(-)
> >
> > diff --git a/hw/rtc.c b/hw/rtc.c
> > index ee4c9102..bdb88f0f 100644
> > --- a/hw/rtc.c
> > +++ b/hw/rtc.c
> > @@ -5,6 +5,15 @@
> >  
> >  #include <time.h>
> >  
> > +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > +#define RTC_BUS_TYPE		DEVICE_BUS_MMIO
> > +#define RTC_BASE_ADDRESS	0x1010000  
> 
> This looks correct, the base address is the serial base address + 64k, so they
> don't overlap, and it doesn't overlap with the flash memory either. Same comment
> as for the serial, I think the reason for choosing this address should be
> mentioned, and the region should be put in the arch memory layout file. Other than
> that, the patch looks good.

Yep, will do!

Thanks,
Andre

> 
> > +#else
> > +/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> > +#define RTC_BUS_TYPE		DEVICE_BUS_IOPORT
> > +#define RTC_BASE_ADDRESS	0x70
> > +#endif
> > +
> >  /*
> >   * MC146818 RTC registers
> >   */
> > @@ -49,7 +58,7 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> >  	time_t ti;
> >  
> >  	if (is_write) {
> > -		if (addr == 0x70) {	/* index register */
> > +		if (addr == RTC_BASE_ADDRESS) {	/* index register */
> >  			u8 value = ioport__read8(data);
> >  
> >  			vcpu->kvm->nmi_disabled	= value & (1UL << 7);
> > @@ -70,7 +79,7 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> >  		return;
> >  	}
> >  
> > -	if (addr == 0x70)
> > +	if (addr == RTC_BASE_ADDRESS)	/* index register is write-only */
> >  		return;
> >  
> >  	time(&ti);
> > @@ -127,7 +136,7 @@ static void generate_rtc_fdt_node(void *fdt,
> >  							    u8 irq,
> >  							    enum irq_type))
> >  {
> > -	u64 reg_prop[2] = { cpu_to_fdt64(0x70), cpu_to_fdt64(2) };
> > +	u64 reg_prop[2] = { cpu_to_fdt64(RTC_BASE_ADDRESS), cpu_to_fdt64(2) };
> >  
> >  	_FDT(fdt_begin_node(fdt, "rtc"));
> >  	_FDT(fdt_property_string(fdt, "compatible", "motorola,mc146818"));
> > @@ -139,7 +148,7 @@ static void generate_rtc_fdt_node(void *fdt,
> >  #endif
> >  
> >  struct device_header rtc_dev_hdr = {
> > -	.bus_type = DEVICE_BUS_IOPORT,
> > +	.bus_type = RTC_BUS_TYPE,
> >  	.data = generate_rtc_fdt_node,
> >  };
> >  
> > @@ -151,8 +160,8 @@ int rtc__init(struct kvm *kvm)
> >  	if (r < 0)
> >  		return r;
> >  
> > -	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> > -	r = kvm__register_pio(kvm, 0x0070, 2, cmos_ram_io, NULL);
> > +	r = kvm__register_iotrap(kvm, RTC_BASE_ADDRESS, 2, cmos_ram_io, NULL,
> > +				 RTC_BUS_TYPE);
> >  	if (r < 0)
> >  		goto out_device;
> >  
> > @@ -170,8 +179,7 @@ dev_init(rtc__init);
> >  
> >  int rtc__exit(struct kvm *kvm)
> >  {
> > -	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> > -	kvm__deregister_pio(kvm, 0x0070);
> > +	kvm__deregister_iotrap(kvm, RTC_BASE_ADDRESS, RTC_BUS_TYPE);
> >  
> >  	return 0;
> >  }  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

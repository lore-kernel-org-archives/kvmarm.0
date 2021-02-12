Return-Path: <SRS0=FDJp=HO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03FDC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Feb 2021 12:01:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FDA764E02
	for <kvmarm@archiver.kernel.org>; Fri, 12 Feb 2021 12:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FDA764E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF3C4B4C8;
	Fri, 12 Feb 2021 07:01:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y1oiYxCfGowa; Fri, 12 Feb 2021 07:01:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61D6E4B4C2;
	Fri, 12 Feb 2021 07:01:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 303CC4B4BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2021 07:01:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S7pw5wb8thXD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Feb 2021 07:01:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 153154B4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2021 07:01:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2C791063;
 Fri, 12 Feb 2021 04:01:54 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A95883F719;
 Fri, 12 Feb 2021 04:01:53 -0800 (PST)
Subject: Re: [PATCH kvmtool 11/21] hw/rtc: Switch to new trap handler
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-12-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ba868501-ad8f-f1bf-7661-0ce9694e25a1@arm.com>
Date: Fri, 12 Feb 2021 12:02:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-12-andre.przywara@arm.com>
Content-Language: en-US
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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

On 12/10/20 2:28 PM, Andre Przywara wrote:
> Now that the RTC device has a trap handler adhering to the MMIO fault
> handler prototype, let's switch over to the joint registration routine.
>
> This allows us to get rid of the ioport shim routines.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/rtc.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
>
> diff --git a/hw/rtc.c b/hw/rtc.c
> index 664d4cb0..ee4c9102 100644
> --- a/hw/rtc.c
> +++ b/hw/rtc.c
> @@ -120,23 +120,6 @@ static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
>  	}
>  }
>  
> -static bool cmos_ram_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	cmos_ram_io(vcpu, port, data, size, false, NULL);
> -	return true;
> -}
> -
> -static bool cmos_ram_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	cmos_ram_io(vcpu, port, data, size, true, NULL);
> -	return true;
> -}
> -
> -static struct ioport_operations cmos_ram_ioport_ops = {
> -	.io_out		= cmos_ram_out,
> -	.io_in		= cmos_ram_in,
> -};
> -
>  #ifdef CONFIG_HAS_LIBFDT
>  static void generate_rtc_fdt_node(void *fdt,
>  				  struct device_header *dev_hdr,
> @@ -169,7 +152,7 @@ int rtc__init(struct kvm *kvm)
>  		return r;
>  
>  	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> -	r = ioport__register(kvm, 0x0070, &cmos_ram_ioport_ops, 2, NULL);
> +	r = kvm__register_pio(kvm, 0x0070, 2, cmos_ram_io, NULL);
>  	if (r < 0)
>  		goto out_device;
>  
> @@ -188,7 +171,7 @@ dev_init(rtc__init);
>  int rtc__exit(struct kvm *kvm)
>  {
>  	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> -	ioport__unregister(kvm, 0x0070);
> +	kvm__deregister_pio(kvm, 0x0070);
>  
>  	return 0;
>  }

Looks good:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

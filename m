Return-Path: <SRS0=hAGT=HS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E95C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 16 Feb 2021 14:31:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9BF364E07
	for <kvmarm@archiver.kernel.org>; Tue, 16 Feb 2021 14:31:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9BF364E07
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AFDE4B576;
	Tue, 16 Feb 2021 09:31:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OObs0ofO9QWi; Tue, 16 Feb 2021 09:31:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4E74B5E7;
	Tue, 16 Feb 2021 09:31:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8D234B576
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Feb 2021 09:31:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p5XTClVcWPmH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Feb 2021 09:31:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5B2C4B527
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Feb 2021 09:31:37 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 118DC31B;
 Tue, 16 Feb 2021 06:31:37 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16BAC3F694;
 Tue, 16 Feb 2021 06:31:35 -0800 (PST)
Subject: Re: [PATCH kvmtool 14/21] hw/serial: Switch to new trap handlers
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-15-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a38de466-4bf7-193f-fbbe-872df93d5474@arm.com>
Date: Tue, 16 Feb 2021 14:31:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-15-andre.przywara@arm.com>
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

Looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

On 12/10/20 2:29 PM, Andre Przywara wrote:
> Now that the serial device has a trap handler adhering to the MMIO fault
> handler prototype, let's switch over to the joint registration routine.
>
> This allows us to get rid of the ioport shim routines.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/serial.c | 36 +++---------------------------------
>  1 file changed, 3 insertions(+), 33 deletions(-)
>
> diff --git a/hw/serial.c b/hw/serial.c
> index 2907089c..d840eebc 100644
> --- a/hw/serial.c
> +++ b/hw/serial.c
> @@ -397,31 +397,6 @@ static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>  	}
>  }
>  
> -static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
> -				  u16 port, void *data, int size)
> -{
> -	struct serial8250_device *dev = ioport->priv;
> -	u8 value = ioport__read8(data);
> -
> -	serial8250_mmio(vcpu, port, &value, 1, true, dev);
> -
> -	return true;
> -}
> -
> -static bool serial8250_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
> -				 u16 port, void *data, int size)
> -{
> -	struct serial8250_device *dev = ioport->priv;
> -	u8 value = 0;
> -
> -
> -	serial8250_mmio(vcpu, port, &value, 1, false, dev);
> -
> -	ioport__write8(data, value);
> -
> -	return true;
> -}
> -
>  #ifdef CONFIG_HAS_LIBFDT
>  
>  char *fdt_stdout_path = NULL;
> @@ -459,11 +434,6 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
>  }
>  #endif
>  
> -static struct ioport_operations serial8250_ops = {
> -	.io_in			= serial8250_ioport_in,
> -	.io_out			= serial8250_ioport_out,
> -};
> -
>  static int serial8250__device_init(struct kvm *kvm,
>  				   struct serial8250_device *dev)
>  {
> @@ -474,7 +444,7 @@ static int serial8250__device_init(struct kvm *kvm,
>  		return r;
>  
>  	ioport__map_irq(&dev->irq);
> -	r = ioport__register(kvm, dev->iobase, &serial8250_ops, 8, dev);
> +	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
>  
>  	return r;
>  }
> @@ -497,7 +467,7 @@ cleanup:
>  	for (j = 0; j <= i; j++) {
>  		struct serial8250_device *dev = &devices[j];
>  
> -		ioport__unregister(kvm, dev->iobase);
> +		kvm__deregister_pio(kvm, dev->iobase);
>  		device__unregister(&dev->dev_hdr);
>  	}
>  
> @@ -513,7 +483,7 @@ int serial8250__exit(struct kvm *kvm)
>  	for (i = 0; i < ARRAY_SIZE(devices); i++) {
>  		struct serial8250_device *dev = &devices[i];
>  
> -		r = ioport__unregister(kvm, dev->iobase);
> +		r = kvm__deregister_pio(kvm, dev->iobase);
>  		if (r < 0)
>  			return r;
>  		device__unregister(&dev->dev_hdr);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

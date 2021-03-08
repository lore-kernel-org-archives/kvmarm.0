Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8466FC433DB
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 17:15:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD3B06522C
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 17:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD3B06522C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 450064B70C;
	Mon,  8 Mar 2021 12:15:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o0HnKUPMSVT1; Mon,  8 Mar 2021 12:15:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 112864B6AF;
	Mon,  8 Mar 2021 12:15:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F57A4B6AF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 12:15:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FVNFf1cV7QtP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 12:15:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36D084B638
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 12:15:53 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3D7BD6E;
 Mon,  8 Mar 2021 09:15:52 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFE243F71B;
 Mon,  8 Mar 2021 09:15:51 -0800 (PST)
Subject: Re: [PATCH kvmtool v2 06/22] hw/i8042: Refactor trap handler
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
 <20210225005915.26423-7-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e31b55d5-d61a-968f-9387-d0c3bbd09e2e@arm.com>
Date: Mon, 8 Mar 2021 17:16:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210225005915.26423-7-andre.przywara@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Sami Mujawar <sami.mujawar@arm.com>,
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

On 2/25/21 12:58 AM, Andre Przywara wrote:
> With the planned retirement of the special ioport emulation code, we
> need to provide an emulation function compatible with the MMIO
> prototype.
>
> Adjust the trap handler to use that new function, and provide shims to
> implement the old ioport interface, for now.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/i8042.c | 68 +++++++++++++++++++++++++++---------------------------
>  1 file changed, 34 insertions(+), 34 deletions(-)
>
> diff --git a/hw/i8042.c b/hw/i8042.c
> index 7d1f9772..ab866662 100644
> --- a/hw/i8042.c
> +++ b/hw/i8042.c
> @@ -292,52 +292,52 @@ static void kbd_reset(void)
>  	};
>  }
>  
> -/*
> - * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
> - */
> -static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> +		   u8 is_write, void *ptr)
>  {
> -	switch (port) {
> -	case I8042_COMMAND_REG: {
> -		u8 value = kbd_read_status();
> -		ioport__write8(data, value);
> +	u8 value;
> +
> +	if (is_write)
> +		value = ioport__read8(data);
> +
> +	switch (addr) {
> +	case I8042_COMMAND_REG:
> +		if (is_write)
> +			kbd_write_command(vcpu->kvm, value);
> +		else
> +			value = kbd_read_status();
>  		break;
> -	}
> -	case I8042_DATA_REG: {
> -		u8 value = kbd_read_data();
> -		ioport__write8(data, value);
> +	case I8042_DATA_REG:
> +		if (is_write)
> +			kbd_write_data(value);
> +		else
> +			value = kbd_read_data();
>  		break;
> -	}
> -	case I8042_PORT_B_REG: {
> -		ioport__write8(data, 0x20);
> +	case I8042_PORT_B_REG:
> +		if (!is_write)
> +			value = 0x20;
>  		break;
> -	}
>  	default:
> -		return false;
> +		return;
>  	}
>  
> +	if (!is_write)
> +		ioport__write8(data, value);
> +}
> +
> +/*
> + * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
> + */
> +static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +{
> +	kbd_io(vcpu, port, data, size, 0, NULL);
> +
>  	return true;
>  }
>  
>  static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>  {
> -	switch (port) {
> -	case I8042_COMMAND_REG: {
> -		u8 value = ioport__read8(data);
> -		kbd_write_command(vcpu->kvm, value);
> -		break;
> -	}
> -	case I8042_DATA_REG: {
> -		u8 value = ioport__read8(data);
> -		kbd_write_data(value);
> -		break;
> -	}
> -	case I8042_PORT_B_REG: {
> -		break;
> -	}
> -	default:
> -		return false;
> -	}
> +	kbd_io(vcpu, port, data, size, 1, NULL);

I think I made a mistake when I suggested that is_write should 0 or 1. I followed
the emulation path in kvmtool and it turns out that is_write is supposed to
represent the field with the same name from the anonymous struct mmio from struct
kvm_run (more precisely, the struct defined at line 4980 from
Documentation/virt/kvm/api.rst, Linux tag v5.11). I think the is_write field is
declared in kvm_run as an u8 for compatibility with an userspace which might not
know about the bool type. is_write is also treated as a bool in the MMIO exit path
by KVM (see arch/arm64/kvm/mmio.c::io_mem_abort()).

kvmtool assigns is_write a boolean value everywhere except in this file, would you
mind changing it back to a bool? Sorry for suggesting the wrong thing.

I checked that the code remains functionally identical, with the above change:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  
>  	return true;
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

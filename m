Return-Path: <SRS0=hpFi=HN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E68EC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Feb 2021 17:23:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A54C564DE9
	for <kvmarm@archiver.kernel.org>; Thu, 11 Feb 2021 17:23:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A54C564DE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E044B39E;
	Thu, 11 Feb 2021 12:23:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0jbUpt3V6mcR; Thu, 11 Feb 2021 12:23:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D61504B3BD;
	Thu, 11 Feb 2021 12:23:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 264D94B39E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2021 12:23:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 780RvH0xbCvq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2021 12:23:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D58134B395
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2021 12:23:04 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DCD411D4;
 Thu, 11 Feb 2021 09:23:04 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C75A33F73B;
 Thu, 11 Feb 2021 09:23:02 -0800 (PST)
Subject: Re: [PATCH kvmtool 06/21] hw/i8042: Refactor trap handler
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-7-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <288df0e8-997c-7691-2dda-017876dba3f4@arm.com>
Date: Thu, 11 Feb 2021 17:23:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-7-andre.przywara@arm.com>
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
> index 36ee183f..eb1f9d28 100644
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

Any particular reason for removing the false return value? I don't see it
mentioned in the commit message. Otherwise this is identical to the two functions
it replaces.

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
> +	kbd_io(vcpu, port, data, size, false, NULL);

is_write is an u8, not a bool.

I never could wrap my head around the ioport convention of "in" (read) and "out"
(write). To be honest, changing is_write changed to an enum so it's crystal clear
what is happening would help with that a lot, but I guess that's a separate patch.

Thanks,

Alex

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
> +	kbd_io(vcpu, port, data, size, true, NULL);
>  
>  	return true;
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

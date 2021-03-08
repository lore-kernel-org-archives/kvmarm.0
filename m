Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707A9C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 17:21:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA38865235
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 17:21:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA38865235
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EDFE4B711;
	Mon,  8 Mar 2021 12:21:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JGtjafpE50Mf; Mon,  8 Mar 2021 12:21:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3C914B6FC;
	Mon,  8 Mar 2021 12:21:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C00B4B6FC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 12:21:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MVBZRQY0ur+q for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 12:21:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26F004B6F9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 12:21:43 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82B21D6E;
 Mon,  8 Mar 2021 09:21:42 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 886EA3F71B;
 Mon,  8 Mar 2021 09:21:41 -0800 (PST)
Subject: Re: [PATCH kvmtool v2 07/22] hw/i8042: Switch to new trap handlers
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
 <20210225005915.26423-8-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3a77522e-c3f7-7250-5a9a-0533400ce9bd@arm.com>
Date: Mon, 8 Mar 2021 17:22:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210225005915.26423-8-andre.przywara@arm.com>
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

On 2/25/21 12:59 AM, Andre Przywara wrote:
> Now that the PC keyboard has a trap handler adhering to the MMIO fault
> handler prototype, let's switch over to the joint registration routine.
>
> This allows us to get rid of the ioport shim routines.
>
> Make the kbd_init() function static on the way.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/i8042.c          | 30 ++++--------------------------
>  include/kvm/i8042.h |  1 -
>  2 files changed, 4 insertions(+), 27 deletions(-)
>
> diff --git a/hw/i8042.c b/hw/i8042.c
> index ab866662..20be36c4 100644
> --- a/hw/i8042.c
> +++ b/hw/i8042.c
> @@ -325,40 +325,18 @@ static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>  		ioport__write8(data, value);
>  }
>  
> -/*
> - * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
> - */
> -static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	kbd_io(vcpu, port, data, size, false, NULL);
> -
> -	return true;
> -}
> -
> -static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	kbd_io(vcpu, port, data, size, true, NULL);
> -
> -	return true;
> -}
> -
> -static struct ioport_operations kbd_ops = {
> -	.io_in		= kbd_in,
> -	.io_out		= kbd_out,
> -};
> -
> -int kbd__init(struct kvm *kvm)
> +static int kbd__init(struct kvm *kvm)
>  {
>  	int r;
>  
>  	kbd_reset();
>  	state.kvm = kvm;
> -	r = ioport__register(kvm, I8042_DATA_REG, &kbd_ops, 2, NULL);
> +	r = kvm__register_pio(kvm, I8042_DATA_REG, 2, kbd_io, NULL);
>  	if (r < 0)
>  		return r;
> -	r = ioport__register(kvm, I8042_COMMAND_REG, &kbd_ops, 2, NULL);
> +	r = kvm__register_pio(kvm, I8042_COMMAND_REG, 2, kbd_io, NULL);
>  	if (r < 0) {
> -		ioport__unregister(kvm, I8042_DATA_REG);
> +		kvm__deregister_pio(kvm, I8042_DATA_REG);
>  		return r;
>  	}
>  
> diff --git a/include/kvm/i8042.h b/include/kvm/i8042.h
> index 3b4ab688..cd4ae6bb 100644
> --- a/include/kvm/i8042.h
> +++ b/include/kvm/i8042.h
> @@ -7,6 +7,5 @@ struct kvm;
>  
>  void mouse_queue(u8 c);
>  void kbd_queue(u8 c);
> -int kbd__init(struct kvm *kvm);
>  
>  #endif

Looks good, I also compile tested the code:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

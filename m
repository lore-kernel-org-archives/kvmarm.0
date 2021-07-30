Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D891C4338F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 10:47:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1D6260462
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 10:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D1D6260462
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4B54ACC9;
	Fri, 30 Jul 2021 06:47:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AS3mOhdiUUi3; Fri, 30 Jul 2021 06:47:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37DBE4B090;
	Fri, 30 Jul 2021 06:47:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC0B4079D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 06:47:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j7Vrj70ewIpj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 06:47:44 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF3724075E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 06:47:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=WD2Ag4JED4QIsvoIQN/gUdEl19MyG+gX26ckt/2TnRM=; b=wNjsq2UUJjLuncBCL1YsnTrm0
 YXYmurFWsXKUm2L2J6I/ypUlXwg6ahaMW1adauhejdybPNoV1znnmnxnBQE7zBZc3hiHNA70er0TI
 QnYpssBHkV8KBet2y5hmFMhE39l0DvuwgvbgZ0fqc5k0GCfAVD82AU47p5lagEFMKX6EwrPmcUuQf
 0RzJNbNT94GC9OKKBbbhwI8Po+HCAFRODBNYzP5zCse901ce9un9gcI6vTyY548AnZny/xjNRDv6s
 Lb108Ee4PLeZUMVJX0zUdAchyPz3c4fqfDYw0Cckeo3R8jGRFEZmHnrutm/pKoieeyzfQfhmhr16V
 0fey8HIUw==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46754)
 by pandora.armlinux.org.uk with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <linux@armlinux.org.uk>)
 id 1m9Q2U-0002GT-LV; Fri, 30 Jul 2021 11:46:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1m9Q2N-0008Nd-T1; Fri, 30 Jul 2021 11:46:43 +0100
Date: Fri, 30 Jul 2021 11:46:43 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH] memblock: make memblock_find_in_range method private
Message-ID: <20210730104643.GG22278@shell.armlinux.org.uk>
References: <20210730104039.7047-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210730104039.7047-1-rppt@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, linux-acpi@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, x86@kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Len Brown <lenb@kernel.org>, devicetree@vger.kernel.org,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Rob Herring <robh+dt@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Fri, Jul 30, 2021 at 01:40:39PM +0300, Mike Rapoport wrote:
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index f97eb2371672..1f8ef9fd5215 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -1012,31 +1012,25 @@ static void __init reserve_crashkernel(void)
>  		unsigned long long lowmem_max = __pa(high_memory - 1) + 1;
>  		if (crash_max > lowmem_max)
>  			crash_max = lowmem_max;
> -		crash_base = memblock_find_in_range(CRASH_ALIGN, crash_max,
> -						    crash_size, CRASH_ALIGN);
> +
> +		crash_base = memblock_phys_alloc_range(crash_size, CRASH_ALIGN,
> +						       CRASH_ALIGN, crash_max);
>  		if (!crash_base) {
>  			pr_err("crashkernel reservation failed - No suitable area found.\n");
>  			return;
>  		}
>  	} else {
> +		unsigned long long crash_max = crash_base + crash_size;
>  		unsigned long long start;
>  
> -		start = memblock_find_in_range(crash_base,
> -					       crash_base + crash_size,
> -					       crash_size, SECTION_SIZE);
> +		start = memblock_phys_alloc_range(crash_size, SECTION_SIZE,
> +						  crash_base, crash_max);
>  		if (start != crash_base) {
> -			pr_err("crashkernel reservation failed - memory is in use.\n");
> +			pr_err("crashkernel reservation failed - No suitable area found.\n");

This change to the error message is incorrect. In this code block, we
are trying to get the exact specified memory block - it is not about
there being "no suitable area" - the requested memory block is not
available. So, the original message carries the exact correct meaning.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

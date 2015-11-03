From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] KVM/arm: kernel low level debug support for ARM32
 virtual platforms
Date: Tue, 3 Nov 2015 17:33:44 +0000
Message-ID: <20151103173344.GC8644@n2100.arm.linux.org.uk>
References: <1446508313-24404-1-git-send-email-m.smarduch@samsung.com>
 <5638E1CD.8090006@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83E3C49794
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 12:30:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c5bVyljsKDTB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 12:30:49 -0500 (EST)
Received: from pandora.arm.linux.org.uk (pandora.arm.linux.org.uk
 [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBFD349776
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 12:30:48 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <5638E1CD.8090006@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, will.deacon@arm.com, grant.likely@secretlab.ca, robherring2@gmail.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 03, 2015 at 11:33:17AM -0500, Christopher Covington wrote:
> > diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> > index a2e16f9..d126bd4 100644
> > --- a/arch/arm/Kconfig.debug
> > +++ b/arch/arm/Kconfig.debug
> > @@ -1155,6 +1155,28 @@ choice
> >  		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
> >  		  devices, including VT8500, WM8505, WM8650 and WM8850.
> >  
> > +	config DEBUG_VIRT_UART_QEMU
> > +		bool "Kernel low-level debugging on QEMU Virtual Platform"
> > +		depends on ARCH_VIRT
> > +		select DEBUG_UART_PL01X
> > +		help
> > +		  Say Y here if you want the debug print routines to direct
> > +		  their output to PL011 UART port on QEMU Virtual Platform.
> > +		  Appropriate address values are:
> > +			PHYS		VIRT
> > +			0x9000000	0xf8090000
> 
> I thought the only guarantee the virt machine had about the memory map was
> that it would be described in the device tree.

This LL debug stuff is used prior to device tree being parsed.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

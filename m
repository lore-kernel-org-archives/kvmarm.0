From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 01/19] arm64: asm-offsets: Avoid clashing DMA
 definitions
Date: Mon, 11 Dec 2017 15:03:08 +0000
Message-ID: <20171211150307.GV10595@n2100.armlinux.org.uk>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
 <20171211144937.4537-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171211144937.4537-2-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 11, 2017 at 02:49:19PM +0000, Marc Zyngier wrote:
> asm-offsets.h contains a few DMA related definitions that have
> the exact same name than the enum members they are derived from.
> 
> While this is not a problem so far, it will become an issue if
> both asm-offsets.h and include/linux/dma-direction.h: are pulled
> by the same file.

Umm.  asm-offsets.h is only supposed to be included by assembly files.
Assembly files would not be able to include linux/dma-direction.h
So this shouldn't be a problem.

The same could be true of things like CLOCK_REALTIME etc.

Just don't do it.  Keep asm-offsets.h as something that gets included
by assembly and only assembly.

If you need to know the offset of some member, use offsetof(), don't
re-use asm-offsets.h.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up

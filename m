From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 01/19] arm64: asm-offsets: Avoid clashing DMA
 definitions
Date: Mon, 11 Dec 2017 15:22:58 +0000
Message-ID: <44ae7c94-61af-fba6-a32f-37a31f536895@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
 <20171211144937.4537-2-marc.zyngier@arm.com>
 <20171211150307.GV10595@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4015E49D5E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 10:19:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VdG0WQt2riWM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 10:19:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E56949D54
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 10:19:35 -0500 (EST)
In-Reply-To: <20171211150307.GV10595@n2100.armlinux.org.uk>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/12/17 15:03, Russell King - ARM Linux wrote:
> On Mon, Dec 11, 2017 at 02:49:19PM +0000, Marc Zyngier wrote:
>> asm-offsets.h contains a few DMA related definitions that have
>> the exact same name than the enum members they are derived from.
>>
>> While this is not a problem so far, it will become an issue if
>> both asm-offsets.h and include/linux/dma-direction.h: are pulled
>> by the same file.
> 
> Umm.  asm-offsets.h is only supposed to be included by assembly files.
> Assembly files would not be able to include linux/dma-direction.h
> So this shouldn't be a problem.
> 
> The same could be true of things like CLOCK_REALTIME etc.
> 
> Just don't do it.  Keep asm-offsets.h as something that gets included
> by assembly and only assembly.

That'd be true if C code never used anything that is exposed by
asm-offsets.h. Unfortunately, things like our alternative patching
relies on generating assembly (or rather, using assembly generated data
structures). For more details, please see patch 4 in the same series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

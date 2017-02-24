From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: A question about TTBRs
Date: Fri, 24 Feb 2017 12:10:21 +0000
Message-ID: <20170224121020.GB417@leverpostej>
References: <CAPB=Z-omrvPjkjmQWfLNWtA86XJzEM1wCB1Rbc-2dnd0iUtaDA@mail.gmail.com>
 <20170224102240.GG1409@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94DB140DB7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 07:09:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7-FbR-da-pGo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Feb 2017 07:09:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DCE540DAF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 07:09:27 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170224102240.GG1409@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, Raz <raziebe@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 24, 2017 at 11:22:40AM +0100, Christoffer Dall wrote:
> On Fri, Feb 24, 2017 at 09:55:09AM +0000, Raz wrote:
> > Hello
> > I am reading the arm8a book. According to the documentation the output
> > address of each level 3 entry in TTBRx_EL1points to an address in the
> > physical memory.
> > By looking in the mmu tab in the DS5 studio I can see the TTBRs tables.
> > 
> > What I do not understand is why while I have 2GB of RAM in the FVP (
> > /proc/meminfo ) some page entries ( level 3 ) of the ttbr points to memory
> > above 4GB; for instance:
> > 
> > Output address NP:0xF794D000
> > 
> > Doesn't the physical memory starts at address zero ? if not, where its
> > starting point is configured?
> 
> It depends on your particular system where RAM starts, and it does not
> necessarily start at zero.  You'd have to check the documentation of
> your model or hardware or look at the device tree you use, for example.

It's also worth bearing in mind that memory is not necessarily
physically contiguous. There may be several banks with gaps in the
middle, as is the case on ARM Juno systems [1]:

	memory@80000000 {
		device_type = "memory";
		/* last 16MB of the first memory area is reserved for secure world use by firmware */
		reg = <0x00000000 0x80000000 0x0 0x7f000000>,
		      <0x00000008 0x80000000 0x1 0x80000000>;
	};

It may also be the case that MMIO devices fall within these gaps.

Thanks,
Mark.

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/arm/juno-base.dtsi?h=v4.10&id=c470abd4fde40ea6a0846a2beab642a578c0b8cd

From: Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH 07/12] arm64: mm: Place kImage at bottom of VA space
Date: Tue, 12 Dec 2017 11:03:54 +0000
Message-ID: <20171212110354.e3h5r6zhh24osjn5@capper-debian.cambridge.arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
 <20171204141313.31604-8-steve.capper@arm.com>
 <CAKv+Gu_A-fAMpheWbKZ+prEVKHR58er7sXz0L93Af1XhJrGZeQ@mail.gmail.com>
 <20171204171809.wvrqfd435bh7i5r4@capper-debian.cambridge.arm.com>
 <CAKv+Gu9Mjd7f57ZZdv+1p70Vs-YD8p6-1P=pb4-KAUsxNVppGw@mail.gmail.com>
 <20171204181213.or2t24rdh6uwj3iu@capper-debian.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AADAD49D27
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 06:00:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uetqueHKBjTi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Dec 2017 06:00:33 -0500 (EST)
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-eopbgr30069.outbound.protection.outlook.com [40.107.3.69])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6218E406D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 06:00:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171204181213.or2t24rdh6uwj3iu@capper-debian.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, nd@arm.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 04, 2017 at 06:12:13PM +0000, Steve Capper wrote:
> On Mon, Dec 04, 2017 at 05:27:10PM +0000, Ard Biesheuvel wrote:
> > On 4 December 2017 at 17:18, Steve Capper <steve.capper@arm.com> wrote:
> > > Hi Ard,
> > >
> > > On Mon, Dec 04, 2017 at 04:25:18PM +0000, Ard Biesheuvel wrote:
> > >> On 4 December 2017 at 14:13, Steve Capper <steve.capper@arm.com> wrote:
> > >> > Re-arrange the kernel memory map s.t. the kernel image resides in the
> > >> > bottom 514MB of memory.
> > >>
> > >> I guess this breaks KASLR entirely, no? Given that it adds an offset
> > >> in the range [0 ... sizeof(VMALLOC_SPACE) /4 ].
> > >
> > > Yes, yes it does. Sorry about this. I had very carefully tested KASLR
> > > with custom offsets... on my early page table code. I will have a think
> > > about this.
> > >
> > > From a KASLR side, my (renewed) understanding is that a virtual address
> > > as low as possible is desired for the kimage start as that affords the
> > > most wiggle room?
> > >
> > 
> > Well, the nice thing about the current arrangement is that the default
> > is adjacent to the vmalloc space so any non-zero [bounded] offset
> > produces a valid placement. Addition with subtraction is easy, so
> > which side the default placement happens to be at does not really
> > matter. Having to implement additional bounds checking in the early
> > KASLR init code to stay clear of the PCI I/O or fixmap regions sounds
> > a bit more cumbersome.
> > 
> 
> I *think* I can fix KASAN_SHADOW_END to be 0xFFFF200000000000 on both 48-bit
> and 52-bit VA configurations. Thus I may be able to enable 52-bit VA with
> minimal disruption to the layout of the VA space (i.e. no need to change
> the layout) if I also depend on CONFIG_RELOCATABLE.
> 

Unfortunately, having KASAN_SHADOW_END at 0xFFFF2000000000000 doesn't
work with 52-bit VAs as this would place it in the direct linear map
area.

So I think we need to flip the two halves of the kernel address space in
order to accommodate inline KASAN that operates under multiple VA space
sizes (I couldn't figure out any way to patch the inline KASAN instrumentation).

Cheers,
-- 
Steve

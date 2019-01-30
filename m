From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH kvmtool v2 0/6] arm: Add support for firmware booting
Date: Wed, 30 Jan 2019 18:19:59 +0000
Message-ID: <20190130181959.GD18558@fuggles.cambridge.arm.com>
References: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
 <20190122071024.GB10214@brain-police>
 <b5e4bd1c-8bb5-36ca-026e-59fd92a4486d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D26924A2D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 13:20:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id biDkAFZcf29H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 13:20:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0F3F4A2AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 13:20:03 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <b5e4bd1c-8bb5-36ca-026e-59fd92a4486d@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: andre.przywara@arm.com, Sami.Mujawar@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 22, 2019 at 09:00:01AM +0000, Julien Thierry wrote:
> On 22/01/2019 07:10, Will Deacon wrote:
> > I've picked up the first four patches of this series, but I don't really
> 
> Thanks!
> 
> > understand where you're going with the non-volatile memory part and whether
> > it's nvram, flash or something completely different. Given that Linux
> > doesn't support your binding, is this something that UEFI currently uses?
> > 
> 
> So the thing is that UEFI/EDK2 needs some kind of readable and writable
> non-volatile memory (flash or nv-ram, not sure what's the difference) to
> load/store its environment. For kvmtool, we can just provide memory
> region where the environment is mapped and EDK2 can just directly read
> from or write to it.
> 
> The thing is, when looking at the flash binding in Linux, each platform
> seems to have its own binding of their flash device (Which I guess makes
> sense since they don't necessarily work the same way). I couldn't find
> any existing generic bindings that seemed to fit what I'm presenting to
> EDK2 (which could also be used by another firmware if they needed a
> binary blob in flash or something).

We could probably abuse memreserve for this, which I think happens in the
wild already for non-memory regions. However, if the non-volatile region is
outside of ram, then why do we care at all? Is UEFI parsing the dts to
locate it? If so, I'd have thought that they would need to get a binding
sorted for that purpose, in which case we can just use that.

Will

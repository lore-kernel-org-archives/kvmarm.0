From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 07/31] KVM: arm/arm64: vgic-v3: Add accessors for the
 ICH_APxRn_EL2 registers
Date: Tue, 30 May 2017 17:42:07 +0100
Message-ID: <20170530164206.GB16541@leverpostej>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-8-marc.zyngier@arm.com>
 <20170503153201.GC4951@leverpostej>
 <3b9ed468-71ac-786c-b587-27968c3f3af9@arm.com>
 <dcf371d4-f3d7-be1c-789a-22eb5509a729@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dcf371d4-f3d7-be1c-789a-22eb5509a729@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 30, 2017 at 05:17:01PM +0100, Marc Zyngier wrote:
> On 03/05/17 16:58, Marc Zyngier wrote:
> > On 03/05/17 16:32, Mark Rutland wrote:
> >> On Wed, May 03, 2017 at 11:45:42AM +0100, Marc Zyngier wrote:
> >>> +static void __hyp_text __vgic_v3_write_ap0rn(u32 val, int n)
> >>> +{
> >>> +	switch (n) {
> >>> +	case 0:
> >>> +		write_gicreg(val, ICH_AP0R0_EL2);
> >>> +		break;
> >>> +	case 1:
> >>> +		write_gicreg(val, ICH_AP0R1_EL2);
> >>> +		break;
> >>> +	case 2:
> >>> +		write_gicreg(val, ICH_AP0R2_EL2);
> >>> +		break;
> >>> +	case 3:
> >>> +		write_gicreg(val, ICH_AP0R3_EL2);
> >>> +		break;
> >>> +	}
> >>
> >> Is there any way we can get a build or runtime failure for an
> >> out-of-bounds n value?
> > 
> > I'd rather avoid runtime failure on this path, because that's pretty
> > terminal. Build-time is a possibility, to some extent.

> >> Given this is used with a constant n, you could make this:
> >>
> >> #define __vgic_v3_write_ap0rn(v, n) \
> >> 	write_gicreg(v, ICH_AP0R##n##_EL2)
> >>
> >> ... which should also give you a warning for an out-of-bounds n.
> >>
> >> Similar could apply for the other helpers here.
> >>
> >> That would require some function -> macro conversion in later patches
> >> though, so I can understand if you're not keen on that.
> > 
> > I don't mind reworking this if that makes it safer. But the real problem
> > is that the register number and the group are not necessarily constants
> > (see how this is used in __vgic_v3_get_highest_active_priority).
> > 
> > I'll have a look at how I can make that look a bit better.
> 
> So I had another look at that, and I'm not sure there is any way to make
> it really nicer, other than expanding all of the apxrn accessors to deal
> with non constant x and n (which makes the code look really awful).
> 
> I'm pretty confident that it is nigh impossible to get x or n out of
> bounds so unless someone shouts, I plan on keeping this code mostly
> unchanged for the next repost.

Fair enough, thanks for taking a look anyhow.

Thanks,
Mark.

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] KVM: arm64: vgic-its: Make updates to
 propbaser/pendbaser atomic
Date: Tue, 9 Aug 2016 13:56:36 +0200
Message-ID: <20160809115636.GF9175@cbox>
References: <20160803161325.14933-1-christoffer.dall@linaro.org>
 <20160803161325.14933-4-christoffer.dall@linaro.org>
 <28496b0a-6ca3-4cba-ca53-d97aabfe9280@arm.com>
 <20160809103012.GD9175@cbox>
 <35bd94e0-949f-d1bd-9014-1cd6bfb9e5ab@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <35bd94e0-949f-d1bd-9014-1cd6bfb9e5ab@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 09, 2016 at 12:19:53PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 09/08/16 11:30, Christoffer Dall wrote:
> > On Mon, Aug 08, 2016 at 02:30:38PM +0100, Andre Przywara wrote:
> >> Hi,
> >>
> >> On 03/08/16 17:13, Christoffer Dall wrote:
> >>> There are two problems with the current implementation of the MMIO
> >>> handlers for the propbaser and pendbaser:
> >>>
> >>> First, the write to the value itself is not guaranteed to be an atomic
> >>> 64-bit write so two concurrent writes to the structure field could be
> >>> intermixed.
> >>>
> >>> Second, because we do a read-modify-update operation without any
> >>> synchronization, if we have two 32-bit accesses to separate parts of the
> >>> register, we can loose one of them.
> >>
> >> I am still not 100% convinced that this is necessary, but leave it up to
> >> the judgement of you senior guys.
> > 
> > ok, consider this case:
> > 
> >     reg = 0x55555555 55555555;
> > 
> >     CPU 0                CPU 1
> >     -----                -----
> >     tmp = reg;
> >                          tmp = reg;
> >     tmp[63:32] = ~0;
> >                          tmp[31:0] = 0;
> >     reg = tmp;
> >                          reg = tmp;
> > 
> >     print("reg is %x", reg);
> >       /* reg is 0x55555555 00000000 */
> > 
> > which is weird, because I think in hardware you'll get:
> >     0xffffffff 00000000
> > 
> > no matter how you order the two 32-bit updates.
> > 
> > That is, unless the architecture tells us that you could observe the
> > above behavior.
> 
> OK, I can see that this case is indeed broken. I was just wondering how
> much software can expect if it allows unsynchronized accesses from
> different CPUs to such a 64-bit register - even if it is for separate
> halves of that register. I'd expect (guest) software to take a lock if
> it can't atomically update prop/pendbaser and there are other agents
> possibly chiming in.
> And I hope we sanitize them enough now to avoid any bad things to happen
> in the kernel ;-)
> 
I don't think it's 100% unreasonable to potentially imagine independent
updates of parts of the register when the spec explicitly says this is
allowed.

I agree, that it would be a curious guest (and I raised this point once
already), but I think relying on this is a terrible approach to
emulating hardware and without any comment or anything in the kernel
saying 'this is safe and reasonable because of so and so' it just looks
too dodgy for me to live with.

-Christoffer

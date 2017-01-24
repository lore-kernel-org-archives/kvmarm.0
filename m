From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Add debugfs vgic-state file
Date: Tue, 24 Jan 2017 13:52:07 +0100
Message-ID: <20170124125207.GP15850@cbox>
References: <20170120103330.13858-1-christoffer.dall@linaro.org>
 <524751ae-8e17-f9a0-88c6-95d4614478af@arm.com>
 <20170124105833.GM15850@cbox>
 <fde51e21-5f90-b2de-72a6-3ba04ed04893@arm.com>
 <20170124122954.GO15850@cbox>
 <1b65df04-0b3d-b012-ac33-9b3727a66c7c@foss.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1b65df04-0b3d-b012-ac33-9b3727a66c7c@foss.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@foss.arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Alex Bennee <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 24, 2017 at 12:35:43PM +0000, Andre Przywara wrote:
> Hi,
> 
> [...]
> 
> >>>>
> >>>> As I didn't understand the seq_* semantics in the first place, I didn't
> >>>> have a look yet what could cause this.
> >>>
> >>> Nice catch, I'll have a look at this.
> >>>
> >>> Just so I'm sure, these are two processes reading the vgic-state file
> >>> for the same single VM, right?
> >>
> >> Yes, just one VM. I was about to write a small test program which is a
> >> bit more nasty and launches <n> threads all doing lseek();read(); on the
> >> same file in a loop, but it turned out that this isn't necessary ;-)
> >> I have that now working, so I can give this a test later.
> >>
> >> I was wondering if you could ditch that lseek / offset setting feature
> >> at all? The smaller debugfs files don't support it as well (ESPIPE on
> >> lseek()). Is that an option when setting up the seq interface?
> >>
> > 
> > I think that only works if you're guaranteed to always only print within
> > the buffer allocated for a single read, but if you run out of buffer
> > space the seq_file code will allocate more space, do the fast forward
> > thing, and continue reading where it left off.  I feel like when we're
> > enumaring over 1000 irqs and could be spitting out a bunch of LPI data
> > later on, this is a bit fragile.
> > The recommendations also state you should only do this if you don't need
> > a lot of locking or printing small data amounts, but I'm not enough of
> > an expert on the seq file to know exactly when that applies and when it
> > doesn't, but it doesn't feel like this fits within that bracket.
> 
> Thanks for the explanation, and this indeed makes some sense.
> I just wanted to save you some nasty debugging, instead tricking you
> into just papering over the issue ;-)
> 
Indeed, I'm all for that if it works :)

Thanks,
-Christoffer

From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Fri, 30 Sep 2016 17:43:35 +0200
Message-ID: <20160930154335.GB7996@cbox>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
 <de375a6e-095c-a17a-0db7-876a5619df42@suse.de>
 <3e85d538-2539-f190-0d17-a2ecfe7b48ce@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3e85d538-2539-f190-0d17-a2ecfe7b48ce@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 30, 2016 at 05:38:11PM +0200, Alexander Graf wrote:
> 
> 
> On 30.09.16 16:54, Alexander Graf wrote:
> > 
> > 
> > On 27.09.16 21:08, Christoffer Dall wrote:
> >> Hi Alex,
> >>
> >> Marc and I have been looking at this during Linaro connect and have
> >> slightly reworked your patch into this small series.
> >>
> >> It would be good if you could have a look at it and test it out.
> >>
> >> I've tested it with your QEMU, and it works for UP, but secondary CPUs
> >> fail to come up, and it looks like the kernel never gets an IPI for
> >> those CPUs from userspace.  Any chance you're willing to take a look at
> >> that?
> > 
> > I still need to see whether I can come up with a prettier solution, but
> > for now this works:
> > 
> > diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> 
> Eh, no, not in i386 code :). But the problem seems to be a missing
> mpstate sync.
> 
Yeah, that looked really dodgy.  Have you tested it? :)

-Christoffer

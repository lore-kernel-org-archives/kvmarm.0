From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH kvm-unit-tests] arm64: timer: Avoid IRQ race in timer test
Date: Thu, 3 Aug 2017 08:24:21 +0200
Message-ID: <20170803062421.GA17272@cbox>
References: <20170726114249.17774-1-cdall@linaro.org>
 <20170802155312.yep4rywinl5pmc6i@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170802155312.yep4rywinl5pmc6i@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 02, 2017 at 05:53:12PM +0200, Andrew Jones wrote:
> On Wed, Jul 26, 2017 at 01:42:49PM +0200, Christoffer Dall wrote:
> > The current timer test relies on testing the pending state of the timer
> > before the interrupt handler has run which could lower the pending
> > signal again (because it masks the timer output signal).
> > 
> > What we really want is to make sure the output signal from the timer as
> > perceived by the virtual interrupt controller is low when the timer is
> > programmed some time far in the future.  The proper way to do that is to
> > disable the timer interrupt on the distributor and then reading its
> > pending state.
> > 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  arm/timer.c | 41 ++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 34 insertions(+), 7 deletions(-)
> >
> 
> Hi Christoffer,
> 
> With this patch the ptimer "not pending before" test always
> fails on KVM for me (tested on mustang and thunderx). Have
> you seen that?
> 

Doy, yeah, that was a silly one.  Patch incoming.

Thanks,
-Christoffer

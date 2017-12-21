From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [kvm-unit-tests PATCH] Support micro operation measurement on
 arm64
Date: Thu, 21 Dec 2017 12:31:50 +0100
Message-ID: <20171221113150.GC29301@cbox>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <20171218181440.yggldvw6lry6wsza@hawk.localdomain>
 <CAO+sbHGU6EUUHQynAaA33T-ThUwA=5f9yq_Uq2mLtXRcHN02Ew@mail.gmail.com>
 <20171219090620.GA31048@cbox>
 <20171219121109.hxqbqjkdgt7k5jo6@hawk.localdomain>
 <20171219130706.GD31048@cbox>
 <20171220162254.dp5vok6lgbxyo5od@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171220162254.dp5vok6lgbxyo5od@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 20, 2017 at 05:22:54PM +0100, Andrew Jones wrote:
> On Tue, Dec 19, 2017 at 02:07:06PM +0100, Christoffer Dall wrote:
> > On Tue, Dec 19, 2017 at 01:11:09PM +0100, Andrew Jones wrote:
> > > On Tue, Dec 19, 2017 at 10:06:20AM +0100, Christoffer Dall wrote:
> > > > On Mon, Dec 18, 2017 at 03:58:49PM -0500, Shih-Wei Li wrote:
> > > > > 
> > > > > I have only tested the code by invoking test directly using make
> > > > > standalone like the following. I did notice that it took ~90 seconds
> > > > > to finish the test itself.
> > > > > ./"tests/micro-cost"
> > > 
> > > standalone still uses timeout with 90 seconds. So your hardware was just
> > > faster than mine, I guess :-)
> > > 
> > 
> > [indentation confusion?]
> 
> Actually I was just lazily replying to both you and Shih-Wei in the same
> mail.
> 

Ah, well the result had a clash with my OCD.

> > 
> > You're responding to something Shih-Wei wrote here, but I didn't
> > understand Shih-Wei's answer, and I think he ran the work on Seattle, so
> > not sure what the difference was.
> 
> It turns out the problem was just the opposite of what I say above. My
> hardware must be faster. While testing v2 of the patch I still got
> timeouts, so I decided to actually try to figure out what's going on.
> The eoi_test() test is so fast that c1 always equals c2, so we always
> assume an overflow occurred and keep trying to get a better sample.

Ah, I should have read this before responding to the other thread...

> 
> I guess we need two changes to the patch. We need to handle c1 == c2
> differently, probably just assume the measurement is smaller than the
> timer frequency and report 1 tick instead of zero. 

Yeah, things are different when using the generic timer counter instead
of the cycle counter in that sense.

Perhaps we should just have an initial assert of "is this thing on"
which does something that should register a moving count on even a slow
clocked arch counter, and then only check for overflow in the general
case?

> We should also
> have a way out of loop_test() when the test is constantly returning
> zero.
> 

Indeed, seems reasonable.

Thanks,
-Christoffer

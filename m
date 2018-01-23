From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 2/2] arm64: add micro test
Date: Tue, 23 Jan 2018 20:54:59 +0100
Message-ID: <20180123195459.namwgukaj6k2vjeq@kamzik.brq.redhat.com>
References: <1516225596-27071-1-git-send-email-shihwei@cs.columbia.edu>
 <1516225596-27071-3-git-send-email-shihwei@cs.columbia.edu>
 <20180118100958.j4iiq3ep2uruikss@yury-thinkpad>
 <20180118103737.jiwf5ly3up6w7f7r@kamzik.brq.redhat.com>
 <20180118112519.vzkfwkgqavvxqzdn@yury-thinkpad>
 <CAO+sbHHKyYHjGqmS5uM=C6bCnUQ2CbHmmFBTAb=WanQsWdLU2Q@mail.gmail.com>
 <20180122084818.l4tklutdrk45jgrx@kamzik.brq.redhat.com>
 <CAO+sbHFG_KQCOXrnyGtGAef-9HpyPCW_0gkqGNgk_xZ-ni5jJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAO+sbHFG_KQCOXrnyGtGAef-9HpyPCW_0gkqGNgk_xZ-ni5jJQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: Yury Norov <ynorov@caviumnetworks.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <cdall@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 23, 2018 at 01:48:43PM -0500, Shih-Wei Li wrote:
> On Mon, Jan 22, 2018 at 3:48 AM, Andrew Jones <drjones@redhat.com> wrote:
> > On Fri, Jan 19, 2018 at 04:57:55PM -0500, Shih-Wei Li wrote:
> >> Thanks for the feedback about the mistakes in math and some issues in
> >> naming, print msg, and coding style. I'll be careful and try to avoid
> >> the same problems the next patch set. Sorry for all of the confusion.
> >>
> >> So we now skip the test when "sample == 0" happens over 1000 times.
> >> This is only due to the case that "cost is < 1/cntfrq" since it's not
> >
> > Since we know the reason it happens, then why don't we just print that
> > message so the user can know it too?
> 
> Yes, we can print out some info when the counter overflows.

It's not overflow we need to worry about printing as much as when the
sample is consistently zero due to running in less time than 1/cntfrq.

> 
> >
> >> possible for the tick to overflow for that many times. Did I miss
> >> something here? I do agree that we should output better msgs to tell
> >> users that the cost of a certain test is constantly smaller than a
> >> tick.
> >
> > Yes
> >
> >>
> >> Also, because ticks overflow should rarely happen, I wonder if we can
> >> simply ignore the data set if it happens? If not, any thoughts on how
> >> to efficiently distinguish one case from the other?
> >
> > If we get tons of zeros, then the test is faster than 1/cntfrq, print it.
> > If we just get one, possibly two zeros, then it was overflow, skip it.
> 
> Yes.
> 
> >
> >>
> >> Thinking of the time granularity used in the output, given there's
> >> likely difference in hardware implementation as previously mentioned,
> >> should we output the cost in ticks (along with frequency) like I did
> >> in v1 & v2 instead, allowing the users to do the translation to the exact
> >> time based on the output?
> >
> > Why? If it's possible for the user to do the math, then it's possible for
> > the test to do the math. It's easy to do, so why put the burden on the
> > user? People don't think in terms of timer ticks, they think in terms of
> > time.
> >
> 
> I was unsure about the right granularity (microseconds vs picoseconds)
> to use. I can fix the math and output in microseconds in v4 if it
> sounds good to you guys?

Maybe computing in pico and outputting in nano is better for the long
term, but when I last tested your series micro was good enough for the
hardware I have access to.

Thanks,
drew

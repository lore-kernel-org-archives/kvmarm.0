From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [kvm-unit-tests PATCH V2 2/2] arm64: add micro test
Date: Thu, 21 Dec 2017 12:28:37 +0100
Message-ID: <20171221112837.GB29301@cbox>
References: <1513733685-32573-1-git-send-email-shihwei@cs.columbia.edu>
 <1513733685-32573-3-git-send-email-shihwei@cs.columbia.edu>
 <20171220164104.w5lwbtre5x7o5oox@hawk.localdomain>
 <CAO+sbHF1HRA8zc5NiE_Y6oVQpHTcLniUCjK47m82RgGLNKmv-Q@mail.gmail.com>
 <20171221092129.swgvincoq55y6xvy@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171221092129.swgvincoq55y6xvy@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 21, 2017 at 10:21:29AM +0100, Andrew Jones wrote:
> On Wed, Dec 20, 2017 at 04:41:24PM -0500, Shih-Wei Li wrote:
> > On Wed, Dec 20, 2017 at 11:41 AM, Andrew Jones <drjones@redhat.com> wrote:
> > > On Tue, Dec 19, 2017 at 08:34:45PM -0500, Shih-Wei Li wrote:
> > >> +             while (i < iterations) {
> > >> +                     sample = test->test_fn();
> > >> +                     if (sample == 0) {
> > >> +                             /*
> > >> +                              * If something went wrong or we had an
> > >> +                              * overflow, don't count that sample.
> > >> +                              */
> > >> +                             printf("cycle count overflow: %lu\n", sample);
> > >> +                             continue;
> > >
> > > Also mentioned in the other mail, we should change this to something like
> > >
> > >  if (sample == 0) {
> > >      if (failures++ > MAX_FAILURES) {
> > >          printf("%s: Too many cycle count overflows\n", test->name);
> > >          return;
> > >      }
> > >      continue;
> > >  }
> > >
> > > Notice the dropping of the sample parameter (we know it's zero) and
> > > the addition of the test name.
> > >
> > 
> > I think the chance which the timer counter actually overflows ((c1) >
> > (c2)) should be really really rare (mostly due to that (c1) == (c2)),
> > and we can just ignore the case if it happens. So I wonder if we can
> > leave the COUNT macro as the way it is, and change the print info in
> > the code like the following?
> > 
> > if (sample == 0) {
> >    if (failures++ > MAX_FAILURES) {
> >        printf("%s: Too many overflows, the cost is likely smaller than
> > a cycle count\n", test->name);
> >        return;
> >    }
> >    continue;
> > }
> > 
> > Also, what might be a good value for MAX_FAILURES based on your
> > experience? The problem in EOI never happened on the machines I used.
> 
> It's always zero on at least one of the platforms I use. So it won't
> matter what MAX_FAILURES is set to, we'll always hit it. I think
> the chance we overflow and get c1 == c2 is almost nil, so we might as
> well report the sample as either zero or one in that case. But whatever
> fixes the time outs is fine by me.
> 

I think the overflow thing should be kept as a sanity check; if we don't
see a reasonable cycle count (either overflow or c1 == c2), just cancel
the test and report to the user that this thing is unreliable and they
should fix their hypervisor.  Thoughts?

> > 
> > >> +                     }
> > >> +                     cycles += sample;
> > >> +                     if (min == 0 || min > sample)
> > >> +                             min = sample;
> > >> +                     if (max < sample)
> > >> +                             max = sample;
> > >> +                     ++i;
> > >> +             }
> > >> +     } while (cycles < goal);
> > >> +     printf("%s:\t avg %lu\t min %llu\t max %llu\n",
> > >> +             test->name, cycles / iterations, min, max);
> > >
> > > Please use %<num><type> format parameters in order to put this
> > > output in columns. Also, I think we should convert the cycle
> > > counts to time (us) using the timer frequency.
> > >
> > 
> > One thing I noticed here is, since in kvm-unit-tests, printf does not
> > currently support floating points, we may lose precision in the output
> > for tests that have smaller cost. For example, in EOI, I saw the min
> > output on seattle became zero since its cost is smaller than 1us.
> > Outputting in nanoseconds might be an option but this then requires
> > type casting floats to unsigned (the timer frequency is around
> > hundreds of MHz in the hardware I tested) just to print the value.
> 
> We shouldn't need floats. Just use nanoseconds for calculations and
> then convert to us.us-fraction manually.
> 
>  ns      = cycles * frq;
>  us      = ns / 1000;
>  us_frac = (ns % 1000) / 100; // one decimal place, use 10 for two
>  printf("%d.d\n", us, us_frac);
> 
> > 
> > I wonder if it's ok to output the timer frequency/counts as we used to
> > have so the users can do the math themselves?
> 
> If you wish. I won't insist on the doing the conversion in the test,
> but it seems easy and helpful enough to do.
> 

I think we're asking for trouble if we output the raw timer counts as
I'm not sure people are aware this can vary across platforms.

What is the argument against scaling the count to a reasonable measure
of time?

Thanks,
-Christoffer

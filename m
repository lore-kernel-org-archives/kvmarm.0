From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH V2 2/2] arm64: add micro test
Date: Thu, 21 Dec 2017 10:21:29 +0100
Message-ID: <20171221092129.swgvincoq55y6xvy@hawk.localdomain>
References: <1513733685-32573-1-git-send-email-shihwei@cs.columbia.edu>
 <1513733685-32573-3-git-send-email-shihwei@cs.columbia.edu>
 <20171220164104.w5lwbtre5x7o5oox@hawk.localdomain>
 <CAO+sbHF1HRA8zc5NiE_Y6oVQpHTcLniUCjK47m82RgGLNKmv-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD91140D25
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Dec 2017 04:17:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jJ6wO5XQoeO5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Dec 2017 04:17:43 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9857840651
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Dec 2017 04:17:43 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAO+sbHF1HRA8zc5NiE_Y6oVQpHTcLniUCjK47m82RgGLNKmv-Q@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 20, 2017 at 04:41:24PM -0500, Shih-Wei Li wrote:
> On Wed, Dec 20, 2017 at 11:41 AM, Andrew Jones <drjones@redhat.com> wrote:
> > On Tue, Dec 19, 2017 at 08:34:45PM -0500, Shih-Wei Li wrote:
> >> +             while (i < iterations) {
> >> +                     sample = test->test_fn();
> >> +                     if (sample == 0) {
> >> +                             /*
> >> +                              * If something went wrong or we had an
> >> +                              * overflow, don't count that sample.
> >> +                              */
> >> +                             printf("cycle count overflow: %lu\n", sample);
> >> +                             continue;
> >
> > Also mentioned in the other mail, we should change this to something like
> >
> >  if (sample == 0) {
> >      if (failures++ > MAX_FAILURES) {
> >          printf("%s: Too many cycle count overflows\n", test->name);
> >          return;
> >      }
> >      continue;
> >  }
> >
> > Notice the dropping of the sample parameter (we know it's zero) and
> > the addition of the test name.
> >
> 
> I think the chance which the timer counter actually overflows ((c1) >
> (c2)) should be really really rare (mostly due to that (c1) == (c2)),
> and we can just ignore the case if it happens. So I wonder if we can
> leave the COUNT macro as the way it is, and change the print info in
> the code like the following?
> 
> if (sample == 0) {
>    if (failures++ > MAX_FAILURES) {
>        printf("%s: Too many overflows, the cost is likely smaller than
> a cycle count\n", test->name);
>        return;
>    }
>    continue;
> }
> 
> Also, what might be a good value for MAX_FAILURES based on your
> experience? The problem in EOI never happened on the machines I used.

It's always zero on at least one of the platforms I use. So it won't
matter what MAX_FAILURES is set to, we'll always hit it. I think
the chance we overflow and get c1 == c2 is almost nil, so we might as
well report the sample as either zero or one in that case. But whatever
fixes the time outs is fine by me.

> 
> >> +                     }
> >> +                     cycles += sample;
> >> +                     if (min == 0 || min > sample)
> >> +                             min = sample;
> >> +                     if (max < sample)
> >> +                             max = sample;
> >> +                     ++i;
> >> +             }
> >> +     } while (cycles < goal);
> >> +     printf("%s:\t avg %lu\t min %llu\t max %llu\n",
> >> +             test->name, cycles / iterations, min, max);
> >
> > Please use %<num><type> format parameters in order to put this
> > output in columns. Also, I think we should convert the cycle
> > counts to time (us) using the timer frequency.
> >
> 
> One thing I noticed here is, since in kvm-unit-tests, printf does not
> currently support floating points, we may lose precision in the output
> for tests that have smaller cost. For example, in EOI, I saw the min
> output on seattle became zero since its cost is smaller than 1us.
> Outputting in nanoseconds might be an option but this then requires
> type casting floats to unsigned (the timer frequency is around
> hundreds of MHz in the hardware I tested) just to print the value.

We shouldn't need floats. Just use nanoseconds for calculations and
then convert to us.us-fraction manually.

 ns      = cycles * frq;
 us      = ns / 1000;
 us_frac = (ns % 1000) / 100; // one decimal place, use 10 for two
 printf("%d.d\n", us, us_frac);

> 
> I wonder if it's ok to output the timer frequency/counts as we used to
> have so the users can do the math themselves?

If you wish. I won't insist on the doing the conversion in the test,
but it seems easy and helpful enough to do.

> >> +# Exit tests
> >> +[micro-test]
> >> +file = micro-test.flat
> >> +smp = 2
> >> +groups = micro-test
> >> +accel = kvm
> >
> > Unless we come up with some expected values and thresholds for
> > these execution times in order to turn the results into PASS/FAIL
> > tests, then I'm still thinking we should probably add it to the
> > nodefault group in order to save time running the regression tests.
> 
> I'm ok with making the micro test as a nodefault if we cannot find a
> generic timeout value that works across the hardware.
>

OK, let's do that for now.

Thanks,
drew

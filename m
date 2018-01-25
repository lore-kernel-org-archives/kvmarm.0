From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: Re: [PATCH v3 2/2] arm64: add micro test
Date: Thu, 25 Jan 2018 08:45:09 -0500
Message-ID: <CAO+sbHGZqtVGkViLcp-LdxrK2Gc5tHrrYsa7PoNP6GJ4L-CvoA@mail.gmail.com>
References: <1516225596-27071-1-git-send-email-shihwei@cs.columbia.edu>
 <1516225596-27071-3-git-send-email-shihwei@cs.columbia.edu>
 <20180118100958.j4iiq3ep2uruikss@yury-thinkpad> <20180118103737.jiwf5ly3up6w7f7r@kamzik.brq.redhat.com>
 <20180118112519.vzkfwkgqavvxqzdn@yury-thinkpad> <CAO+sbHHKyYHjGqmS5uM=C6bCnUQ2CbHmmFBTAb=WanQsWdLU2Q@mail.gmail.com>
 <20180124081755.GO21802@cbox> <20180124083028.pb2zj6caaitscr3v@kamzik.brq.redhat.com>
 <20180124092315.GA18960@cbox> <CAO+sbHF+y6G9TWa+Tit2YPuffibMRZ7KZfBURg6LQqcwxGhxVQ@mail.gmail.com>
 <20180125085247.GQ21802@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180125085247.GQ21802@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, Yury Norov <ynorov@caviumnetworks.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <cdall@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Thu, Jan 25, 2018 at 3:52 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> Hi Shih-Wei,
>
> (Please try to refrain from top-posting on these lists.)
>
> On Wed, Jan 24, 2018 at 09:55:49PM -0500, Shih-Wei Li wrote:
>> Hi Christoffer,
>>
>> In the previous patch, we did the avg and min/max altogether in a
>> single function, in which we can skip the test (and output msg to tell
>> the user about it) if its cost is smaller than 1 cnnfrq for more than
>> X times.
>
> The problem is not just about the cost being smaller than a single tick,
> it's also about granularity.  Even if I get one tick, on some platform
> all that tells me is "this took between 2000 and 4000 cycles".  That's
> not very precise...

Yes, I absolutely agree with you on this :)

>
>>
>> I think we can use two functions, one for "avg" and one for
>> "minx_max_std" as you mentioned if it looks more straightforward. We
>> can first run the avg() and check if the result can be valid, if yes,
>> then we can proceed to do the min_max_std() test; otherwise, we just
>> tell the users that we cannot get valid results from the targeted
>> test. Is this close what you proposed earlier?
>
> I think what we're most commonly interested in is the average cost of an
> operation when it is repeated many times.  I think the best way you can
> achieve a reasonable and accurate measurement of that is using my
> proposal below, where you don't read the counter for every single tiny
> operation, but you average it out over NTIMES.
>
> I think you should focus on doing that first, and getting this clean and
> correct, which should help with some of the concerns about checking for
> overflows etc., which really only applied to the cycle counter and not
> the arch counter.
>
> Then, in a separate follow-up patch, I think it would be helpful to
> introduce the framework that lets you do more fine-grained measurements,
> including min/max/std/mean, which people like me can use when tweaking
> the system to actually use the cycle counter from the PMU instead.  This
> patch would then need to validate the cycle counter reads to some
> degree.
>

Yes.

>>
>> And yes, I can set NTIMES in avg() (and min_max_std()) as a constant
>> value for now.
>>
>
> It should be trivial to add an additional patch in the end that lets the
> user override NTIMES, but again, just introduce it as a separate patch
> if it makes things easier.

Yes, I will first clean up the code and support measuring the
amortized cost using arch counter, then provide support for the
fine-grain measurements and setups for NTIMES in the follow-up
patches.

Thanks,
Shih-Wei

>
> Thanks,
> -Christoffer
>
>>
>> On Wed, Jan 24, 2018 at 4:23 AM, Christoffer Dall
>> <christoffer.dall@linaro.org> wrote:
>> > On Wed, Jan 24, 2018 at 09:30:28AM +0100, Andrew Jones wrote:
>> >> On Wed, Jan 24, 2018 at 09:17:55AM +0100, Christoffer Dall wrote:
>> >> > Hi Shih-Wei,
>> >> >
>> >> > On Fri, Jan 19, 2018 at 04:57:55PM -0500, Shih-Wei Li wrote:
>> >> > > Thanks for the feedback about the mistakes in math and some issues in
>> >> > > naming, print msg, and coding style. I'll be careful and try to avoid
>> >> > > the same problems the next patch set. Sorry for all of the confusion.
>> >> > >
>> >> > > So we now skip the test when "sample == 0" happens over 1000 times.
>> >> > > This is only due to the case that "cost is < 1/cntfrq" since it's not
>> >> > > possible for the tick to overflow for that many times. Did I miss
>> >> > > something here? I do agree that we should output better msgs to tell
>> >> > > users that the cost of a certain test is constantly smaller than a
>> >> > > tick.
>> >> > >
>> >> >
>> >> > I think for things like vmexit counts, it's very likely that all the
>> >> > samples will result in 0 ticks on many systems (fast CPU and slow arch
>> >> > counter; the architecture doesn't give us any guarantees here).  For
>> >> > example, a system with a 2 GHz CPU and a 1 MHz counter will give you a
>> >> > granularity of 2000 cycles for each counter tick, which is not that
>> >> > useful for low-level tuning of KVM.
>> >> >
>> >> > So what I thought we were going to do was:
>> >> >
>> >> > main_test_function()
>> >> > {
>> >> >     long ntimes = NTIMES;
>> >> >     long cost, total_cost;
>> >> >
>> >> >     cnt1 = read_cnt();
>> >> >     do {
>> >> >             run_test();
>> >> >     } while(ntimes--);
>> >> >     cnt2 = read_cnt();
>> >> >
>> >> >     if (verify_sane_counter(cnt1, cnt2))
>> >> >             return;
>> >> >
>> >> >     total_cost = to_nanoseconds(cnt2 - cnt1);
>> >> >     cost = total_cost / NTIMES;
>> >> >     printf("testname: %l (%l)\n", cost, total_cost);
>> >> > }
>> >> >
>> >> > And in that way amortize the potential lack of precision over all the
>> >> > iterations.  Did I miss some prior discussion about why that was a bad
>> >> > idea?
>> >>
>> >> Not that I know of, but I missed the above proposal, which I completely
>> >> agree with.
>> >>
>> >> >
>> >> > It would also be possible to have two functions, one that does the above
>> >> > and one that does a per-run measurement, in case the user wants to know
>> >> > min/max/stddev and is running on a system with sufficient precision.
>> >> > The method could be chosen via an argument.
>> >>
>> >> We should be able to just make NTIMES variable, setting it to one when a
>> >> per-run measurement is desired, right?
>> >
>> > Not quite.  I think you'll get different results from starting up the
>> > whole test suite, doing a single measurement, and then shutting
>> > everything down again, versus a single startup, and then running
>> > everything for 100,000 times, measurig each time, and reporting
>> > min/max/avg/mean/etc.
>> >
>> > We found the latter metrics useful when analyzing things like key/value
>> > store workloads and benchmark results, where individual deviations can
>> > really skew overall results.
>> >
>> >
>> >> Anyway, I'm fine with having set
>> >> to a reasonable value, not variable / no argument, for initial merge.
>> >>
>> >
>> > I'd be absolutely fine with that as well, we can add the additional
>> > functionality in a separate patch, or later on, depending on how much
>> > time Shih-Wei has :)
>> >
>> > Thanks,
>> > -Christoffer
>>

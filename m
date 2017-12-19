From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Tue, 19 Dec 2017 13:00:57 +0100
Message-ID: <20171219120057.hmi7m2qczynhlybd@hawk.localdomain>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
 <20171218191037.wjocr7jbf5ua2duj@hawk.localdomain>
 <CAO+sbHGs9P76NLgzp_t5CbxtHMcsfDkV6xEKUOj08_0U8eNebg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAO+sbHGs9P76NLgzp_t5CbxtHMcsfDkV6xEKUOj08_0U8eNebg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Shih-Wei Li <shihwei@cs.columbia.edu>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 18, 2017 at 04:58:53PM -0500, Shih-Wei Li wrote:
> On Mon, Dec 18, 2017 at 2:10 PM, Andrew Jones <drjones@redhat.com> wrote:
> >> +static void loop_test(struct exit_test *test)
> >> +{
> >> +     unsigned long i, iterations = 32;
> >> +     unsigned long sample, cycles;
> >> +     unsigned long long min = 0, max = 0;
> >> +     const unsigned long long goal = (1ULL << 29);
> >> +
> >> +     do {
> >> +             iterations *= 2;
> >> +             cycles = 0;
> >> +             for (i = 0; i < iterations; i++) {
> >> +                     sample = test->test_fn();
> >> +                     if (sample == 0) {
> >> +                             /*
> >> +                              * If something went wrong or we had an
> >> +                              * overflow, don't count that sample.
> >> +                              */
> >> +                             iterations--;
> >> +                             i--;
> >
> > I'd prefer incrementing a different counter after the sample==0 test /
> > continue, than to decrement both i and iterations.
> 
> I'm not sure about the comment above. Could you please substantiate
> how a new counter should work here?

It doesn't really matter, but how about

 do {
     iterations *= 2;
     cycles = 0;
     i = 0;
     while (i < iterations) {
         sample = test->test_fn();
         if (sample == 0)
             continue;
         cycles += sample;
         ...
         ++i;
     }
 } while (cycles < goal);


> 
> >
> >> +                             debug("cycle count overflow: %lu\n", sample);
> >> +                             continue;
> >> +                     }
> >> +                     cycles += sample;
> >> +                     if (min == 0 || min > sample)
> >> +                             min = sample;
> >> +                     if (max < sample)
> >> +                             max = sample;
> >> +             }
> >> +     } while (cycles < goal);
> >> +     printf("%s:\t avg %lu\t min %llu\t max %llu\n",
> >> +             test->name, cycles / (iterations), min, max);
> >

Thanks,
drew

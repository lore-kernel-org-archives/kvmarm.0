From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFT - PATCH v2 0/2] KVM/arm64: add fp/simd lazy switch support
Date: Tue, 20 Oct 2015 09:21:49 +0200
Message-ID: <20151020072149.GA9457@cbox>
References: <1442964843-11953-1-git-send-email-m.smarduch@samsung.com>
 <20151005154540.GJ9011@cbox> <561BDFE3.5060403@samsung.com>
 <20151018210738.GF7531@cbox> <56256983.2030506@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E6E741049
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 03:18:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jzu6c386p+Po for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Oct 2015 03:18:47 -0400 (EDT)
Received: from mail-lb0-f169.google.com (mail-lb0-f169.google.com
 [209.85.217.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 552B840FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 03:18:47 -0400 (EDT)
Received: by lbcao8 with SMTP id ao8so8274145lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 00:21:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <56256983.2030506@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 19, 2015 at 03:06:59PM -0700, Mario Smarduch wrote:
> 
> 
> On 10/18/2015 2:07 PM, Christoffer Dall wrote:
> > On Mon, Oct 12, 2015 at 09:29:23AM -0700, Mario Smarduch wrote:
> >> Hi Christoffer, Marc -
> >>   I just threw this test your way without any explanation.
> > 
> > I'm confused.  Did you send me something somewhere already?
> Yes in the last patchset
> 
> https://lists.cs.columbia.edu/pipermail/kvmarm/2015-October/016698.html
> 
> I included a simple test I put together.
> 

Sorry, I missed that change in the cover letter.

> > 
> >>
> >> The test loops, does fp arithmetic and checks the truncated result.
> >> It could be a little more dynamic have an initial run to
> >> get the sum to compare against while looping, different fp
> >> hardware may come up with a different sum, but truncation is
> >> to 5'th decimal point.
> >>
> >> The rationale is that if there is any fp/simd corruption
> >> one of these runs should fail. I think most likely scenario
> >> for that is a world switch in midst of fp operation. I've
> >> instrumented (basically add some tracing to vcpu_put()) and
> >> validated vcpu_put gets called thousands of time (for v7,v8)
> >> for an over night test running two guests/host crunching
> >> fp operations.
> >>
> >> Other then that not sure how to really catch any problems
> >> with the patches applied. Obviously this is a huge issues, if this has
> >> any problems. If you or Marc have any other ideas I'd be happy
> >> to enhance the test.
> > 
> > I think it's important to run two VMs at the same time, each with some
> > floating-point work, and then run some floating point on the host at the
> > same time.
> > 
> > You can make that even more interesting by doing 32-bit guests at the
> > same time as well.
> 
> Yes that's the test combination I've been running.

ok, cool, then I trust these patches.

> > 
> > I believe Marc was running Panranoia
> > (http://www.netlib.org/paranoia/paranoia.c) to test the last lazy
> > series.
> 
> I'll try this test and run it for several days, see if anything shows up.
> 

I actually don't know what it does, i.e. if it just uses the FP hardware
or if it actually checks the results produced.

Several days may be unnecessary, but if your machine has nothing else to
do, then why not.

Thanks,
-Christoffer
